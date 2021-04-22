*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
*+
*+    Source Module => J:\ITAESBRA\M_BOA.PRG
*+
*+    Functions: Function MBOA01()
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊

//#INCLUDE "COMANDO.CH"
MDI( "Horas Pendentes por OP" )

if !CHECKIMP( 0 )
   retu .F.
endif

cAE := IMP( "AE" )

aCODC := {}
aCODD := {}
aQTDC := {}
aQTDD := {}
CTLIN := 80
cTIPO := "M"
cTIP2 := "N"
aMAO  := {}
aQTD  := {}
@ 22, 00 clea
@ 22, 00 say "Digite o tipo Horas->   (E)quipamaneto (H)omem  (T)erceiros"
@ 22, 21 get cTIPO                                                         valid cTIPO $ "EHT" pict "!"
@ 23, 00 say "Hora Padr刼        ->   (N)ormal (I)ndicada (M)edia"
@ 23, 21 get cTIP2                                                         valid cTIP2 $ "NIM"  pict "!"
if !READCUR()
   retu .F.
endif

lGRA := MDG( "Gravar Apura噭o" )
if lGRA
   lGRA := SENHAX( "MBOA01" )
endif

mARQ1 := ESTQARQ( cTIPO, 1 )
if lGRA
   if !USEMULT( { { "OP02", 1, 99 }, { "BS3", 0, 99 } } )
      retu
   endif
   dbselectar( "BS3" )
   zap
else
   if !USEREDE( "OP02", 1, 99 )
      retu .F.
   endif
endif

dbselectar( "OP02" )
dbgotop()
while !eof()
   if SSQ <> 99 .and. SEQ # 99
      aVAL := { 0, 0, 0, 0 }
      nVALTIME:=QTTIME
      if cTIP2 = "I".AND.! EMPTY(QTTIM2)
         nVALTIME:=QTTIM2
      Endif
      if cTIP2 = "M".AND.! EMPTY(QTTIMM)
         nVALTIME:=QTTIMM
      Endif
      aVAL[ 1 ] := nVALTIME * ( QPAA2 )
      aVAL[ 2 ] := nVALTIME * ( QPAAS )
      aVAL[ 3 ] := nVALTIME * ( QPAAA )
      aVAL[ 4 ] := nVALTIME * ( QPAA2 + QPAAS + QPAAA )
      for W := 1 to 4
         if aVAL[ W ] > 0.0001
            do case
            case cTIPO = "E"
               MBOA01( CODMP01, aVAL[ W ], W )
            case cTIPO = "H"
               MBOA01( CODMP02, aVAL[ W ], W )
               MBOA01( CODMP02B, aVAL[ W ], W )
               MBOA01( CODMP02C, aVAL[ W ], W )
               MBOA01( CODMP02D, aVAL[ W ], W )
            case cTIPO = "T"
               MBOA01( CODMP03, aVAL[ W ], W )
            endcase
         endif
      next W
   endif
   dbskip()
enddo
dbclosearea()

aTOT := { 0, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } }
if !USEREDE( mARQ1, 1, 1 )
   retu .F.
