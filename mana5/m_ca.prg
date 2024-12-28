// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ca.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :       M_CA.PRG: Configuracao de Cores
// :
// :*****************************************************************************


// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"


PADRAO( 0, 1, 0, "CORES", "Codigo Descri‡„o", "' '+mCODIGO+' '+mDESCRICAO", ;
      "MCA", "MCA", {|| gMCA() }, {|| iMCA() } )


// Pegando Configura‡”es de Cores
CORARR( { "COR001", "COR002", "COR003", "COR004", "COR005", ;
      "COR006", "COR007", "COR008", "COR009", "COR010" }, ;
      { "ZCOR001", "ZCOR002", "ZCOR003", "ZCOR004", "ZCOR005", ;
      "ZCOR006", "ZCOR007", "ZCOR008", "ZCOR009", "ZCOR010" } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iMCA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC iMCA

   mCODIGO := Space( 6 )
   mCOR1   := "W/N  "
   mCOR2   := "N/W  "
   mCOR3   := "N    "
   mCOR4   := "N    "
   mCOR5   := "N/W  "
   RETU .T.

// Recebendo Parametro de Trabalho




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMCA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMCA

// Get nas Menvars
   SetColor( PAD002 )
   @  3, 26 GET mDESCRICAO PICT "@S50"
   READCUR()

   @  6, 25 SAY Chr( 17 )
   mCOR1 := MCA01( mCOR1 )
   @  6, 25 SAY Chr( 251 )
   SetColor( mCOR1 )
   @  6, 18 SAY "COR1"

   SetColor( PAD002 )
   @  8, 25 SAY Chr( 17 )
   mCOR2 := MCA01( mCOR2 )
   @  8, 25 SAY Chr( 251 )
   SetColor( mCOR2 )
   @  8, 18 SAY "COR2"

   SetColor( PAD002 )
   @ 10, 25 SAY Chr( 17 )
   mCOR3 := MCA01( mCOR3 )
   @ 10, 25 SAY Chr( 251 )
   SetColor( mCOR3 )
   @ 10, 18 SAY "COR3"

   SetColor( PAD002 )
   @ 12, 25 SAY Chr( 17 )
   mCOR4 := MCA01( mCOR4 )
   @ 12, 25 SAY Chr( 251 )
   SetColor( mCOR4 )
   @ 12, 18 SAY "COR4"

   SetColor( PAD002 )
   @ 14, 25 SAY Chr( 17 )
   mCOR5 := MCA01( mCOR5 )
   @ 14, 25 SAY Chr( 251 )
   SetColor( mCOR5 )
   @ 14, 18 SAY "COR5"
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MCA01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MCA01( cCOR )

   LOCAL LIN, COL, cCORF, cCORT, cCORETU, ESCOLHA

   LIN     := 1
   COL     := 1
   cCORF   := Left( cCOR, At( "/", cCOR ) - 1 )
   cCORT   := SubStr( cCOR, At( "/", cCOR ) + 1 )
   cCORETU := "W/N,N/W,N,N,N/W"
   DO CASE
   CASE At( "GR", cCORT ) > 0
      COL := 2
   CASE At( "BR", cCORT ) > 0
      COL := 3
   CASE At( "BG", cCORT ) > 0
      COL := 5
   CASE At( "W", cCORT ) > 0
      COL := 1
   CASE At( "R", cCORT ) > 0
      COL := 4
   CASE At( "G", cCORT ) > 0
      COL := 6
   CASE At( "B", cCORT ) > 0
      COL := 7
   CASE At( "N", cCORT ) > 0
      COL := 8
   OTHERWISE
      COL := 8
   ENDCASE
   DO CASE
   CASE At( "GR", cCORF ) > 0
      LIN := 4
   CASE At( "BR", cCORF ) > 0
      LIN := 6
   CASE At( "BG", cCORF ) > 0
      LIN := 10
   CASE At( "W", cCORF ) > 0
      LIN := 2
   CASE At( "R", cCORF ) > 0
      LIN := 8
   CASE At( "G", cCORF ) > 0
      LIN := 12
   CASE At( "B", cCORF ) > 0
      LIN := 14
   CASE At( "N", cCORF ) > 0
      LIN := 16
   OTHERWISE
      LIN := 2
   ENDCASE
   LIN -= IF( At( "+", cCOR ) > 0, 1, 0 )
   SetCursor( 0 )
   WHILE .T.
      SetColor( "W/N,N/W,N,N,W/N" )
      @ LIN + 5, COL * 3 + 38 SAY Chr( 16 )
      KEY     := 0
      MOUSE_B := 0
      WHILE KEY = 0
         KEY := HOTINKEY()
         KEY := LERMOUSE( KEY )
         // if MOUSE_B = 4    //Double click
         // nKEY := K_ENTER
         // endif
         IF MOUSE_B = 5  // Mouse Wheel Forward
            nKEY := K_UP
         ENDIF
         IF MOUSE_B = 6  // Mouse Wheel Backward
            nKEY := K_DOWN
         ENDIF
         ESCOLHA := .F.
         IF MOUSE_Y > 5 .AND. MOUSE_Y < 22 .AND. MOUSE_B = 2   // NAS LINHA E TECLOU DIREITO
            DO CASE
            CASE MOUSE_X = 42 .OR. MOUSE_X = 43
               ESCOLHA := .T.
            CASE MOUSE_X = 45 .OR. MOUSE_X = 46
               ESCOLHA := .T.
            CASE MOUSE_X = 48 .OR. MOUSE_X = 49
               ESCOLHA := .T.
            CASE MOUSE_X = 51 .OR. MOUSE_X = 52
               ESCOLHA := .T.
            CASE MOUSE_X = 54 .OR. MOUSE_X = 55
               ESCOLHA := .T.
            CASE MOUSE_X = 57 .OR. MOUSE_X = 58
               ESCOLHA := .T.
            CASE MOUSE_X = 60 .OR. MOUSE_X = 61
               ESCOLHA := .T.
            CASE MOUSE_X = 63 .OR. MOUSE_X = 64
               ESCOLHA := .T.
            ENDCASE
         ENDIF
         IF ESCOLHA
            LIN := MOUSE_Y - 5
            COL := ( MOUSE_X - 39 ) / 3
            KEY := K_ENTER
         ENDIF
      ENDDO
      @ LIN + 5, COL * 3 + 38 SAY " "
      SetColor( mCOR3 )
      hb_DispBox( 16, 2, 21, 28, HB_DOUBLE )
      SetColor( mCOR1 )
      hb_DispBox( 17, 3, 20, 9, "         " )
      @ 18, 6 SAY "P"
      @ 19, 6 SAY "R"
      SetColor( mCOR2 )
      hb_DispBox( 17, 12, 20, 18, "         " )
      @ 18, 15 SAY "D"
      @ 19, 15 SAY "E"
      SetColor( mCOR5 )
      hb_DispBox( 17, 21, 20, 27, "         " )
      @ 18, 24 SAY "N"
      @ 19, 24 SAY "S"
      SetColor( PAD002 )
      DO CASE
      CASE KEY = K_ENTER
         EXIT
      CASE KEY = K_ESC
         EXIT
      CASE KEY = K_UP .AND. LIN > 1
         LIN--
      CASE KEY = K_DOWN .AND. LIN < 16
         LIN++
      CASE KEY = K_LEFT .AND. COL > 1
         COL--
      CASE KEY = K_RIGHT .AND. COL < 8
         COL++
      CASE KEY = K_HOME
         COL := 1
         LIN := 1
      CASE KEY = K_END
         COL := 8
         LIN := 16
      CASE KEY = K_CTRL_HOME
         COL := 1
      CASE KEY = K_CTRL_END
         COL := 8
      CASE KEY = K_PGUP
         LIN := 1
      CASE KEY = K_PGDN
         LIN := 16
      ENDCASE
   ENDDO
   DO CASE
   CASE LIN = 1
      cCORETU := " +W/"
   CASE LIN = 2
      cCORETU := "  W/"
   CASE LIN = 3
      cCORETU := "+GR/"
   CASE LIN = 4
      cCORETU := " GR/"
   CASE LIN = 5
      cCORETU := "+BR/"
   CASE LIN = 6
      cCORETU := " BR/"
   CASE LIN = 7
      cCORETU := " +R/"
   CASE LIN = 8
      cCORETU := "  R/"
   CASE LIN = 9
      cCORETU := "+BG/"
   CASE LIN = 10
      cCORETU := " BG/"
   CASE LIN = 11
      cCORETU := " +G/"
   CASE LIN = 12
      cCORETU := "  G/"
   CASE LIN = 13
      cCORETU := " +B/"
   CASE LIN = 14
      cCORETU := "  B/"
   CASE LIN = 15
      cCORETU := " +N/"
   CASE LIN = 16
      cCORETU := "  N/"
   ENDCASE
   DO CASE
   CASE COL = 1
      cCORETU += " W"
   CASE COL = 2
      cCORETU += "GR"
   CASE COL = 3
      cCORETU += "BR"
   CASE COL = 4
      cCORETU += " R"
   CASE COL = 5
      cCORETU += "BG"
   CASE COL = 6
      cCORETU += " G"
   CASE COL = 7
      cCORETU += " B"
   CASE COL = 8
      cCORETU += " N"
   ENDCASE
   RETU cCORETU

// + EOF: m_ca.prg
// +
