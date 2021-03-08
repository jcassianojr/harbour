*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BM6A.PRG
*+
*+    Functions: Function MBM6AB()
*+               Function COMPRAS()
*+               Function TRUNCAR()
*+
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI( " Э Imprimir Relatўrio de Apura‡„o de Vendas" )

// Variaveis de Trabalho
CRIARVARS( "APURA2" )
lCPI := MDG( "Deseja Imprimir 12 CPI" )
lCOM := MDG( "Comprimido" )

NRCOPIA := 1
aNFNR   := {}
aBATE   := {}
mTOTD   := mTOTDNF := 0.00
nBATE   := 0

if !CHECKIMP( 0 )
   retu .F.
endif
cAN  := IMP( "AN" )
cDN  := IMP( "DN" )
cEMP := IMP( "ZEMP" )

@ 24, 00
@ 24, 00 say "NЈmero de cўpias:" get NRCOPIA pict '99'
READCUR()

COMPRAS()

if !USEREDE( "APURA2", 0, 99 )
   retu
endif
while !eof()
   nBATE := 0
   for Z := 1 to len( aBATE )
      if aBATE[ Z, 2 ] = COGNOME
         nBATE += aBATE[ Z, 5 ]
      endif
   next Z
   field->ABADEV := nBATE
   dbskip()
enddo

aGRAVA := {}
dbselectar( "APURA2" )
DBSETORDER(2)
dbgotop()
while !eof()
   //Declara‡„o de vari veis
   aadd( aGRAVA, { 0, COGNOME, GRUPOEMP, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } )
   // 1   2          3   4 5 6 7 8 9 10 11 12 13 14,15,16
   nPOS      := len( aGRAVA )
   mGRUPOEMP := GRUPOEMP
   while mGRUPOEMP = GRUPOEMP .and. !eof()
      aGRAVA[ NPOS, 4 ] += PROD
      aGRAVA[ NPOS, 5 ] += FERRA
      aGRAVA[ NPOS, 6 ] += MOPROD
      aGRAVA[ NPOS, 7 ] += MOFERRA
      aGRAVA[ NPOS, 8 ] += TOTALMER
      aGRAVA[ NPOS, 9 ] += total
      aGRAVA[ NPOS, 10 ] += PROD2
      aGRAVA[ NPOS, 11 ] += FERRA2
      aGRAVA[ NPOS, 12 ] += MOPROD2
      aGRAVA[ NPOS, 13 ] += MOFERRA2
      aGRAVA[ NPOS, 14 ] += ABADEV
      aGRAVA[ NPOS, 15 ] += SERV
      aGRAVA[ NPOS, 16 ] += SERV2
      dbskip()
   enddo
enddo
dbclosearea()

if !USEREDE( "APURA2C", 0, 99 )
   retu
endif
dbselectar( "APURA2C" )
zap
for X := 1 to len( aGRAVA )
   if aGRAVA[ X, 9 ] > 0
      netrecapp()
      field->FORNECEDO := aGRAVA[ X, 1 ]
      field->COGNOME   := aGRAVA[ X, 2 ]
      field->GRUPOEMP  := aGRAVA[ X, 3 ]
      field->PROD      := aGRAVA[ X, 4 ]
      field->FERRA     := aGRAVA[ X, 5 ]
      field->MOPROD    := aGRAVA[ X, 6 ]
      field->MOFERRA   := aGRAVA[ X, 7 ]
      field->TOTALMER  := aGRAVA[ X, 8 ]
      field->total     := aGRAVA[ X, 9 ]
      field->PROD2     := aGRAVA[ X, 10 ]
      field->FERRA2    := aGRAVA[ X, 11 ]
      field->MOPROD2   := aGRAVA[ X, 12 ]
      field->MOFERRA2  := aGRAVA[ X, 13 ]
      field->ABADEV    := aGRAVA[ X, 14 ]
      field->SERV      := aGRAVA[ X, 15 ]
      field->SERV2     := aGRAVA[ X, 16 ]
      mPORCENTO        := ( TOTALMER * 100 ) / mTOTMERC     //Acha a porcentagem
      field->PORCENTO  := mPORCENTO
   endif
next X
dbcloseall()

