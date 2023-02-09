class ZAH_CL_USER_PROFILE definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  types:
    BEGIN OF g_t528t,
             plans TYPE plans,
             plstx TYPE plstx,
           END OF g_t528t .
  types:
    BEGIN OF g_t513s,
             stell TYPE stell,
             stltx TYPE stltx,
           END OF g_t513s .
  types:
    BEGIN OF g_t502t,
             famst TYPE famst,
             ftext TYPE ftext,
           END OF g_t502t .
  types:
    BEGIN OF g_t005t,
             land1 TYPE land1,
             natio TYPE natio,
           END OF g_t005t .
  types:
    BEGIN OF g_bnka,
             bankl TYPE bankl,
             banka TYPE banka,
           END OF g_bnka .

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
    gt_t528t TYPE TABLE OF g_t528t .
  data:
    gt_t513s TYPE TABLE OF g_t513s .
  data:
    gt_t502t TYPE TABLE OF g_t502t .
  data:
    gt_t005t TYPE TABLE OF g_t005t .
  data:
    gt_bnka TYPE TABLE OF g_bnka .
  constants GC_LANGUAGE type LANGU value 'P' ##NO_TEXT.
  constants GC_T547S type T547S value 'T547S' ##NO_TEXT.
  data GT_T547S type table of T547S .

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
      !IMP_NUM_EMP type ZAH_S_NUM_EMP .
  methods GET_TABLE_DESCRIPTIONS .
  methods READ_INFTY_0001
    returning
      value(ZAH_S_PERFIL_PA0001) type ZAH_S_PERFIL_PA0001 .
  methods READ_INFTY_0002
    returning
      value(ZAH_S_PERFIL_PA0002) type ZAH_S_PERFIL_PA0002 .
  methods READ_INFTY_0006
    returning
      value(ZAH_S_PERFIL_PA0006) type ZAH_S_PERFIL_PA0006 .
  methods READ_INFTY_0009
    returning
      value(ZAH_S_PERFIL_PA0009) type ZAH_S_PERFIL_PA0009 .
  methods READ_INFTY_0016
    returning
      value(ZAH_S_PERFIL_PA0016) type ZAH_S_PERFIL_PA0016 .
  methods READ_INFTY_0021
    returning
      value(ZAH_S_PERFIL_PA0021) type ZAH_S_PERFIL_PA0021 .
  methods READ_INFTY_0105
    returning
      value(ZAH_S_PERFIL_PA0105) type ZAH_S_PERFIL_PA0105 .
  methods READ_INFTY_0185
    returning
      value(ZAH_S_PERFIL_PA0185) type ZAH_S_PERFIL_PA0185 .
ENDCLASS.



