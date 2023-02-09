class ZAH_CL_CONT_AUSENCIAS definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods GET_CONT_AUSENCIAS
    exporting
      !ET_CONT_AUSENCIAS type ZAH_TT_CONT_AUS_RETURN
    changing
      !CT_NUM_EMP type ZAH_TT_NUM_EMP .
  methods READ_INFTY_0001
    importing
      !IV_NUM_EMP type PERNR_D
    exporting
      !ES_INFTY_0001 type P0001 .
protected section.
private section.

  data GT_T556A type ZAH_TT_T556A .
  data GT_T556B type ZAH_TT_T556B .
  data GT_T538T type ZAH_TT_T538T .
  data GT_T001P type ZAH_TT_T001P .
  data GT_T503 type ZAH_TT_T503 .
  class-data GC_COD_PT type SPRAS value 'PT' ##NO_TEXT.
  data GS_T556A type T556A .
  data GS_T556B type T556B .
  data GS_T538T type T538T .
  data GS_T001P type T001P .
  data GS_T503 type T503 .

  methods GET_COLAB_CONTINGENTE
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_CONT_AUSENCIAS type ZAH_TT_CONT_AUS_RETURN .
ENDCLASS.



CLASS ZAH_CL_CONT_AUSENCIAS IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

*--------------------------------------------------
*recolhe os dados das tabelas ausiliares: T556A, T556B, T538T, T001P, T503
*--------------------------------------------------

*--------------------------------------------------
*T556A: Tipo de contingente de ausências e codigo da unidade de tempo
*--------------------------------------------------

    SELECT *
      FROM t556a
      INTO TABLE gt_t556a.

*--------------------------------------------------
*T556B: Textos do tipo de contingente de ausências
*--------------------------------------------------

    SELECT *
      FROM t556b
      INTO TABLE gt_t556b
      WHERE sprsl = gc_cod_pt.

*--------------------------------------------------
*T538t: Textos da unidade de tempo
*--------------------------------------------------

    SELECT *
      FROM t538t
      INTO TABLE gt_t538t
      WHERE sprsl = gc_cod_pt.

*--------------------------------------------------
*T001P: Áreas/subáreas HR
*--------------------------------------------------

    SELECT *
      FROM t001p
      INTO TABLE gt_t001p.

*--------------------------------------------------
*T503: Grp./subgrp.empregados
*--------------------------------------------------

    SELECT *
      FROM t503
      INTO TABLE gt_t503.

  ENDMETHOD.


  METHOD get_colab_contingente.

    CONSTANTS: lc_2006 TYPE infty VALUE '2006'.

    DATA: lt_infty_2006      TYPE TABLE OF p2006,

          ls_infty_0001      TYPE p0001,

          ls_cont_ausencias  TYPE zah_s_cont_ausencias,   "estrutura para os contingentes de ausência

          ls_cont_aus_return TYPE zah_s_cont_aus_return.  "estrutura para retorno dos contingentes de ausência dos colaboradores


*percorre todos os colaboradores e lê os contingentes de ausências
    LOOP AT it_num_emp INTO DATA(ls_num_emp).

*     limpar variáveis, estruturas e tabelas
      FREE: lt_infty_2006 ,ls_cont_aus_return, gs_t001p, gs_t503.

*--------------------------------------------------
*lê o infotipo 0001
*--------------------------------------------------

      read_infty_0001(
        EXPORTING
          iv_num_emp    = ls_num_emp-num_emp     " Nº pessoal
        IMPORTING
          es_infty_0001 = ls_infty_0001      " Registro mestre HR: infotipo 0001 (atrib.org.)
      ).

*--------------------------------------------------
*lê a tabela T001P para obter o Agrupamento SA recursos humanos p/tps.contingente tempos do colaborador
*--------------------------------------------------

      READ TABLE gt_t001p INTO gs_t001p WITH KEY werks = ls_infty_0001-werks btrtl = ls_infty_0001-btrtl. "filtra por Área e subárea de HR

*--------------------------------------------------
*lê a tabela T503 para obter o Agrupamento subgrupos empregados p/tipos contingente tempos do colaborador
*--------------------------------------------------

      READ TABLE gt_t503 INTO gs_t503 WITH KEY persg = ls_infty_0001-persg persk = ls_infty_0001-persk. "filtra por grupo e subgrupo de empregados

*--------------------------------------------------
*recolhe os contingentes do infotipo 2006
*--------------------------------------------------

      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          pernr     = ls_num_emp-num_emp  "nº colaborador
          infty     = lc_2006   "infotipo 2006
          begda     = sy-datum
*         ENDDA     = '99991231'
        TABLES
          infty_tab = lt_infty_2006.

