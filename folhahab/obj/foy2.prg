// +--------------------------------------------------------------------
// +
// +    Programa  : foy2.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOY2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOY2()

   CABEX( 'Configurar Ordenacao' )
   PARA CCWORK, CCNTX, CCPERG
   INFOR( CCNTX, "DBF+NTX+STR(SEQ,3)", CCNTX, .T. )
   IF ValType( CCPERG ) # "C"
      CCPERG := "S"
   ENDIF

   IF CCWORK = 1   // Edio
      PADRAO( CCNTX, CCNTX, "' '+mDBF+' '+mDESCRICAO", "mDBF+mNTX+STR(mSEQ,3)", "Configurar Indexacao", "Arquivo Nome", ;
         {|| iFOY2() }, {|| tFOY2() }, {|| gFOY2() }, {|| FO_FOR( "GRUPO='SISTEM'" ) } )
   ENDIF

   IF CCWORK = 0   // Indexar
      DO CASE
      CASE CCPERG = "S"
         INDEXT(,, MDG( 'Somente Arquivos da Empresa' ) )
      CASE CCPERG = "N"
         INDEXT(,, .F. )
      CASE CCPERG = "E"
         INDEXT(,, .T. )
      ENDCASE
   ENDIF

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOY2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION iFOY2

   mDBF := Space( 8 )
   mNTX := Space( 8 )
   mSEQ := 0
   MDS( "Digite Arquivo/Indice" )
   @ 24, 40 GET mDBF
   @ 24, 50 GET mNTX WHEN ALLTRUE( if( Empty( mNTX ), mNTX := mDBF, ) )
   @ 24, 60 GET mSEQ
   READCUR()
   mCHAVE := mDBF + mNTX + Str( mSEQ, 3 )
   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOY2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION tFOY2()

   hb_DispBox( 9, 0, 23, 79, B_DOUBLE + " " )
   @ 11, 2  SAY "Descricao Do Arquivo :"
   @ 14, 2  SAY "Nome do Arquivo de Dados  :"
   @ 16, 2  SAY "Seq:"
   @ 16, 20 SAY "Nome do Arquivo de Indice :"
   @ 17, 2  SAY "Nome alias(TAG):"
   @ 18, 2  SAY "Chave Para Criacao do Arquivo de Indice :"
   @ 21, 2  SAY "Este arquivo e Indidual por empresa (S)im(N)ao(I)ni:"
   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOY2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION gFOY2()

   @ 12, 2  GET mDESCRICAO
   @ 14, 31 GET mDBF
   @ 16, 10 GET mSEQ       VALID mSEQ > 0
   @ 16, 51 GET mNTX
   @ 17, 20 GET mTAG
   @ 19, 2  GET mCAMPO
   @ 21, 54 GET mPAD       VALID mPAD $ " SNIA"
   READCUR()
   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function INDEXT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION INDEXT( nINI, nFIM, xEMP )