CLASS ZAH_CL_USER_PROFILE IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    "&---------------------------------------------------------------------"
    "& Descrição: Declaração de variáveis e constantes
    "&---------------------------------------------------------------------"
    DATA: wa_where_clause_t528t TYPE zah_s_description_tables,
          wa_where_clause_t513s TYPE zah_s_description_tables,
          wa_where_clause_t502t TYPE zah_s_description_tables,
          wa_where_clause_t005t TYPE zah_s_description_tables,
          wa_where_clause_bnka  TYPE zah_s_description_tables,
          wa_where_clause_T547S type zah_s_description_tables.

    CONSTANTS: lc_sprsl TYPE char12 VALUE 'SPRSL =',
               lc_spras TYPE char12 VALUE 'SPRAS ='.

    "&---------------------------------------------------------------------"
    "& Descrição: Utilizar as estruturas anteriormente criadas e dar append
    "& das mesmas a uma tabela global. Estas estruturas contêm o nome da
    "& tabela e a clausula where da mesma.
    "&---------------------------------------------------------------------"

    wa_where_clause_t528t-nome_tabela = gc_t528t.
    wa_where_clause_t528t-campos_tabela = 'plans plstx'.
    wa_where_clause_t528t-where_clause = lc_sprsl && '`' && gc_language && '`'.

    wa_where_clause_t513s-nome_tabela = gc_t513s.
    wa_where_clause_t513s-campos_tabela = 'stell stltx'.
    wa_where_clause_t513s-where_clause = lc_sprsl && '`' && gc_language && '`'.

    wa_where_clause_t502t-nome_tabela = gc_t502t.
    wa_where_clause_t502t-campos_tabela = 'famst ftext'.
    wa_where_clause_t502t-where_clause = lc_sprsl && '`' && gc_language && '`'.

    wa_where_clause_t005t-nome_tabela = gc_t005t.
    wa_where_clause_t005t-campos_tabela = 'land1 natio'.
    wa_where_clause_t005t-where_clause = lc_spras && '`' && gc_language && '`'.

    wa_where_clause_bnka-nome_tabela = gc_bnka.
    wa_where_clause_bnka-campos_tabela = 'bankl banka'.
    wa_where_clause_bnka-where_clause = 'BANKS = `PT`'.

    wa_where_clause_T547S-nome_tabela = gc_t547s.
    wa_where_clause_T547S-campos_tabela = 'cttyp cttxt'.
    wa_where_clause_T547S-where_clause = lc_sprsl && '`' && gc_language && '`'.

    APPEND wa_where_clause_t528t TO gt_description_tables.
    APPEND wa_where_clause_t513s TO gt_description_tables.
    APPEND wa_where_clause_t502t TO gt_description_tables.
    APPEND wa_where_clause_t005t TO gt_description_tables.
    APPEND wa_where_clause_bnka TO gt_description_tables.
    APPEND wa_where_clause_t547s to gt_description_tables.

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
    DATA: lr_tab    TYPE REF TO data,
          it_colabs TYPE TABLE OF zah_s_num_emp,
          wa_perfil_colab type zah_s_user_profile.


    "&---------------------------------------------------------------------"
    "& Declaração de constantes utilizadas no processo.
    "&---------------------------------------------------------------------"
    CONSTANTS: lc_infty_prefix TYPE char3 VALUE 'P',
               lc_table_prefix TYPE char3 VALUE 'GT_'.

    "&---------------------------------------------------------------------"
    "& Declaração de Field-Symbols
    "&---------------------------------------------------------------------"
    FIELD-SYMBOLS: <fs_tab>      TYPE STANDARD TABLE,
                   <fs_at_table> TYPE ANY TABLE.

    "////=========================================================="
    "///                 Método - GET_ALL_EMPLOYEE
    "//Descrição: Recolha dos PERNR ativos à data.
    "/============================================================="

    "Se o processo anterior der resultados.
    IF sy-subrc EQ 0.

      "Iremos percorrer a tabela global de infotypes e passar para
      "uma work area para que seja possibilitada a leitura dos mesmos
      LOOP AT gt_infotypes INTO DATA(wa_infotypes).

        "Concatenar o prefixo com o numero do infotipo para depois
        "criarmos uma tabela de forma dinâmica deste tipo.
        CONCATENATE lc_infty_prefix wa_infotypes-infotype INTO DATA(lv_infotype).

        "Criação de uma estrutura de maneira dinâmica.
        CREATE DATA lr_tab TYPE TABLE OF (lv_infotype).
        ASSIGN lr_tab->* TO <fs_tab>.

        "Verificação
        CHECK <fs_tab> IS ASSIGNED.

        "Criação de uma tabela interna dependendo do infotipo
        cl_hr_pnnnn_type_cast=>pnnnn_to_prelp_tab(   " this method accepts a generic infotype structure, making it dynamic
          EXPORTING
            pnnnn_tab = <fs_tab>
          IMPORTING
            prelp_tab = DATA(lv_table)
        ).

        CHECK sy-subrc EQ 0.


*        LOOP AT imp_num_emp INTO DATA(wa_num_emp).

          CALL FUNCTION 'HR_READ_INFOTYPE'
            EXPORTING
              pernr           = imp_num_emp-num_emp
              infty           = wa_infotypes-infotype
              begda           = sy-datum
              endda           = '99991231'
            TABLES
              infty_tab       = lv_table
            EXCEPTIONS
              infty_not_found = 1
              OTHERS          = 2.

