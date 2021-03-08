*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_as3.prg
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
// :   M_AS3  .PRG : Composicao do Produto
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMAS3()
// :
// :*****************************************************************************


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"



PADRAO(1,1,0,"MS03","Codigo   T Codigo"+spac(6)+"Componente"+spac(31)+"Qtdde",;
 "' '+mCODIGO+' '+mTIPOENT+' '+mCODCOMP+' '+mNOMECOMP+' '+STR(mQTDDE,8,4)",;
 "MAS3",,,{|| mCODIGO := xCODIGO},{|| PADARR("MS03",XCODIGO,"XCODIGO","CODIGO")})



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAS302()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAS302

IF EMPTY(mNOMECOMP)
   mNOMECOMP := OBTER(ESTQARQ(mTIPOENT,1),mCODCOMP,"NOME")
ENDIF
IF EMPTY(mPRECO)
   DO CASE
      CASE mTIPOENT $ "EHT" 
         mPRECO := OBTER(ESTQARQ(mTIPOENT,1),mCODCOMP,"VALOR")
      CASE mTIPOENT $ "MCS" 
         mPRECO := OBTER(ESTQARQ(mTIPOENT,1),mCODCOMP,"PRECUST")
      CASE mTIPOENT = "P" 
         mPRECO := OBTER("MS01",mCODCOMP,"CUSTF")
      CASE mTIPOENT = "O" 
         mPRECO := OBTER("MW05",mCODCOMP,"COTVAL")
      CASE mTIPOENT = "R" 
         mPRECO := OBTER("MW07",mCODCOMP,"COTVAL")
   ENDCASE
ENDIF
RETU .T.


