REPORT zah_teste.

*PARAMETERS: p_tname TYPE tabname.
*
*"Variáveis para o desenvolvimento do teste
*DATA: lr_tab  TYPE REF TO data, "
*      lv_0001 TYPE char6 VALUE 'pa0000',
*      lv_0002 type char6 value 'pa0001'.
*
*  "Field-symbol com o tipo de qualquer tabela
*  FIELD-SYMBOLS: <tab> TYPE ANY TABLE.
*
*"Estrutrura para o teste
*TYPES BEGIN OF tt_infotypes.
*
*  TYPES: num_infotype TYPE c LENGTH 6.
*
*TYPES END OF tt_infotypes.
*
*"criação de uma tabela global
*DATA: gt_infotypes TYPE TABLE OF tt_infotypes.
*
*"Adicionar os valores a percorrer
*APPEND lv_0001 TO gt_infotypes.
*APPEND lv_0002 TO gt_infotypes.
*
*"Percorrer os valores todos
*LOOP AT gt_infotypes INTO DATA(wa_infotypes).
*
*  CREATE DATA lr_tab TYPE TABLE OF (wa_infotypes-num_infotype).
*
*  ASSIGN lr_tab->* TO <tab>.
*
*  IF sy-subrc EQ 0.
*  SELECT * FROM (wa_infotypes-num_infotype) INTO TABLE <tab>.
*    cl_demo_output=>display( <tab> ).
*  ENDIF.
*
*ENDLOOP.

**********************************************************************

*data: lt_teste TYPE TPLIC_RVAL_TAB.
*
*
*CALL FUNCTION 'K_ABC_WORKDAYS_FOR_PERIODS_GET'
*  EXPORTING
*    kokrs             = 'AMT'
*    gjahr             = '1999'
*   CALID             = 'PT'
*    period_from       = '01092022'
*    period_cnt        = sy-datum
*    call_prog         = SY-REPID
*  TABLES
*    rtable_val        = lt_teste
*          .


**********************************************************************
*DATA: lt_calendar TYPE TABLE OF SCSHOLIDAY.
*
*CALL FUNCTION 'HOLIDAY_CALENDAR_GET'
* EXPORTING
*   LANGUAGE                         = SY-LANGU
** IMPORTING
**   RETURN_CODE                      =
*  TABLES
*    holiday_calendar                 = lt_calendar
**   HOLIDAY_CALENDAR_LONG            =
** EXCEPTIONS
**   HOLIDAY_CALENDAR_NOT_FOUND       = 1
**   OTHERS                           = 2
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
**********************************************************************
*****DATA: lt_days TYPE TABLE OF RKE_DAT,
*****      lv_date TYPE P01_RBM_DATUM  .
*****
*****CALL FUNCTION 'RKE_SELECT_FACTDAYS_FOR_PERIOD'
*****  EXPORTING
*****    i_datab                     = '20220901'
*****    i_datbi                     = '20220930'
*****    i_factid                    = 'PT'
*****  TABLES
*****    eth_dats                    = lt_days
***** EXCEPTIONS
*****   DATE_CONVERSION_ERROR       = 1
*****   OTHERS                      = 2
*****          .
*****
*****data: teste TYPE ABDATAB.
*****CALL FUNCTION 'CONVERSION_EXIT_PDATE_INPUT'
*****  EXPORTING
*****    input              = '01092022'
***** IMPORTING
*****   OUTPUT             = teste
***** EXCEPTIONS
*****   INVALID_DATE       = 1
*****   OTHERS             = 2
*****          .
*****IF sy-subrc <> 0.
***** Implement suitable error handling here
*****ENDIF.
*****
*****
*****
*****LOOP AT lt_days INTO data(ls_days).
*****
*****  WRITE ls_days-periodat to lv_date.
*****
*****ENDLOOP.
*****
*****WRITE lv_date.
*****IF sy-subrc <> 0.
***** Implement suitable error handling here
*****ENDIF.

*CLASS zcl_demo DEFINITION.
*
*  PUBLIC SECTION.
*
*    DATA : num1 TYPE i.
*
*    METHODS: compare IMPORTING num2 TYPE i.
*    EVENTS: event_compare.
*
*ENDCLASS.
*
*CLASS zcl_eventhandler DEFINITION.
*
*  PUBLIC SECTION.
*
*    METHODS: handling_compare FOR EVENT event_compare OF zcl_demo.
*
*ENDCLASS.
*
*CLASS zcl_demo IMPLEMENTATION.
*
*  METHOD: compare.
*    num1 = num2.
*
*    IF num1 > 10.
*      RAISE EVENT event_compare.
*    ENDIF.
*
*  ENDMETHOD.
*
*ENDCLASS.
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
*  DATA : object_demo          TYPE REF TO zcl_demo,
*         object_eventhandler1 TYPE REF TO zcl_eventhandler,
*         object_eventhandler2 TYPE REF TO zcl_eventhandler.
*
*  PARAMETERS: num1 TYPE i.
**
**  CREATE OBJECT object_demo.
**
**  CREATE OBJECT object_eventhandler.
**
**  SET HANDLER object_eventhandler->handling_compare FOR object_demo. "configurando o gerenciador
**
**  object_demo->compare( num2 = num1 ).
*
*  CREATE OBJECT: object_demo, object_eventhandler1, object_eventhandler2.
*
*  SET HANDLER object_eventhandler1->handling_compare object_eventhandler2->handling_compare FOR object_demo.
*
*  CALL METHOD object_demo->compare( num2 = num1 ).
*
*
*
*CLASS c1 DEFINITION INHERITING FROM object.
*
*ENDCLASS.
*
*CLASS c1 IMPLEMENTATION.
*
*ENDCLASS.
*
*
*
*
*INTERFACE b1.
*
*  DATA: lv_variable_name TYPE i.
*  METHODS: method_name.
*  EVENTS: event_name.
*
*ENDINTERFACE.
*
*CLASS c2 DEFINITION.
*
*  PUBLIC SECTION.
*
*    INTERFACES b1.
*    DATA:lv_variable_name2 TYPE I value '10'.
*
*    PROTECTED SECTION.
*
*    PRIVATE SECTION.
*
*ENDCLASS.
*
*CLASS c2 IMPLEMENTATION.
*
*  METHOD b1~method_name.
*
*    "Código adicional
*
*  ENDMETHOD.
*
*ENDCLASS.