endif
IMPRESSORA()
dbgotop()
while !eof()
   if CTLIN > 50
      @  0,  0  say cAE + "Resumo Estoque/A Processar"
      @  1, 00  say "M_BOA "
      @  1, 60  say time()
      @  1, 70  say ZDATA
      @  2,  0  say "Codigo"
      @  2, 26  say "Nome"
      @  2, 66  say "     Estoque"
      @  2, 78  say "      Atraso"
      @  2, 90  say "   1a Semana"
      @  2, 102 say "   2a.Semana"
      @  2, 114 say "       Total"
      @  3, 00  say repl( "-", 132 )
      CTLIN := 4
   endif
   @ CTLIN,  0 say CODIGO
   @ CTLIN, 26 say NOME
   @ CTLIN, 66 say ESTQSAL pict "@E 9999,999.999"
   mCODIGO   := CODIGO
   mNOME     := NOME
   mGRUPOUTL := GRUPOUTL
   mESTOQUE  := ESTQSAL
   mESTOQU3  := ESTQSAL / 3
   mUSO01    := mUSO02 := mUSO03 := mUSO04 := 0
   mSAL01    := mSAL02 := mSAL03 := mSAL04 := 0
   mSA301    := mSA302 := mSA303 := mSA304 := 0
   aTOT[ 1 ] += ESTQSAL
   nDIV3 := ESTQSAL / 3
   nPOS  := ascan( aMAO, CODIGO )
   if nPOS > 0
      if ESTQSAL > 0
         nBASE := ESTQSAL
         nDESC := 0
         for W := 1 to 4
            @ CTLIN, 66 + ( W * 12 ) say aQTD[ nPOS, W ] pict "@E 9999,999.999"
            cVAR   := "mUSO" + strzero( W, 2 )
            &cVAR. := aQTD[ nPOS, W ]
         next W
         CTLIN ++
         aCRE := { 0, 0, 0, 0 }
         aDEB := { 0, 0, 0, 0 }
         for W := 1 to 4
            aTOT[ 2, W ] += aQTD[ nPOS, W ]
            if W # 4
               nSALDO := nBASE - aQTD[ nPOS, W ]
            else
               nSALDO := ESTQSAL - aQTD[ nPOS, W ]
            endif
            if nSALDO > 0
               aCRE[ W ] := nSALDO
               @ CTLIN, 66 + ( W * 12 ) say nSALDO pict "@E 9999,999.999"
               cVAR   := "mSAL" + strzero( W, 2 )
               &cVAR. := nSALDO
            else
               aDEB[ W ] := nSALDO
               if W # 4
                  nDESC += nSALDO
               endif
               @ CTLIN, 66 + ( W * 12 ) say nDESC pict "@E 9999,999.999"
               cVAR   := "mSAL" + strzero( W, 2 )
               &cVAR. := nDESC
            endif
            if nSALDO > 0
               aTOT[ 3, W ] += nSALDO
            else
               aTOT[ 4, W ] += nSALDO
            endif
            nBASE -= aQTD[ nPOS, W ]
            if nBASE < 0
               nBASE := 0
            endif
         next W
         aadd( aCODC, CODIGO )
         aadd( aQTDC, aCRE )
         aadd( aCODD, CODIGO )
         aadd( aQTDD, aDEB )
         CTLIN ++
         @ CTLIN, 66 say nDIV3 pict "@E 9999,999.999"
         for W := 1 to 3
            @ CTLIN, 66 + ( W * 12 ) say nDIV3 - aQTD[ nPOS, W ] pict "@E 9999,999.999"
            cVAR   := "mSA3" + strzero( W, 2 )
            &cVAR. := nDIV3 - aQTD[ nPOS, W ]
         next W
      else
         CTLIN ++
         @ CTLIN, 66 say 0 pict "@E 9999,999.999"
         aDEB := { 0, 0, 0, 0 }
         for W := 1 to 4
            @ CTLIN, 66 + ( W * 12 ) say - aQTD[ nPOS, W ] pict "@E 9999,999.999"
            aDEB[ W ] := - aQTD[ nPOS, W ]
            aTOT[ 4, W ] += aQTD[ nPOS, W ]
            cVAR   := "mSAL" + strzero( W, 2 )
            &cVAR. := - aQTD[ nPOS, W ]
         next W
         CTLIN ++
         @ CTLIN, 66 say 0 pict "@E 9999,999.999"
         for W := 1 to 3
            @ CTLIN, 66 + ( W * 12 ) say - aQTD[ nPOS, W ] pict "@E 9999,999.999"
            cVAR   := "mSA3" + strzero( W, 2 )
            &cVAR. := - aQTD[ nPOS, W ]
         next W
         aadd( aCODD, CODIGO )
         aadd( aQTDD, aDEB )
      endif
   else
      for W := 1 to 4
         @ CTLIN, 66 + ( W * 12 ) say 0 pict "@E 9999,999.999"
      next W
      CTLIN ++
      aCRE := { 0, 0, 0, 0 }
      for W := 1 to 4
         @ CTLIN, 66 + ( W * 12 ) say ESTQSAL pict "@E 9999,999.999"
         aTOT[ 3, W ] += ESTQSAL
         cVAR   := "mSAL" + strzero( W, 2 )
         &cVAR. := ESTQSAL
      next W
      aadd( aCODC, CODIGO )
      aadd( aQTDC, aCRE )
      CTLIN ++
      @ CTLIN, 66 say nDIV3 pict "@E 9999,999.999"
      for W := 1 to 3
         @ CTLIN, 66 + ( W * 12 ) say nDIV3 pict "@E 9999,999.999"
         cVAR   := "mSA3" + strzero( W, 2 )
         &cVAR. := nDIV3
      next W
   endif
   CTLIN ++
   @ CTLIN,  0 say repl( "-", 132 )
   CTLIN ++
   IF lGRA
      NOVOOPE( "BS3", mCODIGO )
   ENDIF
   dbselectar( mARQ1 )
   dbskip()
enddo
dbclosearea()
@ CTLIN,  0 say repl( "-", 132 )
CTLIN ++
@ CTLIN,  0 say "Estoque/Necessidade"
@ CTLIN, 66 say aTOT[ 1 ]             pict "@E 9999,999.999"
nDIV3 := aTOT[ 1 ] / 3
for W := 1 to 4
   @ CTLIN, 66 + ( W * 12 ) say aTOT[ 2, W ] pict "@E 9999,999.999"
