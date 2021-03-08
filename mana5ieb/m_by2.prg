*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BY2.PRG
*+
*+    Functions: Function CABMBY2()
*+               Function CABMBY2B()
*+               Function MBY201()
*+               Function MBY202()
*+
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//
//
//
//
//#INCLUDE "COMANDO.CH"

MDI( " Э Ficha da Maquina" )
CTLIN := 80
aGER  := {}
lANA  := MDG( "Deseja Analitico" )
lDIA  := MDG( "Deseja Resumo Dia" )
lMES  := MDG( "Deseja Resumo Mensal" )
lGER  := MDG( "Deseja Resumo Geral" )
lP24  := MDG( "Escala 24 Somente Dias Escalados" )


FILTRO  := ''
FILTRO  := RFILORD( "MY03", .F. )

nSEQ    := 0
aRETU   := PERFEC( { "MY03", "MY03A", "ME03" }, { "Y3", "YA", "E3" }, { "Y399", "YA99", "E399" }, { "DATOPR", "PADRAO", "DATA" } )
nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQ    := aRETU[ 5, 1 ]
cARQ2   := aRETU[ 5, 2 ]
cARQ3   := aRETU[ 5, 3 ]
cCAB    := aRETU[ 7 ]
lGRA    := .F.
if aRETU[ 6 ] = 2   //Mes Fechado
   lGRA := MDG( "Gravar Apura‡„o" )
   if lGRA
      lGRA := SENHAX( "MBY002" )
   endif
endif

if !CHECKIMP( 0 )
   retu .F.
endif
//cAE := IMP( "AE" )
//cAC := IMP( "AC" )
cAE := aCHR[2]
cAC := aCHR[1]


if !USEMULT( { { CARQ, 1, 1 }, { cARQ2, 1, 1 }, { cARQ3, 1, 1 }, { "MS06", 1, 1 }, { "ME01", 1, 1 } } )
   retu .F.
endif

if lGRA
   if !USEMULT( { { "RD", 0, 99 }, { "RDE", 0, 99 } } )
      retu .F.
   endif
   dbselectar( "RD" )
   dbsetorder( 2 )
   dbgotop()
   if dbseek( str( nANOUSO, 4 ) + str( nMESUSO, 2 ) )
      nSEQ := SEQ
   endif
   if nSEQ > 0
      dbselectar( "RDE" )
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{||SEQ = nSEQ }, {|| zei_fort(nLASTREC,,,1)})
      pack
   endif
endif

dbselectar( cARQ )
if !empty( FILTRO )
   set filter to &FILTRO
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","CODMAQ + dtos( DATOPR ) + str( INIOPR, 5, 2 )")
ordSetFocus("temp")



