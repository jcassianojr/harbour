// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aw2.prg
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



PADRAO( 1, 1, 0, cMW02, "Pedido   Ite Requisi  Codigo" + spac( 25 ) + "Quantidade", ;
      "' '+STR(mCOMPED,8)+' '+STR(mITEM,3)+' '+STR(mITEREC,8)+' '+mITENOM+' '+STR(mITEQTD,12,3)", ;
      "MAW2",,, {|| MAW2INC() }, {|| PADARR( cMW02, Str( xCOMPED, 8 ), "COMPED", "xCOMPED" ) },,,,, ;
      {|| MAW2REP() },, {|| MAW2DEL() },, .F. )






// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW2INC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAW2INC

   mCOMPED := xCOMPED
   ULTIMOITEM( cMW02, Str( xCOMPED, 8 ), "COMPED", "XCOMPED", "ITEM", "mITEM", .T. )
   MDS( "Digite o ITEM" )
   @ 24, 20 GET mITEM VALID mITEM > 0 .AND. mITEM < 999
   READCUR()
   mCHAVE := Str( mCOMPED, 8 ) + Str( mITEM, 3 )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW2REP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW2REP

   LOCAL cNORMA

   IF INCLUI .AND. !Empty( mITEREC )
      GRAVAMVAR( "MW04", mITEREC, { "RELQTDP", "RELQTDS" }, { "RELQTDP+mITEQTD", "RELQTDI-RELQTDP" } )
      IF IGUALVARS( "MW04", mITEREC )
         IF mRELQTDS <= 0
            APAGAREG( "MW04", mITEREC, .F., .F. )
         ENDIF
         mRECPED  := mCOMPED
         mRECPI   := mITEM
         mRECPD   := ZDATA
         mRELQTDI := mRELQTDS + mITEQTD
         mRELQTDP := mITEQTD
         NOVOREG( "MW04PG", Str( mITEREC, 8 ) + Str( mCOMPED, 8 ) + Str( mITEM, 3 ) )
      ENDIF
   ENDIF
