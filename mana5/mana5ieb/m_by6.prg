//#INCLUDE "COMANDO.CH"

MDI( " Ý Ficha do Produto Media Interna" )

nALPHA:=0.5
cMEDIA:="I"
cTIPMED:="A"

@ 19,00 SAY "Alpha"
@ 20,00 SAY "Tipo Calculo Media"
@ 21,00 SAY "(A)mostra (G)eral"
@ 23,00 SAY "Gravar Campo"
@ 24,00 SAY "(M)edia (1)Aux1 (2)Aux2 (I)nt"
@ 19,50 GET nALPHA
@ 21,50 GET cTIPMED VALID cTIPMED $ "AG"
@ 24,50 GET cMEDIA VALID cMEDIA $ "M12I"
IF ! READCUR()
   RETU .F.
ENDIF


aRETU   := PERFEC( { "MY03" }, { "Y3" }, { "Y399" }, { "DATOPR" } )
cARQ    := aRETU[ 5, 1 ]

if ! USEMULT( { { "MS06", 1, 1 }, { cARQ, 0, 99 },{"MY03MID",0,99} } )
   retu .F.
endif

dbselectar("MY03MID")
ZAP
MBY601(1)
MBY601(2)
dbselectar(cARQ)
dbclosearea()



DBSELECTAR("MS06")
DBGOTOP()
while ! eof()
   netreclock()
   DO CASE
      CASE cMEDIA="M"
           FIELD->PCHORMED:=0
      CASE cMEDIA="I"
           FIELD->PCHORAMD:=0
      CASE cMEDIA="1"
           FIELD->PCHORAX1:=0
      CASE cMEDIA="2"
           FIELD->PCHORAX2:=0
   ENDCASE
   dbunlock()
   dbskip()
enddo




dbselectar("MY03MID")
dbsetorder(2)
dbgotop()
while ! eof()
   @ 24,00 SAY RECNO()
   mCODIGO:=CODIGO
   mSEQ:=SEQ
   mSSQ:=SSQ
   nRECINI:=RECNO()
   nRECFIM:=RECNO()

   //Conta os Registro
   nCONTA:=0
   WHILE mCODIGO=CODIGO.AND.SEQ=mSEQ.AND.SSQ=mSSQ.AND.! EOF()
       @ 24,00 SAY RECNO()
       nCONTA++
       nRECFIM:=RECNO()
       dbskip()
   ENDDO
   nRECPAS:=RECNO()
   nREGAPA:=ROUND(nCONTA*nALPHA/2,0)

   //Marca Inciais
   nCONTA:=0
   DBGOTO(nRECINI)
   WHILE mCODIGO=CODIGO.AND.SEQ=mSEQ.AND.SSQ=mSSQ.AND.! EOF()
       @ 24,00 SAY RECNO()
       IF nCONTA=nREGAPA
          EXIT
       ENDIF
       nCONTA++
       FIELD->TIRADO:=.T.
       dbskip()
   ENDDO

   //Marca Finais
   nCONTA:=0
   DBGOTO(nRECFIM)
   WHILE mCODIGO=CODIGO.AND.SEQ=mSEQ.AND.SSQ=mSSQ.AND.! BOF()
       @ 24,00 SAY RECNO()
       IF nCONTA=nREGAPA
          EXIT
       ENDIF
       nCONTA++
       FIELD->TIRADO:=.T.
       dbskip(-1)
   ENDDO

   //Soma Nao Marcados
   nQTDDE :=0
   nHORAS:=0
   nCONTA:=0
   nMEDIA:=0
   DBGOTO(nRECINI)
   WHILE mCODIGO=CODIGO.AND.SEQ=mSEQ.AND.SSQ=mSSQ.AND.! EOF()
       @ 24,00 SAY RECNO()
       IF ! TIRADO
          nCONTA++
          nQTDDE+=QTDDE
          nMEDIA+=PCHORA
          nHORAS+=HORAS
       ENDIF
       dbskip()
   ENDDO

   //Grava Media
   IF nQTDDE>0.AND.nHORAS>0
      DBSELECTAR("MS06")
      DBGOTOP()
      IF DBSEEK(PADR(mCODIGO,24)+STR(mSEQ,3)+STR(mSSQ,3))
         netreclock()
         IF cTIPMED="G"
            DO CASE
               CASE cMEDIA="M"
                    FIELD->PCHORMED:=ROUND(nQTDDE/nHORAS,0)
               CASE cMEDIA="I"
                    FIELD->PCHORAMD:=ROUND(nQTDDE/nHORAS,0)
               CASE cMEDIA="1"
                    FIELD->PCHORAX1:=ROUND(nQTDDE/nHORAS,0)
               CASE cMEDIA="2"
                    FIELD->PCHORAX2:=ROUND(nQTDDE/nHORAS,0)
            ENDCASE
         ENDIF
         IF cTIPMED="A"
            DO CASE
               CASE cMEDIA="M"
                    FIELD->PCHORMED:=ROUND(nMEDIA/nCONTA,0)
               CASE cMEDIA="I"
                    FIELD->PCHORAMD:=ROUND(nMEDIA/nCONTA,0)
               CASE cMEDIA="1"
                    FIELD->PCHORAX1:=ROUND(nMEDIA/nCONTA,0)
               CASE cMEDIA="2"
                    FIELD->PCHORAX2:=ROUND(nMEDIA/nCONTA,0)
            ENDCASE
         ENDIF
         DBUNLOCK()
      ENDIF
   ENDIF

   dbselectar("MY03MID")
   DBGOTO(nRECPAS)
