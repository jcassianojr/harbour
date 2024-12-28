// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : flib05.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// //#INCLUDE "COMANDO.CH"
#include "INKEY.CH"
#include "BOX.CH"
#include "DBINFO.CH"


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
FUNC RFILORD( ARQWORK, lTIPO, cFILTRO, nINDICE )

// Arqwork se nao passado pega em uso e nao fecha Lopen
// Ltipo se falso nao pergunta ordem so filtro
// Sem tipo passa ""
   LOCAL cDBF    := Alias()
   LOCAL cINDICE := ""
   lOPEN := .T.
   IF ValType( lTIPO ) # "L"
      lTIPO := .T.
   ENDIF
   IF ValType( cFILTRO ) # "C"
      cFILTRO := ""
   ENDIF
   IF ValType( ARQWORK ) # "C"
      lOPEN := .F.
   ENDIF
   IF ValType( nINDICE ) # "N"
      nINDICE := 1
   ENDIF
   IF lOPEN
      IF !NETUSE( ARQWORK )
         RETU { "", cFILTRO }
      ENDIF
   ENDIF
   aESTRU := dbStruct()
   IF lOPEN
      dbCloseArea()
   ENDIF
   pESTRU := Len( aESTRU )
   dESTRU := Array( pESTRU )
// Pegando os Coment rios
   IF Empty( HELPARQ )
      ALERTX( "RFILORD: Variavel HelpARQ Em Branco" )
      RETU { IndexKey(), cFILTRO }
   ELSE
      IF netuse( helparq )   // AREDE( HELPARQ, HELPARQ, 0, .T. )
         FOR X := 1 TO pESTRU
            dbGoTop()
            IF dbSeek( PadR( ARQWORK, 8 ) + "M" + PadR( aESTRU[ X, 1 ], 9 ) )
               dESTRU[ X ] = DADO
            ELSE
               dESTRU[ X ] = PadR( aESTRU[ X, 1 ], 10 )
            ENDIF
         NEXT X
         dbCloseArea()
      ELSE
         FOR X := 1 TO pESTRU
            dESTRU[ X ] = PadR( aESTRU[ X, 1 ], 10 )
         NEXT X
      ENDIF
   ENDIF
   IF lTIPO
      // Escolhendo Ordem
      ORD_SCR := SaveScreen( 00, 00, 24, 79 )
      SetColor( "+GR/N" )
      hb_DispBox( 8, 0, 24, 79, B_DOUBLE + " " )
      SetColor( "+N/GR" )
      hb_DispBox( 8, 45, 10, 76, B_DOUBLE + " " )
      @ 09, 46 SAY "Escolha a ordem da Listagem"
      SetColor( "+W/BG" )
      hb_DispBox( 12, 45, 21, 76, B_DOUBLE + " " )
      @ 13, 46 SAY "Ande com as setas:"
      @ 15, 46 SAY " Quando a op‡„o desejada"
      @ 16, 46 SAY " estiver em destaque"
      @ 17, 46 SAY "    tecle enter."
      SetColor( "W/N" )
      DEFA := 1
      SET KEY K_ESC TO NOBREAK
      nINDICE := RCAMPO( nINDICE )
      SET KEY K_ESC TO
      cINDICE := if( nINDICE # 0, aESTRU[ nINDICE, 1 ], aESTRU[ 1, 1 ] )   // Defa Pos Achoice
      RestScreen( 00, 00, 24, 79, ORD_SCR )
   ENDIF
   cFILTRO := RFILTRO( cFILTRO )
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF
   RETU { cINDICE, cFILTRO }


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

FUNC RFILTRO( cFILTRO, DEFA )  // Filtro Inicial,Posi‡ao Inicial Achoice

   IF ValType( cFILTRO ) # "C"
      cFILTRO := ""
   ENDIF
   IF ValType( DEFA ) # "N"
      DEFA := 1
   ENDIF
   SAVE SCREEN
   SetColor( "+GR/N" )
   hb_DispBox( 8, 0, 24, 79, B_DOUBLE + " " )
   SetColor( "+N/GR" )
   hb_DispBox( 8, 45, 10, 76, B_DOUBLE + " " )
   @  9, 46 SAY "Escolha o grupo de dados"
   SetColor( "+GR/BG" )
   hb_DispBox( 12, 45, 21, 76, B_DOUBLE + " " )
   @ 13, 46 SAY "Ande com as setas:"
   @ 15, 46 SAY "Quando op‡„o desejada estiver"
   @ 16, 46 SAY "em destaque tecle enter."
   @ 17, 46 SAY "Forne‡a o  grupo de dados "
   @ 18, 46 SAY "dando os limites iniciais e"
   @ 19, 46 SAY "finais do grupo."
   @ 20, 46 SAY "Tecle ESC para encerrar."
   SetColor( "W/N,N/W" )
   WHILE .T.
      DFILTRO( cFILTRO )
      DEFA := RCAMPO( DEFA )
      IF DEFA = 0
         EXIT
      ENDIF
      XCTR1 := XCTR2 := MAKEVAR( aESTRU[ DEFA, 2 ], aESTRU[ DEFA, 3 ], aESTRU[ DEFA, 4 ] )
      XCTR3 := "E"
      XCTR5 := ">="
      TELAG := SaveScreen( 08, 16, 24, 79 )
      @ 08, 16 CLEA TO 24, 79
      hb_DispBox( 08, 17, 23, 79, B_DOUBLE + " " )
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
         cFILTRO := cFILTRO + Space( 80 )
         MDS( "" )
         @ 24, 00 GET cFILTRO PICT "@S78"
         READCUR()
         cFILTRO := AllTrim( cFILTRO )
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
            cFILTRO += if( Empty( cFILTRO ), "", XCTR4 ) + "(" + AllTrim( aESTRU[ DEFA, 1 ] ) + XCTR5 + XCTR1A + '.AND.' + AllTrim( aESTRU[ DEFA, 1 ] ) + XCTR6 + XCTR2A + ")"
         ELSE
            cFILTRO += if( Empty( cFILTRO ), "", XCTR4 ) + "(" + AllTrim( aESTRU[ DEFA, 1 ] ) + XCTR5 + XCTR1A + ")"
         ENDIF
      ENDIF
   ENDDO
   REST SCREEN
   SET KEY K_ALT_F TO
   SET KEY K_ALT_G TO
   RETU cFILTRO


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

FUNC RCAMPO

   @ 08, 00 CLEAR TO Min( pESTRU + 9, 21 ), 43
   @ 08, 00 TO Min( pESTRU + 9, 21 ), 43 DOUB
   RETU AChoice( 09, 02, Min( pESTRU + 9, 20 ), 41, dESTRU )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FILTRO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FILTRO( cFILTRO, nDEFA )

   aRETU := RFILORD(, .F., cFILTRO, nDEFA )

   RETURN aRETU[ 2 ]


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FILORD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FILORD( lINDEX )

   IF ValType( lINDEX ) <> "L"
      lINDEX := .F.
   ENDIF
   IF lINDEX
      nIndexes  := dbOrderInfo( DBOI_ORDERCOUNT )
      aNtxNames := {}
      FOR i := 1 TO nIndexes
         AAdd( aNtxNames, dbOrderInfo( DBOI_NAME,, i ) + " - " + dbOrderInfo( DBOI_EXPRESSION,, i ) )
      NEXT
      IF nIndexes > 1
         nRESP := AChoice( 6, 6, 16, 74, aNTXNAMES )
         IF LastKey() = 13
            INX    := nRESP
            FILTRO := FILTRO( FILTRO )
            // ALERTX(STR(INX))
            // ALERTX(FILTRO)
            RETURN
         ENDIF
      ENDIF
   ENDIF
   aRETU  := RFILORD(, .T., FILTRO )  // Filtro e variavel padrao
   INX    := aRETU[ 1 ]  // inx variavel padrao
   FILTRO := aRETU[ 2 ]

   RETURN



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
FUNCTION DFILTRO( TFILTRO )

   TFILTRO := StrTran( TFILTRO, ".AND.", " E " )
   TFILTRO := StrTran( TFILTRO, ".OR.", " OU " )
   TFILTRO := StrTran( TFILTRO, "MONTH", "MES" )
   TFILTRO := StrTran( TFILTRO, "YEAR", "ANO" )
   TFILTRO := StrTran( TFILTRO, "EMPTY", "SEM" )
   TFILTRO := StrTran( TFILTRO, "DTOC", "DIA" )
   TFILTRO := StrTran( TFILTRO, "!", " NAO " )
   MDS( TFILTRO )
   RETU TFILTRO


// + EOF: flib05.prg
// +
