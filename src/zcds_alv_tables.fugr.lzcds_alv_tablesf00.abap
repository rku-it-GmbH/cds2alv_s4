*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZMCDSALVPROGRAM.................................*
FORM GET_DATA_ZMCDSALVPROGRAM.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZCDS_ALV_PROGRAM WHERE
(VIM_WHERETAB) .
    CLEAR ZMCDSALVPROGRAM .
ZMCDSALVPROGRAM-CDS_VIEW =
ZCDS_ALV_PROGRAM-CDS_VIEW .
ZMCDSALVPROGRAM-PROGNAME =
ZCDS_ALV_PROGRAM-PROGNAME .
ZMCDSALVPROGRAM-DYNPRO =
ZCDS_ALV_PROGRAM-DYNPRO .
ZMCDSALVPROGRAM-AUTHOR =
ZCDS_ALV_PROGRAM-AUTHOR .
ZMCDSALVPROGRAM-GENERATED_AT =
ZCDS_ALV_PROGRAM-GENERATED_AT .
ZMCDSALVPROGRAM-NO_GENERATION =
ZCDS_ALV_PROGRAM-NO_GENERATION .
ZMCDSALVPROGRAM-ADD_FUNC_DISPLAY_MODE =
ZCDS_ALV_PROGRAM-ADD_FUNC_DISPLAY_MODE .
<VIM_TOTAL_STRUC> = ZMCDSALVPROGRAM.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZMCDSALVPROGRAM .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZMCDSALVPROGRAM.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZMCDSALVPROGRAM-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZCDS_ALV_PROGRAM WHERE
  CDS_VIEW = ZMCDSALVPROGRAM-CDS_VIEW .
    IF SY-SUBRC = 0.
    DELETE ZCDS_ALV_PROGRAM .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZCDS_ALV_PROGRAM WHERE
  CDS_VIEW = ZMCDSALVPROGRAM-CDS_VIEW .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZCDS_ALV_PROGRAM.
    ENDIF.
ZCDS_ALV_PROGRAM-CDS_VIEW =
ZMCDSALVPROGRAM-CDS_VIEW .
ZCDS_ALV_PROGRAM-PROGNAME =
ZMCDSALVPROGRAM-PROGNAME .
ZCDS_ALV_PROGRAM-DYNPRO =
ZMCDSALVPROGRAM-DYNPRO .
ZCDS_ALV_PROGRAM-AUTHOR =
ZMCDSALVPROGRAM-AUTHOR .
ZCDS_ALV_PROGRAM-GENERATED_AT =
ZMCDSALVPROGRAM-GENERATED_AT .
ZCDS_ALV_PROGRAM-NO_GENERATION =
ZMCDSALVPROGRAM-NO_GENERATION .
ZCDS_ALV_PROGRAM-ADD_FUNC_DISPLAY_MODE =
ZMCDSALVPROGRAM-ADD_FUNC_DISPLAY_MODE .
    IF SY-SUBRC = 0.
    UPDATE ZCDS_ALV_PROGRAM ##WARN_OK.
    ELSE.
    INSERT ZCDS_ALV_PROGRAM .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZMCDSALVPROGRAM-UPD_FLAG,
STATUS_ZMCDSALVPROGRAM-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZMCDSALVPROGRAM.
  SELECT SINGLE * FROM ZCDS_ALV_PROGRAM WHERE
CDS_VIEW = ZMCDSALVPROGRAM-CDS_VIEW .
ZMCDSALVPROGRAM-CDS_VIEW =
ZCDS_ALV_PROGRAM-CDS_VIEW .
ZMCDSALVPROGRAM-PROGNAME =
ZCDS_ALV_PROGRAM-PROGNAME .
ZMCDSALVPROGRAM-DYNPRO =
ZCDS_ALV_PROGRAM-DYNPRO .
ZMCDSALVPROGRAM-AUTHOR =
ZCDS_ALV_PROGRAM-AUTHOR .
ZMCDSALVPROGRAM-GENERATED_AT =
ZCDS_ALV_PROGRAM-GENERATED_AT .
ZMCDSALVPROGRAM-NO_GENERATION =
ZCDS_ALV_PROGRAM-NO_GENERATION .
ZMCDSALVPROGRAM-ADD_FUNC_DISPLAY_MODE =
ZCDS_ALV_PROGRAM-ADD_FUNC_DISPLAY_MODE .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZMCDSALVPROGRAM USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZMCDSALVPROGRAM-CDS_VIEW TO
ZCDS_ALV_PROGRAM-CDS_VIEW .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZCDS_ALV_PROGRAM'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZCDS_ALV_PROGRAM TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZCDS_ALV_PROGRAM'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*

* base table related FORM-routines.............
INCLUDE LSVIMFTX .
