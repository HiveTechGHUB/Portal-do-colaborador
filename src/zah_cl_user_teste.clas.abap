class ZAH_CL_USER_TESTE definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  constants GC_PA0001 type PA0001 value '0001' ##NO_TEXT.
  constants GC_PA0002 type PA0002 value '0002' ##NO_TEXT.
  constants GC_PA0006 type PA0006 value '0006' ##NO_TEXT.
  constants GC_PA0009 type PA0009 value '0009' ##NO_TEXT.
  constants GC_PA0016 type PA0016 value '0016' ##NO_TEXT.
  constants GC_PA0021 type PA0021 value '0021' ##NO_TEXT.
  constants GC_PA0105 type PA0105 value '0105' ##NO_TEXT.
  constants GC_PA0185 type PA0185 value '0185' ##NO_TEXT.
  constants GC_T528T type T528T value 'T528T' ##NO_TEXT.
  constants GC_T513S type T513S value 'T513S' ##NO_TEXT.
  constants GC_T502T type T502T value 'T502T' ##NO_TEXT.
  constants GC_T005T type T005T value 'T005T' ##NO_TEXT.
  constants GC_BNKA type BNKA value 'BNKA' ##NO_TEXT.
  data:
    GT_T528T type TABLE OF T528T .
  data:
    GT_T513S type TABLE OF T513S .
  data:
    GT_T502T type TABLE OF T502T .
  data:
    GT_T005T type TABLE OF T005T .
  data:
    GT_BNKA type TABLE OF BNKA .
  constants GC_LANGUAGE type LANGU value 'P' ##NO_TEXT.

  methods CONSTRUCTOR .
  methods READ_ALL_METHODS
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !EXP_PERFIL_COLAB type ZAH_TT_USER_PROFILE .
protected section.
private section.

  data GT_INFOTYPES type ZAH_TT_INFOTYPE .
  data GT_DESCRIPTION_TABLES type ZAH_TT_DESCRIPTION_TABLES .
  data GT_P0001 type ZAH_TT_PA0001 .
  data GT_P0002 type ZAH_TT_PA0002 .
  data GT_P0006 type ZAH_TT_PA0006 .
  data GT_P0009 type ZAH_TT_PA0009 .
  data GT_P0016 type ZAH_TT_PA0016 .
  data GT_P0021 type ZAH_TT_PA0021 .
  data GT_P0105 type ZAH_TT_PA0105 .
  data GT_P0185 type ZAH_TT_PA0185 .

  methods GET_INFTY_DATA
    importing
      !IMP_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !EXP_PERFIL_COLAB type ZAH_TT_USER_PROFILE .
  methods GET_TABLE_DESCRIPTIONS .
  methods READ_INFTY_0001
    importing
      !IT_NUM_EMP type ZAH_S_NUM_EMP
      value(IT_PA0001) type ref to DATA
    returning
      value(ZAH_S_PERFIL_PA0001) type ZAH_S_PERFIL_PA0001 .
  methods READ_INFTY_0002
    importing
      !IT_NUM_EMP type ZAH_S_NUM_EMP
      value(IT_PA0002) type ref to DATA
    returning
      value(ZAH_S_PERFIL_PA0002) type ZAH_S_PERFIL_PA0002 .
  methods READ_INFTY_0006
    importing
      !IT_NUM_EMP type ZAH_S_NUM_EMP
      value(IT_PA0006) type ref to DATA
    returning
      value(ZAH_S_PERFIL_PA0006) type ZAH_S_PERFIL_PA0006 .
  methods READ_INFTY_0009
    importing
      !IT_NUM_EMP type ZAH_S_NUM_EMP
      value(IT_PA0009) type ref to DATA
    returning
      value(ZAH_S_PERFIL_PA0009) type ZAH_S_PERFIL_PA0009 .
  methods READ_INFTY_0016
    importing
      !IT_NUM_EMP type ZAH_S_NUM_EMP
      value(IT_PA0016) type ref to DATA
    returning
      value(ZAH_S_PERFIL_PA0016) type ZAH_S_PERFIL_PA0016 .
  methods READ_INFTY_0021
    importing
      !IT_NUM_EMP type ZAH_S_NUM_EMP
      value(IT_PA0021) type ref to DATA
    returning
      value(ZAH_S_PERFIL_PA0021) type ZAH_S_PERFIL_PA0021 .
  methods READ_INFTY_0105
    importing
      !IT_NUM_EMP type ZAH_S_NUM_EMP
      value(IT_PA0105) type ref to DATA
    returning
      value(ZAH_S_PERFIL_PA0105) type ZAH_S_PERFIL_PA0105 .
  methods READ_INFTY_0185
    importing
      !IT_NUM_EMP type ZAH_S_NUM_EMP
      value(IT_PA0185) type ref to DATA
    returning
      value(ZAH_S_PERFIL_PA0185) type ZAH_S_PERFIL_PA0185 .
