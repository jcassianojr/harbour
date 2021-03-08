*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_cr.prg
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

IF MDG("Revisar Roteiro")
   PADRAO(0,1,0,"MANATU","Origem   Destino","' '+mARQUIVO1+' '+mARQUIVO2","MCR")
ENDIF

IF !USEREDE("MANATU",1,1)
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   ATUALIZA(ALLTRIM(ARQUIVO1),ALLTRIM(ARQUIVO2))
   DBSELECTAR("MANATU")
   DBSKIP()
ENDDO
DBCLOSEALL()




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ATUALIZA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC ATUALIZA(xARQUIVO1,xARQUIVO2,lAPAGA)

IF VALTYPE(lAPAGA) # "L"
   lAPAGA := .T.
ENDIF
IF ! file(xARQUIVO1+".DBF")
   RETU .F.
ENDIF
IF !USECHK(xARQUIVO1,,.T.)
   RETU .F.
ENDIF
IF !USEREDE(xARQUIVO2,1,99)
   DBCLOSEALL()
   RETU .F.
ENDIF
DBSETORDER(1)
xBUSCA := INDEXKEY()




MDS("Aguarde Atualizando")
DBSELECTAR(xARQUIVO1)
INITVARS()
CLRVARS()
DBSELECTAR(xARQUIVO2)
INITVARS()
CLRVARS()
DBSELECTAR(xARQUIVO1)
nLASTREC := lastrec()
zei_fort(nLASTREC,,,0)
DBGOTOP()
WHILE !EOF()
   EQUVARS()
   NOVOOPE(xARQUIVO2,&xBUSCA.)
   DBSELECTAR(xARQUIVO1)
   DBSKIP()
   ZEI_FORT(nLASTREC,,,1)
ENDDO
FREEVARS()
DBSELECTAR(xARQUIVO1)
DBCLOSEAREA()
DBSELECTAR(xARQUIVO2)
DBCLOSEAREA()
IF lAPAGA
   FERASE(xARQUIVO1+".DBF")
   FERASE(xARQUIVO1+".DBT")
ENDIF
RETURN .T.
