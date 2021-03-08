*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_BO1.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

//#INCLUDE "COMANDO.CH"
//Modo de Trabalho no Video
MDI( " þ Imprimir Pedidos por Ordem de Clientes" )

if !CHECKIMP( 0 )
   return .F.
endif
cZEMP   := IMP( "ZEMP" )
cRESET := IMP( "RESET" )

FILTRO := ''
FILTRO := RFILORD( "MO02", .F. )
lANA   := MDG( "Deseja Analitico" )
lRES   := MDG( "Deseja Resumo" )

if !USEMULT( { { "MA01", 1, 1 }, { "MO01", 1, 1 }, { "MO02", 1, 5 } } )
   retu .F.
endif

dbselectar( "MO02" )
if !empty( FILTRO )
   set filter to &FILTRO
endif

ZPAGINA := 0
CTLIN   := 80
aMES    := {}
aVAL    := {}
aQTD    := {}
aadd( aMES, "ATRASO" )                  //Atraso
aadd( aVAL, 0 )     //Valor Zerado
aadd( aQTD, 0 )

IMPRESSORA()
dbselectar( "MO02" )
dbgotop()
while !eof()
   mCOGN      := COGNOME
   mFORNECEDO := FORNECEDO
   aCMES      := {}
   aCVAL      := {}
   aCQTD      := {}
   lCLIENTE   := .T.
   aadd( aCMES, "ATRASO" )              //Atraso Cliente
   aadd( aCVAL, 0 )                     //Valor Zerado Cliente
   aadd( aCQTD, 0 )
   CID=""
   dbselectar( "MA01" )
   dbgotop()
   if dbseek( mFORNECEDO )
      cCLIENTE := str( mFORNECEDO, 5, 0 ) + '-' + trim(COGNOME) + '-' + trim(CIDADE)
      if ! empty(siSco)
         ccliente+=" Cisco:"+sISCO
      endif
      if ! empty(planta)
         ccliente+=" Planta:"+Planta
      endif
      if ! empty(doca)
         ccliente+=+" Doca:"+DOCA
      endif
   endif
   dbselectar( "MO02" )
   while mFORNECEDO = FORNECEDO .and. !eof()
      if CTLIN > 55 .and. lANA
         ZPAGINA ++
         lCLIENTE := .T.
         @  0,  0  say cRESET
         @  0, 10  say cZEMP
         @  1,  1  say 'M_BO1'
         @  1, 10  say 'Pedidos Por Cliente'
         @  1, 60  say ACENTO( 'P gina: ' ) + str( ZPAGINA, 2 )
         @  1, 80  say 'Emitida em: ' + dtoc( ZDATA )
         @  1, 100 say time()
         @  2,  0  say repl( '-', 130 )
         @  3, 00  say impchr(cIMPCOM)
         @ 03, 02  say 'PEDIDO'
         @ 03, 10  say 'T'
         @ 03, 17  say 'COGIGO DA PECA'
         @ 03, 40  say 'NOME DA PECA'
         @ 03, 56  say 'PEDIDO  CLIENTE'
         @ 03, 74  say 'Quantidade'
         @ 03, 93  say 'UN'
         @ 03, 98  say 'PRAZO'
         @ 03, 107 say 'IPI'
         @ 03, 111 say 'CONSUMO'
         @ 03, 120 say 'PRECO UNITARIO'
         @ 03, 137 say '** TOTAL **'
         @ 03, 150 say 'BASE PRECO'
         @ 03, 162 say 'COND'
         @ 03, 168 say 'MP'
         @ 03, 171 say 'OBSERVACOES'
         @ 04,  0  say impchr(cIMPEXP) + repl( '-', 130 ) + impchr(cIMPCOM)
         CTLIN := 5
      endif
      if lCLIENTE.AND.lANA
         IF CTLIN<>5 //Posicao sem ser cabecario
            CTLIN ++
            @ CTLIN,  0 say repl( '-', 130 ) + impchr(cIMPCOM)
            CTLIN ++
         ENDIF
         @ CTLIN,  0 say impchr(cIMPEXP)
         @ CTLIN,  5 say impchr(cIMPTIT) + cCLIENTE + impchr(cIMPEXP)
         CTLIN ++
         @ CTLIN,  0 say repl( '-', 130 ) + impchr(cIMPCOM)
         CTLIN ++
         lCLIENTE := .F.
      endif
      if QTDESAL > 0.00
         mPEDIDO := PEDIDO
         COND    := ""
         PEDCLI  := ""
         dbselectar( "MO01" )
         dbgotop()
         if dbseek( mPEDIDO )
            COND   := CONDPAG
            PEDCLI := PEDIDOCLI
         endif
         dbselectar( "MO02" )
         if lANA
            @ CTLIN, 00  say PEDIDO                                       pict '99999.99'
            @ CTLIN, 09  say TIPOSERV
            @ CTLIN, 11  say left( CODIGO, 20 ) //Codigo da peca
            @ CTLIN, 31  say substr( NOME, 1, 20 ) //Nome da peca
            @ CTLIN, 52  say left( PEDCLI, 10 ) //Pedido do cliente (mo01)
            DO CASE
               CASE UNID='CT'
                    @ CTLIN, 63  say str( QTDEPED, 9, 2 )
                    @ CTLIN, 73  say str( QTDEENT, 9, 2 )
                    @ CTLIN, 83  say str( QTDESAL, 9, 2 )
               CASE UNID='ML'
                    @ CTLIN, 63  say str( QTDEPED, 9, 3 )
                    @ CTLIN, 73  say str( QTDEENT, 9, 3 )
                    @ CTLIN, 83  say str( QTDESAL, 9, 3 )
               CASE UNID='HR'
                    @ CTLIN, 63 say str( HORAPED, 9, 3 )
                    @ CTLIN, 73 say str( HORAENT, 9, 3 )
                    @ CTLIN, 83 say str( HORASAL, 9, 3 )
               otherwise
                    @ CTLIN, 63  say str( QTDEPED, 9, 0 )
                    @ CTLIN, 73  say str( QTDEENT, 9, 0 )
                    @ CTLIN, 83  say str( QTDESAL, 9, 0 )
            ENDCASE
            @ CTLIN, 93 say UNID    //Unidade
            @ CTLIN, 96 say ENTREGA //Prazo (data)
            @ CTLIN,108 say IPI
            @ CTLIN,115 say CONSUMO
         endif
         mVALOR   := VALOR
         mTEMPVAL := 0
         if empty( INDICE )
            if lANA
               @ CTLIN, 118 say VALOR pict '@E 999,999,999.99' //Preco unitario 140
            endif
         else
            PREIND( INDICE, ZDATA, "mTEMPVAL" )
            mVALOR := round( mTEMPVAL * VALIND, 4 )
            if lANA
               @ CTLIN, 118 say mVALOR pict '@E 999,999,999.99' //Preco unitario 140
            endif
         endif
         if UNID = "HR"
            xTOTALVAL := HORASAL * mVALOR
         else
            xTOTALVAL := QTDESAL * mVALOR                   //Acha o Valor Total
         endif
         if lANA
            @ CTLIN, 134 say xTOTALVAL                   pict '@E 999,999,999.99' //156
            @ CTLIN, 150 say "LISTA PRECO"
            @ CTLIN, 163 say COND
            @ CTLIN, 168 say MATPRIMA
            @ CTLIN, 172 say substr( OBSERVACAO, 1, 30 )
            CTLIN ++
         endif
         if ENTREGA < ZDATA
            aCVAL[ 1 ] += xTOTALVAL
            aCQTD[ 1 ] += CONVUN( QTDESAL, UNID )
            aVAL[ 1 ] += xTOTALVAL
            aQTD[ 1 ] += CONVUN( QTDESAL, UNID )
         else
            cBUSCA := left( cMES( ENTREGA ), 3 ) + "/" + strzero( year( ENTREGA ), 4 )
            nPOS   := ascan( aCMES, cBUSCA )
            if nPOS > 0
               aCVAL[ NPOS ] += xTOTALVAL
               aCQTD[ NPOS ] += CONVUN( QTDESAL, UNID )
            else
               aadd( aCMES, cBUSCA )
               aadd( aCVAL, xTOTALVAL )
               aadd( aCQTD, CONVUN( QTDESAL, UNID ) )
            endif
            nPOS := ascan( aMES, cBUSCA )
            if nPOS > 0
               aVAL[ NPOS ] += xTOTALVAL
               aQTD[ NPOS ] += CONVUN( QTDESAL, UNID )
            else
               aadd( aMES, cBUSCA )
               aadd( aVAL, xTOTALVAL )
               aadd( aQTD, CONVUN( QTDESAL, UNID ) )
            endif
         endif
      endif
      dbselectar( "MO02" )
      dbskip()
   enddo
   nCOL := 0
   nGER := 0
   nQTD := 0
   for W := 1 to len( aCMES )
      if nCOL > 120
         CTLIN ++
         nCOL := 0
      endif
      if lANA
         @ CTLIN, nCOL      say "Total " + aCMES[ W ]
         @ CTLIN, nCOL + 15 say aCVAL[ W ]            pict '@E 999,999.99'
         @ CTLIN, nCOL + 30 say aCQTD[ W ]            pict '@E 999,999,999'
      endif
      nGER += aCVAL[ W ]
      nQTD += aCQTD[ W ]
      nCOL += 45
   next W
   if nCOL > 120 .and. lANA
      CTLIN ++
      nCOL := 0
   endif
   if lANA
      @ CTLIN, nCOL      say "Total Geral"
      @ CTLIN, nCOL + 15 say nGER          pict '@E 999,999.99'
      @ CTLIN, nCOL + 30 say nQTD          pict '@E 999,999,999'
   endif