*        ENDLOOP.
*
        "Estrutura exata para o respetivo infotipo
        cl_hr_pnnnn_type_cast=>prelp_to_pnnnn_tab(
          EXPORTING
            prelp_tab = lv_table
          IMPORTING
            pnnnn_tab = <fs_tab>
        ).

        CHECK sy-subrc EQ 0.

        "Dependendo do numero do infotipo, irá introduzir na respetiva tabela o seu conteudo.

        CONCATENATE lc_table_prefix lv_infotype INTO DATA(lv_gt_table).
        ASSIGN (lv_gt_table) TO <fs_at_table>.

        IF <fs_at_table> IS ASSIGNED.
          <fs_at_table> = <fs_tab>.
        ENDIF.

        UNASSIGN <fs_at_table>.
        UNASSIGN <fs_tab>.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD get_table_descriptions.

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
*      "&---------------------------------------------------------------------"
*
      SELECT (wa_tables-campos_tabela)
         FROM (wa_tables-nome_tabela)
         INTO CORRESPONDING FIELDS OF TABLE <fs_table>
        WHERE (wa_tables-where_clause).
*
*      SELECT *
*         FROM (wa_tables-nome_tabela)
*         INTO TABLE <fs_table>
*        WHERE (wa_tables-where_clause).

      "////=========================================================="
      "///                   Inserir dados
      "//Descrição:utilizado para a inserção dos dados nas respetivas tabelas.
      "/============================================================="

      ASSIGN (tab_name) TO <fs_at_table>.

      IF <fs_at_table> IS ASSIGNED.
*        <fs_at_table> = <fs_table>.
        MOVE-CORRESPONDING <fs_table> TO <fs_at_table>.
      ENDIF.

      UNASSIGN <fs_at_table>.
      UNASSIGN <fs_table>.

    ENDLOOP.

  ENDMETHOD.


  METHOD read_all_methods.

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
    "// de colaborador, guardando os dados numa tabela global
    "/=============================================================="
    FREE: exp_perfil_colab.

    "Loop nos numeros de colaborador
    LOOP AT lt_num_emp INTO DATA(wa_num_col).

      CLEAR wa_perfil_colab.

      get_infty_data( imp_num_emp = wa_num_col ).

      DATA(ls_infty0001) = read_infty_0001( ). "Leitura dos dados do infotipo 0001

      DATA(ls_infty0002) = read_infty_0002( ). "Leitura dos dados do infotipo 0002

      DATA(ls_infty0006) = read_infty_0006( ). "Leitura dos dados do infotipo 0006

      DATA(ls_infty0009) = read_infty_0009( ). "Leitura dos dados do infotipo 0009

      DATA(ls_infty0016) = read_infty_0016( ). "Leitura dos dados do infotipo 0016

      DATA(ls_infty0021) = read_infty_0021( ). "Leitura dos dados do infotipo 0021

      DATA(ls_infty0105) = read_infty_0105( ). "Leitura dos dados do infotipo 0105

      DATA(ls_infty0185) = read_infty_0185( ). "Leitura dos dados do infotipo 0185

      "&---------------------------------------------------------------------"
      "& Descrição: Mover para os respetivos dados para a estrutura.
      "&---------------------------------------------------------------------"

      wa_perfil_colab-num_colaborador = wa_num_col-num_emp.
      wa_perfil_colab-cargo = ls_infty0001-cargo.
      wa_perfil_colab-id_gerente = ls_infty0001-id_gerente.
      wa_perfil_colab-id_organizacional = ls_infty0001-id_organizacional.
      wa_perfil_colab-posicao = ls_infty0001-posicao.

      wa_perfil_colab-nome_completo = ls_infty0002-nome_completo.
      wa_perfil_colab-primeiro_nome = ls_infty0002-primeiro_nome.
      wa_perfil_colab-ultimo_nome = ls_infty0002-ultimo_nome.
      wa_perfil_colab-data_nascimento = ls_infty0002-data_nascimento.
      wa_perfil_colab-estado_civil = ls_infty0002-estado_civil.
      wa_perfil_colab-nacionalidade = ls_infty0002-nacionalidade.
      wa_perfil_colab-genero = ls_infty0002-genero.

      wa_perfil_colab-nr_telemovel = ls_infty0006-nr_telemovel.
      wa_perfil_colab-morada = ls_infty0006-morada.
      wa_perfil_colab-cidade = ls_infty0006-cidade.
      wa_perfil_colab-cod_postal = ls_infty0006-cod_postal.

      wa_perfil_colab-recetor = ls_infty0009-recetor.
      wa_perfil_colab-banco = ls_infty0009-banco.
      wa_perfil_colab-iban = ls_infty0009-iban.
      wa_perfil_colab-nr_conta_bancaria = ls_infty0009-nr_conta_bancaria.

      wa_perfil_colab-inicio_contrato = ls_infty0016-inicio_contrato.
      wa_perfil_colab-duracao_contrato = ls_infty0016-duracao_contrato.
      wa_perfil_colab-tipo_contrato = ls_infty0016-tipo_contrato.

      wa_perfil_colab-nr_emergencia = ls_infty0021-nr_emergencia.

      wa_perfil_colab-email = ls_infty0105-email.

      wa_perfil_colab-cartao_cidadao = ls_infty0185-cartao_cidadao.
      wa_perfil_colab-bilhete_identidade = ls_infty0185-bilhete_identidade.

