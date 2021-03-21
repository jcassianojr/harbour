*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mand.prg
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
// :       MAND.PRG: Menu de Servi‡os
// :      Linguagem: Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 05/04/94     11:11
// :
// :     Documentado 05/13/94 em 14:48                DISK!  vers„o 5.01
// :*****************************************************************************
STATIC KEY := 1
aMENU := ARRAY(33)
aMESS := ARRAY(33)
AFILL(aMENU,SPAC(25))
AFILL(aMESS,SPAC(75))
IF USEREDE("MANOPT",1,1)
   DBGOTOP()
   DBSEEK("D")
   WHILE ITEMENU = "D" .AND. !EOF()
      IF POSICAO > 0 .AND. POSICAO < 34
         aMENU[ POSICAO ] := PADR(DESCP,25)
         aMESS[ POSICAO ] := DESCM
      ENDIF
      DBSKIP()
   ENDDO
   DBCLOSEAREA()
ENDIF
WHILE .T.
   MDI(" Ý Menu de configura‡”es")
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
      IF !ENTMNU("D",KEY)
         LOOP
      ENDIF
   ENDIF
   DO CASE
      CASE KEY = 1 
         M_DA(0)
      CASE KEY = 2 
         M_DB(0)
      CASE KEY = 3 
         AUTOMENU(" Ý Etiquetas","MDC",24,"MANSUB")
      CASE KEY = 4 
         M_DD(0)
      CASE KEY = 5
         PADRAO(0,1,0,"TELEMEMO",'Nome'+spac(12)+'Descri‡„o'+spac(27)+'Telefone',;
          "' '+mNOME+' '+mESPECIF+' '+mTELEF","MDE")
      CASE KEY = 6 
         PADRAO(0,1,0,"AGENDA","Data     Compromisso","' '+DTOC(mCDDATA)+' '+mOBS1","MDF")
      CASE KEY = 7 
         PADRAO(0,1,0,"NOTA","Nome"+spac(7)+"Descrição","' '+mNOME+' '+mOBS1","MDG")
      CASE KEY = 8 
         PADRAO(0,1,0,"MCOPIA","Nome   Descricao","' '+mNOME+' '+mDESCRICAO ","MDH")
      CASE KEY = 9
         COROLD  := SETCOLOR(COR("MDI001"))
         COMANDO := SPAC(80)
         MDS('Qual o comando desejado:')
         @ 24,40 GET COMANDO PICT "@S35"        
         READCUR()
         IF !EMPTY(COMANDO)
		    aSALVO:=SALVAA()
            SETCOLOR(COR("MDI002"))
            hb_run(COMANDO)
            MDS("Tecle algo para Continuar")
            INKEY(0)
			RESTAA(aSALVO)
         ENDIF
         SETCOLOR(COROLD)
         
      CASE KEY = 10
	     aSALVO:=SALVAA()
         SETCOLOR(COR("MDJ002"))
         CLS
         IF ! HB_FILEEXISTS(GetEnv("COMSPEC")) 
            MDT('Nao existe o "+GetEnv("COMSPEC"+", ou saida negada.')
            LOOP
         ENDIF
         MDT('Digite exit para retornar ao programa')
		 hb_run( GetEnv( "COMSPEC" ))
		 RESTAA(ASALVO)
      CASE KEY = 11 
         M_DK()
      CASE KEY = 12 
         M_DL(0)
      CASE KEY = 13 
         M_DM()
      CASE KEY = 14 
         M_DN(0)
      CASE KEY = 15 
         M_DO(0)
      CASE KEY = 16 
         M_DP(0)
      CASE KEY = 17 
         M_DQ(0)
      CASE KEY = 18 
         M_DRC(0)
      CASE KEY = 19
         PADRAO(0,1,0,"MANIVERS","Data     Aniversariante"+spac(32)+"Empresa",;
          "' '+DTOC(mDATA)+' '+mNOME+' '+mFIRMA","MDS")
      CASE KEY = 20 
         M_DT()
      CASE KEY = 21 
         M_DU()
      CASE KEY = 22 
         M_DV()
      CASE KEY = 23 
         M_DW()
      CASE KEY = 24 
         M_DX()
      CASE KEY = 25 
         M_DY()
      CASE KEY = 26 
         M_DZ()
      CASE KEY = 27 
         M_D1()
      CASE KEY = 28 
         M_D2()
      CASE KEY = 29 
         M_D3()
      CASE KEY = 30 
         M_D4()
      CASE KEY = 31 
         M_D5()
      CASE KEY = 32 
         M_D6()
      CASE KEY = 33 
         M_D7()
      OTHERWISE 
         EXIT
   ENDCASE
ENDDO
// : FIM: MAND.PRG
