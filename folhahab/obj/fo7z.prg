// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo7z.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "BOX.CH"

// aqui pega os valores mensais da frota
// tela de dados outro programa

aG01 := EDITPEG( "MG0001" )
PADRAO( "MG01", "MG01", "' '+STR(mNUMERO,8)+' '+mNOME+' '+mCOGNOME+' '+mDDD+' '+mTELEFONE", "mNUMERO", "Cadastro de Frotas", "N£mero  Nome" + spac( 38 ) + "Cognome" + spac( 6 ) + "DDD  Telefone", ;
      {|| PEGCHAVE( "mNUMERO", 0, "Numero Cadastramento" ) }, "MG0001", {|| gFO7Z() }, {|| FO_FOR( "GRUPO='MG01'" ) } )
RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFO7Z()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gFO7Z

   EDITSAY( aG01 )
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE + " " )
   @ 10, 00 SAY "+--------------+ +-------------------------------------------------------------+"
   @ 11, 00 SAY "Ý Horas por/   Ý Ý Tipo Servi‡o:                      Fun‡„o:                  Ý"
   @ 12, 00 SAY "Ý Semana       Ý Ý-------------------------------------------------------------Ý"
   @ 13, 00 SAY "Ý--------------Ý Ý                                                             Ý"
   @ 14, 00 SAY "Ý Pagamento:   Ý Ý-------------------------------------------------------------Ý"
   @ 15, 00 SAY "Ý M - Mensal   Ý Ý Jan =                          Jul =                        Ý"
   @ 16, 00 SAY "Ý Q - QuinzenalÝ Ý Fev =                          Ago =                        Ý"
   @ 17, 00 SAY "Ý S - Semana   Ý Ý Mar =                          Set =                        Ý"
   @ 18, 00 SAY "Ý D - Diario   Ý Ý Abr =                          Out =                        Ý"
   @ 19, 00 SAY "Ý H - Horas    Ý Ý Mai =                          Nov =                        Ý"
   @ 20, 00 SAY "Ý T - Tarefa   Ý Ý Jun =                          Dez =                        Ý"
   @ 21, 00 SAY "Ý O - Outros   Ý Ý                                                             Ý"
   @ 22, 00 SAY "+--------------+ +-------------------------------------------------------------+"
   @ 12, 09 GET mHRSEM                                                                             VALID mHRSEM > 0
   @ 14, 13 GET mTIPO                                                                              VALID CHECKTAB( "TSA2" + mTIPO + "    ", 24, 0, "Tipo n„o Cadastrado" )
   @ 11, 32 GET mTIPSER
   @ 11, 64 GET mFUNCAO
   IF ZUSER = "SUPERVISOR"
      @ 15, 25 GET mSALJAN
      @ 16, 25 GET mSALFEV
      @ 17, 25 GET mSALMAR
      @ 18, 25 GET mSALABR
      @ 19, 25 GET mSALMAI
      @ 20, 25 GET mSALJUN
      @ 15, 56 GET mSALJUL
      @ 16, 56 GET mSALAGO
      @ 17, 56 GET mSALSET
      @ 18, 56 GET mSALOUT
      @ 19, 56 GET mSALNOV
      @ 20, 56 GET mSALDEZ
   ENDIF
   READCUR()
   RETU .T.


// + EOF: fo7z.prg
// +