*--------------------------------------------------
*se o colaborador tiver contingentes vai ler as tabelas de descrições e adicionar á estrutura
*--------------------------------------------------

*percorre a tabela de contingentes do colaborador
      LOOP AT lt_infty_2006 INTO DATA(ls_infty_2006).


*     limpar variáveis, estruturas e tabelas
        FREE: gs_t538t, gs_t556a, gs_t556b, ls_cont_ausencias.

*--------------------------------------------------
*lê a tabela da descrição do tipo de contingente e adiciona a descrição á estrutura
*--------------------------------------------------

        READ TABLE gt_t556b INTO gs_t556b
          WITH KEY sprsl = gc_cod_pt    "codigo de idioma
          mopgk = gs_t503-konty         "Agrupamento subgrupos empregados p/tipos contingente tempos
          mozko = gs_t001p-mozko        "Agrupamento SA recursos humanos p/tps.contingente tempos
          ktart = ls_infty_2006-ktart.  "tipo de contingente

        ls_cont_ausencias-tipo_contigente = gs_t556b-ktext.   "texto do tipo de contingente

*--------------------------------------------------
*lê a tabela da unidade de tempo
*--------------------------------------------------

        READ TABLE gt_t556a INTO gs_t556a
          WITH KEY mopgk = gs_t503-konty  "Agrupamento subgrupos empregados p/tipos contingente tempos
          mozko = gs_t001p-mozko          "Agrupamento SA recursos humanos p/tps.contingente tempos
          ktart = ls_infty_2006-ktart.    "tipo de contingente

*--------------------------------------------------
*lê a tabela da descrição da unidade de tempo e adiciona a descrição á estrutura
*--------------------------------------------------

        READ TABLE gt_t538t INTO gs_t538t
          WITH KEY sprsl = gc_cod_pt  "codigo de idioma
          zeinh = gs_t556a-zeinh.     "unidade de tempo

        ls_cont_ausencias-unidade_tempo = gs_t538t-etext.   "texto da unidade de tempo

*--------------------------------------------------
*adiciona os restantes dados do infotipo 2006 á estrutura
*--------------------------------------------------

        ls_cont_ausencias-num_contigente = ls_infty_2006-anzhl.   "numero de contingentes


        ls_cont_ausencias-inicio_deducao = ls_infty_2006-desta.   "data de inicio da dedução de contingente


        ls_cont_ausencias-fim_deducao = ls_infty_2006-deend.   "data de fim da dedução de contingente


*adiciona a estrutura dos contingentes á tabela
        APPEND ls_cont_ausencias TO ls_cont_aus_return-contingentes.

        FREE ls_infty_2006.

      ENDLOOP.


*se o colaborador tiver contingentes
      IF ls_cont_aus_return-contingentes IS NOT INITIAL.

*adiciona o numero de colaborador á estrutura de retorno
        ls_cont_aus_return-num_emp = ls_num_emp-num_emp.

*adiciona a estrutura á tabela de retorno
        APPEND ls_cont_aus_return TO et_cont_ausencias.

      ENDIF.

      FREE ls_num_emp.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_cont_ausencias.

    sy-datum = '20090102'.

*--------------------------------------------------
*recolhe todos os colaboradores ativos
*ou
*verifica se os colaboradores inseridos estão ativos
*--------------------------------------------------

    zah_i_common_methods~validate_num_emp(
      EXPORTING
        it_num_emp           = ct_num_emp    " tabela de importação/exportação do número de colaborador
      IMPORTING
        et_num_emp_validated = DATA(lt_num_emp)     " tabela de importação/exportação do número de colaborador
    ).

*--------------------------------------------------
*recolhe os contingentes do infotipo 2006
*--------------------------------------------------

    get_colab_contingente(
      EXPORTING
        it_num_emp        = lt_num_emp    " tabela de importação/exportação do número de colaborador
      IMPORTING
        et_cont_ausencias = et_cont_ausencias     " Tabela para retorno dos contingentes de ausência
    ).


  ENDMETHOD.


  METHOD read_infty_0001.

    CONSTANTS: lc_infty_0001 TYPE infty VALUE '0001'.

    DATA: lt_infty_0001 TYPE TABLE OF p0001.

    CALL FUNCTION 'HR_READ_INFOTYPE'
      EXPORTING
        pernr     = iv_num_emp
        infty     = lc_infty_0001
        begda     = sy-datum
        endda     = sy-datum
      TABLES
        infty_tab = lt_infty_0001.

    READ TABLE lt_infty_0001 INTO es_infty_0001 INDEX 1.

  ENDMETHOD.
ENDCLASS.
