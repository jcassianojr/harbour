*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_cm.prg
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
// :   M_CM   .PRG : Mensagem do Sistema
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMCM()
// :
// :    Chamado por:
// :
// :          Chama: fMCM  (fun��o em M_CM.PRG )
// :
// :  Arq. Dados   : MMES       - Mensagem do Sistema
// :
// :  Indices      : MMES       - C�digo da Mensagem
// :                 CODIGO
// :
// :
// :  Documentado em: Junh 9, 1994 as 14:43:05                DISK!  vers�o 5.01
// :*****************************************************************************




//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
// #INCLUDE "MEMOGET.CH"



PADRAO(0,1,0,"MMES","Codigo Utilizacao",;
 "' '+mCODIGO+' '+mUSO","MCM","MCM001",{|| gMCM()})



//Get Nas Mvars

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMCM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gMCM

SETCOLOR(PAD002)
@  5,2 GET mCODIGO                                                      
@  8,2 GET mUSO                                                         
@ 11,2 GET mMENSAGEM                                                    
// @ 14,2 GET mDESCRICAO MEMO coord {15,09,21,72} boxcolor MCFN003         
READCUR()
mDESCRICAO := STRTRAN(mDESCRICAO,CHR(141)+CHR(10),CHR(13)+CHR(10))
RETU .T.

