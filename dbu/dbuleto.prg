// +--------------------------------------------------------------------
// +
// +
// +
// +    Function letomenu()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

#include "leto_rev.ch"
#include "rddleto.ch"
#include "BOX.CH"
#include "TRY.CH"

REQUEST LETO


FUNCTION letomenu()

   LOCAL aAMBIENTE

   cTIPOSQL := "LETODB"  // Passa para privada usadas nas funcoes aBaixo

   aAMBIENTE  := SALVAA()
   cSERVERX   := PADR("//127.0.0.1:2812/",30," ")
   cDATABASEX := Space( 30 )
   cUSERX     := Space( 30 )
   cPASSX     := Space( 30 )
   cTABELAX   := Space( 30 )
   loledb     := .T.
   lMDB       := .F.
   lACCDB     := .F.
   
   cOLDRDD := RDDSETDEFAULT( "LETO" )
   nOLDTIPORDD := TIPODBF
   TIPODBF:=90

   pegcfgbanco()



   WHILE .T.
      hb_DispBox( 3, 22, 22, 55, B_DOUBLE + " " )
      @ 03, 24 SAY "LETODB" + " " + cSERVERX
      OPCAO( 4, 24, "&Versao Info               ", 86 )   // V
      OPCAO( 5, 24, "&Tabelas                   ", 84 )   // T
      OPCAO( 6, 24, "&Importar  DBF             ", 73 )   // I
      OPCAO( 7, 24, "&Exportar  DBF             ", 69 )   // E
      OPCAO( 8, 24, "&Apagar Tabela             ", 65 )   // A
      OPCAO( 9, 24, "Exportar &Formatos         ", 70 )  // F
    //opcao backup zip
      KEY := menu( 1, 0 )
      DO CASE
      CASE KEY = 1
           LETO_INFO(cSERVERX)
      CASE KEY = 2
           LETO_tables(cSERVERX)
      CASE KEY = 3
           LETO_DBFTOSRV(cSERVERX) 
      CASE KEY = 4
           LETO_SRVTODBF(cSERVERX)
      CASE KEY = 5
          LETO_DELDBF(cSERVERX) 
      CASE KEY = 6
          leto_expformat(cSERVERX) 
      OTHERWISE
         EXIT
      ENDCASE
   ENDDO

   TIPODBF :=nOLDTIPORDD
   rddSetDefault( cOLDRDD )
   RDDNOME(TIPODBF)
   
   RESTAA( aAMBIENTE )
   LAYOUT()

   RETURN .T.
   
   
FUNCTION LETO_SRVTODBF(cSrvAddr) 
   cARQORI    := LETO_tables(cSERVERX)
   cARQUIVO   :=TIRAEXT(cARQORI )
   cEXTMEMO:=".FPT"
   cEXTINDEX:=".CDX"
   nConnect := LETO_CONNECT( cSrvAddr )
   altd()
   IF nConnect >= 0
       IF .NOT. File( cARQORI )
          Leto_FCopyFromSrv( cARQORI, cARQORI )
       ENDIF 
       IF .NOT. FILE (cARQUIVO+cEXTMEMO) 
           Leto_FCopyFromSrv( cARQUIVO+cEXTMEMO, cARQUIVO+cEXTMEMO )
       ENDIF
       IF .NOT. FILE (cARQUIVO+cEXTINDEX) 
          Leto_FCopyFromSrv(cARQUIVO+cEXTINDEX, cARQUIVO+cEXTINDEX )
       ENDIF
       leto_disconnect() 
   ENDIF
RETURN .T.     

FUNCTION LETO_DELDBF(cSrvAddr) 
   cARQORI    := LETO_tables(cSERVERX)
   cARQUIVO   :=TIRAEXT(cARQORI )
   cEXTMEMO:=".FPT"
   cEXTINDEX:=".CDX"
   IF MDG('Excluir '+cARQORI)
       nConnect := LETO_CONNECT( cSrvAddr )
       IF nConnect >= 0
           Leto_FERASE( cARQORI, cARQORI )
           Leto_FERASE( cARQUIVO+cEXTMEMO )
           Leto_FERASE(cARQUIVO+cEXTINDEX )
           leto_disconnect() 
       ENDIF
    ENDIF   
RETURN .T.     


