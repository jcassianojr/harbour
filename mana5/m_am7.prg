*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_am7.prg
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
*+    Function m_am7()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_am7

PARA cARQ

PADRAO(0,1,0,cARQ,"Req"+spac(6)+"Cliente"+spac(15)+"Produto"+spac(18)+"NF",;
 "' '+STR(mREQDEV,8)+' '+STR(mCLIENTE,8)+' '+mCOGCLI+' '+mPRODUTO+' '+STR(mNF,8)",;
 "MAM7",,,{|| ULTIMOREG(caRQ,"REQDEV","mREQDEV")})
