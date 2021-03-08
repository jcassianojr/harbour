*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BY5.PRG
*+
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

MDI( " Э Controle de Paradas" )
CTLIN := 80
nSEQ  := 0
lANA  := MDG( "Resumo Analitico" )
lSIN  := MDG( "Resumo Sintetico" )
lMAQ  := MDG( "Resumo Maquinas" )

MDS( "Filtro Requisi‡oes" )
FILTRO := ''
FILTRO := RFILORD( "MY03", .F. )
MDS( "Filtro Paradas" )
FILTR2 := ''
FILTR2 := RFILORD( "MY03A", .F. )

aCPAR  := {}
aCPARD := {}
aCPAD  := {}
aCPADD := {}
nCON   := 0

if !USEREDE( "MD02", 1, 1 )
   retu .F.
endif
dbgotop()
dbseek( "CODPAR" )
while "CODPAR " = alltrim( CODIGO ) .and. !eof()
   aadd( aCPAR, left( CODIGO1, 3 ) )
   aadd( aCPARD, { 0, DESCRICAO } )
   dbskip()
enddo

dbgotop()
dbseek( "CODPARD" )
while alltrim( CODIGO ) = "CODPARD" .and. !eof()
   aadd( aCPAD, left( CODIGO1, 1 ) )
   aadd( aCPADD, { 0, DESCRICAO } )
   dbskip()
enddo
dbclosearea()

//Matriz Maquinas
nCOD := len( aCPAR )

aRETU   := PERFEC( { "MY03", "MY03A" }, { "Y3", "YA" }, { "Y399", "YA99" }, { "DATOPR", "PADRAO" } )
nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQ    := aRETU[ 5, 1 ]
cARQ2   := aRETU[ 5, 2 ]
cCAB    := aRETU[ 7 ]
lGRA    := .F.
if aRETU[ 6 ] = 2   //Mes Fechado
   lGRA := MDG( "Gravar Apura‡„o" )
   if lGRA
      lGRA := SENHAX( "MBY005" )
   endif
endif

if !CHECKIMP( 0 )
   retu .F.
endif
//cAE := IMP( "AE" )
//cAC := IMP( "AC" )
cAE := aCHR[2]
cAC := aCHR[1]


if !USEMULT( { { CARQ2, 1, 1 }, { cARQ, 1, 1 } } )
   retu .F.
endif

dbselectar( cARQ2 )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","CODPAR + str( NUMERO, 8 )")
ordSetFocus("temp")
if !empty( FILTR2 )
   set filter to &FILTR2
endif

dbselectar( cARQ )
if !empty( FILTRO )
   set filter to &FILTRO
endif

if lGRA
   if !USEMULT( { { "RD", 0, 99 }, { "RDP", 0, 99 }, { "RDPD", 0, 99 } } )
      retu .F.
   endif
   dbselectar( "RD" )
   dbsetorder( 2 )
   dbgotop()
   if dbseek( str( nANOUSO, 4 ) + str( nMESUSO, 2 ) )
      nSEQ := SEQ
   endif
   if nSEQ > 0
      dbselectar( "RDP" )
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{||SEQ=nSEQ}, {|| zei_fort(nLASTREC,,,1)})
      pack
      
      dbselectar( "RDPD" )
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{||SEQ=nSEQ}, {|| zei_fort(nLASTREC,,,1)})     
      pack
      
   endif
endif

MDS( "Apurando: " )
aMAQ  := {}
aMAQD := {}
IMPRESSORA()
dbselectar( CARQ2 )
dbgotop()
while !eof()
//   IF CODMAQ="TER" //Pula Tratamento Terceiros
//      WHILE CODMAQ="TER".AND.! EOF()
//         DBSKIP()
//      ENDDO
//   ENDIF
   nCODPAR := CODPAR
   CTLIN   := 80
   while nCODPAR = CODPAR .and. !eof()
      nTEMPO := 0
      VIDEO()
      @ 24, 10 say nCODPAR
      @ 24, 20 say NUMERO
      IMPRESSORA()
      if CTLIN > 55 .and. lANA
         @  0,  0 say cAE + "Ficha de Parada"
         @  1,  0 say cAC + "M_BY5"
         @  1, 10 say cCAB
         @  1, 60 say time()
         @  1, 70 say ZDATA
         @  2, 00 say "Codigo Parada " + nCODPAR
         @  3,  0 say "Numero"
         @  3,  9 say "Item"
         @  3, 13 say "Cod"
         @  3, 18 say "Ini"
         @  3, 26 say "Fim"
         @  3, 32 say "Tot"
         @  3, 38 say "OBS"
         @  4,  0 say repl( "-", 132 )
         CTLIN := 5
      endif
      mNUMERO := NUMERO
      dbselectar( cARQ )
      if dbseek( mNUMERO )              //Se tem cabecario requisicao
         mCODMAQ := CODMAQ
         dbselectar( CARQ2 )
         if lANA
            @ CTLIN,  0 say NUMERO
            @ CTLIN,  9 say ITEM
            @ CTLIN, 13 say CODPAR
            @ CTLIN, 16 say CODPARD
            @ CTLIN, 18 say PINI
            @ CTLIN, 26 say PFIM
            @ CTLIN, 32 say TEMPO
            @ CTLIN, 38 say OBS
            CTLIN ++
         endif
         nTEMPO := TEMPO
         nPOS   := ascan( aMAQ, mCODMAQ )
         if nPOS = 0
            aTEMP := array( nCOD )
            afill( aTEMP, 0 )
            aadd( aMAQ, mCODMAQ )
            aadd( aMAQD, aTEMP )
            nPOS := len( aMAQ )
         endif
         nPOSC := ascan( aCPAR, CODPAR )
         if nPOSC > 0
            aMAQD[ nPOS, nPOSC ] += TEMPO
         endif
         if nCODPAR = "999"
            nPOS := ascan( aCPAD, CODPARD )
            if nPOS > 0
               aCPADD[ nPOS, 1 ] += TEMPO
            else
               nCODPARD:=CODPARD
               VIDEO()
               ALERTX( "Cheque Sub-Codigo: 999/" + nCODPARD + " Requisi‡„o:" + str( mNUMERO ) )
               lGRA:=.F.
               IF ! MDG("Continuar Nao Grava Apuracao")
                  dbcloseall()
                  retu
               ENDIF
               impressora()
            endif
         endif
         nPOS := ascan( aCPAR, nCODPAR )
         if nPOS > 0
            aCPARD[ NPOS, 1 ] += TEMPO
         else
            VIDEO()
            ALERTX( "Cheque Codigo: " + nCODPAR + " Requisi‡„o:" + str( mNUMERO ) )
            lGRA:=.F.
            IF ! MDG("Continuar Nao Grava Apuracao")
               dbcloseall()
               RETU
            ENDIF
            impressora()
         endif
      endif
      dbselectar( CARQ2 )
      dbskip()
   enddo
