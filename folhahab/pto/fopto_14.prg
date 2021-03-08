*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOPTO_14.PRG
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

function fopto_14
para lPER
IF VALTYPE(lPER)#"L"
   lPER=.T.
ENDIF
CABE2( 'FOPTO_14 - Copiando Arquivo' )

nTIPO := PEGRELOGIO()

CAMI := pegarqcon( nTIPO, "CAM" )
DADO := pegarqcon( nTIPO, "TXT" )

COPIO := CAMI + DADO + space( 20 )
COPID := DADO

MDS( "Confirme Arquivo" )
@ 24, 20 get COPIO pict "@S40"
if ! READCUR()
   retu .F.
endif

COPIO := alltrim( COPIO )

if ! HB_FILEEXISTS( COPIO )
   MDT( 'Nao encontrei o arquivo ' + COPIO )
   ALERTX( "Checar Configuracao" )
   retu
endif
IF lPER
   IF FILESIZE(COPIO)>1000000
      ALERTX("Aquivo Relogio Maior 1M")
      ALERTX("Diminua o Periodo de Exportacao")
      IF ! MDG("Deseja Continuar")
          RETUrn
      ENDIF
      ALERTX("Arquivos Grandes Demoram Importacaao/Transferencias")
      ALERTX("Alem de Poderem Causar Erros")
   ENDIF
ENDIF
FILECOPY(COPIO,COPID)

IF lPER
  if MDG( "Deseja transferir Dados Relogio/Ponto" )
     FOPTO_11( nTIPO,.T.)
   endif
else
     FOPTO_11( nTIPO,.F.)
endif
retu

*+ EOF: FOPTO_14.PRG
