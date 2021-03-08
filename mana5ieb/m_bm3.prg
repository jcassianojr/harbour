*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\ITAESBRA\M_BM3.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

//Modo de Trabalho no Video

//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

function m_bm3
para cARQPRI, cARQACU, cCARREF, cCABREF

//Modo de Trabalho no Video
MDI( " н Imprimir RelatЂrio da " + cCABREF )

cVAR     := "ATUAL"
lACUMULA := .F.
ARQWORK  := cARQPRI
MES      := 0
ANO      := 0
cCABAUX  := space( 40 )
PERACU()



FILTRO := "APURA#'N'"
FILTRO := RFILORD( cARQPRI, .F., FILTRO )
CTLIN  := NRCOPIA := 1
VEZES  := 0

if !CHECKIMP( 0 )
   return .F.
endif
cEMP   := IMP( "ZEMP" )
cRESET := IMP( "RESET" )

@ 24, 00
@ 24, 00 say "NЃmero de copias:" get NRCOPIA pict '99'
READCUR()
if !USEREDE( ARQWORK, 1, 99 )
   retu
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
HB_dispbox( 6, 10, 08, 69, B_DOUBLE)
@ 07, 20 say 'Aguarde Acumulando os Valores Para Imprimir'
@ 09, 20 say 'Nota Fiscal : '
@ 10, 20 say 'Emitida em  : '
@ 11, 20 say 'Cliente nro.: '
@ 12, 20 say 'Cognome     : '
//PREPARANDO ACUMULADORES
aACUM := array( 2, 10 )
for X := 1 to 10
   if X = 1
      aACUM[ 1, X ] := 0
      Y             := 0
   else
      Y             += 10
      aACUM[ 1, X ] := Y
   endif
   aACUM[ 2, X ] := 0.00
next X
while !eof()
   @ 09, 35 say NUMERO
   @ 10, 35 say DATA
   @ 11, 35 say FORNECEDO
   @ 12, 35 say COGNOME
   for Y := 1 to 10                     // VERIFICAR AS DATAS DE VENCIMENTO DO MM01
      DIAS := ( &( "DAT" + strzero( Y, 2 ) ) - DATA )       //QTOS DIAS DA EMISSAO
      VAL  := "VAL" + strzero( Y, 2 )   //VALOR NO VENCIMENTO
      for X := 1 to 10
         if DIAS <= aACUM[ 1, X ]
            aACUM[ 2, X ] := aACUM[ 2, X ] + &VAL
            exit
         endif
         if X = 10
            aACUM[ 2, 10 ] := aACUM[ 2, X ] + &VAL
         endif
      next
   next
   dbskip()
enddo
IMPRESSORA()
while VEZES < NRCOPIA
   VEZES ++
   CTLIN   := 80
   ZPAGINA := 0
   if !eof()
      IMPRESSORA()
   endif
   TOT1 := 0.00
   ZPAGINA ++
   @  0,  0 say cRESET + impchr(cIMPEXP)
   @  0,  0 say cEMP
   @  1, 01 say 'M_BM3'
   @  1, 59 say ACENTO( '    Folha: ' ) + str( ZPAGINA, 2 )
   @  2, 01 say 'Horario: ' + time()
   @  2, 59 say 'Emitida em: ' + dtoc( ZDATA )
   @  3, 00 say impchr(cIMPTIT) + cCABREF
   @  4,  0 say '*' + repl( '-', 78 ) + '*'
   CTLIN := 5
   @ CTLIN, 17 say 'Dias'
   @ CTLIN, 36 say 'Valor Faturado'
   @ 06,  0    say '*' + repl( '-', 78 ) + '*'
   CTLIN := 07
   for X := 1 to 10
      if X = 1
         @ CTLIN, 10 say 'A Vista '
      else
         if X = 10
            @ CTLIN, 08 say 'Acima de: '
            @ CTLIN, 17 say aACUM[ 1, X - 1 ] pict '99'
            @ CTLIN, 20 say 'Dias'
         else
            @ CTLIN, 10 say 'Ate -> '
            @ CTLIN, 17 say aACUM[ 1, X ] pict '99'
            @ CTLIN, 20 say 'Dias'
         endif
      endif
      @ CTLIN, 36 say aACUM[ 2, X ] pict '999,999,999.99'
      TOT1 += aACUM[ 2, X ]
      CTLIN ++
   next
   @ CTLIN,  0 say '*' + repl( '-', 78 ) + '*'
   CTLIN ++
   @ CTLIN, 36 say TOT1 pict '999,999,999.99'
   CTLIN ++
   if ZPAGINA > 0
      @ CTLIN,  0 say '*' + repl( '-', 78 )
      CTLIN ++
   endif
enddo
dbclosearea()
IMPFOL()
VIDEO()
IMPEND()

*+ EOF: M_BM3.PRG
