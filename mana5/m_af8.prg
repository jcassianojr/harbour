*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_af8.prg
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

MDI("Criar Arquivo Banco do Brasil->BBSAC.DBF")
//CAMINHO := "\BBCBR\DADOS\"+SPACE(40)
CAMINHO := ProfileString( "MANA5.INI", "PATH", "BBCBR",HB_CWD()+"\BBCBR\DADOS\" )+SPACE(40)//

MDS("Digite o Caminho")
@ 24,30 GET CAMINHO         
IF !READCUR()
   RETU .F.
ENDIF

aLAYG1 := PEGLAY("MEXPOR1","MAF801")

FILTRO  := ''
FILTRO  := RFILORD("MA01",.F.)
CAMINHO := ALLTRIM(CAMINHO)+"BBSAC"
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
ordcreate(,"temp","NR_INS_SAC")
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
   mNOMESAC  := LEFT(NOME,37)
   mTPINSSAC := IF(PESSOA = "J","02","01")
   cCGCTEMP  := STRTRAN(STRTRAN(STRTRAN(CGC3,"-",""),"/",""),".","")
   mCGCCPFS  := IF(PESSOA = "J",cCGCTEMP,"000"+cCGCTEMP)
   mENDERECO := LEFT(ENDERECO3,37)
   mBAIRRO   := LEFT(BAIRRO3,12)
   mCEP      := STRTRAN(CEP3,"-","")
   mCIDADE   := LEFT(CIDADE3,15)
   mUF       := ESTADO3
   GRAVALAY(aLAY1,"BBSAC",,.F.,mCGCCPFS,.T.)
   DBSELECTAR("MA01")
   DBSKIP()
ENDDO
DBCLOSEALL()
ALERTX("N„o se esque‡a de Reordenar Arquivos no Programa do BANCO DO BRASIL")