IMPRESSORA()
dbselectar( cARQ )
dbgotop()
while !eof()
   IF CODMAQ="TER" //Pula Tratamento Terceiros
      WHILE CODMAQ="TER".AND.! EOF()
         DBSKIP()
      ENDDO
   ENDIF
   nCODMAQ := CODMAQ
   mNOME   := ""
   aMES    := {}
   aME2    := {}
   lGRAVA  := .T.
   dbselectar( "ME01" )
   dbgotop()
   if dbseek( nCODMAQ )
      mNOME  := NOME
      lGRAVA := if( APUEFI = "N", .F., .T. )
   endif
   VIDEO()
   @ 24, 00 say "Maquina: " + nCODMAQ + " " + mNOME
   IMPRESSORA()
   if CTLIN # 80
      @ CTLIN,  0 say "Maquina: " + nCODMAQ
      @ CTLIN, 20 say mNOME
      CTLIN ++
      @ CTLIN,  0 say repl( "-", 132 )
      CTLIN ++
   endif
   dbselectar( cARQ )
   while nCODMAQ = CODMAQ .and. !eof()
      nDIA := DATOPR
      aDIA := { 0, 0, 0, 0, 0 }
      while nCODMAQ = CODMAQ .and. nDIA = DATOPR .and. !eof()
         if BXMY03 <> "N" .and. EXCMAQ <> "S"
            mCHAVE  := padr( CODIGO, 24 ) + str( SEQ, 3 ) + str( SSQ, 3 )
            nPCHORA := 0
            dbselectar( "MS06" )
            dbgotop()
            if dbseek( mCHAVE )
               IF nDIA>=DATAINI
                  nPCHORA := PCHORA
               ENDIF
            endif
            dbselectar( cARQ )
            nHORAS := CHOR( FIMOPR + if( VIRADA = "S", 24, 0 ) ) - CHOR( INIOPR ) - PARADA - ( CHOR( ALMFIM ) - CHOR( ALMINI ) )
            nHORAS := round( nHORAS, 2 )
            if nHORAS < 0
               ALERTX( "Cheque Horas Requisi‡„o" + str( numero ) )
               nHORAS := 0
            endif
            if QTDDE < 0
               ALERTX( "Cheque Quantidade Requisi‡„o" + str( numero ) )
            endif
            nFEITO := 0
            if QTDDE > 0 .and. nHORAS > 0.001
               nFEITO := round( QTDDE / nHORAS, 2 )
            endif
            nHREF := 0
            if nPCHORA > 0 .and. nFEITO > 0
               nHREF := round( if( nPCHORA > 0, nFEITO / nPCHORA, 0 ), 2 )
            endif
            nHRE2 := 0
            if QTDDE > 0 .and. nPCHORA > 0
               nHRE2 := round( if( nPCHORA > 0, QTDDE / nPCHORA, 0 ), 2 )
            endif
            if TPMY03 = "S"
               nHREF   := 1
               nHRE2   := nHORAS
               nPCHORA := nFEITO
            endif
            nPARADA := 0
            //Calculos passiveis de implanta‡„o
            nPER01 := nHREF * 100
            nPER02 := nHREF * 100
            nPER03 := 100
            aDIA[ 1 ] += nHORAS
            aDIA[ 3 ] += nHRE2
            aDIA[ 4 ] += QTDDE
            netgrvcam("HORUSO",nHORAS)
            if lANA
               CABMBY2( .T. )
               @ CTLIN,  0  say NUMERO
               @ CTLIN,  9  say DATOPR
               @ CTLIN, 18  say left( CODIGO, 15 )
               @ CTLIN, 34  say SEQ
               @ CTLIN, 38  say SSQ
               @ CTLIN, 42  say CODOPE             pict "9999"
               @ CTLIN, 51  say INIOPR             pict "99.99"
               @ CTLIN, 57  say FIMOPR             pict "99.99"
               @ CTLIN, 63  say nHORAS             pict "99.99"
               @ CTLIN, 69  say nPARADA            pict "99.99"
               @ CTLIN, 75  say QTDDE              pict "999999"
               @ CTLIN, 82  say nFEITO             pict "9999.99"
               @ CTLIN, 90  say nPCHORA            pict "9999"
               @ CTLIN, 95  say nHRE2              pict "99.99"
               @ CTLIN, 101 say nPER01             pict "999.99"
               CTLIN ++
            endif
            mCHAVE := NUMERO
            dbselectar( cARQ2 )
            dbgotop()
            dbseek( str( mCHAVE, 8 ) )
            while mCHAVE = NUMERO .and. !eof()
               aDIA[ 2 ] += TEMPO
               if lANA
                  @ CTLIN, 35 say CODPAR
                  @ CTLIN, 51 say PINI            pict "99.99"
                  @ CTLIN, 57 say PFIM            pict "99.99"
                  @ CTLIN, 69 say TEMPO           pict "99.99"
                  @ CTLIN, 75 say left( OBS, 55 )
                  CTLIN ++
               endif
               dbskip()
            enddo
         endif
         dbselectar( cARQ )
         dbskip()
      enddo
      nESC := 0
      dbselectar( cARQ3 )
      dbgotop()
      if dbseek( nCODMAQ + dtos( nDIA ) )
         nESC := ESTQINI
      endif
      if empty( nESC )
         nTOT := aDIA[ 1 ] + aDIA[ 2 ]
      else
         nTOT := nESC
      endif
      nDIF   := nTOT - aDIA[ 2 ]
      nTO2   := aDIA[ 1 ] + aDIA[ 2 ]
      nDI2   := nTO2 - aDIA[ 2 ]
      nPER01 := PERC( aDIA[ 3 ], nDIF )
      nPER02 := PERC( aDIA[ 3 ], nTOT )
      nPER03 := PERC( aDIA[ 1 ], nTOT )
      if lDIA
         @ CTLIN,  0 say repl( "-", 132 )
         CTLIN ++
         @ CTLIN, 59  say "Esc"
         @ CTLIN, 67  say "HRs"
         @ CTLIN, 75  say "Par"
         @ CTLIN, 83  say "Qtdde"
         @ CTLIN, 91  say "Hr.Pr."
         @ CTLIN, 99  say "Efi"
         @ CTLIN, 107 say "Pro"
         @ CTLIN, 115 say "Utl"
         CTLIN ++
         MBY202( { "Escala", nDIA, nDIF, nESC, aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ], nPER01, nPER02, nPER03 } )
         MBY201( aDIA[ 3 ], aDIA[ 1 ], aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ],, "Apontada" )
         MBY201( aDIA[ 3 ], aDIA[ 1 ], 24 - aDIA[ 2 ], 24,, "24 Horas" )
         @ CTLIN,  0 say repl( "-", 132 )
         CTLIN ++
      endif
      aadd( aMES, { aDIA[ 1 ], aDIA[ 2 ], aDIA[ 3 ], nPER01, nPER02, nPER03, nDIA, aDIA[ 4 ], nESC } )
      aadd( aME2, nCODMAQ + dtos( nDIA ) )
      dbselectar( cARQ )
   enddo
   aDIA  := { 0, 0, 0, 0, 0 }
   nDIAS := 0
   dbselectar( cARQ3 )
   dbgotop()
   dbseek( nCODMAQ )
   while NUMERO = nCODMAQ .and. !eof()
      if ESTQINI > 0
         nPOS := ascan( aME2, nCODMAQ + dtos( DATA ) )
         if nPOS > 0
            aDIA[ 1 ] += aMES[ nPOS, 1 ]
            aDIA[ 2 ] += aMES[ nPOS, 2 ]
            aDIA[ 3 ] += aMES[ nPOS, 3 ]
            aDIA[ 4 ] += aMES[ nPOS, 8 ]                    //Qtde
            aDIA[ 5 ] += aMES[ nPOS, 9 ]                    //Escala
            if lMES
               CABMBY2B( .T. )
               MBY202( { "", aMES[ nPOS, 7 ], 0, aMES[ nPOS, 9 ], aMES[ nPOS, 1 ], aMES[ nPOS, 2 ], aMES[ nPOS, 8 ], aMES[ nPOS, 3 ], aMES[ nPOS, 4 ], aMES[ nPOS, 5 ], aMES[ nPOS, 6 ] } )
            endif
         else
            aDIA[ 5 ] += ESTQINI
            if lMES
               CABMBY2B( .T. )
               MBY202( { "", DATA, 0, ESTQINI, 0, 0, 0, 0, 0, 0, 0 } )
            endif
         endif
         if lP24
            nDIAS ++                    //Soma 24 de dias Escalados
         endif
      endif
      if !lP24
         nDIAS ++   //Soma 24 de dias Escalados
      endif
      dbskip()
   enddo

   dbselectar( cARQ )
   if empty( aDIA[ 5 ] )
      nTOT := aDIA[ 1 ] + aDIA[ 2 ]
   else
      nTOT := aDIA[ 5 ]
   endif
   nPER01 := PERC( aDIA[ 3 ], nTOT - aDIA[ 2 ] )
   nPER02 := PERC( aDIA[ 3 ], nTOT )
   nPER03 := PERC( aDIA[ 1 ], nTOT )
   nPER04 := PERC( aDIA[ 3 ], aDIA[ 1 ] )
   nPER05 := PERC( aDIA[ 3 ], aDIA[ 1 ] + aDIA[ 2 ] )
   nPER06 := PERC( aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )

   nPER07 := PERC( aDIA[ 3 ], ( 24 * nDIAS ) - aDIA[ 2 ] )
   nPER08 := PERC( aDIA[ 3 ], 24 * nDIAS )
   nPER09 := PERC( aDIA[ 1 ], 24 * nDIAS )

   if lMES
      MBY201( aDIA[ 3 ], aDIA[ 1 ], nTOT - aDIA[ 2 ], nTOT, { aDIA[ 5 ], aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ] },, "Escala: " + mNOME )
      MBY201( aDIA[ 3 ], aDIA[ 1 ], aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ],, "Apontada" )
      MBY201( aDIA[ 3 ], aDIA[ 1 ], ( 24 * nDIAS ) - aDIA[ 2 ], 24 * nDIAS,, "24Horas/Dia" )
      @ CTLIN,  0 say repl( "=", 132 )
      CTLIN ++
   endif
   aadd( aGER, { aDIA[ 1 ], aDIA[ 2 ], aDIA[ 3 ], nPER01, nPER02, nPER03, ;
                 nCODMAQ, mNOME, aDIA[ 4 ], aDIA[ 5 ], lGRAVA, 24 * nDIAS, ;
                 nPER04, nPER05, nPER06, nPER07, nPER08, nPER09 } )
   dbselectar( cARQ )