enddo
dbcloseall()
if lRES
   ZPAGINA ++       //Pula p gina e imprime o cabecario e totais dos meses.
   @  0, 12  say cRESET
   @  0,  0  say impchr(cIMPTIT) + cZEMP + impchr(cIMPEXP) //Nome da Empresa
   @  1, 110 say ACENTO( '    P gina: ' ) + str( ZPAGINA, 2 ) //No. da P gina
   @  2, 110 say 'Emitida em: ' + dtoc( ZDATA )
   @  3, 01  say 'M_BO1'
   @  3, 115 say time()
   @  5, 30  say impchr(cIMPTIT) + 'CADASTRO DE PEDIDOS POR CLIENTE' + impchr(cIMPEXP)
   @  7,  0  say repl( '-', 130 )
   CTLIN := 9
   nGER  := 0
   nQTD  := 0
   for W := 1 to len( aMES )
      CTLIN ++
      @ CTLIN, 15 say "Total " + aMES[ W ]
      @ CTLIN, 30 say aVAL[ W ]            pict '@E 999,999,999.99'
      @ CTLIN, 45 say aQTD[ W ]            pict '@E 999,999,999'
      nGER += aVAL[ W ]
      nQTD += aQTD[ W ]
   next W
   CTLIN ++
   @ CTLIN, 15 say "Total Geral"
   @ CTLIN, 30 say nGER          pict '@E 999,999,999.99'
   @ CTLIN, 45 say nQTD          pict '@E 999,999,999'
endif
VIDEO()
IMPEND()

*+ EOF: M_BO1.PRG