ENDCLASS.



CLASS ZAH_CL_USER_TESTE IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    super->constructor( ).

    "&---------------------------------------------------------------------"
    "& Descrição: Declaração de variáveis e constantes
    "&---------------------------------------------------------------------"
    DATA: wa_where_clause_t528t TYPE zah_s_description_tables,
          wa_where_clause_t513s TYPE zah_s_description_tables,
          wa_where_clause_t502t TYPE zah_s_description_tables,
          wa_where_clause_t005t TYPE zah_s_description_tables,
          wa_where_clause_bnka  TYPE zah_s_description_tables.

    CONSTANTS: lc_sprsl type char12 value 'SPRSL =',
               lc_spras type char12 value 'SPRAS ='.

    "&---------------------------------------------------------------------"
    "& Descrição: Utilizar as estruturas anteriormente criadas e dar append
    "& das mesmas a uma tabela global. Estas estruturas contêm o nome da
    "& tabela e a clausula where da mesma.
    "&---------------------------------------------------------------------"

    wa_where_clause_t528t-nome_tabela = gc_t528t.
    wa_where_clause_t528t-where_clause = lc_sprsl && '`' && gc_language && '`'.

    wa_where_clause_t513s-nome_tabela = gc_t513s.
    wa_where_clause_t513s-where_clause = lc_sprsl && '`' && gc_language && '`'.

    wa_where_clause_t502t-nome_tabela = gc_t502t.
    wa_where_clause_t502t-where_clause = lc_sprsl && '`' && gc_language && '`'.

    wa_where_clause_t005t-nome_tabela = gc_t005t.
    wa_where_clause_t005t-where_clause = lc_spras && '`' && gc_language && '`'.

    wa_where_clause_bnka-nome_tabela = gc_bnka.
    wa_where_clause_bnka-where_clause = 'BANKS = `PT`'.

    APPEND wa_where_clause_t528t TO gt_description_tables.
    APPEND wa_where_clause_t513s TO gt_description_tables.
    APPEND wa_where_clause_t502t TO gt_description_tables.
    APPEND wa_where_clause_t005t TO gt_description_tables.
    APPEND wa_where_clause_bnka TO gt_description_tables.

    "&---------------------------------------------------------------------"
    "& Descrição: Constantes declaradas a nivel global e adicionadas
    "& a uma tabela global.
    "&---------------------------------------------------------------------"

    APPEND gc_pa0001 TO gt_infotypes.
    APPEND gc_pa0002 TO gt_infotypes.
    APPEND gc_pa0006 TO gt_infotypes.
    APPEND gc_pa0009 TO gt_infotypes.
    APPEND gc_pa0016 TO gt_infotypes.
    APPEND gc_pa0021 TO gt_infotypes.
    APPEND gc_pa0105 TO gt_infotypes.
    APPEND gc_pa0185 TO gt_infotypes.

  ENDMETHOD.


  METHOD get_infty_data.

    "&---------------------------------------------------------------------"
    "& Declaração de variáveis
    "&---------------------------------------------------------------------"
    DATA: lr_tab          TYPE REF TO data,
          it_colabs       TYPE TABLE OF zah_s_num_emp,
          wa_perfil_colab TYPE zah_s_user_profile,
          lr_table        TYPE REF TO data.


    "&---------------------------------------------------------------------"
    "& Declaração de constantes utilizadas no processo.
    "&---------------------------------------------------------------------"
    CONSTANTS: lc_infty_prefix TYPE char3 VALUE 'P',
               lc_table_prefix TYPE char3 VALUE 'GT_'.

    "&---------------------------------------------------------------------"
    "& Declaração de Field-Symbols
    "&---------------------------------------------------------------------"
    FIELD-SYMBOLS: <fs_tab>      TYPE STANDARD TABLE,
                   <fs_at_table> TYPE ANY TABLE,
                   <fs_any>      TYPE any.

    "////=========================================================="
    "///                 Método - GET_ALL_EMPLOYEE
    "//Descrição: Recolha dos PERNR ativos à data.
    "/============================================================="

    "Se o processo anterior der resultados.
    IF sy-subrc EQ 0.

      "Iremos percorrer a tabela global de infotypes e passar para
      "uma work area para que seja possibilitada a leitura dos mesmos
      LOOP AT imp_num_emp INTO DATA(wa_num_emp).


        FIELD-SYMBOLS: <lf_name> TYPE string.

        CHECK sy-subrc EQ 0.

        LOOP AT gt_infotypes INTO DATA(wa_infotypes).

          "Concatenar o prefixo com o numero do infotipo para depois
          "criarmos uma tabela de forma dinâmica deste tipo.
          CONCATENATE lc_infty_prefix wa_infotypes-infotype INTO DATA(lv_infotype).

          "Criação de uma estrutura de maneira dinâmica.
          CREATE DATA lr_tab TYPE TABLE OF (lv_infotype).
          ASSIGN lr_tab->* TO <fs_tab>.

          "Verificação
          CHECK <fs_tab> IS ASSIGNED.


          CALL FUNCTION 'HR_READ_INFOTYPE'
            EXPORTING
              pernr           = wa_num_emp-num_emp
              infty           = wa_infotypes-infotype
              begda           = sy-datum
              endda           = '99991231'
            TABLES
              infty_tab       = <fs_tab>
            EXCEPTIONS
              infty_not_found = 1
              OTHERS          = 2.


          CREATE DATA lr_table LIKE <fs_tab>.
          ASSIGN lr_tab->* TO <fs_any>.

          CASE wa_infotypes-infotype.

            WHEN '0001'.

              FREE: wa_perfil_colab.

              DATA(ls_infty0001) = read_infty_0001(
                   it_num_emp          = wa_num_emp
                   it_pa0001           = lr_tab
               ).

            WHEN '0002'.

              DATA(ls_infty0002) = read_infty_0002(
                  it_num_emp          = wa_num_emp
                  it_pa0002           = lr_tab
              ).

            WHEN '0006'.

              DATA(ls_infty0006) = read_infty_0006(
                  it_num_emp          = wa_num_emp
                  it_pa0006           = lr_tab
              ).

            WHEN '0009'.

              DATA(ls_infty0009) = read_infty_0009(
                  it_num_emp          = wa_num_emp
                  it_pa0009           = lr_tab
              ).

            WHEN '0016'.

              DATA(ls_infty0016) = read_infty_0016(
                  it_num_emp          = wa_num_emp
                  it_pa0016           = lr_tab
              ).

            WHEN '0021'.

              DATA(ls_infty0021) = read_infty_0021(
                  it_num_emp          = wa_num_emp
                  it_pa0021           = lr_tab
              ).

            WHEN '0105'.

              DATA(ls_infty0105) = read_infty_0105(
                  it_num_emp          = wa_num_emp
                  it_pa0105           = lr_tab
              ).

            WHEN '0185'.

              DATA(ls_infty0185) = read_infty_0185(
                  it_num_emp          = wa_num_emp
                  it_pa0185           = lr_tab
              ).

          ENDCASE.

        ENDLOOP.

        wa_perfil_colab-num_colaborador = wa_num_emp-num_emp.
        MOVE-CORRESPONDING ls_infty0001 TO wa_perfil_colab.
        MOVE-CORRESPONDING ls_infty0002 TO wa_perfil_colab.
        MOVE-CORRESPONDING ls_infty0006 TO wa_perfil_colab.
        MOVE-CORRESPONDING ls_infty0009 TO wa_perfil_colab.
        MOVE-CORRESPONDING ls_infty0016 TO wa_perfil_colab.
        MOVE-CORRESPONDING ls_infty0021 TO wa_perfil_colab.
        MOVE-CORRESPONDING ls_infty0105 TO wa_perfil_colab.
        MOVE-CORRESPONDING ls_infty0185 TO wa_perfil_colab.

        APPEND wa_perfil_colab TO exp_perfil_colab.

        UNASSIGN <fs_tab>.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD GET_TABLE_DESCRIPTIONS.

    "&---------------------------------------------------------------------"
    "& Descrição: Declaração de variáveis e constantes.
    "&            Field-Symbol para a recolha dos dados das tabelas.
    "&---------------------------------------------------------------------"

    DATA: lr_tab    TYPE REF TO data.

    CONSTANTS: lc_table_prefix TYPE char3 VALUE 'GT_'.

    FIELD-SYMBOLS: <fs_table>    TYPE STANDARD TABLE,
                   <fs_at_table> TYPE ANY TABLE.

    "/////=========================================================="
    "////                LOOP - GT_DESCRIPTION_TABLES
    "///Descrição: Iremos fazer um loop a uma tabela global onde estão inseridos
    "//os nomes das tabelas e as clausulas where para as recolhas das mesmas.
    "/============================================================="

    LOOP AT gt_description_tables INTO DATA(wa_tables).

      CONCATENATE lc_table_prefix wa_tables-nome_tabela INTO DATA(tab_name). "Concatenação para formular o nome da tabela global.

      "&---------------------------------------------------------------------"
      "& Descrição: Criação de uma tabela de maneira dinâmica
      "&---------------------------------------------------------------------"
      CREATE DATA lr_tab TYPE TABLE OF (wa_tables-nome_tabela).
      ASSIGN lr_tab->* TO <fs_table>.

      CHECK <fs_table> IS ASSIGNED. "Validação

      "&---------------------------------------------------------------------"
      "& Descrição: Select dinâmico utilizado para a recolha de dados.
      "&---------------------------------------------------------------------"
      SELECT *
         FROM (wa_tables-nome_tabela)
         INTO TABLE <fs_table>
        WHERE (wa_tables-where_clause).

      "////=========================================================="
      "///                   Inserir dados
      "//Descrição:utilizado para a inserção dos dados nas respetivas tabelas.
      "/============================================================="

      ASSIGN (tab_name) TO <fs_at_table>.

      IF <fs_at_table> IS ASSIGNED.
        <fs_at_table> = <fs_table>.
      ENDIF.

      UNASSIGN <fs_at_table>.
      UNASSIGN <fs_table>.

    ENDLOOP.

  ENDMETHOD.


  METHOD READ_ALL_METHODS.

    DATA: wa_perfil_colab TYPE zah_s_user_profile.

    "////=========================================================="
    "///                 Método - Validade_num_emp
    "//Descrição: Validar os numeros de colaborador (Pernr)
    "/============================================================="

    zah_i_common_methods~validate_num_emp(
      EXPORTING
        it_num_emp           = it_num_emp     " tabela dos números de colaborador
      IMPORTING
        et_num_emp_validated = DATA(lt_num_emp)     " tabela número de colaborador validado.
    ).

    "////=========================================================="
    "///                Método -  get_table_descriptions
    "//Descrição: Recolha das tabelas de descrições para tabelas globais.
    "/============================================================="

    get_table_descriptions( ).

    "/////=========================================================="
    "////                 Método - get_infty_data
    "///Descrição: Recolha dos dados dos infotipos perante os numeros
    "// de colaborador, alocando os mesmo no parametro de exportação.
    "/=============================================================="

    get_infty_data(
      EXPORTING
        imp_num_emp      = lt_num_emp    " Estrutura de importação/exportação do número de colaborador
      IMPORTING
        exp_perfil_colab = exp_perfil_colab    " Tipo tabela com a estrutura do perfil de colaborador
    ).

  ENDMETHOD.


  METHOD read_infty_0001.

    "Variavel utilizada na recolha do id do gerente.
    DATA: lt_result TYPE TABLE OF swhactor,
          lr_pa0001 TYPE REF TO data,
          lt_pa0001 TYPE TABLE OF p0001.

    CONSTANTS: lc_plvar_value TYPE plog-plvar VALUE '01',
               lc_otype_value TYPE plog-otype VALUE 'S'.

    FIELD-SYMBOLS <ls_data> TYPE data.

    ASSIGN it_pa0001->* TO <ls_data>. "dereference into field symbol



    MOVE-CORRESPONDING <ls_data> TO lt_pa0001.
    READ TABLE lt_pa0001 INTO DATA(wa_pa0001) WITH KEY pernr = it_num_emp.
    zah_s_perfil_pa0001-id_organizacional = wa_pa0001-orgeh.


    ""T528T
    IF wa_pa0001-plans is not INITIAL.

