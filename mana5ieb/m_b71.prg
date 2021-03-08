*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_B71.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no V?eo
MDI( " þ Imprimir Previs„o de Faturamento" )

nIND := NUMIND( "MO02" )

// Variaveis de Trabalho
CRIARVARS( "MA01" )
CRIARVARS( "MO02" )

FILTRO := ''
FILTRO := RFILORD( "MO02", .F. )
CTLIN  := NRCOPIA := 1
VEZES  := 0

if !CHECKIMP( 0 )
   return .F.
endif
cEMP   := IMP( "ZEMP" )
cRESET := IMP( "RESET" )
@ 24, 00
@ 24, 00 say "N?ero de c?ias:" get NRCOPIA pict '99'
READCUR()
while VEZES < NRCOPIA
   VEZES ++
   CTLIN := 80
   if !USEREDE( "MO02", 1, 99 )
      retu
   endif
   if !empty( FILTRO )
      set filter to &FILTRO
   endif
   dbgotop()
   ZPAGINA   := 0
   L2        := repl( "-", 80 )         //DECLARACAO DE VARIAVEIS
   CO        := "|"
   mVALORMER := mTOT := 0.00
   mENTREGA  := ENTREGA
   MMES      := month( ENTREGA )

   if ! eof()
      IMPRESSORA()
   endif

   while ! eof()
      if month( ENTREGA ) = MMES
         mVALORMER := VALORMER + mVALORMER
      else
         if CTLIN > 55
            ZPAGINA ++
            @  0, 12  say cRESET
            @  0,  0  say impchr(cIMPTIT) + cEMP + impchr(cIMPEXP) //Nome da Empresa
            @  1, 110 say ACENTO( 'P gina: ' ) + str( ZPAGINA, 2 ) //No. da P gina
            @  2, 110 say 'Emitida em: ' + dtoc( ZDATA )
            @  3, 01  say 'M_B71'
            @  3, 115 say time()
            @  5, 30  say impchr(cIMPTIT) + '    PREVISAO DE FATURAMENTO    ' + impchr(cIMPEXP)
            @  7,  0  say repl( '-', 130 )
            CTLIN := 09
            @ CTLIN, 02 say 'Mes de Referencia'
            @ CTLIN, 33 say '  Valor Total Mercadorias'
            CTLIN ++
         endif
         RETORNO := ' '
         CMES( mENTREGA )
         @ CTLIN, 02 say RETORNO + '-' + str( year( mENTREGA ), 4 )
         @ CTLIN, 33 say mVALORMER                                  pict '@E 999,999,999.99'
         CTLIN ++
         mTOT      := mVALORMER + mTOT
         mVALORMER := 0.00
         mVALORMER += VALORMER
         mENTREGA  := ENTREGA
         MMES      := month( ENTREGA )
      endif

      dbskip()
      RETORNO := ' '
      CMES( mENTREGA )
      @ CTLIN, 02 say RETORNO + '-' + str( year( mENTREGA ), 4 )
      @ CTLIN, 33 say mVALORMER   pict '@E 999,999,999.99'
      CTLIN ++
      mTOT += mVALORMER
      @ CTLIN, 00 say repl( '-', 79 )
      CTLIN ++
      @ CTLIN, 33 say mTOT pict '@E 999,999,999,999,999.99'
      CTLIN ++
      @ CTLIN, 00 say repl( '-', 79 )
      CTLIN ++
   enddo
enddo
dbclosearea()
IMPFOL()
VIDEO()
IMPEND()
retu

*+ EOF: M_B71.PRG
