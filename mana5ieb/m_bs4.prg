*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+    Source Module => J:\ITAESBRA\M_BS4.PRG
*+
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ

//#INCLUDE "COMANDO.CH"
MDI( " Ý Controle de Entrega/Entregar" )
para nTIPO, nIND

//Verificando a Impressora
if !CHECKIMP( 0 )
   return .F.
endif

cIMPAE := IMP( "AE" )

//Pegando o Filtro do Relatorio
//FILTRO := ''
//FILTRO := RFILORD( "MS01", .F. )
CRIARVARS( "BS5" )
CRIARVARS( "BS6" )


sMBS401 := SENHAX( "MBS401",, .F. )
aBS4001 := PEGLAY( "MEXPOR1", "BS4001" )
aBS4002 := PEGLAY( "MEXPOR1", "BS4002" )

lBAS   := MDG( "Resumo Dia a Dia" )
lRES   := MDG( "Resumo Final Produto" )
lCLI   := MDG( "Resumo Cliente e Apura‡Æo Grava‡Æo" )
lCOM   := MDG( "Resumo de Composi‡„o" )
lCAN  :=.T.
IF nTIPO=1.or.nTIPO=3
   lCAN:=MDG("Incluir Canceladas")
ENDIF
nCOT01 := nCOT02 := nCOT03 := nCOT04 := 0
aPROD  := {}
aCLIC  := {}
aCLID  := {}

ARQNFI := "MM02"
ARQNF  := "MM01"

lGRA   := .F.
FILTRA := ''
if nTIPO = 1
   aRETU := PERFEC( { "MM02","MM01" }, { "M2","M1" }, { "MM92","MM91" } )
   mMES  := aRETU[ 1 ]
   mANO  := aRETU[ 2 ]
   ARQNFI:= aRETU[ 5, 1 ]
   ARQNF := aRETU[5,2]
   cCAB  := aRETU[ 7 ]

   //Pegando o Filtro do Relatorio
   FILTRA := RFILORD( "MM02", .F. )
   if aRETU[ 6 ] = 2                    //Mes Fechado
      lGRA := MDG( "Gravar Apura‡„o" )
      if lGRA
         lGRA := SENHAX( "MBS402" )
      endif
   endif
endif

if nTIPO = 2
   ARQNFI    := "MO02"
   OPERACAO := "XXX"                    //Fixa Varivel que n„o tem em Pedidos
   //Pegando o Filtro do Relatorio
   FILTRA := RFILORD( "MO02", .F. )
endif


mds("Abrindo Arquivos")
if nTIPO = 1
   if ! USEMULT( { { ARQNFI, 1, nIND }, {ARQNF,1,1},{ "MS01", 1, 1 } } )
      retu .F.
   endif
endif
IF nTIPO=2.or.ntipo=3
   if ! USEMULT( { { ARQNFI, 1, nIND },{ "MS01", 1, 1 } } )
      retu .F.
   endif
endif
//MDS( "Filtro de Produtos" )
//dbselectar( "MS01" )
//if !empty( FILTRO )
//   set filter to &FILTRO.
//endif

dbselectar( ARQNFI )
if ! empty( FILTRA )
   mds("Filtro Notas")
   set filter to &FILTRA.
endif

