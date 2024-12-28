// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_2j.prg
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



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto_2j()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_2j

   PARA lPER

   PEGPTOHOR( "XX", .T., .F. )   // Verifica indices

   IF ZFECHADO = "S"
      ALERTX( "Mes ja Fechado" )
      RETU .F.
   ENDIF


   IF ValType( lPER ) # "L"
      lPER := .T.
   ENDIF
   CABE2( "FOPTO_2J - Lancar Correcoes Horarios - " + ANOMESW )
   IF lPER
      IF !MDG( "Lancar Correcoes Horarios" )
         RETU .F.
      ENDIF
   ENDIF

   cPH := "PH" + ANOMESW
   cPN := "PN" + ANOMESW

   IF !NETUSE( cPH )
      RETU .F.
   ENDIF
   IF !NETUSE( cPN )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !NETUSE( "FOPTOHOR" )
      dbCloseAll()
      RETU .T.
   ENDIF

   dbSelectAr( cPH )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      dINI    := OCOINI
      dFIM    := OCOFIM
      IF Empty( dFIM )
         dFIM := dINI
      ENDIF
      dOCO := OCOCOD
      IF !Empty( dOCO )
         aRETU := PEGPTOHOR( dOCO, .F. )
         IF aRETU[ 6 ]
            dbSelectAr( cPN )
            FOR J := dINI TO dFIM
               dbGoTop()
               IF dbSeek( Str( mNUMERO, 8 ) + DToS( J ) )
                  netreclock()
                  field->CODREV  := dOCO
                  field->ENTREV  := aRETU[ 1 ]
                  field->ALIREV  := aRETU[ 2 ]
                  field->ALSREV  := aRETU[ 3 ]
                  field->SAIREV  := aRETU[ 4 ]
                  field->virada  := aRETU[ 5 ]
                  field->folsn   := aRETU[ 7 ]
                  field->horario := aRETU[ 8 ]
                  field->mudhor  := "#"
                  dbUnlock()
               ENDIF
            NEXT
         ENDIF
      ENDIF
      dbSelectAr( cPH )
      dbSkip()
      zei_fort( nLASTREC,,, 1 )
   ENDDO
   dbCloseAll()


// + EOF: fopto_2j.prg
// +
