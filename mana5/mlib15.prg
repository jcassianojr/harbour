// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib15.prg
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
// ****************************************************************************
// cARQ:=Nome do arquivo                 EX : "MC01"
// aCOR:=Matriz com As cores 1,2,5,6,7   EX : {MAC001,MAC002,MAC005,MAC006,MAC007}
// No Exemplo as cores foram ja armazenadas nas variaveis
// Posi‡„o na Matriz 1->[1] 2->[2] 5->[3] 6->[4] 7->[5]
// eCHAVE="Macro contendo a Chave Principal de Indexa‡ao EX: "mNUMERO"
//
// nOPER:=Variavel de Controle da Tecla Enter Ex: wMAC
// bTEL:=Nome do Bloco que Exibe a Tela  EX : {||tMAC()}
// bINS:=Bloco Para Inclus„o EX:{||fMAC(1,0)}
// bDEL:=Bloco Para Dele‡„o  EX:{||fMAC(3,0)}
// bAL1:=Bloco Para Alterar  EX:{||fMAC(2,0)}
// bAL2:=Bloco Para Alterar  EX:{||fMAC(6,0)}
// bLIS:=Bloco de Listagem Auxiliar - Padr„o=Manlista  EX:{||M_BC()}
// bAUX:=Bloco Com Fun‡”es Para Teclas Auxiliares



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function METPAG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC METPAG( cARQ, aCOR, eCHAVE, nOPR, bTEL, bINS, bDEL, bAL1, bAL2, bLIS, bAUX )

   PRIV KEY := 0

   nIND := if( lPIND, NUMIND( cARQ ), nIEXI )
   nREG := 0   // Fixa Posi‡„o Zero
   nREG := REGMOV( cARQ, nIND, nREG, "T" )
   IF nREG = 0   // Nenhum arquivo
      IF !mdg( "Nenhum Registro Deseja Cadastrar o Primeiro" )
         Eval( bINS )
         nREG := 1
      ENDIF
   ENDIF
   WHILE .T.
      mCHAVE := &eCHAVE.
      IF cTIPG = "1"
         Eval( bTEL )
      ELSE
         SetColor( aCOR[ 2 ] )
         EDITGET( .F., aCOR )
      ENDIF
      SetColor( aCOR[ 1 ] )
      @ MaxRow(), 0 SAY Chr( 17 ) + " " + Chr( 16 ) + " HOME END PGUP/DW=Move INS=Novo DEL=Apag ENT=Muda CTR+ENT=Busca ALT+F10=Lista"
      KEY := 0
      WHILE KEY = 0
         KEY := HOTINKEY()
         KEY := LERMOUSE( KEY )
         IF MOUSE_Y = MaxRow() .AND. MOUSE_B = 2
            DO CASE
            CASE MOUSE_X = 0
               KEY := K_DOWN
            CASE MOUSE_X = 2
               KEY := K_UP
            CASE MOUSE_X > 3 .AND. MOUSE_X < 8
               KEY := K_HOME
            CASE MOUSE_X > 8 .AND. MOUSE_X < 12
               KEY := K_END
            CASE MOUSE_X > 12 .AND. MOUSE_X < 17
               KEY := K_PGUP
            CASE MOUSE_X > 16 .AND. MOUSE_X < 21
               KEY := K_PGDN
            CASE MOUSE_X > 25 .AND. MOUSE_X < 34
               KEY := K_INS
            CASE MOUSE_X > 34 .AND. MOUSE_X < 43
               KEY := K_DEL
            CASE MOUSE_X > 43 .AND. MOUSE_X < 52
               KEY := K_ENTER
            CASE MOUSE_X > 52 .AND. MOUSE_X < 66
               KEY := K_CTRL_RET
            CASE MOUSE_X > 66 .AND. MOUSE_X < 79
               KEY := K_ALT_F10
            ENDCASE
         ENDIF
         IF MOUSE_Y = 1 .AND. MOUSE_B = 2 .AND. MOUSE_X < 4
            KEY := K_ESC
         ENDIF
      ENDDO
      DO CASE
      CASE KEY = K_UP .OR. KEY = K_RIGHT
         nREG := REGMOV( cARQ, nIND, nREG, + 1 )
      CASE KEY = K_DOWN .OR. KEY = K_LEFT
         nREG := REGMOV( cARQ, nIND, nREG, - 1 )
      CASE KEY = K_PGUP
         nREG := REGMOV( cARQ, nIND, nREG, + 10 )
      CASE KEY = K_PGDN
         nREG := REGMOV( cARQ, nIND, nREG, - 10 )
      CASE KEY = K_HOME
         nREG := REGMOV( cARQ, nIND, nREG, "T" )
      CASE KEY = K_END
         nREG := REGMOV( cARQ, nIND, nREG, "B" )
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
         nIBUS   := if( lPBUS, NUMIND( cARQ ), nIBUS )
         mCHABUS := PEGBUS( cARQ, nIBUS )
         nREG    := REGBUS( cARQ, nIBUS, mCHABUS )
      CASE KEY = K_ESC
         EXIT
      OTHERWISE
         IF ValType( bAUX ) = "B"
            Eval( bAUX )
         ENDIF
      ENDCASE
   ENDDO
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function REGMOV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC REGMOV( cARQ, nIND, nREG, nSAL )

   LOCAL nREGRET := 0
   LOCAL cMES    := ""
   LOCAL lZERO   := .F.

   IF ValType( nREG ) # "N"
      nREG := 1
   ENDIF
   IF !USEREDE( cARQ, 1, nIND )
      ALERTX( "N„o Consegui Abrir o Arquivo" )
      RETU nREG
   ENDIF
   IF ValType( nSAL ) = "N"
      dbGoto( nREG )
      dbSkip( nSAL )
      IF nSAL < 0
         IF Bof()
            cMES := "Vocˆ est  no primeiro Registro"
            dbGoTop()
         ENDIF
      ENDIF
      IF nSAL > 0
         IF Eof()
            cMES := "Vocˆ est  no ultimo Registro"
            dbGoBottom()
         ENDIF
      ENDIF
   ENDIF
   IF ValType( nSAL ) = "C"
      IF nSAL = "B"
         dbGoBottom()
      ENDIF
      IF nSAL = "T"
         dbGoTop()
         IF Eof()
            lZERO := .T.
         ENDIF
      ENDIF
   ENDIF
   IF !lZERO
      EQUVARS()
      nREGRET := RecNo()
   ENDIF
   dbCloseArea()
   IF !Empty( cMES )
      ALERTX( cMES )
   ENDIF
   RETU nREGRET


// + EOF: mlib15.prg
// +