*      MOVE-CORRESPONDING ls_infty0001 TO wa_perfil_colab.
*
*      MOVE-CORRESPONDING ls_infty0002 TO wa_perfil_colab.
*
*      MOVE-CORRESPONDING ls_infty0006 TO wa_perfil_colab.
*
*      MOVE-CORRESPONDING ls_infty0009 TO wa_perfil_colab.
*
*      MOVE-CORRESPONDING ls_infty0016 TO wa_perfil_colab.
*
*      MOVE-CORRESPONDING ls_infty0021 TO wa_perfil_colab.
*
*      MOVE-CORRESPONDING ls_infty0105 TO wa_perfil_colab.
*
*      MOVE-CORRESPONDING ls_infty0185 TO wa_perfil_colab.

      APPEND wa_perfil_colab TO exp_perfil_colab. "Colocar a linha do colaborador para o parametro de exp.

    ENDLOOP.

  ENDMETHOD.


  METHOD read_infty_0001.

    "Variavel utilizada na recolha do id do gerente.
    DATA: lt_result      TYPE TABLE OF swhactor.

    CONSTANTS: lc_plvar_value TYPE plog-plvar VALUE '01',
               lc_otype_value TYPE plog-otype VALUE 'S'.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    READ TABLE gt_p0001 INTO DATA(wa_pa0001) INDEX 1.
    zah_s_perfil_pa0001-id_organizacional = wa_pa0001-orgeh.

*    TRY.
*        zah_s_perfil_pa0001-id_organizacional = gt_p0001[ pernr = it_num_emp ]-orgeh.
*      CATCH cx_sy_itab_line_not_found.
*    ENDTRY.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha de dados das tabelas descritivas
    "&---------------------------------------------------------------------"

    "T528T

*    SELECT SINGLE plstx FROM t528t WHERE plans = @wa_pa0001-plans INTO @DATA(lv_plstx).
*    zah_s_perfil_pa0001-posicao = lv_plstx.

    READ TABLE gt_t528t INTO DATA(wa_t528t) WITH KEY plans = wa_pa0001-plans.
    zah_s_perfil_pa0001-posicao = wa_t528t-plstx.

    "T513S
*
*    SELECT SINGLE stltx FROM t513s WHERE stell = @wa_pa0001-stell INTO @DATA(lv_stltx).
*    zah_s_perfil_pa0001-cargo = lv_stltx.

    READ TABLE gt_t513s INTO DATA(wa_t513s) WITH KEY stell = wa_pa0001-stell.
    zah_s_perfil_pa0001-cargo = wa_t513s-stltx.


    IF wa_pa0001-plans IS NOT INITIAL.

      CALL FUNCTION 'RH_STRUC_GET'
        EXPORTING
          act_otype      = lc_otype_value
          act_objid      = wa_pa0001-plans
          act_wegid      = 'A002'
          act_plvar      = lc_plvar_value
        TABLES
          result_tab     = lt_result
        EXCEPTIONS
          no_plvar_found = 1
          no_entry_found = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.

    ENDIF.

    READ TABLE lt_result INDEX 1 INTO DATA(wa_result).
    zah_s_perfil_pa0001-id_gerente = wa_result-objid.


  ENDMETHOD.


  METHOD read_infty_0002.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"



    READ TABLE gt_p0002 INTO DATA(wa_pa0002) INDEX 1.

    zah_s_perfil_pa0002-nome_completo = wa_pa0002-cname.

