// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk54.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => C:\DEVELOP\OBJ\DISK54.PRG
// +
// +    Functions: Function AC_AGUDO()
// +               Function AC_CRASE()
// +               Function AC_TIL()
// +               Function AC_CIRC()
// +               Function Acentuar()
// +               Function liga_acento()
// +               Function Acento()
// +
// +    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function AC_AGUDO()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function AC_AGUDO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC AC_AGUDO

   SET KEY 39 to
   ACENTUAR( "AGU" )
   SetKey( 39, {|| AC_AGUDO() } )
   RETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function AC_CRASE()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function AC_CRASE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC AC_CRASE

   Acentuar( "CRA" )
   RETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function AC_TIL()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function AC_TIL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC AC_TIL

   Acentuar( "TIL" )
   RETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function AC_CIRC()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function AC_CIRC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC AC_CIRC

   ACENTUAR( "CIR" )
   RETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function Acentuar()
// +
// +    Called from ( disk54.prg   )   1 - function ac_agudo()
// +                                   1 - function ac_crase()
// +                                   1 - function ac_til()
// +                                   1 - function ac_circ()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Acentuar()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC Acentuar( cTIPO )

   LOCAL cDOS
   LOCAL cWIN
   LOCAL cBUS
   LOCAL nPOS

   cBUS := { "A", "a", "E", "e", "I", "i", "O", "o", "U", "u", "C", "c" }
   DO CASE
   CASE cTIPO = "CRA"  // Crase
      cDOS := CHARCNVMT( "Здоуы" )
      cWIN := CHARCNVMT( "+р+шньв=+љЧч" )
   CASE cTIPO = "AGU"  // Agudo
      cDOS := CHARCNVMT( "Е жЁрЂщЃ" )
      cWIN := CHARCNVMT( "-с+щ-эгѓ+њЧч" )
   CASE cTIPO = "CIR"  // Circunflexo
      cDOS := CHARCNVMT( "Жвзтъ" )
      cWIN := CHARCNVMT( "-т-ъ+юдєнћЧч" )
   CASE cTIPO = "TIL"  // Til
      cBUS := { "A", "a", "O", "o", "N", "n" }
      cDOS := CHARCNVMT( "ЧЦхфЅЄ" )
      cWIN := CHARCNVMT( "у+iѕбё" )
   CASE cTIPO = "TRE"  // Trema
      cDOS := CHARCNVMT( "ги" )
      cWIN := CHARCNVMT( "-ф-ыЯяжі_ќЧч" )
   CASE cTIPO = "GRA"  // Grau
      cBUS := { "A", "a" }
      cDOS := CHARCNVMT( "" )
      cWIN := CHARCNVMT( "+х" )
   ENDCASE
   xkey := Inkey( 0 )
   ykey := Chr( xkey )
   nPOS := AScan( cBUS, yKEY )
   IF nPOS > 0
      Kkey := if( ACENTUA, cDOS[ nPOS ], cWIN[ nPOS ] )
   ELSE
      kkey := ykey
   ENDIF
   KEYBOARD ( kkey )
   RETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function liga_acento()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function liga_acento()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC liga_acento

   IF mdg( "Ligar Acentuacao" )
      SetKey( 39, {|| AC_AGUDO() } )
      SetKey( 94, {|| AC_CIRC() } )
      SetKey( 96, {|| AC_CRASE() } )
      SetKey( 126, {|| AC_TIL() } )
      IF MDG( "Acentuacao para Windows" )
         ACENTUA := .F.
      ELSE
         ACENTUA := .T.
      ENDIF
   ELSE
      SET KEY 39 to
      SET KEY 94 to
      SET KEY 96 to
      SET KEY 126 to
   ENDIF
   RETU

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function Acento()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Acento()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC Acento( texto )

   LOCAL ag   := Chr( 8 ) + Chr( 39 )
   LOCAL ti   := Chr( 8 ) + Chr( 126 )
   LOCAL cr   := Chr( 8 ) + Chr( 96 )
   LOCAL ci   := Chr( 8 ) + Chr( 94 )
   LOCAL ce   := Chr( 8 ) + Chr( 44 )
   LOCAL sp   := 0
   LOCAL X
   LOCAL aORI := { " ", "", "Ё", "Ђ", "Ѓ", ;
      "Е", "", "ж", "р", "щ", ;
      "", "", "", "", "З", ;
      "", "", "Ж", "в", "т", ;
      "Ц", "", "ф", "", "Ч", "", "", "х" }
   LOCAL aDES := { "a" + ag, "e" + ag, "i" + ag, "o" + ag, "u" + ag, ;
      "A" + ag, "E" + ag, "I" + ag, "O" + ag, "U" + ag, ;
      "a" + ci, "e" + ci, "o" + ci, "a" + cr, "A" + cr, ;
      "c" + ce, "C" + ce, "A" + ci, "E" + ci, "O" + ci, ;
      "a" + ti, "a" + ti, "o" + ti, "o" + ti, "A" + ti, "A" + ti, "O" + ti, "O" + ti }

   IF ValType( TEXTO ) # "C"
      RETU TEXTO
   ENDIF
   IF Type( "nTIPSPO" ) # "U"  // Nao passado tipo spoll
      RETU TEXTO
   ENDIF
   IF nTIPSPO <> 2 .AND. nTIPSPO <> 3 .AND. nTIPSPO <> 4   // LPT1 LPT2 LPT3
      RETU TEXTO
   ENDIF
   FOR X := 1 TO Len( aORI )
      IF At( aORI[ X ], texto ) > 0
         texto := StrTran( texto, aORI[ X ], aDES[ X ] )
         sp++
      ENDIF
   NEXT
   IF sp > 0
      texto += Space( sp )
   ENDIF
   RETU ( texto )

// + EOF: DISK54.PRG

// + EOF: disk54.prg
// +
