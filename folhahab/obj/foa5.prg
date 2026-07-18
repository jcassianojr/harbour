// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foa5.prg
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
// :       FOA5.PRG: Entrada de Dados Vale Transporte
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 23/12/98     11:29
// :
// :*****************************************************************************


CABEX( 'Progama‡„o de Vale Transporte' )
mNUMERO := mCONTA := mCTACOM := mHORAS := 0
PCK     := .F.

IF !NETUSE( PES )   // AREDE(PES,PES,1)
RETU
ENDIF

IF !NETUSE( "VTFIXO" )  // AREDE("VTFIXO","VTFIXO",0)
RETU
ENDIF

IF !NETUSE( "VTCONTA" )   // AREDE("VTCONTA","VTCONTA",1)
RETU
ENDIF

IF !NETUSE( "VTCOMP" )  // AREDE("VTCOMP","VTCOMP",1)
RETU
ENDIF

WHILE .T.
@ 17, 00 CLEA
@ 17, 00 SAY "ESC ou funcionario em Branco Encerra"
@ 18, 00 SAY "Digite o Codigo do Funcionario"
@ 19, 00 SAY "Digite a Codigo do VT"
@ 20, 00 SAY "Digite o Codigo Composto"
@ 21, 00 SAY "Quantos Vale Transporte"
@ 18, 40 GET mNUMERO                                PICT "9999999"
@ 19, 40 GET mCONTA                                 PICT "9999"
@ 20, 40 GET mCTACOM                                PICT "9999"
@ 21, 40 GET mHORAS                                 PICT "999"
IF !READCUR()
EXIT
ENDIF
IF Empty( mNUMERO )
EXIT
ENDIF
IF Empty( mCONTA ) .AND. Empty( mCTACOM )
ALERTX( "Preencha o codigo VT ou Codigo Composto" )
LOOP
ENDIF
IF !Empty( mCONTA ) .AND. !Empty( mCTACOM )
ALERTX( "Preencha apenas o codigo VT ou Codigo Composto" )
LOOP
ENDIF
dbSelectAr( PES )
dbGoTop()
IF !dbSeek( mNUMERO )
ALERTX( 'Funcion rio N„o encontrado' )
LOOP
ENDIF
PETELA( 10 )
IF !Empty( mCONTA )
dbSelectAr( "VTCONTA" )
dbGoTop()
IF !dbSeek( mCONTA )
ALERTX( 'Conta VT n„o encontrada' )
LOOP
ENDIF
ENDIF
IF !Empty( mCTACOM )
dbSelectAr( "VTCOMP" )
dbGoTop()
IF !dbSeek( mCTACOM )
ALERTX( 'Composi‡„o de Passagem n„o encontrada' )
LOOP
ENDIF
ENDIF
dbSelectAr( "VTFIXO" )
dbGoTop()
IF !dbSeek( Str( mNUMERO, 8 ) + Str( mCONTA, 4 ) + Str( mCTACOM, 4 ) )
netrecapp()
FIELD->NUMERO := mNUMERO
FIELD->CONTA  := mCONTA
FIELD->CTACOM := mCTACOM
ELSE
netreclock()
ENDIF
FIELD->HORAS := mHORAS
dbUnlock()
ENDDO
dbSelectAr( "VTFIXO" )
FODZER()
dbCloseAll()
RETU
// : FIM: FOA5.PRG

// + EOF: foa5.prg
// +
