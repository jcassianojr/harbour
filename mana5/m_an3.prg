*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_an3.prg
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
// :   M_AN3  .PRG : Cadastro de Cheques
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Softec
// :      Copyright (c)  1996, Softec Sistemas S/C Ltda.
// :
// :  Procs & Fncts: fMAN3()
// :
// :    Chamado por: M_AN0/M_AL0
// :
// :          Chama: fMAN3  (fun‡„o em M_AN3.PRG )
// :
// :  Arq. Dados   : MN03/ML03/MN03PG/ML03PG/N3AAMM/L3AAMM  - Cadastro de Cheques
// :
// :  Indices      : ARQUIVO-1     -
// :                 STR(NRNOTA)+TIPFAT
// :
// :
// :  Documentado em: Novembro 25, 1996 as 12:04:54
// :*****************************************************************************


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_an3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_an3

PARA cARQ
IF VALTYPE(cARQ) = "C"
   ARQWORK := cARQ
ENDIF


PADRAX(0,,0,{ARQWORK},"Nr.Nota  T Ban Agencia Conta"+spac(8)+"Data     Valor"+spac(14)+"Depositado",;
 "' '+STR(mNRNOTA,  8)+' '+mTIPFAT+' '+STR(mBANCO,  3)+' '+mAGENCIA+' '+mCONTA+' '+DTOC(mDATA)+' '+STR(mVALOR, 18, 2)+' '+DTOC(mDATADEP)",;
 "MAN301","MAN301",,,{|| MAN301()},"MAN301")



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAN301()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAN301

IF !EMPTY(mDATADEP) .AND. (ARQWORK == "MN03" .OR. ARQWORK == "ML03")  //Baixa
   NOVOREG(ARQWORK+"PG",mCHAVE)
   aPAX1[POSPAX] = "Transferido Cheques Pagos"
   aPAX2[POSPAX] = ""
   APAGAREG(ARQWORK,mCHAVE,.F.)
ENDIF
RETU .T.