FUNCTION leto_expformat(cSrvAddr) 
   cARQORI    := LETO_tables(cSERVERX)
   cTABELAX  :=TIRAEXT(cARQORI )


   LCOPIANAT := .F.  // MDG("Copia Nativa(SIM) Interna(NAO)") //copy to nao implemntado mysqlrddd
   tDOC      := pegtipodoc()   // .t. Inclui dbf se for nativa
   pegparexp()
   lDOCCAB   := .F.
   lDOCDAD   := .F.
   lDOCRECNO := .F.
   cSUBTIPO  := " "
   PegcsUB( tDOC )   // pegar o subtipo conforme tipo
   cDESTINO := cTABELAX + "_" + cTIPOSQL + "_leto." + zEXPOREXT
   MDT( cDESTINO )
   MDT( "abrindo arquivo de origem: " + cTABELAX )
   nConnect := LETO_CONNECT( cSrvAddr )
   altd()
       IF nConnect >= 0
         //DBUseArea( <lNewArea> , <cDriver> , <cName>, <xcAlias> , <lShared> , <lReadOnly>,<cCodePage>,<nConnection> ) -> lSuccess
         dbUseArea( .T.,,  cTABELAX,,.T. )
         nLASTREC := LastRec()
         zei_fort( nLASTREC,,, 0 )
         aSTRU := dbStruct()
         multidocg( lDOCCAB, lDOCDAD, lDOCRECNO, cSUBTIPO, TIRAEXT( cDESTINO ), aSTRU )
         dbCloseArea()
     endif
return .t.
   
FUNCTION LETO_DBFTOSRV(cSrvAddr) 
   cARQORI    := win_GetOpenFileName(, "Arquivos de Origem", hb_cwd(), "Arquivos de Origem", "*.dbf", 1 )
   cCAMINHO   :=""
   cARQUIVO   :=""
   cEXTENSAO  :=""
   cEXTMEMO   :=""
   cEXTINDEX  :=""
   //HB_FNameSplit( <cString>, <@cPath> , <@cFileName> , <@cExtension> ) -> NIL
   hb_FNameSplit( cARQORI, @cCAMINHO, @cARQUIVO, @cEXTENSAO )
   TRY
     cEXTMEMO   := hb_rddInfo(RDDI_MEMOEXT)  //a extensao do origem memo do destino vem com ponto
   END
   TRY
     cEXTINDEX   := hb_rddInfo(RDDI_ORDBAGEXT)
   END
   //melhorar antes da busca do dbf escolher rdd
   //como o rdddefault esta leto nao tras as extensoes
   //antes do connection setar novamente rdddefault leto
   //usando exensoes dbfcdx por horan
    // tipodbfesc tem as extensao memo e indices no menu
   IF EMPTY(cEXTMEMO)
      cEXTMEMO:=".FPT"
   ENDIF
   IF EMPTY(cEXTINDEX)
      cEXTINDEX:=".CDX"
   ENDIF
 //*.dbf, *.fpt, *.dbt, *.smt
   //.CDX, .IDX, .MDX, .NTX, .NDX
   nConnect := LETO_CONNECT( cSrvAddr )
   IF nConnect >= 0
       IF File( cARQORI )
          Leto_FCopyToSrv( cARQORI, cARQUIVO+cEXTENSAO )
       ENDIF 
       IF FILE (cCAMINHO+cARQUIVO+cEXTMEMO) 
           Leto_FCopyToSrv( cCAMINHO+cARQUIVO+cEXTMEMO, cARQUIVO+cEXTMEMO )
       ENDIF
       IF FILE (cCAMINHO+cARQUIVO+cEXTINDEX) 
          Leto_FCopyToSrv( cCAMINHO+cARQUIVO+cEXTINDEX, cARQUIVO+cEXTINDEX )
       ENDIF
       leto_disconnect() 
   ENDIF
RETURN .T.  
   
FUNCTION LETO_INFO( cSrvAddr, cLogFile, cOptions )
   LOCAL nConnect := LETO_CONNECT()
   LOCAL cInfo := ""
   LOCAL cTmp, nTmp

#ifndef __XHARBOUR__   /* there is no useable LETO_UDF :-( */
   IF nConnect < 0 .AND. ! EMPTY( cSrvAddr )
      nConnect := LETO_CONNECT( cSrvAddr )
   ENDIF
