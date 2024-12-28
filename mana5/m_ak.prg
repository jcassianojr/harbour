// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ak.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +





// Teclas Operacionais
// #INCLUDE "TECLASM.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_ak()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_ak

   PARA nTIPO

   ARQWORK1 := "MK01"
   ARQWORK2 := "MK02"
   ARQWORK4 := "MK06"

   IF nTIPO = 2
      cVAR     := MESANO()
      ARQWORK1 := "K1" + cVAR
      ARQWORK2 := "K2" + cVAR
      ARQWORK4 := "K6" + cVAR
   ENDIF

   IF nTIPO = 3
      ARQWORK1 := "MK91"
      ARQWORK2 := "MK92"
      ARQWORK4 := "MK96"
   ENDIF

   PRIV wMAk, wpMAk, wcMAk

   wMAk  := 0
   wcMAk := 0
   wPMAk := 1

   aMK2TEL := TELAPEG( "ITK201" )
   aMK2GET := EDITPEG( "ITK201" )



// Modo de Trabalho no Video
   MDI( " Ý ",,, ARQWORK1 )

// Configura‡„o de Trabalho
   PRIV lFIXA
   PRIV nACHO
   PRIV cVIDE
   PRIV lPBUS
   PRIV lPIND
   PRIV mCBAR
   PRIV mCBARM
   PRIV cTIPG
   PRIV aGETS
   PRIV cCBAS
   PRIV nIBUS
   PRIV nIEXI
   PRIV aIND
   PRIV nREG
   IF !CONFARQ( ARQWORK1, "Nota    Emiss„o F Fornecedor" + spac( 9 ) + "S Ope P S Pag  Valor Total da NF", ;
         "' '+STR(mNRNOTA,8)+' '+DTOC(mDATA)+' '+mTIPOCLI+' '+STR(mFORNECEDO,  5)+' '+mCOGNOME+' '+mSETOR+' '+mOPERACAO+' '+mTIPOENT+' '+mSITUACAO+' '+mCONDPAG+' '+STR(mTOTNF, 18, 2)" )
      RETU .F.
   ENDIF
   IF !CONFIND( ARQWORK1 )
      RETU .F.
   ENDIF

// Pegando Cores de Trabalho
   CORMAK := CORARR( "MAK" )

// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   ZESTADO := OBTER( "MANEMP", ZNUMERO, "ESTADO" )
   mESTADO := ""
   mICM    := 0
   IF wMAK = 0
      CRIARVARS( "ML01" )
      CRIARVARS( ARQWORK1 )
      CRIARVARS( ARQWORK2 )
      // CRIARVARS( "MK03" )
   ENDIF
// CRIANDO MATRIZES
   IF wcMAK = 0
      aMAK1 := {}  // Matriz com os dizeres do Achoice
      aMAK2 := {}  // Por N£mero da Nota Fiscal e N£mero do Fornecedor
   ENDIF

