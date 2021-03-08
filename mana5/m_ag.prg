*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ag.prg
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
// :   M_AG   .PRG : Cadastro de Transportadoras
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMAG()
// :
// :    Chamado por:
// :
// :          Chama: fMAG  (fun‡„o em M_AG.PRG )
// :
// :  Arq. Dados   : MG01       - Cadastro de Transportadoras
// :
// :  Indices      : MG01-1     - Numero de Cadastramento
// :                 NUMERO
// :
// :
// :  Documentado em: Junh 6, 1994 as 11:16:48                DISK!  vers„o 5.01
// :*****************************************************************************


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

PRIV xNUMERO

PADRAX(0,,0,{"MG01","MG02","MG03"},"N£mero  Nome"+spac(38)+"Cognome"+spac(6)+"DDD  Telefone",;
 "' '+STRVAL(mNUMERO,8)+' '+mNOME+' '+mCOGNOME+' '+mDDD+' '+mTELEFONE","MAG001","MAG001",;
 {|| MAGEN2()},;
 {|| PADDEL("MG02",IF(VALTYPE(xNUMERO) = 'C',xNUMERO,STRVAL(xNUMERO,8)),"NUMERO","xCHAVE")},;
 {|| MAGREP()})


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAGEN2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAGEN2

IF !USEREDE("MG01",1,1)
   RETU .F.
ENDIF
DBGOTOP()
IF DBSEEK(mCHAVE)
   mTRANPORT  := mCHAVE
   mNOMETRANS := NOME
   mENDETRANS := ENDERECO
   mBAIRTRANS := BAIRRO
   mCIDATRANS := CIDADE
   mESTATRANS := ESTADO
   mCEPTRANS  := CEP
   mCHAPA     := CHAPA
   mCGCTRANS  := CGC
   mIETRANS   := INSCR
ENDIF
DBCLOSEAREA()
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAGREP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAGREP

IF MDG("Deseja Alterar Motoristas")
   xNUMERO := mNUMERO
   PADRAO(1,1,0,"MG02","No    Chapa    Motorista",;
    "' '+STRVAL(mNUMERO,8)+' '+STR(mCODEMP)+' '+mMOTORF",;
    "MAG2",,,{|| mNUMERO := xCHAVE},{|| PADARR("MG02",IF(VALTYPE(xNUMERO) = 'C',xNUMERO,STRVAL(xNUMERO,8)),"NUMERO","XNUMERO")})
ENDIF
IF MDG("Deseja Alterar Frotas")
   xNUMERO := mNUMERO
   PADRAO(1,1,0,"MG03","Tranp Codigo Frota Chapa    Cod Motoris. Modelo Ve¡culo",;
    "' '+STRVAL(mNUMERO,8)+' '+mCODFRO+' '+mCHAPAF+' '+mCODEMP+' '+mMODFRO",;
    "MAG3",,,{|| mNUMERO := xCHAVE},{|| PADARR("MG03",IF(VALTYPE(xNUMERO) = 'C',xNUMERO,STRVAL(xNUMERO,8)),"NUMERO","XNUMERO")})
ENDIF
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKIPVA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC CHECKIPVA(cCOD)

IF EMPTY(cCOD)
   RETU .T.
ENDIF
IF !USEREDE("MG04",1,1)
   RETU .F.
ENDIF
DBGOTOP()
DBSEEK(cCOD)
IF !FOUND()
   DBCLOSEAREA()
   RETU .F.
ENDIF
mPROFRO := IF(ORIGEM = "IMP","Importado","Nacional")
mTIPO   := TIPO
mTIPFRO := OBTER("MD02",PADR("TI2VEI",12)+PADR(STR(TIPO,1),12),"LEFT(DESCRICAO,20)")
mMARFRO := MARCA
mMODFRO := MODELO
DBCLOSEAREA()
RETU .T.
