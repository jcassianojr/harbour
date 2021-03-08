*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_dl.prg
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
// :   M_DL    .PRG: Tabela de Caracteres em ASCII
// :      Linguagem: Clipper 5.x
// :        Sistema: RECURSOS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/28/94     11:19
// :
// :  Procs & Fncts : IMPASCII
// :
// :     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
// :*****************************************************************************

#INCLUDE "BOX.CH"
#INCLUDE "INKEY.CH"

//Help de Contexto
PRIV HELPDBF := "MDL"

// Desenha a Tela
MDI(" þ Tabela ASCII")
MDS("Vocˆ est  vendo a Tabela ASCII ")

CHAR := 00
KEY  := 00
SETCOLOR("RB")
HB_dispbox( 8, 0, 24, 79,B_DOUBLE)
@ 08,10 SAY "Ñ"+REPL('Í',9)+"Ñ"+REPL('Í',9)+"Ñ"+REPL('Í',9)+"Ñ"+REPL('Í',9)+"Ñ"+REPL('Í',9)+"Ñ"+REPL('Í',8)+"Ñ"                                         
@ 09,02 SAY "Dec Car ³ Dec Car ³ Dec Car ³ Dec Car ³ Dec Car ³ Dec Car ³Dec Car ³ Dec Car"                                                              
@ 10,00 SAY 'Æ'+REPL('Í',9)+"Ø"+REPL('Í',9)+"Ø"+REPL('Í',9)+"Ø"+REPL('Í',9)+"Ø"+REPL('Í',9)+"Ø"+REPL('Í',9)+"Ø"+REPL('Í',8)+"Ø"+REPL('Í',9)+'µ'         
FOR X := 11 TO 23
   @ X,10 SAY "³"+SPAC(9)+"³"+SPAC(9)+"³"+SPAC(9)+"³"+SPAC(9)+"³"+SPAC(9)+"³"+SPAC(8)+"³"         
NEXT X
@ 24,10 SAY "Ï"+REPL('Í',9)+"Ï"+REPL('Í',9)+"Ï"+REPL('Í',9)+"Ï"+REPL('Í',9)+"Ï"+REPL('Í',9)+"Ï"+REPL('Í',8)+"Ï"         
SETCOLOR("W/N")
IMPASCII()
DO WHILE .T.
   KEY := HOTINKEY(0)
   IF KEY = K_ESC
      EXIT
   ENDIF
   IF KEY = K_DOWN
      CHAR += 104
      CHAR := IF(CHAR > 207,152,CHAR)
   ENDIF
   IF KEY = K_UP
      CHAR -= 104
      CHAR := IF(CHAR < 0,0,CHAR)
   ENDIF
   IMPASCII()
   KEY := 0
ENDDO
RETU



// !*****************************************************************************
// !
// !      Fun‡ao: IMPASCII
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function IMPASCII()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC IMPASCII

FOR X := 0 TO 12
   FOR Y := 0 TO 7
      CHART := X * 8+CHAR+Y
      @ X+11,Y * 10+2 SAY CHART      PICT '###'        
      @ X+11,Y * 10+7 SAY CHR(CHART)                   
   NEXT Y
NEXT X
RETU
// : FIM M_DL.PRG
