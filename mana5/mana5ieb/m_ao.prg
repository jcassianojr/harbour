// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ao.prg
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => J:\ITAESBRA\M_AO.PRG
// +
// +    Functions: Function fMAO()
// +               Function tMAO()
// +               Function gMAO()
// +               Function MAO1K01()
// +
// +    Reformatted by Click! 2.03 on May-23-2000 at  2:19 pm
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_ao()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_ao

   PARA nTIPO

   lPACKMAO := .F.
   wMAO     := 0
   wpMAO    := 1
   wcMAO    := 0

   cAMO1 := "MO01"
   cAMO2 := "MO02"

   IF nTIPO = 2
      cAMO1 := "MO01BX"
      cAMO2 := "MO02BX"
   ENDIF
   IF nTIPO = 3
      cVAR  := MESANO()
      cAMO1 := "O1" + cVAR
      cAMO2 := "O2" + cVAR
   ENDIF

   mESTADO  := "SP"
   yCFONEW  := ""
   yCFONEWB := ""
   mTIPOENT := ""
   sMAO201  := SENHAX( "MAO201" )

// Tela Devolucao
   aMDETEL := TELAPEG( "MMDE01" )
   aMDEGET := EDITPEG( "MMDE01" )

// Itens Pedidos
   aMO2TEL := TELAPEG( "ITMO21" )
   aMO2GET := EDITPEG( "ITMO21" )


   CRIARVARS( "OF01" )
   CRIARVARS( "OF02" )
   CRIARVARS( "OR01" )
   CRIARVARS( "MO02" )


   PADRAX( 0,, 0, { cAMO1, cAMO2 }, "Pedido   Data     NЃmeroOS Cliente           Data Base Entrega", ;
      "' '+str(mPEDIDO,8,2)+' '+dtoc(mDATA)+' '+str(mOS,8,2)+' '+str(mFORNECEDO,5)+' '+mCOGNOME+' '+dtoc(mDATABASE)+' '+dtoc(mENTREGA)+' '+mPEDIDOCLI+' '+STR(mPEDCLIITE,3)", ;
      "ITMO01", "ITMO01",, {|| MAODEL() }, ;
      {|| MAOPOSREP() }, {|| MAOPREINS() }, "MAO",,,, {|| MAOPOSINS() },, )

// Ajuste
   IF lPACKMAO
      MAOFIXAR()
   ENDIF


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAODEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAODEL()

   lPACKMAO  := .T.
   lAPAGAITE := .T.
   IF cVIDE = "T"
      // Tbrowse ja fez o equvars()
      // mPEDIDO :=PEDIDO
   ELSE
      mPEDIDO := mCHAVE
   ENDIF
   WHILE !USEREDE( "MO02", 1, 99 )
   ENDDO
   dbSeek( Str( mPEDIDO, 8, 2 ) + " 1" )
   WHILE PEDIDO = mPEDIDO .AND. !Eof()
      mOF    := mOS
      gCHAVE := Str( mOS, 8, 2 ) + Str( mITEM, 3 )
      // IF QTDEENT>0
      // lAPAGAITE:=MDG("OS ja com entregas Apagar Mesmo Assim")
      // ENDIF
      IF lAPAGAITE
         DELEREG(,,, .F. )
         IF GERAOF = "S"
            APAGAREG( "OF01", gCHAVE, .F., .F.,, .F. )
            MAOFDEL()
         ENDIF
      ENDIF
      dbSelectAr( "MO02" )
      dbSkip()
   ENDDO
   dbCloseArea()
   RETU lAPAGAITE


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPREINS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPREINS()

   CRIARVARS( "MO02" )
   @ 24, 00
   @ 24, 00 SAY "OS Entrega Hora"
   @ 24, 20 GET mPEDIDO
   @ 24, 30 GET mENTREGA
   @ 24, 40 GET mHORAPRG
   READCUR()
   mOS := mPEDIDO
   PEGACAMPO( "OSCRT", "INT(mOS)", { "CLIENTE", "DATA", "PEDIDOCLI", "PEDCLIITE", "CODIGO" }, ;
      { "mFORNECEDO", "mDATABASE", "mPEDIDOCLI", "mPEDCLIITE", "mCODIGO" } )
   mBUSTMP := Str( Mfornecedo, 5 ) + PadR( mCODIGO, 24 ) + DToS( mENTREGA ) + Str( mHORAPRG, 5, 2 )
// ALERTX(Mbustmp)
   IF VERSEHA( "MO02", mBUSTMP,,, .F., 5 )
      RETU MDG( "Ja existe outra OS para " + DToC( mENTREGA ) + " Gravar Nova" )
   ENDIF
   MAO1K01()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPOSINS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPOSINS()

// mOS   := mPEDIDO
   mDATA   := ZDATA
   mGERAOF := "N"
// movido preins
// PEGACAMPO("OSCRT","INT(mOS)",{"CLIENTE","DATA","PEDIDOCLI","PEDCLIITE","DATAENT"},;
// {"mFORNECEDO","mDATABASE","mPEDIDOCLI","mPEDCLIITE","mENTREGA"})
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOPOSREP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAOPOSREP()

   xFORNECEDO := mFORNECEDO
   xCOGNOME   := mCOGNOME
   xPEDIDO    := mPEDIDO
   mOS        := mPEDIDO
   xOS        := mOS
   xVENDEDOR  := mVENDEDOR
   xCOMISSAO  := mCOMISSAO
   xZONA      := mZONA
   xDATA      := mDATA
   xICM       := mICM
   xBASE      := mDATABASE
   M_AO2( 1 )
   IF cVIDE # "T"
      GRAVAMVAR( "MO01", mPEDIDO, "ENTREGA", "mENTREGA" )
   ELSE
      dbSelectAr( cAMO1 )
      GRAVACAMPO( { "ENTREGA" }, { "mENTREGA" } )
   ENDIF
   RETU .T.




// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MAO1K01()
// +
// +    Called from ( m_ao.prg     )   1 - function gmao()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAO1K01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAO1K01()

// PARA O CALCULO DO ICM
   IF INCLUI
      PEGACAMPO( "MA01", "mFORNECEDO", { "COGNOME", "ESTADO", "CONDPAG", "VENDEDOR", "ZONA" }, { "mCOGNOME", "mESTADO", "mCONDPAG", "mVENDEDOR", "mZONA" } )
   ELSE
      PEGACAMPO( "MA01", "mFORNECEDO", { "COGNOME", "ESTADO" }, { "mCOGNOME", "mESTADO" } )
   ENDIF
   mICM := OBTER( "MD05", mESTADO, "ALIQUOTA" )
   IF !INCLUI
      IF Empty( mCONDPAG )
         mCONDPAG := OBTER( "MA01", mFORNECEDO, "CONDPAG" )
      ENDIF
      IF Empty( mVENDEDOR )
         mVENDEDOR := OBTER( "MA01", mFORNECEDO, "VENDEDOR" )
      ENDIF
      IF Empty( mZONA )
         mZONA := OBTER( "MA01", mFORNECEDO, "ZONA" )
      ENDIF
   ENDIF
   RETU .T.

// + EOF: M_AO.PRG

// + EOF: m_ao.prg
// +