*REPORT  ZTEST_ALV_CHECK     message-id zz           .
*TYPE-POOLS: SLIS.
*DATA: X_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
*      IT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
*      L_LAYOUT type slis_layout_alv.
*
*
*DATA: BEGIN OF ITAB OCCURS 0,
*      VBELN LIKE VBAK-VBELN,
*      POSNR LIKE VBAP-POSNR,
*      erdat like vbap-erdat,
*     END OF ITAB.
*
*SELECT VBELN
*       POSNR
*       erdat
*       FROM VBAP
*       UP TO 100 ROWS
*       INTO TABLE ITAB.
*
*X_FIELDCAT-FIELDNAME = 'VBELN'.
*X_FIELDCAT-SELTEXT_L = 'VBELN'.
*X_FIELDCAT-TABNAME = 'ITAB'.
*X_FIELDCAT-COL_POS = 1.
*APPEND X_FIELDCAT TO IT_FIELDCAT.
*CLEAR X_FIELDCAT.
*
*X_FIELDCAT-FIELDNAME = 'POSNR'.
*X_FIELDCAT-SELTEXT_L = 'POSNR'.
*X_FIELDCAT-TABNAME = 'ITAB'.
*X_FIELDCAT-COL_POS = 2.
*APPEND X_FIELDCAT TO IT_FIELDCAT.
*CLEAR X_FIELDCAT.
*
*X_FIELDCAT-FIELDNAME = 'ERDAT'.
*X_FIELDCAT-SELTEXT_L = 'ERDAT'.
*X_FIELDCAT-TABNAME = 'ITAB'.
*X_FIELDCAT-COL_POS = 3.
*APPEND X_FIELDCAT TO IT_FIELDCAT.
*CLEAR X_FIELDCAT.
*
*
*
*CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
*  EXPORTING
*    I_CALLBACK_PROGRAM       = SY-REPID
*    IT_FIELDCAT              = IT_FIELDCAT
*  TABLES
*    T_OUTTAB                 = ITAB
*  EXCEPTIONS
*    PROGRAM_ERROR            = 1
*    OTHERS                   = 2.
*IF SY-SUBRC <> 0.
*
*  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*ENDIF.

*&---------------------------------------------------------------------*
*& Report  Z_PO_QUANTITY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

*
*TYPE-POOLS: slis.
*TYPES: BEGIN OF ty_flight.
*INCLUDE STRUCTURE spfli.
*TYPES: END OF ty_flight.
*DATA: lt_spfli TYPE TABLE OF ty_flight.
*DATA: ls_spfli TYPE ty_flight.
*DATA: ls_layout TYPE slis_layout_alv.
*DATA: lt_fieldcat TYPE slis_t_fieldcat_alv.
*
*
*START-OF-SELECTION.
*PERFORM build_data.
*PERFORM build_fieldcatalog.
*PERFORM build_layout.
*PERFORM display_list_alv.
*
*
*" Form BUILD_DATA
*
*FORM build_data.
* SELECT * FROM spfli INTO CORRESPONDING FIELDS OF TABLE lt_spfli.
*ENDFORM. "BUILD_DATA
*
*"———————————————————————
*" Form BUILD_FIELDCATALOG
*"———————————————————————
*FORM build_fieldcatalog.
*CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*EXPORTING
*i_program_name = sy-cprog
*" I_INTERNAL_TABNAME =
*i_structure_name = 'SPFLI'
** I_CLIENT_NEVER_DISPLAY = ‘X’
** I_INCLNAME =
** I_BYPASSING_BUFFER =
** I_BUFFER_ACTIVE =
*CHANGING
*ct_fieldcat = lt_fieldcat
*EXCEPTIONS
*inconsistent_interface = 1
*program_error = 2
*OTHERS = 3.
*
*ENDFORM. " BUILD_FIELDCATALOG
*
*"&————————————————–
*"& Form BUILD_LAYOUT
*"&————————————————–
*FORM build_layout.
*ls_layout-zebra = 'X'.
*ls_layout-detail_popup = 'X'.
*ls_layout-detail_titlebar = 'Detailed Flight Info'.
*ls_layout-f2code = '&ETA'.
*ls_layout-window_titlebar = 'Flight Info'.
*ENDFORM. " BUILD_LAYOUT
*"&—————————————————
*"& Form DISPLAY_LIST_ALV
*"&—————————————————-
*FORM display_list_alv.
*CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
*EXPORTING
*i_callback_program = sy-cprog
*i_structure_name = 'SPFLI'
*is_layout = ls_layout
*it_fieldcat = lt_fieldcat
*TABLES
*t_outtab = lt_spfli
*EXCEPTIONS
*program_error = 1
*OTHERS = 2.
*CASE sy-subrc.
*WHEN 1.
*MESSAGE 'Program Error' TYPE 'I'.
*WHEN OTHERS.
*ENDCASE.
*ENDFORM. " DISPLAY_LIST_ALV
*
*TYPE-POOLS: slis.
*
*DATA: BEGIN OF itab OCCURS 0,
*        vbeln TYPE vbeln,
*        expand,
*      END OF itab.
*
*DATA: BEGIN OF itab1 OCCURS 0,
*        vbeln TYPE vbeln,
*        posnr TYPE posnr,
*        matnr TYPE matnr,
*        netpr TYPE netpr,
*      END OF itab1.
*
*DATA: t_fieldcatalog TYPE slis_t_fieldcat_alv.
*DATA: s_fieldcatalog TYPE slis_fieldcat_alv.
*
*s_fieldcatalog-col_pos = '1'.
*s_fieldcatalog-fieldname = 'VBELN'.
*s_fieldcatalog-tabname   = 'ITAB'.
*s_fieldcatalog-rollname  = 'VBELN'.
*s_fieldcatalog-outputlen = '12'.
*APPEND s_fieldcatalog TO t_fieldcatalog.
*CLEAR: s_fieldcatalog.
*
*s_fieldcatalog-col_pos = '1'.
*s_fieldcatalog-fieldname = 'VBELN'.
*s_fieldcatalog-tabname   = 'ITAB1'.
*s_fieldcatalog-rollname  = 'VBELN'.
*s_fieldcatalog-outputlen = '12'.
*APPEND s_fieldcatalog TO t_fieldcatalog.
*CLEAR: s_fieldcatalog.
*
*s_fieldcatalog-col_pos = '2'.
*s_fieldcatalog-fieldname = 'POSNR'.
*s_fieldcatalog-tabname   = 'ITAB1'.
*s_fieldcatalog-rollname  = 'POSNR'.
*APPEND s_fieldcatalog TO t_fieldcatalog.
*CLEAR: s_fieldcatalog.
*
*s_fieldcatalog-col_pos = '3'.
*s_fieldcatalog-fieldname = 'MATNR'.
*s_fieldcatalog-tabname   = 'ITAB1'.
*s_fieldcatalog-rollname  = 'MATNR'.
*APPEND s_fieldcatalog TO t_fieldcatalog.
*CLEAR: s_fieldcatalog.
*
*s_fieldcatalog-col_pos = '4'.
*s_fieldcatalog-fieldname = 'NETPR'.
*s_fieldcatalog-tabname   = 'ITAB1'.
*s_fieldcatalog-rollname  = 'NETPR'.
*s_fieldcatalog-do_sum    = 'X'.
*APPEND s_fieldcatalog TO t_fieldcatalog.
*CLEAR: s_fieldcatalog.
*
*DATA: s_layout TYPE slis_layout_alv.
*
*s_layout-subtotals_text            = 'SUBTOTAL TEXT'.
*s_layout-key_hotspot = 'X'.
*s_layout-expand_fieldname = 'EXPAND'.
*
*
*SELECT vbeln UP TO 100 ROWS
*       FROM
*       vbak
*       INTO TABLE itab.
*
*
*IF NOT itab[] IS INITIAL.
*
*  SELECT vbeln posnr matnr netpr
*         FROM vbap
*         INTO TABLE itab1
*         FOR ALL ENTRIES IN itab
*         WHERE vbeln = itab-vbeln.
*
*ENDIF.
*
*
*DATA: v_repid TYPE syrepid.
*
*v_repid = sy-repid.
*
*DATA: s_keyinfo TYPE slis_keyinfo_alv.
*s_keyinfo-header01 = 'VBELN'.
*s_keyinfo-item01   = 'VBELN'.
*
*CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
*     EXPORTING
*          i_callback_program = v_repid
*          is_layout          = s_layout
*          it_fieldcat        = t_fieldcatalog
*          i_tabname_header   = 'ITAB'
*          i_tabname_item     = 'ITAB1'
*          is_keyinfo         = s_keyinfo
*     TABLES
*          t_outtab_header    = itab
*          t_outtab_item      = itab1
*     EXCEPTIONS
*          program_error      = 1
*          OTHERS             = 2.
*IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*ENDIF.

