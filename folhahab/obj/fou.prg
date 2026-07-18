// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fou.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :        FOU.PRG: Menu Experiencia Admissao Demissao
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1997,  jcassiano  S/C Ltda.
// :  Atualizado em: 02/10/97
// :
// :*****************************************************************************

IMPHP()

Set( _SET_MESSAGE, 23, .T. )
WHILE .T.
CABEX( 'Experiencia / Admissao / Demissao' )
MD()
@ 09, 03 PROM '1>Controle de Experiencia             '
@ 10, 03 PROM '2>Controle de Experiencia-Listagem    '
@ 11, 03 PROM '3>Controle de Experiencia-Contrato    '
@ 13, 03 PROM '4>Termo de Responsabilidade           '
@ 14, 03 PROM '5>Cadastro Adm/Dem CAGED              '
@ 15, 03 PROM '6>Opcao de FGTS                       '
@ 16, 03 PROM '7>Requerimento Seguro Desemprego - SD '
@ 18, 03 PROM '8>Outros Formul rio de ADM/DEM        '
MENU TO OPCAO
DO CASE
CASE OPCAO = 1
FOUE()
CASE OPCAO = 2
FOUEC()
CASE OPCAO = 3
FOUEF()
CASE OPCAO = 4
FOUC1()
CASE OPCAO = 5
FOUC2()
CASE OPCAO = 6
FOUC3()
CASE OPCAO = 7
FOUG()
CASE OPCAO = 8
FO_FOR( "GRUPO='ADMDEM'" )
OTHERWISE
RETU
ENDCASE
ENDDO
// : FIM: FOU.PRG

// + EOF: fou.prg
// +
