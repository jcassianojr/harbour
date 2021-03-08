*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\MANA5\ITAESBRA\M_BO2.PRG
*+
*+    Reformatted by Click! 2.03 on Nov-23-2004 at 12:13 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

//Modo de Trabalho no Video
//#INCLUDE "COMANDO.CH"
MDI( " н Imprimir Programa de Trabalho" )
if !CHECKIMP( 0 )
   retu .F.
endif
cEMP   := ALLTRIM(IMP( "ZEMP" ))
cRESET := IMP( "RESET" )

lSALDO := SENHAX( "MBO201" )
lPARTI := SENHAX( "MBO202" )

if lSALDO
   lSALDO := MDG( "Listar Saldo do Processo" )
endif

if lPARTI
   lPARTI := MDG( "Listar Participacao Produto NAO=ESTOQUE" )
endif
lCLIFOL := MDG( "Um Cliente por Folha" )
lORDEM  := MDG( "Ordem (Sim) Numero (NAO) Cognome")

FILTRO   := ''
FILTRO   := RFILORD( "MO02", .F. )
mOBSMBO2 := space( 70 )
nNRCOPIA := 1
@ 23, 00 say "Nr copias"
@ 23, 20 get nNRCOPIA
@ 24, 00 say "Obs:"
@ 24, 05 get mOBSMBO2
READCUR()
mOBSMBO2 := ALLTRIM(mOBSMBO2)
@ 23,00 say space(80)
@ 24,00 say space(80)

CTLIN := 80
if !USEMULT( { { "MS01", 1, 2 }, { "OF01", 1, 1 }, { "MO02", 1, 99 }, { "MA01", 1, 1 }, { "MO01", 1, 1 } } )
   retu .F.
endif
ZPAGINA := 0
dbselectar( "MO02" )
IF lORDEM
   DBSETORDER(5)
ELSE
   DBSETORDER(2)
ENDIF
if !empty( FILTRO )
   set filter to &FILTRO
endif
nLASTREC:=LASTREC()
nPOSREC:=1
dbgotop()
if eof()
   dbcloseall()
   ALERTX( "Sem Resultados Para o Filtro" )
   retu .F.
endif
IMPRESSORA()
lCLIENTE := .T.

