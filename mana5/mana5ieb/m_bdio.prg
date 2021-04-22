*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\ITAESBRA\M_BDIO.PRG
*+
*+    Functions: Function M_BDIO01()
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

//#INCLUDE "COMANDO.CH"
MDI( "Resumo Por Estados" )

if !CHECKIMP( 0 )
   retu .F.
endif

cTIPOCAN := "T"
cEMP     := IMP( "ZEMP" )
aCHA     := {}
aTOT     := {}
CTLIN    := 80
ZFOL     := 0
aUF   :={"AC","AL","AP","AM","BA","CE","DF","ES","GO",;
         "MA","MT","MS","MG","PA","PB","PR","PE","PI",;
         "RJ","RN","RS","RO","RR","SC","SP","SE","TO"}
aUFGIA:={"01","02","03","04","05","06","07","08","10",;
         "12","13","28","14","15","16","17","18","19",;
         "22","20","21","23","24","25","26","27","29"}
cAPUNEW:="S"

@ 22,00 say "Grupo (T)odos (C)anceladas (N)Цo Canceladas"
@ 23,00 SAY "Apurar CFO Novo"
@ 22,50 get cTIPOCAN pict "!" valid cTIPOCAN $ "TCN"
@ 23,20 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"
if !READCUR()
   retu .F.
endif

aRETU   := PERFEC( { "MM06", "MK06" }, { "M6", "K6" }, { "MM96", "MK96" } )
nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQSAI := aRETU[ 5, 1 ]
cARQENT := aRETU[ 5, 2 ]
CAB     := aRETU[ 7 ]

if MDG( "Apurar Entradas" )
   FILTRO := ""
   IF ! M_BDIO01( cARQENT )
      RETU .F.
   ENDIF
endif
if MDG( "Apurar Saidas" )
   FILTRO := ""
   IF ! M_BDIO01( cARQSAI )
      RETU .F.
   ENDIF
endif


if ! useMULT({{"APUCFOUF",0,99},{"MD04", 1, IF(cAPUNEW="S",2,3)}})
   dbclosearea()
ENDIF
DBSELECTAR("APUCFOUF")
ZAP
cCFO:=IF(cAPUNEW="N","CFO","CFONEW")
aCAM   := {"CONTABIL","BASE","VALOR","ISENTA",;
           "OUTRA","OBS","UF",cCFO,"DESCRICAO","UFGIA"}
nPOS := len( aCHA )
IMPRESSORA()
for X := 1 to nPOS
   if CTLIN > 55
      if CTLIN <> 80
         @ CTLIN,  0 say repl( '-', 230 )
      endif
      ZFOL ++
      @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
      @  1, 83  say CAB
      @  1, 97  say ZDATA
      @  1, 113 say left( time(), 5 )
      @  1, 128 say str( ZFOL, 4 )
      @  2,  0  say repl( "-", 132 )
      @  3,  2  say impchr(cIMPTIT) + cEMP + impchr(cIMPEXP)
      @  4, 00  say impchr(cIMPCOM) + repl( '-', 230 )
      @  5, 00  say 'CFO/UF.'
      @  5, 32  say 'Total da NF'
      @  5, 47  say 'Base ICM'
      @  5, 62  say 'Valor3 ICM'
      @  5, 77  say 'Isentas ICM'
      @  5, 92  say 'Outras ICM'
      @  5, 107 say 'OBS ICM'
      @  5, 122 say 'Base IPI'
      @  5, 137 say 'Valor IPI'
      @  5, 152 say 'Isentas IPI'
      @  5, 167 say 'Outras IPI'
      @  5, 182 say 'Obs IPI'
      CTLIN := 6
   endif
   @ CTLIN, 02  say aCHA[ X ]
   FOR Y=1 TO 11
      @ CTLIN, 17+(Y*15)  say aTOT[ X, Y ] pict '@E 99,999,999.99'
   NEXT Y
   CTLIN ++
   cDESC:=""
   dbselectar( "MD04" )
   dbgotop()
   if dbseek( aTOT[X,13] )
      cDESC := left( DESCRICAO, 45 )
   endif
   cUFGIA:="00"
   nPOSUF:=ASCAN(aUF,aTOT[X,12])
   IF nPOSUF>0
      cUFGIA:=aUFGIA[NPOSUF]
   ENDIF
   aVAL   := {aTOT[ X, 1 ],aTOT[ X, 2 ],aTOT[ X, 3 ],aTOT[ X, 4 ],;
               aTOT[ X, 5 ],aTOT[ X, 6 ],aTOT[X,12],aTOT[X,13],cDESC,cUFGIA}
   DBSELECTAR("APUCFOUF")
   netrecapp()
   GRAVACAMPO(aCAM,aVAL,,.F.,.F.,.F.)
