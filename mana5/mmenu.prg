*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mmenu.prg
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
// :      MMENU.PRG: Menu Principal do Manager
// :      Linguagem: Clipper 5.x
// :        Sistema: MANA5 - ITAESBRA
// :      Copyright (c) 1994, Disk Soft S/C Ltda.
// :  Atualizado em: 05/05/94     10:41
// :
// :*****************************************************************************
SETCOLOR("N/N")
CLS

WHILE .T.
   SETCOLOR(ZCOR001)
   @  0,0 SAY PADR(" ˛ Disk Softwares Manager Versao 5.53b",80)         
   MDI(" ˛ Menu Principal do Sistema")
   SETCOLOR('N/N')
   @ 24,00 SAY REPLICATE(" ",80)         
   // MDS("Vocà est† no Menu Principal")
   Set( _SET_MESSAGE, 3, .T. )
   SETCOLOR(ZCOR006)
   @  8,0 SAY " €€€  €€€€€€€€€   €€€     €€€€€€€   €€€€€€€   €€€€€€€‹    €€€€€€€€       €€€   "         
   @  9,0 SAY "∞€€€ ∞∞∞∞€€€∞∞  ∞€€€€€   ∞€€€∞∞∞  ∞€€€∞∞∞∞€€ ∞€€€∞∞∞€€‹  ∞€€€∞∞∞€€€    ∞€€€€€  "         
   @ 10,0 SAY "∞€€€    ∞€€€   ∞€€€∞€€€  ∞€€€     ∞€€€   ∞∞  ∞€€€  ∞€€ﬂ  ∞€€€  ∞∞€€€  ∞€€€∞€€€ "         
   @ 11,0 SAY "∞€€€    ∞€€€  ∞€€€ ∞∞€€€ ∞€€€€€€  ∞∞€€€€€€€  ∞€€€€€€€‹   ∞€€€   €€€  ∞€€€ ∞∞€€€"         
   @ 12,0 SAY "∞€€€    ∞€€€  ∞€€€  ∞€€€ ∞€€€∞∞    ∞∞∞∞∞∞€€€ ∞€€€∞∞∞€€€  ∞€€€€€€€€   ∞€€€  ∞€€€"         
   @ 13,0 SAY "∞€€€    ∞€€€  ∞€€€€€€€€€ ∞€€€           ∞€€€ ∞€€€  ∞∞€€€ ∞€€€∞∞∞€€€  ∞€€€€€€€€€"         
   @ 14,0 SAY "∞€€€    ∞€€€  ∞€€€∞∞∞€€€ ∞€€€      €€   ∞€€€ ∞€€€   €€€  ∞€€€  ∞∞€€€ ∞€€€∞∞∞€€€"         
   @ 15,0 SAY "∞€€€    ∞€€€  ∞€€€  ∞€€€ ∞€€€€€€€ ∞∞€€€€€€€  ∞€€€€€€€€   ∞€€€   ∞€€€ ∞€€€  ∞€€€"         
   @ 16,0 SAY "∞∞∞     ∞∞∞   ∞∞∞   ∞∞∞  ∞∞∞∞∞∞∞   ∞∞∞∞∞∞∞   ∞∞∞∞∞∞∞∞    ∞∞∞    ∞∞∞  ∞∞∞   ∞∞∞ "         
   SETCOLOR("W+/N")
   @ 19,18 SAY "      GERENCIADOR  DE  BANCO  DE  DADOS"         
   SETCOLOR(SUBSTR(ZCOR007,AT(",",ZCOR007)+1))
   @ 22,00 SAY "              Ajuda        Telememo        Anotaáîes        Agenda        Teclas "         
   @ 23,00 SAY "              Mem¢ria      Calend†rio      Calculadora      Rel¢gio       Data   "         
   SETCOLOR(SUBSTR(ZCOR007,RAT(",",ZCOR007)+1))
   @ 22,0 SAY "Teclas de"         
   @ 23,0 SAY " Funáîes "         
   SETCOLOR(ZCOR007)
   @ 22,11 SAY "F1"          
   @ 22,24 SAY "F2"          
   @ 22,40 SAY "F3"          
   @ 22,57 SAY "F4"          
   @ 22,70 SAY "F5"          
   @ 23,11 SAY "F6"          
   @ 23,24 SAY "F7"          
   @ 23,40 SAY "F8"          
   @ 23,57 SAY "F9"          
   @ 23,70 SAY "F10"         
   SETCOLOR(ZCOR005)
   OPCAO(2,0," &Cadastros  ",67,"Entra no Sub-Menu de Cadastros")
   OPCAO(2,13," &Relat¢rios ",82,"Entra no Sub-Menu de Relat¢rios")
   OPCAO(2,26," &ParÉmetros ",80,"Entra no Sub-Menu de Parametros")
   OPCAO(2,39," &Serviáos   ",83,"Entra no Sub-Menu de Serviáos")
   OPCAO(2,52," &Manual     ",77,"Apresenta o Manual")
   OPCAO(2,65," &Encerrar   ",69,"Encerra o Programa")
   KEY := MENU()
   DO CASE
      CASE KEY = 1 
         MANA()
      CASE KEY = 2 
         MANB()
      CASE KEY = 3 
         MANC()
      CASE KEY = 4 
         MAND()
      CASE KEY = 5 
         MANE()
      CASE KEY = 6 
         CLS 
         SETCURSOR(1) 
         RETU
      OTHERWISE
         IF mdg("Encerrar Programa")
            APAGAREG("MUSERN",ALLTRIM(ZUSER),.F.)
            SETCURSOR(1)
            CLS
            QUIT
         ENDIF
   ENDCASE
ENDDO



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ACESSO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC ACESSO

RETU .T.
