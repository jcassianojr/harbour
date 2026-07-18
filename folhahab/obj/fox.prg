// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fox.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   MANUAL .PRG : MANUAL
// :     Linguagem : harbour
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 05/02/94     11:49
// :
// :  Procs & Fncts: FOX()
// :               : MANUALT()
// :               : MANRETA()
// :               : FMANUAL()
// :               : MANRETM()
// :
// :          Chama: MANUALT()          (fun‡„o em FOX.PRG)
// :               : SCROLLBARDISPLAY() (fun‡„o em ?)
// :               : MANRETA()          (fun‡„o em FOX.PRG, chamado  no Achoice())
// :               : FMANUAL()          (fun‡„o em FOX.PRG)
// :
// :     Documentado 01/09/93 em 13:34                DISK!  vers„o 5.01
// :*****************************************************************************
// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fox()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fox

   PARA WARQMAN

   IF PCount() = 0
      WARQMAN := "FOLHAMAN"
   ENDIF


// Tela de Apresenta‡ao
   MANUALT()

// Variaveis de Trabalho
   GRAPP    := 1
   MARQUIVO := ""
   MAT1     := {}  // Matriz Achoice
   MAT2     := {}  // Matriz Arquivo

// Carregando Matriz
   IF !netuse( warqman )   // AREDE(WARQMAN,WARQMAN,0)
      RETU .F.
   ENDIF
   GRAPT := LastRec()
   GRAPT( 'Carregando Itens do Manual' )
   WHILE !Eof()
      AAdd( MAT1, ' ' + DESCRICAO + ' ' )
      AAdd( MAT2, ARQUIVO )
      GRAPS()
      dbSkip()
   ENDDO
   dbCloseAll()

