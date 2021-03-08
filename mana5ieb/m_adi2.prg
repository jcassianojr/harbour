*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_ADI2.PRG
*+
*+    Functions: Function fMADX()
*+               Function tMADX()
*+               Function gMADX()
*+               Function MADX02()
*+               Function MADX03()
*+               Function MADX04()
*+               Function MADX05()
*+               Function MADI201()
*+
*+    Reformatted by Click! 2.03 on Mar-5-2001 at  2:08 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ


function m_adi2
para wMADX, wpMADX, wcMADX

if pcount() < 3
   wcMADX := 0
endif

//Teclas Operacionais
//#INCLUDE "TECLAS.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

//Modo de Trabalho no Video
MDI( " Э ",,, ARQWORK4 )

//Configura‡„o de Trabalho
priv lFIXA
priv nACHO
priv cVIDE
priv lPBUS
priv lPIND
priv mCBAR
priv mCBARM
priv cTIPG
priv aGETS
priv cCBAS
priv nIBUS
priv nIEXI
priv aIND
priv nREG
if !CONFARQ( ARQWORK4, "Ordem   N.Fiscal   Data           Tipo  Fornecedor" + spac( 13 ) + "Total do Item" )
   retu .F.
endif
if !CONFIND( ARQWORK4 )
   retu .F.
endif

//Pegando Cores de Trabalho
CORMAX := CORARR( "MDI2" )

//Variaveis de Trabalho
priv PCK    := .F.
priv mCHAVE
priv mITEM
DESEJA     := space( 1 )
mDESCRICAO := space( 15 )
VERIFICA   := 0.00

if wMADX = 0
   CRIARVARS( ARQWORK4 )
endif
//CRIANDO MATRIZES
if wcMADX = 0
   aMADX1 := {}     //Matriz com os dizeres do Achoice
   aMADX2 := {}     //NЈmero de Ordem + NЈmero Nota Fiscal + Cўdigo de Opera‡„o
   aMADX3 := {}     //Valor Base Icm
   aMADX4 := {}     //Porcento Icm
   aMADX5 := {}     //Valor Icm
   aMADX6 := {}     //Isentas Icm
   aMADX7 := {}     //Outras Icm
   aMADX8 := {}     //Valor Base IPI
   aMADX9 := {}     //Porcento IPI
   aMADX0 := {}     //Valor IPI
   aMADXA := {}     //Isentas IPI
   aMADXB := {}     //Outras IPI
   aMADXC := {}     //Total do Item
endif

pMADX1 := 1         //Posicao da matriz ???
//xGRAF=0
//xPOS=1

//Incializando a ajuda on Line
priv HELPDBF := "MK04"

if !USEREDE( ARQWORK4, 1, 1 )
   retu
endif
GRAF  := lastrec()
xGRAF := 0
xPOS  := 1
MARCAR()
dbgotop()
dbseek( str( mORDEM, 8 ) )
while mORDEM = ORDEM .and. !eof()
   if !empty( mCBAR )
      aadd( aMADX1, &mCBAR. )
   else
      aadd( aMADX1, ' ' + str( ITEM, 2 ) + ' ' + str( ORDEM, 8 ) + ' ' + str( NUMERO, 6 ) + ' ' + dtoc( DATA ) + ' ' + DCFONEW + ' ' + TIPOFOR + ' ' + str( FORNECEDO, 5 ) + ' ' + COGNOME + ' ' + str( DVALORNF, 18, 2 ) + ' ' + UNIDADE )
   endif
   aadd( aMADX2, str( ORDEM, 8 ) + str( NUMERO, 6 ) + str( ITEM, 2 ) )          //MATRIZ DA CHAVE
   aadd( aMADX3, DBASEICM )
   aadd( aMADX4, DICM )
   aadd( aMADX5, DVALICM )
   aadd( aMADX6, ISENTAICM )
   aadd( aMADX7, OUTRAICM )
   aadd( aMADX8, DBASEIPI )
   aadd( aMADX9, DIPI )
   aadd( aMADX0, DVALIPI )
   aadd( aMADXA, ISENTAIPI )
   aadd( aMADXB, OUTRAIPI )
   aadd( aMADXC, DVALORNF )
   xPOS ++
   MARCAR1()
   dbskip()
