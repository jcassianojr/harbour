// +--------------------------------------------------------------------
// +
// +    Programa  : disk54.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +    Functions: Function AC_AGUDO()
// +               Function AC_CRASE()
// +               Function AC_TIL()
// +               Function AC_CIRC()
// +               Function Acentuar()
// +               Function liga_acento()
// +               Function Acento()
// +
// +--------------------------------------------------------------------
// +

// --- DefiniÁıes de Constantes (Tabela PTISO/ISO-8859-1) ---
#define CHR_A_AGUDO 193 // ¡
#define CHR_a_AGUDO 225 // ·
#define CHR_E_AGUDO 201 // …
#define CHR_e_AGUDO 233 // È
#define CHR_I_AGUDO 205 // Õ
#define CHR_i_AGUDO 237 // Ì
#define CHR_O_AGUDO 211 // ”
#define CHR_o_AGUDO 243 // Û
#define CHR_U_AGUDO 218 // ⁄
#define CHR_u_AGUDO 250 // ˙
#define CHR_C_CEDIL 199 // «
#define CHR_c_CEDIL 231 // Á
#define CHR_A_TIL   195 // √
#define CHR_a_TIL   227 // „
#define CHR_O_TIL   213 // ’
#define CHR_o_TIL   245 // ı
#define CHR_N_TIL   209 // —
#define CHR_n_TIL   241 // Ò
#define CHR_A_CIRC  194 // ¬
#define CHR_a_CIRC  226 // ‚
#define CHR_E_CIRC  202 //  
#define CHR_e_CIRC  234 // Í
#define CHR_I_CIRC  206 // Œ
#define CHR_i_CIRC  238 // Ó
#define CHR_O_CIRC  212 // ‘
#define CHR_o_CIRC  244 // Ù
#define CHR_U_CIRC  219 // €
#define CHR_u_CIRC  251 // ˚
#define CHR_A_TREM  196 // ƒ
#define CHR_a_TREM  228 // ‰
#define CHR_E_TREM  203 // À
#define CHR_e_TREM  235 // Î
#define CHR_I_TREM  207 // œ
#define CHR_i_TREM  239 // Ô
#define CHR_O_TREM  214 // ÷
#define CHR_o_TREM  246 // ˆ
#define CHR_U_TREM  220 // ‹
#define CHR_u_TREM  252 // ¸
#define CHR_A_CRASE 192 // ¿
#define CHR_a_CRASE 224 // ‡
#define CHR_E_CRASE 200 // »
#define CHR_e_CRASE 232 // Ë
#define CHR_I_CRASE 204 // Ã
#define CHR_i_CRASE 236 // Ï
#define CHR_O_CRASE 210 // “
#define CHR_o_CRASE 242 // Ú
#define CHR_U_CRASE 217 // Ÿ
#define CHR_u_CRASE 249 // ˘

