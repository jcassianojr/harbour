// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_cx.prg
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
// :
// :   FORES_CX.PRG: Nome do Programa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      9:05
// :
// :  Procs & Fncts: FORES_CX()
// :
// :          Chama: ACUVAR()           (fun‡„o    em FORESP.PRG)
// :               : VALVAR()           (fun‡„o    em FORESP.PRG)
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************


MDS( 'Acumulando Salario Variavel 13§ Salario' )
MESINI := Month( INI13 )
MESFIM := Month( FIM13 )
ACUVAR( 'SAL_13=0', .F., .T. )
MESES := MESFIM - MESINI + 1
MDS( 'Aguarde Calculando a Media' )
NUM      := CTR
ANOATUAL := .F.
dbSelectAr( PES )
IF ( Year( ADMITIDO ) = ANO ) .AND. ( Month( ADMITIDO ) > 1 )
ANOATUAL := .T.
MESESA   := MESFIM - Month( ADMITIDO ) + 1
ENDIF
dbSelectAr( "FO_VAR" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF ANOATUAL
dbEval( {|| netgrvcam( "HORAS", HORAS / MESESA ) }, {|| NUMERO = NUM }, {|| zei_fort( nLASTREC,,, 1 ) } )
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netgrvcam( "VALOR", VALOR / MESESA ) }, {|| NUMERO = NUM }, {|| zei_fort( nLASTREC,,, 1 ) } )
ELSE
dbEval( {|| netgrvcam( "HORAS", HORAS / MESES ) }, {|| NUMERO = NUM }, {|| zei_fort( nLASTREC,,, 1 ) } )
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netgrvcam( "VALOR", VALOR / MESES ) }, {|| NUMERO = NUM }, {|| zei_fort( nLASTREC,,, 1 ) } )
ENDIF
dbSelectAr( "FO_VAR" )
MDS( 'Calculando Salario Variavel 13§ Sal rio' )
SALV13 := VALVAR( 'SAL_13=0' )
RETU
// : FIM: FORES_CX.PRG

// + EOF: fores_cx.prg
// +