// MW08CHK01() //Checar Precos
// movido posrep m_aw.prg funcao MAW01
   IF MDG( "Rever Programacao de Entrega" )
      xITEM   := mITEM
      xITECOD := mITECOD
      PADRAO( 0, 1, 0, cMW03, "Pedido   Itp Ite Entregar Fornecedor" + spac( 12 ) + "Codigo" + spac( 7 ) + "Saldo", ;
         "' '+STR(mCOMPED,  8)+' '+STR(mITEM,  3)+' '+STR(mITEENT,  3)+' '+DTOC(mDATENT)+' '+STR(mCOMFOR,  8)+' '+mCOMCOG+' '+mITECOD+' '+STR(mQTDSAL, 12, 3)", ;
         "MAW3",,, {|| MAW301() }, {|| PADARR( cMW03, Str( xCOMPED, 8 ) + Str( xITEM, 3 ), "STR(COMPED,8)+STR(ITEM,3)", "STR(xCOMPED,8)+STR(xITEM,3)" ) },,,,, {|| MAW3REP() } )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW301()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW301

   mCOMPED := xCOMPED
   mITEM   := xITEM
   mITECOD := xITECOD
   mCOMFOR := xCOMFOR
   mCOMCOG := xCOMCOG
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW3REP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW3REP  // Nao Apagar Uso Especial

   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW201()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW201

   DO CASE
   CASE mITETIP = "M"
      PEGACAMPO( "MU01", "mITECOD", { "PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)", "CTACONTB", "UNIDADE", "CODMW" }, { "mITENOM", "mITECTA", "mITEUNI", "mCODMW" } )
   CASE mITETIP = "C"
      PEGACAMPO( "MT01", "mITECOD", { "PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)", "CTACONTB", "UNIDADE" }, { "mITENOM", "mITECTA", "mITEUNI" } )
   CASE mITETIP = "O"
      PEGACAMPO( "MW05", "mITECOD", { "PADR(NOME,200)", "CTACONTB", "UNIDADE" }, { "mITENOM", "mITECTA", "mITEUNI" } )
   CASE mITETIP = "R"
      PEGACAMPO( "MW07", "mITECOD", { "PADR(NOME,200)", "CTACONTB", "UNIDADE" }, { "mITENOM", "mITECTA", "mITEUNI" } )
   CASE mITETIP = "I"
      PEGACAMPO( "ME04", "mITECOD", { "PADR(TRIM(TIPO)+' '+TRIM(MARCA)+' Cap.: '+TRIM(CAPACI)+' Div.: '+TRIM(DIVI),200)" }, { "mITENOM" } )
   CASE mITETIP = "T"
      PEGACAMPO( "MP03", "mITECOD", { "PADR(NOM2,200)", "APLICACAO" }, { "mITENOM", "mITEO01" } )
   ENDCASE
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW202()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW202

   PRIV cVAR1 := cVAR2 := "X"

   IF !Empty( mITEREC )
      PEGACAMPO( "MW04", "mITEREC", { "LIRER", "LICER" }, { "cVAR1", "cVAR2" } )
      IF cVAR1 = "X"
         ALERTX( "Requisi‡„o N„o Cadastrada" )
         RETU .T.
      ENDIF
      IF cVAR1 # "S"
         ALERTX( "Requisi‡„o N„o Liberada" )
         RETU .F.
      ENDIF
      IF cVAR2 # "S"
         ALERTX( "Requisi‡„o N„o Checada Compras" )
         RETU .F.
      ENDIF
   ENDIF
   IF INCLUI
      PEGACAMPO( "MW04", "mITEREC", { "RECTIP", "RECCOD", "RECNOM", "RECNO2", "RECDAT", "RECUE", "RECSOL", "RECCTA", "RELQTDS", "RECUND", "RECO01", "RECO02", "RECO03" }, ;
         { "mITETIP", "mITECOD", "mITENOM", "mITENO2", "mRECDAT", "mITEUE", "mITESOL", "mCODDEP", "mITEQTD", "mITEUNI", "mRECO01", "mRECO02", "mRECO03" } )

   ENDIF
   @ 14, 1 SAY mRECO01
   @ 15, 1 SAY mRECO02
   @ 16, 1 SAY mRECO03
   IF !INCLUI .AND. !Empty( mITEREC )
      IF PEGACAMPO( "MW04", "mITEREC", { "RECCTR" }, { "cVAR1" } )
         cVAR2 := mITEREC
         IF cVAR1 = "A"
            IF MDG( "Contrato Anual - Baixar Requisi‡„o" )
               IF IGUALVARS( "MW04", cVAR2 )
                  IF NOVOREG( "MW04PG", cVAR2 )
                     APAGAREG( "MW04", cVAR2 )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW2DEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW2DEL()

   LOCAL aVAL

// ALERTX("Bloco Del")
// Apaga a Ultimo Preco Cadastro
   GRAVAMVAR( ESTQARQ( mITETIP, 1 ), mITECOD, { "ULTPRC", "ULTUND", "ULTDATA" }, { "0", "SPACE(2)", "CTOD(SPACE(8))" } )
// Apaga o Ultimo Preco MW08
   IF USEREDE( "MW08", 1, 99 )
      dbSetOrder( 4 )  // Pedido
      dbGoTop()
      dbSeek( mCOMPED )
      WHILE mCOMPED = COMPED .AND. !Eof()
         IF mITEM = ITEM
            netrecdel()
         ENDIF
         dbSkip()
      ENDDO
      aVAL := { 0, "", CToD( Space( 8 ) ) }
      dbSetOrder( 2 )  // Ultimo Preco Codigo
      dbSelectAr( "MW08" )
      dbGoTop()
      dbSeek( mITETIP + mITECOD )
      IF ITETIP = mITETIP .AND. AllTrim( ITECOD ) == AllTrim( mITECOD )
         aVAL := { ITEPRC, ITEUNI, DATA }
      ENDIF
      dbCloseArea()
      IF aVAL[ 1 ] > 0
         MAWULTPRC( ESTQARQ( mITETIP, 1 ), mITECOD, aVAL )
      ENDIF
   ENDIF
   RETU .T.


// + EOF: m_aw2.prg
// +