next W
CTLIN ++
@ CTLIN,  0 say "Creditos"
for W := 1 to 4
   @ CTLIN, 66 + ( W * 12 ) say aTOT[ 3, W ] pict "@E 9999,999.999"
next W
CTLIN ++
@ CTLIN,  0 say "Debitos"
for W := 1 to 4
   @ CTLIN, 66 + ( W * 12 ) say - aTOT[ 4, W ] pict "@E 9999,999.999"
next W
CTLIN ++
@ CTLIN,  0 say "Semana"
@ CTLIN, 66 say nDIV3    pict "@E 9999,999.999"
for W := 1 to 3
   @ CTLIN, 66 + ( W * 12 ) say nDIV3 - aTOT[ 2, W ] pict "@E 9999,999.999"
next W
IMPFOL()

@  0,  0 say cAE + "Resumo Estoque/A Processar - Remanejamento"
@  1, 00 say "M_BOA-B "
@  1, 60 say time()
@  1, 70 say ZDATA
if type( "nFIM" ) = "D"
   @  1, 10 say "Ate " + dtoc( nFIM )
endif
@  2,  0 say "Codigo"
@  2, 20 say "Remanejando"
@  2, 40 say "      Atraso"
@  2, 52 say "   1a Semana"
@  2, 64 say "   2a.Semana"
@  3, 00 say repl( "-", 132 )
CTLIN := 4

mARQ1 := ESTQARQ( cTIPO, 1 ) + "A"

VIDEO()
while !USEREDE( mARQ1, 1, 1 )
enddo
IMPRESSORA()
for W := 1 to len( aCODC )
   aOPCAO  := {}
   zCODIGO := aCODC[ W ]
   dbgotop()
   dbseek( zCODIGO )
   while zCODIGO = CODIGO .and. !eof()
      aadd( aOPCAO, CODMPSB )
      dbskip()
   enddo
   lCODIGO := .T.
   for Z := 1 to len( aOPCAO )
      for K := 1 to 3
         nSTART := aQTDC[ W, K ]
         nPOS   := ascan( aCODD, aOPCAO[ Z ] )
         if nPOS > 0 .and. nSTART > 0.0001
            nDEB := aQTDD[ nPOS, K ]
            nDEB *= - 1
            if nDEB > 0
               do case
               case nDEB = nSTART
                  if lCODIGO
                     CTLIN ++
                     @ CTLIN, 00 say zCODIGO
                     @ CTLIN, 20 say aCODD[ nPOS ]
                     lCODIGO := .F.
                  endif
                  @ CTLIN, 28 + ( K * 12 ) say nDEB pict "@E 99,999.999"
                  nSTART := 0
               case nSTART > nDEB
                  if lCODIGO
                     CTLIN ++
                     @ CTLIN, 00 say zCODIGO
                     @ CTLIN, 20 say aCODD[ nPOS ]
                     lCODIGO := .F.
                  endif
                  @ CTLIN, 28 + ( K * 12 ) say nDEB pict "@E 99,999.999"
                  nSTART -= nDEB
               case nDEB > nSTART
                  if lCODIGO
                     CTLIN ++
                     @ CTLIN, 00 say zCODIGO
                     @ CTLIN, 20 say aCODD[ nPOS ]
                     lCODIGO := .F.
                  endif
                  @ CTLIN, 28 + ( K * 12 ) say nSTART pict "@E 9999,999.999"
                  aQTDD[ nPOS, K ] -= nSTART
                  nSTART := 0
               endcase
            endif
         endif
      next K
   next Z
next W
dbclosearea()
CTLIN ++
@ CTLIN,  0 say repl( "=", 132 )
CTLIN ++
for W := 1 to len( aCODD )
   nDEB := aQTDD[ W ]
   for Z := 1 to 3
      if nDEB[ Z ] > 0
         @ CTLIN, 20              say aCODD[ W ]
         @ CTLIN, 28 + ( W * 12 ) say nDEB[ Z ]  pict "@E 9999,999.999"
         CTLIN ++
      endif
   next Z
next W
@ CTLIN,  0 say repl( "=", 132 )
CTLIN ++
IMPFOL()
VIDEO()
IMPEND()

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function MBOA01()
*+
*+    Called from ( m_boa.prg    )   6 - function mbo901()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
func MBOA01( cCOD, nVAL, nSUB )

if empty( cCOD )
   retu
endif
nPOS := ascan( aMAO, cCOD )
if nPOS > 0
   aQTD[ nPOS, nSUB ] += nVAL
else
   aadd( aMAO, cCOD )
   aadd( aQTD, { 0, 0, 0, 0 } )
   nPOS := len( aMAO )
   aQTD[ nPOS, nSUB ] += nVAL
endif
retu .T.

*+ EOF: M_BOA.PRG