FUNCTION Acentuar( cTIPO )
   LOCAL cBUS, cDEST, nPOS, yKEY, kkey, xkey

   DO CASE
   CASE cTIPO = "AGU"
      cBUS  := { "A", "a", "E", "e", "I", "i", "O", "o", "U", "u", "C", "c" }
      cDEST := { Chr(CHR_A_AGUDO), Chr(CHR_a_AGUDO), Chr(CHR_E_AGUDO), Chr(CHR_e_AGUDO), ;
                 Chr(CHR_I_AGUDO), Chr(CHR_i_AGUDO), Chr(CHR_O_AGUDO), Chr(CHR_o_AGUDO), ;
                 Chr(CHR_U_AGUDO), Chr(CHR_u_AGUDO), Chr(CHR_C_CEDIL), Chr(CHR_c_CEDIL) }
   CASE cTIPO = "TIL"
      cBUS  := { "A", "a", "O", "o", "N", "n" }
      cDEST := { Chr(CHR_A_TIL), Chr(CHR_a_TIL), Chr(CHR_O_TIL), Chr(CHR_o_TIL), ;
                 Chr(CHR_N_TIL), Chr(CHR_n_TIL) }
   CASE cTIPO = "CIR"
      cBUS  := { "A", "a", "E", "e", "I", "i", "O", "o", "U", "u" }
      cDEST := { Chr(CHR_A_CIRC), Chr(CHR_a_CIRC), Chr(CHR_E_CIRC), Chr(CHR_e_CIRC), ;
                 Chr(CHR_I_CIRC), Chr(CHR_i_CIRC), Chr(CHR_O_CIRC), Chr(CHR_o_CIRC), ;
                 Chr(CHR_U_CIRC), Chr(CHR_u_CIRC) }
   CASE cTIPO = "TRE"
      cBUS  := { "A", "a", "E", "e", "I", "i", "O", "o", "U", "u" }
      cDEST := { Chr(CHR_A_TREM), Chr(CHR_a_TREM), Chr(CHR_E_TREM), Chr(CHR_e_TREM), ;
                 Chr(CHR_I_TREM), Chr(CHR_i_TREM), Chr(CHR_O_TREM), Chr(CHR_o_TREM), ;
                 Chr(CHR_U_TREM), Chr(CHR_u_TREM) }
  CASE cTIPO = "CRA"
      cBUS  := { "A", "a", "E", "e", "I", "i", "O", "o", "U", "u" }
      cDEST := { Chr(CHR_A_CRASE), Chr(CHR_a_CRASE), Chr(CHR_E_CRASE), Chr(CHR_e_CRASE), ;
                 Chr(CHR_I_CRASE), Chr(CHR_i_CRASE), Chr(CHR_O_CRASE), Chr(CHR_o_CRASE), ;
                 Chr(CHR_U_CRASE), Chr(CHR_u_CRASE) }
   CASE cTIPO = "GRA" // Apenas A/a conforme seu cÛdigo original
      cBUS  := { "A", "a" }
      cDEST := { Chr(CHR_A_CRASE), Chr(CHR_a_CRASE) }               
   OTHERWISE
      RETURN NIL
   ENDCASE

   xkey := Inkey( 0 )
   ykey := Chr( xkey )
   nPOS := AScan( cBUS, yKEY )

   IF nPOS > 0
      kkey := cDEST[ nPOS ]
   ELSE
      kkey := ykey
   ENDIF
   KEYBOARD ( kkey )
RETURN NIL

// +--------------------------------------------------------------------
// +
// +    Function AC_AGUDO()
// +
// +--------------------------------------------------------------------
// +
FUNCTION AC_AGUDO

   SET KEY 39 to
   ACENTUAR( "AGU" )
   SetKey( 39, {|| AC_AGUDO() } )
   RETURN


// +--------------------------------------------------------------------
// +
// +    Function AC_CRASE()
// +
// +--------------------------------------------------------------------
// +

FUNCTION AC_CRASE

   Acentuar( "CRA" )
   RETURN


// +--------------------------------------------------------------------
// +
// +    Function AC_TIL()
// +
// +--------------------------------------------------------------------
// +

FUNCTION AC_TIL

   Acentuar( "TIL" )
   RETURN


// +--------------------------------------------------------------------
// +
// +    Function AC_CIRC()
// +
// +--------------------------------------------------------------------
// +

FUNCTION AC_CIRC
   ACENTUAR( "CIR" )
   RETURN

// +--------------------------------------------------------------------
// +
// +    Function liga_acento()
// +
// +--------------------------------------------------------------------
// +

FUNCTION liga_acento

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
   RETURN


// +--------------------------------------------------------------------
// +
// +    Function Acento()
// +
// +--------------------------------------------------------------------
// +

FUNCTION Acento( texto )

   LOCAL ag   := Chr( 8 ) + Chr( 39 )
   LOCAL ti   := Chr( 8 ) + Chr( 126 )
   LOCAL cr   := Chr( 8 ) + Chr( 96 )
   LOCAL ci   := Chr( 8 ) + Chr( 94 )
   LOCAL ce   := Chr( 8 ) + Chr( 44 )
   LOCAL sp   := 0
   LOCAL X
   LOCAL aORI := { "†", "Ç", "°", "¢", "£", ;
      "µ", "ê", "÷", "‡", "È", ;
      "É", "à", "ì", "Ö", "∑", ;
      "á", "Ä", "∂", "“", "‚", ;
      "∆", "Ñ", "‰", "î", "«", "é", "ô", "Â" }
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
   RETURN ( texto )

// + EOF: disk54.prg
// +
