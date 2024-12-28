// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo_rell.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :     FO_RELL.PRG: Impresso de Relatorios Configurados
// :       Linguagem: Harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fo_rell()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fo_rell

   PARA BUSCA

   mTEMP := tmpfile( cRDDEXT )
   IF !netuse( "DISKRELA" )  // PROCURAR A LISTA
      dbCloseAll()
      RETU
   ENDIF
   dbGoTop()
   IF !dbSeek( BUSCA )
      MDT( 'N„o Encontrei o Formul rio' )
      dbCloseArea()
      RETU .F.
   ENDIF
   MDS( 'Carregando a lista Aguarde' )
   LICA      := LCAB   // PARAMETROS DA LISTA
   LICO      := LCOT
   LIRO      := LROD
   TOTL      := LCAB + LCOT + LROD
   ARQUSO    := AllTrim( ARQUIVO )
   FIL       := FILTRO
   SET       := SETUP
   LIS       := LISTA
   LISC      := LISTAC
   LISR      := LISTAR
   MEMORIZ1  := MEMORIA1
   MEMORIZ2  := MEMORIA2
   MEMORIZ3  := MEMORIA3
   ASSOCIZ1  := ASSOCIA1
   ASSOCIZ2  := ASSOCIA2
   ASSOCIZ3  := ASSOCIA3
   VARIAVZ1  := VARIAVEL1
   VARIAVZ2  := VARIAVEL2
   VARIAVZ3  := VARIAVEL3
   TOTAISZ1  := TOTAIS1
   TOTAISZ2  := TOTAIS2
   TOTAISZ3  := TOTAIS3
   TIP       := TIPO
   VEZES     := REP
   mGRAVAREM := GRAVAREM
   dbCloseArea()

// Verifica se n„o existe macro de arquivo
   IF Left( ARQUSO, 1 ) = "&"
      ARQUSO := SubStr( ARQUSO, 2 )
      ARQUSO := &ARQUSO.
   ENDIF
   PAG  := Chr( 12 )   // TIPOS ESPECIAIS DE IMPRESSAO
   AQ   := Chr( 27 ) + Chr( 71 )   // Ativa Qualidade de Carta
   DQ   := Chr( 27 ) + Chr( 72 )   // desativa Qualidade de Carta
   AE   := cIMPTIT   // Ativa linha expandida
   AC   := cIMPCOM   // Ativa o modo comprimido
   DC   := cIMPEXP   // Desativa Comprimido
   AI   := Chr( 27 ) + Chr( 52 )   // Ativa it lico
   DI   := Chr( 27 ) + Chr( 53 )   // Desativa it lico
   AN   := cIMPNEG   // Ativa negrito
   DN   := cIMPNER   // Desativa Negrito
   AX   := Chr( 27 ) + Chr( 83 ) + Chr( 00 )   // Ativa impress„o exponencial
   AD   := Chr( 27 ) + Chr( 83 ) + Chr( 01 )   // Ativa impress„o de ind¡ces
   DXD  := Chr( 27 ) + Chr( 84 )   // Desativa exponencial e ou indice
   AS   := Chr( 27 ) + Chr( 45 ) + Chr( 00 )   // Ativa sublinhado
   DS   := Chr( 27 ) + Chr( 45 ) + Chr( 01 )   // Desativa sublinhado
   AEC  := Chr( 27 ) + Chr( 87 ) + Chr( 00 )   // Ativa expandido cont¡nuo
   DEC  := Chr( 27 ) + Chr( 87 ) + Chr( 01 )   // Desativa expandido cont¡nuo
   AIE  := Chr( 27 ) + Chr( 52 ) + Chr( 27 ) + Chr( 87 ) + Chr( 01 )   // Ativa it lico expandido
   DIE  := Chr( 27 ) + Chr( 53 ) + Chr( 27 ) + Chr( 87 ) + Chr( 00 )   // Desativa It lico expandido
   AIC  := Chr( 27 ) + Chr( 91 ) + Chr( 50 ) + Chr( 27 ) + Chr( 52 )   // Ativa It lico condensado
   DIC  := Chr( 27 ) + Chr( 91 ) + Chr( 48 ) + Chr( 27 ) + Chr( 53 )   // Desativa It lico Condensado
   ACA  := Chr( 27 ) + Chr( 91 ) + Chr( 50 )   // Ativa Condensado 12cpp
   ACB  := Chr( 27 ) + Chr( 91 ) + Chr( 51 )   // Ativa Condensado 15cpp
   ACC  := Chr( 27 ) + Chr( 91 ) + Chr( 52 )   // Ativa Condensado 17cpp
   ACD  := Chr( 27 ) + Chr( 91 ) + Chr( 53 )   // Ativa Condensado 20cpp
   DCE  := Chr( 27 ) + Chr( 91 ) + Chr( 48 )   // Desativa os condensados ACA,ACB,ACC,ACD
   ZMES := MMES( Month( ZDATA ) )
   ZDIA := DToC( ZDATA )
   ZANO := StrZero( Year( ZDATA ), 4 )
   ZDDI := StrZero( Day( ZDATA ), 2 )
   ZDEX := ZDDI + " de " + ZMES + " de " + ZANO
   ZRSM := REPL( "-", 132 )
   ZRDM := REPL( "=", 132 )
   ZRSS := REPL( "-", 80 )
   ZRDS := REPL( "=", 80 )

   ZFOL   := ZREG := 0   // VARIAVEIS DE TOTALIZACAO
   LINHAS := Array( TOTL )   // MATRIZES DO LAYOUT
   LN     := Array( TOTL )
   CL     := Array( TOTL )
   MEMO   := Array( 30 )   // MATRIZ MEMO/ASSOCIA
   ASSO   := Array( 30 )
   ASSV   := Array( 30 )
   FV     := Array( 30 )   // MATRIZ VARIAVEL
   VAR    := Array( 30 )
   FT     := Array( 30 )   // MATRIZ TOTAIS
   TOT    := Array( 30 )