enddo
dbclosearea()
if xPOS = 1
   if !MDG( 'Nenhum Lan‡amento Neste Arquivo. Deseja Incluir ?' )
      retu .F.
   endif
   nSBAR := 0
   if !fMADX( 1, 0 )
      retu .F.
   endif
endif

//Posi‡„o Inicial do Ponteiro
if pcount() = 1
   pMADX := 1
else
   pMADX := ascan( aMADX2, wpMADX )
   pMADX := if( pMADX = 0, 1, pMADX )
endif

//Processando o M‚todo Escolhido
NOBREAK()
priv nSBAR
priv aSBAR
nSBAR := len( aMADX1 )
aSBAR := ScrollBarNew( 03, 79, 23,, pMADX )
ScrollBarDisplay( aSBAR )
ScrollBarUpdate( aSBAR, pMADX, nSBAR, .T. )
while .T.
   mTOTBASICM := 0.00
   mTOTVALICM := 0.00
   mTOTISEICM := 0.00
   mTOTOUTICM := 0.00
   mTOTBASIPI := 0.00
   mTOTVALIPI := 0.00
   mTOTISEIPI := 0.00
   mTOTOUTIPI := 0.00
   mTOTVALNF  := 0.00
   for X := 1 to len( aMADXC )
      mTOTBASICM += aMADX3[ X ]
      mTOTVALICM += aMADX5[ X ]
      mTOTISEICM += aMADX6[ X ]
      mTOTOUTICM += aMADX7[ X ]
      mTOTBASIPI += aMADX8[ X ]
      mTOTVALIPI += aMADX0[ X ]
      mTOTISEIPI += aMADXA[ X ]
      mTOTOUTIPI += aMADXB[ X ]
      mTOTVALNF  += aMADXC[ X ]
   next X
   setcolor( CORMAX[ 1 ] )
   HB_dispbox( 2, 0, 23, 79, B_DOUBLE)
   setcolor( "W+/B" )
   @  2, 19 say " I T E N S    D A    N O T A    F I S C A L "
   setcolor( CORMAX[ 1 ] )
   @  3,  1 say "It Ordem   N.Fiscal   Data  Opera‡„o Tipo  Fornecedor" + spac( 11 ) + "Total do Item"
   @  4,  0 say '+' + replicate( '-', 78 ) + 'Э'
   setcolor( 'W+/B' )
   @ 24, 00 clea
   @ 24, 02 say 'Busca:                Apagar:        Incluir:         Ultimo :'
   setcolor( CORMAX[ 1 ] )
   @ 24, 09 say 'CTRL+Enter'
   @ 24, 32 say 'DEL'
   @ 24, 48 say 'INS'
   @ 24, 65 say 'CTRL+PgDw'
   ScrollBarUpdate( aSBAR, pMADX, nSBAR, .T. )
   ScrollBarDisplay( aSBAR )
   pMADX2 := achoice( 05, 01, 22, 78, aMADX1,, "ACHRETB", pMADX )
   pMADX  := if( pMADX2 # 0, pMADX2, pMADX )
   pMADX2 := pMADX
   do case
   case LASTKEY() = K_ESC
      exit
   case LASTKEY() = K_ALT_F10
      MDS( 'Imprimindo' )
      MANLISTA()
   case LASTKEY() = K_INS
      MDS( 'Incluindo ' )
      fMADX( 1, pMADX )
   case LASTKEY() = K_ENTER .and. wMADX # 3
      MDS( 'Alterando ' )
      fMADX( 2, pMADX )
   case LASTKEY() = K_ENTER .and. wMADX = 3
      MDS( 'Escolhendo' )
      fMADX( 6, pMADX )
      retu
   case LASTKEY() = K_DEL
      MDS( 'Excluindo ' )
      fMADX( 3, pMADX )
   case LASTKEY() = K_CTRL_ENTER .or. LASTKEY() = K_CTRL_F2                  // CTRL+ENTER USO O aMADX1
      if LASTKEY() = K_CTRL_ENTER
         PEGBUS()
      else
         nIBUS   := if( lPBUS, NUMIND( ARQWORK4 ), nIBUS )
         mCHABUS := PEGBUS( ARQWORK4, nIBUS )
         nREG    := REGBUS( ARQWORK4, nIBUS, mCHABUS )
      endif
      pMADX := ascan( aMADX2, str( mORDEM, 8 ) + str( mNUMERO, 6 ) + str( mITEM, 2 ) )
      if pMADX = 0
         ALERTX( 'N„o localizei o Registro Correspondente ....' )
         pMADX := pMADX2
         loop
      endif
   otherwise
      loop
   endcase
enddo

if wMADX = 0
   //LIBERA VARIAVEIS
   release all like m *                 //LIMPAVARS(ARQWORK4)
endif

//EFETUA O PACK SE NECESSARIO
if PCK .and. lFIXA
   FIXAR( ARQWORK4 )
endif
retu .T.



*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function fMADX()
*+
*+    Called from ( m_adi2.prg   )   5 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func fMADX( OPRMADX, POSMADX )          //INC=1//MUD=2//EXC=3 // POSICAO MATRIZ
INCLUI := .F.
if OPRMADX # 1
   mCHAVE := aMADX2[ POSMADX ]
endif

//Opera‡„o de Inclus„o
if OPRMADX = 1
   if valtype( mITEM ) # "N"
      mITEM := 0
   endif
   mITEM ++
   MDS( "Digite o Item" )
   @ 24, 30 get mITEM pict "99"
   if !READCUR()
      retu .F.
   endif
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
   mDCLASSIPI := space( 15 )
   mDVALORNF  := 0.00
   mUNIDADE   := space( 2 )
   mQUANT     := 0.000
   mDIPAM     := "  "
   mOBSICM    := 0.00
   mOBSIPI    := 0.00
   Mchave     := str( mORDEM, 8 ) + str( mNUMERO, 6 ) + str( mITEM, 2 )
   if !NOVOREG( ARQWORK4, mCHAVE )
      retu .F.
   endif
   INCLUI := .T.
endif

//Igualar Mvars
if !IGUALVARS( ARQWORK4, mCHAVE )
   retu .F.
endif
mDATAREF   := xDATAREF
mORDEM     := xORDEM
mNUMERO    := xNUMERO
mDATA      := xDATA
mTIPOFOR   := xTIPOFOR
mFORNECEDO := xFORNECEDO
mCOGNOME   := xCOGNOME
mESPECIE   := yESPECIE

MAM201()
if empty( mLOTE )
   PEGLOTE( 1, xDATAREF, "mLOTE" )
endif

//Opera‡„o de Exclus„o
if OPRMADX = 3
   if APAGAREG( ARQWORK4, mCHAVE )
      aMADX1[ POSMADX ] = ' ' + str( mNUMERO, 6 ) + '  - Registro Excluido / Apagado / Deletado'
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
   endif
   retu .T.
endif


   // Desenha a Tela
   tMADX()
   // Get nas Menvars
   gMADX()
   INCLUI := .T.

//Atualiza as Matrizes se nao for inclusao
if OPRMADX # 1
   mADI202(POSMADX)
endif

//Posiciona o Novo Elemento na Matriz
if OPRMADX = 1
   nSBAR ++
   aadd( aMADX1, NIL )
   aadd( aMADX2, NIL )
   aadd( aMADX3, NIL )
   aadd( aMADX4, NIL )
   aadd( aMADX5, NIL )
   aadd( aMADX6, NIL )
   aadd( aMADX7, NIL )
   aadd( aMADX8, NIL )
   aadd( aMADX9, NIL )
   aadd( aMADX0, NIL )
   aadd( aMADXA, NIL )
   aadd( aMADXB, NIL )
   aadd( aMADXC, NIL )
   POSMADX := len( aMADX1 )
   POSW    := 1
   if POSMADX > 1
      for X := 1 to POSMADX - 1
         mDARE := aMADX2[ X ]
         if mCHAVE <= mDARE
            exit
         endif
      next
      POSW := X
   endif
   ains( aMADX1, POSW )
   ains( aMADX2, POSW )
   ains( aMADX3, POSW )
   ains( aMADX4, POSW )
   ains( aMADX5, POSW )
   ains( aMADX6, POSW )
   ains( aMADX7, POSW )
   ains( aMADX8, POSW )
   ains( aMADX9, POSW )
   ains( aMADX0, POSW )
   ains( aMADXA, POSW )
   ains( aMADXB, POSW )
   ains( aMADXC, POSW )
   mADI202(POSW)
   pMADX   := POSW
   POSMADX := POSW
endif

REPORVARS( ARQWORK4, mCHAVE )
retu



*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function tMADX()
*+
*+    Called from ( m_adi2.prg   )   1 - function fmadx()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func tMADX          //Layout de Tela.


setcolor( CORMAX[ 1 ] )
HB_dispbox( 2, 0, 23, 79, B_DOUBLE)
@  5,  0 say '+'
@  5, 79 say 'Э'
@  3,  1 say "It Ordem   N.Fiscal   Data    DataRef   Cancelada Opera‡Жo      Total"
@  5,  1 say replicate( '-', 78 )
@  6,  1 say "Cli/Forn"
@  8,  2 say "Soma Valor do IPI na Nota Fiscal ?   <S/N> "
@  9,  2 say "Lote :"
@  9, 30 say "Dipam:"
@ 10,  2 say "Material  para  Uso  e  Consumo  ?   <S/N> "
@ 11,  2 SAY "Considerar PIS/Confins           ?   <S/N> "
@ 12,  2 SAY "Pular Apuracao Sintegra          ?   <S/N> "
@ 12, 46 SAY "Desconto:"
@  8, 64 say "Classif.Fiscal"
@ 13,  2 say "Base Icm          %  Valor Icm        Isentas          Outras"
@ 15,  1 say "Mensagens:"
@ 15, 40 say "Observacao"
@ 17,  2 say "Base IPI          %  Valor IPI        Isentas          Outras"
@ 19,  1 say "Mensagens:"
@ 19, 40 say "Observacao"
@ 21,  2 say "Quantidade : "
@ 21, 30 say "Unidade  :  "
@ 22, 02 say "OBS:"
@ 22, 70 say "Red:"
@  4,  1 say mITEM                                                                                     pict '99'
@  4,  4 say mORDEM                                                                                    pict '99999'
@  4, 13 say mNUMERO                                                                                   pict '999999'
@  4, 21 say mDATA
@  4, 31 say MDATAREF
@  4, 41 say mDCANCEL
@  4, 51 SAY mDCFONEW PICT "@R 9.999"
@  4, 57 SAY mDOPER
@  4, 61 SAY mSUBDOPER
@  4, 64 say mDVALORNF                                                                                 pict "@E 999,999,999.99"
@  6, 10 say mTIPOFOR
@  6, 12 say mFORNECEDO                                                                                pict '99999'
@  6, 22 say mCOGNOME
@  9,  9 say mLOTE                                                                                     picture '99999'
@  9, 40 say mDIPAM
@  8, 37 say mSOMANF
@ 10, 37 say mCONSUMO
@ 11, 37 say mDPISCON
@  9, 65 say mDCLASSIPI
@ 14,  2 say mDBASEICM                                                                                 pict "@E 999,999,999.99"
@ 14, 21 say mDICM                                                                                     pict "99"
@ 14, 25 say mDVALICM                                                                                  pict "@E 999,999,999.99"
@ 14, 43 say mISENTAICM                                                                                pict "@E 999,999,999.99"
@ 14, 61 say mOUTRAICM                                                                                 pict "@E 999,999,999.99"
@ 15, 12 say mMICM01
@ 15, 18 say mMICM02
@ 15, 24 say mMICM03
@ 18,  2 say mDBASEIPI                                                                                 pict "@E 999,999,999.99"
@ 18, 19 say mDIPI PICT "99.9"
@ 18, 25 say mDVALIPI                                                                                  pict "@E 999,999,999.99"
@ 18, 43 say mISENTAIPI                                                                                pict "@E 999,999,999.99"
@ 18, 61 say mOUTRAIPI                                                                                 pict "@E 999,999,999.99"
@ 19, 12 say mMIPI01
@ 19, 18 say mMIPI02
@ 19, 24 say mMIPI03
@ 21, 15 say mQUANT                                                                                    pict '9999999.999'
@ 21, 42 say mUNIDADE                                                                                  pict "@!"
retu .T.



*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function gMADX()
*+
*+    Called from ( m_adi2.prg   )   1 - function fmadx()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func gMADX( nTIPO )                     //Get nas Mvars.


if valtype( nTIPO ) = "N"
   TIPCAD( mTIPOFOR, "ARQUSO" )
   PEGACAMPO( ARQUSO, "mFORNECEDO", "ESTADO", "mESTADO" )
endif
@  4,  1 get mITEM  pict '99'
@  4,  4 get mORDEM pict '999999'
if valtype( nTIPO ) = "N"
   @  4, 21 get MDATA
   @  4, 31 get MDATAREF
   @  4, 41 get mDCANCEL
else
   @  4, 21 say mDATA
endif
@  4, 51 GET mDCFONEW PICT "@R 9.999" valid CHECKCFO( mDCFONEW,nREF, mESTADO, zESTADO, 24, 00 ,,,"mDIPAM","mDOPER",,2,.T.)
@  4, 57 get mDOPER    valid CHECKCFO( mDOPER, nREF, mESTADO, zESTADO)
@  4, 61 get mSUBDOPER
READCUR()
@  6, 10 say mTIPOFOR   pict "@!"
@  6, 12 say mFORNECEDO pict '99999'
@  6, 22 say mCOGNOME   pict "@!"
@  4, 65 get mDVALORNF  pict "999,999,999.99"
@  8, 37 get mSOMANF    pict "@!"                                                        valid mSOMANF $ 'SN'
@  9,  9 get mLOTE      picture '99999'                                                  valid MADI201()
@  9, 40 get mDIPAM     valid CHECKEXI("FI_DIPAM","mDIPAM","DIPAM+' '+Nome","DIPAM","DIPAM",.F.)
@ 10, 37 get mCONSUMO   Valid mCONSUMO $ 'SN'  pict "@!"
@ 11, 37 GET mDPISCON   Valid mDPISCON $ 'SN ' pict "@!"
@ 12, 37 GET mPULASIN   VALID mPULASIN $ 'SN ' pict "@!" when alltrue(IF(empty(mPULASIN).AND.mDVALORNF<0,mPULASIN:="S",.T.))
@ 12, 57 GET mDESCSIN
READCUR()
@  9, 65 get mDCLASSIPI valid CHECKIPI( mDCLASSIPI )
@ 14,  2 get mDBASEICM  pict "999,999,999.99"
@ 14, 21 get mDICM      pict "99"               valid MADX03()
@ 14, 25 get mDVALICM   pict "999,999,999.99"   valid MADX05()
@ 14,  2 say mDBASEICM  pict "@E 999,999,999.99"
@ 14, 21 say mDICM      pict "99.99"
@ 14, 25 say mDVALICM   pict "@E 999,999,999.99"
@ 14, 43 get mISENTAICM pict "999,999,999.99"
@ 14, 61 get mOUTRAICM  pict "999,999,999.99"
@ 15, 61 get mOBSICM    pict "999,999,999.99"
@ 15, 12 get mMICM01    picture '99999'
@ 15, 18 get mMICM02    picture '99999'    when !empty( mMICM01 )
@ 15, 24 get mMICM03    picture '99999'    when !empty( mMICM02 )
READCUR()
@ 18,  2 get mDBASEIPI  pict "999,999,999.99"
@ 18, 19 get mDIPI      pict "99.9"                  valid MADX04()
@ 18, 25 get mDVALIPI   pict "999,999,999.99"    valid MADX02()
@ 18, 25 say mDVALIPI   pict "@E 999,999,999.99"
@ 18, 43 get mISENTAIPI pict "999,999,999.99"
@ 18, 61 get mOUTRAIPI  pict "999,999,999.99"
@ 19, 61 get mOBSIPI    pict "999,999,999.99"
@ 19, 12 get mMIPI01    picture '99999'
@ 19, 18 get mMIPI02    picture '99999'            when !empty( mMIPI01 )
@ 19, 24 get mMIPI03    picture '99999'            when !empty( mMIPI02 )
READCUR()
@ 21, 15 get mQUANT   pict '9999999.999'
@ 21, 42 get mUNIDADE pict '@!'   valid CHECKEXI( "MD07", "mUNIDADE", "UNIDADE+' '+UNIDDES", "UNIDADE", "UNIDADE" )
@ 22, 10 get mOBS PICT "@S50"
if ARQWORK4 = "MM06" .or. left( ARQWORK4, 2 ) = "M6"
   @ 22, 75 get mCHKIPI
endif
READCUR()
nVALDIF:=mDVALORNF-(mDBASEIPI+mDVALIPI+mOUTRAIPI+mOBSIPI+mISENTAIPI)
IF (nVALDIF<=-0.01).OR.(nVALDIF>=0.01)
   ALERTX("Valor Contabil Divergente Valores")
ENDIF
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MADX02()
*+
*+    Called from ( m_adi2.prg   )   1 - function gmadx()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MADX02         //Calcula o Valor Total da Nota Fiscal e a % do IPI.

mDIPI := ( mDVALIPI * 100 ) / mDBASEIPI
setcolor( "N/W" )
@ 18, 19 say mDIPI pict "99.9"
setcolor( CORMAX[ 1 ] )
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MADX03()
*+
*+    Called from ( m_adi2.prg   )   1 - function gmadx()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MADX03         //Calcula Valor do ICM.

mDVALICM := mDBASEICM * ( mDICM / 100 )
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MADX04()
*+
*+    Called from ( m_adi2.prg   )   1 - function gmadx()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MADX04         //Calcula Valor do IPI.

mDVALIPI := mDBASEIPI * ( mDIPI / 100 )
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MADX05()
*+
*+    Called from ( m_adi2.prg   )   1 - function gmadx()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MADX05         //Calcula Valor do ICM.

mDICM := ( mDVALICM * 100 ) / mDBASEICM
setcolor( "N/W" )
@ 14, 21 say mDICM pict "99"
setcolor( CORMAX[ 1 ] )
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MADI201()
*+
*+    Called from ( m_adi2.prg   )   1 - function gmadx()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MADI201

if mLOTE = 9999
   PEGLOTE( 1, xDATAREF, "mLOTE" )
endif
retu .T.

FUNC mADI202(nPOS)
aMADX1[ nPOS ] = ' ' + str( mITEM, 2 ) + ' ' + str( mORDEM, 8 ) + ' ' + str( mNUMERO, 6 ) + ' ' + dtoc( mDATA ) + '  ' + mCFONEW +'.'+mSUBDOPER+ ' ' + mTIPOFOR + ' ' + str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + str( mDVALORNF, 18, 2 ) + ' '
aMADX2[ nPOS ] = str( mORDEM, 8 ) + str( mNUMERO, 6 ) + str( mITEM, 2 )
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


*+ EOF: M_ADI2.PRG