for W := 1 to NRCOPIA
   IF MDG("Resumo Por Cliente a Cliente")
      MBM6AB( "APURA2" )
   ENDIF
   IF MDG("Resumo Por Grupo Empresa")
      MBM6AB( "APURA2C" )
   ENDIF
next W

if MDG( "Imprimir Resumo Checagem Abatimento" )
   @  0,  0 say "Resumo Checagem Abatimento"
   CTLIN := 2
   for W := 1 to len( aNFNR )
      @ CTLIN,  0 say aNFNR[ W, 1 ]
      @ CTLIN, 10 say aNFNR[ W, 2 ]
      CTLIN ++
   next W
   IMPFOL()
endif
IMPEND()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBM6AB()
*+
*+    Called from ( m_bm6a.prg   )   2 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBM6AB( cARQ )
VIDEO()
FILTRO := ''
FILTRO := RFILORD(cARQ, .F. )
IMPRESSORA()
xTOTMER    := xTOTNF := 0.00
xFORNECEDO := 0
xCOGN      := space( 12 )
mACUMPORC  := 0.00
mMERCADO   := mTOTALNF := 0.00
mSAL1      := mSAL2 := mSAL3 := 0.00
mTOTNF1    := mTOTNF2 := mTOTNF3 := mTOTNF4 := mTOTNF5 := 0.00
mTOTAL1    := mTOTAL2 := mTOTAL3 := mTOTAL4 := mTOTAL5 := 0.00
nTBATE     := 0
CTLIN      := 80
if !USEREDE( cARQ, 1, 1 )
   retu
endif
IF ! EMPTY(fILTRO)
   SET FILTER TO &FILTRO.
ENDIF
dbgotop()
ZPAGINA := 0
IMPRESSORA()
if Lcom
   @  0,  0 say IMPSTR( aCHR[ 1 ] )
endif
if lCPI
   set print on
   qqout( IMPCHR( 27 ) + IMPCHR( 77 ) )
   set print OFF
endif
while !eof()
   if CTLIN > 55
      ZPAGINA ++
      @  0,  0  say cEMP
      @  1, 01  say 'M_BM6'
      @  1, 20  say 'APURACAO DE VENDAS POR CLIENTE ' + MMES( nMESUSO ) + "/" + cANOUSO
      @  1, 80  say time()
      @  1, 90  say 'Emitida em: ' + dtoc( ZDATA )
      @  1, 110 say ACENTO( '   Folha: ' ) + str( ZPAGINA, 2 )
      @  2,  0  say repl( '-', 132 )
      @  3,  1  say ' NUM.'
      @  3,  7  say 'COGNOME'
      @  3, 22  say '1-PRODUCAO  '
      if lTIPO02
         @  3, 36 say '2-FERR.'
      endif
      @  3, 50 say '3-MO.PRODUCAO'
      if lTIPSER
         @  3, 64 say 'SERVICOS'
      endif
      @  3, 80  say 'TOTAL MERCAD.'
      @  3, 93  say '  % '
      @  3, 101 say 'TOTAL DA N.F.'
      @  3, 117 say "Saldo O/DEV"
      @  4,  0  say repl( '-', 132 )
      CTLIN := 5
   endif

   if total <> 0.00
      if cARQ == "APURA2C"
         @ CTLIN, 06 say if( empty( GRUPOEMP ), "OUTROS", GRUPOEMP )
      else
         @ CTLIN, 00 say FORNECEDO
         @ CTLIN, 06 say COGNOME
      endif
      @ CTLIN, 22 say PROD pict '@E 99,999,999.99'
      if lTIPO02
         @ CTLIN, 36 say FERRA pict '@E 99,999,999.99'
      endif
      @ CTLIN, 50 say MOPROD pict '@E 99,999,999.99'
      if lTIPSER
         @ CTLIN, 64 say SERV pict '@E 99,999,999.99'
      endif
      @ CTLIN, 079 say TOTALMER       pict '@E 99,999,999.99'
      @ CTLIN, 094 say PORCENTO       pict '@E 99.99'
      @ CTLIN, 100 say total          pict '@E 999,999,999.99'
      @ CTLIN, 114 say total - ABADEV pict '@E 999,999,999.99'
      // Acumuladores dos Totais Gerais das Vendas.
      mTOTAL1  += PROD
      mTOTAL2  += FERRA
      mTOTAL3  += MOPROD
      mTOTAL4  += MOFERRA
      mTOTAL5  += SERV
      mMERCADO += TOTALMER
      mTOTALNF += total
      CTLIN ++
      //Acumuladores auxiliares a serem usados no balanco
      mTOTNF1 += PROD2
      mTOTNF2 += FERRA2
      mTOTNF3 += MOPROD2
      mTOTNF4 += MOFERRA2
      mTOTNF5 += SERV2
      //Acumulador de Porcentagem.
      mACUMPORC += PORCENTO
      nTBATE    += ABADEV
   endif
   dbskip()
