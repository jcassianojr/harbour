*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_af6.prg
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

MDI("Criar Arquivo Itau->DBSAC.DBF")
CAMINHO := "\ITAUSIG\"+SPACE(40)
MDS("Digite o Caminho")
@ 24,30 GET CAMINHO         
IF !READCUR()
   RETU .F.
ENDIF
CAMINHO := ALLTRIM(CAMINHO)+"DBSAC"
IF ! file(CAMINHO+".DBF")
   ALERTX("N„o Encontrei Arquivo "+CAMINHO)
   RETU .F.
ENDIF


aLAYG := PEGLAY("MEXPOR1","MAF601")

FILTRO  := ''
FILTRO  := RFILORD("MA01",.F.)
IF !USECHK(CAMINHO,,.T.)
   RETU .F.
ENDIF
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","CODSAC")
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
   mCODSAC   := STR(NUMERO,8)
   mNOMESAC  := LEFT(NOME,30)
   mTPINSSAC := IF(PESSOA = "J","02","01")
   cCGCTEMP  := STRTRAN(STRTRAN(STRTRAN(CGC,"-",""),"/",""),".","")
   mCGCCPFS  := IF(PESSOA = "J",cCGCTEMP,"000"+cCGCTEMP)
   mENDERECO := LEFT(ENDERECO2,40)
   mBAIRRO   := LEFT(BAIRRO2,12)
   mCEP      := STRTRAN(CEP2,"-","")
   mCIDADE   := LEFT(CIDADE2,15)
   mUF       := ESTADO2
   GRAVALAY(aLAYG,"DBSAC",,.F.,mCODSAC,.T.)
   DBSELECTAR("MA01")
   DBSKIP()
ENDDO
DBCLOSEALL()

