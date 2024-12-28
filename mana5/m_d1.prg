// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_d1.prg
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



// Modo de Trabalho no Video
MDI( "Checagem de CEP/DDD " )

PRIV HELPDBF := "MD1"


// md1FAZ("","","",{""})


md1FAZ( "BD01", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX" } )
md1FAZ( "CUREMP", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX" } )
md1FAZ( "IRRF01", "CIDADE", "ESTADO", { "DDD" } )
md1FAZ( "MA01", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDD2", "DDD3", "DDDFAX", "DDDFAX2", "DDDFAX3" } )
md1FAZ( "MALA", "CIDADE", "ESTADO", { "DDD" } )
md1FAZ( "MB01", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX", "DDDPCP", "DDDFAXPCP" } )
md1FAZ( "MC01", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX", "DDDBIP" } )
md1FAZ( "MC01", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX", "DDDBIP" } )
md1FAZ( "MC02", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX", "DDDBIP" } )
md1FAZ( "MC03", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX", "DDDBIP" } )
md1FAZ( "MC04", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX", "DDDBIP" } )
md1FAZ( "MC05", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX", "DDDBIP" } )
md1FAZ( "MF02", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX" } )
md1FAZ( "MF03", "CIDADE1", "ESTADO1", {, "DDD1", "DDF1" } )
md1FAZ( "MF03", "CIDADE2", "ESTADO2", {, "DDD2", "DDF2" } )
md1FAZ( "MF05", "CIDADE1", "ESTADO1", {, "DDD1", "DDF1" } )
md1FAZ( "MF05", "CIDADE2", "ESTADO2", {, "DDD2", "DDF2" } )
md1FAZ( "MG01", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX", "DDDTLX" } )
md1FAZ( "benefic", "CIDADE", "UF", { "DDD" } )
md1FAZ( "curemp", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX" } )
md1FAZ( "FIRMA", "CIDADE", "ESTADO", { "DDD" } )
md1FAZ( "SINDICAT", "CIDADE", "ESTADO", { "DDD" } )
md1FAZ( "TOMADOR", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX" } )
md1FAZ( "VTOPER", "CIDADE", "ESTADO", { "DDD", "DDD1", "DDDFAX" } )
md1FAZ( "cnpjxml", "CIDADE", "UF", { "DDD" }, { { "CEP", "ENDERECO", "BAIRRO", "ENDTIP" } } )
md1FAZ( "cnpjxmlfec", "CIDADE", "UF", { "DDD" }, { { "CEP", "ENDERECO", "BAIRRO", "ENDTIP" } } )
md1FAZ( "sintcert", "CIDADE", "UF", { "DDD" }, { { "CEP", "ENDERECO", "BAIRRO", "ENDTIP" } } )
md1FAZ( "sintcertfec", "CIDADE", "UF", { "DDD" }, { { "CEP", "ENDERECO", "BAIRRO", "ENDTIP" } } )
md1FAZ( "sintpend", "CIDADE", "UF", { "DDD" } )
md1FAZ( "rhsel", "CIDADE", "ESTADO",, { { "CEP", "ENDER", "BAIRRO", "ENDTIP" } } )


// {{"CEP","ENDERECO","BAIRRO","ENDTIP"}} cCEP,eRUA,eBAI,eTIP //multidimensional pois pode ter mais de um endeteco
// {{"CEP","ENDER","BAIRRO","ENDTIP"}}


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MD1FAZ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MD1FAZ( cARQ, cESTADO, cCIDADE, aDDD, aCEP )

   aLAT := { "", "", "", "", "", "" }
   cARQ := AllTrim( cARQ )

   IF !USEREDE( cARQ, 1, 99 )
      RETU .F.
   ENDIF
   IF !USEREDE( "MD10", 1, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbSelectAr( "MD10" )
   dbGoTop()
   IF dbSeek( zESTADO + zCIDADE )  // LOCAL DE ORIGEM USADO PARA O CALCGEOKM
      aLAT[ 4 ] := LATITUDE
      aLAT[ 5 ] := LONGITUDE
      aLAT[ 6 ] := HEMISFERIO
   ENDIF

   dbSelectAr( cARQ )
   WHILE !Eof()
      mESTADO := &cESTADO.
      mCIDADE := &cCIDADE.
      IF mESTADO <> "XX" .AND. mESTADO <> "EX" .AND. mESTADO <> "??"
         dbSelectAr( "MD10" )
         dbGoTop()
         IF dbSeek( mESTADO + Upper( TIRACE( mCIDADE ) ) )
            lRETU     := .T.
            ZDDD      := DDD
            ZCEP      := INICEP
            ZCEPFIM   := FIMCEP
            ZRUA      := "C" + cCODIBGE
            aLAT[ 1 ] := LATITUDE
            aLAT[ 2 ] := LONGITUDE
            aLAT[ 3 ] := HEMISFERIO
            zKM       := calcgeokm( geotodec( aLAT[ 1 ], aLAT[ 3 ] ), geotodec( aLAT[ 2 ], aLAT[ 3 ] ), geotodec( aLAT[ 4 ], aLAT[ 6 ] ), geotodec( aLAT[ 5 ], aLAT[ 6 ] ) )
         ELSE
            ZDDD    := ""
            ZCEP    := ""
            ZCEPFIM := ""
            ZKM     := 0
            ZRUA    := ""
         ENDIF
         dbSelectAr( cARQ )
         IF ValType( aDDD ) = "A"
            FOR i := 1 TO Len( addd )
               cVAR := aDDD[ I ]
               cDDD := &cVAR.
               IF Empty( cDDD ) .AND. !Empty( zddd )
                  NETGRVCAM( cVAR, zDDD )
               ENDIF
            NEXT i
         ENDIF
         IF ValType( aCEP ) = "A"
            FOR i := 1 TO Len( aCEP )
               CHECK5CEP( aCEP[ I,  1 ], aCEP[ I,  2 ], aCEP[ I,  3 ], aCEP[ I,  4 ], .F. )  // CHECK5CEP(cCEP,eRUA,eBAI,eTIP,lMES)
            NEXT i
         ENDIF

      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MD1CHEK01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MD1CHEK01( eVAR )

   cDDD := AllTrim( &eVAR. )
   IF Empty( cDDD ) .AND. !Empty( zddd )
      NETGRVCAM( eVAR, zDDD )
   ENDIF

// if LEN(cDDD) <> 2 .and. !empty(zddd)
// NETGRVCAM(eVAR,zDDD)
// endif


// + EOF: m_d1.prg
// +