*    Concatenate wa_pa0002-gbdat+0(4) '-' wa_pa0002-gbdat+4(2) '-' wa_pa0002-gbdat+6(2) into DATA(lv_gbdat).

    zah_s_perfil_pa0002-data_nascimento = wa_pa0002-gbdat.
    zah_s_perfil_pa0002-primeiro_nome = wa_pa0002-vorna.
    zah_s_perfil_pa0002-ultimo_nome = wa_pa0002-nachn.
    zah_s_perfil_pa0002-genero = wa_pa0002-gesch.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha de dados das tabelas descritivas
    "&---------------------------------------------------------------------"
*
*    SELECT SINGLE ftext FROM T502T WHERE famst = @wa_pa0002-famst and sprsl = 'P' into @data(lv_ftext).
*    zah_s_perfil_pa0002-estado_civil = lv_ftext.

    READ TABLE gt_t502t INTO DATA(wa_t502t) WITH KEY famst = wa_pa0002-famst. " sprsl = 'P'.

    zah_s_perfil_pa0002-estado_civil = wa_t502t-ftext.

***
*    SELECT SINGLE natio FROM t005t WHERE land1 = @wa_pa0002-natio and spras = 'P' into @data(lv_natio).
*    zah_s_perfil_pa0002-nacionalidade = lv_natio.


    READ TABLE gt_t005t INTO DATA(wa_t005t) WITH KEY land1 = wa_pa0002-natio." spras = 'P'.

    zah_s_perfil_pa0002-nacionalidade = wa_t005t-natio.



  ENDMETHOD.


  METHOD read_infty_0006.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"
    FREE: zah_s_perfil_pa0006.

    READ TABLE gt_p0006 INTO DATA(wa_pa0006) INDEX 1." WITH KEY pernr = it_num_emp.

    zah_s_perfil_pa0006-nr_telemovel = wa_pa0006-telnr.
    zah_s_perfil_pa0006-cod_postal = wa_pa0006-pstlz.
    zah_s_perfil_pa0006-cidade = wa_pa0006-ort01.

    IF wa_pa0006-locat IS NOT INITIAL.

      CONCATENATE wa_pa0006-stras ', ' wa_pa0006-locat INTO DATA(lv_morada).

      zah_s_perfil_pa0006-morada = lv_morada.

    ELSE.

      zah_s_perfil_pa0006-morada = wa_pa0006-stras.

    ENDIF.



  ENDMETHOD.


  METHOD read_infty_0009.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    READ TABLE gt_p0009 INTO DATA(wa_pa0009) INDEX 1. "WITH KEY pernr = it_num_emp.

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


  ENDMETHOD.


  METHOD read_infty_0016.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    READ TABLE gt_p0016 INTO DATA(wa_pa0016) INDEX 1."WITH KEY pernr = it_num_emp.

    zah_s_perfil_pa0016-inicio_contrato = wa_pa0016-begda.
    zah_s_perfil_pa0016-duracao_contrato = wa_pa0016-ctedt - wa_pa0016-begda.

    READ TABLE gt_t547s INTO DATA(lt_genero) WITH KEY cttyp = wa_pa0016-cttyp.

    zah_s_perfil_pa0016-tipo_contrato = lt_genero-cttxt.

  endmethod.


  METHOD read_infty_0021.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    READ TABLE gt_p0021 INTO DATA(wa_pa0021) WITH key subty = '7'.

    zah_s_perfil_pa0021-nr_emergencia = wa_pa0021-zztelefone.

  ENDMETHOD.


  METHOD read_infty_0105.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    READ TABLE gt_p0105 INTO DATA(wa_pa0105) WITH KEY subty = '0010'.

    zah_s_perfil_pa0105-email = wa_pa0105-usrid_long.

  ENDMETHOD.


  METHOD read_infty_0185.

    "&---------------------------------------------------------------------"
    "& Descrição: Recolha dos dados do respetivo infotipo
    "&---------------------------------------------------------------------"

    READ TABLE gt_p0185 INTO DATA(wa_pa0185) WITH KEY subty = '06'.

    zah_s_perfil_pa0185-cartao_cidadao = wa_pa0185-icnum.

    READ TABLE gt_p0185 INTO wa_pa0185 WITH KEY subty = '01'.

    zah_s_perfil_pa0185-bilhete_identidade = wa_pa0185-icnum.

  ENDMETHOD.
ENDCLASS.
