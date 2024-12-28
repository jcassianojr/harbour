// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aa.prg
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
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// Senhas de Acesso
sMAA001 := SENHAX( "MAA001",, .F. )

// Telas de Trabalho
aMAAE01 := EDITPEG( "MAA001" )
aMAAT02 := TELAPEG( "MAA002" )
aMAAE02 := EDITPEG( "MAA002" )
aMAAT03 := TELAPEG( "MAA003" )
aMAAE03 := EDITPEG( "MAA003" )

PADRAO( 0, 1, 0, "MA01", "N£mero Cognome" + spac( 6 ) + "Raz„o Social/Nome Completo", ;
      "' '+STR(mNUMERO,  5)+' '+mCOGNOME+' '+SUBSTR(mNOME,1,40)+' '+mDDD+' '+mTELEFONE", ;
      "MAA", "MAA001", {|| gMAA() }, ;
      {|| PADCGC( "MA01", ZIMA ) } )

// Get Nas Mvars



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gMAA

   SetColor( PAD002 )
   SET KEY K_F11 TO TECLAF11
   TELA := 0
   WHILE .T.
      TELA += if( LastKey() = K_PGUP, - 1, 1 )
      TELA := if( LastKey() = K_ESC, 0, TELA )
      TELA := if( LastKey() = K_CTRL_W, 0, TELA )
      DO CASE
      CASE TELA = 1
         MAATELA1()
      CASE TELA = 2
         TELASAY( aMAAT02 )
         EDITSAY( aMAAE02 )
      CASE TELA = 3
         TELASAY( aMAAT03 )
         EDITSAY( aMAAE03 )
      OTHERWISE
         EXIT
      ENDCASE
   ENDDO
   SET KEY K_F11 TO
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAATELA1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAATELA1

   TELASAY( aPADTEL )
   EDITSAY( aMAAE01 )
   IF INCLUI
      mENDERECO2 := mENDERECO
      mBAIRRO2   := mBAIRRO
      mCIDADE2   := mCIDADE
      mESTADO2   := mESTADO
      mCEP2      := mCEP
      mDDD2      := mDDD
      mTELEFONE2 := mTELEFONE
      mRAMAL2    := mRAMAL
      mCONTATO2  := mCONTATO
      mDDDFAX2   := mDDDFAX
      mTELEFAX2  := mTELEFAX
      mENDERECO3 := mENDERECO
      mBAIRRO3   := mBAIRRO
      mCIDADE3   := mCIDADE
      mESTADO3   := mESTADO
      mCEP3      := mCEP
      mDDD3      := mDDD
      mTELEFONE3 := mTELEFONE
      mRAMAL3    := mRAMAL
      mCONTATO3  := mCONTATO
      mDDDFAX3   := mDDDFAX
      mTELEFAX3  := mTELEFAX
      mCGC3      := mCGC
      mNOME3     := mNOME
      mDTCAD     := ZDATA
   ENDIF
   RETU .T.


// + EOF: m_aa.prg
// +