*    SELECT SINGLE plstx FROM t528t WHERE plans = @wa_pa0001-plans INTO @DATA(lv_plstx).
*    zah_s_perfil_pa0001-posicao = lv_plstx.


    READ TABLE gt_t528t INTO DATA(wa_t528t) WITH KEY plans = wa_pa0001-plans.
    zah_s_perfil_pa0001-posicao = wa_t528t-plstx.

    ENDIF.


    ""T513S
    IF wa_pa0001-stell IS NOT INITIAL.
*
*      SELECT SINGLE stltx FROM t513s WHERE stell = @wa_pa0001-stell INTO @DATA(lv_stltx).
*      zah_s_perfil_pa0001-cargo = lv_stltx.

    READ TABLE gt_t513s INTO DATA(wa_t513s) WITH KEY stell = wa_pa0001-stell.
    zah_s_perfil_pa0001-cargo = wa_t513s-stltx.

    ENDIF.



*








*    DATA: lr_table TYPE REF TO data.

*    GET REFERENCE OF it_pa0001 into lt_pa0001.
*    ASSIGN it_pa0001 to

*    <fs_0001> = it_pa0001.
    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"
*    ASSIGN it_pa0001->* TO <fs_0001>.
*    it_pa0001-
*
*    READ TABLE <fs_0001> INTO DATA(wa_pa0001) WITH KEY pernr = it_num_emp.
*    zah_s_perfil_pa0001-id_organizacional = wa_pa0001-orgeh.


