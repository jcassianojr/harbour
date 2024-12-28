// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_db.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_db()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_db

   PARA wFILTRO

   MDI( " Indexar Arquivos " )

// Variaveis de Trabalho
   lPULAFEC  := .F.
   lPULACEP  := .F.
   lPULACNPJ := .F.
   aARQ      := {}
   aARQD     := {}

   IF ValType( wFILTRO ) # "C"
      lPULAFEC  := MDG( "Pular Arquivos Fechados" )
      lPULACEP  := MDG( "Pular Arquivos CEPS" )
      lPULACNPJ := MDG( "Pular Arquivos CNPJ/IE" )
      lMESARQ   := MDG( "Exibir Mensagem arquivo nao encontrado" )
      FILTRO    := RFILORD( zARQ, .F. )
   ELSE
      lMESARQ := .T.
      FILTRO  := wFILTRO
   ENDIF

   IF !useCHK( ZDIRC + "MANARQ", ZDIRC + "MANARQ", .T. )
      dbCloseAll()
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   SET FILTER TO &FILTRO
   dbGoTop()
   WHILE !Eof()
      lINCLUI := .T.
      @ 24, 00 SAY PadR( ARQUIVO, 8 )
      IF ( !Empty( arqANO ) .AND. lPULAFEC ) .OR. ARQUIVO = "MANARQ" .OR. ARQUIVO = "MANARQ1"
         // Nao Inclui Na Lista Fechados
         lINCLUI := .F.
      ENDIF
      IF PADRAO = "A" .AND. lPULACEP   // E cep e foi solicitado pular
         lINCLUI := .F.
      ENDIF
      IF lPULACNPJ .AND. ( At( "CNPJIE", ARQUIVO ) > 0 .OR. At( "BAIXA", ARQUIVO ) > 0 )
         lINCLUI := .F.
      ENDIF
      IF lINCLUI
         AAdd( aARQ, AllTrim( ARQUIVO ) )
         AAdd( aARQD, { PADRAO, AllTrim( CAMINHO ), if( Empty( DRIVER ), "DBFCDX", DRIVER ) } )
      ENDIF
      dbSkip()
      zei_fort( nLASTREC,,, 1 )
   ENDDO
   dbCloseArea()

// LOCALARQ(PADRAO,CAMINHO)

   IF !useCHK( ZDIRC + "MANARQ1", ZDIRC + "MANARQ1", .T. )
      dbCloseAll()
      RETU .F.
   ENDIF
   nLASTREC := Len( aARQ )
   zei_fort( nLASTREC,,, 0 )
   FOR X := 1 TO Len( aARQ )
      cARQ := aARQ[ X ]
      @ 24, 00 SAY PadR( cARQ, 8 )
      // Carrega o Diret¢rio do Arquivo
      mDIR := LOCALARQ( aARQD[ X, 1 ], aARQD[ X, 2 ] )
      // Carrega os Indices
      aIND := {}
      dbGoTop()
      dbSeek( cARQ )
      WHILE cARQ = AllTrim( ARQUIVO ) .AND. !Eof()
         AAdd( aIND, { AllTrim( INDICE ), AllTrim( INDEXP ) } )
         dbSkip()
      ENDDO
      // Apagando Indices
      IF aARQD[ X, 3 ] = "DBFCDX"
         IF File( mDIR + cARQ + ".CDX" )
            FErase( mDIR + cARQ + ".CDX" )
         ENDIF
      ELSE
         FOR W := 1 TO Len( aIND )
            IF File( mDIR + aIND[ W, 1 ] + ".NTX" )
               FErase( mDIR + aIND[ W, 1 ] + ".NTX" )
            ENDIF
         NEXT W
      ENDIF
      IF USECHK( mDIR + cARQ,, .F., aARQD[ X, 3 ], .T., 300, lMESARQ )   // USECHK(cARQ,cIND,lSHA,cDRIVER,lNEW,nTIME,lMES)
         PACK
         nLASTREC := LastRec()
         zei_fort( nLASTREC,,, 0 )
         FOR W := 1 TO Len( aIND )
            @ 24, 10 SAY PadR( aIND[ W, 1 ], 8 )
            IF aARQD[ X, 3 ] = "DBFCDX"
               mDIRIND := mDIR + cARQ
               cTAG    := aIND[ W, 1 ]
            ELSE
               mDIRIND := mDIR + aIND[ W, 1 ]
            ENDIF
            mINDEXP := aIND[ W, 2 ]
            IF Left( mINDEXP, 1 ) # "<"
               IF aARQD[ X, 3 ] = "DBFCDX"
                  INDEX ON &mINDEXP TAG &cTAG. EVAL ZEI_FORT( nLASTREC,,, 1 )
               ELSE
                  INDEX ON &mINDEXP TO &mDIRIND EVAL ZEI_FORT( nLASTREC,,, 1 )
               ENDIF
            ELSE
               mINDEXP := SubStr( mINDEXP, 2 )
               IF aARQD[ X, 3 ] = "DBFCDX"
                  INDEX ON &mINDEXP TAG &cTAG. DESCEN EVAL ZEI_FORT( nLASTREC,,, 1 )
               ELSE
                  INDEX ON &mINDEXP TO &mDIRIND DESCEN EVAL ZEI_FORT( nLASTREC,,, 1 )
               ENDIF
            ENDIF
         NEXT W
         dbCloseArea()
      ENDIF
      dbSelectAr( "MANARQ1" )
      zei_fort( nLASTREC,,, 1 )
   NEXT X

   IF !useCHK( ZDIRC + "MANARQ", ZDIRC + "MANARQ", .T. )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbSelectAr( "MANARQ1" )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   WHILE !Eof()
      lTEM     := .T.
      cARQUIVO := AllTrim( ARQUIVO )
      dbSelectAr( "manarq" )
      dbGoTop()
      IF !dbSeek( cARQUIVO )
         ltem := .F.
      ENDIF
      dbSelectAr( "MANARQ1" )
      WHILE cARQUIVO = AllTrim( ARQUIVO ) .AND. !Eof()
         IF !ltem
            netrecdel()
         ENDIF
         dbSkip()
         zei_fort( nLASTREC,,, 1 )
      ENDDO
   ENDDO

   dbCloseAll()
   FIXAR( "MANARQ1" )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MDT( cMSG )  // EXIBE MENSAGEM POR UM TEMPO

   hb_Alert( cMSG,,, 1 )

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MD   // TELA PARA AS MENSAGENS

   @ MaxRow(), 00

   RETURN .T.



// + EOF: m_db.prg
// +