*TABLES:t001.
*"Types
*TYPES:
*      BEGIN OF t_1001,
*        bukrs TYPE t001-bukrs,
*        butxt TYPE t001-butxt,
*        ort01 TYPE t001-ort01,
*        land1 TYPE t001-land1,
*      END OF t_1001.
*"Work area
*DATA:
*      w_t001 TYPE t_1001.
*"Internal table
*DATA:
*      i_t001 TYPE STANDARD TABLE OF t_1001.
*
**&---------------------------------------------------------------------*
** ALV Declarations
**----------------------------------------------------------------------*
** Types Pools
*TYPE-POOLS:
*   slis.
** Types
*TYPES:
*   t_fieldcat         TYPE slis_fieldcat_alv,
*   t_events           TYPE slis_alv_event,
*   t_layout           TYPE slis_layout_alv.
** Workareas
*DATA:
*   w_fieldcat         TYPE t_fieldcat,
*   w_events           TYPE t_events,
*   w_layout           TYPE t_layout.
** Internal Tables
*DATA:
*   i_fieldcat         TYPE STANDARD TABLE OF t_fieldcat,
*   i_events           TYPE STANDARD TABLE OF t_events.
**&---------------------------------------------------------------------*
**&    start of selection
**&---------------------------------------------------------------------*
*START-OF-SELECTION.
*  PERFORM get_data.
*
**&---------------------------------------------------------------------*
**&    end-of-selection.
**&---------------------------------------------------------------------*
*END-OF-SELECTION.
*
*  PERFORM build_fieldcatlog.
*  PERFORM build_events.
*  PERFORM build_layout.
*  PERFORM list_display.
**&---------------------------------------------------------------------*
**&      Form  get_data
**&---------------------------------------------------------------------*
*FORM get_data .
*
*  SELECT bukrs
*         butxt
*         ort01
*         land1
*    FROM t001
*    INTO TABLE i_t001
*    UP TO 30 ROWS.
*
*ENDFORM.                    " get_data
**&---------------------------------------------------------------------*
**&      Form  build_fieldcatlog
**&---------------------------------------------------------------------*
*FORM build_fieldcatlog .
*  CLEAR:w_fieldcat,i_fieldcat[].
*
*  PERFORM build_fcatalog USING:
*           'BUKRS' 'I_T001' 'BUKRS',
*           'BUTXT' 'I_T001' 'BUTXT',
*           'ORT01' 'I_T001' 'ORT01',
*           'LAND1' 'I_T001' 'LAND1'.
*
*ENDFORM.                    "BUILD_FIELDCATLOG
**&---------------------------------------------------------------------*
**&      Form  BUILD_FCATALOG
**&---------------------------------------------------------------------*
*FORM build_fcatalog USING l_field l_tab l_text.
*
*  w_fieldcat-fieldname      = l_field.
*  w_fieldcat-tabname        = l_tab.
*  w_fieldcat-seltext_m      = l_text.
*
*  APPEND w_fieldcat TO i_fieldcat.
*  CLEAR w_fieldcat.
*
*ENDFORM.                    " build_fieldcatlog
**&---------------------------------------------------------------------*
**&      Form  build_events
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*FORM build_events.
*  CLEAR :
*        w_events, i_events[].
*  w_events-name = 'TOP_OF_PAGE'."Event Name
*  w_events-form = 'TOP_OF_PAGE'."Callback event subroutine
*  APPEND w_events TO i_events.
*  CLEAR  w_events.
*
*ENDFORM.                    "build_events
**&---------------------------------------------------------------------*
**&      Form  build_layout
**&---------------------------------------------------------------------*
*FORM build_layout .
*
*  w_layout-colwidth_optimize = 'X'.
*  w_layout-zebra             = 'X'.
*
*ENDFORM.                    " build_layout
**&---------------------------------------------------------------------*
**&      Form  list_display
**&---------------------------------------------------------------------*
*FORM list_display .
*  DATA:
*        l_program TYPE sy-repid.
*  l_program = sy-repid.
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_callback_program = l_program
*      is_layout          = w_layout
*      it_fieldcat        = i_fieldcat
*      it_events          = i_events
*    TABLES
*      t_outtab           = i_t001
*    EXCEPTIONS
*      program_error      = 1
*      OTHERS             = 2.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*ENDFORM.                    " list_display
**&---------------------------------------------------------------------*
**&      Form  top_of_page
**&---------------------------------------------------------------------*
*FORM top_of_page.
*  DATA :
*   li_header TYPE slis_t_listheader,
*   w_header  LIKE LINE OF li_header.
*  DATA:
*        l_date TYPE char10.
*  WRITE sy-datum TO l_date.
*  w_header-typ  = 'H'.
*  CONCATENATE sy-repid ':' 'From Date' l_date INTO w_header-info SEPARATED BY space.
*  APPEND w_header TO li_header.
*  CLEAR w_header.
*
*  w_header-typ  = 'S'.
*  w_header-info = sy-title.
*  APPEND w_header TO li_header.
*  CLEAR w_header.
*
*  w_header-typ  = 'A'.
*  w_header-info = sy-uname.
*  APPEND w_header TO li_header.
*  CLEAR w_header.
*
*  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
*    EXPORTING
*      it_list_commentary = li_header.
*
*ENDFORM.                    "top_of_page


