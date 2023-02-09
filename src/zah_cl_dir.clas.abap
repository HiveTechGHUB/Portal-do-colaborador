class ZAH_CL_DIR definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  methods GET_COLAB_DIR
    importing
      !IV_ANO type PNPPABRJ
    exporting
      !ET_DIR type ZAH_TT_DIR_RETURN
    changing
      !CT_NUM_EMP type ZAH_TT_NUM_EMP .
protected section.
private section.

  methods GET_EMPLOYEES_BY_YEAR
    importing
      !IV_ANO type PNPPABRJ
    exporting
      !ET_ALL_PERNR type ZAH_TT_NUM_EMP .
  methods CHECK_ACTIVE_EMPLOYEES_BY_YEAR
    importing
      !IV_ANO type PNPPABRJ
    exporting
      !IT_NON_EXISTING_NUM_EMP type ZAH_TT_NUM_EMP
      !IT_NUM_EMP_NOT_ACTIVE type ZAH_TT_NUM_EMP
    changing
      !CT_NUM_EMP type ZAH_TT_NUM_EMP .
  methods GET_COMPANY_AT_YEAR
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
      !IV_ANO type PNPPABRJ
    exporting
      !ET_COMPANY type ZAH_TT_COMPANY .
  methods GET_DIR
    importing
      !IV_NUM_EMP type PERNR_D
      !IV_ANO type PNPPABRJ
      !IV_COMPANY type BUKRS
    exporting
      !ES_DIR type ZAH_S_DIR_RETURN .
ENDCLASS.



CLASS ZAH_CL_DIR IMPLEMENTATION.


  METHOD check_active_employees_by_year.

    DATA: lt_emp           TYPE TABLE OF p0000,
          ls_num_emp       TYPE zah_s_num_emp,
          lv_subrc         TYPE sy-subrc,
          lv_last_day_year TYPE datum.

    CONSTANTS: lc_12_31 TYPE n LENGTH 4 VALUE 1231.

*   obter ultimo dia do ano
    CONCATENATE iv_ano lc_12_31 INTO lv_last_day_year.


    "Se o parametro inicial estiver preenchido
    IF ct_num_emp IS NOT INITIAL.

      "Percorrer o parametro inicial de modo a ler todos os dados introduzidos.
      LOOP AT ct_num_emp INTO ls_num_emp-num_emp.

        "Chamada do RFC "HR_READ_INFOTYPE" para a recolha de dados e verificação do utilizador
        CALL FUNCTION 'HR_READ_INFOTYPE'
          EXPORTING
            pernr     = ls_num_emp-num_emp
            infty     = '0000'
            begda     = lv_last_day_year
            endda     = lv_last_day_year
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


  METHOD get_colab_dir.

    DATA: lt_company TYPE zah_tt_company,
          ls_dir     TYPE zah_s_dir_return.


    IF ct_num_emp IS INITIAL. "se não forem indroduzidos colaboradores

*--------------------------------------------------
*recolhe todos os colaboradores ativos num ano indicado
*--------------------------------------------------

      get_employees_by_year(
        EXPORTING
          iv_ano       = iv_ano    " Ano cálculo folhas de pagamento p/determinação período
        IMPORTING
          et_all_pernr = ct_num_emp    " tabela de importação/exportação do número de colaborador
      ).

    ELSE. "se forem indroduzidos colaboradores

*--------------------------------------------------
*verifica se os colaboradores inseridos estão ativos
*--------------------------------------------------

      check_active_employees_by_year(
        EXPORTING
          iv_ano                  = iv_ano    " Ano cálculo folhas de pagamento p/determinação período
        CHANGING
          ct_num_emp              = ct_num_emp    " tabela de importação/exportação do número de colaborador
      ).

    ENDIF.

*--------------------------------------------------
*   obtem a empresa do colaborador
*--------------------------------------------------

    get_company_at_year(
      EXPORTING
        it_num_emp = ct_num_emp    " tabela de importação/exportação do número de colaborador
        iv_ano     = iv_ano    " Ano cálculo folhas de pagamento p/determinação período
      IMPORTING
        et_company = lt_company    " Tabela para recolher a empresa de cada colaborador
    ).

