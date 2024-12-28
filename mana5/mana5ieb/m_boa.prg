// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_boa.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
// +
// +    Source Module => J:\ITAESBRA\M_BOA.PRG
// +
// +    Functions: Function MBOA01()
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊

// #INCLUDE "COMANDO.CH"
MDI( "Horas Pendentes por OP" )

IF !CHECKIMP( 0 )
RETU .F.
ENDIF

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
@ 22, 00 SAY "Digite o tipo Horas->   (E)quipamaneto (H)omem  (T)erceiros"
@ 22, 21 GET cTIPO                                                         VALID cTIPO $ "EHT" PICT "!"
@ 23, 00 SAY "Hora Padr刼        ->   (N)ormal (I)ndicada (M)edia"
@ 23, 21 GET cTIP2                                                         VALID cTIP2 $ "NIM" PICT "!"
IF !READCUR()
RETU .F.
ENDIF

lGRA := MDG( "Gravar Apura噭o" )
IF lGRA
lGRA := SENHAX( "MBOA01" )
ENDIF

mARQ1 := ESTQARQ( cTIPO, 1 )
IF lGRA
IF !USEMULT( { { "OP02", 1, 99 }, { "BS3", 0, 99 } } )
RETU
ENDIF
dbSelectAr( "BS3" )
ZAP
ELSE
IF !USEREDE( "OP02", 1, 99 )
RETU .F.
ENDIF
ENDIF

dbSelectAr( "OP02" )
dbGoTop()
WHILE !Eof()
IF SSQ <> 99 .AND. SEQ # 99
aVAL     := { 0, 0, 0, 0 }
nVALTIME := QTTIME
IF cTIP2 = "I" .AND. !Empty( QTTIM2 )
nVALTIME := QTTIM2
ENDIF
IF cTIP2 = "M" .AND. !Empty( QTTIMM )
nVALTIME := QTTIMM
ENDIF
aVAL[ 1 ] := nVALTIME * ( QPAA2 )
aVAL[ 2 ] := nVALTIME * ( QPAAS )
aVAL[ 3 ] := nVALTIME * ( QPAAA )
aVAL[ 4 ] := nVALTIME * ( QPAA2 + QPAAS + QPAAA )
FOR W := 1 TO 4
IF aVAL[ W ] > 0.0001
DO CASE
CASE cTIPO = "E"
MBOA01( CODMP01, aVAL[ W ], W )
CASE cTIPO = "H"
MBOA01( CODMP02, aVAL[ W ], W )
MBOA01( CODMP02B, aVAL[ W ], W )
MBOA01( CODMP02C, aVAL[ W ], W )
MBOA01( CODMP02D, aVAL[ W ], W )
CASE cTIPO = "T"
MBOA01( CODMP03, aVAL[ W ], W )
ENDCASE
ENDIF
NEXT W
ENDIF
dbSkip()
ENDDO
dbCloseArea()

