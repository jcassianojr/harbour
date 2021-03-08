*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_as5.prg
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
// :   M_AS5  .PRG : Cadastro de Pecas Similares
// :   Linguagem   : Clipper 5.x
// :        Sistema: DISNAUTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994, Disk Soft S/C Ltda.
// :
// :  Procs & Fncts: fMS5()
// :
// :    Chamado por:
// :
// :          Chama: fMS5  (fun‡„o em M_AS2.PRG )
// :
// :  Arq. Dados   : MS05"       - Movimenta‡„o de Estoque
// :
// :
// :
// :  Documentado em: Junh 13, 1994 as 10:21:37                DISK!  vers„o 5.01
// :*****************************************************************************

#INCLUDE "BOX.CH"

PADRAO(0,1,0,"MS05","Este Codigo    Igual ao Codigo",;
 "' '+mDOCODIGO+'      '+mCODIGO",;
 "MAS5",{|| tMAS5()},{|| gMAS5()})

//Tela de Dados

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tMAS5()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC tMAS5

SETCOLOR(MS5007)
HB_DISPBOX(2,0,23,79,B_DOUBLE)
@ 03,2 SAY "Este Codigo       Igual ao Codigo"         
SETCOLOR(MS5005)
@  4,2  SAY mDOCODIGO         
@  4,20 SAY mCODIGO           
RETU .T.

//Get Nas Mvars

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMAS5()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gMAS5

SETCOLOR(MS5002)
@  4,2  GET mDOCODIGO         
@  4,20 GET mCODIGO           
READCUR()
RETU .T.