*--------------------------------------------------
*   Gerar e exportar a Dir
*--------------------------------------------------

    LOOP AT lt_company INTO DATA(ls_company) WHERE company IS NOT INITIAL. "se o colaborador não tiver uma empresa não vai gerar o pdf

      FREE: ls_dir.

      get_dir(
        EXPORTING
          iv_num_emp = ls_company-num_emp     " Nº pessoal
          iv_ano     = iv_ano     " Ano cálculo folhas de pagamento p/determinação período
          iv_company = ls_company-company    " Empresa
        IMPORTING
          es_dir     = ls_dir     " Estrutura para retorno da DIR
      ).

      IF ls_dir IS NOT INITIAL.

        APPEND ls_dir TO et_dir.

      ENDIF.


    ENDLOOP.

  ENDMETHOD.


  METHOD get_company_at_year.

    CONSTANTS: lc_infty_0001 TYPE infty VALUE '0001',
               lc_12_31      TYPE n LENGTH 4 VALUE 1231.

    DATA: lt_infty_0001    TYPE TABLE OF p0001,
          ls_company       TYPE zah_s_company,
          lv_subrc         TYPE sy-subrc,
          lv_last_day_year TYPE datum.


*   obter ultimo dia do ano
    CONCATENATE iv_ano lc_12_31 INTO lv_last_day_year.

    LOOP AT it_num_emp INTO DATA(ls_num_emp).

      FREE: lt_infty_0001, ls_company.

      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          pernr           = ls_num_emp-num_emp
          infty           = lc_infty_0001
          begda           = lv_last_day_year
          endda           = lv_last_day_year
        IMPORTING
          subrc           = lv_subrc
        TABLES
          infty_tab       = lt_infty_0001
        EXCEPTIONS
          infty_not_found = 1
          OTHERS          = 2.

*      CHECK lv_subrc = 0.

      READ TABLE lt_infty_0001 INTO DATA(ls_infty_0001) WITH KEY pernr = ls_num_emp-num_emp.

      ls_company-num_emp = ls_num_emp-num_emp.
      ls_company-company = ls_infty_0001-bukrs.

      APPEND ls_company TO et_company.

      FREE:ls_infty_0001.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_dir.

    DATA: l_pdfoutput    TYPE fpformoutput,
          lv_no_dir_flag TYPE c.

    EXPORT iv_num_emp FROM iv_num_emp TO MEMORY ID 'ZAH_PAYROLL_EXT_TOOL_PERNR'.

*      programa que gera a DIR
    SUBMIT rpciidp0
        WITH pnppernr = iv_num_emp  "nº colaborador
        WITH ccode    = iv_company  "código empresa
        WITH year     = iv_ano  "ano cálculo folhas de pagamento
        WITH p_ess_ex = 'X'
        WITH pchkpdf  = 'X'
        AND RETURN.

*importar o PDF
    IMPORT l_pdfoutput-pdf TO l_pdfoutput-pdf FROM MEMORY ID 'PDFF'.

*importar a constante que indica que o colaborador não tem DIR
    IMPORT lc_no_dir_flag TO lv_no_dir_flag FROM MEMORY ID 'ZAH_PAYROLL_NO_DIR_FLAG'.

*se o colaborador possuir DIR
    IF lv_no_dir_flag IS INITIAL.

      es_dir-num_emp = iv_num_emp.  "adicionar o nº de colaborador á estrutura de retorno

      es_dir-ano = iv_ano.  "adicionar o ano á estrutura de retorno

*converter a XString para base64
      CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
        EXPORTING
          input  = l_pdfoutput-pdf
        IMPORTING
          output = es_dir-pdf.  "adiciona á estrutura de retorno

    ENDIF.

    FREE MEMORY ID: 'ZAH_PAYROLL_NO_DIR_FLAG', 'PDFF'.


  ENDMETHOD.


  METHOD get_employees_by_year.

    CONSTANTS: lc_12_31 TYPE n LENGTH 4 VALUE 1231.

    DATA: lv_last_day_year TYPE datum.

*   obter ultimo dia do ano
    CONCATENATE iv_ano lc_12_31 INTO lv_last_day_year.

    SELECT pernr
      INTO TABLE et_all_pernr
      FROM pa0000
      WHERE begda LE lv_last_day_year
      AND endda GE lv_last_day_year
      AND stat2 EQ '3'"ativo
      ORDER BY pernr ASCENDING.

  ENDMETHOD.
ENDCLASS.