mds("Iniciando")
CTLIN    := 60
nOLDOS := 0
dOLDDA := ctod( "00/00/00" )
IMPRESSORA()
dbselectar( "MS01" )
dbgotop()
while !eof()
   VIDEO()
   @ 24,00 SAY CODIGO
   @ 24,75 say "   "
   IMPRESSORA()
   nTOT     := 0
   nTOTSAL  := 0
   nCON01   := nCON02 := nCON03 := nCON04 := 0
   mCODIGO  := CODIGO
   mNOME    := NOME
   mSEQAREA := SEQAREA
   mULTIMONF:= ULTIMONF
   mULTIMOFA:= ULTIMOFA
   //CTLIN    := 60
   lTEM     := .F.
   lFOL     :=.T.
   dbselectar( ARQNFI )
   dbgotop()
   dbseek( mCODIGO )
   while CODIGO = mCODIGO .and. !eof()
      VIDEO()
      @ 24,75 SAY "GRV"
      IMPRESSORA()
      IF nTIPO#2
         IF NUMERO>mULTIMONF.AND.TIPOENT="P" //so atualiza se for produto
            mULTIMONF:=NUMERO
            mULTIMOFA:=DATA
         ENDIF
         IF TIPOENT<>"P".AND.mULTIMONF=NUMERO
            mULTIMONF:=0
            mULTIMOFA:=CTOD(SPACE(8))
         ENDIF
      ENDIF
      lCANCELA:=.F.
      IF nTIPO=1
         mNUMERO:=NUMERO
         DBSELECTAR(ARQNF)
         DBGOTOP()
         IF DBSEEK(mNUMERO)
            IF CANCELADA="S"
               lCANCELA:=.T.
            ENDIF
         ENDIF
      ENDIF
      VIDEO()
      IF nTIPO=1.OR.nTIPO=3
         @ 24,30 SAY NUMERO
      ELSE
         @ 24,30 SAY PEDIDO
      ENDIF
      IMPRESSORA()
      dbselectar( ARQNFI )
      if IF(nTIPO=2,.T., APURA # "N".and. ESPECIE # "NFC".AND.! EMPTY(OS).AND. (lCAN.OR.! lCANCELA).AND.TIPOENT="P")
         lTEM := .T.
         if CTLIN > 50 .and. lBAS
            @  0,  0 say cIMPAE + "CONTROLE DE ENTREGAS"
            @  1,  0 say "M_BS4 "
            @  1, 60 say time()
            @  1, 70 say ZDATA
            @  2,  0 say "PECA: " + alltrim( mCODIGO ) + " - " + ACENTO( mNOME )
            IF nTIPO=2
               @  3,  0 say "Data                   OS          Qtdde  Saldo  Entrega CD Cliente"
            ELSE
               @  3,  0 say "Data        No.        OS   Preco  Qtdde  Progr  Entrega CD Cliente"
            ENDIF
            @  4,  0 say repl( "-", 80 )
            CTLIN := 5
            lFOL     :=.F.
         else
            IF lFOL.and.Lbas
               @  ctlin,  0 say repl( "-", 80 )
               ctlin++
               @  ctlin,  0 say "PECA: " + alltrim( mCODIGO ) + " - " + ACENTO( mNOME )
               ctlin++
               @  ctlin,  0 say repl( "-", 80 )
               ctlin++
               lFOL     :=.F.
            ENDIF
         endif
         if lBAS
            @ CTLIN,  0 say DATA
         endif
         if nTIPO =2
            if lBAS
               @ CTLIN, 18 say OS PICT "9999.99"
               @ CTLIN, 34 say CONVUN( QTDEPED, UNID ) pict "@E 999999"
               @ CTLIN, 41 say CONVUN( QTDESAL, UNID ) pict "@E 999999"
               @ CTLIN, 48 say ENTREGA
               @ CTLIN, 59 SAY FORNECEDO PICT "999999"
               @ CTLIN, 66 SAY COGNOME
            endif
            nTOT     += CONVUN( QTDEPED, UNID )
            nTOTSAL  += CONVUN( QTDESAL, UNID )
         ENDIF
         if nTIPO = 1 .or. nTIPO = 3
            if lBAS
               @ CTLIN,  9 say STR(NUMERO,6)
               @ CTLIN ,16 SAY IF(lCANCELA,"*","")
               @ CTLIN, 18 say OS PICT "9999.99"
               if sMBS401
                  @ CTLIN, 26 say PRECO pict "@E 9999.99"
               endif
               @ CTLIN, 34 say CONVUN( QTDE, UNID )    pict "@E 999999"
               @ CTLIN, 41 say CONVUN( QTDESAL, UNID ) pict "@E 999999"
               @ CTLIN, 48 say ENTREGA
            endif
            nGRU1   := nGRU2 := nGRU3 := 0
            nQTD1   := nQTD2 := nQTD3 := 0
            cCODERR := ""
            //            IF OS#nOLDOS.OR.dOLDDA#DATA
            do case
            case DATA = ENTREGA .and. QTDE # QTDESAL
               cCODERR := "F2"
               nCON03 ++
               nCOT03 ++
               nGRU3 := 1
               nQTD3 := QTDE
            case DATA <= ENTREGA
               cCODERR := "FO"
               nCON01 ++
               nCOT01 ++
               nGRU1 := 1
               nQTD1 := QTDE
            case DATA = ENTREGA .and. QTDE = QTDESAL
               cCODERR := "FO"
               nCON01 ++
               nCOT01 ++
               nGRU1 := 1
               nQTD1 := QTDE
            case DATA > ENTREGA .and. QTDE = QTDESAL
               cCODERR := "F1"
               nCON02 ++
               nCOT02 ++
               nGRU2 := 1
               nQTD2 := QTDE
            otherwise
               cCODERR := "F2"
               nCON03 ++
               nCOT03 ++
               nGRU3 := 1
               nQTD3 := QTDE
            endcase
            if lBAS
               @ CTLIN, 57 say cCODERR
               @ CTLIN, 59 SAY FORNECEDO PICT "999999"
               @ CTLIN, 66 SAY ALLTRIM(PEDIDOCLI)
            endif
            nCON04 ++
            nCOT04 ++
            nOLDOS := OS
            dOLDDA := DATA
            nTOT   += CONVUN( QTDE, UNID )
            nPOS   := ascan( aCLIC, mCODIGO + str( FORNECEDO, 8 ) )
            if nPOS > 0
               aCLID[ NPOS, 2 ] += nGRU1
               aCLID[ NPOS, 3 ] += nGRU2
               aCLID[ NPOS, 4 ] += nGRU3
               aCLID[ NPOS, 5 ] ++
               aCLID[ NPOS, 6 ] += CONVUN( QTDE, UNID )
               aCLID[ NPOS, 8 ] += CONVUN( nQTD1, UNID )
               aCLID[ NPOS, 9 ] += CONVUN( nQTD2, UNID )
               aCLID[ NPOS, 10 ] += CONVUN( nQTD3, UNID )
            else
               aadd( aCLIC, mCODIGO + str( FORNECEDO, 8 ) )
               aadd( aCLID, { mCODIGO, nGRU1, nGRU2, nGRU3, 1, CONVUN( QTDE, UNID ), FORNECEDO, CONVUN( nQTD1, UNID ), CONVUN( nQTD2, UNID ), CONVUN( nQTD3, UNID ) } )
            endif
         endif
         CTLIN ++
      endif
      dbselectar( ARQNFI )
      dbskip()
   enddo
   if lTEM.and.Ntipo#2
      if lBAS
         @ CTLIN,  0 say "Total"
         @ CTLIN, 40 say nTOT    pict "@E 9999,999"
         CTLIN ++
         nPER01 := PERC( nCON01, nCON04 )
         nPER02 := PERC( nCON02, nCON04 )
         nPER03 := PERC( nCON03, nCON04 )
         @ CTLIN,  0 say "FO:  " + str( nCON01, 5 ) + " F1:  " + str( nCON02, 5 ) + " F2:  " + str( nCON03, 5 ) + " Ent:  " + str( nCON04, 5 )
         CTLIN ++
         @ CTLIN,  0 say "FO: " + str( nPER01, 6, 2 ) + " F1: " + str( nPER02, 6, 2 ) + " F2: " + str( nPER03, 6, 2 )
         IMPFOL()
      endif
      aadd( aPROD, { mCODIGO, nCON01, nCON02, nCON03, nCON04, nTOT, mSEQAREA, mNOME } )
   endif
   if Ntipo#2
      dbselectar( "MS01" )
      NETRECLOCK()
      FIELD->ULTIMONF:= mULTIMONF
      FIELD->ULTIMOFA:= mULTIMOFA
      DBUNLOCK()
   endif
    if Ntipo=2.and.ntot>0
       @  ctlin,  0 say repl( "-", 80 )
       ctlin++
       @  ctlin,  0 say "Total "
       @ CTLIN, 34 say nTOT pict "@E 999999"
       @ CTLIN, 41 say nTOTSAL pict "@E 999999"
       ctlin++
       @  ctlin,  0 say repl( "-", 80 )
   endif
   dbselectar( "MS01" )
   if mCODIGO = CODIGO
      while mCODIGO = CODIGO .and. !eof()                   //Salto diferentes compradores
         dbskip()
      enddo
   else
      dbskip()
   endif
enddo
dbcloseall()

if lRES.and.Ntipo#2
   VIDEO()
   IMPRESSORA()
   nTOTAL := 0
   @  0,  0 say "Resumo Final Produto"
   @  1,  0 say "Codigo"
   @  1, 25 say "FO      F1      F2      ENT    QTDE"
   CTLIN := 3
   for W := 1 to len( aPROD )
      @ CTLIN,  0 say aPROD[ W, 1 ]
      @ CTLIN, 25 say aPROD[ W, 2 ] pict "999"
      @ CTLIN, 32 say aPROD[ W, 3 ] pict "999"
      @ CTLIN, 39 say aPROD[ W, 4 ] pict "999"
      @ CTLIN, 46 say aPROD[ W, 5 ] pict "999"
      @ CTLIN, 53 say aPROD[ W, 6 ] pict "@E 9999,999"
      CTLIN ++
      @ CTLIN, 25 say PERC( aPROD[ W, 2 ], aPROD[ W, 5 ] ) pict "999.99%"
      @ CTLIN, 32 say PERC( aPROD[ W, 3 ], aPROD[ W, 5 ] ) pict "999.99%"
      @ CTLIN, 39 say PERC( aPROD[ W, 4 ], aPROD[ W, 5 ] ) pict "999.99%"
      nTOTAL += aPROD[ W, 6 ]
      CTLIN ++
   next W
   @ CTLIN,  0 say repl( "-", 80 )
   CTLIN ++
   @ CTLIN,  0 say "Total"
   @ CTLIN, 24 say nCOT01  pict "9999"
   @ CTLIN, 31 say nCOT02  pict "9999"
   @ CTLIN, 38 say nCOT03  pict "9999"
   @ CTLIN, 45 say nCOT04  pict "9999"
   @ CTLIN, 53 say nTOTAL  pict "@E 9999,999"
   CTLIN ++
   @ CTLIN, 25 say PERC( nCOT01, nCOT04 ) pict "999.99%"
   @ CTLIN, 32 say PERC( nCOT02, nCOT04 ) pict "999.99%"
   @ CTLIN, 39 say PERC( nCOT03, nCOT04 ) pict "999.99%"
   IMPFOL()
   dbcloseall()
endif

if lCOM
   aCOM  := {}
   aMAT  := {}
   aCOMQ := {}
   aMATQ := {}
   VIDEO()
   if !USEREDE( "MS03", 1, 1 )
      dbcloseall()
      retu .F.
   endif
   MDS( "Calculando Composi‡„o" )
   IMPRESSORA()
   for W := 1 to len( aPROD )
      dbgotop()
      dbseek( aPROD[ W, 1 ] )
      while alltrim( aPROD[ W, 1 ] ) = alltrim( CODIGO ) .and. !eof()
         if TIPOENT = "M"               //Materia Prima
            nPOS := ascan( aMAT, CODCOMP )
            if nPOS > 0
               aMATQ[ nPOS ] += QTDDE * aPROD[ W, 6 ]
            else
               aadd( aMAT, CODCOMP )
               aadd( aMATQ, QTDDE * aPROD[ W, 6 ] )
            endif
         endif
         if TIPOENT = "C"               //Componentes
            nPOS := ascan( aCOM, CODCOMP )
            if nPOS > 0
               aCOMQ[ nPOS ] += QTDDE * aPROD[ W, 6 ]
            else
               aadd( aCOM, CODCOMP )
               aadd( aCOMQ, QTDDE * aPROD[ W, 6 ] )
            endif
         endif
         dbskip()
      enddo
   next W
   dbcloseall()
   CTLIN := 80
   for W := 1 to len( aCOM )
      if CTLIN > 50
         @  0,  0 say "Resumo Final Produto Composi‡„o Componentes"
         @  1, 00 say "Componente"
         @  1, 25 say "Quantidade"
         CTLIN := 3
      endif
      @ CTLIN,  0 say aCOM[ W ]
      @ CTLIN, 25 say aCOMQ[ W ] pict "@E 9999,999.99"
      CTLIN ++
   next W
   IMPFOL()
   CTLIN := 80
   for W := 1 to len( aMAT )
      if CTLIN > 50
         @  0,  0 say "Resumo Final Produto Composi‡„o Materia Prima"
         @  1, 00 say "Mat. Prima"
         @  1, 25 say "Quantidade"
         CTLIN := 3
      endif
      @ CTLIN,  0 say aMAT[ W ]
      @ CTLIN, 25 say aMATQ[ W ] pict "@E 9999,999.99"
      CTLIN ++
   next W
   IMPFOL()
endif

if lCLI.and.Ntipo#2
   VIDEO()
   if !USEMULT( { { "MA01", 1, 1 }, { "MS01", 1, 1 } } )
      retu .F.
   endif
   if lGRA
      if !USEMULT( { { "BS5", 0, 99 }, { "BS6", 0, 99 }, { "BS1", 0, 99 }, { "BS2", 0, 99 } } )
         retu .F.
      endif
      dbselectar( "BS1" )
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{||MES = aRETU[ 1 ] .and. ANO = aRETU[ 2 ]}, {|| zei_fort(nLASTREC,,,1)})
      DBCLOSEAREA()
      dbselectar( "BS2" )
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{||MES = aRETU[ 1 ] .and. ANO = aRETU[ 2 ]}, {|| zei_fort(nLASTREC,,,1)})
      DBCLOSEAREA()
      dbselectar( "BS5" )
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{||MES = aRETU[ 1 ] .and. ANO = aRETU[ 2 ]}, {|| zei_fort(nLASTREC,,,1)})
      DBCLOSEAREA()
      dbselectar( "BS6" )
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{||MES = aRETU[ 1 ] .and. ANO = aRETU[ 2 ]}, {|| zei_fort(nLASTREC,,,1)})
      DBCLOSEAREA()
      if !USEMULT( { { "BS5", 1, 99 }, { "BS6", 1, 99 }, { "BS1", 1, 99 }, { "BS2", 1, 99 } } )
         retu .F.
      endif
   endif
   CTLIN  := 80
   nT01   := nT02 := nT03 := nT04 := 0
   nT06   := nT08 := nT09 := nT10 := 0
   aGRUPO := {}
   aGRUPD := {}
   IMPRESSORA()
   dbselectar( "MA01" )
   dbgotop()
   while !eof()
      lPRI     := .T.
      nG01     := nG02 := nG03 := nG04 := 0
      nG06     := nG08 := nG09 := nG10 := 0
      mCOGCLI  := COGNOME
      mGRUPO   := GRUPOEMP
      mCLIENTE := NUMERO
      mNOMECLI := NOME
      for W := 1 to len( aCLID )
         if aCLID[ W, 7 ] = NUMERO
            if CTLIN > 50
               @  0,  0 say "Resumo Final Cliente"
               @  1,  0 say "Codigo"
               @  1, 25 say "FO"
               @  1, 35 say "F1"
               @  1, 45 say "F2"
               @  1, 55 say "ENT"
               @  2,  0 say "Qtde"
               CTLIN := 3
            endif
            if lPRI
               @ CTLIN,  0 say repl( "=", 80 )
               CTLIN ++
               @ CTLIN,  0 say NUMERO
               @ CTLIN, 10 say NOME
               CTLIN ++
               @ CTLIN,  0 say repl( "-", 80 )
               CTLIN ++
               lPRI := .F.
            endif
            GRAVAVAR2( aBS4001 )
            @ CTLIN,  0 say aCLID[ W, 1 ]
            @ CTLIN, 25 say aCLID[ W, 2 ] pict "999"
            @ CTLIN, 35 say aCLID[ W, 3 ] pict "999"
            @ CTLIN, 45 say aCLID[ W, 4 ] pict "999"
            @ CTLIN, 50 say aCLID[ W, 5 ] pict "999"
            CTLIN ++
            @ CTLIN, 25 say mPER01 pict "999.99%"
            @ CTLIN, 35 say mPER02 pict "999.99%"
            @ CTLIN, 45 say mPER03 pict "999.99%"
            CTLIN ++
            @ CTLIN, 25 say aCLID[ W, 8 ]  pict "@E 9999,999"
            @ CTLIN, 35 say aCLID[ W, 9 ]  pict "@E 9999,999"
            @ CTLIN, 45 say aCLID[ W, 10 ] pict "@E 9999,999"
            @ CTLIN, 55 say aCLID[ W, 6 ]  pict "@E 9999,999"
            CTLIN ++
            @ CTLIN, 25 say mPEQ01 pict "999.99%"
            @ CTLIN, 35 say mPEQ02 pict "999.99%"
            @ CTLIN, 45 say mPEQ03 pict "999.99%"
            CTLIN ++
            CTLIN ++
            if lGRA
               mCODIGO := alltrim( aCLID[ W, 1 ] )
               mQTDDE  := aCLID[ W, 6 ]
               mF0     := aCLID[ W, 2 ]
               mF1     := aCLID[ W, 3 ]
               mF2     := aCLID[ W, 4 ]
               mENT    := aCLID[ W, 5 ]
               mQTD01  := aCLID[ W, 8 ]
               mQTD02  := aCLID[ W, 9 ]
               mQTD03  := aCLID[ W, 10 ]
               mNOME   := ""
               dbselectar( "MS01" )
               dbgotop()
               if dbseek( mCODIGO )
                  mNOME := NOME
                  for J := 1 to 10
                     cSTR := "mSET" + strzero( J, 2 )
                     if at( chr( 48 + J ), SEQAREA ) > 0
                        &cSTR. := mQTDDE
                     else
                        &cSTR. := 0
                     endif
                  next J
               else
                  for J := 1 to 10
                     cSTR   := "mSET" + strzero( J, 2 )
                     &cSTR. := 0
                  next J
               endif
               NOVOOPA( "BS5", .T., .T. )
            endif
         endif
         dbselectar( "MA01" )
      next W
      if nG01 + nG02 + nG03 + nG04 > 0
         mPER01 := PERC( NG01, NG04 )
         mPER02 := PERC( NG02, NG04 )
         mPER03 := PERC( NG03, NG04 )
         mPEQ01 := PERC( NG08, NG06 )
         mPEQ02 := PERC( NG09, NG06 )
         mPEQ03 := PERC( NG10, NG06 )
         mF0    := NG01
         mF1    := NG02
         mF2    := NG03
         mENT   := NG04
         mQTDDE := NG06
         mQTD01 := NG08
         mQTD02 := NG09
         mQTD03 := NG10
         mNOME  := mNOMECLI
         if lGRA
            NOVOOPA( "BS6", .T., .T. )
         endif
         @ CTLIN,  0 say repl( "-", 80 )
         CTLIN ++
         @ CTLIN,  0 say "TOTAL"
         @ CTLIN, 25 say nG01    pict "999"
         @ CTLIN, 35 say nG02    pict "999"
         @ CTLIN, 45 say nG03    pict "999"
         @ CTLIN, 55 say nG04    pict "999"
         CTLIN ++
         @ CTLIN, 25 say mPER01 pict "999.99%"
         @ CTLIN, 35 say mPER02 pict "999.99%"
         @ CTLIN, 45 say mPER03 pict "999.99%"
         CTLIN ++
         @ CTLIN, 25 say nG08 pict "@E 9999,999"
         @ CTLIN, 35 say nG09 pict "@E 9999,999"
         @ CTLIN, 45 say nG10 pict "@E 9999,999"
         @ CTLIN, 55 say nG06 pict "@E 9999,999"
         CTLIN ++
         @ CTLIN, 25 say mPEQ01 pict "999.99%"
         @ CTLIN, 35 say mPEQ02 pict "999.99%"
         @ CTLIN, 45 say mPEQ03 pict "999.99%"
         CTLIN ++
         @ CTLIN,  0 say repl( "=", 80 )
         CTLIN ++
         nPOS := ascan( aGRUPO, mGRUPO )
         if nPOS > 0
            aGRUPD[ NPOS, 1 ] += NG01
            aGRUPD[ NPOS, 2 ] += NG02
            aGRUPD[ NPOS, 3 ] += NG03
            aGRUPD[ NPOS, 4 ] += NG04
            aGRUPD[ NPOS, 5 ] += NG06
            aGRUPD[ NPOS, 6 ] += NG08
            aGRUPD[ NPOS, 7 ] += NG09
            aGRUPD[ NPOS, 8 ] += NG10
         else
            aadd( aGRUPO, mGRUPO )
            aadd( aGRUPD, { NG01, NG02, NG03, NG04, NG06, NG08, NG09, NG10 } )
         endif
      endif
      dbselectar( "MA01" )
      dbskip()
   enddo
   mPER01 := PERC( NT01, NT04 )
   mPER02 := PERC( NT02, NT04 )
   mPER03 := PERC( NT03, NT04 )
   mPEQ01 := PERC( NT08, NT06 )
   mPEQ02 := PERC( NT09, NT06 )
   mPEQ03 := PERC( NT10, NT06 )
   mF0    := NT01
   mF1    := NT02
   mF2    := NT03
   mENT   := NT04
   mQTDDE := NT06
   mQTD01 := NT08
   mQTD02 := NT09
   mQTD03 := NT10
   if lGRA
      NOVOOPA( "BS1", .T., .T. )
   endif
   IMPFOL()
   if lGRA
      for X := 1 to len( aGRUPO )
         GRAVAVAR2( aBS4002 )
         NOVOOPA( "BS2", .T., .T. )
      next X
   endif
   dbcloseall()
endif
VIDEO()
IMPEND()


*+ EOF: M_BS4.PRG
