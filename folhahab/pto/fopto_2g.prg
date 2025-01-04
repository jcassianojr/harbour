// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_2g.prg Importar Ocorrencias
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


FUNCTION fopto_2g()

   CABE2( "FOPTO_2G - Importar Ocorrencias" )

   cPO := "PO" + ANOMESW   // ANOWORK + strzero( MES, 2 )
   CHECKCRI( cPO, "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )

// cARQ := space( 40 )
// MDS( "Digite o Nome do Arquivo" )
// @ 24, 30 get cARQ
// if !READCUR()
// retu .F.
// endif
// cARQ := alltrim( cARQ )
   cARQ := win_GetOpenFileName(, "Arquivos de Ocorrencias", hb_cwd(), "Arquivos de Ocorrencias", "*.*", 1 )

   IF !hb_FileExists( cARQ )
      ALERTX( "Nao encontrei Arquivo: " + cARQ )
      RETU .F.
   ENDIF
   nHANDLE := hb_fopen( cARQ )
   IF nHANDLE <= 0
      ALERTX( "Nao Consegui abrir o Arquivo: " + cARQ )
      RETU .F.
   ENDIF
   lCONF  := MDG( "Conferir funcionario a funcionario" )
   lOCOR  := MDG( "Gravar em SIM=ocorrencias NAO=Ponto" )
   aNUM   := {}
   aINI   := {}
   aFIM   := {}
   aCOD   := {}
   LINHA1 := FREADLINE( nHANDLE )
   LINHA  := AllTrim( LINHA1 )
   WHILE .T.
      IF !Empty( LINHA )
         dINI := SubStr( LINHA, 9, 6 )
         tDIA := SubStr( dINI, 1, 2 )
         tMES := SubStr( dINI, 3, 2 )
         tANO := SubStr( dINI, 5, 2 )
         dINI := CToD( tDIA + "/" + tMES + "/" + tANO )
         dFIM := SubStr( LINHA, 15, 6 )
         tDIA := SubStr( dFIM, 1, 2 )
         tMES := SubStr( dFIM, 3, 2 )
         tANO := SubStr( dFIM, 5, 2 )
         dFIM := CToD( tDIA + "/" + tMES + "/" + tANO )
         AAdd( aNUM, Val( Left( LINHA, 8 ) ) )
         AAdd( aINI, dINI )
         AAdd( aFIM, dFIM )
         AAdd( aCOD, if( Len( LINHA ) = 22, Right( LINHA, 2 ), "  " ) )
      ENDIF
      LINHA := AllTrim( FREADLINE( nHANDLE ) )
      IF LINHA = LINHA1
         EXIT
      ENDIF
   ENDDO
   FClose( nHANDLE )

   cPN := "PN" + ANOMESW   // ANOWORK + strzero( MES, 2 )
   CRIARVARS( PES )

   FOR W := 1 TO Len( aNUM )
      mNUMERO := aNUM[ W ]
      dINI    := aINI[ W ]
      dFIM    := aFIM[ W ]
      dOCO    := aCOD[ W ]
      IF IGUALVARS( PES, PESIND, mNUMERO )
         IF lCONF
            @ 05, 00 SAY mNUMERO
            @ 05, 10 SAY mNOME
            @ 06, 00 SAY "Data inicial"
            @ 06, 20 SAY "Data Final"
            @ 06, 40 SAY "Codigo"
            @ 07, 00 GET dINI
            @ 07, 20 GET dFIM
            @ 07, 40 GET dOCO           VALID !Empty( dOCO )
            READCUR()
         ENDIF
         IF !Empty( dOCO )
            IF !lOCOR  // se nao for ocorrencia gravar ponto
               IF NETUSE( cPN )  // AREDE( cPN, cPN, 1 )
                  FOR J := dINI TO dFIM
                     dbGoTop()
                     IF dbSeek( Str( mNUMERO, 8 ) + DToS( J ) )
                        netreclock()
                        field->COD := dOCO
                        dbUnlock()
                     ENDIF
                  NEXT
                  dbCloseArea()
               ENDIF
            ELSE
               IF NETUSE( cPO )  // AREDE( cPO, cPO, 1 )
                  dbGoTop()
                  IF !dbSeek( Str( mNUMERO, 8 ) + DToS( dINI ) )
                     netrecapp()
                     field->NUMERO := mNUMERO
                     field->OCOINI := dINI
                  ELSE
                     netreclock()
                  ENDIF
                  field->OCOFIM := dFIM
                  field->OCOCOD := dOCO
                  dbUnlock()
               ENDIF
               dbCloseArea()
            ENDIF
         ENDIF
      ELSE
         IF lCONF
            ALERTX( "Funcion rio nao Cadastrado: " + Str( mNUMERO ) )
         ENDIF
      ENDIF
   NEXT W

   IF lCONF
      IF MDG( "Deseja imprimir arquivo Importado" )
         IMPARQ( cARQ )
      ENDIF
// FOPTO_2H(.T.)
   ELSE
// FOPTO_2H(.F.)
   ENDIF

   RETURN

// + EOF: fopto_2g.prg
// +
