*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mane.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :       MANE.PRG: Manual
// :      Linguagem: Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 05/04/94     11:46
// :
// :  Procs & Fncts: MANE()
// :               : MANUALT()
// :               : MANRETA()
// :               : FMANUAL()
// :               : MANRETM()
// :
// :          Chama: COR()     (fun‡„o em MLIB.PRG)
// :               : MANUALT() (fun‡„o em MANE.PRG)
// :               : USEREDE() (fun‡„o em MLIB.PRG)
// :               : MARCAR()  (fun‡„o em MLIB.PRG)
// :               : MARCAR1() (fun‡„o em MLIB.PRG)
// :               : MANRETA() (fun‡„o em MANE.PRG, chamado  no Achoice())
// :               : FMANUAL() (fun‡„o em MANE.PRG)
// :
// :     Documentado 05/13/94 em 14:48                DISK!  vers„o 5.01
// :*****************************************************************************



//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
//#INCLUDE "teclas.CH"

//Inicializando o Help
HELPDBF := "MANE"

// Carregando Cores
MANE01 := COR("MANE01")
MANE02 := COR("MANE02")
MANE03 := COR("MANE03")
MANE04 := COR("MANE04")

// Tela de Apresenta‡ao
MANUALT()

// Variaveis de Trabalho
DIRMAN   := ZDIRP+"MAN\"
xGRAF    := 0
mARQUIVO := ""
MAN51    := {}  //Matriz Achoice
MAN52    := {}  //Matriz Arquivo

//Carregando Matriz
IF !USEREDE("MANAMAN",1,1)
   RETU .F.
ENDIF
GRAF := LASTREC()
MARCAR('Carregando Itens do Manual')
WHILE !EOF()
   AADD(MAN51,' '+DESCRICAO+' ')
   AADD(MAN52,ARQUIVO)
   MARCAR1()
   DBSKIP()
ENDDO
DBCLOSEAREA()

MDS("Enter=Exibe Ctrl+Enter=Busca ALT+F10=Imprime")
//Exibindo e Processando o Achoice
ACHEI := 1
WHILE .T.
   nKEY   := 0
   ACHEI2 := ESCARR(MAN51,1,0,23,79,ACHEI,"Conta   Descricao",,"Enter=Exibe Ctrl+Enter=Busca ALT+F10=Imprime")
   ACHEI  := IF(ACHEI2 # 0,ACHEI2,ACHEI)
   ACHEI2 := ACHEI
   @ 24,00 CLEA
   DO CASE
      CASE LASTKEY() = K_ESC 
         EXIT
      CASE LASTKEY() = K_ENTER
         FMANUAL(1,ACHEI)
      CASE LASTKEY() = K_ALT_F10
         fMANUAL(2,ACHEI)
      OTHERWISE 
         LOOP
   ENDCASE
ENDDO
RETU

// !*************************************************************************
// !
// !    Chamado por: MANE.PRG
// !
// !          Chama: MANRETM()  (fun‡„o em MANE.PRG, chamado  no MemoEdit())
// !               : MANUALT()  (fun‡„o em MANE.PRG)
// !               : MANCRIMP() (fun‡„o em MANE.PRG)
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fMANUAL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC fMANUAL(OPRMAN5,POSMAN5)

NOBREAK()
mARQUIVO := MAN52[POSMAN5]
MDS("Aguarde Carregando os dados")
IF OPRMAN5 = 1
   CLEAR
   SETCOLOR(MANE02)
   @ 00,00 CLEAR TO 00,79
   @ 24,00 CLEAR TO 24,79
   @ 00,00 SAY "       "+SPAC(6)+"           ÝÝ Mover: "+CHR(24)+" "+CHR(25)+" PGUP PGDN HOME END  ÝÝ Sair: ESC "         
   @ 24,00 SAY MAN51[POSMAN5]                                                                                             
   SETCOLOR(MANE03)
   SETCURSOR(1)
   NOBREAK()
   VERTXT(DIRMAN+mARQUIVO)
   //READTEXT(DIRMAN+mARQUIVO,01,00,23,78)
   MANUALT()
ENDIF
IF OPRMAN5 = 2
   IMPARQ(DIRMAN+mARQUIVO)
ENDIF
MDS("Enter=Exibe Ctrl+Enter=Busca ALT+F10=Imprime")
RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: MANUALT() Tela de Exibi‡„o
// !
// !    Chamado por: MANE.PRG
// !               : FMANUAL()          (fun‡„o    em MANE.PRG)
// !
// !          Chama: CLSBOX()           (fun‡„o    em ?)
// !               : CLSCOR()           (fun‡„o    em ?)
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MANUALT()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MANUALT

SETCOLOR(MANE01)
CLSBOX(00,00,00,79)
@ 00,00 SAY "<<MANUAL> v5.3B "         
MDS("Enter=Exibe Ctrl+Enter=Busca ALT+F10=Imprime")
CLSCOR()
RETU .T.

// : FIM: MANE.PRG
