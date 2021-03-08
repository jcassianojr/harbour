*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_dd.prg
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
// :   M_DD   .PRG : Arquivo de Cartas
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMDD()
// :
// :    Chamado por: MANA
// :
// :          Chama: fMDD  (fun‡„o em M_DD.PRG )
// :
// :  Arq. Dados   : MCARTA     - Arquivo de Cartas
// :
// :  Indices      : MCARTA     - Arquivo de Cartas
// :                 ARQUIVO
// :
// :
// :  Documentado em: Junho 6, 1994 as 10:39                DISK!  vers„o 5.01
// :*****************************************************************************


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
//#INCLUDE "FILEGET.CH"



PADRAO(0,1,0,"MCARTA","Arquivo Descri‡„o",;
 "' '+mARQUIVO+' '+mNOME",;
 "MDD","MDD001",{|| gMDD()})



//Get Nas Mvars

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMDD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gMDD

SETCOLOR(PAD002)
@  4,1  GET mARQUIVO //FILE CAMINHO ZDIRP+"TXT\" EXTENSAO "TXT" IMPSETUP {mSETUP,mMARLIN,mMARINF,mMARSUP,mMARESQ,mMARDIR,mMARCOL,.F.}                      
@  4,15 GET mNOME                                                                                                                                        
@  7,45 GET mMARESQ                                                                                                                 PICTURE '99'         
@  8,45 GET mMARDIR                                                                                                                 PICTURE '99'         
@  9,45 GET mMARSUP                                                                                                                 PICTURE '99'         
@ 10,45 GET mMARINF                                                                                                                 PICTURE '99'         
@ 13,45 GET mMARLIN                                                                                                                 PICTURE '99'         
@ 14,45 GET mMARCOL                                                                                                                 PICTURE '999'        
@ 17,45 GET mSETUP                                                                                                                                       
READCUR()
RETU .T.

