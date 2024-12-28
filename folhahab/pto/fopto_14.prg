// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_14.prg
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
// +    Function fopto_14()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_14

   PARA lPER

   IF ValType( lPER ) # "L"
      lPER := .T.
   ENDIF
   CABE2( 'FOPTO_14 - Copiando Arquivo' )

   nTIPO := PEGRELOGIO()

   CAMI := pegarqcon( nTIPO, "CAM" )
   DADO := pegarqcon( nTIPO, "TXT" )

   COPIO := CAMI + DADO + Space( 20 )
   COPID := DADO

   MDS( "Confirme Arquivo" )
   @ 24, 20 GET COPIO PICT "@S40"
   IF !READCUR()
      RETU .F.
   ENDIF

   COPIO := AllTrim( COPIO )

   IF !hb_FileExists( COPIO )
      MDT( 'Nao encontrei o arquivo ' + COPIO )
      ALERTX( "Checar Configuracao" )
      RETU
   ENDIF
   IF lPER
      IF FILESIZE( COPIO ) > 1000000
         ALERTX( "Aquivo Relogio Maior 1M" )
         ALERTX( "Diminua o Periodo de Exportacao" )
         IF !MDG( "Deseja Continuar" )
            RETURN
         ENDIF
         ALERTX( "Arquivos Grandes Demoram Importacaao/Transferencias" )
         ALERTX( "Alem de Poderem Causar Erros" )
      ENDIF
   ENDIF
   FILECOPY( COPIO, COPID )

   IF lPER
      IF MDG( "Deseja transferir Dados Relogio/Ponto" )
         FOPTO_11( nTIPO, .T. )
      ENDIF
   ELSE
      FOPTO_11( nTIPO, .F. )
   ENDIF
   RETU


// + EOF: fopto_14.prg
// +