// Variaveis de Posi‡„o
   POSMID := POSROD := POSQUE := .F.
   POSTOP := .T.


// Preenche a matrizes com vazios
   AFill( MEMO, "" )
   AFill( ASSO, "" )
   AFill( ASSV, 0 )
   AFill( FV, "" )
   AFill( VAR, "" )
   AFill( FT, "" )
   AFill( TOT, 0 )



   IF !NETUSE( "DISKREL1" )  // CARREGA CABECARIO
      RETU
   ENDIF
   LAYR( LISC, 1, LICA )
   LAYR( LIS, LICA + 1, LICA + LICO )  // CARREGA CONTEUDO
   LAYR( LISR, LICA + LICO + 1, LICA + LICO + LIRO )   // CARREGA RODAPE
   dbCloseArea()

   IF !NETUSE( "DISKRELM" )  // CARREGA MEMORIA
      RETU
   ENDIF
   MEMOX( MEMORIZ1, 0, 1 )
   MEMOX( MEMORIZ2, 10, 1 )
   MEMOX( MEMORIZ2, 20, 1 )
   MEMOX( VARIAVZ1, 0, 3 )   // CARREGA VARIAVEL
   MEMOX( VARIAVZ2, 10, 3 )
   MEMOX( VARIAVZ3, 20, 3 )
   MEMOX( TOTAISZ1, 0, 4 )   // CARREGA TOTAIS
   MEMOX( TOTAISZ2, 10, 4 )
   MEMOX( TOTAISZ3, 20, 4 )
   dbCloseArea()

   IF !NETUSE( "DISKRELS" )  // CARREGA ASSOCIAR
      RETU
   ENDIF
   MEMOX( ASSOCIZ1, 0, 2 )
   MEMOX( ASSOCIZ2, 10, 2 )
   MEMOX( ASSOCIZ3, 20, 2 )
   dbCloseArea()


   COPIAS := 1   // NUMERO DE COPIAS RELATORIOS SEM ARQUIVOS
   MDS( 'Quantas Copias' )
   @ 24, 30 GET copias PICT '###' RANGE 1, 999
   READCUR()

   IF !CHECKIMP( 0, .T. )
      RETU .F.
   ENDIF

   IMPRESSORA()  // INICIA SETUP DA IMPRESSORA
   IF !Empty( SET )
      @ PRow(), 0 SAY &SET
   ENDIF