aTOT := { 0, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } }
IF !USEREDE( mARQ1, 1, 1 )
RETU .F.
ENDIF
IMPRESSORA()
dbGoTop()
WHILE !Eof()
IF CTLIN > 50
@  0, 0   SAY cAE + "Resumo Estoque/A Processar"
@  1, 00  SAY "M_BOA "
@  1, 60  SAY Time()
@  1, 70  SAY ZDATA
@  2, 0   SAY "Codigo"
@  2, 26  SAY "Nome"
@  2, 66  SAY "     Estoque"
@  2, 78  SAY "      Atraso"
@  2, 90  SAY "   1a Semana"
@  2, 102 SAY "   2a.Semana"
@  2, 114 SAY "       Total"
@  3, 00  SAY repl( "-", 132 )
CTLIN := 4
ENDIF
@ CTLIN, 0  SAY CODIGO
@ CTLIN, 26 SAY NOME
@ CTLIN, 66 SAY ESTQSAL PICT "@E 9999,999.999"
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
nPOS  := AScan( aMAO, CODIGO )
IF nPOS > 0
IF ESTQSAL > 0
nBASE := ESTQSAL
nDESC := 0
FOR W := 1 TO 4
@ CTLIN, 66 + ( W * 12 ) SAY aQTD[ nPOS, W ] PICT "@E 9999,999.999"
cVAR   := "mUSO" + StrZero( W, 2 )
&cVAR. := aQTD[ nPOS, W ]
NEXT W
CTLIN++
aCRE := { 0, 0, 0, 0 }
aDEB := { 0, 0, 0, 0 }
FOR W := 1 TO 4
aTOT[ 2, W ] += aQTD[ nPOS, W ]
IF W # 4
nSALDO := nBASE - aQTD[ nPOS, W ]
ELSE
nSALDO := ESTQSAL - aQTD[ nPOS, W ]
ENDIF
IF nSALDO > 0
aCRE[ W ] := nSALDO
@ CTLIN, 66 + ( W * 12 ) SAY nSALDO PICT "@E 9999,999.999"
cVAR   := "mSAL" + StrZero( W, 2 )
&cVAR. := nSALDO
ELSE
aDEB[ W ] := nSALDO
IF W # 4
nDESC += nSALDO
ENDIF
@ CTLIN, 66 + ( W * 12 ) SAY nDESC PICT "@E 9999,999.999"
cVAR   := "mSAL" + StrZero( W, 2 )
&cVAR. := nDESC
ENDIF
IF nSALDO > 0
aTOT[ 3, W ] += nSALDO
ELSE
aTOT[ 4, W ] += nSALDO
ENDIF
nBASE -= aQTD[ nPOS, W ]
IF nBASE < 0
nBASE := 0
ENDIF
NEXT W
AAdd( aCODC, CODIGO )
AAdd( aQTDC, aCRE )
AAdd( aCODD, CODIGO )
AAdd( aQTDD, aDEB )
CTLIN++
@ CTLIN, 66 SAY nDIV3 PICT "@E 9999,999.999"
FOR W := 1 TO 3
@ CTLIN, 66 + ( W * 12 ) SAY nDIV3 - aQTD[ nPOS, W ] PICT "@E 9999,999.999"
cVAR   := "mSA3" + StrZero( W, 2 )
&cVAR. := nDIV3 - aQTD[ nPOS, W ]
NEXT W
ELSE
CTLIN++
@ CTLIN, 66 SAY 0 PICT "@E 9999,999.999"
aDEB := { 0, 0, 0, 0 }
FOR W := 1 TO 4
@ CTLIN, 66 + ( W * 12 ) SAY - aQTD[ nPOS, W ] PICT "@E 9999,999.999"
aDEB[ W ] := - aQTD[ nPOS, W ]
aTOT[ 4, W ] += aQTD[ nPOS, W ]
cVAR   := "mSAL" + StrZero( W, 2 )
&cVAR. := - aQTD[ nPOS, W ]
NEXT W
CTLIN++
@ CTLIN, 66 SAY 0 PICT "@E 9999,999.999"
FOR W := 1 TO 3
@ CTLIN, 66 + ( W * 12 ) SAY - aQTD[ nPOS, W ] PICT "@E 9999,999.999"
cVAR   := "mSA3" + StrZero( W, 2 )
&cVAR. := - aQTD[ nPOS, W ]
NEXT W
AAdd( aCODD, CODIGO )
AAdd( aQTDD, aDEB )
ENDIF
ELSE
FOR W := 1 TO 4
@ CTLIN, 66 + ( W * 12 ) SAY 0 PICT "@E 9999,999.999"
NEXT W
CTLIN++
aCRE := { 0, 0, 0, 0 }
FOR W := 1 TO 4
@ CTLIN, 66 + ( W * 12 ) SAY ESTQSAL PICT "@E 9999,999.999"
aTOT[ 3, W ] += ESTQSAL
cVAR   := "mSAL" + StrZero( W, 2 )
&cVAR. := ESTQSAL
NEXT W
AAdd( aCODC, CODIGO )
AAdd( aQTDC, aCRE )
CTLIN++
@ CTLIN, 66 SAY nDIV3 PICT "@E 9999,999.999"
FOR W := 1 TO 3
@ CTLIN, 66 + ( W * 12 ) SAY nDIV3 PICT "@E 9999,999.999"
cVAR   := "mSA3" + StrZero( W, 2 )
&cVAR. := nDIV3
NEXT W
ENDIF
CTLIN++
@ CTLIN, 0 SAY repl( "-", 132 )
CTLIN++
IF lGRA
NOVOOPE( "BS3", mCODIGO )
ENDIF
dbSelectAr( mARQ1 )
dbSkip()
ENDDO
dbCloseArea()
@ CTLIN, 0 SAY repl( "-", 132 )
CTLIN++
@ CTLIN, 0  SAY "Estoque/Necessidade"
@ CTLIN, 66 SAY aTOT[ 1 ]               PICT "@E 9999,999.999"
nDIV3 := aTOT[ 1 ] / 3
FOR W := 1 TO 4
@ CTLIN, 66 + ( W * 12 ) SAY aTOT[ 2, W ] PICT "@E 9999,999.999"
NEXT W
CTLIN++
@ CTLIN, 0 SAY "Creditos"
FOR W := 1 TO 4
@ CTLIN, 66 + ( W * 12 ) SAY aTOT[ 3, W ] PICT "@E 9999,999.999"
NEXT W
CTLIN++
@ CTLIN, 0 SAY "Debitos"
FOR W := 1 TO 4
@ CTLIN, 66 + ( W * 12 ) SAY - aTOT[ 4, W ] PICT "@E 9999,999.999"
NEXT W
CTLIN++
@ CTLIN, 0  SAY "Semana"
@ CTLIN, 66 SAY nDIV3    PICT "@E 9999,999.999"
FOR W := 1 TO 3
@ CTLIN, 66 + ( W * 12 ) SAY nDIV3 - aTOT[ 2, W ] PICT "@E 9999,999.999"
NEXT W
IMPFOL()

