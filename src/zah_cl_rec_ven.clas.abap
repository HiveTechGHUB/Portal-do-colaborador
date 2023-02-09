class ZAH_CL_REC_VEN definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_ANO_RECIBO type PNPPABRJ
      !IV_MES_RECIBO type PNPPABRP .
  methods GET_COLAB_RECIBO
    exporting
      !ET_RECIBO type ZAH_TT_REC_VENCIMENTO
    changing
      !CT_NUM_EMP type ZAH_TT_NUM_EMP .
protected section.
private section.

  data GV_FIRST_DAY_MONTH type DATUM .
  data GV_LAST_DAY_MONTH type DATUM .

  methods GET_EMPLOYEES_BY_MONTH
    exporting
      !ET_ALL_PERNR type ZAH_TT_NUM_EMP .
  methods CHECK_ACTIVE_EMP_BY_MONTH
    exporting
      !IT_NON_EXISTING_NUM_EMP type ZAH_TT_NUM_EMP
      !IT_NUM_EMP_NOT_ACTIVE type ZAH_TT_NUM_EMP
    changing
      !CT_NUM_EMP type ZAH_TT_NUM_EMP .
  methods GET_PAYROLL_RESULT
    importing
      !IV_NUM_EMP type PERNR_D
    exporting
      !ET_PAY_RESULT type PAY99_RESULT .
  methods GET_RECIBO
    importing
      !IV_NUM_EMP type PERNR_D
      !IS_PAYROLL_RESULTS type PAY99_RESULT
    exporting
      !ES_RECIBO type ZAH_S_REC_VENCIMENTO .
  methods CONVERT_OTF_TO_PDF
    importing
      !IT_OTFDATA type TSFOTF
    exporting
      !EV_PDF_BASE64 type ESH_E_CU_ICON_BASE64 .
  methods GET_PAYMENT_AMOUNT
    exporting
      !EV_MONTANTE_PAGAMETO type MAXBT
      !EV_REMUNERACOES_BRUTAS type MAXBT
      !EV_DEDUCOES type MAXBT
      !EV_BONUS type MAXBT .
ENDCLASS.



CLASS ZAH_CL_REC_VEN IMPLEMENTATION.


  METHOD check_active_emp_by_month.

    DATA: lt_emp     TYPE TABLE OF p0000,
          ls_num_emp TYPE zah_s_num_emp,
          lv_subrc TYPE sy-subrc.

    "Se o parametro inicial estiver preenchido
    IF ct_num_emp IS NOT INITIAL.

      "Percorrer o parametro inicial de modo a ler todos os dados introduzidos.
      LOOP AT ct_num_emp INTO ls_num_emp-num_emp.

        "Chamada do RFC "HR_READ_INFOTYPE" para a recolha de dados e verificação do utilizador
        CALL FUNCTION 'HR_READ_INFOTYPE'
          EXPORTING
            pernr     = ls_num_emp-num_emp
            infty     = '0000'
            begda     = gv_last_day_month
            endda     = gv_last_day_month
          IMPORTING
            subrc     = lv_subrc
          TABLES
            infty_tab = lt_emp.

        "No caso do utilizador não existir
        IF lv_subrc NE 0.

          "Iremos colocar o numero de colaborador para uma tabela
          "de modo a informar o utilizador que este nao existe
          APPEND ls_num_emp-num_emp TO it_non_existing_num_emp.
          SORT it_non_existing_num_emp BY num_emp DESCENDING.

        ENDIF.

      ENDLOOP.

    ENDIF.

    CLEAR ct_num_emp.

    "Se o parametro stat2 não for inicial,
    "iremos verificar se o utilizador está ativo ou não
    LOOP AT lt_emp INTO DATA(ls_emp) WHERE stat2 IS NOT INITIAL.

      "Estando ativo
      IF ls_emp-stat2 EQ '3'.

        APPEND ls_emp-pernr TO ct_num_emp.
        SORT ct_num_emp BY num_emp DESCENDING.

        "Não está ativo
      ELSE.

        APPEND ls_emp-pernr TO it_num_emp_not_active.
        SORT it_num_emp_not_active BY num_emp DESCENDING.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    super->constructor( ).

    CONSTANTS: lc_day_01 TYPE n LENGTH 2 VALUE 01.

*   obter primeiro dia do mês
    CONCATENATE iv_ano_recibo iv_mes_recibo lc_day_01 INTO gv_first_day_month.

