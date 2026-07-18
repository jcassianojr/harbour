// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fogb.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :       FOGB.PRG:  RECRIA PLANILHA DE FALTAS OU HT
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 01/07/98
// :
// :*****************************************************************************


CABEX( 'Criar Planilha' )
MDS( 'AGUARDE CRIANDO NOVA PLANILHA' )

netzap( "FO_HOR" )

IF !NETUSE( PES )   // AREDE(PES,PES,1)
RETU
ENDIF
FILTRO := "EMPTY(DEMITIDO)"
SET FILTER TO &FILTRO

IF !netuse( "FO_HOR" )  // AREDE("FO_HOR","FO_HOR",0)
dbCloseAll()
RETU
ENDIF

dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
NUM := NUMERO
NOM := NOME
dbSelectAr( "FO_HOR" )
NETRECAPP()
FIELD->NUMERO := NUM
FIELD->NOME   := NOM
dbSelectAr( PES )
dbSkip()
ENDDO
RETU
// : FIM: FOGB.PRG

// + EOF: fogb.prg
// +
