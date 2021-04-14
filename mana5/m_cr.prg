*+--------------------------------------------------------------------
*+
*+    Programa  : m_cr.prg
*+
*+    Sistema   : MANA5
*+
*+    Linguagem : Harbour
*+
*+    Copyright (c) 2021, Jorge Cassiano
*+
*+    Documentado em 15/04/2021
*+
*+--------------------------------------------------------------------
*+

IF MDG("Revisar Roteiro")
   PADRAO(0,1,0,"MANATU","Origem   Destino Indice","' '+mARQUIVO1+' '+mARQUIVO2+' '+STRZERO(mINDICE,2)","MCR")
ENDIF

IF !USEREDE("MANATU",1,1)
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   ATUALIZA(ALLTRIM(ARQUIVO1),ALLTRIM(ARQUIVO2),,INDICE)
   DBSELECTAR("MANATU")
   DBSKIP()
ENDDO
DBCLOSEALL()




*+--------------------------------------------------------------------
*+
*+    Function ATUALIZA(cORIGEM,cDESTINO,lAPAGAORIGEM,nINDICE)
*+
*+--------------------------------------------------------------------
*+
FUNCTION ATUALIZA(xARQUIVO1,xARQUIVO2,lAPAGA,nIND)

IF VALTYPE(lAPAGA) # "L" 
   lAPAGA := .T.
ENDIF
IF VALTYPE(nIND)<>"N" 
   nIND:=1
ENDIF   
IF nIND=0
   nIND:=1
ENDIF

IF ! file(xARQUIVO1+".DBF")
   RETURN .F.
ENDIF
IF ! USECHK(xARQUIVO1,,.T.)
   RETURN .F.
ENDIF
IF ! USEREDE(xARQUIVO2,1,99)
   DBCLOSEALL()
   RETURN .F.
ENDIF
DBSETORDER(nIND)
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
   IF ! NOVOOPE(xARQUIVO2,&xBUSCA.) 
      dbgotop()
      IF DBSEEK(&xBUSCA.)
	     dbrlock()
         REPLVARS( .T. , .T.) //Se nao incluir grava os campos em branco
		 dbunlock()
		 IF xARQUIVO2="MF01" .AND. EMPTY(FIELD->BANCO) .AND. LEFT(FIELD->NUMERO,1)<>"M" //mantendo codigo banco
		     dbrlock()
			 FIELD->BANCO:=VAL(FIELD->NUMERO) //antes eram so numero agora tem banco comecando com M
			 dbunlock()
		 ENDIF
	  ENDIF
   ENDIF
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