*TABLES: t001.
*DATA: it_company TYPE TABLE OF t001.
*SELECT-OPTIONS: so_bukrs FOR t001-bukrs.
*
*START-OF-SELECTION.
*  SELECT * FROM t001
*    INTO TABLE it_company
*    WHERE bukrs IN so_bukrs.
*
*END-OF-SELECTION.
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_structure_name = 'T001'
*    TABLES
*      t_outtab              = it_company
*    EXCEPTIONS
*      program_error    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.

*   CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_structure_name = 'T001'
*    CHANGING
*      ct_fieldcat           = DATA(it_fieldcat).


*  TYPE-POOLS: slis.
*
*  DATA: BEGIN OF itab OCCURS 0,
*          vbeln TYPE vbeln,
*          expand,
*        END OF itab.
*
*  DATA: BEGIN OF itab1 OCCURS 0,
*          vbeln TYPE vbeln,
*          posnr TYPE posnr,
*          matnr TYPE matnr,
*          netpr TYPE netpr,
*        END OF itab1.
*
*  DATA: t_fieldcatalog TYPE slis_t_fieldcat_alv.
*  DATA: s_fieldcatalog TYPE slis_fieldcat_alv.
*
*  s_fieldcatalog-col_pos = '1'.
*  s_fieldcatalog-fieldname = 'VBELN'.
*  s_fieldcatalog-tabname   = 'ITAB'.
*  s_fieldcatalog-rollname  = 'VBELN'.
*  s_fieldcatalog-outputlen = '12'.
*  APPEND s_fieldcatalog TO t_fieldcatalog.
*  CLEAR: s_fieldcatalog.
*
*  s_fieldcatalog-col_pos = '1'.
*  s_fieldcatalog-fieldname = 'VBELN'.
*  s_fieldcatalog-tabname   = 'ITAB1'.
*  s_fieldcatalog-rollname  = 'VBELN'.
*  s_fieldcatalog-outputlen = '12'.
*  APPEND s_fieldcatalog TO t_fieldcatalog.
*  CLEAR: s_fieldcatalog.
*
*  s_fieldcatalog-col_pos = '2'.
*  s_fieldcatalog-fieldname = 'POSNR'.
*  s_fieldcatalog-tabname   = 'ITAB1'.
*  s_fieldcatalog-rollname  = 'POSNR'.
*  APPEND s_fieldcatalog TO t_fieldcatalog.
*  CLEAR: s_fieldcatalog.
*
*  s_fieldcatalog-col_pos = '3'.
*  s_fieldcatalog-fieldname = 'MATNR'.
*  s_fieldcatalog-tabname   = 'ITAB1'.
*  s_fieldcatalog-rollname  = 'MATNR'.
*  APPEND s_fieldcatalog TO t_fieldcatalog.
*  CLEAR: s_fieldcatalog.
*
*  s_fieldcatalog-col_pos = '4'.
*  s_fieldcatalog-fieldname = 'NETPR'.
*  s_fieldcatalog-tabname   = 'ITAB1'.
*  s_fieldcatalog-rollname  = 'NETPR'.
*  s_fieldcatalog-do_sum    = 'X'.
*  APPEND s_fieldcatalog TO t_fieldcatalog.
*  CLEAR: s_fieldcatalog.
*
*  DATA: s_layout TYPE slis_layout_alv.
*
*  s_layout-subtotals_text            = 'SUBTOTAL TEXT'.
*  s_layout-key_hotspot = 'X'.
*  s_layout-expand_fieldname = 'EXPAND'.
*
*  SELECT vbeln UP TO 100 ROWS
*         FROM vbak
*         INTO TABLE itab.
*
*  IF NOT itab[] IS INITIAL.
*
*    SELECT vbeln posnr matnr netpr
*           FROM vbap
*           INTO TABLE itab1
*           FOR ALL ENTRIES IN itab
*           WHERE vbeln = itab-vbeln.
*  ENDIF.
*
*  DATA: v_repid TYPE syrepid.
*
*  v_repid = sy-repid.
*  DATA: s_keyinfo TYPE slis_keyinfo_alv.
*  s_keyinfo-header01 = 'VBELN'.
*  s_keyinfo-item01   = 'VBELN'.
*
*  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
*       EXPORTING
*            i_callback_program = v_repid
*            is_layout          = s_layout
*            it_fieldcat        = t_fieldcatalog
*            i_tabname_header   = 'ITAB'
*            i_tabname_item     = 'ITAB1'
*            is_keyinfo         = s_keyinfo
*       TABLES
*            t_outtab_header    = itab
*            t_outtab_item      = itab1
*       EXCEPTIONS
*            program_error      = 1
*            OTHERS             = 2.
*  IF sy-subrc NE 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*
**REPORT  ZALV_REPORT_SFLIGHT.
*TABLES : SFLIGHT.
*TYPE-POOLS : SLIS."**INTERNAL TABLE DECLARTION
*DATA : WA_SFLIGHT TYPE SFLIGHT,
*       IT_SFLIGHT TYPE TABLE OF SFLIGHT."**DATA DECLARTION
*DATA: FIELDCATALOG TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
*      GD_LAYOUT    TYPE SLIS_LAYOUT_ALV,
*      GD_REPID     LIKE SY-REPID,
*      G_SAVE TYPE C VALUE 'X',
*      G_VARIANT TYPE DISVARIANT,
*      GX_VARIANT TYPE DISVARIANT,
*      G_EXIT TYPE C,
*      ISPFLI TYPE TABLE OF SPFLI."* To understand the importance of the following parameter, click here.
***SELECTION SCREEN DETAILS
*SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-002 .
*PARAMETERS: VARIANT LIKE DISVARIANT-VARIANT.
*SELECTION-SCREEN END OF BLOCK B1.
***GETTING DEFAULT VARIANT
*INITIALIZATION.
*  GX_VARIANT-REPORT = SY-REPID.
*  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
*    EXPORTING
*      I_SAVE     = G_SAVE
*    CHANGING
*      CS_VARIANT = GX_VARIANT
*    EXCEPTIONS
*      NOT_FOUND  = 2.
*  IF SY-SUBRC = 0.
*    VARIANT = GX_VARIANT-VARIANT.
*  ENDIF."**PERFORM DECLARATIONS
*START-OF-SELECTION.
*  PERFORM DATA_RETRIVEL.
*  PERFORM BUILD_FIELDCATALOG.
*  PERFORM DISPLAY_ALV_REPORT.
**&---------------------------------------------------------------------*
**&      Form  BUILD_FIELDCATALOG
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM BUILD_FIELDCATALOG .  FIELDCATALOG-FIELDNAME   = 'CARRID'.
*  FIELDCATALOG-SELTEXT_M   = 'Airline Code'.
*  FIELDCATALOG-COL_POS     = 0.
*  APPEND FIELDCATALOG TO FIELDCATALOG.
*  CLEAR  FIELDCATALOG.
*  FIELDCATALOG-FIELDNAME   = 'CONNID'.
*  FIELDCATALOG-SELTEXT_M   = 'Flight Connection Number'.
*  FIELDCATALOG-COL_POS     = 1.
*  APPEND FIELDCATALOG TO FIELDCATALOG.
*  CLEAR  FIELDCATALOG.  FIELDCATALOG-FIELDNAME   = 'FLDATE'.
*  FIELDCATALOG-SELTEXT_M   = 'Flight date'.
*  FIELDCATALOG-COL_POS     = 2.
*  APPEND FIELDCATALOG TO FIELDCATALOG.
*  CLEAR  FIELDCATALOG.  FIELDCATALOG-FIELDNAME   = 'PRICE'.
*  FIELDCATALOG-SELTEXT_M   = 'Airfare'.
*  FIELDCATALOG-COL_POS     = 3.
*  FIELDCATALOG-OUTPUTLEN   = 20.
*  APPEND FIELDCATALOG TO FIELDCATALOG.
*  CLEAR  FIELDCATALOG.
*ENDFORM.                    " BUILD_FIELDCATALOG
*
*
**&---------------------------------------------------------------------*
**&      Form  DISPLAY_ALV_REPORT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM DISPLAY_ALV_REPORT .
*  GD_REPID = SY-REPID.
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      I_CALLBACK_PROGRAM      = GD_REPID
*      I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE'  "see FORM
*      I_CALLBACK_USER_COMMAND = 'USER_COMMAND'
*      IT_FIELDCAT             = FIELDCATALOG[]
*      I_SAVE                  = 'X'
*      IS_VARIANT              = G_VARIANT
*    TABLES
*      T_OUTTAB                = IT_SFLIGHT
*    EXCEPTIONS
*      PROGRAM_ERROR           = 1
*      OTHERS                  = 2.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*ENDFORM.                    "DISPLAY_ALV_REPORT" DISPLAY_ALV_REPORT
**&---------------------------------------------------------------------*
**&      Form  DATA_RETRIVEL
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM DATA_RETRIVEL .
*  SELECT * FROM SFLIGHT INTO TABLE IT_SFLIGHT.
*ENDFORM.                    " DATA_RETRIVEL*-------------------------------------------------------------------*
** Form  TOP-OF-PAGE                                                 *
**-------------------------------------------------------------------*
** ALV Report Header                                                 *
**-------------------------------------------------------------------*
*FORM TOP-OF-PAGE.
**ALV Header declarations
*  DATA: T_HEADER TYPE SLIS_T_LISTHEADER,
*        WA_HEADER TYPE SLIS_LISTHEADER,
*        T_LINE LIKE WA_HEADER-INFO,
*        LD_LINES TYPE I,
*        LD_LINESC(10) TYPE C."* Title
*  WA_HEADER-TYP  = 'H'.
*  WA_HEADER-INFO = 'SFLIGHT Table Report'.
*  APPEND WA_HEADER TO T_HEADER.
*  CLEAR WA_HEADER."* Date
*  WA_HEADER-TYP  = 'S'.
*  WA_HEADER-KEY = 'Date: '.
*  CONCATENATE  SY-DATUM+6(2) '.'
*               SY-DATUM+4(2) '.'
*               SY-DATUM(4) INTO WA_HEADER-INFO.   "todays date
*  APPEND WA_HEADER TO T_HEADER.
*  CLEAR: WA_HEADER.
*  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
*    EXPORTING
*      IT_LIST_COMMENTARY = T_HEADER.
*ENDFORM.                    "top-of-page