*    TRY.
*        zah_s_perfil_pa0001-id_organizacional = gt_p0001[ pernr = it_num_emp ]-orgeh.
*      CATCH cx_sy_itab_line_not_found.
*    ENDTRY.
    "&---------------------------------------------------------------------"
    "& Descrição: Recolha de dados das tabelas descritivas
    "&---------------------------------------------------------------------"

*     SELECT plstx from t528t where plans = wa_pa0001-plans into .

    "T528T
*
*    READ TABLE gt_t528t INTO DATA(wa_t528t) WITH KEY plans = wa_pa0001-plans.
*    zah_s_perfil_pa0001-posicao = wa_t528t-plstx.
*
*
*    "T513S
*
*    READ TABLE gt_t513s INTO DATA(wa_t513s) WITH KEY stell = wa_pa0001-stell.
*    zah_s_perfil_pa0001-cargo = wa_t513s-stltx.


*    IF wa_pa0001-plans IS NOT INITIAL.
*
*      CALL FUNCTION 'RH_STRUC_GET'
*        EXPORTING
*          act_otype      = lc_otype_value
*          act_objid      = wa_pa0001-plans
*          act_wegid      = 'A002'
*          act_plvar      = lc_plvar_value
*        TABLES
*          result_tab     = lt_result
*        EXCEPTIONS
*          no_plvar_found = 1
*          no_entry_found = 2
*          OTHERS         = 3.
*      IF sy-subrc <> 0.
**       Implement suitable error handling here
*      ENDIF.

