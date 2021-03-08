*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_cb2.prg
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
// :   M_CB2  .PRG : Arquivo de Configura‡„o de Indexa‡„o
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMCB2()
// :
// :    Chamado por:
// :
// :          Chama: fMCB2  (fun‡„o em M_CB2.PRG )
// :
// :  Arq. Dados   : MANARQ1    - Arquivo de Configura‡„o de Indexa‡„o
// :
// :  Indices      : MANARQ1    - Arquivo e N£mero da Indexa‡„o
// :                 ARQUIVO+STR(ITEM,2)
// :
// :
// :  Documentado em: Mai 23, 1994 as 09:46:28                DISK!  vers„o 5.01
// :*****************************************************************************

#INCLUDE "INKEY.CH"


PADRAO(1,1,0,ZARQ1,"Arquivo  I. Indice   Descri‡„o",;
 "' '+mARQUIVO+' '+STR(mITEM,2)+' '+mINDICE+' '+mDESC",;
 "MCB2","MCB201","MCB201",{|| MCB2INS()} ;
 ,{|| PADARR(ZARQ1,mARQUIVO,"ARQUIVO","mARQUIVO")},;
 {| nKEY,nPOS | MCB2TEC(nKEY,nPOS)},,,.F.)




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MCB2TEC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MCB2TEC(nKEY,nPOS)

IF nKEY = K_ALT_ENTER
   mITEM := VAL(SUBSTR(aPAD2[nPOS],9,2))
   M_DB("ARQUIVO=mARQUIVO.AND.ITEM=mITEM")
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MCB2INS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MCB2INS

mITEM := LEN(aPAD1)
mITEM ++
RETU .T.