@  0, 0  SAY cAE + "Resumo Estoque/A Processar - Remanejamento"
@  1, 00 SAY "M_BOA-B "
@  1, 60 SAY Time()
@  1, 70 SAY ZDATA
IF Type( "nFIM" ) = "D"
@  1, 10 SAY "Ate " + DToC( nFIM )
ENDIF
@  2, 0  SAY "Codigo"
@  2, 20 SAY "Remanejando"
@  2, 40 SAY "      Atraso"
@  2, 52 SAY "   1a Semana"
@  2, 64 SAY "   2a.Semana"
@  3, 00 SAY repl( "-", 132 )
CTLIN := 4

mARQ1 := ESTQARQ( cTIPO, 1 ) + "A"

VIDEO()
WHILE !USEREDE( mARQ1, 1, 1 )
ENDDO
IMPRESSORA()
FOR W := 1 TO Len( aCODC )
aOPCAO  := {}
zCODIGO := aCODC[ W ]
dbGoTop()
dbSeek( zCODIGO )
WHILE zCODIGO = CODIGO .AND. !Eof()
AAdd( aOPCAO, CODMPSB )
dbSkip()
ENDDO
lCODIGO := .T.
FOR Z := 1 TO Len( aOPCAO )
FOR K := 1 TO 3
nSTART := aQTDC[ W, K ]
nPOS   := AScan( aCODD, aOPCAO[ Z ] )
IF nPOS > 0 .AND. nSTART > 0.0001
nDEB := aQTDD[ nPOS, K ]
nDEB *= -1
IF nDEB > 0
DO CASE
CASE nDEB = nSTART
IF lCODIGO
CTLIN++
@ CTLIN, 00 SAY zCODIGO
@ CTLIN, 20 SAY aCODD[ nPOS ]
lCODIGO := .F.
ENDIF
@ CTLIN, 28 + ( K * 12 ) SAY nDEB PICT "@E 99,999.999"
nSTART := 0
CASE nSTART > nDEB
IF lCODIGO
CTLIN++
@ CTLIN, 00 SAY zCODIGO
@ CTLIN, 20 SAY aCODD[ nPOS ]
lCODIGO := .F.
ENDIF
@ CTLIN, 28 + ( K * 12 ) SAY nDEB PICT "@E 99,999.999"
nSTART -= nDEB
CASE nDEB > nSTART
IF lCODIGO
CTLIN++
@ CTLIN, 00 SAY zCODIGO
@ CTLIN, 20 SAY aCODD[ nPOS ]
lCODIGO := .F.
ENDIF
@ CTLIN, 28 + ( K * 12 ) SAY nSTART PICT "@E 9999,999.999"
aQTDD[ nPOS, K ] -= nSTART
nSTART := 0
ENDCASE
ENDIF
ENDIF
NEXT K
NEXT Z
NEXT W
dbCloseArea()
CTLIN++
@ CTLIN, 0 SAY repl( "=", 132 )
CTLIN++
FOR W := 1 TO Len( aCODD )
nDEB := aQTDD[ W ]
FOR Z := 1 TO 3
IF nDEB[ Z ] > 0
@ CTLIN, 20          SAY aCODD[ W ]
@ CTLIN, 28 + ( W * 12 ) SAY nDEB[ Z ]  PICT "@E 9999,999.999"
CTLIN++
ENDIF
NEXT Z
NEXT W
@ CTLIN, 0 SAY repl( "=", 132 )
CTLIN++
IMPFOL()
VIDEO()
IMPEND()

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function MBOA01()
// +
// +    Called from ( m_boa.prg    )   6 - function mbo901()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBOA01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBOA01( cCOD, nVAL, nSUB )

   IF Empty( cCOD )
      RETU
   ENDIF
   nPOS := AScan( aMAO, cCOD )
   IF nPOS > 0
      aQTD[ nPOS, nSUB ] += nVAL
   ELSE
      AAdd( aMAO, cCOD )
      AAdd( aQTD, { 0, 0, 0, 0 } )
      nPOS := Len( aMAO )
      aQTD[ nPOS, nSUB ] += nVAL
   ENDIF
   RETU .T.

// + EOF: M_BOA.PRG

// + EOF: m_boa.prg
// +
