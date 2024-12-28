// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_a1.prg
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :  FORES_A1.PRG : Remanejamento de F‚rias
// :     Linguagem : Clipper 5.2e
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      8:56
// :
// :*****************************************************************************



CABE2( 'Remanejamento de F‚rias' )
CTR := 0
MDS( 'Digite o n£mero do Funcion rio:' )
@ 24, 40 GET CTR PICT '######'
READCUR()
IF !netuse( pes )
RETU
ENDIF
dbGoTop()
IF !dbSeek( CTR )
MDT( 'Funcion rio nao encontrado !!!' )
dbCloseAll()
RETU
ENDIF
PETELA( 8 )
dbCloseAll()


VERIFICA := MDG( 'Revisar Periodo ja  baixados' )

IF !netuse( "fo_fer" )
RETU
ENDIF
dbGoTop()
dbSeek( CTR * 100000000 )
WHILE CTR = NUMERO .AND. !Eof()
IF !VERIFICA
IF BAIXADO = "S"
dbSkip()
LOOP
ENDIF
ENDIF
FORESRT()
FORESRS()
MDS( "Deseja alterar este periodo" )
OPCAO( 24, 40, ' &Sim ', 83 )
OPCAO( 24, 50, ' &N„o ', 78 )
KEY := MENU( 2, 0 )
IF KEY = 1
FORESRG()
ENDIF
dbSkip()
ENDDO
dbCloseAll()


// : FIM: FORES_A1.PRG

// + EOF: fores_a1.prg
// +
