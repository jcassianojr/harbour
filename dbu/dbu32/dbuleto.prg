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
      OPCAO( 4, 24, " &Versao Infro           ", 86 )   // V
      OPCAO( 5, 24, "&Tabelas                   ", 84 )   // T
      
       //OPCAO( 5, 24, "&Database Selecionar       ", 68 )   // D
   //   OPCAO( 6, 24, "&Importar  DBF             ", 73 )   // I
    //  OPCAO( 7, 24, "&Tabelas                   ", 84 )   // T
    //  OPCAO( 8, 24, "&Exportar  DBF             ", 69 )   // E
    //  OPCAO( 9, 24, "&Apagar Tabela             ", 65 )   // A
    //  OPCAO( 10, 24, "Exportar &Formatos         ", 70 )  // F
      KEY := menu( 1, 0 )
      DO CASE
      CASE KEY = 1
           LETO_INFO(cSERVERX)
      CASE KEY = 2
           LETO_tables(cSERVERX)
      CASE KEY = 3
      CASE KEY = 4
      CASE KEY = 5
      CASE KEY = 6
      CASE KEY = 7
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

       aRETU := leto_MgGetTables(nConnect)
       
       altd()
       FOR i := 1 TO Len( aRETU )
          AAdd( aRESULT, aRETU[ i, 1 ] )
       NEXT i


       IF Len( aResult ) > 0
          hb_DispBox( 3, 22, 22, 55, B_DOUBLE + " " )
          nChoices := AChoice( 4, 23, 21, 54, aResult )
       ENDIF
       
       altd()
       aRETU:=Leto_MgGetInfo(nConnect)
   endif
   
   

   RESTAA( aAMBIENTE )

   RETURN ( iif( nChoices > 0, aResult[ nChoices ], "" ) )