// Exibindo e Processando o Achoice
   NOBREAK()
   ACHEI := 1
   GRAF  := Len( MAT1 )
   BSBAR := SCROLLBARNEW( 03, 79, 23,, 1 )
   WHILE .T.
      hb_DispBox( 1, 0, 23, 79, B_DOUBLE + " " )
      @  2, 2 SAY "Conta   Descri‡„o"
      @  3, 0 SAY 'Ç' + REPL( '-', 78 ) + '¶'
      MDS( "Enter=Exibe Ctrl+Enter=Lista" )
      SCROLLBARDISPLAY( BSBAR )
      SCROLLBARUPDATE( BSBAR, ACHEI, GRAF, .T. )
      ACHEI2 := AChoice( 04, 01, 22, 78, MAT1,, "MANRETA", ACHEI )
      ACHEI  := IF( ACHEI2 # 0, ACHEI2, ACHEI )
      ACHEI2 := ACHEI
      MD()
      DO CASE
      CASE LastKey() = K_ESC
         MDS( 'Retornando' )
         EXIT
      CASE LastKey() = K_ENTER
         MDS( 'Exibindo  ' )
         FMANUAL( 1, ACHEI )
      CASE LastKey() = K_CTRL_ENTER
         MDS( 'Imprimindo' )
         FMANUAL( 2, ACHEI )
      OTHERWISE
         LOOP
      ENDCASE
   ENDDO
   RETU

// !*****************************************************************************
// !
// !         Fun‡„o: FMANUAL()
// !
// !    Chamado por: FOX.PRG
// !
// !          Chama: SCROLLBARDISPLAY() (fun‡„o    em ?)
// !               : MANRETM()          (fun‡„o    em FOX.PRG, chamado  no MemoEdit())
// !               : MANUALT()          (fun‡„o    em FOX.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FMANUAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FMANUAL( OPR, POS2 )  // 1-Exibir 2-Listar

// ******************
   MARQUIVO := MAT2[ POS2 ]
   MDS( "Aguarde Carregando os dados" )
   TEXTO := hb_MemoRead( hb_cwd() + "MAN\" + MARQUIVO )
   FIM   := MLCount( TEXTO )
   IF OPR = 1
      CLEAR
      SetColor( "N/W" )
      @ 00, 00 CLEAR TO 00, 79
      @ 24, 00 CLEAR TO 24, 79
      @ 00, 00 SAY " Linha:" + SPAC( 6 ) + "Coluna:    ÝÝ Mover: " + Chr( 24 ) + " " + Chr( 25 ) + " PGUP PGDN HOME END  ÝÝ Sair: ESC "
      @ 24, 00 SAY MAT1[ POS2 ]
      SetColor( "W/N" )
      SetCursor( 1 )
      NOBREAK()
      ASBAR := SCROLLBARNEW( 00, 79, 24,, 1 )
      SCROLLBARDISPLAY( ASBAR )
      MemoEdit( TEXTO, 01, 00, 23, 78, .F., "MANRETM", 79, 4, 1, 0, 0, 0 )
      MANUALT()
   ENDIF
   IF OPR = 2
      IMPHP()
      checkimp( 0 )
      impressora()
      @ PRow(), 0 SAY IMPSTR( cIMPCOM )
      X := 1
      WHILE X <= FIM
         @ PRow() + 2, 0 SAY ""
         FOR Y := 1 TO 55
            @ PRow() + 1, 0 SAY RTrim( tipogra( ACENTO( MemoLine( TEXTO, 80, X ) ) ) )
            X++
            IF X > FIM
               EXIT
            ENDIF
         NEXT Y
         IMPFOL()
      ENDDO
      VIDEO()
      IMPEND()
   ENDIF
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: MANUALT()  Tela de Exibi‡„o
// !
// !    Chamado por: FOX.PRG
// !               : FMANUAL()          (fun‡„o    em FOX.PRG)
// !
// !          Chama: CLSBOX()           (fun‡„o    em ?)
// !               : CLSCOR()           (fun‡„o    em ?)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MANUALT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MANUALT

   SetColor( "+W/N,N/W" )
   CLSBOX( 00, 00, 00, 79 )
   @ 00, 00 SAY "<MANUAL> v5.3b"
   CLSCOR()
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: MANRETA()  Retorno do Achoice
// !
// !    Chamado por: FOX.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MANRETA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MANRETA( NSTATUS, NELEMENT, NRELATIVE )  // criado apenas para retornar o ponteiro do vetor

   IF NSTATUS == 0
      SCROLLBARUPDATE( BSBAR, NELEMENT, GRAF )
   ENDIF
   DO CASE
   CASE LastKey() = K_CTRL_ENTER
      RETU 1
   CASE LastKey() = K_ESC
      RETU 0
   CASE LastKey() = K_CTRL_ENTER
      RETU 1
   CASE LastKey() = K_HOME   // HOME VIRA CTRL_PGUP
      KEYBOARD Chr( K_CTRL_PGUP )
   CASE LastKey() = K_END    // END  VIRA CTRL_PGDN
      KEYBOARD Chr( K_CTRL_PGDN )
   OTHERWISE
      RETU 2
   ENDCASE
   RETU .T.


// !*****************************************************************************
// !
// !         Fun‡„o: MANRETM()  Retorno do Memoedit
// !
// !    Chamado por: FMANUAL()  (fun‡„o em FOX.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MANRETM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MANRETM

   SetColor( "N/W" )
   PARA MODO, LINHA, COLUNA
   DO CASE
   CASE LastKey() = K_HOME   // HOME VIRA CTRL_PGUPF
      KEYBOARD Chr( K_CTRL_PGUP )
   CASE LastKey() = K_END    // END  VIRA CTRL_PGDN
      KEYBOARD Chr( K_CTRL_PGDN )
   ENDCASE
   SCROLLBARUPDATE( ASBAR, LINHA, FIM, .T. )
   @ 00, 08 SAY LINHA  PICT "####"
   @ 00, 21 SAY COLUNA PICT "##"
   SetColor( "W/N" )
   RETU 0

// : FIM: FOX.PRG

// + EOF: fox.prg
// +
