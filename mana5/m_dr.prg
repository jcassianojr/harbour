// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_dr.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :   M_DR   .PRG : Mala Direta
// :   Linguagem   : harbour
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :  Procs & Fncts: fMDR()
// :
// :    Chamado por:
// :
// :          Chama: fMDR  (fun��o em M_DR.PRG )
// :
// :  Arq. Dados   : MALA       - Mala Direta
// :
// :  Indices      : MALA       - Numero de Controle
// :                 NUMERO
// :
// :
// :  Documentado em:  29, 1994 as 13:08:07                DISK!  vers�o 5.01
// :*****************************************************************************



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
// #INCLUDE "MEMOGET.CH"

aVARL := {}   // Variavel de Pr� Lan�amento

// Monta Pr� Lan�amento
IF USEREDE( HELPARQ, 1, 1 )
dbGoTop()
dbSeek( ARQWORK )
WHILE DBF = ARQWORK .AND. !Eof()
IF !Empty( PRELAN )
AAdd( aVARL, { CAMPO, PRELAN } )
ENDIF
dbSkip()
ENDDO
dbCloseArea()
ENDIF



PADRAO( 0, 1, 0, ARQWORK, "Numero  Nome", ;
      "' '+STR(mNUMERO,  8)+' '+mNOME", ;
      "MDR", "MDR001", {|| gMDR() } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDRINS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MDRINS

   mNUMERO := ULTIMOREG( ARQWORK, "NUMERO" )
   mNUMERO++
   IF !Empty( aVARL )
      FOR X := 1 TO Len( aVARL )
         cCAMPO   := aVARL[ X, 1 ]
         cVAR     := aVARL[ X, 2 ]
         &cCAMPO. := &cVAR.
      NEXT X
   ENDIF




// Get Nas Mvars


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMDR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMDR

   SetColor( CORPAD[ 2 ] )
   @  4, 10 GET mNOME
   @  7, 1  GET mESTADO    VALID CHECKUF( "mESTADO" )
   @  7, 5  GET mCIDADE    VALID CHECKCID( mESTADO, "mCIDADE" )
   @  7, 43 GET mBAIRRO
   @ 10, 1  GET mENDLOG    WHEN IF( Empty( mENDLOG ), ESCOLHELOG( "mENDLOG" ), .T. )
   @ 10, 14 GET mENDRUA    VALID ENDCID( mESTADO, mCIDADE, "mENDRUA", "mCEP", "mENDNUM" ) .AND. MDR01( 11, 1 )
   @ 10, 64 GET mENDNUM    VALID ENDCID( mESTADO, mCIDADE, "mENDRUA", "mCEP", "mENDNUM" ) .AND. MDR01( 11, 1 )
   @ 11, 1  GET mENDERECO  WHEN Empty( mENDLOG )
   @ 11, 70 GET mCEP       PICTURE "99999-999"                                                        WHEN VERCEP( "mCEP" )   VALID CHECK5CEP( mCEP ) .AND. CHKUFCEP( mCEP, mESTADO )
   @ 14, 1  GET mDDD       WHEN VERDDD( "mDDD" )
   @ 14, 6  GET mTELEFONE
   @ 14, 16 GET mCONTATO
   @ 14, 27 GET mDATACONTA
   @ 14, 41 GET mIMPRIME   PICTURE "!"                                                                VALID mIMPRIME $ 'SN'
// @ 17,1  GET mOBS MEMO coord {17,1,23,78} //boxcolor MCFN03
   IF !READCUR()
      RETU .T.
   ENDIF

   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDR01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MDR01( nROW, nCOL, eDIZ )

   IF ValType( nROW ) # "N"
      nROW := 24
   ENDIF
   IF ValType( nCOL ) # "N"
      nCOL := 01
   ENDIF
   IF !Empty( mENDLOG )
      mENDERECO := PadR( AllTrim( mENDLOG ) + ' ' + AllTrim( mENDRUA ) + ' ' + AllTrim( mENDNUM ), 68 )
      IF ValType( eDIZ ) = "C"
         @ nROW, nCOL SAY &eDIZ
      ELSE
         @ nROW, nCOL SAY mENDERECO
      ENDIF
   ENDIF
   RETU .T.

// + EOF: m_dr.prg
// +