for x = 1 to nNRCOPIA
   dbselectar( "MO02" )
   dbgotop()
   while !eof()
      video()
      @ 24, 00 say FORNECEDO
      impressora()
      nFORNECEDO := FORNECEDO
      cCOGNOME   := COGNOME
      cCLIENTE   := str( nFORNECEDO, 5, 0 )
      dbselectar( "MA01" )
      dbgotop()
      if dbseek( nFORNECEDO )
          cCLIENTE := str( nFORNECEDO, 5, 0 ) + '-' + trim(COGNOME) + '-' + trim(CIDADE)
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
      while IF(lORDEM,nFORNECEDO = FORNECEDO,cCOGNOME=COGNOME) .and. !eof()
         video()
         @ 24, 20 say PEDIDO
         ZEI_FORT(nLASTREC,.T.,nPOSREC)
         nPOSREC++
         impressora()
         if QTDESAL > 0
            if CTLIN > 50
               ZPAGINA ++
               if nTIPSPO = 2 .or. nTIPSPO = 3 .or. nTIPSPO = 4
                  @  0,  0  say cRESET
               ENDIF
               @  0,  1  say impchr( cIMPTIT ) + cEMP + impchr( cIMPEXP )
               @  1,  1  say 'M_BO2'
               @  1, 10  say 'PROGRAMA DE TRABALHO'
               @  1, 60  say ACENTO( 'P gina: ' ) + str( ZPAGINA, 2 )
               @  1, 80  say 'Emitida em: ' + dtoc( ZDATA )
               @  1, 100 say time()
               @  2,  0  say mOBSMBO2
               @  3,  0  say repl( '-', 130 )
               @  4, 03  say 'O.S.'
               @  4, 09  say 'P'
               @  4, 11  say 'Codigo'
               @  4, 27  say 'Nome'
               @  4, 53  say 'Ped Cli'
               @  4, 63  say 'Qtde'
               @  4, 72  say 'Entreg'
               @  4, 81  say 'Saldo'
               @  4, 90  say 'Fabricar'
               @  4, 99  say 'UN'
               @  4, 102 say 'Entrega'
               @  4, 111 say 'PL'
               if lPARTI
                  @  4, 114 say "Parti"
               ELSE
                  @  4, 114 say "Estq"
               ENDIF   
               @  4, 121 say 'Obs:'
               CTLIN    := 5
               lCLIENTE := .T.
            endif
            if lCLIENTE
               @ CTLIN,  0 say repl( '-', 130 )
               CTLIN ++
               @ CTLIN,  5 say impchr( cIMPTIT ) + ALLTRIM(cCLIENTE) + impchr( cIMPEXP )
               CTLIN ++
               @ CTLIN,  0 say repl( '-', 130 )
               CTLIN ++
               lCLIENTE := .F.
            endif
            nPEDIDO := PEDIDO
            PEDCLI  := ""
            COND    := ""
            dbselectar( "MO01" )
            dbgotop()
            if dbseek( nPEDIDO )
               PEDCLI := PEDIDOCLI
               COND   := CONDPAG
            endif
            dbselectar( "MO02" )
            @ CTLIN, 00 say OS                                                pict '99999.99'
            @ CTLIN, 09 say TIPOSERV
            @ CTLIN, 11 say left( CODIGO, 15 ) //CODIGO DA PECA
            @ CTLIN, 27 say left( NOME, 25 ) //NOME DA PECA
            @ CTLIN, 53 say left( PEDCLI, 9 ) // 51  PEDIDO DO CLIENTE (MO01)
            do case
            case UNID = 'CT'
               @ CTLIN, 63 say str( QTDEPED, 8, 2 )
               @ CTLIN, 72 say str( QTDEENT, 8, 2 )
               @ CTLIN, 81 say str( QTDESAL, 8, 2 )
            case UNID = 'ML'
               @ CTLIN, 63 say str( QTDEPED, 8, 3 )
               @ CTLIN, 72 say str( QTDEENT, 8, 3 )
               @ CTLIN, 81 say str( QTDESAL, 8, 3 )
            case UNID = 'HR'
               @ CTLIN, 63 say str( HORAPED, 8, 3 )
               @ CTLIN, 72 say str( HORAENT, 8, 3 )
               @ CTLIN, 81 say str( HORASAL, 8, 3 )
            otherwise
               @ CTLIN, 63 say str( QTDEPED, 8, 0 )
               @ CTLIN, 72 say str( QTDEENT, 8, 0 )
               @ CTLIN, 81 say str( QTDESAL, 8, 0 )
            endcase
            if lSALDO
               mCHAVE := str( PEDIDO, 8, 2 ) + str( ITEM, 3 )
               dbselectar( "OF01" )
               dbgotop()
               if dbseek( mCHAVE )
                  @ CTLIN, 90 say str( QSALDO, 8, 2 )
               endif
               dbselectar( "MO02" )
            endif
            @ CTLIN, 99  say UNID
            @ CTLIN, 102 say ENTREGA
            @ CTLIN, 111 say PLANTA
            mCODIGO := CODIGO
            //if lPARTI
               dbselectar( "MS01" )
               dbgotop()
               if dbseek( mCODIGO )
                  IF lPARTI 
                     @ CTLIN, 114 say PARTI
                  ELSE
                     @ CTLIN, 114 say str(convun(ESTQSAL,unid), 8, 0 )
                  ENDIF   
               endif
               dbselectar( "MO02" )
            //endif
            @ CTLIN, 123 say impchr( cIMPCOM ) + substr( OBSERVACAO, 1, 15 ) + impchr( cIMPEXP )
            CTLIN ++
         endif
         dbselectar( "MO02" )
         dbskip()
      enddo
      lCLIENTE := .T.
      if lCLIFOL
         CTLIN := 56
      endif
   enddo
next
dbcloseall()
@ CTLIN,  0 say "" //Ajuste Uma Lina Para o Video
VIDEO()
IMPEND()

*+ EOF: M_BO2.PRG