enddo

IMPFOL()
if lSIN
   @  0,  0 say cAE + "Ficha de Paradas"
   @  1,  0 say cAC + "M_BY5B"
   @  1, 60 say time()
   @  1, 70 say ZDATA
   @  2, 00 say "Resumo Geral"
   @  2, 20 say cCAB
   @  3,  0 say repl( "-", 132 )
   @  4,  0 say "Codigo"
   @  4, 70 say "Horas"
   @  5, 00 say repl( "-", 132 )
   CTLIN := 6
endif
nHORAS := 0
for X := 1 to len( aCPAR )
   nHORAS += aCPARD[ X, 1 ]
   if lSIN
      @ CTLIN,  0 say aCPAR[ X ]
      @ CTLIN,  5 say aCPARD[ X, 2 ]
      @ CTLIN, 70 say aCPARD[ X, 1 ] pict "99999.99"
      CTLIN ++
   endif
   if nSEQ > 0
      if !empty( aCPAR[ X ] ) .and. lGRA
         dbselectar( "RDP" )
         netrecapp()
         field->SEQ    := nSEQ
         field->NUMERO := aCPAR[ X ]
         field->HP     := aCPARD[ X, 1 ]
         field->NOME   := aCPARD[ X, 2 ]
      endif
   endif
next X

for X := 1 to len( acPAD )
   if lSIN
      @ CTLIN,  0 say acPAD[ X ]
      @ CTLIN,  5 say acPADD[ X, 2 ]
      @ CTLIN, 70 say acPADD[ X, 1 ] pict "99999.99"
      CTLIN ++
   endif
   if nSEQ > 0
      if !empty( acPAD[ X ] ) .and. lGRA
         dbselectar( "RDPD" )
         netrecapp()
         field->SEQ    := nSEQ
         field->NUMERO := acPAD[ X ]
         field->HP     := acPADD[ X, 1 ]
         field->NOME   := acPADD[ X, 2 ]
      endif
   endif
next X
if lSIN
   //Totais
   @ CTLIN,  0 say repl( "-", 132 )
   CTLIN ++
   @ CTLIN,  0 say "Geral"
   @ CTLIN, 15 say nHORAS  pict "9999.99"
   CTLIN ++
   @ CTLIN,  0 say repl( "-", 132 )
endif
if lGRA
   dbselectar( "RD" )
   dbsetorder( 1 )
   dbgotop()
   if dbseek( nSEQ )
      field->PAHP := nHORAS
   endif
   dbcloseall()
endif

if lMAQ
   CTLIN := 80
   aTEMP := array( nCOD )
   afill( aTEMP, 0 )
   aGER := aTEMP
   for X := 1 to len( aMAQ )
      if CTLIN > 55
         @  0,  0 say cAE + "Ficha de Paradas Resumos Maquinas"
         @  1,  0 say cAC + "M_BY5C"
         @  1, 60 say time()
         @  1, 70 say ZDATA
         @  2, 00 say "Resumo Geral"
         @  3,  0 say repl( "-", 132 )
         @  4,  0 say "Maquina"
         @  5,  0 say repl( "-", 132 )
         CTLIN := 6
      endif
      @ CTLIN,  0 say aMAQ[ X ]
      @ CTLIN,  5 say ACENTO( OBTER( "ME01", aMAQ[ X ], "NOME" ) )
      CTLIN ++
      nTOT := 0
      for W := 1 to len( aCPAR )
         @ CTLIN,  0 say aCPAR[ W ]
         @ CTLIN,  5 say aCPARD[ W, 2 ]
         @ CTLIN, 70 say aMAQD[ X, W ]  pict "99999.99"
         aGER[ W ] += aMAQD[ X, W ]
         nTOT += aMAQD[ X, W ]
         CTLIN ++
      next W
      @ CTLIN,  0 say "Total Equipamento"
      @ CTLIN, 70 say nTOT                pict "99999.99"
      CTLIN ++
   next X
   nTOT := 0
   @ CTLIN,  0 say "Total Geral"
   CTLIN ++
   for W := 1 to len( aCPAR )
      @ CTLIN,  0 say aCPAR[ W ]
      @ CTLIN,  5 say aCPARD[ W, 2 ]
      @ CTLIN, 70 say aGER[ W ]      pict "99999.99"
      nTOT += aGER[ W ]
      CTLIN ++
   next W
endif
IMPFOL()
IMPEND()

*+ EOF: M_BY5.PRG