// Se o tipo ‚ AB ou AA apenas uma repiti‡„o do conteudo e realizada
   IF TIP = 'AB' .OR. TIP = 'AA'
      VEZES := 1
   ENDIF

// IMPRESSAO TIPO AB E AD Sem Arquivos
   IF TIP = 'AB' .OR. TIP = 'AD'
      FOR Z := 1 TO COPIAS
         ZFOL++
         IMPCAB()
         FOR Y := 1 TO VEZES
            IMPCOT()
         NEXT Y
         IMPROD()
      NEXT Z
   ENDIF

// IMPRESSAO TIPO AA OU AC Com Arquivos
   IF TIP = 'AC' .OR. TIP = 'AA'
      VIDEO()
      IF !NETUSE( ARQUSO )
         RETU
      ENDIF
      cSELE5 := Alias()
      FILTRO := FIL
      INX    := ""
      FILORD( .T. )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      IF ValType( INX ) = "N"
         dbSetOrder( INX )
      ELSE
         ordDestroy( "temp" )
         ordCreate(, "temp", inx )
         ordSetFocus( "temp" )
      ENDIF
      SET FILTER TO &FILTRO

      IMPRESSORA()
      FOR Z := 1 TO COPIAS
         // Zera as Variaveis totalizadoras
         ZFOL := ZREG := 0   // VARIAVEIS DE TOTALIZACAO
         AFill( TOT, 0 )  // ZERA OS TOTALIS
         dbGoTop()
         WHILE !Eof()
            ZFOL++
            IMPCAB()
            FOR Y := 1 TO VEZES
               CALCVAR()
               CALCTOT()
               IMPCOT()
               ZREG++
               dbSelectAr( cSELE5 )
               dbSkip()
               IF Eof()
                  EXIT
               ENDIF
            NEXT Y
            IMPROD()
         ENDDO
      NEXT Z
      dbSelectAr( cSELE5 )
      dbCloseArea()
   ENDIF

/* IMPRESSAO TIPO AE Com Arquivos
Utiliza‡„o B sica Resumo de Situa‡”es
2a. Processamento todos os registros do arquivo
1a. Imprime o Cabe‡ario
3a. N„o Imprime o Conteudo
4a. Imprime o Rodap‚
*/
   IF TIP = 'AE'
      // Processa o arquivo Calculando Variaveis e Totais
      VIDEO()
      IF !NETUSE( ARQUSO )
         RETU
      ENDIF

      FILTRO := FIL
      INX    := ""
      FILORD( .T. )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      IF ValType( INX ) = "N"
         dbSetOrder( INX )
      ELSE
         ordDestroy( "temp" )
         ordCreate(, "temp", inx )
         ordSetFocus( "temp" )
      ENDIF
      SET FILTER TO &FILTRO


      dbGoTop()
      WHILE !Eof()
         CALCVAR()
         CALCTOT()
         ZREG++
         dbSkip()
      ENDDO
      dbCloseArea()

      // Inicia Impress„o
      IMPRESSORA()
      FOR Z := 1 TO COPIAS
         // Imprime o Cabe‡ario
         IMPCAB()
         // Imprime o Rodap‚
         IMPROD()
      NEXT Z
      // Defalt Finalizacao de pagina
      IMPFOL()
   ENDIF
   VIDEO()
   IMPEND()
   RETU



// !*****************************************************************************
// !
// !         Fun‡„o: IMPLIN()
// !
// !    Chamado por: IMPCAB()           (fun‡„o    em FO_RELL.PRG)
// !               : IMPCOT()           (fun‡„o    em FO_RELL.PRG)
// !               : IMPROD()           (fun‡„o    em FO_RELL.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IMPLIN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IMPLIN   // IMPRIME UMA LINHA DE EDICAO

   DIZERES := AllTrim( LINHAS[ X ] )
   PUL     := LN[ X ]
   COL     := CL[ X ]
   DIGA    := &DIZERES
   IF ValType( DIGA ) = "C"
      IF DIGA = "PAG" .OR. DIGA = "CHR(12)"
         IMPFOL()
      ELSE
         @ PRow() + PUL, COL SAY ACENTO( DIGA )
      ENDIF
   ELSE
      @ PRow() + PUL, COL SAY DIGA
   ENDIF
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: IMPCAB()
// !
// !    Chamado por: FO_RELL.PRG
// !
// !          Chama: IMPLIN()           (fun‡„o    em FO_RELL.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IMPCAB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IMPCAB   // IMPRIME O CABECARIO

   IF !Empty( LISC )
      FOR X := 1 TO LICA
         IMPLIN()
      NEXT X
   ENDIF