*REPORT ZHR_TES.

************************************************************************

*Type-Pools *

************************************************************************
*
*TYPE-POOLS : slis.
*
*************************************************************************
*
**Nodes *
*
*************************************************************************
*
*NODES: person,
*
*group,
*
*peras.
*
**************************************************************************
*
**Tables *
*
*************************************************************************
*
*TABLES: pernr,
*
*        t512w,
*
*        tfkbt,
*
*        pa0022,
*
*        pa0016,
*
*        bkpf.
*
*************************************************************************
*
**Infotypes *
*
*************************************************************************
*
*INFOTYPES : 0000, "Actions
*
*0001, "Org Details
*
*0022, "Education Details
*
*0041, "Date Specification
*
*0002, "Personal Details
*
*0016.
*
*************************************************************************
*
**Internal Tables *
*
*************************************************************************
*
*DATA :BEGIN OF t_output OCCURS 0,
*
*        pernr TYPE pernr_d, " Personnel No.
*
*        ename TYPE emnam, " Employee Name
*
*        btrtl TYPE btrtl, "Personnel Subarea
*
*        btext TYPE btext, "Personnel Subarea Text
*
*        persk TYPE persk, "Grade
*
*        ptext TYPE pktxt, "gradeText
*
*      END OF t_output,
*
*      t_fcat TYPE slis_t_fieldcat_alv.
*
**----
*
**ALV Variable
*
**----
*
*DATA : w_fieldcat  TYPE slis_t_fieldcat_alv,
*
*       wa_fieldcat TYPE slis_fieldcat_alv.
*
*************************************************************************
*
**Event : GET Pernr *
*
*************************************************************************
*
*GET peras.
*
*PERFORM read_data. "Data Selection
*
*************************************************************************
*
**Event : End-Of-Selection *
*
*************************************************************************
*
*END-OF-SELECTION.
*
*  PERFORM f_addcat. "Field Cat
*
*  PERFORM f_display. "Display
*
**&----
*
**& Form read_data
*
**&----
*
*FORM read_data.
*
**Organizational Assignment
*
*  rp_provide_from_last p0001 space pn-begda pn-endda.
*
*  IF pnp-sw-found EQ 1.
*
*    t_output-pernr = p0001-pernr.
*
*    t_output-ename = p0001-ename.
*
*    t_output-btrtl = p0001-btrtl.
*
*    t_output-persk = p0001-persk.
*
**Personal sub area text
*
*    SELECT SINGLE btext FROM t001p
*
*    INTO t_output-btext
*
*    WHERE btrtl = t_output-btrtl.
*
**Grade text
*
*    SELECT SINGLE ptext FROM t503t
*
*    INTO t_output-ptext
*
*    WHERE persk = t_output-persk AND
*
*    sprsl = 'EN'.
*
*  ENDIF.
*
*  APPEND t_output.
*
*  CLEAR t_output.
*
*ENDFORM. "
*
**&----
*
**& Form f_addcat
*
**&----
*
*FORM f_addcat .
*
*  PERFORM f_fieldcat USING 'T_OUTPUT' 'PERNR' 'Personnel No.' 8 ''.
*
*  PERFORM f_fieldcat USING 'T_OUTPUT' 'ENAME' 'Name' 15 ''.
*
*  PERFORM f_fieldcat USING 'T_OUTPUT' 'PTEXT' 'Grade' 10 ''.
*
*ENDFORM. " f_addcat
*
**&----
*
**& Form f_fieldcat
*
**&----
*
*FORM f_fieldcat USING VALUE(p_tname)
*
*VALUE(p_fname)
*
*VALUE(p_desc)
*
*VALUE(p_leng)
*
*VALUE(p_out).
*
*  MOVE : p_tname TO wa_fieldcat-tabname,
*
*  p_fname TO wa_fieldcat-fieldname,
*
*  p_desc TO wa_fieldcat-seltext_l,
*
*  p_leng TO wa_fieldcat-outputlen,
*
*  p_out TO wa_fieldcat-no_out.
*
*  APPEND wa_fieldcat TO t_fcat.
*
*  CLEAR wa_fieldcat.
*
*ENDFORM. " f_fieldcat
*
**&----
*
**& Form f_display
*
**&----
*
*FORM f_display.
*
**Local Variable
*
*  DATA : lv_repid  LIKE sy-repid,
*
*         ls_layout TYPE slis_layout_alv.
*
*  lv_repid = sy-repid.
*
*  ls_layout-zebra = 'X'.
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_callback_program = lv_repid
*      is_layout          = ls_layout
*      it_fieldcat        = t_fcat
*      i_save             = 'A'
*    TABLES
*      t_outtab           = t_output
*    EXCEPTIONS
*      program_error      = 1
*      OTHERS             = 2.
*
*  IF sy-subrc <> 0.
*
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*
*    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*
*  ENDIF.
*
*ENDFORM. " f_display

