*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BM4.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function M_bm4
para cARQPRI, cARQACU, cCARREF, cCABREF

//Modo de Trabalho no Video
MDI( " Э Imprimir Relatўrio da " + cCABREF )

cVAR     := "ATUAL"
lACUMULA := .F.
ARQWORK  := cARQPRI
MES      := 0
ANO      := 0
cCABAUX  := space( 40 )
PERACU()

FILTRO := 'APURA#"N"'
FILTRO := RFILORD( cARQPRI, .F., FILTRO )

if !CHECKIMP( 0 )
   return .F.
endif


MDS( "Aguarde Montando Relatorio" )
if !USEREDE( ARQWORK, 1, 99 )
   retu .F.
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif

IMPRESSORA()

TOT1 := TOT2 := TOT3 := 0.00
@ prow(), 1      say "ITAESBRA INDUSTRA MECANICA LTDA."
@ prow() + 1, 23 say cCABREF
@ prow() + 1, 0  say repl( '-', 78 )
@ prow() + 1, 0  say 'N.Fis'
@ prow(), 06     say 'Emiss„o'
@ prow(), 16     say 'Cliente'
@ prow(), 34     say 'CFO'
@ prow(), 42     say 'Vencim.'
@ prow(), 51     say 'Total Mercador.'
@ prow(), 64     say 'Total Nota '
@ prow() + 1, 00 say repl( '-', 78 )

dbgotop()
while !eof()
   @ prow() + 1, 00 say NUMERO              pict '99999'
   @ prow(), 06     say DATA
   @ prow(), 15     say FORNECEDO           pict '99999'
   @ prow(), 21     say COGNOME
   @ prow(), 34     say alltrim( OPERACAO )
   @ prow(), 42     say DAT01
   @ prow(), 51     say TOTMER              pict '@E 99999,999.99'
   @ prow(), 64     say TOTNF               pict '@E 99999,999.99'
   TOT1 += TOTMER
   TOT3 += TOTNF
   dbskip()
enddo
@ prow() + 1, 1  say repl( '-', 78 )
@ prow() + 1, 10 say "Totais Gerais : "
@ prow(), 51     say TOT1               pict '@E 99999,999.99'
@ prow(), 64     say TOT3               pict '@E 99999,999.99'
@ prow() + 1, 1  say repl( '=', 78 )
dbclosearea()
IMPFOL()
VIDEO()
IMPEND()


*+ EOF: M_BM4.PRG
