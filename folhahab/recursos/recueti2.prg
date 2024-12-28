// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : recueti2.prg
// +
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   RECUETI2.PRG: CONFIGURADA
// :      Linguagem: Harbour
// :        Sistema: RECURSOS
// :      Copyright (c) 2024,  jcassiano
// :  Atualizado em:
// :
// :*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RECUETI2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION RECUETI2()

   WHILE .T.
      @ 13, 00 CLEAR
      SetColor( "W/G" )
      @ 13, 27 CLEAR TO 15, 51
      @ 13, 27 TO 15, 51 DOUB
      OPCAO( 14, 29, ' &Imprimir ', 73 )
      OPCAO( 14, 39, ' &Editar   ', 69 )
      OPCAO1 := MENU(, 0 )
      SetColor( "W/N" )
      IF OPCAO1 = 0
         EXIT
      ENDIF
      SAVE SCREEN TO TELA_2
      EDITA()
      REST SCREEN FROM TELA_2
   ENDDO

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function EDITA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION EDITA

   IMPRIME := .F.
   @ 08, 00 CLEAR
   PES1 := SPAC( 12 )
   IF !netuse( "ETIQ2" )   // BREDE("ETIQ2",0)
      RETU
   ENDIF
   IF !NETUSE( "ETIQ3" )   // AREDE("ETIQ3","ETIQ3",0)
      dbSelectAr( "ETIQ2" )
      dbCloseArea()
      RETU
   ENDIF
   dbGoTop()
   IF !NSHOW1()
      RETU
   ENDIF

   DECLARE _CAMPO[ 1 ]
   _CAMPO[ 1 ] = "' '+CODIGO+' '+DESCRICAO+' '"
   @ 08, 00 CLEAR TO 21, 79
   SetColor( "W/G" )
   @ 08, 00 CLEAR TO 21, 48
   @ 08, 00 TO 21, 48 DOUB
   @ 08, 03 SAY 'C¢digo'
   @ 08, 16 SAY 'Descri‡ao'
   PCK := .F.
   dbEdit( 09, 02, 20, 47, _CAMPO, "CA", .T., "", "", "", "", "" )
   SetColor( "W/N" )
   SetCursor( 1 )

   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CA

   PARA MODO

   KEY := LastKey()
   DO CASE
   CASE MODO < 4
      RETU ( 1 )
   CASE KEY = 7
      SetCursor( 1 )
      DELEREC()
      SetCursor( 0 )
      RETU ( 2 )
   CASE KEY = 10
      MDS( 'Digite o c¢digo:' )
      @ 23, 40 GET PES1
      READCUR()
      @ 22, 00
      IF LastKey() <> 27
         REC := RecNo()
         dbGoTop()
         IF !dbSeek( PES1 )
            MDT( 'Nao encontrado' )
            dbGoto( REC )
         ENDIF
      ENDIF
      RETU ( 1 )
   CASE KEY = 13 .OR. KEY = 22
      TELA := SaveScreen( 08, 00, 22, 79 )
      IF OPCAO1 = 2
         IF KEY = 22
            NETRECAPP()
            @ Row() + 1, 3 GET CODIGO
         ELSEIF KEY = 13
            @ Row(), 3 GET CODIGO
         ENDIF
         @ Row(), Col() + 1 GET DESCRICAO
         READCUR()
         IF LastKey() = 27
            IF KEY = 22
               NETRECDEL()
               ANT := SetColor()
               SetColor( "W/G" )
               @ 08, 00 CLEAR TO 20, 48
               @ 08, 00 TO 20, 48 DOUB
               @ 08, 03 SAY 'C¢digo'
               @ 08, 16 SAY 'Descri‡ao'
               SetColor( ANT )
               RELEASE ANT
            ENDIF
            // * ALTERADO EM 5/8/92
            RETU ( 27 )
         ENDIF
         PRIV DBTELA, COR_ANT
         COR_ANT := SetColor()
         DBTELA  := SaveScreen( 00, 00, 24, 79 )
         SetColor( "+W/BR" )
         @ 08, 00 CLEAR TO 22, 79
         @ 08, 00 TO 22, 79 DOUB
         SET DELI TO "[]"
         SET DELI ON
         @ 09, 02 SAY 'Arq.1:'
         @ 10, 02 SAY 'Chv.1:'
         @ 11, 02 SAY 'Campo:'
         @ 12, 02 SAY 'Arq.2:'
         @ 13, 02 SAY 'Chv.2:'
         @ 14, 02 SAY 'Lin.1:'
         @ 15, 02 SAY 'Lin.2:'
         @ 16, 02 SAY 'Lin.3:'
         @ 17, 02 SAY 'Lin.4:'
         @ 18, 02 SAY 'Lin.5:'
         @ 19, 02 SAY 'Lin.6:'
         @ 20, 02 SAY 'Lin.7:'
         @ 21, 02 SAY 'Lin.8:'
         SetCursor( 1 )
         CONTINUA := .F.
         IF Empty( ARQUIVO )
            CONTINUA := .T.
         ELSE
            @ 09, 09      SAY ARQUIVO
            @ 10, 09      SAY CHAVE
            @ 11, 09      SAY CAMPO
            @ 11, Col() + 1 SAY '(Relacionado)'
            @ 12, 09      SAY ARQUIVO2
            @ 13, 09      SAY CHAVE2
            IF MDG( 'Revisa os Arquivos' )
               CONTINUA := .T.
            ENDIF
         ENDIF
         IF CONTINUA
            @ 09, 02 SAY 'Arq.1:' GET ARQUIVO VALID ARQ( ARQUIVO )
            READCUR()
            IF LastKey() = 27
               SetColor( COR_ANT )
               SetCursor( 0 )
               SET DELI OFF
               RestScreen( 00, 00, 24, 79, DBTELA )
               RETU ( 2 )
            ENDIF
            XARQUIVO := AllTrim( ARQUIVO )
            PRIVA ANT_SEL
            ANT_SEL := SELECT ()
            // ********
            IF !netuse( XARQUIVO )   // BREDE(XARQUIVO,0)
               RETU
            ENDIF
            cSELE10 := Alias()
            // ********
            SAVE SCREEN
            MDS( 'Escolha a ordem da listagem' )
            aESTRU := dbStruct()
            pESTRU := Len( aESTRU )
            dESTRU := Array( pESTRU )
            FOR Z := 1 TO pESTRU
               dESTRU[ Z ] = PadR( aESTRU[ Z, 1 ], 10 )
            NEXT Z
            DEFA := 1
            DEFA := RCAMPO( DEFA )
            IF DEFA = 0
               DEFA := 1
            ENDIF
            CHAVEARQ1 := FieldName( DEFA )
            SELECT ( ANT_SEL )
            REPL CHAVE WITH CHAVEARQ1
            REST SCREEN
            @ 10, 09 SAY CHAVE
            IF MDG( 'Relacionar Arquivos?' )
               dbSelectAr( cSELE10 )
               SAVE SCREEN
               MDS( 'Escolha a campo relacionado' )
               aESTRU := dbStruct()
               pESTRU := Len( aESTRU )
               dESTRU := Array( pESTRU )
               FOR Z := 1 TO pESTRU
                  dESTRU[ Z ] = PadR( aESTRU[ Z, 1 ], 10 )
               NEXT Z
               DEFA := 1
               DEFA := RCAMPO( DEFA )
               IF DEFA = 0
                  DEFA := 1
               ENDIF
               CAMPOREL := FieldName( DEFA )
               SELECT ( ANT_SEL )
               REPL CAMPO WITH CAMPOREL
               REST SCREEN
               @ 11, 09      SAY CAMPO
               @ 11, Col() + 1 SAY '(Relacionado)'
               @ 12, 09      GET ARQUIVO2        VALID ARQ( ARQUIVO2 )
               READCUR()
               XARQUIVO2 := AllTrim( ARQUIVO2 )
               IF !netuse( xarquivo2 )   // BREDE(XARQUIVO2,0)
                  RETU
               ENDIF
               SAVE SCREEN
               MDS( 'Escolha a ordem de relacao' )
               aESTRU := dbStruct()
               pESTRU := Len( aESTRU )
               dESTRU := Array( pESTRU )
               FOR Z := 1 TO pESTRU
                  dESTRU[ Z ] = PadR( aESTRU[ Z, 1 ], 10 )
               NEXT Z
               DEFA := 1
               DEFA := RCAMPO( DEFA )
               IF DEFA = 0
                  DEFA := 1
               ENDIF
               REST SCREEN
               CHAVEARQ2 := FieldName( DEFA )
               SELECT ( ANT_SEL )
               REPL CHAVE2 WITH CHAVEARQ2
               @ 23, 00 CLEAR TO 24, 79
               @ 13, 09 SAY CHAVE2
               dbCloseAre()
            ELSE
               SELECT ( ANT_SEL )
               REPL CAMPO WITH ""
               REPL ARQUIVO2 WITH ""
               REPL CHAVE2 WITH ""
            ENDIF
            dbSelectAr( cSELE10 )
            dbCloseArea()
            SELECT ( ANT_SEL )
         ENDIF
         SET DELI OFF
         SetCursor( 1 )
         @ 14, 09 GET LINHA1 PICT "@S70"
         @ 15, 09 GET LINHA2 PICT "@S70"
         @ 16, 09 GET LINHA3 PICT "@S70"
         @ 17, 09 GET LINHA4 PICT "@S70"
         @ 18, 09 GET LINHA5 PICT "@S70"
         @ 19, 09 GET LINHA6 PICT "@S70"
         @ 20, 09 GET LINHA7 PICT "@S70"
         @ 21, 09 GET LINHA8 PICT "@S70"
         READCUR()
         IF LastKey() = 27
            SetColor( "W/G" )
            RestScreen( 08, 00, 21, 79, TELA )
            RETU ( 1 )
         ENDIF
         TELA1 := SaveScreen( 18, 03, 21, 79 )
         SetColor( "W/G" )
         @ 18, 03 CLEAR TO 20, 76
         @ 18, 03 TO 20, 76 DOUB
         @ 18, 34 SAY 'Filtro:'
         @ 19, 05 GET FILTRO
         READCUR()
         IF LastKey() = 27
            RestScreen( 08, 00, 21, 79, TELA )
            SetColor( "W/G" )
            RETU ( 1 )
         ENDIF
         SetColor( "+W/BR" )
         @ 19, 06 CLEAR TO 20, 79
         @ 19, 06 TO 21, 79 DOUB
         @ 19, 30 SAY 'Setup de Impressao:'
         @ 20, 08 GET SETUP
         READCUR()
         IF LastKey() = 27
            SetColor( "W/G" )
            RestScreen( 08, 00, 21, 79, TELA )
            RETU ( 1 )
         ENDIF
         SetColor( "W/N" )
         RestScreen( 18, 03, 21, 79, TELA1 )
         ARQ  := Trim( ARQUIVO )
         KEY  := Trim( CHAVE )
         ARQ2 := Trim( ARQUIVO2 )
         KEY2 := Trim( CHAVE2 )
      ELSEIF KEY = 13
         LISTA()
      ENDIF
      RestScreen( 08, 00, 22, 79, TELA )
      SetColor( "W/G" )
      RETU ( 1 )
   CASE KEY = 27
      RETU ( 0 )
   ENDCASE
   RETU ( 1 )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LISTA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION LISTA

   dbSelectAr( "etiq2" )
   dbGoTop()
   IF Eof()
      MDT( 'N„o h  etiquetas cadastradas' )
      RETU
   ENDIF
   CAMPOX := Array( 1 )
   CAMPOX[ 1 ] = "' '+STR(ALTURA)+' '+STR(LARGURA)+' '+STR(COLUNAS)+' '"
   TELA5 := SaveScreen( 08, 49, 21, 64 )
   TELATIP()
   ALT  := 0
   LAR  := 0
   COL  := 0
   PCK1 := IMPRIME := .F.
   dbEdit( 09, 50, 15, 63, CAMPOX, "CAD1", .T., "", "", "", "", "" )
   RestScreen( 08, 49, 21, 64, TELA5 )
   SetColor( "W/N" )
   dbSelectAr( "etiq3" )
   IF !IMPRIME
      RETU
   ENDIF
   dbSelectAr( "etiq3" )
   ARQ  := Trim( ARQUIVO )
   KEY  := Trim( CHAVE )
   ARQ2 := Trim( ARQUIVO2 )
   KEY2 := Trim( CHAVE2 )
   CPO  := Trim( CAMPO )
   IF File( "&ARQ..DBF" )
      MDT( 'A g u a r d e ! ! ! Indexando...' )
      IF !NETUSE( ARQ,,,,, .F., )   // BREDE(ARQ,0)
         RETU
      ENDIF
      cSELE3   := Alias()
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      ordDestroy( "temp" )
      ordCreate(, "temp", KEY )
      ordSetFocus( "temp" )

      IF File( "&ARQ2..DBF" )
         IF !NETUSE( ARQ2,,,,, .F., )   // BREDE(ARQ2,0)
            RETU
         ENDIF
         cALIAS4 := Alias()

         nLASTREC := LastRec()
         zei_fort( nLASTREC,,, 0 )
         ordDestroy( "temp" )
         ordCreate(, "temp", KEY2 )
         ordSetFocus( "temp" )


         IF !Empty( CPO )
            dbSelectAr( cSELE3 )
            SET RELATION TO &CPO INTO &cALIAS3
         ENDIF
      ENDIF
      dbSelectAr( "etiq3" )
      @ 23, 0
   ELSE
      MDT( 'Arquivo nao encontrado' )
      dbSelectAr( "etiq3" )
      RETU
   ENDIF
   LINHAX := { LINHA1, LINHA2, LINHA3, LINHA4, LINHA5, LINHA6, LINHA7, LINHA8 }
   CONFIG := Trim( SETUP )
   FI     := Trim( FILTRO )
   dbSelectAr( cSELE3 )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO
   COPIAS := 1
   IF !CHECKIMP( 0 )
      dbSelectAr( "etiq3" )
      RETU
   ENDIF
   IMPRESSORA()
   SET PRINT ON
   ?? Chr( 27 ) + 'C' + Chr( ALT + 1 )
   IF !Empty( CONFIG )
      ?? &CONFIG
   ENDIF
   SET PRINT OFF
   dbGoTop()
   WHILE !Eof()
      RRR   := RecNo()
      CTLIN := -1
      FOR CU := 1 TO ALT
         CTLIN++
         DIZERES := LINHAX[ CU ]
         FOR CT := 1 TO COL
            CTCOL := 0
            IF CT > 1
               CTCOL := ( LAR * ( CT - 1 ) ) + ( CT - 1 )
            ENDIF
            dbGoto( RRR )
            IF CT > 1
               dbSkip( CT - 1 )
            ENDIF
            @ CTLIN, CTCOL SAY &DIZERES
         NEXT
      NEXT
      dbSkip()
   ENDDO
   IMPFOL()
   SET PRINT ON
   ?? Chr( 27 ) + '@'
   SET PRINT OFF
   dbSelectAr( cSELE4 )
   dbCloseArea()
   dbSelectAr( cSELE3 )
   dbCloseArea()
   VIDEO()
   IMPEND()
   dbSelectAr( "etiq3" )
   RETU
// : FIM: RECUETI2.PRG

// + EOF: recueti2.prg
// +
