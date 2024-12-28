// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bo.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


MDI( " þ MENU DE PEDIDOS " )
OPCAO( 6, 0, " &A - Relat¢rio de Horas Equipamentos ", 65,, {|| M_BO1( "E" ) } )
OPCAO( 7, 0, " &B - Relat¢rio de Horas Homens       ", 65,, {|| M_BO1( "H" ) } )
OPCAO( 8, 0, " &C - Relat¢rio de Horas Terceiros    ", 65,, {|| M_BO1( "T" ) } )
MENU(, 0 )

// + EOF: m_bo.prg
// +
