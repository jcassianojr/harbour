// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ch.prg
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



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"


PADRAO( 0, 1, 0, "MACESS", "C¢digo Descri‡„o", "' '+mCODIGO+' '+mDESCRICAO", "MCH" )


// ** Libera‡„o de Senhas Especiais


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SENHAX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC SENHAX( cCHAVE, cTITULO, lMES, cSENHA, nLEN )

   LOCAL lRETU := .F.

   IF ValType( nLEN ) # "N"
      nLEN := 5
   ENDIF
   IF ValType( cTITULO ) # "C"
      cTITULO := "Checando Acesso"
   ENDIF
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   MDS( cTITULO )
   lRETU := PEGACS( "A", cCHAVE + ZUSER, .T. )
   IF !lRETU .AND. lMES
      ALERTX( "Acesso Bloqueado - " + cCHAVE )
   ENDIF
   RETU lRETU



// + EOF: m_ch.prg
// +
