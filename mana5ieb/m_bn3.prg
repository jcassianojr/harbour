*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BN3.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI( " Э Imprimir Contas Recebidas por Data de Pagamento" )

if !CHECKIMP( 0 )
   retu .F.
endif
cEMP := IMP( "ZEMP" )
lCOM:=MDG("Comprimido")
lDIA:=MDG("Totais do Dia")
CTLIN   := 80
ZPAGINA := 0
TOT1    := TOT2 := 0.00


aRETU   := PERFEC( { "MN01PG" }, { "MN" }, { "MN99" }  )
ARQWORK := aRETU[ 5, 1 ]
cCAB    := aRETU[ 7 ]



FILTRO := ''
FILTRO := RFILORD( ARQWORK, .F. )


if !USEREDE( ARQWORK, 1, 0 )
   retu
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","datapg")
ordSetFocus("temp")

if !empty( FILTRO )
   set filter to &FILTRO
endif


IMPRESSORA()
if Lcom
   @ 0,0 SAY IMPSTR(aCHR[1])
endif


dbgotop()
while !eof()
   TOT1:=0
   DAT := DATAPG    //DAT :=VENCIMENT
   WHILE DATAPG=DAT.AND.! EOF()
      if CTLIN > 55
         ZPAGINA ++
         @  0,  0  say  cEMP
         @  1, 01  say 'M_BN3'
         @  1, 20  say 'CONTAS RECEBIDAS POR DATA DE PAGAMENTO' + impchr(cIMPEXP)
         @  1, 80 SAY TIME()
         @  1, 90 say 'Emitida em: ' + dtoc( ZDATA )
         @  1, 110 say ACENTO( '    P gina: ' ) + str( ZPAGINA, 2 )
         @  2,  0  say repl( '-', 132 )
         @ 03, 01  say ' NUMERO '
         @ 03, 14  say ACENTO( 'EMISSЋO' )
         @ 03, 27  say 'CLIENTE '
         @ 03, 47  say 'VENCIMENT'
         @ 03, 59  say 'VALOR TITULO '
         @ 03, 76  say 'PAGO EM'
         @ 03, 84  say '     VALOR PAGO'
         @ 03, 101 say ACENTO( 'OBSERVAЂЋO:' )
         @ 04,  0  say repl( '-', 132 )
         CTLIN := 5
      endif
      @ CTLIN, 01 say NUMERO pict '99999999'
      if !empty( TIPFAT )
         @ CTLIN, 09 say '-' + TIPFAT
      endif
      @ CTLIN, 14 say DATA // NOVO
      @ CTLIN, 25 say strzero( FORNECEDO, 5 )
      @ CTLIN, 32 say COGNOME
      @ CTLIN, 45 say VENCIMENT
      @ CTLIN, 55 say VALOR                   pict '999,999,999.99'
      @ CTLIN, 73 say DATAPG
      @ CTLIN, 83 say VALORPG                 pict '999,999,999.99'
      @ CTLIN, 99 say left( OBS1, 31 ) //99
      TOT1 += VALORPG                   //Soma dos Valores pagos (por dia e geral)
      TOT2 += VALORPG
      CTLIN ++
      dbskip()
   ENDDO
   if TOT1>0.AND.lDIA
      CTLIN ++
      @ CTLIN, 83 say TOT1                pict '999,999,999.99' //58
      @ CTLIN, 98 say 'Total do Dia' //76
      CTLIN ++
      @ CTLIN,  0 say repl( '-', 132 )
      CTLIN ++
   endif
 enddo
 IF TOT2>0
   @ CTLIN,  0 say repl( '-', 132 )
   CTLIN ++
   @ CTLIN, 83 say TOT2                pict '999,999,999.99' //58
   @ CTLIN, 98 say 'Total Geral ' //76
   CTLIN ++
   @ CTLIN, 0 say repl( '-', 132 )
   CTLIN ++
ENDIF
dbcloseall()
IMPFOL()
VIDEO()
IMPEND()

*+ EOF: M_BN3.PRG
