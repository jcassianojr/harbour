// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ad2.prg
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


#include "BOX.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_ad2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_ad2

// Recebendo Parametro de Trabalho
   PARA wMAD2, wpMAD2, wcMAD2

/* 3o. Paramentro
0 - Cria e Carrega as Matrizes
1 - N„o Cria e Carrega as Matrizes
2 - N„o Cria e N„o Carrega as Matrizes
*/
   IF PCount() < 3
      wcMAD2 := 0
   ENDIF


// Teclas Operacionais
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
   MDI( " Ý ",,, "MD02" )

// Configura‡„o de Trabalho
   PRIV lFIXA, nACHO, cVIDE, lPBUS, lPIND, mCBAR, mCBARM, cTIPG, aGETS, cCBAS, nIBUS, nIEXI, aIND
   IF !CONFARQ( "MD02" )
      RETU .F.
   ENDIF
   IF !CONFIND( "MD02" )
      RETU .F.
   ENDIF

// Pegando Cores de Trabalho
   CORMAD2 := CORARR( "MAD2" )

// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   IF wMAD2 = 0
      CRIARVARS( "MD02" )
   ENDIF
// CRIANDO MATRIZES
   IF wcMAD2 = 0
      aMAD21 := {}   // Matriz com os dizeres do Achoice
      aMAD22 := {}   // Por ordem de c¢digo
      aMAD23 := {}   // Por ordem de data
      aMAD24 := {}   // VALOR
      aMAD25 := {}   // Varia‡„o
   ENDIF

