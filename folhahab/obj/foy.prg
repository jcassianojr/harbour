*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foy.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:46 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :        FOY.PRG: Menu do Auxilio Operacional
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 12/03/99
// :
// :*****************************************************************************
//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


PRIV HELPDBF
HELPDBF := "FOY"
WHILE .T.
   CABEX("Menu do Auxilio Operacional")
   SETCOLOR("+GR/BG")
   HB_DISPBOX(3,0,23,79,B_DOUBLE+" ")
   OPCAO(4,2," 1 - Sequencia de Contas        ",49)
   OPCAO(5,2," 2 - Ordenar Arquivos           ",50)
   OPCAO(6,2," 3 - Configurar Ordenacao       ",51)
   OPCAO(7,2," 4 - Refazer Controles          ",52)
   OPCAO(8,2," 5 - Configuracao Sistema       ",53)
   OPCAO(9,2," 6 - Recompor Contas            ",54)
   OPCAO(10,2," 7 - Configuracao Formularios   ",55)
   OPCAO(11,2," 8 - Reorganizar Estrutura      ",56)
   OPCAO(12,2," 9 - Alterar Lay-out Relatorios ",57)
   OPCAO(13,2," A - Atualizar Formularios/Tabel",65)
   OPCAO(14,2," B - Restricao de Contas        ",66)
   OPCAO(15,2," C - Criar Arquivo              ",67)
   OPCAO(16,2," D - Ajustar Codigos Fotos/Depto",68)
   OPCAO(17,2," E - Atualizar VT-TK            ",69)
   OPCAO(18,2," F - Atualizar VT-VB            ",70)
   KEY := MENU(,0)
   SETCOLOR("W/N,N/W")
   DO CASE
   CASE KEY = 1
      PADRAO("RELCONTA","RELCONTA","mCODIGO+' '+mNOME+' '","mCODIGO","Cadastro de Sequencia de Contas","Conta Descricao",;
       {|| PEGCHAVE("mCODIGO",SPACE(8),"Codigo:")},"FOY101","FOY101",,,4)
   CASE KEY = 2
      IF MDG("Modulo Principal Folha")
         FOY2(0,"FOLHANTX")
      ENDIF
      IF MDG("Modulo Lista Anuais")
         FOY2(0,"FOLISNTX")
      ENDIF
      IF MDG("Modulo Rescisao e Ferias")
         FOY2(0,"FORFENTX")
      ENDIF
      IF MDG("Modulo Ponto")
         FOY2(0,"FOPTONTX")
      ENDIF
      IF MDG("Modulo Recursos")
         FOY2(0,"RECURNTX")
      ENDIF
   CASE KEY = 3
      IF MDG("Modulo Principal Folha")
         FOY2(1,"FOLHANTX")
      ENDIF
      IF MDG("Modulo Lista Anuais")
         FOY2(1,"FOLISNTX")
      ENDIF
      IF MDG("Modulo Rescisao e Ferias")
         FOY2(1,"FORFENTX")
      ENDIF
      IF MDG("Modulo Ponto")
         FOY2(1,"FOPTONTX")
      ENDIF
      IF MDG("Modulo Recursos")
         FOY2(1,"RECURNTX")
      ENDIF
   CASE KEY = 4 
      FOY4()
   CASE KEY = 5 
      FOY5()
   CASE KEY = 6 
      FOY6()
   CASE KEY = 7
      PADRAO("REL2","REL2","mCODIGO","mCODIGO","Configuracao Relatorios","Codigo",;
       {|| PEGCHAVE("mCODIGO",SPACE(8),"Codigo:")},"REL201","REL201",{|| FO_FOR("GRUPO='CONFIG'")})
   CASE KEY = 8 
      FOY8()
   CASE KEY = 9 
      FOY9()
   CASE KEY = 10 
      FOYA()
   CASE KEY = 11 
      FOYB()
   CASE KEY = 12 
      FOYC()
   CASE KEY = 13 
      FOYD()
   CASE KEY = 14 
      VTATUTK(1)
   CASE KEY = 15 
      VTATUTK(2)
   OTHER 
      RETU
   ENDCASE
ENDDO


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOYC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION FOYC

CABEX('Criar Arquivo')
cARQ := SPACE(8)
MDS("Digite o Nome do Arquivo")
@ 24,40 GET cARQ         
IF !READCUR()
   RETU .F.
ENDIF
cARQ := ALLTRIM(cARQ)
IF !file(cARQ+".DBE")
   ALERTX("Falta Arquivo Dicionario: "+cARQ+".DBE")
   RETU .F.
ENDIF
IF MDG("Arquivo Individual da Empresa")
   HB_CWD(PATHX)
   // DIRCHANGE(PATHX)
   MAKEDBF("..\"+cARQ+".DBE")
   // DIRCHANGE('..')
   HB_CWD('..')
ELSE
   MAKEDBF(cARQ+".DBE")
ENDIF
RETURN .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOYB()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION FOYB

IF ZUSER <> "SUPERVISOR"
   ALERTX("Acesso Permitido Somente Para o Supervisor")
   RETU
ENDIF
IF MDG("Contas RPA")
   PADRAO("CTARPA","CTARPA","STR(mCODIGO)+' '+mDESCR+' '+mACEITE","mCODIGO","Cadastro de Bloqueio Contas","Conta"+spac(36)+"Travar",;
    {|| ALLTRUE()},"FO6TR1","FO6TR1",,,4)
ELSE
   PADRAO("CONTAS","CONTAS","STR(mCODIGO)+' '+mDESCR+' '+mACEITE","mCODIGO","Cadastro de Bloqueio Contas","Conta"+spac(36)+"Travar",;
    {|| ALLTRUE()},"FO6TR1","FO6TR1",,,4)
ENDIF
RETURN .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOY5()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION FOY5

CABEX("Alterando Configuracao Detalhes")
IF !netuse("CONFIGU",,.F.,,,.F.,)
   RETU
ENDIF
TELASAY("FOY501")
EDITSAY("FOY501")
DBGOTOP()
TEMPO    := TEMP
IM1      := IMPRE
DRI      := DRIVE
ZMOEDA01 := MOEDA01
ZMOEDA02 := MOEDA02
ZMOEDA03 := MOEDA03
ZMOEDA04 := MOEDA04
ZMOEDA05 := MOEDA05
ZMOEDA06 := MOEDA06
DBCLOSEALL()
RETURN .T.


// : FIM: FOY.PRG

*+ EOF: foy.prg
*+