*REPORT  zterceiro_report03.

*
*TABLES: bkpf.
*
*START-OF-SELECTION.
*
*  GET bkpf.
*  CHECK bkpf-belnr IN br_belnr.
*  WRITE:/ bkpf-belnr, bkpf-budat.
*
*END-OF-SELECTION.
*
**INFOTYPES: 0000,0001,0002,2001,2002.
**
**TABLES: pernr.
**
**START-OF-SELECTION.
**
**  GET pernr.
**
**  rp-read-all-time-ity pn-begda pn-endda.
**
**  rp-provide-from-frst p0000 space pn-begda pn-endda.
**
**  rp-provide-from-last p0001 space pn-begda pn-endda.
**
***  PERFORM get_data.
**
**END-OF-SELECTION.
**
***  PERFORM display_list.
*
*  CALL FUNCTION 'RH_READ_INFTY'
*    EXPORTING
*      with_stru_auth       = 'X'
*      plvar                = p_plvar
*      otype                = p_otype
*      objid                = p_objid
*      infty                = '9113'
*      istat                = '1'
*      begda                = p_begda
*      endda                = p_endda
*    TABLES
*      innnn                = lt_i9113
*    EXCEPTIONS
*      all_infty_with_subty = 1
*      nothing_found        = 2
*      no_objects           = 3
*      wrong_condition      = 4
*      wrong_parameters     = 5
*      OTHERS               = 6.
*  IF sy-subrc <> 0.
**   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
**              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*
*    CALL FUNCTION 'RH_READ_INFTY_TABDATA'
*      EXPORTING
*        infty          = '9113'
*      TABLES
*        innnn          = lt_i9113
*        hrtnnnn        = lt_i9113_dbtab
*      EXCEPTIONS
*        no_table_infty = 1
*        innnn_empty    = 2
*        nothing_found  = 3
*        OTHERS         = 4.
*    IF sy-subrc <> 0.
**   Implement suitable error handling here
*    ENDIF.
*
*  CALL FUNCTION 'RH_GET_TABDATA_FROM_ITAB'
*    EXPORTING
*      tabnr                = <fs_i9113>-tabnr
*    tables
*      hrtnnnn              = Lt_i9113_dbtab
*      ptnnnn               = lt_pt9113
*   EXCEPTIONS
*     NOTHING_FOUND        = 1
*     OTHERS               = 2
*            .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.




