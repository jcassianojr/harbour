// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_43.prg Atualizar CaDastro de Horarios de Referencias
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


FUNCTION fopto_43()

   CABE2( 'FOPTO_43 - Atualizar CaDastro de Horarios de Referencias' )

   IF !NETUSE( PES )
      RETU
   ENDIF

   IF !NETUSE( "FO_RELHR" )
      dbCloseAll()
      RETU .F.
   ENDIF
   INITVARS()
   CLRVARS()

   IF !NETUSE( "FOPTOHRE" )
      dbCloseAll()
      RETU .F.
   ENDIF
   INITVARS()
   CLRVARS()

   IF !NETUSE( "ESCALPAD" )
      dbCloseAll()
      RETU .T.
   ENDIF

   cPE := "PE" + ANOMESW
   CHECKCRI( cPE, "FOPTOREV", "GRUPO+DTOS(DATA)" )

   IF !NETUSE( cPE )
      dbCloseAll()
      RETU .F.
   ENDIF

// 1a. Fase Cria os Horarios
   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      PETELA( 9 )
      NUM       := NUMERO
      mNOMEPES  := NOME
      mADMITIDO := ADMITIDO
      dbSelectAr( "FO_RELHR" )
      dbGoTop()
      IF dbSeek( NUM )
         netreclock()
      ELSE
         netrecapp()
         FO_RELHR->NUMERO := NUM
      ENDIF
      FO_RELHR->NOME := mNOMEPES
      IF Empty( DATAREF1 )
         FO_RELHR->DATAREF1 := mADMITIDO
      ENDIF
      dbUnlock()
      dbSelectAr( PES )
      dbSkip()
   ENDDO

// 2a. Fase Cria os Horarios
   dbSelectAr( "fo_relhr" )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY numero
      @ 24, 10 SAY nome
      mNUMERO := NUMERO
      mHFOL00 := HFOL00
      mGRUPO  := GRUPO
      mHORREF := HORREF

// Ajusta codigos
      IF Empty( HFOL00 ) .AND. !Empty( HORREF )
         NETGRVCAM( "HFOL00", "N" )
      ENDIF
      IF Empty( HFOL00 ) .AND. !Empty( GRUPO )
         NETGRVCAM( "HFOL00", "S" )
      ENDIF
      IF HFOL00 = "S"  // Escala nao tem horario padrao
         netgrvcam( "HORREF", "" )
      ENDIF
      IF HFOL00 = "N"  // horario padrao nao tem escala
         netgrvcam( "GRUPO", "" )
      ENDIF

// Tenta Opter o codigo
      IF Empty( mGRUPO ) .AND. Empty( mHORREF )
         dbSelectAr( PES )
         dbGoTop()
         IF dbSeek( mNUMERO )
            mHTT := HTT
            dbSelectAr( "FOPTOHRE" )
            dbGoTop()
            IF dbSeek( mHTT )
               mHORREF := mHTT
            ENDIF
            IF Empty( mHORREF )
               dbSelectAr( "ESCALPAD" )
               dbGoTop()
               IF dbSeek( mHTT )
                  mGRUPO := mHTT
               ENDIF
               IF Empty( mGRUPO )
                  dbSelectAr( cPE )
                  dbGoTop()
                  IF dbSeek( mHTT )
                     mGRUPO := mHTT
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         dbSelectAr( "fo_relhr" )
         IF !Empty( mHORREF )
            NETGRVCAM( "HFOL00", "N" )
            NETGRVCAM( "HORREF", mHORREF )
         ENDIF
         IF !Empty( mGRUPO )
            NETGRVCAM( "HFOL00", "S" )
            NETGRVCAM( "GRUPO", mGRUPO )
         ENDIF
      ENDIF
      dbSelectAr( "fo_relhr" )
      dbSkip()
   ENDDO
   dbCloseAll()

   RETURN .T.



// + EOF: fopto_43.prg
// +
