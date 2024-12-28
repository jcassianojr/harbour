// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_au0.prg
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





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_au0()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_au0

   PARA ARQWORK, ARQ2, ARQ3, ARQ3BX, STR3, ARQ4, STR4, ARQ9, ARQI, cSEN, cMENU

   AUTOMENU( " Ý Cadastro de " + ARQWORK, cMENU, 24 )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iMAU2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC iMAU2()

// Retorna de Referencias
   mNOME    := xNOME
   mUNIDADE := xUNIDADE
   RETU .F.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iMAU3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC iMAU3()

   mCODIGO := xCODIGO
   MDS( "Digite o Codigo do Produto" )
   @ 24, 40 GET mCODIGO
   IF !READCUR()
      RETU .F.
   ENDIF
   PEGACAMPO( ARQWORK, "mCODIGO", { "NOME", "UNIDADE" }, { "mNOME", "mUNIDADE" } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAU301()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAU301( cARQUSO, cARQBAI )

   IF AllTrim( wARQ ) == AllTrim( cARQUSO ) .AND. !Empty( mDATASAI ) .AND. !Empty( mNRNOTASAI ) .AND. ;
         ! Empty( mTOTKGANT ) .AND. !Empty( mTOTKGSAI )
      BAIXAREM( cARQUSO, cARQBAI, mCODIGO + Str( mNRNOTAINI ) )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function BAIXAREM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC BAIXAREM( cARQUSO, cARQBAI, eCHAVE )

   mOLDDIG := mDIGCTR
   I       := 0
   mDIGCTR := "A"
   WHILE VERSEHA( cARQBAI, eCHAVE + mDIGCTR )
      I++
      mDIGCTR := Chr( 65 + I )
   ENDDO
   IF NOVOREG( cARQBAI, eCHAVE + mDIGCTR )
      mDATASAI   := CToD( Space( 8 ) )
      mNRNOTASAI := 0
      mTOTKGANT  := mTOTKGEST
      mTOTKGSAI  := 0
      mTOTKGEST  := 0
      mDIGCTR    := mOLDDIG  // Retorna o Digito Controle Inicial
      IF mTOTKGANT > 0
         mTOTKGEST := mTOTKGANT
         REPORVARS( cARQUSO, eCHAVE + mDIGCTR )
      ELSE
         APAGAREG( cARQUSO, eCHAVE + mDIGCTR, .F., .F. )
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAUBX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAUBX

   PARA ARQWORK, ARQ3, ARQ3BX

   IF ValType( ARQ3BX ) = "C"
      PADRAO( 0, 1, 0, ARQ3, "C¢digo   T Cliente" + spac( 12 ) + "NF Ent.  Saldo   Rastro", ;
         "' '+mCODIGO+' '+mTIPOCLI+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mNRNOTAINI,8)+' '+STR(mTOTKGEST,9,2)+' '+mRASTRO", "MAU3",,,, ;
         ,,,,, {|| MAU301( ARQ3, ARQ3BX ) } )
   ELSE
      PADRAO( 0, 1, 0, ARQ3, "C¢digo   T Cliente" + spac( 12 ) + "NF Sai.  Qtdde", ;
         "' '+mCODIGO+' '+mTIPOCLI+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mNRNOTAINI,8)+' '+STR(mTOTKGEST,9,2)+' '+mRASTRO", "MAU3" )
   ENDIF


// + EOF: m_au0.prg
// +