#endif

   IF nConnect >= 0
      cTmp := leto_udf( "OS" )
   ELSE
      cInfo += "Server revision: " + __SRV_REVISION__ + HB_EOL() + HB_EOL()
   ENDIF
   IF ! EMPTY( cTmp ) .AND. VALTYPE( cTmp ) == "C"
      cInfo := "Server revision: " + __SRV_REVISION__ + HB_EOL() + cTmp + HB_EOL()

      cTmp := leto_udf( "VERSION" )        /* Harbour version */
      IF ! EMPTY( cTmp ) .AND. VALTYPE( cTmp ) == "C"
         cInfo += cTmp + HB_EOL()
      ENDIF
      cTmp := leto_udf( "HB_VERSION", 1 )  /* C-compiler aka HB_VERSION_COMPILER */
      IF ! EMPTY( cTmp ) .AND. VALTYPE( cTmp ) == "C"
         cInfo += cTmp + HB_EOL()
      ENDIF
      cInfo += HB_EOL()
   ENDIF

   cInfo += "Client revision: " + __RDD_REVISION__ + HB_EOL() + OS() + HB_EOL()
   cInfo += VERSION() + HB_EOL()
   cTmp := HB_VERSION( 1 )   /* C-compiler aka HB_VERSION_COMPILER */
   IF ! EMPTY( cTmp ) .AND. VALTYPE( cTmp ) == "C"
      cInfo += cTmp + HB_EOL()
   ENDIF

   IF nConnect >= 0 .AND. ! EMPTY( cOptions )
      IF VAL( cOptions ) >=0 .AND. LEFT( cOptions, 1 ) $ "0123456789"
         nTmp := VAL( cOptions )
         IF leto_mgID() != nTmp  /* ele we have just overwritten the log */
            cTmp := leto_MgLog( nConnect, nTmp )
         ELSE
            cTmp := ""
         ENDIF
      ELSE
         nTmp := -1
         cTmp := leto_MgLog( nConnect, -1 )
      ENDIF
      IF ! EMPTY( cTmp )
         cInfo += "- -[ " + STR( nTmp, 4, 0 ) + " ]" + REPL( "- ", 15 )
         cInfo +=  + HB_EOL() + cTmp + REPL( "- ", 42 ) + HB_EOL()
      ENDIF
   ENDIF

   cInfo += HB_EOL()

   IF ! EMPTY( cLogFile ) .AND. VALTYPE( cLogFile ) == "C"
      IF FILE( cLogFile )
         IF ".gz" $ LOWER( cLogFile )
            cTmp := HB_ZUNCOMPRESS( MEMOREAD( cLogFile ) )
         ELSE
            cTmp := MEMOREAD( cLogFile )
         ENDIF
         cInfo += cTmp
         IF ".gz" $ LOWER( cLogFile )
            cTmp := HB_GZCOMPRESS( cInfo )
            IF ! EMPTY( cTmp )
               MEMOWRIT( cLogFile, cTmp )
            ELSE
               MEMOWRIT( cLogFile + ".txt", cInfo )
            ENDIF
         ELSE
            MEMOWRIT( cLogFile, cInfo + MEMOREAD( cLogFile )  )
         ENDIF
      ELSE
         IF ".gz" $ LOWER( cLogFile )
            cTmp := HB_GZCOMPRESS( cInfo )
            IF ! EMPTY( cTmp )
               MEMOWRIT( cLogFile, cTmp )
            ELSE
               MEMOWRIT( cLogFile + ".txt", cInfo )
            ENDIF
         ELSE
            MEMOWRIT( cLogFile, cInfo )
         ENDIF
      ENDIF
   ELSE
      ALERT( cInfo )
   ENDIF
   
   leto_disconnect()

RETURN cInfo



FUNCTION leto_tables( cSrvAddr )

// ---------------------------------------------------------------------------
// Shows all tables inside the database
// ---------------------------------------------------------------------------
   LOCAL aResult, nChoices, I, aRETU
   LOCAL aAMBIENTE
   nChoices  := 0
   aAMBIENTE := SALVAA()
   aRESULT   := {}
   
   
   
  nConnect := LETO_CONNECT( cSrvAddr )

   IF nConnect >= 0

       aRETU := leto_directory( "*.DBF" )  
       
       FOR i := 1 TO Len( aRETU )
          AAdd( aRESULT, aRETU[ i, 1 ] )
       NEXT i


       IF Len( aResult ) > 0
          hb_DispBox( 3, 22, 22, 55, B_DOUBLE + " " )
          nChoices := AChoice( 4, 23, 21, 54, aResult )
       ENDIF
       
   endif
   
   leto_disconnect()

   RESTAA( aAMBIENTE )

   RETURN ( iif( nChoices > 0, aResult[ nChoices ], "" ) )




