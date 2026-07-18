// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo0g.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FO0G.PRG: Cadastramento C¢digos FPAS
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 11/08/98
// :
// :*****************************************************************************


PADRAO( "CONFINSS", "CONFINSS", "' '+STR(mFPAS,  3)+' '+mDESCRICAO+' '+STR(mEMPRESA,  5, 2)+' '+STR(mACIDENTE,  5, 2)+' '+STR(mTERCEIRO,  4)", "mFPAS", "Codigos FPAS", "FPAS Descri‡„o" + spac( 43 ) + "EMP   ACTRA TER", ;
      {|| PEGCHAVE( "mFPAS", Space( 3 ), "Codigo FPAS" ) }, "FPAS01", "FPAS01", {|| FO_FOR( "GRUPO='CONFINSS'" ) } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO0GK01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FO0GK01

   mTERCEIRO := 0
   mTERCEIRO += IF( mE0001 # 0, 1, 0 )   // Salario educacao
   mTERCEIRO += IF( mE0002 # 0, 2, 0 )   // Incra
   mTERCEIRO += IF( mE0004 # 0, 4, 0 )   // Senai
   mTERCEIRO += IF( mE0008 # 0, 8, 0 )   // Sesi
   mTERCEIRO += IF( mE0016 # 0, 16, 0 )  // Senac
   mTERCEIRO += IF( mE0032 # 0, 32, 0 )  // Sesc
   mTERCEIRO += IF( mE0064 # 0, 64, 0 )  // Sebrae
   mTERCEIRO += IF( mE0128 # 0, 128, 0 )   // DPC
   mTERCEIRO += IF( mE0256 # 0, 256, 0 )   // FAREA
   mTERCEIRO += IF( mE0512 # 0, 512, 0 )   // SENAR
   mTERCEIRO += IF( mE1024 # 0, 1024, 0 )  // SEST
   mTERCEIRO += IF( mE2048 # 0, 2048, 0 )  // SENAT
   mTERCEIRO += IF( mE4096 # 0, 4096, 0 )  // SESCOOP
   mTOTAL    := mE0001 + mE0002 + mE0004 + mE0008 + mE0016 + mE0032 + mE0064 + mE0128 + mE0256 + mE0512 + mE1024 + mE2048 + mE4096
   @ 21, 9 SAY mTERCEIRO PICTURE '9999'
   @ 22, 9 SAY mTOTAL    PICTURE '99.99'
   RETU .T.

// + EOF: fo0g.prg
// +
