// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_d9.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FOLIS_D9.PRG: Rais Ajustes de Codigos Velhos/Novos
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

IF !NETUSE( PES )
RETU .F.
ENDIF

IF !NETUSE( "FORAIS" )
dbCloseAll()
RETU .F.
ENDIF

dbSelectAr( pes )
dbGoTop()
WHILE !Eof()
mNUMERO := NUMERO
PETELA( 8 )
netreclock()
CHECKMOTDEM()
CorrigeFo_pes()
dbSelectAr( "FORAIS" )
dbGoTop()
IF !dbSeek( Str( nANOUSO, 4 ) + Str( mNUMERO, 8 ) )
netrecapp()
FIELD->NUMERO := CTR
FIELD->ANO    := ANOUSO
ELSE
netreclock()
ENDIF
IF Empty( RAISVINC )
FIELD->RAISVINC := "10"
ENDIF
IF RAISVINC == "1 "
FIELD->RAISVINC := "10"
ENDIF
IF Empty( TIPOADM )
FIELD->TIPOADM := "2"
ENDIF
IF Empty( ALVARA )
FIELD->ALVARA := "N"
ENDIF
IF Empty( DEMITIDO )
FIELD->RAISDEM := "00"
ENDIF
dbSelectAr( pes )
IF Empty( MOTIVO )
FIELD->MOTIVO := OBTER( "FO_RCAU",, FORAIS->RAISDEM, "CODIGO", 2 )
ENDIF
dbUnlock()
dbSkip()
ENDDO
dbCloseAll()

// + EOF: folis_d9.prg
// +
