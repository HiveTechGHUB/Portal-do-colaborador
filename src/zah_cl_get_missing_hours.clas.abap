class ZAH_CL_GET_MISSING_HOURS definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  interfaces ZAH_I_DIFFERENT_METHODS .

  methods GET_MISSING_HOURS
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_MISSING_HOURS type ZAH_TT_MISSING_HOURS .
  methods GET_THEORIC_HOURS
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_THEORIC_HOURS type ZAH_TT_THEORIC_HOURS .
  methods GET_DAYS_MISSING_HOURS
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_DAYS_MISSING_HOURS type ZAH_TT_DAYS_MISSING_HOURS .
  methods GET_RECORDED_HOURS
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_RECORDED_HOURS type ZAH_TT_RECORDED_HOURS .
protected section.
private section.

  methods GET_INFO_HOURS
    importing
      !IT_COMP_EMPS type ZAH_TT_COMPANY
      !IV_FIRST_DATE type SY-DATUM
      !IV_LAST_DATE type SY-DATUM
    exporting
      !ET_INFO_CATS type ZAH_TT_INFO_CATSDB .
ENDCLASS.



CLASS ZAH_CL_GET_MISSING_HOURS IMPLEMENTATION.


  METHOD get_days_missing_hours.

    DATA: lv_first_date         TYPE datum,
          lt_util_days          TYPE TABLE OF rke_dat,
          ls_calendar           TYPE zah_s_calendar,
          ls_info_cats          TYPE zah_s_info_catsdb,
          lv_sum_daily_hours    TYPE catshours,
          ls_days_missing_hours TYPE zah_s_days_missing_hours.

    "metodo validar os numeros do colaborador importados
    "casa nao sejam importados nenhum o metodo retorna todos os colaboradores ativos
    zah_i_common_methods~validate_num_emp(
    EXPORTING
      it_num_emp           =  it_num_emp   " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_num_emp_validated =  DATA(lt_num_emps)   " tabela de importação/exportação do número de colaborador
  ).

    "recolhe codigo da empresa de cada colaborador
    zah_i_common_methods~get_company(
      EXPORTING
        it_num_emp = lt_num_emps    " tabela de importação/exportação do número de colaborador
      IMPORTING
        et_company = DATA(lt_comp_emp)    " Tabela para recolher a empresa de cada colaborador
    ).

    "recolhe calendarios fatoriais de cada colaborador
    zah_i_different_methods~get_calendar(
      EXPORTING
        it_comp_emps = lt_comp_emp     " Tabela para recolher a empresa de cada colaborador
      IMPORTING
        et_calendar =  DATA(lt_calendar_emps)   " tabela importação/exportaçao calendario dos colaboradores
    ).
    "recolhe horas teoricas dos colaboradores diarias
    get_theoric_hours(
      EXPORTING
        it_num_emp       =   lt_num_emps  " Nº pessoal
      IMPORTING
        et_theoric_hours =  DATA(lt_theoric_hours)   " Horas
    ).


    "recolhe primeiro dia do mes corrente
    CALL FUNCTION 'OIL_MONTH_GET_FIRST_LAST'
      EXPORTING
        i_date      = sy-datum
      IMPORTING
        e_first_day = lv_first_date.


    "recolhe horas que faltam marcar de sempre
    get_info_hours(
      EXPORTING
        it_comp_emps  = lt_comp_emp     " Tabela para recolher a empresa de cada colaborador
        iv_first_date = lv_first_date    " Campo do sistema ABAP: código de retorno de instruções ABAP
        iv_last_date  = sy-datum    " Campo do sistema ABAP: código de retorno de instruções ABAP
      IMPORTING
        et_info_cats  = DATA(lt_info_cats)    " tabela recolher informaçao da tabela CATSDB (horas)
    ).
    "loop à tabela de horas teoricas
    LOOP AT lt_theoric_hours INTO DATA(ls_theoric_hours).

      FREE: ls_calendar,
      ls_info_cats,
      ls_days_missing_hours.

      "recolhe o calendario do colaborador
      READ TABLE lt_calendar_emps INTO ls_calendar WITH KEY num_col = ls_theoric_hours-num_col.
      "se correr bem
      IF sy-subrc EQ 0.
        "recolhe a lista de dias uteis conforme o calendario
        CALL FUNCTION 'RKE_SELECT_FACTDAYS_FOR_PERIOD'
          EXPORTING
            i_datab               = lv_first_date
            i_datbi               = sy-datum
            i_factid              = ls_calendar-calendar
          TABLES
            eth_dats              = lt_util_days
          EXCEPTIONS
            date_conversion_error = 1
            OTHERS                = 2.

        "loop à tabela dos dias uteis
        LOOP AT lt_util_days INTO DATA(ls_util_days).

          CLEAR lv_sum_daily_hours.

          "loop à tabela das horas onde a data é igual ao dia util e o numero do colaborador é igual ao do loop das horas teoricas
          LOOP AT lt_info_cats INTO ls_info_cats WHERE data EQ ls_util_days-periodat AND num_col = ls_theoric_hours-num_col.
            "faz sumatorio das horas
            ADD ls_info_cats-horas TO lv_sum_daily_hours.

          ENDLOOP.
          "se as horas teoricas forem maiores que o sumatorio significa que faltam marcar horas nesse dia
          IF ls_theoric_hours-theoric_hours GT lv_sum_daily_hours.

            DATA(lv_missing_hours) = ls_theoric_hours-theoric_hours - lv_sum_daily_hours.

            ls_days_missing_hours-num_col = ls_theoric_hours-num_col.
            ls_days_missing_hours-dia = ls_util_days-periodat.
            ls_days_missing_hours-horas_falta = lv_missing_hours.
            "adiciona numero do colaborador dia e horas que faltam à tabela de exportação.
            APPEND ls_days_missing_hours TO et_days_missing_hours.

          ENDIF.

        ENDLOOP.

      ENDIF.
    ENDLOOP.
    "ordena a tabela de exportação por ordem crescente no numero de colaborador
    SORT et_days_missing_hours BY num_col ASCENDING.

  ENDMETHOD.


  METHOD get_info_hours.
    CONSTANTS: lc_aproved(2) TYPE c VALUE '30'.

    "recolhe horas que foram ja confirmadas
    SELECT pernr, catshours, rproj, rkostl, workdate, awart, zactividade, ersda, ernam, laeda, aenam, status
      FROM catsdb
      INTO TABLE @et_info_cats
      FOR ALL ENTRIES IN @it_comp_emps
      WHERE pernr EQ @it_comp_emps-num_emp
        AND workdate LE @iv_last_date
        AND workdate GE @iv_first_date
            AND ( status EQ @lc_aproved
         OR status EQ '10'
         OR status EQ '20' ).

    SORT et_info_cats BY num_col ASCENDING.
  ENDMETHOD.


  METHOD get_missing_hours.
    DATA: "lt_num_emps      TYPE zah_tt_num_emp,

      ls_info_cats     TYPE zah_s_info_catsdb,
      ls_missing_hours TYPE zah_s_missing_hours,
      ls_theoric_hours TYPE zah_s_theoric_hours,

      lv_duration      TYPE i,
      lv_first_date    TYPE sy-datum,
      lv_theoric_hours TYPE catshours,
      lv_sum_hours     TYPE catshours,
      lv_missing_hours TYPE catshours.

     "datas para o modulo de funçao para clacular a duração pois se for de manha ele ainda nao conta o dia de hoje
    data: lv_start_time TYPE sy-uzeit VALUE '150000',
          lv_end_time TYPE sy-uzeit VALUE '150000'.

    "metodo validar os numeros do colaborador importados
    "casa nao sejam importados nenhum o metodo retorna todos os colaboradores ativos
    zah_i_common_methods~validate_num_emp(
    EXPORTING
      it_num_emp           =  it_num_emp   " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_num_emp_validated =  DATA(lt_num_emps)   " tabela de importação/exportação do número de colaborador
  ).

    "recolhe codigo da empresa de cada colaborador
    zah_i_common_methods~get_company(
      EXPORTING
        it_num_emp = lt_num_emps    " tabela de importação/exportação do número de colaborador
      IMPORTING
        et_company = DATA(lt_comp_emp)    " Tabela para recolher a empresa de cada colaborador
    ).

    "recolhe calendarios fatoriais de cada colaborador
    zah_i_different_methods~get_calendar(
      EXPORTING
        it_comp_emps = lt_comp_emp     " Tabela para recolher a empresa de cada colaborador
      IMPORTING
        et_calendar =  DATA(lt_calendar_emps)   " tabela importação/exportaçao calendario dos colaboradores
    ).


    "recolhe horas teoricas dos colaboradores diarias
    get_theoric_hours(
      EXPORTING
        it_num_emp       =  lt_num_emps  " Nº pessoal
      IMPORTING
        et_theoric_hours = DATA(lt_theoric_hours)    " Horas
    ).

