*! usado em fo7a
*! usado em folis_d1


*!*****************************************************************************
*!
*!         Fun‡„o: CHECKFGTS
*!
*!*****************************************************************************
FUNCTION CHECKFGTS(dFGTS)
IF EMPTY(dFGTS)
   MDS(OBTER("FO_TAB",,"FGTS2    ","DESCRI"))
ELSE
   ALERTX("Data FGTS em branco")   
ENDIF
IF FGTS>=ADMITIDO
   MDS(OBTER("FO_TAB",,"FGTS1    ","DESCRI"))
else
   ALERTX("Data FGTS menor que admissao")   
ENDIF
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: CHECKCTPS
*!
*!*****************************************************************************

FUNCTION CHECKCTPS()
FIELD->PROFIS:=STRZERO(VAL(PROFIS),7)
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: CHECKSERIE
*!
*!*****************************************************************************
FUNCTION CHECKSERIE()
FIELD->SERIE:=STRZERO(VAL(SERIE),5)
RETU .T.



*!*****************************************************************************
*!
*!         Função: CHECKMOTDEM()
*!
*!*****************************************************************************
FUNCTION CHECKMOTDEM()   
IF EMPTY(RAISDEM)
   RAISDEM:=OBTER("FO_RCAU","",MOTIVO,"RAIS")
ENDIF
IF EMPTY(FGTSMOT)
   FGTSMOT:=OBTER("FO_RCAU","",MOTIVO,"CODGRE")
ENDIF
IF EMPTY(PGFGTS)
   PGFGTS:=OBTER("FO_RCAU","",MOTIVO,"PAGAFGTS")
ENDIF
IF EMPTY(MOTIVODEM)
   MOTIVODEM:=OBTER("FO_RCAU","",MOTIVO,"CAGED")
ENDIF
RETURN .T.

*!*****************************************************************************
*!
*!         Fun‡„o: CHECKADM
*!
*!*****************************************************************************
FUNC CHECKADM()
IF ADMITIDO-NASC>5110.AND.! EMPTY(NASC)
   RETU .T.
ENDIF
ALERTX("Funcionario Menor de 14 anos ???")
PRIV GETLIST:={}
MDS("Confirme Data Nascimento ")
@ 24,40 GET NASC
READCUR()
RETU .T.

FUNCTION FOSFAMQTDE(mNUMERO,cTIPO)
LOCAL nQTDE:=0
LOCAL cALIAS:=ALIAS()
IF ! NETUSE("FOSFAM") 
   RETURN .F.
ENDIF
IF VALTYPE(cTIPO)<>"C"
   cTIPO:="I"
ENDIF
dbgotop()
dbseek(STR(mNUMERO,8))
while mNUMERO=NUMERO .AND. ! EOF()
   IF cTIPO="I"
      IF FIELD->IRRF<>"N"
         nQTDE++
      ENDIF
   ENDIF   
   IF cTIPO="S"
      IF EMPTY(BAIXA) .and. ZDATA-FOSFAM->NASCTO>5114 
         netreclock()
         FOSFAM->BAIXA:=NASCTO+5114  //"S" //14anos*365 +4 dias anos Bissestos
         FOSFAM->SALFAM:="N"
         dbunlock()
      ENDIF   
      IF EMPTY(FOSFAM->BAIXA) .OR. FOSFAM->SALFAM<>"N"
         nQTDE++
      ENDIF
   ENDIF   
   dbskip()   
enddo
DBCLOSEAREA()
IF ! EMPTY(cALIAS)
   DBSELECTAR(cALIAS) 
ENDIF
RETURN nQTDE

