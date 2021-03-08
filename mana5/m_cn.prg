*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_cn.prg
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
// :   M_CN   .PRG : Grupo de Relat¢rios
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMCN()
// :
// :    Chamado por:
// :
// :          Chama: fMCN  (fun‡„o em M_CN.PRG )
// :
// :  Arq. Dados   : MANREG     - Grupo de Relat¢rios
// :
// :  Indices      : MANREG-1   - Posi‡„o
// :                 POSICAO
// :
// :
// :  Documentado em: Junh 14, 1994 as 10:40:19                DISK!  vers„o 5.01
// :*****************************************************************************


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

PADRAX(0,,0,{"MANREG","MANREL","MANRE1"},"Posi‡„o Grupo Descri‡„o",;
 "' '+STR(mPOSICAO,  2)+' '+mGRUPO+' '+mDESCRICAO","MCN001","MCN001",;
 ,,{|| MCNREP()})


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MCNREP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MCNREP

IF mdg("Deseja Ver Configura‡„o de Lay-out")
   IF mdg("Relatorios Especificos")
      ARQREL := "MANREL"
      ARQRE1 := "MANRE1"
   ELSE
      ARQREL := "PADREL"
      ARQRE1 := "PADRE1"
   ENDIF
   mMENU  := mGRUPO
   mMENU1 := mGRUPO
   M_CN2(1)
ENDIF
RETU .T.

