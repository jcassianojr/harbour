// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bob.prg
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
// +    Source Module => J:\ITAESBRA\M_BOB.PRG
// +
// +    Functions: Function MBOB01()
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

cTIPO := "M"
cTIP2 := "N"

@ 22, 00 clea
@ 22, 00 SAY "Digite o tipo Horas->   (E)quipamaneto (H)omem  (T)erceiros"
@ 22, 19 GET cTIPO                                                         VALID cTIPO $ "EHT" PICT "!"
@ 23, 00 SAY "Hora Padr刼        ->   (N)ormal (I)ndicada (M)edia "
@ 23, 19 GET cTIP2                                                         VALID cTIP2 $ "NIM" PICT "!"
IF !READCUR()
RETU .F.
ENDIF

mARQ1 := ESTQARQ( cTIPO, 1 )

aFAL := {}
aFAH := {}
aCOD := {}
aHOR := {}

IF !USEREDE( mARQ1, 1, 1 )
RETU .F.
ENDIF
IMPRESSORA()
dbGoTop()
WHILE !Eof()
AAdd( aCOD, AllTrim( CODIGO ) )
AAdd( aHOR, { ESTQSAL, 0, ESTQSAL, NOME } )
dbSkip()
ENDDO
dbCloseArea()

IF !USEMULT( { { "OP01", 1, 99 }, { "OP02", 1, 99 } } )
RETU .F.
ENDIF

CTLIN := 80
IMPRESSORA()
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
DO CASE
CASE cTIPO = "E"
MBOB01( CODMP01, aVAL )
CASE cTIPO = "H"
MBOB01( CODMP02, aVAL )
MBOB01( CODMP02B, aVAL )
MBOB01( CODMP02C, aVAL )
MBOB01( CODMP02D, aVAL )
CASE cTIPO = "T"
MBOB01( CODMP03, aVAL )
ENDCASE
ENDIF
dbSkip()
ENDDO
dbCloseAll()

IMPFOL()
CTLIN := 80
FOR W := 1 TO Len( aFAL )
IF CTLIN > 50
@  0, 0   SAY cAE + "Resumo Estoque/A Processar Itens OP"
@  1, 00  SAY "M_BOBB "
@  1, 60  SAY Time()
@  1, 70  SAY ZDATA
@  2, 0   SAY "Codigo"
@  2, 13  SAY "Nome"
@  2, 57  SAY "Produto"
@  2, 78  SAY "      Atraso"
@  2, 90  SAY "   1a Semana"
@  2, 102 SAY "   2a.Semana"
@  2, 114 SAY "       Total"
@  3, 0   SAY repl( "-", 132 )
CTLIN := 4
ENDIF
@ CTLIN, 0  SAY aFAH[ W, 2 ]
@ CTLIN, 13 SAY aFAH[ W, 3 ]
@ CTLIN, 57 SAY AllTrim( aFAH[ W, 4 ] )
FOR Z := 1 TO 4
@ CTLIN, 66 + ( W * 12 ) SAY aFAH[ W, 1, Z ] PICT "@E 99,999.999"
NEXT Z
CTLIN++
NEXT W
IMPFOL()
VIDEO()
IMPEND()

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function MBOB01()
// +
// +    Called from ( m_bob.prg    )   6 - function mboa01()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBOB01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBOB01( cCOD, aVAL )

   IF Empty( cCOD )
      RETU
   ENDIF
   IF CTLIN > 50
      @  0, 0   SAY cAE + "Resumo Estoque/A Processar Itens OP"
      @  1, 00  SAY "M_BOB "
      @  1, 60  SAY Time()
      @  1, 70  SAY ZDATA
      @  2, 0   SAY "Codigo"
      @  2, 13  SAY "Nome"
      @  2, 46  SAY "OP SEQ SSQ"
      @  2, 57  SAY "Produto"
      @  2, 78  SAY "      Atraso"
      @  2, 90  SAY "   1a Semana"
      @  2, 102 SAY "   2a.Semana"
      @  2, 114 SAY "       Total"
      @  3, 00  SAY repl( "-", 132 )
      CTLIN := 4
   ENDIF
   @ CTLIN, 0 SAY cCOD
   nPOS := AScan( aCOD, AllTrim( cCOD ) )
   IF nPOS > 0
      @ CTLIN, 13 SAY aHOR[ nPOS, 4 ]
      @ CTLIN, 44 SAY OP           PICT "9999"
      @ CTLIN, 49 SAY SEQ          PICT "999"
      @ CTLIN, 53 SAY SSQ          PICT "999"
      mOP     := OP
      mCODIGO := ""
      dbSelectAr( "OP01" )
      dbGoTop()
      dbSeek( mOP )
      IF Found()
         @ CTLIN, 57 SAY AllTrim( CODIGO )
         mCODIGO := CODIGO
      ENDIF
      dbSelectAr( "OP02" )
      nFALTA := { 0, 0, 0, 0 }
      nDES   := { 0, 0, 0, 0 }
      nSOM4  := 0
      FOR Z := 1 TO 3
         nSTART := aVAL[ Z ]
         DO CASE
         CASE aHOR[ NPOS, 3 ] <= 0
            @ CTLIN, 66 + ( Z * 12 ) SAY 0 PICT "@E 99,999.999"
            nDES[ Z ] := nSTART
            nDES[ 4 ] += nSTART
            nFALTA[ Z ] := nSTART
            nFALTA[ 4 ] += nSTART
         CASE aHOR[ NPOS, 3 ] > nSTART
            @ CTLIN, 66 + ( Z * 12 ) SAY nSTART PICT "@E 99,999.999"
            nSOM4     += nSTART
            nDES[ Z ] := 0
            aHOR[ NPOS, 3 ] -= nSTART
         CASE aHOR[ NPOS, 3 ] < nSTART
            @ CTLIN, 66 + ( Z * 12 ) SAY aHOR[ NPOS, 3 ] PICT "@E 99,999.999"
            nSOM4     += aHOR[ NPOS, 3 ]
            nDES[ Z ] := nSTART - aHOR[ NPOS, 3 ]
            nDES[ 4 ] += nSTART - aHOR[ NPOS, 3 ]
            nFALTA[ Z ] := nSTART - aHOR[ NPOS, 3 ]
            nFALTA[ 4 ] += nSTART - aHOR[ NPOS, 3 ]
            aHOR[ NPOS, 3 ] := 0
         ENDCASE
      NEXT Z
      @ CTLIN, 114 SAY nSOM4 PICT "@E 99,999.999"
      CTLIN++
      FOR Z := 1 TO 4
         @ CTLIN, 66 + ( Z * 12 ) SAY nDES[ Z ] PICT "@E 99,999.999"
      NEXT Z
      aHOR[ NPOS, 2 ] += nSTART
      FOR Z := 1 TO 3
         IF nFALTA[ Z ] > 0
            nPOS2 := AScan( aFAL, cCOD + mCODIGO )
            IF nPOS2 > 0
               aFAH[ nPOS2, 1, Z ] += nFALTA[ Z ]
            ELSE
               AAdd( aFAL, cCOD + mCODIGO )
               AAdd( aFAH, { nFALTA, cCOD, aHOR[ nPOS, 4 ], mCODIGO } )
            ENDIF
         ENDIF
      NEXT Z
   ELSE
      @ CTLIN, 15 SAY "N刼 Cadastrado"
   ENDIF
   CTLIN++
   RETU .T.

// + EOF: M_BOB.PRG

// + EOF: m_bob.prg
// +