enddo
@ CTLIN, 00 say repl( '-', 132 )
CTLIN ++
@ CTLIN, 01  say "Total das Vendas=>"
@ CTLIN, 22  say mTOTAL1              pict '@E 999,999,999.99'
@ CTLIN, 36  say mTOTAL2              pict '@E 999,999,999.99'
@ CTLIN, 50  say mTOTAL3              pict '@E 999,999,999.99'
@ CTLIN, 64  say mTOTAL5              pict '@E 999,999,999.99'
@ CTLIN, 079 say mMERCADO             pict '@E 999,999,999.99'
@ CTLIN, 100 say mTOTALNF             pict '@E 999,999,999.99'
@ CTLIN, 114 say mTOTALNF - nTBATE    pict '@E 999,999,999.99'
CTLIN ++
@ CTLIN, 00 say repl( '-', 132 )
CTLIN ++

//C lculo do Total Final das Vendas
mMERCADO += mSUCATA1

@ CTLIN, 01  say "Vendas Diversas IMOBILIZADO/SUCATA e Outros==>"
@ CTLIN, 079 say mSUCATA1                                         pict '@E 999,999,999.99'
@ CTLIN, 094 say( mSUCATA1 * 100 ) / mTOTMERC                     pict '@E 99.99'
@ CTLIN, 100 say mSUCATA2                                         pict '@E 999,999,999.99'

//CTLIN++
//@ CTLIN, 01 SAY "Pretacao de Servicos                       ==>"
//@ CTLIN, 79 SAY mVALPRES PICT '@E 999,999,999.99'
//@ CTLIN,094 SAY (mVALPRES*100)/mTOTMERC       PICT '@E 99.99'
//@ CTLIN,100 SAY mVALPRES PICT '@E 999,999,999.99'

CTLIN ++
@ CTLIN, 00 say repl( '-', 132 )
CTLIN ++
@ CTLIN, 01  say "Total Final Vendas"
@ CTLIN, 19  say mTOTAL1                                 pict '@E 999,999,999.99'
@ CTLIN, 49  say mTOTAL3                                 pict '@E 999,999,999.99'
@ CTLIN, 079 say mMERCADO                                pict '@E 999,999,999.99'
@ CTLIN, 100 say mTOTALNF + mSUCATA2 + mVALPRES          pict '@E 999,999,999.99'
@ CTLIN, 114 say mTOTALNF + mSUCATA2 + mVALPRES - nTBATE pict '@E 999,999,999.99'
CTLIN ++
@ CTLIN, 00 say repl( '-', 132 )
CTLIN ++

//STORE 0.00 TO NR9A,NR10A
@ CTLIN,  2 say 'DEVOLUCOES/ABATIMENTOS DE VENDAS POR CLIENTE'
CTLIN ++
@ CTLIN, 00 say repl( '-', 132 )
CTLIN ++

for Z := 1 to len( aBATE )
   IF ASCAN(aUFE,aBATE[Z][1])=0
     @ CTLIN, 01  say str( aBATE[ Z, 1 ], 5 )
     @ CTLIN, 07  say aBATE[ Z, 2 ]
     @ CTLIN, 70  say aBATE[ Z, 3 ]
     @ CTLIN, 079 say aBATE[ Z, 4 ]           pict '@E 999,999,999.99'
     @ CTLIN, 100 say aBATE[ Z, 5 ]           pict '@E 999,999,999.99'
     CTLIN ++
   ENDIF
next Z

