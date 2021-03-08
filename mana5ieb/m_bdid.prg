*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_BDID.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

//#INCLUDE "COMANDO.CH"


//Modo de Trabalho no Video
MDI( " þ Imprimir Relat?io Checagem DIPI ")
if !CHECKIMP( 0 )
   retu
endif
cEMP   := IMP( "ZEMP" )
cRESET := IMP( "RESET" )

cAPUNEW:="S"
cCABAUX := space( 40 )
cTIPOCAN :="T"
aRETU := PERFEC( {"MK02","MK06","MM02","MM06" }, {"K2", "K6","M2", "M6" }, {"MK92", "MK96", "MM92","MM96" } )


@ 21,00 SAY  "Informe Cabe‡ario Auxiliar"
@ 22,00 SAY "Grupo (T)odos (C)anceladas (N)? Canceladas"
@ 23,00 SAY "Apurar CFO Novo"
@ 21,30  get cCABAUX
@ 22,45 get cTIPOCAN PICT "!" VALID cTIPOCAN $ "TCN"
@ 23,40 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"
if !READCUR()
   retu .F.
endif


nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQENT := aRETU[5,1]
cARQEN2 := aRETU[5,2]
cARQSAI := aRETU[5,3]
cARQSA2 := aRETU[5,4]
cVAR    := aRETU[ 7 ]


lRESNF   := MDG( "Deseja Resumo Classifica‡„o NF" )
lRESDIPI := MDG( "Deseja Resumo Classifica‡„o DIPI" )
lXNFDIPI := MDG( "Deseja Resumo NF x DIPI" )
lXDIPINF := MDG( "Deseja Resumo DIPI x NF" )
lRESVAL  := MDG( "Deseja Resumo Soma Valores x Contabil" )


IF MDG("Listar Entrada")
   M_BDID01(cARQENT,cARQEN2,"E")
ENDIF
IF MDG("Listar Saida")
   M_BDID01(cARQSAI,cARQSA2,"S")
ENDIF
IMPEND()


FUNC M_BDID01(ARQWORK,ARQWOR2,Ctipo)
ZFOL  := 0
CTLIN := 80
if ! USEMULT({{ARQWOR2, 1, 99},{ARQWORK, 1,99 }})
   retu
endif
dbselectar( ARQWORK )
dbsetorder(4) //Numero da Nota
nLAST01:=LASTREC()
dbselectar( ARQWOR2 )
dbsetorder(3) //Numero da Nota
nLAST02:=LASTREC()

IMPRESSORA()
if lRESNF
   VIDEO()
   MDS("Resumo Operacao Classificacao NF")
   IMPRESSORA()
   dbselectar( ARQWORK )
   dbgotop()
   while !eof()
      if empty(IF(cAPUNEW="S",CFONEW,OPERACAO) ) .or. empty( CLASSIPI ).AND.SOMACANCEL()
         M_BDID02("Numero   CFO     Classipi" + spac( 7 ) + "Valor Total" + spac( 8 ) + "Valor Mercadora    Valor Ipi")
         @ CTLIN,  0 say if( cTIPO= "S", NUMERO, NRNOTA ) picture '99999999'
         @ CTLIN,  9 say IF(cAPUNEW="S",ALLTRIM(CFONEW)+IF(EMPTY(CFONEWB),"","/"+CFONEWB),OPERACAO)
         @ CTLIN, 19 say CLASSIPI
         @ CTLIN, 34 say VALORTOT                               picture '@E 9999,999.99'
         @ CTLIN, 50 say VALORMER                               picture '@E 9999,999.99'
         @ CTLIN, 64 say VALORIPI                               picture '@E 9999,999.99'
         CTLIN ++
      endif
      dbselectar( ARQWORK )
      dbskip()
      video()
      zei_fort(nLAST01)
      impressora()
   enddo
   IMPFOL()
endif
if lRESDIPI
   VIDEO()
   MDS("Resumo Operacao Classificacao DIPI")
   IMPRESSORA()
   CTLIN := 80
   dbselectar( ARQWOR2 )
   dbgotop()
   while !eof()
      if empty( IF(cAPUNEW="N",DOPER,DCFONEW) ) .or. empty( DCLASSIPI ).AND.SOMACANCEL()
         M_BDID02("Numero   CFO     Classipi" + spac( 7 ) + "Valor Total" + spac( 8 ) + "Valor Mercadora    Valor Ipi")
         @ CTLIN,  0 say NUMERO picture '99999999'
         @ CTLIN,  9 say IF(cAPUNEW="N",DOPER,DCFONEW)
         @ CTLIN, 17 say DCLASSIPI
         @ CTLIN, 32 say DVALORNF  picture '@E 999,999,999.99'
         @ CTLIN, 62 say DVALIPI   picture '@E 999,999,999.99'
         CTLIN ++
      endif
      dbselectar( ARQWOR2 )
      dbskip()
      video()
      zei_fort(nLAST02)
      impressora()
   enddo
   IMPFOL()
