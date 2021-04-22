*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+    Source Module => J:\ITAESBRA\M_BDIC.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ

//#INCLUDE "COMANDO.CH"

function m_bdic
para cARQPRI, cARQACU, cCARREF, cCABREF

//Modo de Trabalho no Video
MDI( " Ý Imprimir Relat¢rio de Classifica‡ao ")

cZEMP   := IMP( "ZEMP" )
cEMP := IMP( "ZEMP" )


if ! CHECKIMP( 0 )
   retu .F.
endif

cCABAUX  := space( 40 )
cTIPOCAN := "T"
@ 22, 00 say "Cabe‡ario Aux."
@ 23, 00 say "Grupo (T)odos (C)anceladas (N)Æo Canceladas"
@ 24,00 SAY "Apurar CFO Novo"
@ 22,20 get cCABAUX
@ 23,50 get cTIPOCAN PICT "!" VALID cTIPOCAN $ "TCN"
@ 24,40 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"
if !READCUR()
   retu .F.
endif



aRETU   := PERFEC( { "MM02", "MK02" }, { "M2", "K2" }, { "MM92", "MK92" } )
MES     := aRETU[ 1 ]
ANO     := aRETU[ 2 ]
cARQSAI := aRETU[ 5, 1 ]
cARQENT := aRETU[ 5, 2 ]
cVAR    := aRETU[ 7 ]



if MDG( "Entradas" )
   M_BDIC01( cARQENT, "Classifica‡Æo Fisal - Nota Fiscal de Entradas" ,"E")
endif
if MDG( "Saidas" )
   M_BDIC01( cARQSAI, "Classifica‡Æo Fiscal - Nota Fiscal de Saidas" ,"S")
endif
VIDEO()
IMPEND()


FUNC m_BDIC01(ARQWORK,cCABREF,cTIPO)
CTLIN  := 80
ZFOL   := 0
FILTRO := ''
FILTRO := RFILORD( ARQWORK, .F. )
if !USEREDE( ARQWORK, 1, 0 )
   retu
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
IF cAPUNEW="N"
   ordDestroy("temp")
   ordcreate(,"temp","OPERACAO+classipi")
   ordSetFocus("temp")
ELSE
   ordDestroy("temp")
   ordcreate(,"temp","CFONEW+CFONEWB+classipi")
   ordSetFocus("temp")
ENDIF
if !empty( FILTRO )
   set filter to &FILTRO
endif

dbgotop()
IMPRESSORA()
while !eof()
   xOPERACAO := IF(cAPUNEW="N",OPERACAO,CFONEW+CFONEWB)
   yVALMER   := yTOTIPI := yTOTPES := yVALOUT := yTOTQTE := 0
   while xOPERACAO = IF(cAPUNEW="N",OPERACAO,CFONEW+CFONEWB) .and. !eof()
      xCLASSIPI := CLASSIPI
      xVALMER   := xTOTIPI := xTOTPES := xVALOUT := xTOTQTE := 0
      while xCLASSIPI = CLASSIPI .and. xOPERACAO = IF(cAPUNEW="N",OPERACAO,CFONEW+CFONEWB) .and. !eof()
         if IF(cTIPO="E",.T.,ESPECIE # "NFE")
            if VALORIPI > 0
               xVALMER +=  VALORMER
               yVALMER +=  VALORMER
            else
               xVALOUT +=  VALORMER
               yVALOUT +=  VALORMER
            endif
            xTOTIPI +=  VALORIPI
            xTOTPES += if( cTIPOE="S", PESTOT, PESLIQ * QTDE )
            yTOTIPI += VALORIPI
            yTOTPES += if( cTIPOE="S", PESTOT, PESLIQ * QTDE )
            xTOTQTE += QTDE
            yTOTQTE += QTDE
         endif
         dbskip()
      enddo
      if CTLIN > 55
         ZFOL ++
         @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
         @  1, 83  say cVAR
         @  1, 97  say ZDATA
         @  1, 113 say left( time(), 5 )
         @  1, 128 say str( ZFOL, 4 )
         @  2,  0  say repl( "-", 132 )
         @  3, 01  say 'DIPI-C'
         @  3, 20  say cCABAUX
         @  5, 30  say impchr(cIMPTIT) + ACENTO( cCABREF )
         @  6,  2  say impchr(cIMPTIT) + cZEMP + impchr(cIMPEXP)
         @  7, 00  say repl( '-', 130 )
         @ 09, 01  say "CFO     Classifica‡„o  Valor Mercadoria   Valor IPI" + spac( 10 ) + "Outros" + spac( 13 ) + "Quantidade" + spac( 9 ) + "Peso total"
         @ 10, 00  say repl( '-', 130 )
         CTLIN := 11
      endif
      @ CTLIN, 00 say xOPERACAO
      @ CTLIN, 08 say xCLASSIPI
      @ cTLIN, 23 say xVALMER   pict '@E 999,999,999.99'
      @ CTLIN, 42 say xTOTIPI   pict '@E 999,999,999.99'
      @ CTLIN, 61 say xVALOUT   pict '@E 999,999,999.99'
      @ CTLIN, 80 say xTOTQTE   pict '@E 9,999,999.999'
      @ CTLIN, 99 say xTOTPES   pict '@E 9,999,999.999'
      CTLIN ++
   enddo
   @ CTLIN,  0 say repl( '-', 132 )
   CTLIN ++
   @ CTLIN, 00 say "Totais Gerais ................"
   @ CTLIN, 23 say yVALMER                          pict '@E 999,999,999.99'
   @ CTLIN, 42 say yTOTIPI                          pict '@E 999,999,999.99'
   @ CTLIN, 61 say yVALOUT                          pict '@E 999,999,999.99'
   @ CTLIN, 80 say yTOTQTE                          pict '@E 9,999,999.999'
   @ CTLIN, 99 say yTOTPES                          pict '@E 9,999,999.999'
   CTLIN ++
   @ CTLIN,  0 say repl( '-', 132 )
   CTLIN ++
enddo
IMPFOL()
dbcloseall()

*+ EOF: M_BDIC.PRG
