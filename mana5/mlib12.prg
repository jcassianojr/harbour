// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib12.prg
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



// cTAB   ->Codigo da Tabela
// cSUBTAB->Sub Codigo da Tabela
// dDATA  ->Data da Tabela
// mVAL   ->Nome da Variavel que Recebera o Valor Obtido
// nVAL   ->Valor Para Convers„o
// mCON   ->Nome da Variavel que Recebera o Valor Convertido
// nCAS   ->Casas de Arredondamento
// nROW, nCOL, cPIC  -> Posi‡„o para Exibir o Valor
// nROW2,nCOL2,cPIC2 -> Posi‡„o para Exibir o Valor Convertido



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CONVTAB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CONVTAB( cTAB, cSUBTAB, dDATA, mVAL, nVAL, mCON, nCAS, nROW, nCOL, cPIC, nROW2, nCOL2, cPIC2 )

   LOCAL nVALOBI := nVALCON := 0

   IF Empty( cTAB ) .OR. Empty( dDATA )
      RETU .T.
   ENDIF
   cTAB := PadR( cTAB, 12 )
   IF ValType( cSUBTAB ) # "C"
      cSUBTAB := Space( 12 )
   ENDIF
   nVALOBI := OBTER( "MD02", cTAB + cSUBTAB + DToS( dDATA ), "VALOR" )
   IF !Empty( nVALOBI )
      IF ValType( mVAL ) = "C"
         &mVAL. := nVALOBI
      ENDIF
      IF ValType( nVAL ) = "N"
         IF ValType( nCAS ) # "N"
            nCAS := 2
         ENDIF
         nVALCON := Round( nVAL / nVALOBI, nCAS )
      ENDIF
      IF ValType( mCON ) = "C"
         &mCON. := nVALCON
      ENDIF
      IF ValType( nROW ) = "N" .AND. ValType( nCOL ) = "N"
         IF ValType( cPIC ) = "C"
            @ nROW, nCOL SAY nVALOBI PICT cPIC
         ELSE
            @ nROW, nCOL SAY nVALOBI
         ENDIF
      ENDIF
      IF ValType( nROW2 ) = "N" .AND. ValType( nCOL2 ) = "N" .AND. !Empty( nVALCON )
         IF ValType( cPIC2 ) = "C"
            @ nROW2, nCOL2 SAY &mCON. PICT cPIC2
         ELSE
            @ nROW2, nCOL2 SAY &mCON.
         ENDIF
      ENDIF
   ENDIF
   RETU .T.


// + EOF: mlib12.prg
// +
