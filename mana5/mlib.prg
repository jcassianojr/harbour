// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function REPORVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC REPORVARS( cARQ, eBUSCA )   // PARAMETRO ARQUIVO, E CHAVE DE BUSCA

   RETORNO := .F.
   IF !USEREDE( cARQ, 1, 99 )
      RETU .F.
   ENDIF
   dbGoTop()
   IF dbSeek( eBUSCA )
      KEY := 0
      WHILE !dbRLock( RecNo() ) .AND. KEY # 27
         KEY := Inkey( 0.5 )
      ENDDO
      IF KEY # 27
         REPLVARS()  // Funcao da Develop.Lib
         RETORNO := .T.
      ENDIF
   ENDIF
   dbUnlock()
   dbCommit()
   dbCloseArea()
   IF !RETORNO
      ALERTX( "N„o encontrei o registro" )
   ENDIF
   gravalog( eBUSCA, "ALT", cARQ )
   RETU RETORNO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IGUALVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IGUALVARS( cARQ, eBUSCA, nIND, lMES )   // PARAMETRO ARQUIVO, E CHAVE DE BUSCA

   RETORNO := .F.
   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF

   IF !USEREDE( cARQ, 1, nIND )
      RETU .F.
   ENDIF
   dbGoTop()
   IF dbSeek( eBUSCA )
      EQUVARS()
      RETORNO := .T.
   ENDIF
   dbUnlock()
   dbCommit()
   dbCloseArea()
   IF !RETORNO .AND. lMES
      ALERTX( "N„o encontrei o registro" )
   ENDIF
   RETU RETORNO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NUMIND()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NUMIND( cARQ, nPOS )

   LOCAL nIND    := 1
   LOCAL aNUMIND := {}
   LOCAL mDBF    := Alias()

   SET COLOR TO
   IF ValType( nPOS ) # "N"
      nPOS := 1
   ENDIF
   nPOS := if( nPOS = 0, 1, nPOS )
   IF !USEREDE( zARQ1, 1, 1 )
      RETU 1
   ENDIF
   dbSeek( PadR( cARQ, 8 ) + Str( 1, 2 ) )
   WHILE ARQUIVO = PadR( cARQ, 8 ) .AND. !Eof()
      AAdd( aNUMIND, DESC )
      dbSkip()
   ENDDO
   dbCloseArea()
   IF Len( aNUMIND ) = 0
      RETU 1
   ENDIF
   nPOS := if( nPOS > Len( aNUMIND ), 1, nPOS )
   nIND := ESCARR( aNUMIND, 4, 5, 24 - 3, 63, nPOS, "Escolha a Ordem Desejada" )
   nIND := if( nIND > 0, nIND, 1 )
   IF !Empty( mDBF )
      dbSelectAr( mDBF )
   ENDIF
   RETU nIND



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NUMFIL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NUMFIL( nPOS )

   LOCAL nFIL := 1

   aNUMFIL := { "1 - Filtro Padr„o ", "2 - Condicional Fixo ", ;
      "3 - Filtro Busca ", "4 - Condicional Filtro", ;
      "5 - Condicional Localizar" }
   IF ValType( nPOS ) # "N"
      nPOS := 1
   ENDIF
   nPOS := if( nPOS = 0 .OR. nPOS > 4, 1, nPOS )
   nPOS := if( nPOS > Len( aNUMFIL ), 1, nPOS )
   nFIL := ESCARR( aNUMFIL, 4, 5, 24 - 3, 63, nPOS, "Escolha o Filtro Desejado" )
   nFIL := if( nFIL > 0, nFIL, 1 )
   RETU nFIL



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RFILTRO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC RFILTRO( FILTRO, DEFA )

   LOCAL pCOR  := SetColor()
   LOCAL pTELA := SaveScreen( 8, 0, 24, 79 )

   SetColor( 'N/W,' + zCOR002 )
   hb_DispBox( 8, 45, 10, 75, B_DOUBLE, 'W' )
   @  9, 48 SAY "Escolha o grupo de dados"
   hb_DispBox( 12, 45, 22, 75, B_DOUBLE, 'W' )
   @ 13, 46 SAY " Ande com as setas. Quando a"
   @ 14, 46 SAY " op‡„o  desejada estiver  em"
   @ 15, 46 SAY " destaque tecle         .   "
   @ 16, 46 SAY " Forne‡a o grupo  de  dados "
   @ 17, 46 SAY " dando os limites iniciais e"
   @ 18, 46 SAY " finais do grupo.           "
   @ 20, 46 SAY " Tecle     para encerrar.   "
   SetColor( "R/W" )
   @ 15, 63 SAY "<Enter>"
   @ 20, 53 SAY "ESC"
   SetColor( 'N/W,' + zCOR002 )
   IF PCount() = 0
      FILTRO := ''
      DEFA   := 1
   ELSEIF PCount() = 1
      DEFA := 1
   ENDIF
   WHILE .T.
      DFILTRO( FILTRO )
      DEFA := RCAMPO( DEFA )
      IF DEFA = 0
         EXIT
      ENDIF
      XCTR1 := XCTR2 := MAKEVAR( aESTRU[ DEFA, 2 ], aESTRU[ DEFA, 3 ], aESTRU[ DEFA, 4 ] )
      XCTR3 := "E"
      XCTR5 := ">="
      TELAG := SaveScreen( 08, 16, 24, 79 )
      @ 08, 16 CLEA TO 24, 79
      hb_DispBox( 08, 17, 23, 79, B_DOUBLE )
      @ 09, 20 SAY "Forne‡a os Limites inicial e Final do(a)"
      @ 10, 20 SAY dESTRU[ DEFA ]
      @ 11, 17 SAY '+' + repl( '-', 61 ) + 'Ý'
      @ 12, 20 SAY 'Do '
      @ 13, 17 SAY '+' + repl( '-', 61 ) + 'Ý'
      @ 14, 20 SAY 'Ao '
      @ 15, 17 SAY '+' + repl( '-', 61 ) + 'Ý'
      @ 16, 20 SAY '(E) (O)u (B)ranco (M)anual'
      @ 17, 20 SAY "Opera‡ao: >= <= <> > <"
      SET KEY K_ESC TO NOBREAK
      @ 12, 23 GET XCTR1
      @ 14, 23 GET XCTR2
      @ 16, 50 GET XCTR3 VALID XCTR3 $ "EOBM"
      @ 17, 50 GET XCTR5 VALID Trim( XCTR5 ) $ "<>=" .OR. XCTR5 = ">=" .OR. XCTR5 = "<=" .OR. xCTR5 = "<>"
      READCUR()
      IF XCTR3 = "M"
         FILTRO += Space( 80 )
         @ 24, 00 GET FILTRO PICT "@S78"
         READCUR()
         FILTRO := AllTrim( FILTRO )
      ENDIF
      SET KEY K_ESC TO
      RestScreen( 08, 16, 24, 79, TELAG )
      DO CASE
      CASE aESTRU[ DEFA, 2 ] = "C"
         XCTR1A := '"' + AllTrim( XCTR1 ) + '"'
         XCTR2A := '"' + AllTrim( XCTR2 ) + '"'
      CASE aESTRU[ DEFA, 2 ] = "D"
         XCTR1A := 'CTOD(' + '"' + DToC( XCTR1 ) + '"' + ')'
         XCTR2A := 'CTOD(' + '"' + DToC( XCTR2 ) + '"' + ')'
      CASE aESTRU[ DEFA, 2 ] = "N"
         XCTR1A := AllTrim( Str( XCTR1, aESTRU[ DEFA, 3 ], aESTRU[ DEFA, 4 ] ) )
         XCTR2A := AllTrim( Str( XCTR2, aESTRU[ DEFA, 3 ], aESTRU[ DEFA, 4 ] ) )
      ENDCASE
      IF !Empty( XCTR1 ) .OR. !Empty( XCTR2 ) .OR. XCTR3 = "B"
         XCTR4 := ".AND."
         IF XCTR3 = "O"
            XCTR4 := ".OR."
         ENDIF
         IF !Empty( XCTR2 )
            XCTR6 := "<="
            IF XCTR5 = "> "
               XCTR6 := "<"
            ENDIF
            FILTRO += if( Empty( FILTRO ), "", XCTR4 ) + "(" + AllTrim( aESTRU[ DEFA, 1 ] ) + XCTR5 + XCTR1A + '.AND.' + AllTrim( aESTRU[ DEFA, 1 ] ) + XCTR6 + XCTR2A + ")"
         ELSE
            FILTRO += if( Empty( FILTRO ), "", XCTR4 ) + "(" + AllTrim( aESTRU[ DEFA, 1 ] ) + XCTR5 + XCTR1A + ")"
         ENDIF
      ENDIF
   ENDDO
   RestScreen( 8, 0, 24, 79, pTELA )
   SET KEY K_ALT_F TO
   SET KEY K_ALT_G TO
   SetColor( pCOR )
   RETU FILTRO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RFILORD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC RFILORD

   PARA ARQWORK, lTIPO, FILTRO, nDEFA
   PRIV pCOR   := SetColor()
   PRIV FECHAR := .F.
   PRIV DBF    := Alias()

   IF ValType( lTIPO ) # "L"
      lTIPO := .T.
   ENDIF
   IF ValType( FILTRO ) # "C"
      FILTRO := ""
   ENDIF
   IF ValType( nDEFA ) # "N"
      nDEFA := 1
   ENDIF