*obter ultimo dia do mês
    CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
      EXPORTING
        day_in            = gv_first_day_month
      IMPORTING
        last_day_of_month = gv_last_day_month.


  ENDMETHOD.


  METHOD convert_otf_to_pdf.

    DATA: lv_pdf_xstring TYPE xstring,
          lt_pdf_lines   TYPE tline_t.

    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
      IMPORTING
        bin_file              = lv_pdf_xstring
      TABLES
        otf                   = it_otfdata
        lines                 = lt_pdf_lines
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        err_bad_otf           = 4
        OTHERS                = 5.

    CHECK lv_pdf_xstring IS NOT INITIAL.

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_pdf_xstring
      IMPORTING
        output = ev_pdf_base64.


  ENDMETHOD.


  METHOD get_colab_recibo.

    IF ct_num_emp IS INITIAL. "se não forem indroduzidos colaboradores

*--------------------------------------------------
*recolhe todos os colaboradores ativos num ano indicado
*--------------------------------------------------

      get_employees_by_month(
        IMPORTING
          et_all_pernr = ct_num_emp     " tabela de importação/exportação do número de colaborador
      ).

    ELSE. "se forem indroduzidos colaboradores

*--------------------------------------------------
*verifica se os colaboradores inseridos estão ativos
*--------------------------------------------------

      check_active_emp_by_month(
        CHANGING
          ct_num_emp              = ct_num_emp     " tabela de importação/exportação do número de colaborador
      ).

    ENDIF.


*percorre todos os colaboradores
    LOOP AT ct_num_emp INTO DATA(ls_num_emp).


*--------------------------------------------------
*lê os dados de payroll do colaborador
*--------------------------------------------------

      get_payroll_result(
        EXPORTING
          iv_num_emp    = ls_num_emp-num_emp     " tabela de importação/exportação do número de colaborador
        IMPORTING
          et_pay_result = DATA(ls_pay_result)     " Estrutura p/res.cálculo FlhPgto.: internacional
      ).

      CHECK ls_pay_result IS NOT INITIAL.

*--------------------------------------------------
*obtem o recibo do colaborador
*--------------------------------------------------

      get_recibo(
        EXPORTING
          iv_num_emp         = ls_num_emp-num_emp    " Nº pessoal
          is_payroll_results = ls_pay_result    " Estrutura p/res.cálculo FlhPgto.: internacional
        IMPORTING
          es_recibo          = DATA(ls_recibo)     " Estrutura de retorno do recibo de vencimento
      ).


      IF ls_recibo IS NOT INITIAL.

*       adicionar a estrutura á tabela
        APPEND ls_recibo TO et_recibo.

      ENDIF.

      FREE: ls_pay_result, ls_recibo.

    ENDLOOP.


  ENDMETHOD.


  METHOD get_employees_by_month.

    SELECT pernr
      INTO TABLE et_all_pernr
      FROM pa0000
      WHERE begda LE gv_last_day_month
      AND endda GE gv_last_day_month
      AND stat2 EQ '3'"ativo
      ORDER BY pernr ASCENDING.

  ENDMETHOD.


  METHOD get_payment_amount.

    DATA: lv_fdata       TYPE /1pyxxfo/zhr_payroll_rv.

    IMPORT lv_fdata TO lv_fdata FROM MEMORY ID 'ZAH_VALORES_PAGAMENTO'.

*----------------------------------------------------------------------------
*Remuneração base
*----------------------------------------------------------------------------

    LOOP AT lv_fdata-star_remun_base INTO DATA(ls_remuneracao_base).

      ADD ls_remuneracao_base-pay_amount TO ev_remuneracoes_brutas.

    ENDLOOP.

*----------------------------------------------------------------------------
*Pagamentos Complementares
*----------------------------------------------------------------------------

    LOOP AT lv_fdata-star_remun_compl INTO DATA(ls_remun_compl).

      CHECK ls_remun_compl-wagetype_key-wagetype NE '0116'.

      ADD ls_remun_compl-pay_amount TO ev_bonus.

      ADD ls_remun_compl-pay_amount TO ev_remuneracoes_brutas.

    ENDLOOP.

*----------------------------------------------------------------------------
*Deduções ao liquido (quotas)
*----------------------------------------------------------------------------
    LOOP AT lv_fdata-star_dedu_liq_quotas INTO DATA(ls_dedu_liq_cotas).

      ADD ls_dedu_liq_cotas-pay_amount TO ev_deducoes.

    ENDLOOP.

*----------------------------------------------------------------------------
*Deduções ao liquido
*----------------------------------------------------------------------------

    LOOP AT lv_fdata-star_ded_liquid INTO DATA(ls_ded_liquido).

      IF ls_ded_liquido-wagetype_key-wagetype NE '9105'.
        MULTIPLY ls_ded_liquido-pay_amount BY -1.
      ENDIF.

      ADD ls_ded_liquido-pay_amount TO ev_deducoes.

    ENDLOOP.