LOCAL cDBFNAME

   IF ! netuse( ccNTX )
      RETU
   ENDIF
   dbGoTop()
   WHILE !Eof()
      cCAM    := ""
      USODBF  := AllTrim( DBF )
      cDBFNAME := USODBF
      aCHAVE  := {}
      aINDICE := {}
      aTAG    := {}
      WHILE USODBF = AllTrim( DBF ) .AND. !Eof()
         USONTX := AllTrim( NTX )
         USOCAM := AllTrim( CAMPO )
         USOTAG := AllTrim( TAG )
         IF Len( AllTrim( USODBF ) ) = 3 .AND. USODBF = "FOL"
            USODBF := FOL
            USONTX := FOL
         ENDIF
         IF Len( AllTrim( USODBF ) ) = 3 .AND. USODBF = "SEM"
            USODBF := 'SS' + ARQMES
            USONTX := 'SS' + ARQMES
         ENDIF
         IF Len( AllTrim( USODBF ) ) = 3 .AND. USODBF = "RPA"
            USODBF := 'RP' + ARQMES
            USONTX := 'RP' + ARQMES
         ENDIF
         IF Len( AllTrim( USODBF ) ) = 3 .AND. USODBF = "RPL"
            USODBF := 'RL' + ARQMES
            USONTX := 'RL' + ARQMES
         ENDIF
         // Definies do RPA
         IF CCNTX = "RPANTX"
            IF USODBF = "RPA08"
               USODBF := ARQMES
               USONTX := ARQMES
            ENDIF
         ENDIF
         // Definies do Fiscal
         IF CCNTX = "FISCANTX"
            DO CASE
            CASE USODBF = "ENT"
               USODBF := ENT
               USONTX := ENT
            CASE USODBF = "SAI"
               USODBF := SAI
               USONTX := SAI
            CASE USODBF = "SER"
               USODBF := SER
               USONTX := SER
            ENDCASE
         ENDIF

         // Difinioes do Ponto
         IF CCNTX = "FOPTONTX"
            cMESANO := ANOWORK + StrZero( mestrab, 2 )
         ENDIF
         IF USODBF = "FO_PON"
            USODBF := "PN" + cMESANO
            USONTX := "PN" + cMESANO
            USOTAG := "PN" + cMESANO
         ENDIF
         IF USODBF = "FO_POT"
            USODBF := "PT" + cMESANO
            USONTX := "PT" + cMESANO
            USOTAG := "PT" + cMESANO
         ENDIF
         IF USODBF = "FO_POS"
            USODBF := "PS" + cMESANO
            USONTX := "PS" + cMESANO
            USOTAG := "PS" + cMESANO
         ENDIF
         IF USODBF = "FOPTOREV"
            USODBF := "PE" + cMESANO
            USONTX := "PE" + cMESANO
            USOTAG := "PE" + cMESANO
         ENDIF
         IF USODBF = "FO_POCO"
            USODBF := "PO" + cMESANO
            USONTX := "PO" + cMESANO
            USOTAG := "PO" + cMESANO
         ENDIF
         IF USODBF = "FO_PMAN"
            USODBF := "PM" + cMESANO
            USONTX := "PM" + cMESANO
            USOTAG := "PM" + cMESANO
         ENDIF
         IF USODBF = "FO_PHOR"
            USODBF := "PH" + cMESANO
            USONTX := "PH" + cMESANO
            USOTAG := "PH" + cMESANO
         ENDIF
         IF USODBF = "BCOREQ"
            USODBF := "BH" + cMESANO
            USONTX := "BH" + cMESANO
            USOTAG := "BH" + cMESANO
         ENDIF
         IF USODBF = "BCRBAK"
            USODBF := "BK" + cMESANO
            USONTX := "BK" + cMESANO
            USOTAG := "BK" + cMESANO
         ENDIF
         IF USODBF = "FO_PDES"
            USODBF := "PX" + cMESANO
            USONTX := "PX" + cMESANO
            USOTAG := "PX" + cMESANO
         ENDIF
         IF USODBF = "FO_DIO"
            USODBF := "PD" + cMESANO
            USONTX := "PD" + cMESANO
            USOTAG := "PD" + cMESANO
         ENDIF
         IF USODBF = "FO_ALM"
            USODBF := "PA" + cMESANO
            IF USOCAM = "STR(NUMERO,8)+DTOS(DATA)+STRZERO(HOR,5,2)"
               USONTX := "PA" + cMESANO
            ENDIF
            USOTAG := "PA" + cMESANO
         ENDIF
         IF USODBF = "FO_POR"
            USODBF := "PP" + cMESANO
            IF USOCAM = "STR(NUMERO,8)+DTOS(DATA)+STRZERO(HOR,5,2)"
               USONTX := "PP" + cMESANO
            ENDIF
            USOTAG := "PP" + cMESANO
         ENDIF
         IF USODBF = "PES"
            USODBF := PES
         ENDIF

         // CAMINHO
         cCAM := ""
         IF PAD = 'S'
            cCAM := ZDIRE
         ENDIF
         IF PAD = 'I'
            cCAM := PEGCAMINI( USODBF )
         ENDIF
         IF PAD = 'A'
            cCAM := ZDIRN
         ENDIF
         IF PAD = 'E'  // Tabelas esocial
            cCAM := hb_cwd() + "esocial_tab\"
         ENDIF
         IF PAD = "S" .OR. PAD = "I" .OR. PAD = "A" .OR. PAD = "E"
            USODBF := cCAM + USODBF
            USONTX := cCAM + USODBF
         ENDIF
         IF !xEMP .OR. PAD = 'S'
            AAdd( achave, USOCAM )
            AAdd( aindice, usontx )
            AAdd( aTAG, usotag )
         ENDIF
         dbSelectAr( CCNTX )
         dbSkip()
      ENDDO
      IF Len( aCHAVE ) > 0
         IF .NOT. FILE(USODBF+".DBF")
            IF FILE(cDBFNAME+".DBE")
               altd()
               MAKEDBF(cDBFNAME+".DBE", .F., .T., ,cCAM)
            ENDIF
         ENDIF
         INFOR( USODBF, aCHAVE, aINDICE,, aTAG )
      ENDIF
      dbSelectAr( CCNTX )
   ENDDO
   dbCloseArea()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGCAMINI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION PEGCAMINI( cARQ, cCAM )

   IF ValType( cCAM ) # "C"
      cCAM := ProfileString( "FOLHA.INI", cARQ + ".DBF", "CAMINHO", ZDIRE )
   ENDIF
   CCAM := StrTran( CCAM, "[AA]", Right( StrZero( ANOUSO, 4 ), 2 ) )
   CCAM := StrTran( CCAM, "[AAAA]", StrZero( ANOUSO, 4 ) )
   CCAM := StrTran( CCAM, "[MM]", StrZero( MESTRAB, 2 ) )
   CCAM := StrTran( CCAM, "[ZZZ]", StrZero( NREMP, 3 ) )
   CCAM := StrTran( CCAM, "[ZZ]", StrZero( NREMP, 2 ) )
   CCAM := StrTran( CCAM, "[Z]", StrZero( NREMP, 1 ) )
   CCAM := StrTran( CCAM, "[III]", StrZero( ZCODMANA5, 3 ) )
   CCAM := StrTran( CCAM, "[II]", StrZero( ZCODMANA5, 2 ) )
   CCAM := StrTran( CCAM, "[I]", StrZero( ZCODMANA5, 1 ) )
   RETU cCAM

// + EOF: foy2.prg
// +
