// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_27.prg
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


CABE2( 'FOPTO_27 - Marcar um dia com um c¢digo' )
dINI := zdataini
dFIM := zdatafim
mCOD := "  "
mRED := " "
mBCO := " "
mFOL := " "
mEXT := " "
mSOD := "  "
mALM := " "
mZER := "N"
@ 18, 00 SAY 'Digite o Periodo para marca‡„o'
@ 19, 00 SAY 'Digite o C¢digo/Sub para marca‡„o'
@ 19, 50 SAY 'Zerar'
@ 20, 00 SAY 'Redu‡ao Horario  SN'
@ 21, 00 SAY 'Banco de Horas   SNF'
@ 22, 00 SAY 'Folga Indicada   SNV'
@ 23, 00 SAY 'Hora Extra       SNVTZ'
@ 24, 00 SAY 'Almoco           ABCDESN'
@ 18, 40 GET dINI
@ 18, 50 GET dFIM
@ 19, 40 GET mCOD
@ 19, 43 GET mSOD
@ 19, 55 GET mZER                                PICT "!" VALID mZER $ "SN "
@ 20, 40 GET mRED                                PICT "!" VALID mRED $ "SN "
@ 21, 40 GET mBCO                                PICT "!" VALID mBCO $ "SNF "
@ 22, 40 GET mFOL                                PICT "!" VALID mFOL $ "SNVM "
@ 23, 40 GET mEXT                                PICT "!" VALID mEXT $ "SNVTZ "
@ 24, 40 GET mALM                                PICT "!" VALID mALM $ "ABCDESN "
IF !READCUR()
RETU .F.
ENDIF

cPN := "PN" + ANOMESW

MDS( 'Aguarde Fazendo as substitui‡”es' )

IF !NETUSE( PES )
RETU
ENDIF
FILTRO := FILTRO( "EMPTY(DEMITIDO)" )
SET FILTER TO &FILTRO
IF !NETUSE( cPN )
dbCloseAll()
RETU
ENDIF

dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 8 )
mNUMERO := NUMERO
fopto2h( if( mZER = "S", .T., .F. ) )
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()

   RETURN .T.


// + EOF: fopto_27.prg
// +
