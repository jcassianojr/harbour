// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_2y.prg Exclusao Demitidos
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

function fopto_2y()
CABE2( 'FOPTO_2Y - Exclusao Demitidos' )
cPN := "PN" + ANOMESW



IF !NETUSE( PES )
RETU
ENDIF

IF !NETUSE( cPN )
dbCloseAll()
RETU
ENDIF
dbSelectAr( PES )
WHILE !Eof()
IF !Empty( DEMITIDO )
PETELA( 8 )
mNUMERO := NUMERO
mDATA   := DEMITIDO
mDATA++
dbSelectAr( cPN )
dbGoTop()
dbSeek( Str( mNUMERO, 8 ) + DToS( mDATA ) )
WHILE mNUMERO = NUMERO .AND. !Eof()
netrecdel()
dbSkip()
ENDDO
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()
return

// + EOF: fopto_2y.prg
// +
