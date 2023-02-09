class ZAH_CL_LISTS definition
  public
  final
  create public .

public section.

  methods GET_PROJECT_LIST
    exporting
      !ET_PROJECT_LIST type ZAH_TT_PROJECT_LIST .
  methods GET_COST_CENTER_LIST
    exporting
      !ET_COST_CENTER_LIST type ZAH_TT_COST_CENTER_LIST .
  methods GET_ABSTENCE_TYPES_LIST
    exporting
      !ET_ABSTENCE_TYPES_LIST type ZAH_TT_ABSTENCE_TYPES_LIST .
  methods GET_PROJECT_TYPES
    exporting
      !ET_PROJECT_TYPES type ZAH_TT_PROJECT_TYPES_LIST .
  methods GET_PROJECT_PROFILES
    exporting
      !ET_PROJECT_PROFILES type ZAH_TT_PROJECT_PROFILES_LIST .
protected section.
private section.
ENDCLASS.



CLASS ZAH_CL_LISTS IMPLEMENTATION.


  METHOD GET_ABSTENCE_TYPES_LIST.

    SELECT awart atext
      FROM t554t
      INTO TABLE et_abstence_types_list
      WHERE moabw = '19'
        AND sprsl = 'PT'.
  ENDMETHOD.


  METHOD GET_COST_CENTER_LIST.
    SELECT kostl ktext
      FROM cskt
      INTO TABLE et_cost_center_list
      WHERE spras = 'PT'
         AND kokrs = 'AMT'
         AND datbi >= sy-datum.

  ENDMETHOD.


  METHOD get_project_list.


    DATA: lt_info_prps TYPE TABLE OF zah_s_info_prps,
          ls_info_prps  TYPE zah_s_info_prps,
          lt_info_proj TYPE TABLE OF zah_s_info_proj,
          lt_info_ihpa TYPE TABLE OF zah_s_info_ihpa,
          ls_info_ihpa  TYPE zah_s_info_ihpa,
          lt_info_kna1 TYPE TABLE OF zah_s_info_kna1,
          ls_info_kna1 TYPE  zah_s_info_kna1 .

    data: ls_project_list TYPE zah_s_project_list.


    "recolher informaçao tabela PRPS
    SELECT DISTINCT psphi prart
      INTO TABLE lt_info_prps
      FROM prps.

    "recolher informaçao tabela proj
    SELECT pspnr pspid post1 plfaz plsez profl verna erdat ernam aedat aenam OBJNR
      INTO TABLE lt_info_proj
      FROM proj.

    "recolher informação tabela ihpa
    SELECT objnr parnr
      INTO TABLE  lt_info_ihpa
      FROM ihpa.

    "recolher informação tabela kna1
    SELECT kunnr name1
      INTO TABLE lt_info_kna1
      from kna1.


      LOOP AT lt_info_proj into DATA(ls_info_proj).

        free: ls_project_list,
              ls_info_ihpa,
              ls_info_prps,
              ls_info_kna1.

        "meter ifens para melhor display do pep
        CONCATENATE ls_info_proj-pep(2) '-' ls_info_proj-pep+2(1) '-' ls_info_proj-pep+3(5) into data(lv_pep).
        ls_project_list-pep_recetor = lv_pep.

        "guarda valores necessarios da tabela proj
        ls_project_list-id_pep = ls_info_proj-id_pep.
        ls_project_list-name = ls_info_proj-nome.
        ls_project_list-start_date = ls_info_proj-start_date.
        ls_project_list-end_date = ls_info_proj-end_date.
        ls_project_list-project_profile = ls_info_proj-project_profile.
        ls_project_list-responsavel = ls_info_proj-responsavel.
        ls_project_list-createdon = ls_info_proj-createdon.
        ls_project_list-createdby = ls_info_proj-createdby.
        ls_project_list-updatedon = ls_info_proj-updatedon.
        ls_project_list-updatedby = ls_info_proj-updatedby.

        "define o scope do projeto (1-nacional | 2-internacional)
        IF ls_info_proj-pep+2(1) eq 'N'.
          ls_project_list-project_scope = '1'.

          ELSEIF ls_info_proj-pep+2(1) eq 'I'.
            ls_project_list-project_scope = '2'.

        ENDIF.

        "recolhe nº do cliente na tabela ipha através do nº do objeto da tabela proj
        READ TABLE lt_info_ihpa into ls_info_ihpa WITH KEY num_objeto = ls_info_proj-num_cliente.

        "recolhe nome do cliente na tabela KNA1 atraves do nº do mesmo presente na tabela ipha
        READ TABLE lt_info_kna1 INTO ls_info_kna1 WITH KEY num_cliente = ls_info_ihpa-cliente.

        "guarda nome do cliente
        ls_project_list-client = ls_info_kna1-nome_cliente.

        "recolhe tipo do projeto
        READ TABLE lt_info_prps into ls_info_prps WITH KEY ID_PEP = ls_info_proj-id_pep.

        "guarda tipo do projeto
        ls_project_list-projec_type = ls_info_prps-tipo_projeto.

        "adiciona valores da estrutura à tabela de exportação
        APPEND ls_project_list to et_project_list.

      ENDLOOP.

  ENDMETHOD.


  method GET_PROJECT_PROFILES.

    SELECT PROFIDPROJ PROFI_TXT
      INTO TABLE et_project_profiles
      from tcj4t
      WHERE spras = 'PT'.

  endmethod.


  METHOD GET_PROJECT_TYPES.

    SELECT prart pratx
      INTO TABLE et_project_types
      FROM tcj1t
      WHERE langu eq 'PT'.
  ENDMETHOD.
ENDCLASS.
