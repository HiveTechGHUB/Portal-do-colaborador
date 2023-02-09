interface ZAH_I_DIFFERENT_METHODS
  public .


  methods GET_CALENDAR
    importing
      !IT_COMP_EMPS type ZAH_TT_COMPANY
    exporting
      !ET_CALENDAR type ZAH_TT_CALENDAR .
endinterface.