next X
VIDEO()
IMPEND()


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function M_BDIO01()
*+
*+    Called from ( m_bdio.prg   )   2 -
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func M_BDIO01( cARQ )

FILTRO := RFILORD( cARQ, .F. )
if !USEMULT( { { cARQ, 1, 0 }, { "MA01", 1, 1 }, { "MB01", 1, 1 } } )
   retu .F.
endif
dbselectar( cARQ )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
IF cAPUNEW="N"
   ordDestroy("temp")
   ordcreate(,"temp","tipofor + str( fornecedo, 8 ) + dcfone")
   ordSetFocus("temp")   
ELSE
   ordDestroy("temp")
   ordcreate(,"temp","tipofor + str( fornecedo, 8 ) + doper")
   ordSetFocus("temp")
ENDIF
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
while !eof()
   @ 24, 00 say NUMERO
   @ 24, 10 SAY RECNO()
   nFORNECEDO := FORNECEDO
   nTIPO      := TIPOFOR
   cESTADO    := "ZZ"
   if nTIPO = "C"
      dbselectar( "MA01" )
      dbgotop()
      if dbseek( Nfornecedo )
         cESTADO := ESTADO
      endif
   endif
   if nTIPO = "F"
      dbselectar( "MB01" )
      dbgotop()
      if dbseek( NFornecedo )
         cESTADO := ESTADO
      endif
   endif
   dbselectar( cARQ )
   IF cESTADO ="ZZ"
      IF EMPTY(nTIPO)
         ALERTX("Tipo Nao Preenchido"+STR(nFORNECEDO))
      ELSE
         ALERTX("Cheque "+IF(nTIPO="C","Cliente","Fornecedor")+STR(nFORNECEDO))
      ENDIF
      ALERTX("Cadastro Estado-Ou Tipo Cliente Fornecedor na NF")
      ALERTX("NFЇ "+STR(NUMERO))
      IF ! MDG("Continuar Mesmo Assim")
          DBCLOSEALL()
          RETU .F.
      ENDIF
   ENDIF
   dbselectar( cARQ )
   while nTIPO = TIPOFOR .and. nFORNECEDO = FORNECEDO .and. !eof()
      cDOPER := IF(cAPUNEW="N",DOPER,DCFONEW)
      aVAL   := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,"","" }
      //12 Estado 13 CFO
      aCAM   := {"DVALORNF","DBASEICM","DVALICM","ISENTAICM",;
                 "OUTRAICM","OBSICM","DBASEIPI","DVALIPI",;
                 "ISENTAIPI","OUTRAIPI","OBSIPI"}
      while nTIPO = TIPOFOR .and. nFORNECEDO = FORNECEDO .and. cDOPER=IF(cAPUNEW="N",DOPER,DCFONEW) .and. !eof()
         if SOMACANCEL()
            FOR X=1 TO 11
                cCAMPO:=aCAM[X]
                aVAL[ X ] += &cCAMPO.
            NEXT X
         endif
         dbselectar( Carq )
         dbskip()
      enddo
      nPOS := ascan( aCHA, cDOPER + cESTADO )
      if nPOS > 0
         for X := 1 to 11
            aTOT[ nPOS, X ] += aVAL[ X ]
         next X
      else
         aVAL[12]=cESTADO
         aVAL[13]=cDOPER
         aadd( aCHA, cDOPER + cESTADO )
         aadd( aTOT, aVAL )
      endif
      dbselectar( cARQ )
   enddo
   dbselectar( cARQ )
enddo
dbcloseall()
RETU .T.

*+ EOF: M_BDIO.PRG
