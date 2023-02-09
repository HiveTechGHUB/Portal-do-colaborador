FUNCTION zah_testes.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IMP_NUM_COL) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     REFERENCE(NUM_COLABS) TYPE  ZAH_TT_NUM_EMP
*"     REFERENCE(NON_EXISTING_COLABS) TYPE  ZAH_TT_NUM_EMP
*"     REFERENCE(NON_ACTIVE_COLABS) TYPE  ZAH_TT_NUM_EMP
*"     REFERENCE(EXP_USER_PROFILES) TYPE  ZAH_TT_USER_PROFILE
*"     REFERENCE(EXP_PA0002) TYPE  ZAH_TT_PA0002
*"----------------------------------------------------------------------

  "&---------------------------------------------------------------------"
  "&                   TESTE 1 - Verificação de PERNR - STAT2 = 3
  "&---------------------------------------------------------------------"
  "& Descrição: Verificar se o PERNR existe, e se é ou não ativo.
  "&---------------------------------------------------------------------"

*
*  DATA: classe  TYPE REF TO zah_cl_portal_col.
*
*  "Criação do objeto com referência a uma classe.
*  CREATE OBJECT classe.
*
*  "Chamada do método para verificar os pernr's (Numeros de colaborador)
*  classe->zah_i_common_methods~get_by_employee(
*    IMPORTING
*      it_non_existing_num_emp = non_existing_colabs    " tabela de importação/exportação do número de colaborador
*      it_num_emp_not_active   = non_active_colabs      " tabela de importação/exportação do número de colaborador
*    CHANGING
*      it_num_emp              = imp_num_col            " tabela de importação/exportação do número de colaborador
*  ).
*
*    "Exposição do conteudo
*    num_colabs = imp_num_col.

  "&---------------------------------------------------------------------"
  "&                TESTE 2 - Prenchimento de Dados
  "&---------------------------------------------------------------------"
  "& Descrição: Preenchimento de dados de utilizadores, utilizando o RFC
  "&  "HR_READ_INFOTYPE" de forma dinâmica.
  "&---------------------------------------------------------------------"

*  DATA: lr_classe TYPE REF TO zah_cl_user_profile,
*        it_colabs TYPE TABLE OF zah_s_num_emp.
*
*  "Criação do objeto com referencia à classe
*  CREATE OBJECT lr_classe.
*
*  "Chamada do método para a leitura
*  lr_classe->read_all_methods(
*    EXPORTING
*        it_num_emp =  imp_num_col
*    IMPORTING
*      exp_perfil_colab = DATA(it_user_profiles)   " Estrutura para o perfil do colaborador
*  ).
*
*  "Parametro de exportação
*  exp_user_profiles = it_user_profiles.

*  cl_demo_output=>display( it_user_profiles ).


  "////=========================================================="
  "///                 TESTE 3 - GET_TABLE_DESCRIPTIONS
  "//Descrição: Recolha das tabelas de descrições
  "/============================================================="

*  DATA: table_name  TYPE string VALUE 'MARA',
*        column_id   TYPE string VALUE 'MATNR',
*        column_name TYPE string VALUE 'MTART',
*        name_value  TYPE string VALUE 'HALB'.
*
*  DATA: results TYPE REF TO data,
*        tablety TYPE string.
*
*  FIELD-SYMBOLS <results> TYPE STANDARD TABLE.
*
*  tablety = table_name && '-' && column_id.
*  CREATE DATA results TYPE TABLE OF (tablety).
*  ASSIGN results->* TO <results>.
*
*
*  DATA: condition TYPE string.
*  condition = column_name && ` = name_value`.
*
*  SELECT (column_id) FROM (table_name)
*    INTO TABLE <results>.
**    WHERE (condition).
*
*   cl_demo_output=>display( <results> ).
*
*  DATA: lr_classe TYPE REF TO zah_cl_user_teste,
*        it_colabs TYPE TABLE OF zah_s_num_emp.
*
*  CREATE OBJECT lr_classe.
*
*  lr_classe->read_all_methods(
*    EXPORTING
*      it_num_emp       = imp_num_col    " tabela de importação/exportação do número de colaborador
*    IMPORTING
*      exp_perfil_colab = exp_user_profiles    " Estrutura para o perfil do colaborador
*  ).


