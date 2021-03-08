*+行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行
*+
*+    Source Module => C:\CLIPPER\FOLHA\PTO\FOPTO_2I.PRG
*+
*+    Reformatted by Click! 2.03 on May-6-2000 at  9:12 pm
*+
*+行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行行

function fopto_2i
para lPER
IF ZFECHADO="S"
   ALERTX("Mes ja Fechado")
   RETU .F.
ENDIF
IF VALTYPE(lPER)#"L"
   lPER=.T.
ENDIF
CABE2( "FOPTO_2I - Lancar Horarios Avulsos - " + ANOMESW )
IF lPER
   if !MDG( "Lancar Horarios Avulsos" )
      retu .F.
   endif
ENDIF

cPM := "PM" + ANOMESW
cPN := "PN" + ANOMESW
cPD := "PD" + ANOMESW



if ! NETUSE(cPM)
   retu .F.
endif
if ! NETUSE(cPN)
   dbcloseall()
   retu .F.
endif
if ! NETUSE(cPD)
   dbcloseall()
   retu .F.
endif
if ! NETUSE("AFDTERR")
   dbcloseall()
   retu .F.
endif
if ! NETUSE(PES)
   dbcloseall()
   retu .F.
endif


dbselectar( cPM )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
dbgotop()
while !eof()
   mNUMERO := NUMERO
   mPIS    :=''
   dbselectar(pes)
   dbgotop()   
   if dbseEK(mNUMERO)
      mPIS:=PIS
   endif
   dbselectar( cPM )
   dDAT    := DATOCO
   tOCO    := TIPOCO
   hOCO    := HOROCO
   hOC2    := HOROC2
   hOC3    := HOROC3
   hOC4    := HOROC4
   cZER    := IF(TYPE("ZERHOR")="C",ZERHOR," ") //zerhor competencia antigas
   dbselectar( cPN )
   dbgotop()
   if dbseek( str( mNUMERO, 8 ) + dtos( dDAT ) )
      netreclock()
      IF (tOCO = "E".OR.tOCO="T").AND.! EMPTY(hOCO)
          field->ENT := hOCO
          field->MUDENT:="*"
      ENDIF
      IF (tOCO = "1".OR.tOCO="T").AND.! EMPTY(hOC2)
          field->ALS := hOC2
          field->MUDALS:="*"
      ENDIF
      IF (tOCO = "2".OR.tOCO="T").AND.! EMPTY(hOC3)
          field->ALE := hOC3
          field->MUDALE:="*"
      ENDIF
      IF (tOCO = "N".OR.tOCO = "S".OR.tOCO="T").AND.! EMPTY(hOC4)
          field->SAI := hOC4
          field->MUDSAI:="*"
      endIF
      if empty( hOCO ) .and. cZER = "S"
         do case
         case tOCO = "E"
            field->ENT := 0
            field->MUDENT:="*"
         case tOCO = "S".OR.tOCO = "N"
            field->SAI := 0
            field->MUDSAI:="*"
         case tOCO = "1"
            field->ALS := 0
            field->MUDALS:="*"
         case tOCO = "2"
            field->ALE := 0
            field->MUDALE:="*"
         case tOCO = "T"
            field->ENT:= 0
            field->ALS:= 0
            field->ALE:= 0
            field->SAI:= 0
            field->MUDENT:="*"
            field->MUDALS:="*"
            field->MUDALE:="*"
            field->MUDSAI:="*"
         endcase
      endif
      DBUNLOCK()
   endif   
   IF (tOCO = "E".OR.tOCO="T").AND.! EMPTY(hOCO)
      dbselectar(cPD)
      dbgotop()
      if ! dbseek( str( mNUMero, 8 ) + dtos( ddat ) + str( hOCO, 5, 2 ) )
          netrecapp()
          field->NUMERO:=mNUMERO
          FIELD->DATA:=dDAT
          FIELD->HORA:=hOCO
          FIELD->TIPOM  :="E"
          FIELD->TIPOR  :="I"
          IF ! EMPTY(mpIS)
             FIELD->PIS    :=mPIS
          ENDIF   
      endif       
   ENDIF
   //IF (tOCO = "1".OR.tOCO="T").AND.! EMPTY(hOC2)
   //ENDIF
   //IF (tOCO = "2".OR.tOCO="T").AND.! EMPTY(hOC3)
   //ENDIF
   IF (tOCO = "S".OR.tOCO="T".OR.tOCO="N").AND.! EMPTY(hOC4)
      IF tOCO="N"      //para efeito relogio saida noturno tem que
         dDAT++
      ENDIF
      dbselectar(cPD)
      dbgotop()
      if ! dbseek( str( mNUMero, 8 ) + dtos( ddat ) + str( hOC4, 5, 2 ) )
          netrecapp()
          field->NUMERO:=mNUMERO
          FIELD->DATA:=dDAT
          FIELD->HORA:=hOC4
          FIELD->TIPOM  :="S"
          FIELD->TIPOR  :="I"
          IF ! EMPTY(mpIS)
             FIELD->PIS    :=mPIS
          ENDIF   
      endif     
   endIF      
   dbselectar( cPM )
   dbskip()
   zei_fort(nLASTREC,,,1)
enddo
dbselectar("AFDTERR")
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
dbgotop()
while ! eof()
  mCHAVE:=str( NUMero, 8 ) + dtos( DATA ) + str( HORA, 5, 2 )
  mNUMERO=NUMERO
  mDATA  =DATA
  mHORA  =HORA
  IF ! EMPTY(MOTOCO)
      dbselectar(cPD)
      dbgotop()
      if dbseek(mCHAVE)
         netreclock()
         field->numero:=mNUMERO
         field->data  :=mDATA
         field->hora  :=mHORA     
         field->TIPOM :="D"
      ENDIF
  ENDIF    
  dbselectar("AFDTERR")
  dbskip()
  zei_fort(nLASTREC,,,1)
enddo
dbcloseall()

*+ EOF: FOPTO_2I.PRG
