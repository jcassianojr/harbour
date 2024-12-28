// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_am4.prg
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


// :*****************************************************************************
// :
// :   M_AM4  .PRG : Mensagens Corpo Nota Fiscal
// :   Linguagem   : Clipper 5.x
// :        Sistema: Manager 5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMAM4()
// :
// :    Chamado por:
// :
// :          Chama: fMAM4  (fun‡„o em M_AM4.PRG )
// :
// :  Arq. Dados   : MM04       - Mensagens Corpo Nota Fiscal
// :
// :  Indices      : MM04-1     - N£mero das Mensagens
// :                 NUMMENS
// :
// :
// :  Documentado em:  2, 1994 as 14:12:23                DISK!  vers„o 5.01
// :*****************************************************************************




// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_am4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_am4

   PARA cARQ

   IF ValType( cARQ ) = "C"
      ARQWORK := cARQ
   ENDIF

   PADRAO( 0, 1, 0, ARQWORK, "N£mero  Descri‡„o", ;
      "' '+STR(mNUMMENS,  5)+' '+mDESMENS", ;
      "MAM4",,, {|| ULTIMOREG( ARQWORK, "NUMMENS", "mNUMMENS" ) } )




// + EOF: m_am4.prg
// +
