*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_bo.prg
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

MDI(" þ MENU DE PEDIDOS ")
OPCAO(6,0," &A - Relat¢rio de Horas Equipamentos ",65,,{|| M_BO1("E")})
OPCAO(7,0," &B - Relat¢rio de Horas Homens       ",65,,{|| M_BO1("H")})
OPCAO(8,0," &C - Relat¢rio de Horas Terceiros    ",65,,{|| M_BO1("T")})
MENU(,0)