*    "recolhe primeiro dia do mes corrente
    CALL FUNCTION 'OIL_MONTH_GET_FIRST_LAST'
      EXPORTING
        i_date      = sy-datum
      IMPORTING
        e_first_day = lv_first_date.

    "recolhe horas que faltam marcar de sempre
    get_info_hours(
      EXPORTING
        it_comp_emps  = lt_comp_emp     " Tabela para recolher a empresa de cada colaborador
        iv_first_date = lv_first_date    " Campo do sistema ABAP: código de retorno de instruções ABAP
        iv_last_date  = sy-datum    " Campo do sistema ABAP: código de retorno de instruções ABAP
      IMPORTING
        et_info_cats  = DATA(lt_info_cats)    " tabela recolher informaçao da tabela CATSDB (horas)
    ).

    LOOP AT lt_calendar_emps INTO DATA(ls_calendar_emp).

      FREE:  ls_info_cats,
      ls_theoric_hours.

      CLEAR: lv_duration,
      lv_theoric_hours,
      lv_sum_hours.

      "calcula dias uteis do primeiro dia do mes ate ao corrente
      CALL FUNCTION 'DURATION_DETERMINE'
        EXPORTING
          factory_calendar = ls_calendar_emp-calendar
        IMPORTING
          duration         = lv_duration
        CHANGING
          start_time = lv_start_time
          end_time = lv_end_time
          start_date       = lv_first_date
          end_date         = sy-datum.

      "le a tabela das horas que o colaborador deve trabalhar por dia conforme o numero do colaborador
      READ TABLE lt_theoric_hours INTO ls_theoric_hours WITH KEY num_col = ls_calendar_emp-num_col.

      "calcula horas teoricas do intervalo de tempo calculado
      lv_theoric_hours = ls_theoric_hours-theoric_hours * lv_duration.


      "soma todas as horas aprovadas recolhidas
      LOOP AT lt_info_cats INTO ls_info_cats WHERE num_col EQ ls_calendar_emp-num_col .

        ADD ls_info_cats-horas TO lv_sum_hours.

      ENDLOOP.
      "cacula horas que faltam marcar
      lv_missing_hours = lv_theoric_hours - lv_sum_hours.

      ls_missing_hours-missing_hours = lv_missing_hours.
      ls_missing_hours-num_col = ls_calendar_emp-num_col.

      "adiciona dados à tabela de exportação
      APPEND ls_missing_hours TO et_missing_hours.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_recorded_hours.

    CONSTANTS: lc_first_date            TYPE sy-datum VALUE '19000101',
               lc_last_date             TYPE sy-datum VALUE '99991231',
               lc_domain_cats_status TYPE DOMNAME VALUE 'CATSSTATUS'.

    DATA: lt_status   TYPE TABLE OF dd07v.

    DATA: ls_recorded_hours TYPE zah_s_recorded_hours.


    "metodo validar os numeros do colaborador importados
    "casa nao sejam importados nenhum o metodo retorna todos os colaboradores ativos
    zah_i_common_methods~validate_num_emp(
    EXPORTING
      it_num_emp           =  it_num_emp   " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_num_emp_validated =  DATA(lt_num_emps)   " tabela de importação/exportação do número de colaborador
  ).

    "recolhe codigo da empresa de cada colaborador
    zah_i_common_methods~get_company(
      EXPORTING
        it_num_emp = lt_num_emps    " tabela de importação/exportação do número de colaborador
      IMPORTING
        et_company = DATA(lt_comp_emp)    " Tabela para recolher a empresa de cada colaborador
    ).

    "recolhe horas que faltam marcar de sempre
    get_info_hours(
      EXPORTING
        it_comp_emps  = lt_comp_emp     " Tabela para recolher a empresa de cada colaborador
        iv_first_date = lc_first_date    " Campo do sistema ABAP: código de retorno de instruções ABAP
        iv_last_date  = lc_last_date    " Campo do sistema ABAP: código de retorno de instruções ABAP
      IMPORTING
        et_info_cats  = DATA(lt_info_cats)    " tabela recolher informaçao da tabela CATSDB (horas)
    ).

    "recolhe descriçoes dos status das horas
    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname    = lc_domain_cats_status
      TABLES
        values_tab = lt_status.

    "loop para recolher descriçao do status
    LOOP AT lt_info_cats into DATA(ls_info_cats).

      FREE ls_recorded_hours.

      "passa dados para uma estrutura com os memos campos da tabela de exportaçao
      MOVE-CORRESPONDING ls_info_cats to ls_recorded_hours.


      "recolhe descriçao
      READ TABLE lt_status INTO data(ls_status) WITH KEY domvalue_l = ls_info_cats-status_processamento.
      IF sy-subrc eq 0.

        ls_recorded_hours-status_processamento = ls_status-ddtext.

      ENDIF.

      "adiciona à tabela de exportação
      APPEND ls_recorded_hours to et_recorded_hours.


    ENDLOOP.



  ENDMETHOD.


  METHOD get_theoric_hours.

    DATA: lt_infty_7       TYPE TABLE OF p0007,
          ls_infty_7       TYPE p0007,
          lv_subrc         TYPE sy-subrc,
          ls_theoric_hours TYPE zah_s_theoric_hours.


    CONSTANTS: lc_infty(4) TYPE c VALUE '0007'.

    "recolhe horas previstas de trabalho de cada colaborador

    LOOP AT it_num_emp INTO DATA(ls_num_emp).
      FREE: lt_infty_7.

      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          pernr     = ls_num_emp-num_emp
          infty     = lc_infty
          begda     = sy-datum
          endda     = sy-datum
        IMPORTING
          subrc     = lv_subrc
        TABLES
          infty_tab = lt_infty_7.

      IF lv_subrc EQ 0.

        LOOP AT lt_infty_7 INTO ls_infty_7.

          ls_theoric_hours-num_col = ls_infty_7-pernr.
          ls_theoric_hours-theoric_hours = ls_infty_7-arbst.

          APPEND ls_theoric_hours TO et_theoric_hours.

          FREE ls_infty_7.

        ENDLOOP.
      ENDIF.


    ENDLOOP.



  ENDMETHOD.


   METHOD zah_i_different_methods~get_calendar.

     DATA: lt_bwkey    TYPE ckmh_t_bwkey_bukrs, " Tabela werks (T001W)
           ls_bwkey    TYPE ckmh_bwkey_bukrs, " estrutura werks (T001W)
           lv_fabkl    TYPE fabkl,              " Calendario
           ls_calendar TYPE zah_s_calendar.

     LOOP AT it_comp_emps INTO DATA(ls_comp_emp).

       CLEAR lv_fabkl.
       CLEAR lt_bwkey.
       clear ls_calendar.
       CLEAR ls_bwkey.

       TRY.
         "recolhe o codigo da area de avaliaçao da empresa
           CALL FUNCTION 'CKML_BWKEY_FOR_BUKRS_GET'
             EXPORTING
               i_bukrs   = ls_comp_emp-company
             IMPORTING
               etr_bwkey = lt_bwkey.

         CATCH cx_sy_dyn_call_illegal_type.
       ENDTRY.

       READ TABLE lt_bwkey INDEX 1 INTO ls_bwkey.

       "atraves do codigo da area de avaliaçao recolhe o calendario
       CALL FUNCTION 'CY_READ_T001W'
         EXPORTING
           iwerks = ls_bwkey-bwkey
         IMPORTING
           ekalid = lv_fabkl.

       ls_calendar-num_col = ls_comp_emp-num_emp.
       ls_calendar-calendar = lv_fabkl.

       APPEND ls_calendar TO et_calendar.
     ENDLOOP.
   ENDMETHOD.
ENDCLASS.