enddo
if lGER
   CTLIN := 80      //For‡ar Iniciar Uma FOLHA
endif
aDIA := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
for X := 1 to len( aGER )
   aDIA[ 1 ] += aGER[ X, 1 ]            //trabalhadas
   aDIA[ 2 ] += aGER[ X, 2 ]            //paradas
   aDIA[ 3 ] += aGER[ X, 3 ]            //hora referencia
   aDIA[ 4 ] += aGER[ X, 9 ]            //Qtde
   aDIA[ 5 ] += aGER[ X, 10 ]           //Escala
   aDIA[ 6 ] += aGER[ X, 12 ]           //24 Horas
   if lGER
      CABMBY2B( .F. )
      MBY202( { aGER[ X, 7 ], aGER[ X, 8 ], 0, aGER[ X, 10 ], aGER[ X, 1 ], aGER[ X, 2 ], aGER[ X, 9 ], aGER[ X, 3 ], aGER[ X, 4 ], aGER[ X, 5 ], aGER[ X, 6 ] } )
      CTLIN ++
   endif
   if nSEQ > 0 .and. lGRA .and. aGER[ X, 11 ]
      dbselectar( "RDE" )
      netrecapp()
      field->SEQ    := nSEQ
      field->HD     := aGER[ X, 10 ]    //Escalas
      field->HDRE   := aGER[ X, 1 ] + aGER[ X, 2 ]          //Horas Liquidas+Paradas
      field->HD24   := aGER[ X, 12 ]    //Escala 24 horas
      field->HP     := aGER[ X, 2 ]     //Horas Paradas
      field->HT     := aGER[ X, 1 ]
      field->PE     := aGER[ X, 4 ]
      field->PP     := aGER[ X, 5 ]
      field->PU     := aGER[ X, 6 ]
      field->NUMERO := aGER[ X, 7 ]
      field->NOME   := aGER[ X, 8 ]
      field->QP     := aGER[ X, 9 ]
      field->PERE   := aGER[ X, 13 ]
      field->PPRE   := aGER[ X, 14 ]
      field->PURE   := aGER[ X, 15 ]
      field->PE24   := aGER[ X, 16 ]
      field->PP24   := aGER[ X, 17 ]
      field->PU24   := aGER[ X, 18 ]
   endif
