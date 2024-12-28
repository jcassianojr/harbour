// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aoz.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


MDI( " þ Reprocessar Reserva Necessidade Materia Prima" )
IF !MDG( "Deseja Reprocessar" )
RETU .F.
ENDIF

IF MDG( "Reprocessar Passos da Ordem de Fabrica‡Æo" )
M_AOY()
ENDIF
lPRO := MDG( "Incluir Saldo em Processo" )
IF lPRO
APGPR2( 2 )  // Estoque de processo
ENDIF

CRIARVARS( "OR01" )   // arq 0r01 Apenas Referencia Criacao
mDATA   := ZDATA
mNUMERO := 0

ZAPARQ( { { "OR06", .F., .T. }, { "OR07", .F., .T. }, { "OR08", .F., .T. } } )  // Apagando Todas Reservas

ZAPARQ( { { "OR09", .F., .T. }, { "OR10", .F., .T. }, { "OR11", .F., .T. } } )  // Zerando e Abrindo Reservas

MDS( "Gerando as Necessidades" )
IF !USEREDE( "OF03", 1, 3 )
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
@ 24, 30 SAY OF
mOS      := OF
mOF      := OF
mSEQ     := 1
nSTART   := QTTIME * QTFAL
mTIPO    := "E"
mDLIMP   := DLIMP
mDLIMITE := DLIMITE
mDPEDI   := DPEDI
IF nSTART > 0.0001
MAOZ01( CODMP01, "E" )
MAOZ01( CODMP02, "H" )
MAOZ01( CODMP02B, "H" )
MAOZ01( CODMP02C, "H" )
MAOZ01( CODMP02D, "H" )
MAOZ01( CODMP03, "T" )
ENDIF
dbSkip()
ENDDO
dbCloseAll()

MDS( "Distribuindo o Estoque" )
MAOZ02( "MP01" )
MAOZ02( "MP02" )
MAOZ02( "MP03" )





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOZ01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAOZ01( cCOD, cTIPO )

   IF !Empty( cCOD )
      mCODIGO := cCOD
      mQTDDE  := nSTART
      IF !NOVOOPE( TIPORR( cTIPO, 2 ), PadR( cCOD, 24 ) + Str( mOF, 8, 2 ) )
         FIELD->QTDDE := QTDDE + mQTDDE
      ENDIF
   ENDIF
   dbSelectAr( "OF03" )
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOZ02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOZ02( cARQ )

   IF !USEREDE( cARQ, 1, 1 )
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 40 SAY CODIGO
      yCODIGO := CODIGO
      wQTDE   := ESTQSAL + IF( lPRO, ESTQPRO, 0 )
      IF wQTDE > 0
         IF cARQ == "MP01"
            MAY02( "OR09", "OR09BX", "OR06", wQTDE )
         ENDIF
         IF cARQ == "MP02"
            MAY02( "OR10", "OR10BX", "OR07", wQTDE )
         ENDIF
         IF cARQ == "MP03"
            MAY02( "OR11", "OR11BX", "OR08", wQTDE )
         ENDIF
      ENDIF
      dbSelectAr( cARQ )
      dbSkip()
   ENDDO
   RETU .T.

// + EOF: m_aoz.prg
// +