enddo
dbcloseall()


Function MBY601(nPASSO)
dbselectar( cARQ )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
MDS("Criando Indices")
IF nPASSO=1
   ordDestroy("temp")
   ordcreate(,"temp","codigo+str(seq,3)+str(ssq,3)")
   ordSetFocus("temp")
ELSE
   ordDestroy("temp")
   ordcreate(,"temp","codig2+str(seq,3)+str(ssq,3)")
   ordSetFocus("temp")  
ENDIF
MDS("")
@ 24,60 SAY nPASSO
dbgotop()
while ! eof()
   @ 24,00 SAY RECNO()
   WHILE (EMPTY(IF(nPASSO=1,CODIGO,CODIG2)).OR.SSQ=99.OR.CODMAQ="TER".OR.SEQ=0.OR.SSQ=0).AND.! EOF()
       @ 24,00 SAY RECNO()
       DBSKIP()
   ENDDO
   cCODIGO:=IF(nPASSO=1,CODIGO,CODIG2)
   mCODIGO := cCODIGO
   mSEQ    := SEQ
   mSSQ    := SSQ
   mDATAINI:= CTOD(SPACE(8))
   DBSELECTAR("MS06")
   DBGOTOP()
   IF DBSEEK(PADR(cCODIGO,24)+STR(mSEQ,3)+STR(mSSQ,3))
      mDATAINI:=DATAINI
   ENDIF
   DBSELECTAR(cARQ)
   WHILE mCODIGO=IF(nPASSO=1,CODIGO,CODIG2).AND.SEQ=mSEQ.AND.SSQ=mSSQ.AND.! EOF()
      @ 24,00 SAY RECNO()
      IF ! EMPTY(mDATAINI).OR.DATOPR>=mDATAINI
         mHORAS  := CHOR( FIMOPR + if( VIRADA = "S", 24, 0 ) ) - CHOR( INIOPR ) - PARADA - ( CHOR( ALMFIM ) - CHOR( ALMINI ) )
         mQTDDE  := QTDDE
         mDATOPR := DATOPR
         mHORAS  := round( mHORAS, 2 )
         mTIRADO := .F.
         mPCHORA := 0
         mINIOPR := INIOPR
         mFIMOPR := FIMOPR
         mPARADA := PARADA
         IF mQTDDE>0.AND.mHORAS>0
            mPCHORA :=ROUND(mQTDDE/mHORAS,0)
         ENDIF
         IF mPCHORA>1.AND.BXMY03#"N"
            IF ! EMPTY(mCODIGO)
               NOVOOPA( "MY03MID" )
            ENDIF
         ENDIF
      ENDIF
      dbselectar( cARQ )
      dbskip()
   ENDDO
   dbselectar( cARQ )
enddo


*+ EOF: M_BY3.PRG
