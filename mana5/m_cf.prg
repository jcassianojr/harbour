// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cf.prg
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
// :       M_CF.PRG: Arquivo de Ajuda ONline
// :      Linguagem: Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 05/03/94     12:11
// :
// :  Procs & Fncts: M_CF()
// :               : FMCF()
// :
// :
// :     Arq. Dados: HELPARQ - Arquivo de Ajuda ONLine
// :
// :        Indices: Pela Refer�ncia do Arquivo e Campo
// :                 DBF+CAMPO
// :
// :     Documentado 05/13/94 em 14:48                DISK!  vers�o 5.01
// :*****************************************************************************


// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
// #INCLUDE "MEMOGET.CH"
// #INCLUDE "FILEGET.CH"



PADRAX( 0,, 0, { HELPARQ }, "Posi��o Variavel   Arquivo Descri��o", ;
      "' '+mDBF+' '+mCAMPO+' '+mARQUIVO+' '+mDADO", "MCF001", {|| gMCF() },,, ;
      ,, "MCF",,,,,, "" )






// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMCF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gMCF

// Get nas Menvars
   SetColor( CORPAX[ 1 ] )
   @  4, 30 GET mDBF
   @  6, 30 GET mCAMPO
   @  6, 63 GET mSEQ   PICTURE '999'
// @  8,30 GET mDESCRICAO MEMO coord {12,00,24,79} boxcolor CORMCF[6]
// @ 10,30 GET mARQUIVO FILE CAMINHO ZDIRP+"MAN\"
   @ 13, 2  GET mDADO
   @ 16, 2  GET mPRELAN
   @ 18, 02 GET mCONDICAO
   READCUR()
   RETU .T.

// + EOF: m_cf.prg
// +
