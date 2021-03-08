*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\CLIPPER\FOLHA\PTO\FOPTO_2H.PRG
*+
*+    Reformatted by Click! 2.03 on May-6-2000 at  9:12 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

function fopto_2h
para lPER
IF ZFECHADO="S"
   ALERTX("Mes ja Fechado")
   RETU .F.
ENDIF
IF VALTYPE(lPER)#"L"
   lPER=.T.
ENDIF
CABE2( "FOPTO_2H - Lancar Ocorrencias - " + ANOMESW )
IF lPER
   if !MDG( "Lancar Ocorrencias" )
     retu .F.
   endif
ENDIF


//Ocorrencias entre meses proximo mes
nANOPRO:=ANOUSO
nMESPRO:=MESTRAB+1
IF nMESPRO=13
   nMESPRO:=1
   nANOPRO:=nANOPRO+1
ENDIF

cPRO := "PO" + right(STRZERO(nANOPRO,4),2) + strzero(NMESPRO,2)
CHECKCRI( cPRO, "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )


cPO := "PO" + ANOMESW
cPN := "PN" + ANOMESW

if ! NETUSE(cPO)
   retu .F.
endif
if ! NETUSE(cPN)
   dbcloseall()
   retu .F.
endif
if ! NETUSE(cPRO)
   dbcloseall()
   retu .F.
endif



dbselectar( cPO )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
dbgotop()
while !eof()
   mNUMERO := NUMERO
   dINI    := OCOINI
   dFIM    := OCOFIM
   mCOD    := OCOCOD
   mRED    := OCORED
   mBCO    := OCOBCO
   mFOL    := OCOFOL
   mEXT    := OCOEXT
   mSOD    := OCOSUB
   mALM    := OCOALM
   mMOT    := OCOMOT
   if empty( dFIM )
      dFIM := dINI
   endif



   fopto2h()
   IF DFIM>ZDATAFIM
      dbselectar( cPRO )
      dbgotop()
      if ! dbseek(STR(mNUMERO,8)+DTOS(dINI))
         netrecapp()
         field->NUMERO:=mNUMERO
         field->OCOINI:=dINI
       else
         netreclock()
      endif
      field->OCOFIM:=dFIM
      field->OCOCOD:=mCOD
      field->OCORED:=mRED
      field->OCOBCO:=mBCO
      field->OCOFOL:=mFOL
      field->OCOEXT:=mEXT
      field->OCOSUB:=mSOD
      field->OCOALM:=mALM
      field->OCOMOT:=mMOT
      dbunlock()
   ENDIF
   dbselectar( cPO )
   dbskip()
   zei_fort(nLASTREC,,,1)
enddo
dbcloseall()

func fopto2h(lZERCOD)
LOCAL dFIMTMP
IF VALTYPE(LZERCOD)#"L"
   lZERCOD:=.F.
ENDIF
dINITMP:=dINI       //So lanca as competencias
IF dINITMP<ZDATAINI
   dINITMP:=ZDATAINI
ENDIF
dFIMTMP:=dFIM
IF dFIMTMP>ZDATAFIM
   dFIMTMP:=ZDATAFIM
ENDIF
dbselectar( cPN )
for J := dINITMP to dFIMTMP
    @ 24,00 say str( mNUMERO, 8 ) +" - "+ dtoc( J )
    dbgotop()
    IF dbseek( str( mNUMERO, 8 ) + dtos( J ) )
       netreclock()
       if !empty( mCOD ).OR.lZERCOD
          field->COD := mCOD
       endif
       if !empty( mSOD )
          field->SOD := mSOD
       endif
       if !empty( mRED )
          field->REDSN := mRED
       endif
       if !empty( mBCO )
          field->BCOSN := mBCO
       endif
       if !empty( mFOL )
          field->FOLSN := mFOL
       endif
       if !empty( mALM )
          field->ALMOCO := mALM
       endif
       if !empty( mEXT )
          field->EXTSN := mEXT
       endif
       DBUNLOCK()
    endif
next
retuRN .t.

FUNCTION SomaPoCesta(mNUMERO)
LOCAL nRETU:=0
cALIAS:=ALIAS()
dbselectar(cPO)
dbgotop()
dbseek(STR(mNUMERO,8))
WHILE mNUMERO=NUMERO.AND. ! EOF()
    IF ABONA="C"
       nRETU+=HRABO
    ENDIF
    dbskip()
ENDDO
IF ! EMPTY(cALIAS)
   DBSELECTAR(cALIAS)
ENDIF
return nRETU

*+ EOF: FOPTO_2H.PRG