next X
if empty( aDIA[ 5 ] )
   nTOT := aDIA[ 1 ] + aDIA[ 2 ]
else
   nTOT := aDIA[ 5 ]
endif
nPER01 := PERC( aDIA[ 3 ], nTOT - aDIA[ 2 ] )
nPER02 := PERC( aDIA[ 3 ], nTOT )
nPER03 := PERC( aDIA[ 1 ], nTOT )
nPER04 := PERC( aDIA[ 3 ], aDIA[ 1 ] )
nPER05 := PERC( aDIA[ 3 ], aDIA[ 1 ] + aDIA[ 2 ] )
nPER06 := PERC( aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )
nPER07 := PERC( aDIA[ 3 ], aDIA[ 6 ] - aDIA[ 2 ] )
nPER08 := PERC( aDIA[ 3 ], aDIA[ 6 ] )
nPER09 := PERC( aDIA[ 1 ], aDIA[ 6 ] )
if lGER
   MBY201( aDIA[ 3 ], aDIA[ 1 ], nTOT - aDIA[ 2 ], nTOT, { aDIA[ 5 ], aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ] } )
   MBY201( aDIA[ 3 ], aDIA[ 1 ], aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )             //Apontadas
   MBY201( aDIA[ 3 ], aDIA[ 1 ], aDIA[ 6 ] - aDIA[ 2 ], aDIA[ 6 ] )             //24 HORAS
endif
IMPFOL()
if lGRA
   dbselectar( "RD" )
   dbsetorder( 1 )
   dbgotop()
   if dbseek( nSEQ )
      field->EQHD   := aDIA[ 5 ]
      field->EQHP   := aDIA[ 2 ]
      field->EQHT   := aDIA[ 1 ]
      field->EQQP   := aDIA[ 4 ]
      field->EQH24  := aDIA[ 6 ]
      field->EQPE   := nPER01
      field->EQPP   := nPER02
      field->EQPU   := nPER03
      field->EQPERE := nPER04
      field->EQPPRE := nPER05
      field->EQPURE := nPER06
      field->EQPE24 := nPER07
      field->EQPP24 := nPER08
      field->EQPU24 := nPER09
   endif
endif
dbcloseall()
IMPEND()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function CABMBY2()
*+
*+    Called from ( m_by2.prg    )   1 - function cabmby1()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func CABMBY2( lSAYF )