*SUBMIT ZHR_PAYROLL_EXTRACTION_TOOL WITH

*&---------------------------------------------------------------------*
*& Report  Y_EXCEL_TO_ITAB
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

*REPORT y_excel_to_itab.
*
*PARAMETERS: p_file LIKE rlgrap-filename,
*            p_str  TYPE tabname,
*            p_hdr  as CHECKBOX,
*            p_cli  as CHECKBOX.
*
*START-OF-SELECTION.
*
*  DATA: lt_dyn_tab             TYPE REF TO data.
*
*  FIELD-SYMBOLS : <lfs_dyn_tab> TYPE ANY TABLE.
*
*  IF p_file IS NOT INITIAL.
*
*    "Generate table
*    CREATE DATA lt_dyn_tab TYPE TABLE OF (p_str).
*    ASSIGN lt_dyn_tab->* TO <lfs_dyn_tab>.
*
*    CALL FUNCTION 'Y_CONVERSION_EXIT_DECS_INPUT'
*      EXPORTING
*        iv_filename          = p_file
*        iv_structure         = p_str
*        IV_MANDT_AVL         = p_cli
*        IV_HDR_AVL           = p_hdr
*      CHANGING
*        ct_return_table      = <lfs_dyn_tab>
*      EXCEPTIONS
*        structure_not_found  = 1
*        field_not_found      = 2
*        OTHERS               = 3.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ELSE.
*      "Do what you must with the converted data
******        ">>>If needed the below line could be used to update the data to DB
******        MODIFY (p_str) FROM TABLE <lfs_dyn_tab>.
******        "<<<
*    ENDIF.
*  ENDIF.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*
*  CALL FUNCTION 'F4_FILENAME'
*    EXPORTING
*      program_name  = syst-cprog
*      dynpro_number = syst-dynnr
*      field_name    = ' '
*    IMPORTING
*      file_name     = p_file.
*


*----------------------------------------------------------------------------------
*PARAMETERS: p_file TYPE  rlgrap-filename.
*PARAMETERS: p_head TYPE char01 DEFAULT 'X'.
*
*TYPES: BEGIN OF t_datatab,
*      col1(250)    TYPE c,
*      col2(250)    TYPE c,
*      col3(250)    TYPE c,
*      END OF t_datatab.
*
*DATA: it_datatab TYPE STANDARD TABLE OF t_datatab,
*      wa_datatab TYPE t_datatab.
*
*DATA: it_raw TYPE truxs_t_text_data.
*
** At selection screen
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*  CALL FUNCTION 'F4_FILENAME'
*    EXPORTING
*      field_name = 'P_FILE'
*    IMPORTING
*      file_name  = p_file.
*
*START-OF-SELECTION.
*
*  " Convert Excel Data to SAP internal Table Data
*  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
*    EXPORTING
**     I_FIELD_SEPERATOR        =
*      i_line_header            =  p_head
*      i_tab_raw_data           =  it_raw       " WORK TABLE
*      i_filename               =  p_file
*    TABLES
*      i_tab_converted_data     = it_datatab[]  "ACTUAL DATA
*   EXCEPTIONS
*      conversion_failed        = 1
*      OTHERS                   = 2.
*
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*
*
************************************************************************
** END-OF-SELECTION.
*END-OF-SELECTION.
*  " For sample, Excel Data transfered to internal table is displayed with write
*  LOOP AT it_datatab INTO wa_datatab.
*    WRITE:/ wa_datatab-col1,
*            wa_datatab-col2,
*            wa_datatab-col3.
*  ENDLOOP.





"////=========================================================="
"///                    Excel to ALV
"//Descrição:
"/============================================================="

*DATA: lv_rc       TYPE i,
*      it_file     TYPE filetable,
*      lv_action   TYPE i,
*
*
*      lv_filesize TYPE w3param-cont_len,
*      lv_filetype TYPE w3param-cont_type,
*      it_bin_data TYPE w3mimetabtype.
*
*TRY.

"////=========================================================="
"///                 File Open Dialog
"//Descrição:
"/============================================================="

