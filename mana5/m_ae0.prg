*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ae0.prg
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

//#INCLUDE "COMANDO.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC M_AE

PRIV xNUMERO

PADRAX(0,,0,{"ME01","ME02"},"N£mero   M quina/Equipamento/Aparelho"+spac(10)+"Cad. Invent rio",;
 "' '+mNUMERO+' '+mNOME+' '+mCONTABIL","MAE001","MAE001",;
 ,{|| PADDEL("ME02",xCHAVE,"NUMERO","xCHAVE")},{|| MAE01()},,"MAE")




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAE01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAE01

IF MDG("Checar Sequencia de Distribuicao de Horas")
   xNUMERO := mNUMERO
   PADRAO(1,1,0,"ME02","Maq  Seq Codigo Mao de Obra",;
    "' '+mNUMERO+' '+STR(mSEQ,  3)+' '+mCODMP01+' '+mNOMMP01",;
    "MAE2","MAE201","MAE201",;
    {|| mNUMERO := xNUMERO},{|| PADARR("ME02",xNUMERO,"NUMERO","xNUMERO")})
ENDIF
IF MDG("Checar Escala da Maquina")
   xNUMERO := mNUMERO
   PADRAO(1,1,0,"ME03","Maq  Data     Inic. Saida Saldo",;
    "' '+mNUMERO+' '+DTOC(mDATA)+' '+STR(mESTQINI,5,2)+' '+STR(mESTQSAI,5,2)+' '+STR(mESTQSAL,5,2)",;
    "MAE30","MAE301","MAE301",;
    {|| mNUMERO := xNUMERO},{|| PADARR("ME03",xNUMERO,"NUMERO","xNUMERO")})
ENDIF
IF MDG("Checar Resultado da Escala da Maquina")
   xNUMERO := mNUMERO
   PADRAO(1,1,0,"ME03A","Maq  Data     OF"+spac(7)+"QTDDE Cod Operacao T",;
    "' '+mNUMERO+' '+DTOC(mDATA)+' '+STR(mOF,  8, 2)+' '+STR(mQTDDE,  5, 2)+' '+mCODMP01+' '+mCODRES",;
    "MAE3A","MAE3A1","MAE3A1",;
    {|| mNUMERO := xNUMERO},{|| PADARR("ME03A",xNUMERO,"NUMERO","xNUMERO")})
ENDIF
RETU .T.

