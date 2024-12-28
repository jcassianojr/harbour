// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk05.prg
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
// :       ATUALIZA(xARQUIVO1,xBUSCA,xARQUIVO2,nINDICE2,lAPA)
// :
// :*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ATUALIZA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ATUALIZA( xARQUIVO1, xBUSCA, xARQUIVO2, nINDICE2, lAPA )

   IF ValType( lAPA ) # "L"
      lAPA := .F.
   ENDIF
   IF ValType( nINDICE2 ) # "N"
      nINDICE2 := 1
   ENDIF
   IF !NETUSE( xARQUIVO1,,,,, .F., )
      RETU .F.
   ENDIF
   INITVARS()
   CLRVARS()
   cSELE1 := Alias()

   IF !NETUSE( xARQUIVO2 )
      dbCloseAll()
      RETU .F.
   ENDIF
   INITVARS()
   CLRVARS()
   cSELE2 := Alias()
   IF nINDICE2 <> 1
      dbSetOrder( nINDICE2 )
   ENDIF

   dbSelectAr( cSELE1 )
   GRAPP := 1
   GRAPT := LastRec()
   GRAPT( 'Aguarde Atualizando -> ' + xARQUIVO2 )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   WHILE !Eof()
      EQUVARS()
      BUSCA := &xBUSCA.
      dbSelectAr( cSELE2 )
      dbGoTop()
      IF !dbSeek( BUSCA )
         netrecapp()
         REPLVARS()
      ELSE
         DO CASE
         CASE xARQUIVO1 = "NEWPAISES" .AND. Empty( UF )
            NETRECLOCK()
            FIELD->UF := "EX"
            dbUnlock()
            REPLVARS( .T., .T. )
         CASE xARQUIVO1 = "NEWCNAE2" .AND. Empty( ALIQ_ATV ) .AND. !Empty( mALIQ_ATV )
            netreclock()
            field->ALIQ_ATV := mALIQ_ATV
            dbUnlock()
         CASE xARQUIVO1 = "NEWCNAE2" .AND. Empty( NCM_ATV ) .AND. !Empty( mNCM_ATV )
            netreclock()
            field->NCM_ATV := mNCM_ATV
            dbUnlock()
         CASE xARQUIVO1 = "NEWCBON" .AND. Empty( CAGEDESCO ) .AND. !Empty( MCAGEDESCO )
            netreclock()
            field->CAGEDESCO := mCAGEDESCO
            dbUnlock()
         CASE xARQUIVO1 = "NEWNATJ" .AND. Empty( NATGRU )
            netreclock()
            DO CASE
            CASE Left( CODIGO, 1 ) = "1"
               field->natgru := "1. ADMINISTRACAO PUBLICA"
            CASE Left( CODIGO, 1 ) = "2"
               field->natgru := "2. ENTIDADES EMPRESARIAIS"
            CASE Left( CODIGO, 1 ) = "3"
               field->natgru := "3. ENTIDADES SEM FINS LUCRATIVOS"
            CASE Left( CODIGO, 1 ) = "4"
               field->natgru := "4. PESSOAS FISICAS"
            CASE Left( CODIGO, 1 ) = "5"
               field->natgru := "5. ORG. INTERNACIONAIS E OUTRAS INSTITUICOES EXT."
            ENDCASE
            dbUnlock()
         ENDCASE
      ENDIF
      dbSelectAr( cSELE1 )
      GRAPS()
      zei_fort( nLASTREC,,, 1 )
      dbSkip()
   ENDDO
   FREEVARS()
   dbCloseAll()
   IF lAPA
      FErase( xARQUIVO1 + ".DBF" )
   ENDIF
   RETU .T.

// + EOF: disk05.prg
// +
