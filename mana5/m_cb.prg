// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cb.prg
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
// :       M_CB.PRG: Configuracao de Arquivos
// :      Linguagem: Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 05/02/94     11:18
// :
// :  Procs & Fncts: M_CB()
// :               : FMCB()
// :
// :     Documentado 05/13/94 em 14:48                DISK!  vers„o 5.01
// :*****************************************************************************

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

PRIV mDBF, xARQUIVO

PADRAX( 0,, 0, { ZARQ, ZARQ1 }, "Arquivo  Descri‡„o", ;
      "' '+mARQUIVO+' '+mDRIVER+' '+mDESCRICAO", "MCB001", "MCB001", ;
      {|| MCBEN2() }, {|| PADDEL( zARQ1, xCHAVE, "ARQUIVO", "xCHAVE" ) }, {|| M_CB2( 1 ) }, ;
      , "MCB",, {| nKEY, nPOS | MCBTEC( nKEY, nPOS ) } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MCBEN2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MCBEN2

   mDBF     := mARQUIVO
   xARQUIVO := mARQUIVO  // Campo Indentico no MANHEL
   M_CO2( 1 )
   mARQUIVO := xARQUIVO
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MCBTEC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MCBTEC( nKEY, nPOS )

   IF nKEY = K_ALT_ENTER
      mARQUIVO := aPAX2[ nPOS ]
      M_DB( "ARQUIVO=mARQUIVO" )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MCBK01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MCBK01

   mIBUS := NUMIND( mARQUIVO, mIBUS )
   @ 08, 48 SAY mIBUS
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MCBK02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MCBK02

   mIEXI := NUMIND( mARQUIVO, mIBUS )
   @ 09, 48 SAY mIEXI
   RETU .T.

// + EOF: m_cb.prg
// +
