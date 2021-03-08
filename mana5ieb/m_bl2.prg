*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BL2.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no VЎdeo
MDI( " Э Imprimir Relatўrio de Contas Pagas" )

lCOM:=MDG("Comprimido")
lDIA := MDG("Total do Dia")

//Verifica a Impressora
if !CHECKIMP( 0 )
   return .F.
endif
cEMP := IMP( "ZEMP" )

//Grupo da Listagem
FILTRO := ''
FILTRO := RFILORD( "ML01PG", .F. )


aRETU   := PERFEC( { "ML01PG" }, { "ML" }, { "ML99" }  )
ARQWORK := aRETU[ 5, 1 ]
cCAB    := aRETU[ 7 ]

TOTPG1  := TOTPG2 := 0.00
ZPAGINA := 0
CTLIN   := 80

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
while ! eof()
   TOTPG1 := 0.00
   DAT := DATAPG    //VENCIMENT
   while dat=datapg.and.! eof()
      if CTLIN > 55
         ZPAGINA ++
         @  0,  0  say cEMP
         @  1, 01 say 'M_BL2'
         @  1, 20 say  'CONTAS PAGAS POR DATA DE PAGAMENTO'
         @  1, 80 SAY TIME()
         @  1, 90 say 'Emitida em: ' + dtoc( ZDATA )
         @  1,110 say ACENTO( '    P gina: ' ) + str( ZPAGINA, 2 )
         @  2,  0 say repl( '-', 132 )
         @ 03, 01  say 'Numero '
         @ 03, 14  say 'Emissao'
         @ 03, 23 say 'Fornecedor'
         @ 03, 42 say 'Vcto'
         @ 03, 51 say 'Valor'
         @ 03, 64 say 'Dep'
         @ 03, 68 say 'Bco'
         @ 03, 72 say 'Data Pg'
         @ 03, 81 say 'Valor Pg'
         @ 03, 94 say 'Diferen‡a'
         @ 03,107 say 'Obs'
         @ 04,  0  say repl( '-', 132 )
         CTLIN := 5
      endif
      @ CTLIN, 01 say NRNOTA pict '99999999'
      if !empty( TIPFAT )
         @ CTLIN, 09 say '-' + TIPFAT
      endif
      @ CTLIN, 14 say DATA
      @ CTLIN, 23 say strzero( FORNECEDO, 5 )
      @ CTLIN, 29 say COGNOME
      @ CTLIN, 42 say VENCIMENT
      @ CTLIN, 51 say VALOR            pict '@E 99999,999.99'
      @ CTLIN, 64 say COD
      @ CTLIN, 68 say BANCO
      @ CTLIN, 72 say DATAPG
      @ CTLIN, 81 say VALORPG           pict '@E 99999,999.99'
      @ CTLIN, 94 say DIFERENCA         pict '@E 99999,999.99'
      @ CTLIN,107 say left( OBS1, 20 )
      TOTPG1 += VALORPG
      TOTPG2 += VALORPG
      CTLIN ++
      dbskip()
   ENDDO
   if TOTPG1>0.AND.lDIA
      CTLIN ++
      @ CTLIN, 90 say 'Total do Dia'
      @ CTLIN, 106 say TOTPG1         pict '999,999,999.99'
      CTLIN ++
      @ CTLIN,  0 say repl( '-', 132 )
      CTLIN ++
   endif
enddo
IF TOTPG2>0
   CTLIN ++
   @ CTLIN, 90 say 'Total Geral '
   @ CTLIN, 106 say TOTPG2         pict '999,999,999.99'
ENDIF
dbcloseall()
IMPFOL()
VIDEO()
IMPEND()
