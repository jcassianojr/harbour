// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_dm.prg
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

PADRAX( 0,, 0, { "MEXPOR", "MEXPOR1" }, "C¢digo ArqOri   Arq.Des  Descri‡„o", ;
      "' '+mCODIGO+' '+mARQORI+' '+mARQDES+' '+mDESCRICAO", "MDK001", "MDK001", ;
      , {|| PADDEL( "MEXPOR1", xCHAVE, "CODIGO", "xCHAVE" ) }, {|| MDKREP() } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDKREP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MDKREP

   IF mdg( "Deseja rever Vari veis de Transferencia" )
      xCODIGO := mCODIGO
      PADRAO( 1, 1, 0, "MEXPOR1", "C¢digo Destino    Origem", ;
         "' '+mCODIGO+' '+mVARDES+' '+mVARDRI", ;
         "MDK2",,, {|| mCODIGO := xCODIGO }, {|| PADARR( "MEXPOR1", xCODIGO, "CODIGO", "XCODIGO" ) } )
   ENDIF
   RETU .T.


// + EOF: m_dm.prg
// +
