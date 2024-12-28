// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib14.prg
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



#include "INKEY.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function METNVI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC METNVI( cARQ, bINS, bDEL, bAL1, bAL2, bBUS, cCOR, nOPR, bLIS )

   WHILE .T.
      MDF()
      MDS( "INS=Novo DEL=Apagar ENTER=Alterar CTRL+ENTER=Busca ALT+F10=Listar ESC=Sair" )
      SetColor( cCOR )
      KEY := 0
      WHILE KEY = 0
         KEY := HOTINKEY()
         KEY := LERMOUSE( KEY )
         IF MOUSE_Y = MaxRow() .AND. MOUSE_B = 2
            DO CASE
            CASE MOUSE_X > 0 .AND. MOUSE_X < 7
               KEY := K_INS
            CASE MOUSE_X > 9 .AND. MOUSE_X < 18
               KEY := K_DEL
            CASE MOUSE_X > 20 .AND. MOUSE_X < 32
               KEY := K_ENTER
            CASE MOUSE_X > 34 .AND. MOUSE_X < 49
               KEY := K_CTRL_RET
            CASE MOUSE_X > 51 .AND. MOUSE_X < 64
               KEY := K_ALT_F10
            CASE MOUSE_X > 66 .AND. MOUSE_X < 74
               KEY := K_ESC
            ENDCASE
         ENDIF
         IF MOUSE_Y = 1 .AND. MOUSE_B = 2 .AND. MOUSE_X < 4
            KEY := K_ESC
         ENDIF
      ENDDO
      DO CASE
      CASE KEY = K_INS
         Eval( bINS )
      CASE KEY = K_ENTER .AND. nOPR # 3
         Eval( bAL1 )
      CASE KEY = K_ENTER .AND. nOPR = 3
         Eval( bAL2 )
         RETU
      CASE KEY = K_DEL
         Eval( bDEL )
      CASE KEY = K_ALT_F10
         IF ValType( bLIS ) = "B"
            Eval( bLIS )
         ELSE
            MANLISTA()
         ENDIF
      CASE KEY = K_CTRL_RET
         nIBUS  := if( lPBUS, NUMIND( cARQ ), nIBUS )
         mCHAVE := PEGBUS( cARQ, nIBUS )
         nREG   := REGBUS( cARQ, nIBUS, mCHAVE )
         Eval( bBUS )
      CASE KEY = K_ESC
         EXIT
      OTHERWISE
         LOOP
      ENDCASE
   ENDDO
   RETU .T.


// + EOF: mlib14.prg
// +
