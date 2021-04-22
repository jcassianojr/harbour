*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
*+
*+    Source Module => J:\ITAESBRA\M_BOB.PRG
*+
*+    Functions: Function MBOB01()
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

cTIPO := "M"
cTIP2 := "N"

@ 22, 00 clea
@ 22, 00 say "Digite o tipo Horas->   (E)quipamaneto (H)omem  (T)erceiros"
@ 22, 19 get cTIPO                                                         valid cTIPO $ "EHT" pict "!"
@ 23, 00 say "Hora Padr刼        ->   (N)ormal (I)ndicada (M)edia "
@ 23, 19 get cTIP2                                                         valid cTIP2 $ "NIM"  pict "!"
if !READCUR()
   retu .F.
endif

mARQ1 := ESTQARQ( cTIPO, 1 )

aFAL := {}
aFAH := {}
aCOD := {}
aHOR := {}

if !USEREDE( mARQ1, 1, 1 )
   retu .F.
endif
IMPRESSORA()
dbgotop()
while !eof()
   aadd( aCOD, alltrim( CODIGO ) )
   aadd( aHOR, { ESTQSAL, 0, ESTQSAL, NOME } )
   dbskip()
enddo
dbclosearea()

if !USEMULT( { { "OP01", 1, 99 }, { "OP02", 1, 99 } } )
   retu .F.
endif

CTLIN := 80
IMPRESSORA()
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
      do case
      case cTIPO = "E"
         MBOB01( CODMP01, aVAL )
      case cTIPO = "H"
         MBOB01( CODMP02, aVAL )
         MBOB01( CODMP02B, aVAL )
         MBOB01( CODMP02C, aVAL )
         MBOB01( CODMP02D, aVAL )
      case cTIPO = "T"
         MBOB01( CODMP03, aVAL )
      endcase
   endif
   dbskip()
enddo
dbcloseall()

IMPFOL()
CTLIN := 80
for W := 1 to len( aFAL )
   if CTLIN > 50
      @  0,  0  say cAE + "Resumo Estoque/A Processar Itens OP"
      @  1, 00  say "M_BOBB "
      @  1, 60  say time()
      @  1, 70  say ZDATA
      @  2,  0  say "Codigo"
      @  2, 13  say "Nome"
      @  2, 57  say "Produto"
      @  2, 78  say "      Atraso"
      @  2, 90  say "   1a Semana"
      @  2, 102 say "   2a.Semana"
      @  2, 114 say "       Total"
      @  3,  0  say repl( "-", 132 )
      CTLIN := 4
   endif
   @ CTLIN,  0 say aFAH[ W, 2 ]
   @ CTLIN, 13 say aFAH[ W, 3 ]
   @ CTLIN, 57 say alltrim( aFAH[ W, 4 ] )
   for Z := 1 to 4
      @ CTLIN, 66 + ( W * 12 ) say aFAH[ W, 1, Z ] pict "@E 99,999.999"
   next Z
   CTLIN ++
next W
IMPFOL()
VIDEO()
IMPEND()

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function MBOB01()
*+
*+    Called from ( m_bob.prg    )   6 - function mboa01()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
func MBOB01( cCOD, aVAL )

if empty( cCOD )
   retu
endif
if CTLIN > 50
   @  0,  0  say cAE + "Resumo Estoque/A Processar Itens OP"
   @  1, 00  say "M_BOB "
   @  1, 60  say time()
   @  1, 70  say ZDATA
   @  2,  0  say "Codigo"
   @  2, 13  say "Nome"
   @  2, 46  say "OP SEQ SSQ"
   @  2, 57  say "Produto"
   @  2, 78  say "      Atraso"
   @  2, 90  say "   1a Semana"
   @  2, 102 say "   2a.Semana"
   @  2, 114 say "       Total"
   @  3, 00  say repl( "-", 132 )
   CTLIN := 4
endif
@ CTLIN,  0 say cCOD
nPOS := ascan( aCOD, alltrim( cCOD ) )
if nPOS > 0
   @ CTLIN, 13 say aHOR[ nPOS, 4 ]
   @ CTLIN, 44 say OP              pict "9999"
   @ CTLIN, 49 say SEQ             pict "999"
   @ CTLIN, 53 say SSQ             pict "999"
   mOP     := OP
   mCODIGO := ""
   dbselectar( "OP01" )
   dbgotop()
   dbseek( mOP )
   if found()
      @ CTLIN, 57 say alltrim( CODIGO )
      mCODIGO := CODIGO
   endif
   dbselectar( "OP02" )
   nFALTA := { 0, 0, 0, 0 }
   nDES   := { 0, 0, 0, 0 }
   nSOM4  := 0
   for Z := 1 to 3
      nSTART := aVAL[ Z ]
      do case
      case aHOR[ NPOS, 3 ] <= 0
         @ CTLIN, 66 + ( Z * 12 ) say 0 pict "@E 99,999.999"
         nDES[ Z ] := nSTART
         nDES[ 4 ] += nSTART
         nFALTA[ Z ] := nSTART
         nFALTA[ 4 ] += nSTART
      case aHOR[ NPOS, 3 ] > nSTART
         @ CTLIN, 66 + ( Z * 12 ) say nSTART pict "@E 99,999.999"
         nSOM4     += nSTART
         nDES[ Z ] := 0
         aHOR[ NPOS, 3 ] -= nSTART
      case aHOR[ NPOS, 3 ] < nSTART
         @ CTLIN, 66 + ( Z * 12 ) say aHOR[ NPOS, 3 ] pict "@E 99,999.999"
         nSOM4     += aHOR[ NPOS, 3 ]
         nDES[ Z ] := nSTART - aHOR[ NPOS, 3 ]
         nDES[ 4 ] += nSTART - aHOR[ NPOS, 3 ]
         nFALTA[ Z ] := nSTART - aHOR[ NPOS, 3 ]
         nFALTA[ 4 ] += nSTART - aHOR[ NPOS, 3 ]
         aHOR[ NPOS, 3 ] := 0
      endcase
   next Z
   @ CTLIN, 114 say nSOM4 pict "@E 99,999.999"
   CTLIN ++
   for Z := 1 to 4
      @ CTLIN, 66 + ( Z * 12 ) say nDES[ Z ] pict "@E 99,999.999"
   next Z
   aHOR[ NPOS, 2 ] += nSTART
   for Z := 1 to 3
      if nFALTA[ Z ] > 0
         nPOS2 := ascan( aFAL, cCOD + mCODIGO )
         if nPOS2 > 0
            aFAH[ nPOS2, 1, Z ] += nFALTA[ Z ]
         else
            aadd( aFAL, cCOD + mCODIGO )
            aadd( aFAH, { nFALTA, cCOD, aHOR[ nPOS, 4 ], mCODIGO } )
         endif
      endif
   next Z
else
   @ CTLIN, 15 say "N刼 Cadastrado"
endif
CTLIN ++
retu .T.

*+ EOF: M_BOB.PRG