// Pegando a Estrutura
   IF SELECT ( ARQWORK ) = 0
      IF !USEREDE( ARQWORK, 1, 0 )
         RETU FILTRO
      ENDIF
      FECHAR := .T.
   ELSE
      dbSelectAr( ARQWORK )
   ENDIF
   aESTRU := dbStruct()
   IF FECHAR
      dbCloseArea()
   ENDIF
   pESTRU := Len( aESTRU )
   dESTRU := Array( pESTRU )
// Pegando os Coment rios
   IF !USEREDE( HELPARQ, 1, 1 )
      RETU FILTRO
   ENDIF
   FOR X := 1 TO pESTRU
      dbGoTop()
      IF dbSeek( PadR( ARQWORK, 8 ) + "M" + PadR( aESTRU[ X, 1 ], 9 ) )
         IF !Empty( DADO )
            dESTRU[ X ] = DADO
         ELSE
            dESTRU[ X ] = PadR( aESTRU[ X, 1 ], 10 )
         ENDIF
      ELSE
         dESTRU[ X ] = PadR( aESTRU[ X, 1 ], 10 )
      ENDIF
   NEXT X
   dbCloseArea()
   IF lTIPO
      // Escolhendo Ordem
      ORD_SCR := SaveScreen( 5, 0, 24, 79 )
      SetColor( 'N/W,' + zCOR002 )
      hb_DispBox( 5, 45, 10, 76, B_DOUBLE, 'W' )
      @ 09, 46 SAY "Escolha a ordem da Listagem"
      hb_DispBox( 12, 45, 22, 76, B_DOUBLE, 'W' )
      @ 13, 46 SAY " Ande com as setas:"
      @ 15, 46 SAY " Quando a op‡„o desejada"
      @ 16, 46 SAY " estiver  em  destaque"
      @ 17, 46 SAY " tecle         ."
      SetColor( "R/W" )
      @ 17, 54 SAY "<Enter>"
      SetColor( 'N/W,' + zCOR002 )
      SET KEY K_ESC TO NOBREAK
      DEFA := RCAMPO( DEFA, nDEFA )
      SET KEY K_ESC TO
      INX := if( DEFA # 0, aESTRU[ DEFA, 1 ], aESTRU[ 1, 1 ] )
      RestScreen( 5, 0, 24, 79, ORD_SCR )
   ENDIF
// Escolhendo o Filtro
   FILTRO := RFILTRO( FILTRO, nDEFA )
   SetColor( pCOR )
   IF !Empty( DBF )
      dbSelectAr( DBF )
   ENDIF
   RETU FILTRO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RCAMPO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC RCAMPO( nINIPOS )

   IF ValType( nINIPOS ) # "N"
      nINIPOS := 1
   ENDIF
   RETU ESCARR( dESTRU, 8, 0, Min( pESTRU + 11, 24 - 1 ), 43, nINIPOS )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DFILTRO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC DFILTRO( TFILTRO )

   TFILTRO := StrTran( TFILTRO, ".AND.", " E " )
   TFILTRO := StrTran( TFILTRO, ".OR.", " OU " )
   TFILTRO := StrTran( TFILTRO, "MONTH", "MES" )
   TFILTRO := StrTran( TFILTRO, "YEAR", "ANO" )
   TFILTRO := StrTran( TFILTRO, "EMPTY", "SEM" )
   TFILTRO := StrTran( TFILTRO, "DTOC", "DIA" )
   TFILTRO := StrTran( TFILTRO, "!", " NAO " )
   MDS( TFILTRO )
   RETU TFILTRO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OBTER()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC OBTER( cARQ, KEYINDEX, cCAMPO, nIND, nROW, nCOL, cMES, cMES2, cDEF )   // SEEK MAIS RETORNO CAMPO

   LOCAL cDBF   := Alias()
   LOCAL FECHAR := .F.
   LOCAL cRETU  := ""

   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   IF ValType( cDEF ) # "U"
      cRETU := cDEF
   ENDIF
   IF SELECT ( cARQ ) = 0
      IF !USEREDE( cARQ, 1, nIND )
         RETU cRETU
      ENDIF
      FECHAR := .T.
   ELSE
      dbSelectAr( cARQ )
      IF nIND > 1
         dbSetOrder( nIND )
      ENDIF
   ENDIF
   dbGoTop()
   IF dbSeek( keyindex )
      cRETU := &cCAMPO.
   ELSE
      IF ValType( cDEF ) = "U"
         cRETU := MAKE_EMPTY( cCAMPO )
      ENDIF
   ENDIF
   IF ValType( nROW ) = "N"
      IF !Empty( cRETU )
         @ nROW, nCOL SAY &cMES.
      ELSE
         @ nROW, nCOL SAY &cMES2.
      ENDIF
   ENDIF
   IF FECHAR
      dbCloseArea()
   ENDIF
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF
   RETU cRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MUDADATA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MUDADATA( cPRG, nLIN, cVAR )

   PRIV GETLIST := {}

   IF Type( "ZDATA" ) # 'D'
      ZDATA := DXDIA
   ENDIF
   MDS( "Digite a Data Operacional" )
   @ 24, 40 GET ZDATA
   READCUR()
   ZDIA := Day( ZDATA )
   ZMES := Month( ZDATA )
   ZANO := Year( ZDATA )
   IF cPRG = "READCUR"
      SetCursor( if( ReadInsert(), 1, 2 ) )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CONFIND()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CONFIND( cARQ )

   aIND := {}
   IF !USEREDE( zARQ1, 1, 1 )
      ALERTX( "N„o Consegui Pegar Configura‡„o de Busca" )
      RETU .F.
   ENDIF
   dbGoTop()
   IF !dbSeek( PadR( cARQ, 8 ) + Str( 1, 2 ) )
      dbCloseArea()
      ALERTX( "N„o Encontrei Configura‡„o de Busca" )
      RETU .F.
   ENDIF
   WHILE PadR( cARQ, 8 ) = ARQUIVO .AND. !Eof()
      AAdd( aIND, { { LIN1, COL1, VAR1, DES1 }, { LIN2, COL2, VAR2, DES2 }, { LIN3, COL3, VAR3, DES3 }, FORMULA } )
      dbSkip()
   ENDDO
   dbCloseArea()
   IF Len( aIND ) = 0
      ALERTX( "Falta Configura‡„o de Busca" )
      RETU .F.
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MONTATAB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MONTATAB( cNOMETAB, cNOMEARR1, cNOMEARR2, cSTR1, cSTR2 )

   aUM := {}
   aDO := {}
   IF !USEREDE( "MD02", 1, 1 )
      RETU .T.
   ENDIF
   GRAF  := LastRec()
   xGRAF := 0
   xPOS  := 1
   MARCAR()
   dbGoTop()
   dbSeek( PadR( cNOMETAB, 12 ) )
   WHILE CODIGO = cNOMETAB .AND. !Eof()
      IF ValType( cSTR1 ) # "C"
         AAdd( aUM, CODIGO1 + ' ' + DESCRICAO )
      ELSE
         AAdd( aUM, &cSTR1. )
      ENDIF
      IF ValType( cSTR2 ) # "C"
         AAdd( aDO, CODIGO1 )
      ELSE
         AAdd( aDO, &cSTR2. )
      ENDIF
      xPOS++
      MARCAR1()
      dbSkip()
   ENDDO
   dbCloseArea()
   &cNOMEARR1. := AClone( aUM )
   &cNOMEARR2. := AClone( aDO )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IMP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IMP( cCOD, cIMP )

   LOCAL cCODRET := ""
   LOCAL DBF_USO := Alias()

   IF ValType( cIMP ) # "C"
      cIMP := ZIMPPAD
   ENDIF
   IF !USEREDE( "CODIMP", 1, 1 )
      IF !Empty( DBF_USO )
         SELE &DBF_USO
      ENDIF
      RETU ""
   ENDIF
   dbGoTop()
   IF dbSeek( PadR( cCOD, 6 ) + cIMP )
      cCODRET := CONTEUDO
   ENDIF
   dbCloseArea()
   IF !Empty( DBF_USO )
      SELE &DBF_USO
   ENDIF
   IF !Empty( cCODRET )
      cCODRET := &cCODRET.
      IF Type( "nTIPSPO" ) # "U" .AND. ( nTIPSPO = 1 .OR. nTIPSPO > 5 )
         cCODRET := RANGEREPL( Chr( 0 ), Chr( 31 ), cCODRET, "" )
      ENDIF
      IF At( "CHR(", cCODRET ) > 0
         IF nTIPSPO = 1 .OR. nTIPSPO > 5   // video txt txtwin rtf html pdf
            cCODRET := ""
         ENDIF
      ENDIF
      cCODRET := AllTrim( cCODRET )
   ENDIF
   RETU cCODRET



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKCC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CHECKCC( cEXP, cARQ, cVAR, lVAZIO )

   LOCAL lRETU  := .F.
   LOCAL nBUSCA
   PRIV lCONVCC := .F.

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   IF ValType( lVAZIO ) # "L"
      lVAZIO := .T.
   ENDIF
   IF ValType( cARQ ) # "C"
      cARQ := "MI01"
   ENDIF
   IF ValType( cEXP ) # "C"
      cEXP := "mCTACONTB"
   ENDIF
   nBUSCA := &cEXP.
   IF Empty( nBUSCA )
      MDS( "Conta n„o Digitada" )
      RETU .T.
   ENDIF
   IF ZLANC = 1
      IF ValType( nBUSCA ) = "C"
         nBUSCA  := Val( nBUSCA )
         lCONVCC := .T.
      ENDIF
   ELSE
      nBUSCA := AllTrim( StrTran( nBUSCA, ".", "" ) )
   ENDIF
   lRETU := CHECKEXI( cARQ, cEXP, "CONTA+' '+NOME", "IF(ZLANC=0,CONTA,IF(lCONVCC,PADR(ALLTRIM(STR(NUMERO)),12),NUMERO))", "MAI001", lVAZIO,,, if( ZLANC = 0, 1, 2 ) )
   IF lRETU .AND. ZLANC = 1 .AND. ValType( cVAR ) = "C"  // Reduzida Traz Conta
      &cVAR. := OBTER( cARQ, nBUSCA, "CONTA", 2 )
   ENDIF
   IF lRETU .AND. ZLANC = 0 .AND. ValType( cVAR ) = "C"  // Normal Tras Reduzida
      &cVAR. := OBTER( cARQ, nBUSCA, "NUMERO", 1 )
   ENDIF
   RETU lRETU


// + EOF: mlib.prg
// +
