*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_afa.prg
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

MDI("Criar Arquivo Sudameris->CLIENTES.DBF")
CAMINHO := ProfileString( "MANA5.INI", "PATH", "COBSUDA",HB_CWD()+"\COBSUDA" )+SPACE(40)//

//CAMINHO := "\COBSUDA\"+SPACE(40)
MDS("Digite o Caminho")
@ 24,30 GET CAMINHO         
IF !READCUR()
   RETU .F.
ENDIF

aLAYG1 := PEGLAY("MEXPOR1","MAFA01")

FILTRO  := ''
FILTRO  := RFILORD("MA01",.F.)
CAMINHO := ALLTRIM(CAMINHO)+"CLIENTES"
IF ! file(CAMINHO+".DBF")
   ALERTX("Nao Encontrei Arquivo "+CAMINHO)
   RETU .F.
ENDIF
IF !USECHK(CAMINHO,,.T.)
   RETU .F.
ENDIF

nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","CPF_CGC")
ordSetFocus("temp")

IF !USEREDE("MA01",1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
IF !EMPTY(FILTRO)
   SET FILTER TO &FILTRO
ENDIF
DBGOTOP()
WHILE !EOF()
   mNOMESAC  := LEFT(NOME,40)
   mTPINSSAC := IF(PESSOA = "J","02","01")
   cCGCTEMP  := CGC
   mCGCCPFS  := IF(PESSOA = "J",cCGCTEMP,"000"+ALLTRIM(cCGCTEMP))
   mENDERECO := LEFT(ENDERECO,40)
   mCEP      := STRTRAN(CEP,"-","")
   mCIDADE   := LEFT(CIDADE,15)
   mUF       := ESTADO
   GRAVALAY(aLAY1,"CLIENTES",,.F.,mCGCCPFS,.T.)
   DBSELECTAR("MA01")
   DBSKIP()
ENDDO
DBCLOSEALL()

