*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_am4.prg
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
// :   M_AM4  .PRG : Mensagens Corpo Nota Fiscal
// :   Linguagem   : Clipper 5.x
// :        Sistema: Manager 5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMAM4()
// :
// :    Chamado por:
// :
// :          Chama: fMAM4  (fun‡„o em M_AM4.PRG )
// :
// :  Arq. Dados   : MM04       - Mensagens Corpo Nota Fiscal
// :
// :  Indices      : MM04-1     - N£mero das Mensagens
// :                 NUMMENS
// :
// :
// :  Documentado em:  2, 1994 as 14:12:23                DISK!  vers„o 5.01
// :*****************************************************************************




//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_am4()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_am4

PARA cARQ
IF VALTYPE(cARQ) = "C"
   ARQWORK := cARQ
ENDIF

PADRAO(0,1,0,ARQWORK,"N£mero  Descri‡„o",;
 "' '+STR(mNUMMENS,  5)+' '+mDESMENS",;
 "MAM4",,,{|| ULTIMOREG(ARQWORK,"NUMMENS","mNUMMENS")})



