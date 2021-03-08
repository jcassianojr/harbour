*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : manc.prg
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

// :******************************************************************************:
// :       MANC.PRG: Sub-Menu de Configura‡”es
// :      Linguagem: Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Softec
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 15/09/97
// :
// :*****************************************************************************
STATIC KEY := 1
aMENU := ARRAY(33)
aMESS := ARRAY(33)
AFILL(aMENU,SPACE(25))
AFILL(aMESS,SPACE(75))
IF USEREDE("MANOPT",1,1)
   DBGOTOP()
   DBSEEK("C")
   WHILE ITEMENU = "C" .AND. !EOF()
      IF POSICAO > 0 .AND. POSICAO < 34
         aMENU[ POSICAO ] := PADR(DESCP,25)
         aMESS[ POSICAO ] := DESCM
      ENDIF
      DBSKIP()
   ENDDO
   DBCLOSEAREA()
ENDIF


WHILE .T.
   MDI(" þ Vocˆ est  escolhendo a Configura‡„o Para Altera‡„o")
   SETCOLOR(ZCOR008)
   FOR X := 1 TO 11
      OPCAO(X * 2+2,1," &"+LTRIM(aMENU[X]),ASC(LEFT(ALLTRIM(aMENU[X]),1)),aMESS[X])
   NEXT X
   FOR X := 12 TO 22
      OPCAO((X - 11) * 2+2,27," &"+LTRIM(aMENU[X]),ASC(LEFT(ALLTRIM(aMENU[X]),1)),aMESS[X])
   NEXT X
   FOR X := 23 TO 33
      OPCAO((X - 22) * 2+2,53," &"+LTRIM(aMENU[X]),ASC(LEFT(ALLTRIM(aMENU[X]),1)),aMESS[X])
   NEXT X
   KEY := MENU(1,2)
   IF KEY > 0
      IF !ENTMNU("C",KEY)
         LOOP
      ENDIF
   ENDIF
   DO CASE
      CASE KEY = 1 
         M_CA(0)
      CASE KEY = 2 
         M_CB(0)
      CASE KEY = 3
         IF MDG("Configurar Menus do Mana5")
            PADRAO(0,1,0,"MANOPT","I PO Item"+spac(17)+"Mensagem",;
             "' '+mITEMENU+' '+STR(mPOSICAO,2)+' '+mDESCP+' '+SUBSTR(ALLTRIM(mDESCM),1,40)","MCC")
         ENDIF
         IF MDG("Configurar Sub-Menus do Mana5")
            PADRAO(0,1,0,"MANSUB","I PO Item"+spac(17)+"Mensagem",;
             "' '+mITEMENU+' '+STR(mPOSICAO,2)+' '+mDESCP+' '+SUBSTR(ALLTRIM(mDESCM),1,40)","MCC")
         ENDIF
         IF MDG("Configurar Menus do ManaW")
            PADRAO(0,1,0,"WINOPT","I PO Item"+spac(17)+"Mensagem",;
             "' '+mITEMENU+' '+STR(mPOSICAO,2)+' '+mDESCP+' '+SUBSTR(ALLTRIM(mDESCM),1,40)","MCC")
         ENDIF
         IF MDG("Configurar Acessos do Sysw")
            PADRAO(0,1,0,"SYSOPT","I PO Item"+spac(17)+"Mensagem",;
             "' '+mITEMENU+' '+STR(mPOSICAO,2)+' '+mDESCP+' '+SUBSTR(ALLTRIM(mDESCM),1,40)","MCC")
         ENDIF

      CASE KEY = 4 
         M_CD()
      CASE KEY = 5 
         M_CE(0)
      CASE KEY = 6 
         M_CF(0)
      CASE KEY = 7 
         M_CG()
      CASE KEY = 8 
         M_CH(0)
      CASE KEY = 9 
         M_CI(0)
      CASE KEY = 10 
         EDITARQ("\CONFIG.SYS")
      CASE KEY = 11 
         EDITARQ("\AUTOEXEC.BAT")
      CASE KEY = 12 
         PADRAO(0,1,0,"CODIMP","C¢digo Impressora Descri‡„o","' '+mCODIGO+' '+mNOMEIMP+' '+mDESCRICAO","MCL")
      CASE KEY = 13 
         M_CM(0)
      CASE KEY = 14 
         M_CN(0)
      CASE KEY = 15 
         M_CO(0)
      CASE KEY = 16 
         M_CP()
      CASE KEY = 17 
         M_CQ()
      CASE KEY = 18 
         M_CR()
      CASE KEY = 19 
         M_CS()
      CASE KEY = 20 
         PADRAO(0,1,0,"MANFEC","Origem Destino","' '+mARQORI+' '+mSTRDES+' '+OBTER('MANARQ',mARQORI,'DESCRICAO')","MCT")
      CASE KEY = 21 
         PADRAO(0,1,0,"MF11","Variavel   Arquivo","' '+mVARIAVEL+' '+mARQUIVO","MCU")
      CASE KEY = 22 
         M_CV()
      CASE KEY = 23
      CASE KEY = 24
      CASE KEY = 25
      CASE KEY = 26
      CASE KEY = 27
      CASE KEY = 28
      CASE KEY = 29
      CASE KEY = 30
      CASE KEY = 31
      CASE KEY = 32
      CASE KEY = 33
      OTHERWISE 
         EXIT
   ENDCASE
ENDDO
// : FIM: MANC.PRG
