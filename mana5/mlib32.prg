// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib32.prg
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



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKPAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKPAR( lDESCFO, bAUXGET, mVARNUM, mVARTOT, mVARDIF )

   IF ValType( lDESCFO ) # "L"
      lDESCFO := .F.
   ENDIF
   IF ValType( mVARTOT ) # "N"
      mVARTOT := mTOTNF
   ENDIF
// Fechamento do Pedido
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
   @  3, 3  SAY "Nota    Emiss„o F CLI/FOR   " + spac( 9 ) + "S Ope P S Pag  Valor Total da NF"
   @  4, 0  SAY '+' + Replicate( '-', 78 ) + 'Ý'
   @  6, 0  SAY '+' + Replicate( '-', 52 ) + "-" + Replicate( '-', 25 ) + 'Ý'
   @  7, 10 SAY "Vencimentos e Valores Desta Entrada"
   @  8, 5  SAY "Vencer  Ý Valor  :"
   @  9, 1  SAY "1-" + spac( 10 ) + "Ý" + spac( 19 ) + "Ý"
   @ 10, 1  SAY "2-" + spac( 10 ) + "Ý" + spac( 19 ) + "Ý"
   @ 11, 1  SAY "3-" + spac( 10 ) + "Ý" + spac( 19 ) + "Ý"
   @ 12, 1  SAY "4-" + spac( 10 ) + "Ý" + spac( 19 ) + "Ý"
   @ 13, 1  SAY "5-" + spac( 10 ) + "Ý" + spac( 19 ) + "Ý"
   @  9, 41 SAY "6-" + spac( 10 ) + "Ý" + spac( 19 ) + "Ý"
   @ 10, 41 SAY "7-" + spac( 10 ) + "Ý" + spac( 19 ) + "Ý"
   @ 11, 41 SAY "8-" + spac( 10 ) + "Ý" + spac( 19 ) + "Ý"
   @ 12, 41 SAY "9-" + spac( 10 ) + "Ý" + spac( 19 ) + "Ý"
   @ 13, 40 SAY "10-" + spac( 09 ) + "Ý" + spac( 19 ) + "Ý"
   @ 14, 0  SAY '+' + Replicate( '-', 12 ) + "-" + Replicate( '-', 19 ) + "-" + Replicate( '-', 5 ) + "-" + Replicate( '-', 13 ) + "-" + Replicate( '-', 5 ) + "-" + Replicate( '-', 19 ) + 'Ý'
   @ 15, 22 SAY "Da Nota Fiscal   Ý"
   @ 16, 1  SAY "Tot.Mercadoria" + spac( 24 ) + "Ý"
   @ 17, 1  SAY "Total do IPI  " + spac( 24 ) + "Ý"
   @ 18, 1  SAY "Total N.Fiscal" + spac( 24 ) + "Ý"
   @ 19, 1  SAY "Valor do ICMS " + spac( 24 ) + "Ý"
   @ 20, 1  SAY "Base Calc. IPI" + spac( 24 ) + "Ý"
   @ 21, 1  SAY "Base Calc. ICM" + spac( 24 ) + "Ý"
// Get nas Menvars
   @  5, 1  SAY &mVARNUM.
   @  5, 10 SAY mDATA
   @  5, 19 SAY mTIPOCLI
   @  5, 21 SAY mFORNECEDO
   @  5, 27 SAY mCOGNOME
   IF lDESCFO
      @  5, 42 SAY mOPERACAO + '-' + Trim( mDESCFO )
   ELSE
      @  5, 42 SAY mOPERACAO
   ENDIF
   @  5, 46 SAY mTIPOENT
   @  5, 48 SAY mSITUACAO
   @  5, 50 SAY mCONDPAG
   WHILE .T.
      @  9, 4  GET mDAT01
      @  9, 14 GET mVAL01 PICT "999,999,999.99"
      @ 10, 4  GET mDAT02
      @ 10, 14 GET mVAL02 PICT "999,999,999.99"
      @ 11, 4  GET mDAT03
      @ 11, 14 GET mVAL03 PICT "999,999,999.99"
      @ 12, 4  GET mDAT04
      @ 12, 14 GET mVAL04 PICT "999,999,999.99"
      @ 13, 4  GET mDAT05
      @ 13, 14 GET mVAL05 PICT "999,999,999.99"
      @  9, 44 GET mDAT06
      @  9, 54 GET mVAL06 PICT "999,999,999.99"
      @ 10, 44 GET mDAT07
      @ 10, 54 GET mVAL07 PICT "999,999,999.99"
      @ 11, 44 GET mDAT08
      @ 11, 54 GET mVAL08 PICT "999,999,999.99"
      @ 12, 44 GET mDAT09
      @ 12, 54 GET mVAL09 PICT "999,999,999.99"
      @ 13, 44 GET mDAT10
      @ 13, 54 GET mVAL10 PICT "999,999,999.99"
      IF ValType( bAUXGET ) = "C"
         DO CASE
         CASE bAUXGET = "1"
            @ 16, 20 GET mTOTMER  PICT '999,999,999.99'
            @ 17, 20 GET mTOTIPI  PICT '999,999,999.99'
            @ 18, 20 GET mTOTNF   PICT "999,999,999.99"
            @ 19, 20 GET mTOTICM  PICT '999,999,999.99'
            @ 20, 20 GET mBASEIPI PICT '999,999,999.99'
            @ 21, 20 GET mBASEICM PICT '999,999,999.99'
         CASE bAUXGET = "2" .OR. bAUXGET = "3"
            @ 16, 44 SAY 'Pis'
            @ 17, 44 SAY 'Cofins'
            @ 22, 02 SAY 'Frete'
            @ 22, 20 SAY mTOTFRETE PICT '999,999,999.99'
            @ 16, 20 GET mTOTMER   PICT '999,999,999.99'
            @ 17, 20 GET mTOTIPI   PICT '999,999,999.99'
            @ 18, 20 GET mTOTNF    PICT "999,999,999.99"
            @ 19, 20 GET mTOTICM   PICT '999,999,999.99'
            @ 20, 20 GET mTOTBIPI  PICT '999,999,999.99'
            @ 21, 20 GET mTOTBICM  PICT '999,999,999.99'
            @ 16, 54 GET mVALPIS   PICT '999,999,999.99'
            @ 17, 54 GET mVALFIN   PICT '999,999,999.99'
         ENDCASE
      ENDIF
      IF ValType( bAUXGET ) = "B"
         Eval( bAUXGET )
      ENDIF
      READCUR()
      IF ValType( mVARDIF ) # "C"
         IF Round( mVAL01 + mVAL02 + mVAL03 + mVAL04 + mVAL05 + ;
               mVAL06 + mVAL07 + mVAL08 + mVAL09 + mVAL10, 2 ) # Round( mVARTOT, 2 )
            ALERTX( "As Somas da Parcela n„o Conferem com o Total" )
         ELSE
            EXIT
         ENDIF
      ELSE
         IF Round( mVAL01 + mVAL02 + mVAL03 + mVAL04 + mVAL05 + ;
               mVAL06 + mVAL07 + mVAL08 + mVAL09 + mVAL10, 2 ) # Round( mVARTOT + &mVARDIF., 2 )
            ALERTX( "As Somas da Parcela n„o Conferem com o Total" )
            IF MDG( "Lan‡ar Diferen‡a" )
               MDS( "Digite o Valor da Diferen‡a" )
               @ 24, 40 GET &mVARDIF.
               READCUR()
            ENDIF
         ELSE
            EXIT
         ENDIF
      ENDIF
   ENDDO
   RETU .T.


// + EOF: mlib32.prg
// +
