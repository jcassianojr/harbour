// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo7alib.prg
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

// ! usado em fo7a
// ! usado em folis_d1


// !*****************************************************************************
// !
// !         Fun‡„o: CHECKFGTS
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKFGTS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CHECKFGTS( dFGTS )

   IF Empty( dFGTS )
      MDS( OBTER( "FO_TAB",, "FGTS2    ", "DESCRI" ) )
   ELSE
      ALERTX( "Data FGTS em branco" )
   ENDIF
   IF FGTS >= ADMITIDO
      MDS( OBTER( "FO_TAB",, "FGTS1    ", "DESCRI" ) )
   ELSE
      ALERTX( "Data FGTS menor que admissao" )
   ENDIF
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: CHECKCTPS
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKCTPS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CHECKCTPS()

   FIELD->PROFIS := StrZero( Val( PROFIS ), 7 )

   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: CHECKSERIE
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKSERIE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CHECKSERIE()

   FIELD->SERIE := StrZero( Val( SERIE ), 5 )

   RETU .T.



// !*****************************************************************************
// !
// !         Função: CHECKMOTDEM()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKMOTDEM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CHECKMOTDEM()

   IF Empty( motivo )
      RETURN .T.   // nao checa mas retorna true pois pode estar sendo usado no get when
   ENDIF
   IF Empty( RAISDEM )   // todos busca motivo mais o campo de retorno e diferente
      RAISDEM := OBTER( "FO_RCAU", "", MOTIVO, "RAIS" )
   ENDIF
   IF Empty( FGTSMOT )
      FGTSMOT := OBTER( "FO_RCAU", "", motivo, "CODGRE" )
   ENDIF
   IF Empty( PGFGTS )
      PGFGTS := OBTER( "FO_RCAU", "", motivo, "PAGAFGTS" )
   ENDIF
   IF Empty( MOTIVODEM )
      MOTIVODEM := OBTER( "FO_RCAU", "", MOTIVO, "CAGED" )
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKSEXO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CHECKSEXO( cNOMESEXO, cSEXO, lGRAVA )

   nPOSNOMESEXO := At( " ", cNOMESEXO ) > 0
   IF nPOSNOMESEXO > 0
      cNOMESEXO := SubStr( cNOMESEXO, 1, nPOSNOMESEXO - 1 )
   ENDIF
   IF Empty( cSEXO )   // quando nao for no when checar no modulo antes de chamar para melhorar performace
      CSEXO := OBTER( "NOMESEXO", "", cNOMESEXO, "CLASSIFICA" )
      IF lGRAVA
         SEXO := cSEXO
      ENDIF
   ENDIF

   RETURN cSEXO  // usar alltrue no when

// !*****************************************************************************
// !
// !         Fun‡„o: CHECKADM
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKADM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKADM()

   IF ADMITIDO - NASC > 5110 .AND. !Empty( NASC )
      RETU .T.
   ENDIF
   ALERTX( "Funcionario Menor de 14 anos ???" )
   PRIV GETLIST := {}
   MDS( "Confirme Data Nascimento " )
   @ 24, 40 GET NASC
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOSFAMQTDE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOSFAMQTDE( mNUMERO, cTIPO )

   LOCAL nQTDE  := 0
   LOCAL cALIAS := Alias()

   IF !NETUSE( "FOSFAM" )
      RETURN .F.
   ENDIF
   IF ValType( cTIPO ) <> "C"
      cTIPO := "I"
   ENDIF
   dbGoTop()
   dbSeek( Str( mNUMERO, 8 ) )
   WHILE mNUMERO = NUMERO .AND. !Eof()
      IF cTIPO = "I"
         IF FIELD->IRRF <> "N"
            nQTDE++
         ENDIF
      ENDIF
      IF cTIPO = "S"
         IF Empty( BAIXA ) .AND. ZDATA - FOSFAM->NASCTO > 5114
            netreclock()
            FOSFAM->BAIXA  := NASCTO + 5114  // "S" //14anos*365 +4 dias anos Bissestos
            FOSFAM->SALFAM := "N"
            dbUnlock()
         ENDIF
         IF Empty( FOSFAM->BAIXA ) .OR. FOSFAM->SALFAM <> "N"
            nQTDE++
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   dbCloseArea()
   IF !Empty( cALIAS )
      dbSelectAr( cALIAS )
   ENDIF

   RETURN nQTDE


// + EOF: fo7alib.prg
// +
