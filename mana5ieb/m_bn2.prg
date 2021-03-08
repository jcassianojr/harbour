*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_BN2.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

//#INCLUDE "COMANDO.CH"


//Modo de Trabalho no Video
MDI( " þ Imprimir Contas a Receber Data de Vencimento " )

//Checando a Impressora
if !CHECKIMP( 0 )
   return .F.
endif
cEMP := IMP( "ZEMP" )


lCOM:=MDG("Comprimido")


//Filtro de Trabalho
FILTRO := ''
FILTRO := RFILORD( "MN01", .F. )

CTLIN   := 80
ZPAGINA := 0
TOT1    := TOT2 := 0.00

//Abrindo o Arquivo
if !USEREDE( "MN01", 1, 1 )
   retu
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif

IMPRESSORA()
if Lcom
   @ 0,0 SAY IMPSTR(aCHR[1])
endif

dbgotop()
while !eof()
   TOT1    :=  0.00
   DAT     := VENCIMENT
   nITEM   := 0
   WHILE VENCIMENT=DAT.AND.! EOF()
      if CTLIN > 55
         ZPAGINA ++
         @  0,  0  say  cEMP
         @  1, 01  say 'M_BN2'
         @  1, 20  say  'CONTAS A RECEBER POR DATA DE VENCIMENTO'
         @  1, 80 SAY TIME()
         @  1, 90 say 'Emitida em: ' + dtoc( ZDATA )
         @  1, 110 say ACENTO( '    P gina: ' ) + str( ZPAGINA, 2 )
         @  2,  0  say repl( '-', 132 )
         @ 03, 01  say ' NUMERO '
         @ 03, 14  say ACENTO( 'EMISSŽO' )
         @ 03, 27  say 'CLIENTE '
         @ 03, 47  say ACENTO( 'VENCER' )
         @ 03, 62  say ' VALOR TITULO '
         @ 03, 76  say 'BANCO' // NOVO
         @ 03, 84  say 'DOC.BOL.' // NOVO
         @ 03, 103 say ACENTO( 'OBSERVA€ŽO:' )
         @ 04,  0  say repl( '-', 132 )
         CTLIN := 5
      endif
      @ CTLIN, 01 say NUMERO pict '99999999'
      if !empty( TIPFAT )
         @ CTLIN, 09 say '-' + TIPFAT
      endif
      @ CTLIN, 12 say DATA // NOVO
      @ CTLIN, 25 say strzero( FORNECEDO, 5 )
      @ CTLIN, 32 say COGNOME
      @ CTLIN, 45 say VENCIMENT
      @ CTLIN, 57 say VALATUAL                pict '999,999,999.99'
      @ CTLIN, 74 say BANCO // NOVO
      @ CTLIN, 81 say DOCBOL // NOVO
      @ CTLIN, 99 say left( OBS1, 31 )
      TOT1 += VALATUAL
      TOT2 += VALATUAL
      nITEM++
      CTLIN ++
      dbskip()
   ENDDO
   if nITEM>0
      CTLIN ++
      @ CTLIN, 58 say TOT1           pict '999,999,999.99'
      @ CTLIN, 76 say 'Total do Dia'
      CTLIN ++
      @ CTLIN,  1 say repl( '-', 132 )
      CTLIN ++
   endif
enddo
IF TOT2>0
   @ CTLIN,  1 say repl( '-', 132 )
   CTLIN ++
   @ CTLIN, 58 say TOT2           pict '999,999,999.99'
   @ CTLIN, 76 say 'Total Geral '
   CTLIN ++
ENDIF
dbcloseall()
IMPFOL()
VIDEO()
IMPEND()

*+ EOF: M_BN2.PRG
