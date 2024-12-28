// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib47.prg
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





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IMPREL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC IMPREL

   PARA mGRUPO, mCODIGO, ARQREL, ARQRE1
   LOCAL cTELA

   IF IGUALVARS( ARQREL, mGRUPO + mCODIGO )
      cTELA := SaveScreen( 00, 00, 2, 79 )
      MANB2()
      IMPEND()
      RestScreen( 00, 00, 2, 79, cTELA )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MANLISTA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MANLISTA( cGRUPO )

   IF ValType( cGRUPO ) # "C" .AND. Type( "ZGRUPO" ) = "C"
      cGRUPO := zGRUPO
   ENDIF
   IF MDG( "Relatorios Especificos" )
      PRIV ARQREL := "MANREL"
      PRIV ARQRE1 := "MANRE1"
   ELSE
      PRIV ARQREL := "PADREL"
      PRIV ARQRE1 := "PADRE1"
   ENDIF
   CRIARVARS( "MANREL" )
   mMENU  := cGRUPO
   mGRUPO := cGRUPO
   aMCN21 := {}  // Matriz com os dizeres do Achoice
   aMCN22 := {}  // Codigo do Relatorio
   M_CN2( 3 )  // Chama com 3 para Escolher relatorio
   RETU .T.


// + EOF: mlib47.prg
// +