if CTLIN > 55
   @  0,  0  say cAE + "Ficha do Equipamento"
   @  1,  0  say cAC + "M_BY2"
   @  1, 60  say time()
   @  1, 70  say ZDATA
   @  2,  0  say "Req."
   @  2,  9  say "Data"
   @  2, 18  say "Peca No."
   @  2, 34  say "Ope"
   @  2, 42  say "Op"
   @  2, 51  say "Ini"
   @  2, 57  say "Fim"
   @  2, 63  say "HRs"
   @  2, 69  say "Par"
   @  2, 75  say "Qtdde"
   @  2, 82  say "Real"
   @  2, 90  say "Pad"
   @  2, 95  say "Hr.Pr."
   @  2, 101 say "Efi"
   @  2, 108 say "Pro"
   @  2, 115 say "Utl"
   CTLIN := 3
   if lSAYF
      @ CTLIN,  0 say "Equipamento: " + nCODMAQ
      @ CTLIN, 20 say mNOME
      CTLIN ++
      @ CTLIN,  0 say repl( "-", 132 )
      CTLIN ++
   endif
endif
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function CABMBY2B()
*+
*+    Called from ( m_by2.prg    )   3 - function cabmby1()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func CABMBY2B( lSAYF )

if CTLIN > 55
   @  0,  0  say cAE + "Ficha do Equipamento"
   @  1,  0  say cAC + "M_BY2"
   @  1, 60  say time()
   @  1, 70  say ZDATA
   @  2, 59  say "Esc"
   @  2, 71  say "HRs"
   @  2, 85  say "Par"
   @  2, 93  say "Qtdde"
   @  2, 101 say "Hr.Pr."
   @  2, 110 say "Efi"
   @  2, 117 say "Pro"
   @  2, 124 say "Utl"
   CTLIN := 3
   if lSAYF
      @ CTLIN,  0 say "Equipamento: " + nCODMAQ
      @ CTLIN, 20 say mNOME
      CTLIN ++
      @ CTLIN,  0 say repl( "-", 132 )
      CTLIN ++
   endif
endif

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBY201()
*+
*+    Called from ( m_by2.prg    )   8 - function cabmby1()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBY201( nVAL1, nVAL2, nDIFR, nTOTR, aVAL, cTITULO )

local aPER := { 0, 0, 0 }
aPER[ 1 ] := PERC( nVAL1, nDIFR )
aPER[ 2 ] := PERC( nVAL1, nTOTR )
aPER[ 3 ] := PERC( nVAL2, nTOTR )
if valtype( cTITULO ) # "U"
   @ CTLIN,  0 say left( cTITULO, 40 )
endif
@ CTLIN, 41 say nTOTR pict "99999.99"
@ CTLIN, 50 say nDIFR pict "99999.99"
if valtype( aVAL ) = "A"
   @ CTLIN, 59  say aVAL[ 1 ] pict "9999999.99"
   @ CTLIN, 71  say aVAL[ 2 ] pict "999999.99"
   @ CTLIN, 85  say aVAL[ 3 ] pict "9999.99"
   @ CTLIN, 93  say aVAL[ 4 ] pict "9999999"
   @ CTLIN, 101 say aVAL[ 5 ] pict "99999.99"
endif
@ CTLIN, 110 say aPER[ 1 ] pict "999.99"
@ CTLIN, 117 say aPER[ 2 ] pict "999.99"
@ CTLIN, 124 say aPER[ 3 ] pict "999.99"
CTLIN ++
retu aPER

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBY202()
*+
*+    Called from ( m_by2.prg    )   4 - function cabmby1()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBY202( aVAL )

@ CTLIN,  0 say aVAL[ 1 ]
@ CTLIN,  9 say padr( STRVAL( aVAL[ 2 ] ), 40 )
if aVAL[ 3 ] > 0
   @ CTLIN, 50 say aVAL[ 3 ] pict "9999.99"
endif
@ CTLIN, 59  say aVAL[ 4 ]  pict "9999999.99"
@ CTLIN, 71  say aVAL[ 5 ]  pict "999999.99"
@ CTLIN, 85  say aVAL[ 6 ]  pict "9999.99"
@ CTLIN, 93  say aVAL[ 7 ]  pict "9999999"
@ CTLIN, 101 say aVAL[ 8 ]  pict "99999.99"
@ CTLIN, 110 say aVAL[ 9 ]  pict "999.99"
@ CTLIN, 117 say aVAL[ 10 ] pict "999.99"
@ CTLIN, 124 say aVAL[ 11 ] pict "999.99"
CTLIN ++
retu .T.

*+ EOF: M_BY2.PRG
