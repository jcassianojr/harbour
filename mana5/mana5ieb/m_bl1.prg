*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_BL1.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-11-2002 at  4:29 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI( " þ Imprimir Contas a Pagar por Data de Vencimento " )

if !CHECKIMP( 0 )
   retu .F.
endif
cEMP   := IMP( "ZEMP" )
nCOPIA := 1

FILTRO := ''
FILTRO := RFILORD( "ML01", .F. )

nIND := NUMIND( "ML01" )

lCOM := MDG("Comprimido" )
lCAB := MDG("Cabe‡ario" )
lDIA := MDG("Total do Dia")
MDS( "Digite N?de Copias" )
@ 24, 40 get nCOPIA
READCUR()

if !USEREDE( "ML01", 1, 1 )
   retu
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif
IMPRESSORA()
for X := 1 to NCOPIA
   CTLIN   := 80
   TOT1    := TOT2 := 0.00
   ZPAGINA := 0

   if Lcom
      @  0,  0 say IMPSTR( aCHR[ 1 ] )
   endif

   dbgotop()
   while !eof()
      DAT  := VENCIMENT
      TOT1 := 0
      while DAT = VENCIMENT .and. !eof()
         if CTLIN > 55
            if lCAB
               ZPAGINA ++
               @  0,  0  say cEMP
               @  1, 01  say 'M_BL1'
               @  1, 20  say 'CONTAS A PAGAR POR DATA DE VENCIMENTO'
               @  1, 80  say time()
               @  1, 90  say 'Emitida em: ' + dtoc( ZDATA )
               @  1, 110 say ACENTO( '    P gina: ' ) + str( ZPAGINA, 2 )
               @  2,  0  say repl( '-', 132 )
               @ 03, 01  say ' NUMERO '
               @ 03, 14  say 'EMISSAO'
               @ 03, 25  say 'FORNECEDOR'
               @ 03, 45  say 'VENCERA' // 45
               @ 03, 55  say ' VALOR TITULO ' //57
               @ 03, 71  say 'COD' //NOVO
               @ 03, 76  say 'BCO'
               @ 03, 80  say 'OBSERVACAO:'
               @ 04,  0  say repl( '-', 132 )
               CTLIN := 5
            else
               CTLIN := 1
            endif
         endif
         @ CTLIN, 01 say NRNOTA pict '99999999'
         if !empty( TIPFAT )
            @ CTLIN, 09 say '-' + TIPFAT
         endif
         @ CTLIN, 14 say DATA
         @ CTLIN, 25 say strzero( FORNECEDO, 5 )
         @ CTLIN, 31 say COGNOME
         @ CTLIN, 45 say VENCIMENT
         @ CTLIN, 55 say VALATUAL                pict '999,999,999.99'
         @ CTLIN, 71 say COD
         @ CTLIN, 82 say BANCO
         @ CTLIN, 86 say left( OBS1, 40 )
         TOT1 += VALATUAL
         TOT2 += VALATUAL
         CTLIN ++
         dbskip()
      enddo
      if TOT1 > 0.and.lDIA
         @ CTLIN,  0 say repl( '-', 132 )
         CTLIN ++
         @ CTLIN, 58 say TOT1           pict '999,999,999.99'
         @ CTLIN, 76 say 'Total do Dia'
         CTLIN ++
         @ CTLIN,  0 say repl( '-', 132 )
         CTLIN ++
      endif
   enddo
   if TOT2 > 0
      CTLIN ++
      @ CTLIN, 58 say TOT2           pict '999,999,999.99'
      @ CTLIN, 76 say 'Total Geral '
      CTLIN ++
   endif
next X
dbcloseall()
IMPFOL()
VIDEO()
IMPEND()

*+ EOF: M_BL1.PRG
