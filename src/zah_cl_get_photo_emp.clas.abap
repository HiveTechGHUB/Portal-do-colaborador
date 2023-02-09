class ZAH_CL_GET_PHOTO_EMP definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  methods GET_PHOTOS_EMPS
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_PHOTO_EMP type ZAH_TT_PHOTO_EMP .
  methods GET_PHOTOS_DELTA
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_PHOTO_EMP type ZAH_TT_PHOTO_EMP .
protected section.
private section.
ENDCLASS.



CLASS ZAH_CL_GET_PHOTO_EMP IMPLEMENTATION.


  METHOD get_photos_delta.

    DATA: lt_photo_emp_bd  TYPE TABLE OF zva_tb_photo_emp.


    get_photos_emps(
  EXPORTING
    it_num_emp   =  it_num_emp  " tabela de importação/exportação do número de colaborador
  IMPORTING
    et_photo_emp =  DATA(lt_photo_emp)  " Tipo de tabela para exportação fotos do colaborador
).
    "recolhe todas as fotos na tabela de bd que tavam em cache
    SELECT * FROM zva_tb_photo_emp INTO TABLE lt_photo_emp_bd.

    "logica que adiciona ou idita dados ba bd
    "loop tabela das fotos recolhidas em sap
    LOOP AT lt_photo_emp INTO DATA(ls_photo_emp).

      "verifica se existe dados na bd correspondente aos colaboradores encontrados
      READ TABLE lt_photo_emp_bd INTO DATA(ls_photo_emp_bd) WITH KEY num_emp = ls_photo_emp-num_emp.
      "se encontar
      IF sy-subrc EQ 0.
        "verifica se as fotos entre bd e sap sao iguais
        IF ls_photo_emp-photo_emp NE ls_photo_emp_bd-photo_emp ."or ls_photo_emp-photo_emp IS NOT INITIAL.

          ls_photo_emp_bd-num_emp = ls_photo_emp-num_emp.
          ls_photo_emp_bd-photo_emp = ls_photo_emp-photo_emp.

          "modifica na bd
          MODIFY zva_tb_photo_emp FROM ls_photo_emp_bd.
          "adiciona à tabela de exportação
          APPEND ls_photo_emp TO et_photo_emp.
        ENDIF.
        "se o subrc for diferente de 0 e o colaborador tiver foto
      ELSEIF ls_photo_emp-photo_emp IS NOT INITIAL.

        ls_photo_emp_bd-num_emp = ls_photo_emp-num_emp.
        ls_photo_emp_bd-photo_emp = ls_photo_emp-photo_emp.

        "modifica/adiciona a foto na tabela de bd
        MODIFY zva_tb_photo_emp FROM  ls_photo_emp_bd.
        "adiciona à tabela de exportação
        APPEND ls_photo_emp TO et_photo_emp.

      ENDIF.

    ENDLOOP.

    "limpa estruturas
    CLEAR: ls_photo_emp,
           ls_photo_emp_bd.

    "logica para eliminar fotos da bd
    "loop à tabela de bd
    LOOP AT lt_photo_emp_bd INTO ls_photo_emp_bd.
      "verifica se existe dados na tabela recolhida de sap correspondente aos colaboradores na bd
      READ TABLE lt_photo_emp INTO ls_photo_emp WITH KEY num_emp = ls_photo_emp_bd-num_emp.
      "se nao corresponder
      IF sy-subrc NE 0.

        "extrutura inserir tabela de exportação
        ls_photo_emp-num_emp = ls_photo_emp_bd-num_emp.
        ls_photo_emp-photo_emp = ' '.

        "adiciona à tabela de exportação
        APPEND  ls_photo_emp TO et_photo_emp.

        "elimina linha daquele colaborador na bd
        DELETE FROM zva_tb_photo_emp WHERE num_emp EQ ls_photo_emp-num_emp.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.


  METHOD get_photos_emps.

    DATA:
          lv_photo_exists TYPE c,
          ls_connect_info TYPE  toav0,
          lt_acinf        TYPE TABLE OF scms_acinf,
          lt_content      TYPE TABLE OF sdokcntbin,
          lv_length       TYPE i,
          lv_emp_photo    TYPE xstring,
*          lt_content      TYPE STANDARD TABLE OF string,
          lv_photo_base64 TYPE string,
          ls_photo_emp    TYPE zah_s_photo_emp.



    "metodo validar os numeros do colaborador importados
    "casa nao sejam importados nenhum o metodo retorna todos os colaboradores ativos
    zah_i_common_methods~validate_num_emp(
      EXPORTING
        it_num_emp           =   it_num_emp  " tabela de importação/exportação do número de colaborador
      IMPORTING
        et_num_emp_validated =   data(lt_num_emps)  " tabela de importação/exportação do número de colaborador
    ).

    "lopp à tabela de colaboradores
    LOOP AT lt_num_emps INTO DATA(ls_num_emp).

      CLEAR: lv_photo_exists,
      lv_length.

      free: ls_connect_info,
       lt_acinf,
       lt_content,
       lv_length,
       ls_photo_emp.

      "verifica se existe foto deste colaborador
      CALL FUNCTION 'HR_IMAGE_EXISTS'
        EXPORTING
          p_pernr               = ls_num_emp-num_emp
        IMPORTING
          p_exists              = lv_photo_exists
          p_connect_info        = ls_connect_info
        EXCEPTIONS
          error_connectiontable = 1
          OTHERS                = 2.

      "se existir foto
      IF ls_connect_info is not INITIAL.

        "vai ler as informaçoes da mesma e recolher o binario
        CALL FUNCTION 'SCMS_DOC_READ'
          EXPORTING
            stor_cat    = ' '
            crep_id     = ls_connect_info-archiv_id
            doc_id      = ls_connect_info-arc_doc_id
          TABLES
            access_info = lt_acinf
            content_bin = lt_content.

        "recolhe o numero de linhas de binario
        DATA(lv_last_line) = lines( lt_content )."funçao que conta o numero de linhas na tabela

*** NOVA SINTAXE READ TABLE ***
        TRY.
          "recolhe o tamanho da foto
            lv_length = lt_acinf[ 1 ]-comp_size.

          CATCH cx_sy_itab_line_not_found.

        ENDTRY.

        "transforma o binario numa unica string
        CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
          EXPORTING
            input_length = lv_length
            first_line   = 0
            last_line    = lv_last_line
          IMPORTING
            buffer       = lv_emp_photo
          TABLES
            binary_tab   = lt_content.
        "se a xtring do binario tiver preenchida
        IF lv_emp_photo is NOT INITIAL.

          "transforma o binario em base64
          CALL FUNCTION 'SSFC_BASE64_ENCODE'
            EXPORTING
              bindata = lv_emp_photo
            IMPORTING
              b64data = lv_photo_base64.

          ls_photo_emp-num_emp = ls_num_emp-num_emp.
          ls_photo_emp-photo_emp = lv_photo_base64.

          "preenche a tabela de exportaçao
          APPEND ls_photo_emp TO et_photo_emp.

        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
