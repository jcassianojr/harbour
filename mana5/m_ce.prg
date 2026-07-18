// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ce.prg
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
// :       M_CE.PRG: Arquivo do manual
// :      Linguagem: harbour
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 05/02/94     11:18
// :
// :  Procs & Fncts: M_CE()
// :               : FMCE()
// :
// :          Chama: MDI()              (fun��o    em ?)
// :               : MDF()              (fun��o    em ?)
// :               : CONFARQ()          (fun��o    em ?)
// :               : COR()              (fun��o    em ?)
// :               : CRIARVARS()        (fun��o    em ?)
// :               : USEREDE()          (fun��o    em ?)
// :               : MARCAR()           (fun��o    em ?)
// :               : MARCAR1()          (fun��o    em ?)
// :               : FMCE()             (fun��o    em M_CE.PRG)
// :               : SCROLLBARDISPLAY() (fun��o    em ?)
// :               : ACHRETB()          (fun��o    em ?, chamado  no Achoice())
// :               : MANLISTA()         (fun��o    em ?)
// :               : FIXAR()            (fun��o    em ?)
// :
// :    Arq. Manual: MANAMAN - Arquivo do Manual
// :
// :       Indices : Por C�digo de Arquivo
// :                 ARQUIVO
// :
// :     Documentado 05/13/94 em 14:48                DISK!  vers�o 5.01
// :*****************************************************************************



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
// #INCLUDE "FILEGET.CH"



PADRAO( 0, 1, 0, "MANAMAN", "Descri��o", "' '+mDESCRICAO", "MCE", "MCE001", {|| gMCE() } )





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMCE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gMCE

// Get nas Menvars
   SetColor( PAD002 )
   @  4, 2 GET mDESCRICAO
// @  6,2 GET mARQUIVO FILE CAMINHO ZDIRP+"MAN\"
   READCUR()
   RETU .T.


// + EOF: m_ce.prg
// +