*    ENDIF.

*    zah_s_perfil_pa0001-id_gerente =


  ENDMETHOD.


  METHOD read_infty_0002.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"
    DATA: lt_pa0002 TYPE TABLE OF p0002.

    FIELD-SYMBOLS <ls_data> TYPE data.

    ASSIGN it_pa0002->* TO <ls_data>. "dereference into field symbol

    MOVE-CORRESPONDING <ls_data> TO lt_pa0002.

    READ TABLE lt_pa0002 INTO DATA(wa_pa0002) WITH KEY pernr = it_num_emp.


    zah_s_perfil_pa0002-nome_completo = wa_pa0002-cname.

    CONCATENATE wa_pa0002-gbdat+0(4) '-' wa_pa0002-gbdat+4(2) '-' wa_pa0002-gbdat+6(2) INTO DATA(lv_gbdat).

    zah_s_perfil_pa0002-data_nascimento = wa_pa0002-gbdat.
    zah_s_perfil_pa0002-primeiro_nome = wa_pa0002-vorna.
    zah_s_perfil_pa0002-ultimo_nome = wa_pa0002-nachn.


    "&---------------------------------------------------------------------"
    "& Descrição: Recolha de dados das tabelas descritivas
    "&---------------------------------------------------------------------"

*
*    SELECT SINGLE ftext from t502t where famst = @wa_pa0002-famst aND sprsl = 'P' into @data(lv_ftext).
*    zah_s_perfil_pa0002-estado_civil = lv_ftext.

    read table gt_t502t INTO data(wa_t502t) WITH KEY famst = wa_pa0002-famst sprsl = 'P'.

    zah_s_perfil_pa0002-estado_civil = wa_t502t-ftext.


