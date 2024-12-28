// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a21.prg
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

// :*****************************************************************************
// :
// :   M_A2   .PRG : Cadastro de Pecas Estoque
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5/ITAESBRA
// :      Copyright (c) 1998, Disk Soft S/C Ltda.
// :
// :*****************************************************************************

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

PRIV xNOME, xUNIDADE, xESTQINI, xDATABALAN

sMAS601 := SENHAX( "MAS601",, .F. )

sMAS006 := SENHAX( "MAS006",, .F. )

CRIARVARS( "OP02" )
CRIARVARS( "MS01" )
CRIARVARS( "MS01I" )
CRIARVARS( "MS03" )
CRIARVARS( "MS06" )
CRIARVARS( "MSOP" )



PADRAO( 0, 1, 0, "MS01", "Codigo" + spac( 19 ) + "Descri‡„o" + spac( 32 ) + "Estoque", ;
      "' '+mCODIGO+' '+mNOME+' '+STR(mESTQSAL, 10, 3)", ;
      "MA2",,,,, {| nKEY | MA2KEY( nKEY ) }, {|| MA2IGU() }, {|| MA2ROD() } )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2IGU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MA2IGU()

   xESTQINI := mESTQINI
   RETU .F.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2KEY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2KEY( nKEY )

   mATIVO := OBTER( "MS01", AllTrim( SubStr( aPAD2[ pPAD ], 1, 24 ) ), "ATIVO", 2 )
   IF mATIVO = "N"
      ALERTX( "Produto NÆo Esta Ativo" )
      RETU .T.
   ENDIF
   DO CASE
   CASE nKEY = K_ALT_F3
      mCODIGO := SubStr( aPAD2[ pPAD ], 1, 24 )
      xCODIGO := mCODIGO
      M_AS3( 1 )
   CASE nKEY = K_ALT_F4
      mCODIGO := SubStr( aPAD2[ pPAD ], 1, 24 )
      xCODIGO := mCODIGO
      mOP     := OBTER( "OP01", AllTrim( xCODIGO ), "OP", 2 )
      PADRAO( 1, 1, 0, "MS06", "Codigo               Seq SSQ Operacao", ;
         "' '+mCODIGO+' '+STR(mSEQ,3)+STR(mSSQ,3)+' '+LEFT(mDESCRI,30)", ;
         "MAS6", "MAS601", "MAS601", ;
         {|| mCODIGO := xCODIGO }, {|| PADARR( "MS06", xCODIGO, "XCODIGO", "CODIGO" ) },, ;
         {|| MA2IGU() },,, {|| NOVOREG( "OP02", mCHAVE, .F.,, 4 ) },, ;
         {|| APAGAREG( "OP02", mCHAVE, .F., .F., 4 ) } )

      // {|| MA2IGU()},,,{|| NOVOREG("OP02",PADR(xCODIGO,24)+STR(mSEQ,3)+STR(mSSQ,3),.F.,,4 )},,;
      // {|| APAGAREG("OP02",PADR(xCODIGO,24)+STR(mSEQ,3)+STR(mSSQ,3),.F.,.F.,4)})
      ALERTX( "Modificacoes Processo Checar Ordem Produ‡ao/Recalcular" )
   CASE nKEY = K_ALT_F2
      mCODIGO := AllTrim( SubStr( aPAD2[ pPAD ], 1, 24 ) )
      ARQWORK := "MS99"
      M_AS99()
      mCODIGO := PadR( mCODIGO, 24 )
   CASE nKEY = K_ALT_F5
      mCODIGO := aPAD2[ pPAD ]
      xCODIGO := mCODIGO
      PADRAO( 1, 1, 0, "MS01I", "Codigo" + spac( 19 ) + "Ite Tip Especificado", ;
         "' '+mCODIGO+' '+STR(mITEM,  3)+' '+mTIPA+' '+mESPE", ;
         "MSI", "MSI", "MSI", ;
         {|| mCODIGO := xCODIGO }, {|| PADARR( "MS01I", xCODIGO, "CODIGO", "xCODIGO" ) } )
   CASE nKEY = K_ALT_F6
      mCODIGO := AllTrim( SubStr( aPAD2[ pPAD ], 1, 24 ) )
      xCODIGO := mCODIGO
      PADRAO( 1, 1, 0, "MSOP", "Codigo" + spac( 19 ) + "Local" + spac( 6 ) + "OP" + spac( 7 ) + "Qtde", ;
         "' '+mCODIGO+' '+mLOCAL+' '+STR(mOP,8)+' '+STR(mQTDE,10)", ;
         "MSOP", "MSOP", "MSOP", ;
         {|| mCODIGO := xCODIGO }, {|| PADARR( "MSOP", AllTrim( xCODIGO ), "ALLTRIM(CODIGO)", "ALLTRIM(xCODIGO)", 1 ) } )
   ENDCASE
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA2ROD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA2ROD()

   @ 24, 01 SAY 'Busca:CTRL+ENTER ALT+F2=Movto +F3=Comp +F4=Seq +F5=Ens +F6=OP'
   RETU .T.

// + EOF: m_a21.prg
// +
