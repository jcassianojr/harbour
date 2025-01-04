// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_44.prg Alterar a Hor rio de Refer?ncia
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "INKEY.CH"
#include "BOX.CH"


FUNCTION fopto_44()

   PEGPTOHOR( "XX", .T., .F. )   // Verifica indices

   CRIARVARS( "FOPTOHRE" )   // compatibilidade manter  para exibir os horarios que estao
// foptohre

   PRIV mCODIGO  // Variavel Usado no igualvars do horario Padrao


   PADRAO( "FO_RELHR", "FO_RELHR", "STR(mNUMERO,8)+' '+mNOME+' '+if(mHFOL00='N',mHORREF,mGRUPO)+' '", ;
      "mNUMERO", "FOPTO_44 - Horario de Referencia", "Funcionario" + spac( 27 ) + "Horario", ;
      {|| PEGCHAVE( "mNUMERO", ULTIMOREG( "FO_RELHR", "NUMERO", .T. ), "Numero" ) }, {|| tFOPTO44( 1 ) }, {|| gFOPTO44( 1 ) }, {|| FO_RELL( "PONTOCAD01" ) }, "", 2,,, "X" )
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO44()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOPTO44( nTIPO )  // usado fo_relhr e foptohre

   IF nTIPO = 1
      @  4, 2  SAY mNUMERO   PICTURE '99999999'
      @  4, 11 GET mNOME     WHEN FOPTO44A()
      @  6, 15 GET mHFOL00   VALID mHFOL00 $ "SN " // Usa escala SN
      @  6, 34 GET mGRUPO    WHEN mHFOL00 = "S" // Codigo da Escala
      @  7, 27 GET mHORREF   WHEN mHFOL00 = "N"                    VALID FOPTO44() // Codigo do horario Padrao
      @  3, 70 GET mALMOCO   VALID mALMOCO $ "ABCDESN "
      @  4, 68 GET mMARALM   VALID mMARALM $ "SN "
      @  6, 68 GET mMARMES   VALID mMARMES $ "SN "
      @  7, 68 GET mDATAREF1
      READCUR()
      IF mHFOL00 = "S"   // Escala nao tem horario padrao
         mHORREF := ""
      ENDIF
      IF mHFOL00 = "N"   // horario padrao nao tem escala
         mGRUPO := ""
      ENDIF
      IF !Empty( mHORREF ) .OR. mHFOL00 = "S"  // tem horario referencia
         FOPTO44A()  // pego o horario padrao
         RETU .T.
      ENDIF  // senao pedi horario abaixo
   ELSE
      @  4, 2  SAY mCODIGO
      @  4, 11 GET mNOME     WHEN INCLUI
      @ 24, 00 GET zCONTINUA WHEN !INCLUI
      READCUR()
   ENDIF
   IF nTIPO = 1
      IF mHFOL00 = "S"   // escala nao mostra nada
         RETU .T.
      ENDIF
   ENDIF
   IF !INCLUI
      RETU .T.
   ENDIF
   @ 11, 09 GET mCHOR   VALID fopto44hor( "" )
   @ 12, 09 GET mCHOR02 VALID fopto44hor( "02" )
   @ 13, 09 GET mCHOR03 VALID fopto44hor( "03" )
   @ 14, 09 GET mCHOR04 VALID fopto44hor( "04" )
   @ 15, 09 GET mCHOR05 VALID fopto44hor( "05" )
   @ 16, 09 GET mCHOR06 VALID fopto44hor( "06" )
   @ 17, 09 GET mCHOR07 VALID fopto44hor( "07" )
   @ 18, 09 GET mCHOR01 VALID fopto44hor( "01" )
   READCUR()
   @ 12, 46 GET mHFOL02 VALID mHFOL02 $ "SNV "
   @ 13, 46 GET mHFOL03 VALID mHFOL03 $ "SNV "
   @ 14, 46 GET mHFOL04 VALID mHFOL04 $ "SNV "
   @ 15, 46 GET mHFOL05 VALID mHFOL05 $ "SNV "
   @ 16, 46 GET mHFOL06 VALID mHFOL06 $ "SNV "
   @ 17, 46 GET mHFOL07 VALID mHFOL07 $ "SNV "
   @ 18, 46 GET mHFOL01 VALID mHFOL01 $ "SNV "
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO44()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFOPTO44( nTIPO )  // usado fo_relhr e foptohre

   IF nTIPO <> 3
      hb_DispBox( 2, 0, 23, 79, B_DOUBLE + " " )
   ENDIF
   IF nTIPO = 1
      @  3, 2  SAY "Funcionario" + spac( 30 ) + "Almoco(S)im(N)ao Faixa A-E"
      @  4, 43 SAY "Marca Horario Almoco" + spac( 8 ) + "SN"
      @  6, 43 SAY "Iniciar o Mes"
      @  6, 2  SAY "Usa Escala " + spac( 6 ) + "(S/N)   Grupo"
      @  7, 2  SAY "Horario de Referencia:"
      @  7, 43 SAY "Data Inicio Adc/Not"
   ENDIF
   IF nTIPO = 2
      @  3, 2 SAY "Codigo"
   ENDIF
   IF nTIPO = 1
      IF mHFOL00 = "S"   // escala nao mostra nada
         RETU .T.
      ENDIF
   ENDIF
   @  9, 11 SAY "Horario"
   @  9, 21 SAY "Entr.   Almoco    Saida Folga"
   @ 11, 2  SAY "Padrao"
   @ 12, 2  SAY "Segunda"
   @ 13, 2  SAY "Terca"
   @ 14, 2  SAY "Quarta"
   @ 15, 2  SAY "Quinta"
   @ 16, 2  SAY "Sexta"
   @ 17, 2  SAY "S bado"
   @ 18, 2  SAY "Domingo"
   @ 11, 21 SAY mHENT                           PICTURE '99.99'
   @ 11, 27 SAY mHALS                           PICTURE '99.99'
   @ 11, 33 SAY mHALE                           PICTURE '99.99'
   @ 11, 39 SAY mHSAI                           PICTURE '99.99'
   @ 12, 21 SAY mHENT02                         PICTURE '99.99'
   @ 12, 27 SAY mHALS02                         PICTURE '99.99'
   @ 12, 33 SAY mHALE02                         PICTURE '99.99'
   @ 12, 39 SAY mHSAI02                         PICTURE '99.99'
   @ 13, 21 SAY mHENT03                         PICTURE '99.99'
   @ 13, 27 SAY mHALS03                         PICTURE '99.99'
   @ 13, 33 SAY mHALE03                         PICTURE '99.99'
   @ 13, 39 SAY mHSAI03                         PICTURE '99.99'
   @ 14, 21 SAY mHENT04                         PICTURE '99.99'
   @ 14, 27 SAY mHALS04                         PICTURE '99.99'
   @ 14, 33 SAY mHALE04                         PICTURE '99.99'
   @ 14, 39 SAY mHSAI04                         PICTURE '99.99'
   @ 15, 21 SAY mHENT05                         PICTURE '99.99'
   @ 15, 27 SAY mHALS05                         PICTURE '99.99'
   @ 15, 33 SAY mHALE05                         PICTURE '99.99'
   @ 15, 39 SAY mHSAI05                         PICTURE '99.99'
   @ 16, 21 SAY mHENT06                         PICTURE '99.99'
   @ 16, 27 SAY mHALS06                         PICTURE '99.99'
   @ 16, 33 SAY mHALE06                         PICTURE '99.99'
   @ 16, 39 SAY mHSAI06                         PICTURE '99.99'
   @ 17, 21 SAY mHENT07                         PICTURE '99.99'
   @ 17, 27 SAY mHALS07                         PICTURE '99.99'
   @ 17, 33 SAY mHALE07                         PICTURE '99.99'
   @ 17, 39 SAY mHSAI07                         PICTURE '99.99'
   @ 18, 21 SAY mHENT01                         PICTURE '99.99'
   @ 18, 27 SAY mHALS01                         PICTURE '99.99'
   @ 18, 33 SAY mHALE01                         PICTURE '99.99'
   @ 18, 39 SAY mHSAI01                         PICTURE '99.99'
   @ 12, 46 SAY mHFOL02
   @ 13, 46 SAY mHFOL03
   @ 14, 46 SAY mHFOL04
   @ 15, 46 SAY mHFOL05
   @ 16, 46 SAY mHFOL06
   @ 17, 46 SAY mHFOL07
   @ 18, 46 SAY mHFOL01
   @ 11, 09 SAY mCHOR
   @ 12, 09 SAY mCHOR02
   @ 13, 09 SAY mCHOR03
   @ 14, 09 SAY mCHOR04
   @ 15, 09 SAY mCHOR05
   @ 16, 09 SAY mCHOR06
   @ 17, 09 SAY mCHOR07
   @ 18, 09 SAY mCHOR01
   @ 11, 11 SAY mHOR
   @ 12, 11 SAY mHOR02
   @ 13, 11 SAY mHOR03
   @ 14, 11 SAY mHOR04
   @ 15, 11 SAY mHOR05
   @ 16, 11 SAY mHOR06
   @ 17, 11 SAY mHOR07
   @ 18, 11 SAY mHOR01
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO44()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO44

   IF !Empty( mHORREF )
      IF !IGUALVARS( "FOPTOHRE", "FOPTOHRE", mHORREF, "Lendo Registro", "Nao Encontrei codigo do horario" )
         RETU .F.
      ENDIF
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO44A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOPTO44A

   xNOME := OBTER( PES,, mNUMERO, "NOME" )
   IF !Empty( xNOME )
      mNOME := xNOME
      RETU .F.
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO44HOR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO44HOR( cSUB )

   cBUSCA := "MCHOR" + cSUB
   cBUSCA := &cBUSCA.
   aRETU  := PEGPTOHOR( CBUSCA, .T., .T. )
   IF aRETU[ 6 ]
      cTMPVAR   := "MHENT" + cSUB
      &cTMPVAR. := aRETU[ 1 ]
      cTMPVAR   := "MHALS" + cSUB
      &cTMPVAR. := aRETU[ 2 ]
      cTMPVAR   := "MHALE" + cSUB
      &cTMPVAR. := aRETU[ 3 ]
      cTMPVAR   := "MHSAI" + cSUB
      &cTMPVAR. := aRETU[ 4 ]
      IF !Empty( cSUB )
         cTMPVAR   := "MHFOL" + cSUB
         &cTMPVAR. := aRETU[ 7 ]
      ENDIF
      cTMPVAR   := "mHOR" + cSUB
      &cTMPVAR. := Aretu[ 8 ]
   ENDIF
   tFOPTO44( 3 )
   RETU .T.

// : FIM: FOPTO_44.PRG


// + EOF: fopto_44.prg
// +