*    SELECT SINGLE natio from t005t where  land1 = @wa_pa0002-natio and spras = 'P' into @Data(lv_natio).
*    zah_s_perfil_pa0002-nacionalidade = lv_natio.

    READ TABLE gt_t005t INTO DATA(wa_t005t) WITH KEY land1 = wa_pa0002-natio spras = 'P'.

    zah_s_perfil_pa0002-nacionalidade = wa_t005t-natio.











*    READ TABLE gt_p0002 INTO DATA(wa_pa0002) WITH KEY pernr = it_num_emp.
*
*    zah_s_perfil_pa0002-nome_completo = wa_pa0002-cname.
*
**    Concatenate wa_pa0002-gbdat+0(4) '-' wa_pa0002-gbdat+4(2) '-' wa_pa0002-gbdat+6(2) into DATA(lv_gbdat).
*
*    zah_s_perfil_pa0002-data_nascimento = wa_pa0002-gbdat.
*    zah_s_perfil_pa0002-primeiro_nome = wa_pa0002-vorna.
*    zah_s_perfil_pa0002-ultimo_nome = wa_pa0002-nachn.
*
*    "&---------------------------------------------------------------------"
*    "& Descrição: Recolha de dados das tabelas descritivas
*    "&---------------------------------------------------------------------"
*
*    READ TABLE gt_t502t INTO DATA(wa_t502t) WITH KEY famst = wa_pa0002-famst sprsl = 'P'.
*
*    zah_s_perfil_pa0002-estado_civil = wa_t502t-ftext.
*
*    READ TABLE gt_t005t INTO DATA(wa_t005t) WITH KEY land1 = wa_pa0002-natio spras = 'P'.
*
*    zah_s_perfil_pa0002-nacionalidade = wa_t005t-natio.

  ENDMETHOD.


  METHOD read_infty_0006.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"
    FREE: zah_s_perfil_pa0006.


    DATA: lt_pa0006 TYPE TABLE OF p0006.

    FIELD-SYMBOLS <ls_data> TYPE data.

    ASSIGN it_pa0006->* TO <ls_data>. "dereference into field symbol

    MOVE-CORRESPONDING <ls_data> TO lt_pa0006.

    READ TABLE lt_pa0006 INTO DATA(wa_pa0006) WITH KEY pernr = it_num_emp.

    zah_s_perfil_pa0006-nr_telemovel = wa_pa0006-telnr.
    zah_s_perfil_pa0006-cod_postal = wa_pa0006-pstlz.
    zah_s_perfil_pa0006-cidade = wa_pa0006-ort01.

    IF wa_pa0006-locat IS NOT INITIAL.

      CONCATENATE wa_pa0006-stras ', ' wa_pa0006-locat INTO DATA(lv_morada).

      zah_s_perfil_pa0006-morada = lv_morada.

    ELSE.

      zah_s_perfil_pa0006-morada = wa_pa0006-stras.

    ENDIF.



