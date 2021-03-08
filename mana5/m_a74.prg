*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_a74.prg
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

MDI("Copia de Nota Fiscal")
xNUMERO := 0
yNUMERO := 0
ULTIMOREG("MM01","NUMERO","yNUMERO")
MDS("Digite a Nota Origem/Destino")
@ 24,40 GET xNUMERO pict "99999999"        
@ 24,50 GET yNUMERO pict "99999999"        
IF !READCUR()
   RETU .F.
ENDIF
lATUAL := MDG("Nota Origem Mes Atual")

if !lATUAL
   cANO    := MESANO()
   ARQWORK := "M1"+cANO
   ARQWOR2 := "M2"+cANO
endif



IF VERSEHA("MM01",yNUMERO)
   ALERTX("Nota destino j  cadastrada")
   RETU .F.
ENDIF
IF !VERSEHA(IF(lATUAL,"MM01",ARQWORK),xNUMERO)
   ALERTX("Nota Origem n„o cadastrada")
   RETU .F.
ENDIF
CRIARVARS("MM01")
CRIARVARS("MM02")
IF lATUAL
   IF !USEMULT({{"MM01",1,99},{"MM02",1,99}})
      RETU .F.
   ENDIF
   ARQWORK := "MM01"
   ARQWOR2 := "MM02"
ELSE
   IF !USEMULT({{"MM01",1,99},{"MM02",1,99},{ARQWORK,1,99},{ARQWOR2,1,99}})
      RETU .F.
   ENDIF
ENDIF
DBSELECTAR(ARQWORK)
DBGOTOP()
IF DBSEEK(xNUMERO)
   EQUVARS()
   mNUMERO := yNUMERO   //Ajusta nota destino
   netgrvcam("COPIA",yNUMERO)
   DBSELECTAR("MM01")
   NOVOOPA(,.F.)
   netgrvcam("COPIA",xNUMERO)
   DBSELECTAR(ARQWOR2)
   DBGOTOP()
   DBSEEK(STR(xNUMERO,8))
   WHILE NUMERO = xNUMERO .AND. !EOF()
      nREC := RECNO()
      EQUVARS()
      mNUMERO := yNUMERO  //Ajusta nota destino
      DBSELECTAR("MM02")
      NOVOOPA()
      DBSELECTAR(ARQWOR2)
      DBGOTO(nREC)
      DBSKIP()
   ENDDO
ENDIF
DBCLOSEALL()