// Incializando a ajuda on Line
   PRIV HELPDBF := "MD02"

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMAD2 # 2
      nIND := IF( lPIND, NUMIND( "MD02" ), nIEXI )
      IF !USEREDE( "MD02", 1, nIND )
         RETU
      ENDIF
      GRAF  := LastRec()
      xGRAF := 0
      xPOS  := 1
      MARCAR()
      dbGoTop()
      dbSeek( mCODIGO )
      WHILE mCODIGO = CODIGO .AND. !Eof()
         DO CASE
         CASE xTIPO = '%'
            AAdd( aMAD21, ' ' + DToC( DATA ) + ' ' + TRANSF( VARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMUGERA, '@E 99,999,999.9999' ) + ' ' )
         CASE xTIPO = 'P'
            AAdd( aMAD21, ' ' + DToC( DATA ) + ' ' + TRANSF( VARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMUGERA, '@E 99,999,999.9999' ) + ' ' )
         CASE xTIPO = '$'
            AAdd( aMAD21, ' ' + DToC( DATA ) + ' ' + TRANSF( VALOR, '@E 99,999,999.99' ) + ' ' + TRANSF( VARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMUGERA, '@E 999,999,999.9' ) + ' ' )
         CASE xTIPO = 'V'
            AAdd( aMAD21, ' ' + DToC( DATA ) + ' ' + TRANSF( VALOR, '@E 9,999,999.999' ) + ' ' + TRANSF( VARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( ACUMUGERA, '@E 999,999,999.9' ) + ' ' )
         OTHERWISE
            AAdd( aMAD21, ' ' + CODIGO1 + ' ' + DESCRICAO + ' ' + DToC( DATA ) + ' ' + TRANSF( VARIACAO, '@E 9,999,999.9999' ) + ' ' )
         ENDCASE
         AAdd( aMAD22, CODIGO + CODIGO1 + DToS( DATA ) )
         AAdd( aMAD23, DATA )
         AAdd( aMAD24, VALOR )
         AAdd( aMAD25, VARIACAO )
         xPOS++
         MARCAR1()
         dbSkip()
      ENDDO
      dbCloseArea()
      IF xPOS = 1
         IF !mdg( 'Nenhum lan‡amento neste arquivo, deseja incluir' )
            RETU .F.
         ENDIF
         nSBAR := 0
         IF !fMAD2( 1, 0 )
            RETU .F.
         ENDIF
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   IF PCount() = 1
      pMAD2 := 1
   ELSE
      pMAD2 := AScan( aMAD22, wpMAD2 )
      pMAD2 := IF( pMAD2 = 0, 1, pMAD2 )
   ENDIF

// Processando o M‚todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aMAD21 )
      aSBAR := ScrollBarNew( 04, 79, 23, SubStr( CORMAD2[ 1 ], RAt( ",", CORMAD2[ 1 ] ) + 1 ), pMAD2 )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMAD2, nSBAR, .T. )
      WHILE .T.
         SetColor( CORMAD2[ 1 ] )
         hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
         DO CASE
         CASE XTIPO = '%'
            @ 03, 02 SAY 'Data'
            @ 03, 11 SAY 'Variacao  % '
            @ 03, 24 SAY 'Acumulo  Jan'
            @ 03, 37 SAY 'Acum. 12 Mes'
            @ 03, 50 SAY 'Acumulo  Total'
            MDS( '[CTRL+ENTER=Sub-Codigo] [CTRL+F2=Data][ALT+F5]=Recalcular Tabela' )
         CASE XTIPO = 'P'
            @ 03, 02 SAY 'Data'
            @ 03, 11 SAY 'Variacao  % '
            @ 03, 24 SAY 'Acumulo  Jan'
            @ 03, 37 SAY 'Acum. 12 Mes'
            @ 03, 50 SAY 'Acumulo  Total'
            MDS( '[CTRL+ENTER=Sub-Codigo] [CTRL+F2=Data]' )
         CASE XTIPO = '$'
            @ 03, 02 SAY 'Data'
            @ 03, 11 SAY '    V a l o r '
            @ 03, 27 SAY '  Variacao'
            @ 03, 39 SAY 'Acumulo Jan'
            @ 03, 50 SAY '  Acum.12 Mes'
            @ 03, 72 SAY 'Global'
            MDS( '[CTRL+ENTER=Sub-Codigo] [CTRL+F2=Data] [ALT+F5]=Recalcular Tabela' )
         CASE XTIPO = 'V'
            @ 03, 02 SAY 'Data'
            @ 03, 11 SAY '    V a l o r '
            @ 03, 27 SAY '  Variacao'
            @ 03, 39 SAY 'Acumulo Jan'
            @ 03, 50 SAY '  Acum.12 Mes'
            @ 03, 72 SAY 'Global'
            MDS( '[CTRL+ENTER=Sub-Codigo] [CTRL+F2=Data]' )
         OTHERWISE
            @ 03, 2  SAY 'C¢digo'
            @ 03, 15 SAY 'Descricao'
            @ 03, 56 SAY 'Data'
            @ 03, 65 SAY 'Variacao/Ind.'
            MDS( 'Pesquisa: [CTRL+ENTER=Sub-Codigo] [CTRL+F2=Data]' )
         ENDCASE
         SetColor( CORMAD2[ 1 ] )
         @  4, 0 SAY '+' + Replicate( '-', 78 ) + 'Ý'
         ScrollBarUpdate( aSBAR, pMAD2, nSBAR, .T. )
         ScrollBarDisplay( aSBAR )
         pMAD22 := AChoice( 05, 01, 22, 78, aMAD21,, "ACHRETB", pMAD2 )
         pMAD2  := IF( pMAD22 # 0, pMAD22, pMAD2 )
         pMAD22 := pMAD2
         nROW   := Row()
         DO CASE
         CASE LastKey() = K_ESC
            MDS( 'Retornando' )
            IF xTIPO = '%' .OR. xTIPO = '$'  // RECALCULAR E GRAVAR
               MDS( 'Aguarde Atualizando Arquivo' )
               RECALC( .T. )
            ENDIF
            EXIT
         CASE LastKey() = K_ALT_F10
            MDS( 'Imprimindo' )
            MANLISTA()
         CASE LastKey() = K_INS
            MDS( 'Incluindo ' )
            fMAD2( 1, pMAD2 )
         CASE LastKey() = K_ENTER .AND. wMAD2 # 3
            MDS( 'Alterando ' )
            fMAD2( 2, pMAD2 )
         CASE LastKey() = K_ENTER .AND. wMAD2 = 3
            MDS( 'Escolhendo' )
            fMAD2( 6, pMAD2 )
            RETU
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fMAD2( 3, pMAD2 )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := IF( lPBUS, NUMIND( "MD02" ), nIBUS )
            mCHABUS := PEGBUS( "MD02", nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( "MD02", nIBUS, mCHABUS )
            ENDIF
            pMAD2 := AScan( aMAD22, mCHAVE )
            IF pMAD2 = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMAD2 := pMAD22
               LOOP
            ENDIF
         CASE LastKey() = LK_ALT_F5  // (RECALCULAR) SEM GRAVAR
            IF xTIPO = '%' .OR. xTIPO = '$'
               RECALC( .F. )
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF

   IF wMAD2 = 0
      // LIBERA VARIAVEIS
      RELEASE ALL LIKE m *   // LIMPAVARS("MD02")

   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( "MD02" )
   ENDIF
   RETU .T.

// ******************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMAD2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMAD2( OPRMAD2, POSMAD2 )   // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ******************
// Pegar a Chave de Busca
   IF OPRMAD2 # 1
      IF cVIDE = 'S'
         mCHAVE := aMAD22[ POSMAD2 ]
      ENDIF
      IF cVIDE = "N" .AND. POSMAD2 # 1
         PEGBUS( "MD02", 1 )
      ENDIF
   ENDIF

// Opera‡„o de Exclus„o
   IF OPRMAD2 = 3
      IF APAGAREG( "MD02", mCHAVE )
         IF cVIDE = "S"
            IF xTIPO = ' '
               aMAD21[ POSMAD2 ] = ' ' + mCODIGO1 + ' - Registro Excluido / Apagado / Deletado'
            ELSE
               aMAD21[ POSMAD2 ] = ' ' + DToC( mDATA ) + ' - Registro Excluido / Apagado / Deletado'
            ENDIF
         ENDIF
         PCK := .T.
      ENDIF
      RETU .T.
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMAD2 = 1
      nROW := 24
      PEGBUS( "MD02", 1 )
      IF !NOVOREG( "MD02", mCHAVE )
         RETU .F.
      ENDIF
   ENDIF



// IGUALAR mVARS
   IF !IGUALVARS( "MD02", mCHAVE )
      RETU .F.
   ENDIF


   IF OPRMAD2 # 1
      // Get nas Menvars
      gMAD2()
   ENDIF



// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMAD2 # 1
      DO CASE
      CASE xTIPO = '%'
         aMAD21[ POSMAD2 ] = ' ' + DToC( mDATA ) + ' ' + TRANSF( mVARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMUGERA, '@E 99,999,999.9999' ) + ' '
      CASE xTIPO = 'P'
         aMAD21[ POSMAD2 ] = ' ' + DToC( mDATA ) + ' ' + TRANSF( mVARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMUGERA, '@E 99,999,999.9999' ) + ' '
      CASE xTIPO = '$'
         aMAD21[ POSMAD2 ] = ' ' + DToC( mDATA ) + ' ' + TRANSF( mVALOR, '@E 99,999,999.99' ) + ' ' + TRANSF( mVARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMUGERA, '@E 999,999,999.9' ) + ' '
      CASE xTIPO = 'V'
         aMAD21[ POSMAD2 ] = ' ' + DToC( mDATA ) + ' ' + TRANSF( mVALOR, '@E 9,999,999.999' ) + ' ' + TRANSF( mVARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMUGERA, '@E 999,999,999.9' ) + ' '
      OTHERWISE
         aMAD21[ POSMAD2 ] = ' ' + mCODIGO1 + ' ' + mDESCRICAO + ' ' + DToC( mDATA ) + ' ' + TRANSF( mVARIACAO, '@E 9,999,999.9999' ) + ' '
      ENDCASE
      aMAD22[ POSMAD2 ] = mCODIGO + mCODIGO1 + DToS( mDATA )
      aMAD23[ POSMAD2 ] = mDATA
      aMAD24[ POSMAD2 ] = mVALOR
      aMAD25[ POSMAD2 ] = mVARIACAO
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMAD2 = 1
      nSBAR++
      AAdd( aMAD21, NIL )
      AAdd( aMAD22, NIL )
      AAdd( aMAD23, NIL )
      AAdd( aMAD24, NIL )
      AAdd( aMAD25, NIL )
      POSMAD2 := Len( aMAD21 )
      POSW    := 1
      IF POSMAD2 > 1
         FOR X := 1 TO POSMAD2 - 1
            mDARE := aMAD22[ X ]
            IF mCHAVE <= mDARE   // IF mCODIGO+CODIGO1+DTOS(DATA)<=mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aMAD21, POSW )
      AIns( aMAD22, POSW )
      AIns( aMAD23, POSW )
      AIns( aMAD24, POSW )
      AIns( aMAD25, POSW )
      DO CASE
      CASE xTIPO = '%'
         aMAD21[ POSW ] = ' ' + DToC( mDATA ) + ' ' + TRANSF( mVARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMUGERA, '@E 99,999,999.9999' ) + ' '
      CASE xTIPO = 'P'
         aMAD21[ POSW ] = ' ' + DToC( mDATA ) + ' ' + TRANSF( mVARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMUGERA, '@E 99,999,999.9999' ) + ' '
      CASE xTIPO = '$'
         aMAD21[ POSW ] = ' ' + DToC( mDATA ) + ' ' + TRANSF( mVALOR, '@E 99,999,999.99' ) + ' ' + TRANSF( mVARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMUGERA, '@E 999,999,999.9' ) + ' '
      CASE xTIPO = 'V'
         aMAD21[ POSW ] = ' ' + DToC( mDATA ) + ' ' + TRANSF( mVALOR, '@E 9,999,999.999' ) + ' ' + TRANSF( mVARIACAO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULADO, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMULANU, '@E 999,999.9999' ) + ' ' + TRANSF( mACUMUGERA, '@E 999,999,999.9' ) + ' '
      OTHERWISE
         aMAD21[ POSW ] = ' ' + mCODIGO1 + ' ' + mDESCRICAO + ' ' + DToC( mDATA ) + ' ' + TRANSF( mVARIACAO, '@E 9,999,999.9999' ) + ' '
      ENDCASE
      aMAD22[ POSW ] = mCODIGO + mCODIGO1 + DToS( mDATA )
      aMAD23[ POSW ] = mDATA
      aMAD24[ POSW ] = mVALOR
      aMAD25[ POSW ] = mVARIACAO
      pMAD2 := POSW
   ENDIF

   REPORVARS( "MD02", mCHAVE )  // REPORVARS("MD02",mCODIGO+CODIGO1+DTOS(DATA))

   RETU .T.


// !*****************************************************************************
// !
// !         Fun‡„o: RECALC()
// !
// !    Chamado por: M_AD2.PRG
// !
// !          Chama: PADRAO             (processo  em MLIBRARY.PRG)
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RECALC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC RECALC( GRAVAR )

   MDS( 'Aguarde Fazendo os Calculos...' )
   tPOS   := Len( aMAD21 )
   aMAD26 := Array( tPOS )   // CONTEM O ACUMULADO
   aMAD27 := Array( tPOS )   // CONTEM O ACUMULANU
   aMAD28 := Array( tPOS )   // CONTEM O ACUMUGERA
   AFill( aMAD26, 0 )
   AFill( aMAD27, 0 )
   AFill( aMAD28, 0 )
   FOR X := 1 TO tPOS
      IF aMAD23[ X ] # CToD( "00/00/00" )
         IF X = 1  // NAO EXISTE REGISTRO SUPERIOR A ESTE (NICIO DO ARQUIVO)
            VAL   := VAL1 := VAL1A := VAL1B := 0
            VAL1C := VAL := 1
         ELSE
            VAL   := aMAD24[ X - 1 ]
            VAL1  := aMAD25[ X - 1 ]
            VAL1A := aMAD26[ X - 1 ]
            VAL1B := aMAD27[ X - 1 ]
            VAL1C := aMAD28[ X - 1 ]
         ENDIF
         IF xTIPO = '%'
            // * ACUMULANDO APENAS A VARIACAO DO ANO  <<<<<<<<<<<<<<
            IF Month( aMAD23[ X ] ) = 1 .AND. Day( aMAD23[ X ] ) = 1
               aMAD26[ X ] = aMAD25[ X ]
            ELSE
               aMAD26[ X ] = ( ( ( ( ( VAL1A / 100 ) + 1 ) * ( ( aMAD25[ X ] / 100 ) + 1 ) ) - 1 ) * 100 )
            ENDIF
            aMAD28[ X ] = ( ( ( aMAD25[ X ] / 100 ) + 1 ) * VAL1C )
            VAL1C := aMAD28[ X ]
            // * ACUMULANDO A VARIACAO DOS ULTIMOS 12 MESES <<<<<<<<<<<<<<<<<
            xDAT   := Day( aMAD23[ X ] )
            xMES   := Month( aMAD23[ X ] )
            xANO   := ( Year( aMAD23[ X ] ) - 1 )
            xDAT   := IF( xDAT > 10, Str( xDAT, 2 ), Str( xDAT, 1 ) )
            xMES   := IF( xMES > 10, Str( xMES, 2 ), Str( xMES, 1 ) )
            xANO   := SubStr( Str( xANO, 4 ), 3, 2 )
            xANO12 := CToD( xDAT + '/' + xMES + '/' + xANO )
            xCHAVE := AScan( aMAD23, xANO12 )
            xVAL   := IF( xCHAVE # 0, ( ( ( VAL1C / aMAD28[ xCHAVE ] ) - 1 ) * 100 ), 0 )
            aMAD27[ X ] = xVAL
            aMAD24[ X ] = aMAD28[ X ]
         ELSE
            aMAD25[ X ] = IF( VAL = 0, 0, ( ( aMAD24[ X ] / VAL ) - 1 ) * 100 )
            // * ACUMULANDO APENAS A VARIACAO DO ANO  <<<<<<<<<<<<<<
            IF Month( aMAD23[ X ] ) = 1 .AND. Day( aMAD23[ X ] ) = 1
               xVAL := IF( VAL # 0, ( ( ( aMAD24[ X ] / VAL ) - 1 ) * 100 ), 0 )
               aMAD26[ X ] = xVAL
               aMAD25[ X ] = xVAL
            ELSE
               xANO   := ( Year( aMAD23[ X ] ) - 1 )
               xANO   := SubStr( Str( xANO, 4 ), 3, 2 )
               xANO12 := CToD( '01' + '/' + '12' + '/' + xANO )
               xVAL   := aMAD24[ X ]
               xCHAVE := AScan( aMAD23, XANO12 )
               xVAL   := IF( xCHAVE # 0, ( ( ( xVAL / aMAD24[ X ] ) - 1 ) * 100 ), 0 )
               aMAD26[ X ] = xVAL
            ENDIF
            // * ACUMULO GERAL DE TODA A TABELA
            aMAD28[ X ] = ( ( ( aMAD25[ X ] / 100 ) + 1 ) * VAL1C )
            // * ACUMULANDO A VARIACAO DOS ULTIMOS 12 MESES <<<<<<<<<<<<<<<<<
            xDAT   := Day( aMAD23[ X ] )
            xMES   := Month( aMAD23[ X ] )
            xAno   := ( Year( aMAD23[ X ] ) - 1 )
            xDAT   := IF( xDAT > 10, Str( xDAT, 2 ), Str( xDAT, 1 ) )
            xMES   := IF( xMES > 10, Str( xMES, 2 ), Str( xMES, 1 ) )
            xANO   := SubStr( Str( xANO, 4 ), 3, 2 )
            xANO12 := CToD( xDAT + '/' + xMES + '/' + xANO )
            xCHAVE := AScan( aMAD23, xANO12 )
            xVAL   := IF( xCHAVE # 0, ( ( ( VAL / aMAD24[ xCHAVE ] ) - 1 ) * 100 ), 0 )
            aMAD27[ X ] = xVAL
         ENDIF
      ENDIF
   NEXT X
   FOR X := 1 TO tPOS
      IF xTIPO = '%'
         aMAD21[ X ] = ' ' + DToC( aMAD23[ X ] ) + ' ' + TRANSF( aMAD25[ X ], '@E 999,999.9999' ) + ' ' + TRANSF( aMAD26[ X ], '@E 999,999.9999' ) + ' ' + TRANSF( aMAD27[ X ], '@E 999,999.9999' ) + ' ' + TRANSF( aMAD28[ X ], '@E 99,999,999.9999' ) + ' '
      ELSE
         aMAD21[ X ] = ' ' + DToC( aMAD23[ X ] ) + ' ' + TRANSF( aMAD24[ X ], '@E 99,999,999.99' ) + ' ' + TRANSF( aMAD25[ X ], '@E 999,999.9999' ) + ' ' + TRANSF( aMAD28[ X ], '@E 999,999.9999' ) + ' ' + TRANSF( aMAD27[ X ], '@E 999,999.9999' ) + ' ' + TRANSF( aMAD28[ X ], '@E 999,999,999.9' ) + ' '
      ENDIF
   NEXT X
   IF GRAVAR
      MDS( 'Aguarde Gravando os Valores Calculados' )
      USEREDE( "MD02", 1, 99 )
      FOR X := 1 TO tPOS
         dbGoTop()
         IF dbSeek( mCODIGO + aMAD22[ X ] + DToS( aMAD23[ X ] ) )
            netreclock()
            FIELD->CODIGO1   := aMAD22[ X ]
            FIELD->DATA      := aMAD23[ X ]
            FIELD->VALOR     := aMAD24[ X ]
            FIELD->VARIACAO  := aMAD25[ X ]
            FIELD->ACUMULADO := aMAD26[ X ]
            FIELD->ACUMULANU := aMAD27[ X ]
            FIELD->ACUMUGERA := aMAD28[ X ]
            dbUnlock()
         ENDIF
      NEXT X
      dbCloseAll()
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAD2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMAD2

   SET KEY K_F11 TO TECLAF11
   hb_DispBox( 9, 0, 23, 79, B_DOUBLE )
   @ 10, 1  SAY "Sub-Codigo"
   @ 11, 1  SAY "Descri‡Æo"
   @ 12, 1  SAY "Data"
   @ 13, 1  SAY "Valor"
   @ 14, 1  SAY "Varia‡Æo"
   @ 15, 1  SAY "Acumulado"
   @ 16, 1  SAY "Acu.Anual"
   @ 17, 1  SAY "Acu.Geral"
   @ 10, 10 GET mCODIGO1
   @ 11, 10 GET mDESCRICAO
   @ 12, 10 GET mDATA
   @ 13, 10 GET mVALOR       PICT '@E 9,999,999.999'
   @ 14, 10 GET mVARIACAO    PICT '@E 999,999.9999'
   @ 15, 10 GET mACUMULADO   PICT '@E 999,999.9999'
   @ 16, 10 GET mACUMULANU   PICT '@E 999,999.9999'
   @ 17, 10 GET mACUMUGERA   PICT '@E 9999,999.9999'
   READCUR()
   SET KEY K_F11 TO
   RETU .T.


// + EOF: m_ad2.prg
// +