*    READ TABLE gt_p0006 INTO DATA(wa_pa0006) WITH KEY pernr = it_num_emp.
*
*    zah_s_perfil_pa0006-nr_telemovel = wa_pa0006-telnr.
*    zah_s_perfil_pa0006-cod_postal = wa_pa0006-pstlz.
*    zah_s_perfil_pa0006-cidade = wa_pa0006-ort01.
*
*    IF wa_pa0006-locat IS NOT INITIAL.
*
*      CONCATENATE wa_pa0006-stras ', ' wa_pa0006-locat INTO DATA(lv_morada).
*
*      zah_s_perfil_pa0006-morada = lv_morada.
*
*    ELSE.
*
*      zah_s_perfil_pa0006-morada = wa_pa0006-stras.
*
*    ENDIF.



  ENDMETHOD.


  METHOD read_infty_0009.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    DATA: lt_pa0009 TYPE TABLE OF p0009.

    FIELD-SYMBOLS <ls_data> TYPE data.

    ASSIGN it_pa0009->* TO <ls_data>. "dereference into field symbol

    MOVE-CORRESPONDING <ls_data> TO lt_pa0009.

    READ TABLE lt_pa0009 INTO DATA(wa_pa0009) WITH KEY pernr = it_num_emp.


    zah_s_perfil_pa0009-recetor = wa_pa0009-emftx.
    zah_s_perfil_pa0009-iban = wa_pa0009-iban.
    zah_s_perfil_pa0009-nr_conta_bancaria = wa_pa0009-bankn.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha de dados das tabelas descritivas
    "&---------------------------------------------------------------------"

*    SELECT SINGLE banka FROM bnka WHERE bankl = @wa_pa0009-bankl INTO @DATA(lv_banka).
*    zah_s_perfil_pa0009-banco = lv_banka.

    READ TABLE gt_bnka INTO DATA(wa_bnka) WITH KEY bankl = wa_pa0009-bankl.
    zah_s_perfil_pa0009-banco = wa_bnka-banka.