*  DATA: lr_nome  TYPE REF TO <nomedaclasse>,
*        lr_nome2 TYPE REF TO <nomedaclasse>.
*
*  CREATE OBJECT lr_nome.
*  CREATE OBJECT lr_nome2.
*
*  lr_nome = lr_nome2.

  DATA: lt_p0002 TYPE TABLE OF p0002,
        lt_pernr TYPE zah_tt_num_emp.

  IF imp_num_col IS INITIAL.

    SELECT pernr FROM pa0000 WHERE stat2 ='3' AND begda < @sy-datum AND endda > @sy-datum INTO TABLE @imp_num_col.

  ENDIF.

  LOOP AT imp_num_col INTO DATA(wa_num_col).

    CALL FUNCTION 'HR_READ_INFOTYPE'
      EXPORTING
        pernr     = wa_num_col-num_emp
        infty     = '0002'
        begda     = sy-datum
        endda     = sy-datum
      TABLES
        infty_tab = lt_p0002.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDLOOP.

  exp_pa0002 = lt_p0002.
*
*
*  DATA: ls_prelp TYPE prelp,
*        ls_p0001 type p0001.
*
*  cl_hr_pnnnn_type_cast=>prelp_to_pnnnn(
*    EXPORTING
*      prelp = ls_prelp
*    IMPORTING
*      pnnnn = ls_p0001
*  ).
*
*  cl_hr_pnnnn_type_cast=>pnnnn_to_prelp(
*    EXPORTING
*      pnnnn = ls_p0001
*    IMPORTING
*      prelp = ls_prelp
*  ).

ENDFUNCTION.
*
*CLASS cl_teste DEFINITION.
*
*  EVENTS: nome_evento EXPORTING VALUE(ex_variavel) TYPE <type>.
*  CLASS-EVENTS: nome_evento.
*
*ENDCLASS.
*
*CLASS cl_teste IMPLEMENTATION.
*
*  METHOD m.
*
*    RAISE EVENT nome_evento.
*
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS cl_teste2 DEFINITION.
*
*
*ENDCLASS.
*
*CLASS cl_teste2 IMPLEMENTATION.
*
*ENDCLASS.
*
*
**CLASS z_cl_nome_classe DEFINITION.
**
**
**  PUBLIC SECTION.
*    TYPES: text10 TYPE c LENGTH 10.
*
*
*
*    CONSTANTS: constant TYPE <type> VALUE <value>.
*
*  PROTECTED SECTION.
*    DATA: lv_variable1 TYPE <type>,
*          lv_variable2 TYPE <ddic_type>,
*          lv_variable3 LIKE variable1,
*          lv_variable4 TYPE <type> VALUE <value>,
*          lv_variable5 TYPE <type> READ-ONLY,
*          lv_variable6 TYPE REF TO <classname>,
*          lv_variable7 TYPE REF TO <interface>.
*
*ENDCLASS.
*
*CLASS z_cl_exemplo DEFINITION.
*
*  PUBLIC SECTION.
*
*  PRIVATE SECTION.
*
*ENDCLASS.
*
*CLASS z_cl_exemplo IMPLEMENTATION.
*
*
*ENDCLASS.





*Class definir_nome DEFINITION.
*
*
*
*ENDCLASS.
*
*
*Class definir_nome IMPLEMENTATION.
*
*
*
*ENDCLASS.
*
***** definition da classe principal****
*
*  CLASS zcl_demo DEFINITION.
*
*    PUBLIC SECTION.
*
*      DATA : num1 TYPE i.
*
*      METHODS: comparar IMPORTING num2 TYPE i.
*
*      EVENTS: event_compare.
*
*  ENDCLASS.
*
*****definition do manipulador de eventos****
*
*  CLASS zcl_eventhandler DEFINITION.
*
*    PUBLIC SECTION.
*
*      METHODS: handling_compare FOR EVENT event_compare OF zcl_demo.
*
*  ENDCLASS.
*
***** implementação de classe ****
*
*CLASS zcl_demo IMPLEMENTATION.
*
*  METHOD: comparar.
*
*    num1 = num2.
*
*    IF num1 > 10.
*       RAISE EVENT event_compare.
*
*    ENDIF.
*
*  ENDMETHOD.
*
*ENDCLASS.
*
*
*CLASS zcl_eventhandler IMPLEMENTATION.
*
*  METHOD: handling_compare.
*
*    WRITE: 'Evento aciondo... num1 é maior que 10'.
*
*  ENDMETHOD.
*
*ENDCLASS.
*
*START-OF-SELECTION.
*
*****criando objeto de classe****
*
*DATA : object_demo         TYPE REF TO zcl_demo,
*
*****criando objeto handle do evento****
*
*       object_eventhandler type REF to zcl_eventhandler.
*
*create OBJECT object_demo.
*
*CREATE OBJECT object_eventhandler.
*
*SET HANDLER object_eventhandler->handling_compare FOR zcl_demo.
*
*object_demo->compare(2).
