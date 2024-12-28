// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foptoc.prg
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
// +    Documentado em 27-Dez-2024 as  9:34 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKCRI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CHECKCRI( cARQ, cORI, eCHA, eCH2 )

   LOCAL cPAD, cCAM, aESTRU

   IF !REDEfile( cARQ, ".DBF", .F. ) .OR. !REDEfile( cARQ, ".CDX", .F. )
      cPAD := OBTER( "FOPTONTX",, cORI, "PAD",,,,,, "S" )
      cCAM := ""
      DO CASE
      CASE cPAD = "S"
         cCAM := ZDIRE
      CASE cPAD = "A"
         cCAM := ZDIRN
      CASE cPAD = "I"
         cCAM := PEGCAMINI( cORI )
      ENDCASE
      IF !REDEfile( cARQ, ".DBF", .F. )
         IF !NETUSE( cORI,,,,, .F., )
            RETURN
         ENDIF
         aESTRU := dbStruct()
         dbCloseArea()
         dbCreate( cCAM + cARQ, aESTRU )
      ENDIF
      IF !REDEfile( cARQ, ".CDX", .F. )
         IF ValType( eCH2 ) = "C"
            INFOR( cARQ, eCHA, cCAM + cARQ + "1",, cARQ + "1" )
            INFOR( cARQ, eCH2, cCAM + cARQ + "2",, cARQ + "2" )
         ELSE
            INFOR( cARQ, eCHA, cCAM + cARQ,, cARQ )
         ENDIF
      ENDIF
   ENDIF


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function pegrelogio()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION pegrelogio

   LOCAL nARQ := 0

   WHILE nARQ = 0
      nARQ := ESCOLHEXI( "FOPTOREL", 0, "' '+STR(NUMERO,8)+' '+NOME", "NUMERO" )
   ENDDO

   RETURN nARQ


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function pegequip()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION pegequip( cFILTRO )

   LOCAL nARQ := 0

   WHILE nARQ = 0
      nARQ := ESCOLHEXI( "FOPTOEQP", 0, "' '+STR(NUMERO,8)+' '+NOME", "NUMERO", cFILTRO )
   ENDDO

   RETURN nARQ



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PARQDIO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PARQDIO( nARQ )

   IF ValType( nARQ ) # "N"
      nARQ := PEGRELOGIO()
   ENDIF

   RETURN TARQREL( nARQ, .F., "D" )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TARQREL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC TARQREL( nTIPO, lPER, cTIPO )

   LOCAL cARQ := "ERRO"

   IF ValType( lPER ) # "L"
      lPER := .T.
   ENDIF
   IF ValType( cTIPO ) # "C"
      cTIPO := " "
   ENDIF
   IF !netuse( "foptorel" )
      RETURN cARQ
   ENDIF
   IF !dbSeek( nTIPO )
      dbCloseArea()
      RETU cARQ
   ENDIF
   DO CASE
   CASE cTIPO = "D"  // Dio
      DO CASE
      CASE DESTINO = "P"   // folha ponto (D)
         cARQ := "PD"
      CASE DESTINO = "R"   // refeitorio (A)Lmoco
         cARQ := "PA"
      CASE DESTINO = "A"
         cARQ := "PP"  // aesso (P)ortaria
      ENDCASE
      cARQ += ANOMESW
   OTHERWISE
      IF if( lPER, MDG( "Arquivo de Backup" ), .T. )
         DO CASE
         CASE DESTINO = "P"  // folha ponto (D)
            cARQ := "D"
         CASE DESTINO = "R"  // refeitorio (A)lmoco
            cARQ := "A"
         CASE DESTINO = "A"
            cARQ := "P"  // acesso (P)ortaria
         ENDCASE
         cARQ += ANOMESW
      ELSE
         dbCloseArea()
         cARQ := pegarqcon( nTIPO, "DBFMIG" )
         RETU carq
      ENDIF
   ENDCASE
   dbCloseArea()

   RETURN cARQ


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function pegarqcon()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION pegarqcon( nTIPO, cTIPO )

   LOCAL cARQ := "ERRO"

   IF !netuse( "FOPTOREL" )
      RETU cARQ
   ENDIF
   IF !dbSeek( nTIPO )
      dbCloseArea()
      RETURN cARQ
   ENDIF
   DO CASE
   CASE cTIPO = "PRO"
      cARQ := PROCESSO
   CASE cTIPO = "CAM"
      cARQ := CAMINHO
   CASE cTIPO = "DBFMIG"
      cARQ := ARQDEST
   CASE cTIPO = "TXT"
      cARQ := ARQUIVO
      IF At( ".", cARQ ) = 0
         cARQ += ".TXT"
      ENDIF
      // case cTIPO = "NEX"
      // cARQ:=CAMINEX
      // case cTIPO = "NER"
      // cARQ:=CAMINER
      // case cTIPO = "ANO"
      // cARQ:=ANOREL
      // case cTIPO = "DIV"
      // cARQ := if( HORADEC = "S", .T., .F. )
   ENDCASE
   dbCloseAll()

   RETURN cARQ



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGHORFIX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PEGHORFIX( mNUMERO )

   aFOLGA := { "N", "N", "N", "N", "N", "N", "N" }
   aREF   := { { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, ;  // Horario Normal
      { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, ;
      { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, ;
      { 0, 0, 0, 0 }, { 0, 0, 0, 0 } }
   aNHOR := { 0, 0, 0, 0, 0, 0, 0, 0 }

   dbSelectAr( "FO_RELHR" )
   dbGoTop()
   IF dbSeek( mNUMERO )
      lREVESAR  := if( HFOL00 = "S", .T., .F. )
      mGRUPO    := GRUPO   // Codigo da Escala
      mTURNO    := HFOL00  // Escala S/N
      mHORREF   := HORREF  // Codigo do Horario Fixo
      dDATAREF1 := DATAREF1
      mALMOCO   := ALMOCO
      mMARMES   := MARMES
      mMARALM   := MARALM
      IF mTURNO = "N"  // nao tem escala pega fixo
         dbSelectAr( "FOPTOHRE" )
         dbGoTop()
         IF dbSeek( mHORREF )
            aFOLGA := { HFOL01, HFOL02, HFOL03, HFOL04, HFOL05, HFOL06, HFOL07 }
            aREF   := { { HENT01, HALS01, HALE01, HSAI01 }, { HENT02, HALS02, HALE02, HSAI02 }, ;
               { HENT03, HALS03, HALE03, HSAI03 }, { HENT04, HALS04, HALE04, HSAI04 }, ;
               { HENT05, HALS05, HALE05, HSAI05 }, { HENT06, HALS06, HALE06, HSAI06 }, ;
               { HENT07, HALS07, HALE07, HSAI07 }, { HENT, HALS, HALE, HSAI } }
            aNHOR := { HOR01, HOR02, HOR03, HOR04, HOR05, HOR06, HOR07, HOR }
         ENDIF
      ENDIF
   ENDIF

   RETURN




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGFOLGA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PEGFOLGA( cCOD )

   LOCAL lRETU

   lRETU := .F.
   IF ccod = "FE" .OR. cCod = "FO" .OR. cCOD = "SA" .OR. cCOD = "DO" .OR. cCOD = "BH"
      lRETU := .T.
   ENDIF

   RETURN lRETU


// + EOF: foptoc.prg
// +