*
*    READ TABLE gt_p0009 INTO DATA(wa_pa0009) WITH KEY pernr = it_num_emp.
*
*    zah_s_perfil_pa0009-recetor = wa_pa0009-emftx.
*    zah_s_perfil_pa0009-iban = wa_pa0009-iban.
*    zah_s_perfil_pa0009-nr_conta_bancaria = wa_pa0009-bankn.
*
*
*    "&---------------------------------------------------------------------"
*    "& Descrição: Recolha de dados das tabelas descritivas
*    "&---------------------------------------------------------------------"
*
*    READ TABLE gt_bnka INTO DATA(wa_bnka) WITH KEY bankl = wa_pa0009-bankl.
*    zah_s_perfil_pa0009-banco = wa_bnka-banka.

  ENDMETHOD.


  METHOD READ_INFTY_0016.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    DATA: lt_pa0016 TYPE TABLE OF p0016.

    FIELD-SYMBOLS <ls_data> TYPE data.

    ASSIGN it_pa0016->* TO <ls_data>. "dereference into field symbol

    MOVE-CORRESPONDING <ls_data> TO lt_pa0016.

    READ TABLE lt_pa0016 INTO DATA(wa_pa0016) WITH KEY pernr = it_num_emp.

    zah_s_perfil_pa0016-inicio_contrato = wa_pa0016-begda.
    zah_s_perfil_pa0016-duracao_contrato = wa_pa0016-ctedt - wa_pa0016-begda.

*
*    READ TABLE gt_p0016 INTO DATA(wa_pa0016) WITH KEY pernr = it_num_emp.
*
*    zah_s_perfil_pa0016-inicio_contrato = wa_pa0016-begda.
*    zah_s_perfil_pa0016-duracao_contrato = wa_pa0016-ctedt - wa_pa0016-begda.

  ENDMETHOD.


  METHOD read_infty_0021.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    DATA: lt_pa0021 TYPE TABLE OF p0021.

    FIELD-SYMBOLS <ls_data> TYPE data.

    ASSIGN it_pa0021->* TO <ls_data>. "dereference into field symbol

    MOVE-CORRESPONDING <ls_data> TO lt_pa0021.

    READ TABLE lt_pa0021 INTO DATA(wa_pa0021) WITH KEY pernr = it_num_emp subty = '7'.

    zah_s_perfil_pa0021-nr_emergencia = wa_pa0021-zztelefone.

*    READ TABLE gt_p0021 INTO DATA(wa_pa0021) WITH KEY pernr = it_num_emp subty = '7'.

*    zah_s_perfil_pa0021-nr_emergencia = wa_pa0021-zztelefone.

  ENDMETHOD.


  METHOD READ_INFTY_0105.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    DATA: lt_pa0105 TYPE TABLE OF p0105.

    FIELD-SYMBOLS <lt_data> TYPE data.

    ASSIGN it_pa0105->* TO <lt_data>. "dereference into field symbol

*    MOVE-CORRESPONDING <lt_data> TO lt_pa0105.

    lt_pa0105 = <lt_data>.
*    BREAK-POINT.

    READ TABLE lt_pa0105 INTO DATA(wa_pa0105) WITH KEY pernr = it_num_emp.

    zah_s_perfil_pa0105-email = wa_pa0105-usrid_long.
*
*    READ TABLE gt_p0105 INTO DATA(wa_pa0105) WITH KEY pernr = it_num_emp subty = '0010'.
*
*    zah_s_perfil_pa0105-email = wa_pa0105-usrid_long.

  ENDMETHOD.


  METHOD read_infty_0185.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    READ TABLE gt_p0185 INTO DATA(wa_pa0185) WITH KEY pernr = it_num_emp subty = '06'.

    zah_s_perfil_pa0185-cartao_cidadao = wa_pa0185-icnum.

    READ TABLE gt_p0185 INTO wa_pa0185 WITH KEY pernr = it_num_emp subty = '01'.

    zah_s_perfil_pa0185-bilhete_identidade = wa_pa0185-icnum.

  ENDMETHOD.
ENDCLASS.
