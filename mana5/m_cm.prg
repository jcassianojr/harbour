// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cm.prg
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
// :   M_CM   .PRG : Mensagem do Sistema
// :   Linguagem   : harbour
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :  Procs & Fncts: fMCM()
// :
// :    Chamado por:
// :
// :          Chama: fMCM  (fun��o em M_CM.PRG )
// :
// :  Arq. Dados   : MMES       - Mensagem do Sistema
// :
// :  Indices      : MMES       - C�digo da Mensagem
// :                 CODIGO
// :
// :
// :  Documentado em: Junh 9, 1994 as 14:43:05                DISK!  vers�o 5.01
// :*****************************************************************************




// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
// #INCLUDE "MEMOGET.CH"



PADRAO( 0, 1, 0, "MMES", "Codigo Utilizacao", ;
      "' '+mCODIGO+' '+mUSO", "MCM", "MCM001", {|| gMCM() } )



// Get Nas Mvars


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMCM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gMCM

   SetColor( PAD002 )
   @  5, 2 GET mCODIGO
   @  8, 2 GET mUSO
   @ 11, 2 GET mMENSAGEM
// @ 14,2 GET mDESCRICAO MEMO coord {15,09,21,72} boxcolor MCFN003
   READCUR()
   mDESCRICAO := StrTran( mDESCRICAO, Chr( 141 ) + Chr( 10 ), Chr( 13 ) + Chr( 10 ) )
   RETU .T.


// + EOF: m_cm.prg
// +