// Incializando a ajuda on Line
   PRIV HELPDBF := "MK01"

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMAK # 2
      nIND := if( lPIND, NUMIND( ARQWORK1 ), nIEXI )
      IF !USEREDE( ARQWORK1, 1, 1 )
         RETU
      ENDIF
      GRAF := LastRec()
      IF GRAF > nACHO
         dbCloseArea()
         ALERTX( "Muitos Arquivos para o Modo Video" )
         cVIDE := "N"
      ELSE
         xGRAF := 0
         xPOS  := 1
         MARCAR()
         dbGoTop()
         WHILE !Eof()
            IF !Empty( mCBAR )
               AAdd( aMAK1, &mCBAR. )
            ELSE
               AAdd( aMAK1, ' ' + Str( NRNOTA, 8 ) + ' ' + DToC( DATA ) + ' ' + TIPOCLI + ' ' + Str( FORNECEDO, 5 ) + ' ' + COGNOME + ' ' + SETOR + ' ' + OPERACAO + ' ' + TIPOENT + ' ' + SITUACAO + ' ' + CONDPAG + ' ' + Str( TOTNF, 18, 2 ) )
            ENDIF
            AAdd( aMAK2, Str( NRNOTA, 8 ) + Str( FORNECEDO, 5 ) + DToS( DATA ) )
            xPOS++
            MARCAR1()
            dbSkip()
         ENDDO
         dbCloseArea()
         IF xPOS = 1
            IF !mdg( 'Nenhum Lan‡amento Neste Arquivo Deseja Incluir' )
               RETU .F.
            ENDIF
            nSBAR := 0
            IF !fMAK( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   IF PCount() = 1
      pMAK := 1
   ELSE
      pMAK := AScan( aMAK2, wpMAK )
      pMAK := if( pMAK = 0, 1, pMAK )
   ENDIF

// Processando o M‚todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR
      PRIV aSBAR
      nSBAR := Len( aMAK1 )
      aSBAR := ScrollBarNew( 04, 79, 23, SubStr( CORMAK[ 1 ], RAt( ",", CORMAK[ 1 ] ) + 1 ), pMAK )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMAK, nSBAR, .T. )
      WHILE .T.
         CABVID( CORMAK[ 1 ], pMAK )
         nKEY := 0
         KEYBOARD Chr( 255 )
         bELE  := {| X | aMAK1[ X ] }
         cCOR  := CORMAK[ 1 ]
         pMAK2 := AChoice( 05, 01, 22, 78, aMAK1,, "ACHMOU", pMAK )
         pMAK  := if( pMAK2 # 0, pMAK2, pMAK )
         pMAK2 := pMAK
         DO CASE
         CASE LastKey() = K_ESC
            IF mdg( 'Encerrar Consulta' )
               EXIT
            ENDIF
            LOOP
         CASE LastKey() = K_ALT_F10
            MDS( 'Imprimindo' )
            MANLISTA()
         CASE LastKey() = K_INS
            MDS( 'Incluindo ' )
            fMAK( 1, pMAK )
         CASE LastKey() = K_ENTER .AND. wMAK # 3
            MDS( 'Alterando ' )
            fMAK( 2, pMAK )
         CASE LastKey() = K_ENTER .AND. wMAK = 3
            MDS( 'Escolhendo' )
            fMAK( 6, pMAK )
            RETU
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fMAK( 3, pMAK )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := if( lPBUS, NUMIND( ARQWORK1 ), nIBUS )
            mCHABUS := PEGBUS( ARQWORK1, nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( ARQWORK1, nIBUS, mCHABUS )
            ENDIF
            pMAK := AScan( aMAK2, mCHAVE )
            IF pMAK = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMAK := pMAK2
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF
   IF cVIDE = 'N'
      METNVI( ARQWORK1, {|| fMAK( 1, 0 ) }, {|| fMAK( 3, 0 ) }, {|| fMAK( 2, 0 ) }, ;
         {|| fMAK( 6, 0 ) }, {|| fMAK( 2, - 1 ) }, CORMAK[ 1 ], wMAK )
   ENDIF
   IF cVIDE = 'P'
      METPAG( ARQWORK1, CORMAK, "STR(mNRNOTA,8)+STR(mFORNECEDO,5)+DTOS(mDATA)", wMAK, ;
         {|| tMAK() }, {|| fMAK( 1, 0 ) }, {|| fMAK( 3, 0 ) }, {|| fMAK( 2, 0 ) }, ;
         {|| fMAK( 6, 0 ) } )
   ENDIF
   IF cVIDE = 'I'
      METINT( ARQWORK1,, {|| fMAK( 2, - 1 ) } )
   ENDIF

   IF wMAK = 0
      // LIBERA VARIAVEIS
      RELEASE ALL LIKE m *
   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( ARQWORK1 )
      FIXAR( ARQWORK2 )
   ENDIF
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMAK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMAK( OPRMAK, POSMAK )  // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ***********************
// Pegar a Chave de Busca
   IF OPRMAK # 1
      IF cVIDE = 'S'
         mCHAVE := aMAK2[ POSMAK ]
      ENDIF
      IF cVIDE = 'N' .AND. POSMAK # -1
         PEGBUS( ARQWORK1, 1 )
      ENDIF
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMAK = 1
      // Zera Variaveis
      CRIARVARS( ARQWORK1 )
      PEGBUS( ARQWORK1, 1 )
      // Marca Valores Pre definidos
      mTIPOCLI  := 'F'
      mSETOR    := 'C'
      mOPERACAO := '111'
      mTIPOENT  := 'D'
      mSITUACAO := '1'
      IF !NOVOREG( ARQWORK1, mCHAVE )
         RETU .F.
      ENDIF
   ENDIF

// IGUALAR mVARS
   IF !IGUALVARS( ARQWORK1, mCHAVE )
      RETU .F.
   ENDIF
   IF Empty( mDATAREF )
      mDATAREF := mDATA
   ENDIF
   IF Empty( mTIPOCLI )
      mTIPOCLI := "C"
   ENDIF

// Guarda Variaveis de Referencia arquivo MK02
   xNRNOTA    := mNRNOTA
   mNUMERO    := mNRNOTA
   xDATA      := mDATA
   xFORNECEDO := mFORNECEDO
   xOPERACAO  := mOPERACAO
   yCFONEW    := mCFONEW
   yCFONEWB   := mCFONEWB
   ySUBOPER   := mSUBOPER
   yAPURA     := mAPURA



// Opera‡„o de Exclus„o
   IF OPRMAK = 3
      IF APAGAREG( ARQWORK1, mCHAVE )
         IF cVIDE = "S"
            aMAK1[ POSMAK ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + Str( mFORNECEDO, 5 ) + ' ' + DToC( mDATA ) + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
         // Apagando os itens deste Pedido
         WHILE !USEREDE( ARQWORK2, 0, 99 )
         ENDDO
         dbSeek( Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + DToS( mDATA ) )
         WHILE Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + DToS( mDATA ) = Str( NRNOTA, 8 ) + Str( FORNECEDO, 5 ) + DToS( DATA ) .AND. !Eof()
            EQUVARS()
            IF TIPOENT = "M" .OR. TIPOENT = "C"
               yCODIGO   := mCODIGO
               mOLDQTDDE := MAK2K06()
               MAK2K05( "E" )
            ENDIF
            DELEREG( ARQWORK2,, .T., .F. )
         ENDDO
         dbCloseArea()
         PCK    := .T.
         aDATAS := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, ;
            mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }
         FOR W := 1 TO 10
            IF !Empty( aDATAS[ W ] )
               mTIPFAT := Chr( 64 + W )
               APAGAREG( "ML01", DToS( aDATAS[ W ] ) + Str( mNRNOTA, 8 ) + mTIPFAT, .F. )
            ENDIF
         NEXT
      ENDIF
      RETU .T.
   ENDIF

   aDATOLD := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, ;
      mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }


   TIPCAD( mTIPOCLI, "ARQUSO" )

// Metodo de Edi‡„o
   IF cTIPG = "1"
      // Desenha a Tela
      tMAK()
      // Get nas Menvars
      gMAK()
   ELSE
      EDITGET( .T., CORMAK )
   ENDIF

// Guarda Variaveis de Referencia arquivo MK02
   xNRNOTA    := mNRNOTA
   mNUMERO    := mNRNOTA
   xDATA      := mDATA
   xFORNECEDO := mFORNECEDO
   xOPERACAO  := mOPERACAO
   yICM       := mICM  // Fixa ICM

// Itens da Nota Fiscal
   M_AK2( 1 )

// Calculando Parcelas
   IF Empty( mVAL01 )
      MPAGAR( mCONDPAG, mTOTNF, mDATA, .T. )
   ENDIF

// Checando os Parcelas
   CHECKPAR(, "2", "mNRNOTA" )

// Transferˆncia de Dados para o Contas a Pagar (ML01).
   yNRNOTA   := mNRNOTA  // Salva vari veis NRNOTA e DATA do MK01.
   yDATA     := mDATA
   ySITUACAO := mSITUACAO

   mSITUACAO := 0
   aDATAS    := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, ;
      mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }
   aVALOR := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, ;
      mVAL06, mVAL07, mVAL08, mVAL09, mVAL10 }
   mNOME     := OBTER( ARQUSO, mFORNECEDO, "NOME" )  // Puxa o Nome, DDD e Telefone
   mDDD      := OBTER( ARQUSO, mFORNECEDO, "DDD" )   // do Cadastro de Clientes p/
   mTELEFONE := OBTER( ARQUSO, mFORNECEDO, "TELEFONE" )
   mCLIENTE  := mFORNECEDO
   mTOTFAT   := mTOTNF

   IF ARQWORK1 == "MK01" .AND. MDG( "Transferir Contas a Pagar" )
      MDS( "Aguarde Transferencia Contas a Pagar" )
      WHILE !USEREDE( "ML01", 1, 99 )
      ENDDO
      FOR W := 1 TO 10
         mTIPFAT := Chr( 64 + W )  // Tipo do Faturamento (A,B,C...)
         IF W = 1 .AND. Empty( aDATAS[ 2 ] )   // Somente um vencimento
            mTIPFAT := " "
         ENDIF
         mVENCIMENT := aDATAS[ W ]
         mVALOR     := aVALOR[ W ]
         yDATAV     := aDATOLD[ W ]
         DO CASE
            // Zerou o valor ou a data
            // Apaga o Lan‡amento Buscando Pela Data Anterior
         CASE mVALOR = 0 .OR. Empty( mVENCIMENT )
            DELEREG(, DToS( yDATAV ) + Str( mNRNOTA, 8 ) + mTIPFAT )
            // Lan‡amento Normal Cria ou Atualiza
         CASE yDATAV = mVENCIMENT .AND. mVALOR > 0 .AND. !Empty( mVENCIMENT )
            IF !NOVOOPE(, DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
               // Altera Lan‡amentos
               netreclock()
               REPLVARS()
               dbUnlock()
            ENDIF
            // Mudou a data Apaga o anterior Grava o novo
         CASE yDATAV <> mVENCIMENT .AND. mVALOR > 0
            // Apagando o Anterior
            DELEREG(, DToS( yDATAV ) + Str( mNRNOTA, 8 ) + mTIPFAT )
            NOVOOPE(, DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
         ENDCASE
      NEXT
      dbCloseAll()
   ENDIF

   mNRNOTA   := yNRNOTA  // Retorna as vari veis que foram salvadas.
   mDATA     := yDATA
   mSITUACAO := ySITUACAO

// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMAK # 1
      aMAK1[ POSMAK ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + DToC( mDATA ) + ' ' + mTIPOCLI + ' ' + Str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + mSETOR + ' ' + mOPERACAO + ' ' + mTIPOENT + ' ' + mSITUACAO + ' ' + mCONDPAG + ' ' + Str( mTOTNF, 18, 2 )
      aMAK2[ POSMAK ] = Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + DToS( mDATA )
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMAK = 1
      nSBAR++
      AAdd( aMAK1, NIL )
      AAdd( aMAK2, NIL )
      POSMAK := Len( aMAK1 )
      POSW   := 1
      IF POSMAK > 1
         FOR X := 1 TO POSMAK - 1
            mDARE := aMAK2[ X ]
            IF mCHAVE <= mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aMAK1, POSW )
      AIns( aMAK2, POSW )
      aMAK1[ POSW ] = ' ' + Str( mNRNOTA, 8 ) + ' ' + DToC( mDATA ) + ' ' + mTIPOCLI + ' ' + Str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + mSETOR + ' ' + mOPERACAO + ' ' + mTIPOENT + ' ' + mSITUACAO + ' ' + mCONDPAG + ' ' + Str( mTOTNF, 18, 2 )
      aMAK2[ POSW ] = Str( mNRNOTA, 8 ) + Str( mFORNECEDO, 5 ) + DToS( mDATA )
      pMAK := POSW
   ENDIF

   REPORVARS( ARQWORK1, mCHAVE )

   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tMAK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tMAK

   SetColor( CORMAK[ 5 ] )
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
   @  3, 3  SAY "Nota    Emiss„o   Competencia"
   @  4, 0  SAY '+' + repl( '-', 78 ) + 'Ý'
   @  6, 43 SAY "Setor" + spac( 12 ) + "Nat.Opera‡„o"
   @  7, 1  SAY "Tipo: F=Fornecedor" + spac( 24 ) + "F :C=NF.Fornec"
   @  8, 7  SAY "C=Cliente" + spac( 30 ) + "S=NF.Interna"
   @ 10, 1  SAY "Entrada ser  de:    P=Pe‡as" + spac( 9 ) + "Situa‡„o:1=Compra"
   @ 11, 21 SAY "D=Despesas" + spac( 15 ) + "2=Consigna‡„o    Nota     Data"
   @ 12, 21 SAY "V=Veiculos" + spac( 15 ) + "3=Devolu‡„o"
   @ 13, 21 SAY "O=Outras" + spac( 17 ) + "4=Demonstra‡„o"
   @ 14, 46 SAY "O=Outras"
   @ 15, 1  SAY "Condi‡„o de Pagamento:    -"
   @ 17, 2  SAY "Conta Contabil :"
   @ 20, 0  SAY '+' + repl( '-', 14 ) + "-" + repl( '-', 14 ) + "-" + repl( '-', 15 ) + "-" + repl( '-', 32 ) + 'Ý'
   @ 21, 1  SAY "F:F=FornecedorÝS:C=NF Fornec.ÝP:P=Pe‡a D=DespÝS:1=Compra" + spac( 6 ) + "3=Devolu‡„o"
   @ 22, 3  SAY "C=Cliente   Ý  S=NF InternaÝ  V=Veiculo    Ý  2=Consigna‡„o 4=Demonstra‡„o"
   @ 23, 15 SAY "Ï" + repl( '-', 14 ) + "Ï" + repl( '-', 15 ) + "Ï"
   SetColor( CORMAK[ 3 ] )
   TIPCAD( mTIPOCLI, "ARQUSO" )
   @  5, 1  SAY mNRNOTA
   @  5, 10 SAY mDATA
   @  5, 21 SAY mDATAREF
   @  8, 3  SAY mTIPOCLI
   @  7, 23 SAY mFORNECEDO
   @  7, 29 SAY mCOGNOME
   @  8, 43 SAY mSETOR
   @  7, 60 SAY mOPERACAO
   @ 10, 18 SAY mTIPOENT
   @ 11, 40 SAY mSITUACAO
   @ 15, 24 SAY mCONDPAG
   @ 17, 19 SAY mCTACONTB
   RETU .T.

// Get Nas Mvars



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMAK

   SetColor( CORMAK[ 2 ] )
   TIPCAD( mTIPOCLI, "ARQUSO" )
// Get nas Menvars
   @  5, 1  SAY mNRNOTA    PICT '99999999'
   @  5, 10 GET mDATA
   @  5, 21 GET mDATAREF
   @  8, 3  GET mTIPOCLI   PICT "!"                                                                               VALID TIPCAD( mTIPOCLI, "ARQUSO", 6, 23 )
   @  7, 23 GET mFORNECEDO PICT '99999'                                                                           VALID MAKK01()
   @  7, 29 GET mCOGNOME
   @  8, 43 GET mSETOR
   @  7, 60 GET mOPERACAO  VALID CHECKCFO( mOPERACAO, 1, mESTADO, zESTADO, 7, 66, "LEFT(DESCRICAO,13)" )
   @ 10, 18 GET mTIPOENT
   @ 11, 40 GET mSITUACAO
   @ 15, 24 GET mCONDPAG   VALID VERSEHA( "MJ01", mCONDPAG, "LEFT(NOME,14)", "'Condi‡„o n„o Cadastrada'", .T., 1, 15, 29 )
   IF ZLANC = 0
      @ 17, 19 GET mCTACONTB PICT ZPICCC VALID CHECKCC()
   ELSE
      @ 17, 19 GET mCTACONTB VALID CHECKCC()
   ENDIF
   READCUR()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAKK01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAKK01()

   PEGACAMPO( ARQUSO, "mFORNECEDO", { "COGNOME", "ESTADO" }, { "mCOGNOME", "mESTADO" } )
   mICM := OBTER( "MD05", mESTADO, "ALIQUOTA" )
   RETU .T.


// + EOF: m_ak.prg
// +
