// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_dk.prg
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





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_dk()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_dk

   PARA aARQ

   IF ValType( aARQ ) = "U"
      aARQ := ESCOLHEXI( "MANFEC", "", "' '+ARQORI+' '+STRDES+' '+OBTER('MANARQ',ARQORI,'DESCRICAO')", "ARQORI" )
   ENDIF
   IF ValType( aARQ ) = "C"
      aARQ := { aARQ }
   ENDIF
   CRIARVARS( "MANFEC" )
   FOR X := 1 TO Len( aARQ )
      IF !IGUALVARS( "MANFEC", aARQ[ X ] )
         RETU .F.
      ENDIF
      // ALERTX(mSTRANO)
      // ALERTX(mSTRDES)
      // ALERTX(mSTRATU)
      // ALERTX(mSTRBAI)
      IF Empty( mCAMDAT )
         mCAMDAT := "PADRAO"
      ENDIF
      IF Empty( mCAMDA2 )
         mCAMDA2 := "PADRAO"
      ENDIF
      SOMAANO( mSTRANO, mSTRDES,,, mSTRATU, mCAMDAT, mSTRBAI, mCAMDA2,, )
   NEXT X
   RELEASE ALL LIKE m *  // LIMPAVARS(wARQ)

// SOMAANO( cARQSOM, cSTRREF, cVARSOM, bSOMA, cATU, eDAT, cBAI, eDA2, aPER ,bUSE)



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FECRETBAI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FECRETBAI( cORI, cBAI )

   MDI( "Retorno de Baixa" )
   PRIV aIND, eCHAVE, nTIPO
   nTIPO := 0
   IF cORI = "MR03" .OR. cORI = "MS04" .OR. cORI = "MS07"
      nTIPO := 1
   ENDIF
   IF cORI = "MU03" .OR. cORI = "MQ03" .OR. cORI = "MT03"
      nTIPO := 1
   ENDIF
   IF !CONFIND( cORI )
      RETU .F.
   ENDIF
   CRIARVARS( cORI )
   WHILE .T.
      eCHAVE := PEGBUS( cORI, 1 )
      ALERTX( eCHAVE )
      IF IGUALVARS( cBAI, eCHAVE )
         IF nTIPO = 1
            mDATASAI   := CToD( SPAC( 8 ) )
            mNRNOTASAI := 0
            mTOTKGSAI  := 0
            mTOTKGEST  := mTOTKGANT
         ENDIF
         IF NOVOREG( cORI, eCHAVE )
            APAGAREG( cBAI, eCHAVE, .F. )
         ENDIF
      ENDIF
      IF !MDG( "Continuar" )
         EXIT
      ENDIF
   ENDDO


// + EOF: m_dk.prg
// +
