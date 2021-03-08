*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_af9.prg
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

MDI("Criar Arquivo BCN->COBSCAD.DBF")

CAMINHO := "\COBBCN\"+SPACE(40)
MDS("Digite o Caminho")
@ 24,30 GET CAMINHO         
IF !READCUR()
   RETU .F.
ENDIF

aLAYG1 := PEGLAY("MEXPOR1","MAF901")

FILTRO  := ''
FILTRO  := RFILORD("MA01",.F.)
CAMINHO := ALLTRIM(CAMINHO)+"COBSACAD"
IF ! file(CAMINHO+".DBF")
   ALERTX("N„o Encontrei Arquivo "+CAMINHO)
   RETU .F.
ENDIF
IF !USECHK(CAMINHO,,.T.)
   RETU .F.
ENDIF
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","CGC_CPF")
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
   mTPINSSAC := IF(PESSOA = "J",2,1)
   cCGCTEMP  := STRTRAN(STRTRAN(STRTRAN(CGC,"-",""),"/",""),".","")
   mCGCCPFS  := IF(PESSOA = "J",cCGCTEMP,"000"+cCGCTEMP)
   mENDERECO := LEFT(ENDERECO,40)
   mBAIRRO   := LEFT(BAIRRO,15)
   mCEP      := STRTRAN(CEP,"-","")
   mCIDADE   := LEFT(CIDADE,15)
   mUF       := ESTADO
   mDDD      := DDD
   mTELEFONE := STRTRAN(STRTRAN(STRTRAN(TELEFONE,"-",""),"/",""),".","")
   GRAVALAY(aLAY1,"COBSACAD",,.F.,mCGCCPFS,.T.)
   DBSELECTAR("MA01")
   DBSKIP()
ENDDO
DBCLOSEALL()
