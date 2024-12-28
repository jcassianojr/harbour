// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib13.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



// Processa o Metodo Ininterrupto
// cARQ -> Nome do Arquivo
// bCHA -> Bloco Para Chaves Especiais
// bALT -> Bloco que chama a Fun‡„o de Altera‡„o
// EX: de Chamada ("MC01",,"{||fMAC(2,-1)}) 2->Alterar -1 N„o Repergunta Chave
#include "INKEY.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function METINT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC METINT( cARQ, bCHA, bALT )

   WHILE .T.
      IF ValType( bCHA ) = "B"
         Eval( bCHA )
      ELSE
         PEGBUS( cARQ, 1 )
      ENDIF
      IF LastKey() = K_ESC
         EXIT
      ENDIF
      IF !VERSEHA( cARQ, mCHAVE )
         NOVOREG( cARQ, mCHAVE )
      ENDIF
      Eval( bALT )
   ENDDO


// + EOF: mlib13.prg
// +