*    cl_gui_frontend_services=>file_open_dialog(
*      EXPORTING
*        file_filter             = |xlsx (.*xlsx)\|*.xlsx\|{ cl_gui_frontend_services=>filetype_all }|
*      CHANGING
*        file_table              = it_file
*        rc                      = lv_rc
*        user_action             = lv_action
*      EXCEPTIONS
*        file_open_dialog_failed = 1
*        cntl_error              = 2
*        error_no_gui            = 3
*        not_supported_by_gui    = 4
*        OTHERS                  = 5
*    ).
*
*    IF lv_action = cl_gui_frontend_services=>action_ok.
*
*      IF lines( it_file ) > 0.
*
*        cl_gui_frontend_services=>gui_upload(
*         EXPORTING
*          filename = |{ it_file[ 1 ]-filename }|
*          filetype = 'BIN'
*         IMPORTING
*          filelength = lv_filesize
*         CHANGING
*          data_tab = it_bin_data ).
*
*        DATA(lv_bin_data) = cl_bcs_convert=>solix_to_xstring( it_solix   = it_bin_data ).
*
*        DATA(o_excel) = NEW cl_fdt_xl_spreadsheet( document_name = CONV #( it_file[ 1 ]-filename )
*        xdocument = lv_bin_data ).
*
*        DATA: it_worksheet_names TYPE if_fdt_doc_spreadsheet=>t_worksheet_names.
*
*        o_excel->if_fdt_doc_spreadsheet~get_worksheet_names( IMPORTING worksheet_names = it_worksheet_names ).
*
*        IF lines( it_worksheet_names ) > 0.
*
*          DATA(o_worksheet_itab) = o_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( it_worksheet_names[ 1 ] ).
*
*          ASSIGN o_worksheet_itab->* TO FIELD-SYMBOL(<worksheet>).
*
*
*          cl_demo_output=>write_data( <worksheet> ).
*
*
*
*          DATA(lv_html) = cl_demo_output=>get( ).
*
*          cl_abap_browser=>show_html(
**            EXPORTING
**              html         =
*              title        = 'Excel Worksheet'
**              size         = CL_ABAP_BROWSER=>MEDIUM
**              modal        = ABAP_TRUE
*              html_string  = lv_html
**              printing     = ABAP_FALSE
**              buttons      = NAVIGATE_OFF
**              format       = CL_ABAP_BROWSER=>LANDSCAPE
**              position     = CL_ABAP_BROWSER=>TOPLEFT
**              data_table   =
**              anchor       =
**              context_menu = ABAP_FALSE
**              html_xstring =
**              check_html   = ABAP_TRUE
*              container    = cl_gui_container=>default_screen
**              dialog       = ABAP_TRUE
**            IMPORTING
**              html_errors  =
*          ).
*
*          WRITE: space.
*
*        ENDIF.
*
*      ENDIF.
*
*    ENDIF.
*
*  CATCH cx_root INTO DATA(e_text).
*
*    MESSAGE e_text->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
*
*ENDTRY.
*
*
*    TYPE-POOLS: truxs.
*    PARAMETERS: p_file TYPE  rlgrap-filename.
*    TYPES: BEGIN OF t_datatab,
*             col1(30) TYPE c,
*             col2(30) TYPE c,
*             col3(30) TYPE c,
*           END OF t_datatab.
*    DATA: it_datatab TYPE STANDARD TABLE OF t_datatab,
*          wa_datatab TYPE t_datatab.
*    DATA: it_raw TYPE truxs_t_text_data.
** At selection screen
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*  CALL FUNCTION 'F4_FILENAME'
*    EXPORTING
*      field_name = 'P_FILE'
*    IMPORTING
*      file_name  = p_file.
**  ENDTRY.
************************************************************************
**START-OF-SELECTION.
*START-OF-SELECTION.
*  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
*    EXPORTING
**     I_FIELD_SEPERATOR    =
*      i_line_header        = 'X'
*      i_tab_raw_data       = it_raw       " WORK TABLE
*      i_filename           = p_file
*    TABLES
*      i_tab_converted_data = it_datatab[]    "ACTUAL DATA
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
************************************************************************
** END-OF-SELECTION.
*END-OF-SELECTION.
*  LOOP AT it_datatab INTO wa_datatab.
*    WRITE:/ wa_datatab.
*  ENDLOOP.





"----------------------------------------------------------------------------------------------------------------
*
*INCLUDE rpc2rx00.
*INCLUDE rpc2rpp0.
*INCLUDE hptpaymacro.
*INCLUDE rpppxd00.
*INCLUDE rpppxd10.
*
*DATA: rgdir     TYPE STANDARD TABLE OF pc261,
*      evp_rgdir TYPE STANDARD TABLE OF pc261,
*      ls_rgdir  TYPE pc261.
*
*CALL FUNCTION 'CU_READ_RGDIR'
*  EXPORTING
*    persnr                   = '0017'
**   BUFFER                   =
**   NO_AUTHORITY_CHECK       = ' '
** IMPORTING
**   MOLGA                    =
*  tables
*    in_rgdir                 = rgdir
* EXCEPTIONS
*   NO_RECORD_FOUND          = 1
*   OTHERS                   = 2
*          .
*
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
*
*CALL FUNCTION 'CD_SELECT_DATE_RANGE'
* EXPORTING
*   FPPER_BEGDA       = '18000101'
*   FPPER_ENDDA       = '99991231'
*  TABLES
*    in_rgdir          = rgdir
*    out_rgdir         = evp_rgdir
*          .
*
*SORT evp_rgdir BY seqnr DESCENDING.
*READ TABLE evp_rgdir into ls_rgdir INDEX 1.
*CHECK sy-subrc EQ 0.
*
*rx-key-pernr = '0017'.
*UNPACK ls_rgdir-seqnr TO rx-key-seqno.
*
**rp-imp-c2-rp.
**BREAK-POINT.
**include rpppxm00.
*


*-------------------------------------------------------------------------------------------

*DATA: it_periods type TABLE OF T549Q,
*      it_tab_sko type TABLE OF PC2B3,
*      it_tab_zes type TABLE OF PC2B6.
*
*CALL FUNCTION 'HR_PAYROLL_PERIODS_GET'
*  EXPORTING
*    get_begda       = '18000101'
*    get_endda       = '99991231'
*  TABLES
*    get_periods     = it_periods
*  .
*
*CALL FUNCTION 'HR_TIME_RESULTS_GET'
*  EXPORTING
*    get_pernr             = '0002'
*    get_pabrj             = '2009'
*    get_pabrp             = '02'
*  TABLES
*    get_sko               = it_tab_sko
*    get_zes               = it_tab_zes
*  EXCEPTIONS
*    no_period_specified   = 1
*    wrong_cluster_version = 2
*    no_read_authority     = 3
*    cluster_archived      = 4
*    technical_error       = 5
*    others                = 6
*  .
*
*
*
*
*IF sy-subrc <> 0.
** MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
**            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*ENDIF.




"______________________________________________________________
*
*      INCLUDE rpppxd10.
*      INCLUDE rpc1b100.
*      INCLUDE rpc2b200.
*      INCLUDE rpppxd00.
*
*      b2-key-pernr = '0002'.
*      b2-key-pabrj = '2009'.
*      b2-key-pabrp = '02'.
*      b2-key-cltyp = '1'.
*      rp-imp-c2-b2.
*
*      IF rp-imp-b2-subrc = 0.
*        READ TABLE zl WITH KEY lgart = '0112'.
*
*        IF sy-subrc = 0.
*          write zl-anzhl.
*        ENDIF.
*
*      ENDIF.
*
*      b1-key-pernr = '0002'.
*      rp-imp-c1-b1.
*
*      INCLUDE rpppxm00.
