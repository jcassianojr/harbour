// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foam.prg
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
// :
// :       FOAM.PRG: Ocorrencias Coletivas
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/08/94      8:59
// :
// :*****************************************************************************


CABEX( 'Cadastramento de Ocorrencias Coletivas' )

CRIARVARS( "FO_OCO" )
tFOAL( .F. )
gFOAL( .F. )
xFOAL( 1 )



IF !netuse( pes )   // AREDE(PES,PES,1)
RETU
ENDIF
FILTRO := ''
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO

IF !netuse( "FO_OCO" )  // AREDE("FO_OCO","FO_OCO",0)
dbCloseAll()
RETU
ENDIF

@ 08, 00 CLEA
MDS( 'Aguarde Cadastrando Dados' )
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 7 )
mDEPTO  := DEPTO
mSETOR  := SETOR
mSECAO  := SECAO
mCHAPA  := CHAPA
mNOMEF  := NOME
mNUMERO := NUMERO
mBUSCA  := Str( mNUMERO, 8 ) + DToS( mDATASAIDA )
dbSelectAr( "FO_OCO" )
IF !dbSeek( mBUSCA )
netrecapp()
REPLVARS()
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()


// : FIM: FOAM.PRG

// + EOF: foam.prg
// +