@ CTLIN, 00 say repl( '-', 132 )
CTLIN ++
@ CTLIN,  1  say 'TOTAL DEVOLUCOES=>'
@ CTLIN, 079 say mTOTD                pict '@E 999,999,999.99'
@ CTLIN, 100 say mTOTDNF              pict '@E 999,999,999.99'
CTLIN ++
@ CTLIN, 00 say repl( '-', 132 )
CTLIN ++
IF CTLIN>55
   CTLIN:=0
   @ CTLIN, 00 say repl( '-', 132 )
   CTLIN ++
ENDIF
@ CTLIN,  1 say '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BALANCO FINAL DO PERIODO =>>>>>'

//Total Mercadoria menos Total da Devolucao
mBALANCO1 := mMERCADO - mTOTD
//Total da nota (com imposto) menos o total da devolucao com imposto
mBALANCO2 := mTOTALNF + mSUCATA2 + mVALPRES - mTOTDNF

@ CTLIN, 079 say mBALANCO1 pict '@E 999,999,999.99'
@ CTLIN, 100 say mBALANCO2 pict '@E 999,999,999.99'
CTLIN ++
@ CTLIN, 00 say repl( '-', 132 )

//Totais sem Imposto
PRODUCAO := mTOTAL1 + mTOTAL2 + mTOTAL3

//Totais com Imposto
mTOTAL1NF := mTOTNF1 + mTOTNF2 + mTOTNF3

mPORC1 := mPORC4 := mPROC5 := 0.00

mBASE2 := PRODUCAO + mTOTAL5            //Sem Imposto
mBASE  := mTOTAL1NF + mTOTNF5           //Com Imposto
mBASEP := mTOTAL1NF + mTOTNF5 + mTOTDNF

mPORC1 := if( mTOTAL1NF > 0, TRUNCAR( mTOTAL1NF / mBASEP * 100 ), 0 )
mPORC4 := if( mTOTDNF > 0, TRUNCAR( mTOTDNF / mBASEP * 100 ), 0 )
mPORC5 := if( mTOTNF5 > 0, TRUNCAR( mTOTNF5 / mBASEP * 100 ), 0 )

CTLIN ++
@ CTLIN, 17 say ' SEM  IMPOSTO  '
@ CTLIN, 35 say ' COM  IMPOSTO  '
@ CTLIN, 53 say '%'
CTLIN ++
@ CTLIN,  1 say 'PRODUCAO (1+2+3)=>'
@ CTLIN, 19 say PRODUCAO             pict '@E 999,999,999.99'
@ CTLIN, 34 say mTOTAL1NF            pict '@E 999,999,999.99'
@ CTLIN, 50 say mPORC1               pict '@E 999.99'

CTLIN ++
@ CTLIN,  1 say 'SERVICOS        =>'
@ CTLIN, 19 say mTOTAL5              pict '@E 999,999,999.99'
@ CTLIN, 34 say mTOTNF5              pict '@E 999,999,999.99'
@ CTLIN, 50 say mPORC5               pict '@E 999.99'

CTLIN ++
@ CTLIN, 01 say 'DEVOLUCOES    =>'
@ CTLIN, 19 say mTOTD              pict '@E 999,999,999.99'
@ CTLIN, 34 say mTOTDNF            pict '@E 999,999,999.99'
@ CTLIN, 50 say mPORC4             pict '@E 999.99'

CTLIN ++
@ CTLIN, 00 say repl( '-', 132 )
CTLIN ++
@ CTLIN, 01 say 'RESUMO FINAL ===>'
@ CTLIN, 19 say mBASE2 - mTOTD      pict '@E 999,999,999.99'
@ CTLIN, 34 say mBASE - mTOTDNF     pict '@E 999,999,999.99'
CTLIN ++
@ CTLIN, 00 say repl( '-', 132 )
CTLIN ++
@ CTLIN, 01 say 'FATURADO MES ANTERIOR => '
@ CTLIN, 50 say FATMESANT                   pict '@E 999,999,999.99'
CTLIN ++
@ CTLIN, 01 say 'FATURADO MES ATUAL ===>'
@ CTLIN, 50 say mBASE - mTOTDNF           pict '@E 999,999,999.99'
CTLIN ++
DIFMES := ( mBASE - mTOTDNF - FATMESANT )
if FATMESANT <> 0.00
   PARDIF := ( ( ( ( mBASE - mTOTDNF ) / FATMESANT ) - 1 ) * 100 )
else
   PARDIF := 0.00
