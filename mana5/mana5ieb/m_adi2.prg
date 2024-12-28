// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_adi2.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_ADI2.PRG
// +
// +    Functions: Function fMADX()
// +               Function tMADX()
// +               Function gMADX()
// +               Function MADX02()
// +               Function MADX03()
// +               Function MADX04()
// +               Function MADX05()
// +               Function MADI201()
// +
// +    Reformatted by Click! 2.03 on Mar-5-2001 at  2:08 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_adi2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_adi2

   PARA wMADX, wpMADX, wcMADX

   IF PCount() < 3
      wcMADX := 0
   ENDIF

// Teclas Operacionais
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"

// Modo de Trabalho no Video
   MDI( " Э ",,, ARQWORK4 )

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
   IF !CONFARQ( ARQWORK4, "Ordem   N.Fiscal   Data           Tipo  Fornecedor" + spac( 13 ) + "Total do Item" )
      RETU .F.
   ENDIF
   IF !CONFIND( ARQWORK4 )
      RETU .F.
   ENDIF

// Pegando Cores de Trabalho
   CORMAX := CORARR( "MDI2" )

// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   PRIV mITEM
   DESEJA     := Space( 1 )
   mDESCRICAO := Space( 15 )
   VERIFICA   := 0.00

   IF wMADX = 0
      CRIARVARS( ARQWORK4 )
   ENDIF
// CRIANDO MATRIZES
   IF wcMADX = 0
      aMADX1 := {}   // Matriz com os dizeres do Achoice
      aMADX2 := {}   // NЈmero de Ordem + NЈmero Nota Fiscal + Cўdigo de Opera‡„o
      aMADX3 := {}   // Valor Base Icm
      aMADX4 := {}   // Porcento Icm
      aMADX5 := {}   // Valor Icm
      aMADX6 := {}   // Isentas Icm
      aMADX7 := {}   // Outras Icm
      aMADX8 := {}   // Valor Base IPI
      aMADX9 := {}   // Porcento IPI
      aMADX0 := {}   // Valor IPI
      aMADXA := {}   // Isentas IPI
      aMADXB := {}   // Outras IPI
      aMADXC := {}   // Total do Item
   ENDIF

   pMADX1 := 1   // Posicao da matriz ???
// xGRAF=0
// xPOS=1

// Incializando a ajuda on Line
   PRIV HELPDBF := "MK04"

   IF !USEREDE( ARQWORK4, 1, 1 )
      RETU
   ENDIF
   GRAF  := LastRec()
   xGRAF := 0
   xPOS  := 1
   MARCAR()
   dbGoTop()
   dbSeek( Str( mORDEM, 8 ) )
   WHILE mORDEM = ORDEM .AND. !Eof()
      IF !Empty( mCBAR )
         AAdd( aMADX1, &mCBAR. )
      ELSE
         AAdd( aMADX1, ' ' + Str( ITEM, 2 ) + ' ' + Str( ORDEM, 8 ) + ' ' + Str( NUMERO, 6 ) + ' ' + DToC( DATA ) + ' ' + DCFONEW + ' ' + TIPOFOR + ' ' + Str( FORNECEDO, 5 ) + ' ' + COGNOME + ' ' + Str( DVALORNF, 18, 2 ) + ' ' + UNIDADE )
      ENDIF
      AAdd( aMADX2, Str( ORDEM, 8 ) + Str( NUMERO, 6 ) + Str( ITEM, 2 ) )  // MATRIZ DA CHAVE
      AAdd( aMADX3, DBASEICM )
      AAdd( aMADX4, DICM )
      AAdd( aMADX5, DVALICM )
      AAdd( aMADX6, ISENTAICM )
      AAdd( aMADX7, OUTRAICM )
      AAdd( aMADX8, DBASEIPI )
      AAdd( aMADX9, DIPI )
      AAdd( aMADX0, DVALIPI )
      AAdd( aMADXA, ISENTAIPI )
      AAdd( aMADXB, OUTRAIPI )
      AAdd( aMADXC, DVALORNF )
      xPOS++
      MARCAR1()
      dbSkip()
   ENDDO
   dbCloseArea()
   IF xPOS = 1
      IF !MDG( 'Nenhum Lan‡amento Neste Arquivo. Deseja Incluir ?' )
         RETU .F.
      ENDIF
      nSBAR := 0
      IF !fMADX( 1, 0 )
         RETU .F.
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   IF PCount() = 1
      pMADX := 1
   ELSE
      pMADX := AScan( aMADX2, wpMADX )
      pMADX := if( pMADX = 0, 1, pMADX )
   ENDIF

