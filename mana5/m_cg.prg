*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_cg.prg
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
// :       M_CG.PRG: Ajustar data e Hora do Sistema
// :      Linguagem: Clipper 5.x
// :
// :        Sistema: Manager Vers„o 5  Cl-52E,RATM
// :         Autor : Equipe Softec Sistemas
// :      Copyright (c) 1995, Softec Sistemas S/C Ltda.
// :  Atualizado  : 21/09/95      7:52
// :
// :      Documentado 21/09/95 at 07:58                Softec!
// :*****************************************************************************

//Preparando o Help
HELPDBF := "MCG"

MDI(" Ý Ajustando data e Hora do Sistema")


TIME := TIME()
DATA := DATE()

TELASAY("MCG001")
EDITSAY("MCG001")


//SETTIME(TIME,ISAT())
//SETDATE(DATA,ISAT())

SETTIME(TIME)
SETDATE(DATA)

RETU .T.

// : FIM: M_CG.PRG