endif
@ CTLIN, 01  say 'DIFERENCA ENTRE MES ==>'
@ CTLIN, 050 say DIFMES                    pict '@E 999,999,999.99'
@ CTLIN, 065 say PARDIF                    pict '@E 999.99'
@ CTLIN, 072 say '%'
CTLIN ++
@ CTLIN, 01 say 'TOTAL DE DESPESAS ====>'
@ CTLIN, 25 say mDESPMES                  pict '@E 999,999,999.99'
mSAL3 := ( mBASE - mDESPMES - mTOTDNF )
@ CTLIN, 44 say 'SALDO'
@ CTLIN, 50 say mSAL3   pict '@E 999,999,999.99'
CTLIN ++
@ CTLIN, 00 say repl( '-', 132 )
dbcloseall()
IMPFOL()

//Gravando o resultado
if ( !lTIPO02 ) .or. ( !lTIPSER )       //Se Nao For Completo nao Grava
   if !VERSEHA( "APUITA", str( nANOUSO, 4 ) + str( nMESUSO, 2 ) )
      mANO   := nANOUSO
      mMES   := nMESUSO
      mSALDO := mSAL3
      NOVOREG( "APUITA", str( nANOUSO, 4 ) + str( nMESUSO, 2 ) )
   else
      GRAVAMVAR( "APUITA", str( nANOUSO, 4 ) + str( nMESUSO, 2 ), "SALDO", "mSAL3" )
   endif
endif
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function COMPRAS()
*+
*+    Called from ( m_bm6a.prg   )   1 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func COMPRAS        //Pega os Dados e Valores armazenados no NF Compras.

if !USEREDE( ARQWORK2, 1, 4 )           //Notas Fiscais de Compras (TOTNF decresc.)
   retu .F.
endif
dbgotop()
while !eof()
   xFORNECEDO := FORNECEDO
   xCOGN      := COGNOME
   xTOTNF     := xTOTMER := 0.00
   while xCOGN = COGNOME .and. !eof()
      if left( OPERACAO, 3 ) = "131" .or. left( OPERACAO, 3 ) = "231" .or. left( OPERACAO, 3 ) = "331"
         xCOGN      := COGNOME
         xFORNECEDO := FORNECEDO
         xTOTMER    += TOTMER
         xTOTNF     += TOTNF
      endif
      dbskip()
   enddo
   if xTOTNF > 0 .or. xTOTMER > 0
      aadd( aBATE, { xFORNECEDO, xCOGN, "DEV", xTOTMER, xTOTNF } )
      mTOTD   += xTOTMER                //Acumula o Total da Devolucao  (TOTDEV)
      mTOTDNF += xTOTNF                 //Acumula o Total da Devolucao com imposto (TOTDEVNF)
   endif
enddo
dbclosearea()

if !USEREDE( ARQWORK3, 1, 3 )           //Contas Recebidas Por Cliente
   retu .F.
endif
set filter to ABATER > 0
dbgotop()
while !eof()
   xFORNECEDO := FORNECEDO
   xCOGN      := COGNOME
   xTOTNF     := xTOTMER := 0.00
   while xFORNECEDO = FORNECEDO .and. !eof()
      if ABATER > 0 .and. !empty( DOCABATE )
         aadd( aNFNR, { NUMERO, ABATER } )
         xTOTMER += ABATER
         xTOTNF  += ABATER
      endif
      dbskip()
   enddo
   if xTOTNF > 0
      aadd( aBATE, { xFORNECEDO, xCOGN, "ABA", xTOTMER, xTOTNF } )
      mTOTD   += xTOTMER                //Acumula o Total da Devolucao  (TOTDEV)
      mTOTDNF += xTOTNF                 //Acumula o Total da Devolucao com imposto (TOTDEVNF)
   endif
enddo
dbclosearea()
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function TRUNCAR()
*+
*+    Called from ( m_bm6a.prg   )   3 - function mbm6ab()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func TRUNCAR( Arg1 )

local Local1 := 0
local Local2 := 0
local vdpos
vdpos := at( ".", str( Arg1 * 100 ) ) - 1
if ( vdpos > 0 )
   Local2 := val( substr( str( Arg1 * 100 ), 1, vdpos ) )
   Local1 := Local2 / 100
else
   Local1 := Arg1
endif
return Local1

*+ EOF: M_BM6A.PRG