// Processando o M‚todo Escolhido
   NOBREAK()
   PRIV nSBAR
   PRIV aSBAR
   nSBAR := Len( aMADX1 )
   aSBAR := ScrollBarNew( 03, 79, 23,, pMADX )
   ScrollBarDisplay( aSBAR )
   ScrollBarUpdate( aSBAR, pMADX, nSBAR, .T. )
   WHILE .T.
      mTOTBASICM := 0.00
      mTOTVALICM := 0.00
      mTOTISEICM := 0.00
      mTOTOUTICM := 0.00
      mTOTBASIPI := 0.00
      mTOTVALIPI := 0.00
      mTOTISEIPI := 0.00
      mTOTOUTIPI := 0.00
      mTOTVALNF  := 0.00
      FOR X := 1 TO Len( aMADXC )
         mTOTBASICM += aMADX3[ X ]
         mTOTVALICM += aMADX5[ X ]
         mTOTISEICM += aMADX6[ X ]
         mTOTOUTICM += aMADX7[ X ]
         mTOTBASIPI += aMADX8[ X ]
         mTOTVALIPI += aMADX0[ X ]
         mTOTISEIPI += aMADXA[ X ]
         mTOTOUTIPI += aMADXB[ X ]
         mTOTVALNF  += aMADXC[ X ]
      NEXT X
      SetColor( CORMAX[ 1 ] )
      hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
      SetColor( "W+/B" )
      @  2, 19 SAY " I T E N S    D A    N O T A    F I S C A L "
      SetColor( CORMAX[ 1 ] )
      @  3, 1 SAY "It Ordem   N.Fiscal   Data  Opera‡„o Tipo  Fornecedor" + spac( 11 ) + "Total do Item"
      @  4, 0 SAY '+' + Replicate( '-', 78 ) + 'Э'
      SetColor( 'W+/B' )
      @ 24, 00 clea
      @ 24, 02 SAY 'Busca:                Apagar:        Incluir:         Ultimo :'
      SetColor( CORMAX[ 1 ] )
      @ 24, 09 SAY 'CTRL+Enter'
      @ 24, 32 SAY 'DEL'
      @ 24, 48 SAY 'INS'
      @ 24, 65 SAY 'CTRL+PgDw'
      ScrollBarUpdate( aSBAR, pMADX, nSBAR, .T. )
      ScrollBarDisplay( aSBAR )
      pMADX2 := AChoice( 05, 01, 22, 78, aMADX1,, "ACHRETB", pMADX )
      pMADX  := if( pMADX2 # 0, pMADX2, pMADX )
      pMADX2 := pMADX
      DO CASE
      CASE LastKey() = K_ESC
         EXIT
      CASE LastKey() = K_ALT_F10
         MDS( 'Imprimindo' )
         MANLISTA()
      CASE LastKey() = K_INS
         MDS( 'Incluindo ' )
         fMADX( 1, pMADX )
      CASE LastKey() = K_ENTER .AND. wMADX # 3
         MDS( 'Alterando ' )
         fMADX( 2, pMADX )
      CASE LastKey() = K_ENTER .AND. wMADX = 3
         MDS( 'Escolhendo' )
         fMADX( 6, pMADX )
         RETU
      CASE LastKey() = K_DEL
         MDS( 'Excluindo ' )
         fMADX( 3, pMADX )
      CASE LastKey() = K_CTRL_ENTER .OR. LastKey() = K_CTRL_F2   // CTRL+ENTER USO O aMADX1
         IF LastKey() = K_CTRL_ENTER
            PEGBUS()
         ELSE
            nIBUS   := if( lPBUS, NUMIND( ARQWORK4 ), nIBUS )
            mCHABUS := PEGBUS( ARQWORK4, nIBUS )
            nREG    := REGBUS( ARQWORK4, nIBUS, mCHABUS )
         ENDIF
         pMADX := AScan( aMADX2, Str( mORDEM, 8 ) + Str( mNUMERO, 6 ) + Str( mITEM, 2 ) )
         IF pMADX = 0
            ALERTX( 'N„o localizei o Registro Correspondente ....' )
            pMADX := pMADX2
            LOOP
         ENDIF
      OTHERWISE
         LOOP
      ENDCASE
   ENDDO

   IF wMADX = 0
      // LIBERA VARIAVEIS
      RELEASE ALL LIKE m *   // LIMPAVARS(ARQWORK4)
   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( ARQWORK4 )
   ENDIF
   RETU .T.



// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function fMADX()
// +
// +    Called from ( m_adi2.prg   )   5 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMADX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMADX( OPRMADX, POSMADX )   // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

   INCLUI := .F.
   IF OPRMADX # 1
      mCHAVE := aMADX2[ POSMADX ]
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMADX = 1
      IF ValType( mITEM ) # "N"
         mITEM := 0
      ENDIF
      mITEM++
      MDS( "Digite o Item" )
      @ 24, 30 GET mITEM PICT "99"
      IF !READCUR()
         RETU .F.
      ENDIF
      // Limpando vari veis no momento de inclus„o de dados.
      mLOTE      := 0
      mDBASEICM  := 0.00
      mDICM      := 00
      mDVALICM   := 0.00
      mISENTAICM := 0.00
      mOUTRAICM  := 0.00
      mDBASEIPI  := 0.00
      mDIPI      := 00.0
      mDVALIPI   := 0.00
      mISENTAIPI := 0.00
      mOUTRAIPI  := 0.00
      mDCLASSIPI := Space( 15 )
      mDVALORNF  := 0.00
      mUNIDADE   := Space( 2 )
      mQUANT     := 0.000
      mDIPAM     := "  "
      mOBSICM    := 0.00
      mOBSIPI    := 0.00
      Mchave     := Str( mORDEM, 8 ) + Str( mNUMERO, 6 ) + Str( mITEM, 2 )
      IF !NOVOREG( ARQWORK4, mCHAVE )
         RETU .F.
      ENDIF
      INCLUI := .T.
   ENDIF

// Igualar Mvars
   IF !IGUALVARS( ARQWORK4, mCHAVE )
      RETU .F.
   ENDIF
   mDATAREF   := xDATAREF
   mORDEM     := xORDEM
   mNUMERO    := xNUMERO
   mDATA      := xDATA
   mTIPOFOR   := xTIPOFOR
   mFORNECEDO := xFORNECEDO
   mCOGNOME   := xCOGNOME
   mESPECIE   := yESPECIE

   MAM201()
   IF Empty( mLOTE )
      PEGLOTE( 1, xDATAREF, "mLOTE" )
   ENDIF

// Opera‡„o de Exclus„o
   IF OPRMADX = 3
      IF APAGAREG( ARQWORK4, mCHAVE )
         aMADX1[ POSMADX ] = ' ' + Str( mNUMERO, 6 ) + '  - Registro Excluido / Apagado / Deletado'
         PCK := .T.
         aMADX2[ POSMADX ] = mCHAVE
         aMADX3[ POSMADX ] = 0
         aMADX4[ POSMADX ] = 0
         aMADX5[ POSMADX ] = 0
         aMADX6[ POSMADX ] = 0
         aMADX7[ POSMADX ] = 0
         aMADX8[ POSMADX ] = 0
         aMADX9[ POSMADX ] = 0
         aMADX0[ POSMADX ] = 0
         aMADXA[ POSMADX ] = 0
         aMADXB[ POSMADX ] = 0
         aMADXC[ POSMADX ] = 0
      ENDIF
      RETU .T.
   ENDIF


// Desenha a Tela
   tMADX()
// Get nas Menvars
   gMADX()
   INCLUI := .T.

// Atualiza as Matrizes se nao for inclusao
   IF OPRMADX # 1
      mADI202( POSMADX )
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF OPRMADX = 1
      nSBAR++
      AAdd( aMADX1, NIL )
      AAdd( aMADX2, NIL )
      AAdd( aMADX3, NIL )
      AAdd( aMADX4, NIL )
      AAdd( aMADX5, NIL )
      AAdd( aMADX6, NIL )
      AAdd( aMADX7, NIL )
      AAdd( aMADX8, NIL )
      AAdd( aMADX9, NIL )
      AAdd( aMADX0, NIL )
      AAdd( aMADXA, NIL )
      AAdd( aMADXB, NIL )
      AAdd( aMADXC, NIL )
      POSMADX := Len( aMADX1 )
      POSW    := 1
      IF POSMADX > 1
         FOR X := 1 TO POSMADX - 1
            mDARE := aMADX2[ X ]
            IF mCHAVE <= mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aMADX1, POSW )
      AIns( aMADX2, POSW )
      AIns( aMADX3, POSW )
      AIns( aMADX4, POSW )
      AIns( aMADX5, POSW )
      AIns( aMADX6, POSW )
      AIns( aMADX7, POSW )
      AIns( aMADX8, POSW )
      AIns( aMADX9, POSW )
      AIns( aMADX0, POSW )
      AIns( aMADXA, POSW )
      AIns( aMADXB, POSW )
      AIns( aMADXC, POSW )
      mADI202( POSW )
      pMADX   := POSW
      POSMADX := POSW
   ENDIF

   REPORVARS( ARQWORK4, mCHAVE )
   RETU



// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function tMADX()
// +
// +    Called from ( m_adi2.prg   )   1 - function fmadx()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tMADX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tMADX  // Layout de Tela.

   SetColor( CORMAX[ 1 ] )
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
   @  5, 0  SAY '+'
   @  5, 79 SAY 'Э'
   @  3, 1  SAY "It Ordem   N.Fiscal   Data    DataRef   Cancelada Opera‡Жo      Total"
   @  5, 1  SAY Replicate( '-', 78 )
   @  6, 1  SAY "Cli/Forn"
   @  8, 2  SAY "Soma Valor do IPI na Nota Fiscal ?   <S/N> "
   @  9, 2  SAY "Lote :"
   @  9, 30 SAY "Dipam:"
   @ 10, 2  SAY "Material  para  Uso  e  Consumo  ?   <S/N> "
   @ 11, 2  SAY "Considerar PIS/Confins           ?   <S/N> "
   @ 12, 2  SAY "Pular Apuracao Sintegra          ?   <S/N> "
   @ 12, 46 SAY "Desconto:"
   @  8, 64 SAY "Classif.Fiscal"
   @ 13, 2  SAY "Base Icm          %  Valor Icm        Isentas          Outras"
   @ 15, 1  SAY "Mensagens:"
   @ 15, 40 SAY "Observacao"
   @ 17, 2  SAY "Base IPI          %  Valor IPI        Isentas          Outras"
   @ 19, 1  SAY "Mensagens:"
   @ 19, 40 SAY "Observacao"
   @ 21, 2  SAY "Quantidade : "
   @ 21, 30 SAY "Unidade  :  "
   @ 22, 02 SAY "OBS:"
   @ 22, 70 SAY "Red:"
   @  4, 1  SAY mITEM                                                                   PICT '99'
   @  4, 4  SAY mORDEM                                                                  PICT '99999'
   @  4, 13 SAY mNUMERO                                                                 PICT '999999'
   @  4, 21 SAY mDATA
   @  4, 31 SAY MDATAREF
   @  4, 41 SAY mDCANCEL
   @  4, 51 SAY mDCFONEW                                                                PICT "@R 9.999"
   @  4, 57 SAY mDOPER
   @  4, 61 SAY mSUBDOPER
   @  4, 64 SAY mDVALORNF                                                               PICT "@E 999,999,999.99"
   @  6, 10 SAY mTIPOFOR
   @  6, 12 SAY mFORNECEDO                                                              PICT '99999'
   @  6, 22 SAY mCOGNOME
   @  9, 9  SAY mLOTE                                                                   PICTURE '99999'
   @  9, 40 SAY mDIPAM
   @  8, 37 SAY mSOMANF
   @ 10, 37 SAY mCONSUMO
   @ 11, 37 SAY mDPISCON
   @  9, 65 SAY mDCLASSIPI
   @ 14, 2  SAY mDBASEICM                                                               PICT "@E 999,999,999.99"
   @ 14, 21 SAY mDICM                                                                   PICT "99"
   @ 14, 25 SAY mDVALICM                                                                PICT "@E 999,999,999.99"
   @ 14, 43 SAY mISENTAICM                                                              PICT "@E 999,999,999.99"
   @ 14, 61 SAY mOUTRAICM                                                               PICT "@E 999,999,999.99"
   @ 15, 12 SAY mMICM01
   @ 15, 18 SAY mMICM02
   @ 15, 24 SAY mMICM03
   @ 18, 2  SAY mDBASEIPI                                                               PICT "@E 999,999,999.99"
   @ 18, 19 SAY mDIPI                                                                   PICT "99.9"
   @ 18, 25 SAY mDVALIPI                                                                PICT "@E 999,999,999.99"
   @ 18, 43 SAY mISENTAIPI                                                              PICT "@E 999,999,999.99"
   @ 18, 61 SAY mOUTRAIPI                                                               PICT "@E 999,999,999.99"
   @ 19, 12 SAY mMIPI01
   @ 19, 18 SAY mMIPI02
   @ 19, 24 SAY mMIPI03
   @ 21, 15 SAY mQUANT                                                                  PICT '9999999.999'
   @ 21, 42 SAY mUNIDADE                                                                PICT "@!"
   RETU .T.



// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function gMADX()
// +
// +    Called from ( m_adi2.prg   )   1 - function fmadx()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMADX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMADX( nTIPO )   // Get nas Mvars.

   IF ValType( nTIPO ) = "N"
      TIPCAD( mTIPOFOR, "ARQUSO" )
      PEGACAMPO( ARQUSO, "mFORNECEDO", "ESTADO", "mESTADO" )
   ENDIF
   @  4, 1 GET mITEM  PICT '99'
   @  4, 4 GET mORDEM PICT '999999'
   IF ValType( nTIPO ) = "N"
      @  4, 21 GET MDATA
      @  4, 31 GET MDATAREF
      @  4, 41 GET mDCANCEL
   ELSE
      @  4, 21 SAY mDATA
   ENDIF
   @  4, 51 GET mDCFONEW  PICT "@R 9.999"                             VALID CHECKCFO( mDCFONEW, nREF, mESTADO, zESTADO, 24, 00,,, "mDIPAM", "mDOPER",, 2, .T. )
   @  4, 57 GET mDOPER    VALID CHECKCFO( mDOPER, nREF, mESTADO, zESTADO )
   @  4, 61 GET mSUBDOPER
   READCUR()
   @  6, 10 SAY mTIPOFOR   PICT "@!"
   @  6, 12 SAY mFORNECEDO PICT '99999'
   @  6, 22 SAY mCOGNOME   PICT "@!"
   @  4, 65 GET mDVALORNF  PICT "999,999,999.99"
   @  8, 37 GET mSOMANF    PICT "@!"                                                                VALID mSOMANF $ 'SN'
   @  9, 9  GET mLOTE      PICTURE '99999'                                                          VALID MADI201()
   @  9, 40 GET mDIPAM     VALID CHECKEXI( "FI_DIPAM", "mDIPAM", "DIPAM+' '+Nome", "DIPAM", "DIPAM", .F. )
   @ 10, 37 GET mCONSUMO   VALID mCONSUMO $ 'SN'                                                    PICT "@!"
   @ 11, 37 GET mDPISCON   VALID mDPISCON $ 'SN '                                                   PICT "@!"
   @ 12, 37 GET mPULASIN   VALID mPULASIN $ 'SN '                                                   PICT "@!"            WHEN alltrue( IF( Empty( mPULASIN ) .AND. mDVALORNF < 0, mPULASIN := "S", .T. ) )
   @ 12, 57 GET mDESCSIN
   READCUR()
   @  9, 65 GET mDCLASSIPI VALID CHECKIPI( mDCLASSIPI )
   @ 14, 2  GET mDBASEICM  PICT "999,999,999.99"
   @ 14, 21 GET mDICM      PICT "99"                  VALID MADX03()
   @ 14, 25 GET mDVALICM   PICT "999,999,999.99"      VALID MADX05()
   @ 14, 2  SAY mDBASEICM  PICT "@E 999,999,999.99"
   @ 14, 21 SAY mDICM      PICT "99.99"
   @ 14, 25 SAY mDVALICM   PICT "@E 999,999,999.99"
   @ 14, 43 GET mISENTAICM PICT "999,999,999.99"
   @ 14, 61 GET mOUTRAICM  PICT "999,999,999.99"
   @ 15, 61 GET mOBSICM    PICT "999,999,999.99"
   @ 15, 12 GET mMICM01    PICTURE '99999'
   @ 15, 18 GET mMICM02    PICTURE '99999'            WHEN !Empty( mMICM01 )
   @ 15, 24 GET mMICM03    PICTURE '99999'            WHEN !Empty( mMICM02 )
   READCUR()
   @ 18, 2  GET mDBASEIPI  PICT "999,999,999.99"
   @ 18, 19 GET mDIPI      PICT "99.9"              VALID MADX04()
   @ 18, 25 GET mDVALIPI   PICT "999,999,999.99"    VALID MADX02()
   @ 18, 25 SAY mDVALIPI   PICT "@E 999,999,999.99"
   @ 18, 43 GET mISENTAIPI PICT "999,999,999.99"
   @ 18, 61 GET mOUTRAIPI  PICT "999,999,999.99"
   @ 19, 61 GET mOBSIPI    PICT "999,999,999.99"
   @ 19, 12 GET mMIPI01    PICTURE '99999'
   @ 19, 18 GET mMIPI02    PICTURE '99999'          WHEN !Empty( mMIPI01 )
   @ 19, 24 GET mMIPI03    PICTURE '99999'          WHEN !Empty( mMIPI02 )
   READCUR()
   @ 21, 15 GET mQUANT   PICT '9999999.999'
   @ 21, 42 GET mUNIDADE PICT '@!'          VALID CHECKEXI( "MD07", "mUNIDADE", "UNIDADE+' '+UNIDDES", "UNIDADE", "UNIDADE" )
   @ 22, 10 GET mOBS     PICT "@S50"
   IF ARQWORK4 = "MM06" .OR. Left( ARQWORK4, 2 ) = "M6"
      @ 22, 75 GET mCHKIPI
   ENDIF
   READCUR()
   nVALDIF := mDVALORNF - ( mDBASEIPI + mDVALIPI + mOUTRAIPI + mOBSIPI + mISENTAIPI )
   IF ( nVALDIF <= -0.01 ) .OR. ( nVALDIF >= 0.01 )
      ALERTX( "Valor Contabil Divergente Valores" )
   ENDIF
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MADX02()
// +
// +    Called from ( m_adi2.prg   )   1 - function gmadx()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MADX02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MADX02   // Calcula o Valor Total da Nota Fiscal e a % do IPI.

   mDIPI := ( mDVALIPI * 100 ) / mDBASEIPI
   SetColor( "N/W" )
   @ 18, 19 SAY mDIPI PICT "99.9"
   SetColor( CORMAX[ 1 ] )
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MADX03()
// +
// +    Called from ( m_adi2.prg   )   1 - function gmadx()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MADX03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MADX03   // Calcula Valor do ICM.

   mDVALICM := mDBASEICM * ( mDICM / 100 )
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MADX04()
// +
// +    Called from ( m_adi2.prg   )   1 - function gmadx()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MADX04()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MADX04   // Calcula Valor do IPI.

   mDVALIPI := mDBASEIPI * ( mDIPI / 100 )
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MADX05()
// +
// +    Called from ( m_adi2.prg   )   1 - function gmadx()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MADX05()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MADX05   // Calcula Valor do ICM.

   mDICM := ( mDVALICM * 100 ) / mDBASEICM
   SetColor( "N/W" )
   @ 14, 21 SAY mDICM PICT "99"
   SetColor( CORMAX[ 1 ] )
   RETU .T.

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MADI201()
// +
// +    Called from ( m_adi2.prg   )   1 - function gmadx()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MADI201()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MADI201

   IF mLOTE = 9999
      PEGLOTE( 1, xDATAREF, "mLOTE" )
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function mADI202()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC mADI202( nPOS )

   aMADX1[ nPOS ] = ' ' + Str( mITEM, 2 ) + ' ' + Str( mORDEM, 8 ) + ' ' + Str( mNUMERO, 6 ) + ' ' + DToC( mDATA ) + '  ' + mCFONEW + '.' + mSUBDOPER + ' ' + mTIPOFOR + ' ' + Str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + Str( mDVALORNF, 18, 2 ) + ' '
   aMADX2[ nPOS ] = Str( mORDEM, 8 ) + Str( mNUMERO, 6 ) + Str( mITEM, 2 )
   aMADX3[ nPOS ] = mDBASEICM
   aMADX4[ nPOS ] = mDICM
   aMADX5[ nPOS ] = mDVALICM
   aMADX6[ nPOS ] = mISENTAICM
   aMADX7[ nPOS ] = mOUTRAICM
   aMADX8[ nPOS ] = mDBASEIPI
   aMADX9[ nPOS ] = mDIPI
   aMADX0[ nPOS ] = mDVALIPI
   aMADXA[ nPOS ] = mISENTAIPI
   aMADXB[ nPOS ] = mOUTRAIPI
   aMADXC[ nPOS ] = mDVALORNF
   RETU .T.


// + EOF: M_ADI2.PRG

// + EOF: m_adi2.prg
// +