*----------------------------------------------------------------------------
*Deduções legais
*----------------------------------------------------------------------------

    LOOP AT lv_fdata-star_ded_legais INTO DATA(ls_ded_legais).

      ADD ls_ded_legais-pay_amount TO ev_deducoes.

    ENDLOOP.

*----------------------------------------------------------------------------
*Clacula montante liquido
*----------------------------------------------------------------------------
    ev_montante_pagameto = ev_remuneracoes_brutas - ev_deducoes.

  ENDMETHOD.


  METHOD get_payroll_result.

    DATA: lt_pay_result TYPE hrpay99_tab_of_results.


    CALL FUNCTION 'HRCM_PAYROLL_RESULTS_GET'
      EXPORTING
        pernr              = iv_num_emp
        begda              = gv_first_day_month
        endda              = gv_last_day_month
      IMPORTING
*       SUBRC              =
*       MOLGA              =
        payroll_result_tab = lt_pay_result.


    READ TABLE lt_pay_result INTO et_pay_result INDEX sy-tabix.


  ENDMETHOD.


  METHOD get_recibo.

    CONSTANTS: lc_molga  TYPE molga VALUE '19',  "Agrupamento de países
               lc_fname  TYPE hrf_name VALUE 'ZHR_PAYROLL_RV',  "Formulários HR:  nome do objeto
               lc_fclass TYPE hrf_class VALUE 'PAYSLIP'.   "Classe de formulário

    DATA: ls_otf_data    TYPE tsfotf,

          lv_pdf_xstring TYPE xstring,

          lr_form_object TYPE REF TO object.

*--------------------------------------------------
*chama o programa para obter o recibo de vencimento
*--------------------------------------------------

    EXPORT iv_num_emp FROM iv_num_emp TO MEMORY ID 'ZAH_PAYROLL_EXT_TOOL_PERNR'.

    SUBMIT h99_hrforms_call   WITH pnpxabkr = is_payroll_results-inter-versc-abkrs  "Área processamento folha pagamento p/determinação período
                              WITH pnppabrp = gv_last_day_month+4(2)  "Período proc.FlhPgto.p/determinação período
                              WITH pnpdispj = gv_last_day_month(4)  "Ano cálculo folhas de pagamento p/determinação período
                              WITH pnppernr-low = iv_num_emp  "nº colaborador
                              WITH pnpabkrs-low = is_payroll_results-inter-versc-abkrs  "Área de processamento da folha de pagamento
                              WITH pnpbegda = gv_first_day_month  "Data de início período de seleção de dados
                              WITH pnpendda = gv_last_day_month   "Data de fim período de seleção de dados
                              WITH p_molga  = lc_molga  "Agrupamento de países
                              WITH p_fclass = lc_fclass   "Classe de formulário
                              WITH p_fname  = lc_fname  "Formulários HR:  nome do objeto
                              AND RETURN.


    IMPORT es_otfdata TO ls_otf_data FROM MEMORY ID 'ZAH_OTF_DATA'.

    FREE MEMORY ID 'ZAH_OTF_DATA'.

    CHECK ls_otf_data IS NOT INITIAL.

*--------------------------------------------------
*converte o otf para base64 e adiciona á estrutura de retorno
*--------------------------------------------------

    convert_otf_to_pdf(
      EXPORTING
        it_otfdata    = ls_otf_data    " Smart Form: tabela OTF
      IMPORTING
        ev_pdf_base64 = es_recibo-recibo    " Símbolo codificado com Base64
    ).

*adiciona o nº de colaborador á estrutura
    es_recibo-num_emp = iv_num_emp.

*adiciona o ano do recibo á estrutura
    es_recibo-ano_recibo = gv_last_day_month(4).

*adiciona o mês do recibo á estrutura
    es_recibo-mes_recibo = gv_last_day_month+4(2).


*--------------------------------------------------
*calcula os montantes de pagamento
*--------------------------------------------------

*testes
    get_payment_amount(
      IMPORTING
        ev_montante_pagameto   = es_recibo-montante_pagamento     " Cálculo das folhas de pagamento: montante
        ev_remuneracoes_brutas = es_recibo-remuneracoes_brutas    " Cálculo das folhas de pagamento: montante
        ev_deducoes            = es_recibo-deducoes     " Cálculo das folhas de pagamento: montante
        ev_bonus               = es_recibo-bonus     " Cálculo das folhas de pagamento: montante
    ).

  ENDMETHOD.
ENDCLASS.
