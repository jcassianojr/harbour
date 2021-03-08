*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aosb.prg
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


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_aosb()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_aosb

PARA nTIPO

ARQWORK1 := "MOSB01"
ARQWORK2 := "MOSB02"
nREF     := 2

IF nTIPO = 2
   cVAR     := MESANO()
   ARQWORK1 := "O3"+cVAR
   ARQWORK2 := "O4"+cVAR
ENDIF

xCODIGO := SPACE(24)

PADRAX(0,,0,{ARQWORK1,ARQWORK2},"Numero   Data Fornecedor",;
 "' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mFORNECEDO)+' '+mCOGNOME","MOSB01","MOSB01",;
 ,{|| PADDEL(ARQWORK2,str(xCHAVE,8),"NUMERO","xCHAVE")},;
 {|| MOSBREP()},{|| mNUMERO := ULTIMOREG(ARQWORK1,"NUMERO","mNUMERO")})



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MOSBREP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MOSBREP()

xNUMERO := mNUMERO
PADRAO(1,1,0,ARQWORK2,"  Item  Qtde   C¢digo"+spac(6)+"Nome"+spac(20)+"Pre‡o Un.",;
 "' '+STR(mSEQ,2)+' '+STR(mQTDE,10,3)+' '+LEFT(mCODIGO,10)+' '+LEFT(mNOME,10)+' '+STR(mPRECO,16,2)",;
 "MOSB02","MOSB02","MOSB02",{|| MOSBINC02()},{|| PADARR(ARQWORK2,str(xNUMERO,8),"STR(xNUMERO,8)","STR(NUMERO,8)")},,)
//        ;  {|| xCODIGO:=mCODIGO})
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MOSBINC02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MOSBINC02

mNUMERO := xNUMERO
ULTIMOITEM(ARQWORK2,str(xNUMERO,8),"NUMERO","XNUMERO","SEQ","mSEQ",.T.)
IF MSEQ > 5
   ALERTX("Somente 5 Itens")
   RETU .F.
ENDIF
retu .t.