// Ajusta Variaveis de Posi‡„o
   POSTOP := .F.
   POSMID := .T.
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: IMPCOT()
// !
// !    Chamado por: FO_RELL.PRG
// !
// !          Chama: IMPLIN()           (fun‡„o    em FO_RELL.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IMPCOT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IMPCOT   // IMPRIME O CONTEUDO

   FOR X := LICA + 1 TO LICA + LICO
      IMPLIN()
   NEXT X
// Ajusta Variaveis de Posi‡„o
   POSMID := .F.
   POSROD := .T.
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: IMPROD()
// !
// !    Chamado por: FO_RELL.PRG
// !
// !          Chama: IMPLIN()           (fun‡„o    em FO_RELL.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IMPROD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IMPROD   // IMPRIME O RODAPE

   IF !Empty( LISR )
      FOR X := LICA + LICO + 1 TO LICA + LICO + LIRO
         IMPLIN()
      NEXT X
   ENDIF
// Ajusta Variaveis de Posi‡„o
   POSROD := .F.
   POSTOP := .T.
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: ASS()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ASS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ASS( xASSVAL )   // ASSOCIA VALORES A PALAVRAS

   LOCAL PAL     := ""
   LOCAL POSICAO

   POSICAO := AScan( ASSV, xASSVAL )
   IF POSICAO # 0
      PAL := ASSO[ POSICAO ]
   ENDIF
   RETU PAL


// !*****************************************************************************
// !
// !         Fun‡„o: MEMOX()
// !
// !    Chamado por: FO_RELL.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MEMOX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MEMOX

   PARA MEMORIZA, SOME, AMAT   // BUSCAR,POSICAO MATRIZ,MATRIZ DESTINO

   IF MEMORIZA # SPAC( 6 )
      dbGoTop()
      IF dbSeek( MEMORIZA )
         FOR X := 1 TO 10
            MM := 'M' + StrZero( X, 2 )
            DO CASE
            CASE AMAT = 1
               MEMO[ X + SOME ] = RTrim( &MM )
            CASE AMAT = 2
               VV := 'V' + StrZero( X, 2 )
               ASSO[ X + SOME ] = RTrim( &MM )
               ASSV[ X + SOME ] = &VV
            CASE AMAT = 3
               FV[ X + SOME ] = RTrim( &MM )
            CASE AMAT = 4
               FT[ X + SOME ] = RTrim( &MM )
            ENDCASE
         NEXT X
      ENDIF
   ENDIF
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: LAYR()
// !
// !    Chamado por: FO_RELL.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LAYR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC LAYR

   PARA BUSCA, xINI, xFIM  // BUSCAR,INICIO,FIM LOOP

   IF BUSCA # SPAC( 6 )
      BUSCA := BUSCA + "    1"
      dbGoTop()
      dbSeek( BUSCA )
      FOR X := xINI TO xFIM
         LINHAS[ X ] = IF( Empty( DIZ ), "", DIZ )
         LN[ X ] = LIN
         CL[ X ] = COL
         dbSkip()
      NEXT
   ENDIF
   RETU .T.


// !*****************************************************************************
// !
// !         Fun‡„o: CALCVAR()
// !
// !    Chamado por: FO_RELL.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCVAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CALCVAR  // CALCULA AS VARIAVEIS

   FOR W := 1 TO 30
      TEMP := FV[ W ]
      VAR[ W ] = IF( Empty( TEMP ), "", &TEMP )
   NEXT W
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: CALCTOT()
// !
// !    Chamado por: FO_RELL.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCTOT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CALCTOT  // CALCULA OS TOTAIS

   FOR W := 1 TO 30
      TEMP := FT[ W ]
      TOT[ W ] = IF( Empty( TEMP ), "", &TEMP )
   NEXT W
   RETU .T.
// : FIM: FO_RELL.PRG

// + EOF: fo_rell.prg
// +