endif
if lXNFDIPI
   VIDEO()
   MDS("Resumo Cruzamento NFxDIPI")
   IMPRESSORA()
   CTLIN := 80
   dbselectar( ARQWORK )
   dbgotop()
   while !eof()
      mNUMERO := if( cTIPO = "S", NUMERO, NRNOTA )
      dbselectar( ARQWOR2 )
      dbgotop()
      IF ! dbseek( mNUMERO )
         M_BDID02("")
         @ CTLIN, 00 say "Nota " + str( mNUMERO ) + ACENTO( " N„o Esta na Dipi " ) + cVAR
         CTLIN ++
      endif
      dbselectar( ARQWORK )
      while if( cTIPO = "S", NUMERO, NRNOTA ) = mNUMERO .and. !eof()
         dbskip()
      enddo
      video()
      zei_fort(nLAST01)
      impressora()
   enddo
   IMPFOL()
endif
IF lRESVAL
   VIDEO()
   MDS("Resumo Base x Valores")
   IMPRESSORA()
   CTLIN := 80
   dbselectar( ARQWOR2 )
   set filter to
   dbgotop()
   while ! eof()
      nVALDIF:=DVALORNF-(DBASEIPI+DVALIPI+OUTRAIPI+OBSIPI+ISENTAIPI)
      IF (nVALDIF<=-0.01).OR.(nVALDIF>=0.01).AND.SOMACANCEL()
         M_BDID02("")
         @ CTLIN, 00 say "Nota " + str( NUMERO,8 )+"."+STR(ITEM,3)+" Valores Nao Conferem"
         CTLIN ++
         @ CTLIN, 00 say DVALORNF  picture '@E 9999999.99'
         @ CTLIN, 11 say DBASEIPI  picture '@E 9999999.99'
         @ CTLIN, 22 say DVALIPI   picture '@E 9999999.99'
         @ CTLIN, 33 say OUTRAIPI  picture '@E 9999999.99'
         @ CTLIN, 44 say ISENTAIPI picture '@E 9999999.99'
         @ CTLIN, 55 say OBSIPI    picture '@E 9999999.99'
         @ CTLIN, 66 SAY nVALDIF picture '@E 9999999.99'
         CTLIN ++
      ENDIF
      dbskip()
      video()
      zei_fort(nLAST02)
      impressora()
   enddo
   IMPFOL()
ENDIF
if lXDIPINF
   VIDEO()
   MDS("Resumo Cruzamento DIPIxNF")
   IMPRESSORA()
   CTLIN := 80
   dbselectar( ARQWOR2 )
   set filter to
   dbgotop()
   while !eof()
      mNUMERO :=  NUMERO
      dbselectar( ARQWORK )
      dbgotop()
      IF ! dbseek( mNUMERO )
         M_BDID02("")
         @ CTLIN, 00 say "Nota " + str( mNUMERO ) + ACENTO( " N„o Esta na NF " ) + cVAR
         CTLIN ++
      endif
      dbselectar( ARQWOR2 )
      while  NUMERO = mNUMERO .and. !eof()
         dbskip()
      enddo
      video()
      zei_fort(nLAST02)
      impressora()
   enddo
endif
dbcloseall()
VIDEO()

FUNC M_BDID02(cDIZ)
if CTLIN > 55
  if CTLIN <> 80 .and. CTLIN < 60
     @ CTLIN,  0 say repl( '-', 80 )
  endif
  ZFOL ++
  @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S  REF.:"+cVAR+" DATA:" + DTOC(ZDATA) + " HORA:" + LEFT(TIME(),5) + " F.:"+str( ZFOL, 4 )
  @  2, 01  say 'DIPI-D Checagem Nota Fiscal '+cEMP
  @  3, 20  say cCABAUX
  CTLIN:=4
  IF ! EMPTY(cDIZ)
     @  CTLIN,  0  say cDIZ
     CTLIN++
  ENDIF
  @ CTLIN, 00  say repl( '-', 80 )
  CTLIN++
endif

*+ EOF: M_BDID.PRG
