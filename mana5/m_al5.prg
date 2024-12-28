// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_al5.prg
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


// #INCLUDE "COMANDO.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_al5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_al5

   PARA ARQWORK, bSAY, bGET

   MDI( " Ý ",,, ARQWORK )
   CLSCOR()
   IF ARQWORK = "ML01"
      CORMAL  := CORARR( "MAL" )
      aMALTEL := TELAPEG( "MAL001" )
   ENDIF
   IF ARQWORK = "MN01"
      CORMAN  := CORARR( "MAN" )
      aMANTEL := TELAPEG( "MAN001" )
      aMANGET := EDITPEG( "MAN001" )
   ENDIF
   CRIARVARS( ARQWORK )
   nIND := NUMIND( ARQWORK )
   PRIV mCHAVE, mCHABUS, aIND
   cVIDE := "N"
   IF !CONFIND( ARQWORK )
      RETU .F.
   ENDIF
   WHILE .T.
      mCHABUS := PEGBUS( ARQWORK, nIND )
      IF pESC
         EXIT
      ENDIF
      IF IGUALVARS( ARQWORK, mCHABUS, nIND )
         IF ARQWORK = "ML01"
            TIPCAD( mTIPOCLI, "ARQUSO", 3, 24 )
         ENDIF
         FORMULA  := aIND[ 1, 4 ]
         VARIAVEL := aIND[ 1, 1, 3 ]
         mCHAVE   := IF( Empty( FORMULA ), &VARIAVEL., &FORMULA. )
         Eval( bSAY )
         Eval( bGET )
         IF !Empty( mDATAPG ) .AND. !Empty( mVALORPG )
            mOBS := "Baixa Manual"
            NOVOREG( ARQWORK + "PG", mCHAVE )
            APAGAREG( ARQWORK, mCHAVE, .F. )
            IF Round( mDIFERENCA, 2 ) < Round( 0, 2 )
               mVALOR   := Abs( mDIFERENCA )
               mVALORPG := 0
               mDATAPG  := CToD( "  /  /  " )
               mAVISO   := "S"
               I        := 1
               mTIPFAT  := Chr( 64 + I )
               mCHAVE   := IF( Empty( FORMULA ), &VARIAVEL., &FORMULA. )
               WHILE VERSEHA( ARQWORK, mCHAVE )
                  I++
                  mTIPFAT := Chr( 64 + I )
               ENDDO
               NOVOREG( ARQWORK, mCHAVE )
            ENDIF
         ENDIF
      ENDIF
   ENDDO

// + EOF: m_al5.prg
// +
