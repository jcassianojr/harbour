// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib30.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ACHMOU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC ACHMOU( nStatus, nElement, nRelative )

   SCROLLBARUPDATE( aSBAR, nElement, nSBAR, .T. )
   SetColor( SubStr( cCOR, At( ",", cCOR ) + 1 ) )
   @ nRELATIVE + 5, 1 SAY PadR( Eval( bELE, nElement ), 78 )
   nKEY  := 0
   cMOVE := ""
   WHILE nKEY = 0
      nKEY := HOTINKEY()
      nKEY := LERMOUSE( nKEY )
      DO CASE
      CASE MOUSE_B = 1 .AND. MOUSE_Y = 4
         nKEY := K_UP
      CASE MOUSE_B = 1 .AND. MOUSE_Y = MaxRow() - 1
         nKEY := K_DOWN
      CASE MOUSE_B = 2
         nKEY := K_ESC
      CASE MOUSE_Y = 1 .AND. MOUSE_B = 1 .AND. MOUSE_X < 4
         nKEY := K_ESC
      CASE MOUSE_B = 1 .AND. Row() = MOUSE_Y .AND. MOUSE_X # MaxCol() - 1
         nKEY := K_ENTER
      ENDCASE
      IF MOUSE_X = 79 .AND. MOUSE_B = 1
         DO CASE
         CASE MOUSE_Y = 03
            nKEY := K_HOME
         CASE MOUSE_Y >= 5 .AND. MOUSE_Y <= 13
            nKEY := K_PGUP
         CASE MOUSE_Y >= 14 .AND. MOUSE_Y <= 22
            nKEY := K_PGDN
         CASE MOUSE_Y = MaxRow()
            nKEY := K_END
         ENDCASE
      ENDIF
      IF MOUSE_Y = MaxRow() .AND. MOUSE_B = 1
         DO CASE
         CASE MOUSE_X > 00 .AND. MOUSE_X < 07
            nKEY := K_INS
         CASE MOUSE_X > 09 .AND. MOUSE_X < 17
            nKEY := K_DEL
         CASE MOUSE_X > 19 .AND. MOUSE_X < 30
            nKEY := K_ENTER
         CASE MOUSE_X > 32 .AND. MOUSE_X < 47
            nKEY := K_CTRL_RET
         CASE MOUSE_X > 49 .AND. MOUSE_X < 62
            nKEY := K_ALT_F10
         ENDCASE
      ENDIF
      IF MOUSE_B = 1 .AND. MOUSE_Y > 4 .AND. MOUSE_Y < MaxRow() - 1 .AND. MOUSE_X # MaxCol() - 1 .AND. Row() # MOUSE_Y
         IF MOUSE_Y < Row()
            nKEY  := 255   // Apenas Para Sair do Loop
            cMOVE := repl( Chr( K_UP ), Row() - MOUSE_Y )
         ELSE
            nKEY  := 255
            cMOVE := repl( Chr( K_DOWN ), MOUSE_Y - Row() )
         ENDIF
      ENDIF
   ENDDO
   SetColor( cCOR )
   @ nRELATIVE + 5, 1 SAY PadR( Eval( bELE, nElement ), 78 )
   DO CASE
   CASE nKEY = K_HOME  // HOME VIRA CTRL_PGUP
      nKEY := K_CTRL_PGUP
   CASE nKEY = K_END   // END  VIRA CTRL_PGDN
      nKEY := K_CTRL_PGDN
   ENDCASE
   DO CASE
   CASE nKEY = K_ENTER
      RETU 1
   CASE nKEY = K_INS
      RETU 0
   CASE nKEY = K_DEL
      RETU 1
   CASE nKEY = K_CTRL_RET
      RETU 0
   CASE nKEY = K_ALT_F1
      RETU 1
   CASE nKEY = K_ALT_F2
      RETU 1
   CASE nKEY = K_ALT_F3
      RETU 1
   CASE nKEY = K_ALT_F4
      RETU 1
   CASE nKEY = K_ALT_F5
      RETU 1
   CASE nKEY = K_ALT_F6
      RETU 1
   CASE nKEY = K_ALT_F7
      RETU 1
   CASE nKEY = K_ALT_F8
      RETU 1
   CASE nKEY = K_ALT_F9
      RETU 1
   CASE nKEY = K_ALT_F10
      RETU 1
   CASE nKEY = K_SH_F1
      RETU 1
   CASE nKEY = K_SH_F2
      RETU 1
   CASE nKEY = K_SH_F3
      RETU 1
   CASE nKEY = K_SH_F4
      RETU 1
   CASE nKEY = K_SH_F5
      RETU 1
   CASE nKEY = K_SH_F6
      RETU 1
   CASE nKEY = K_SH_F7
      RETU 1
   CASE nKEY = K_SH_F8
      RETU 1
   CASE nKEY = K_SH_F9
      RETU 1
   CASE nKEY = K_ALT_ENTER
      RETU 1
   CASE nKEY = K_CTRL_DEL
      RETU 1
   CASE nKEY = K_ESC
      RETU 0
   ENDCASE
   IF Empty( cMOVE )
      KEYBOARD Chr( nKEY )
   ELSE
      KEYBOARD cMOVE
   ENDIF
   RETU 2



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABVID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CABVID( cCOR, nPOS, xR1, xR2 )

   IF ValType( xR1 ) # "N"
      xR1 := 2
   ENDIF
   IF ValType( xR2 ) # "N"
      xR2 := 24
   ENDIF
   SetColor( cCOR )
   hb_DispBox( xR1, 0, xR2 - 1, 79, B_DOUBLE )
   @ xR1 + 1, 1  SAY cCBAS
   @ xR1 + 1, 79 SAY "Ý"
   @ xR1 + 2, 0  SAY '+' + Replicate( '-', 77 ) + 'AÝ'
   @ xR2, 0    SAY "INS=Novo DEL=Apaga Enter=Altera Ctrl+ENTER=Busca Alt+F10=Lista" + spac( 17 ) + "Ý"
   SetColor( cCOR )
   ScrollBarUpdate( aSBAR, nPOS, nSBAR, .T. )
   ScrollBarDisplay( aSBAR )
   RETU .T.


// + EOF: mlib30.prg
// +
