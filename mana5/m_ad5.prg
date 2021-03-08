*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ad5.prg
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
// :   M_AD5  .PRG : Al¡quotas Estaduais de ICMS
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :*****************************************************************************





//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_ad5()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function M_ad5

PARA wMAD5
xUF := "  "


PADRAX(wMAD5,,0,{"MD05","MD10"},"UF Z   %     %R  Estado"+spac(15)+"Capital",;
 "mUFICMS+' '+mZONAFRANCA+' '+STR(mALIQUOTA,  5, 2)+' '+STR(mALIQUOTAR,  5, 2)+' '+mNOMEEXT+' '+mCAPITAL+' '+mINICEP+' '+mFIMCEP","MAD501","MAD501",;
 {|| MAD5REP(.T.)},,{|| MAD5REP(.F.)})



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAD5REP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAD5REP(lPERG)

IF lPERG .OR. mdg("Deseja Alterar Cadastro de Cidades")
   mUF := mUFICMS
   xUF := mUFICMS
   PADRAO(1,1,0,"MD10","UF Nome"+spac(32)+"DDD    Faixa de CEPs     Feriado",;
    "' '+mUF+' '+mNOME+' '+mDDD+' '+mINICEP+' '+mFIMCEP+' '+DTOC(mFERIADO)",;
    "MADA",,,{|| mUF := xUF},{|| PADARR("MD10",XUF,"UF","XUF",1)})
ENDIF
RETU .T.
