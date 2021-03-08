*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_a1.prg
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

// :*****************************************************************************
// :
// :   M_A1   .PRG : Contratos
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :*****************************************************************************

//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"


PRIV xNUMERO,xDATA,xCLIENTE,xDATABASE,xDIA_VENC,xVENCIMENT,xREAJ


PADRAX(0,,0,{"M101","M102"},"N£mero   Data     Cliente"+spac(12)+"DataBase D  T  R Total"+spac(8)+"VENCIMENTO",;
 "' '+STR(mNUMERO,  8)+' '+DTOC(mDATA)+' '+STR(mCLIENTE,  5)+' '+mCOGNOME+' '+DTOC(mDATABASE)+' '+STR(mDIA_VENC,  2)+' '+STR(mDURACAO,  2)+' '+mREAJ+' '+STR(mTOTNF, 12, 2)+' '+DTOC(mVENCIMENTO)","MA1001","MA1001",;
 ,{|| PADDEL("M102",STR(xCHAVE,8),"NUMERO","xCHAVE")},,{|| mNUMERO := ULTIMOREG("M101","NUMERO","mNUMERO")},;
 "MA1",,,,,{|| MA1IGU()})




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MA1IGU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MA1IGU

//Poupa Variaveis
xNUMERO    := mNUMERO
xDATA      := mDATA
xCLIENTE   := mCLIENTE
xDATABASE  := mDATABASE
xDIA_VENC  := mDIA_VENC
xVENCIMENT := mVENCIMENT
xREAJ      := mREAJ
IF mdg("Deseja Alterar Itens do Contrato")
   M_A12(1)
ENDIF
RETU .T.





*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MA101()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MA101()

mVENCIMENTO := ADDMONTH(mDATA,mDURACAO)
@ 10,28 SAY mVENCIMENT         
RETU .T.

