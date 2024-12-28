// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cr.prg
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


IF MDG( "Revisar Roteiro" )
PADRAO( 0, 1, 0, "MANATU", "Origem   Destino Indice", "' '+mARQUIVO1+' '+mARQUIVO2+' '+STRZERO(mINDICE,2)", "MCR" )
ENDIF

IF !USEREDE( "MANATU", 1, 1 )
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
ATUALIZA( AllTrim( ARQUIVO1 ), AllTrim( ARQUIVO2 ),, INDICE )
dbSelectAr( "MANATU" )
dbSkip()
ENDDO
dbCloseAll()





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
FUNCTION ATUALIZA( xARQUIVO1, xARQUIVO2, lAPAGA, nIND )

   IF ValType( lAPAGA ) # "L"
      lAPAGA := .T.
   ENDIF
   IF ValType( nIND ) <> "N"
      nIND := 1
   ENDIF
   IF nIND = 0
      nIND := 1
   ENDIF

   IF !File( xARQUIVO1 + ".DBF" )
      RETURN .F.
   ENDIF
   IF !USECHK( xARQUIVO1,, .T. )
      RETURN .F.
   ENDIF
   IF !USEREDE( xARQUIVO2, 1, 99 )
      dbCloseAll()
      RETURN .F.
   ENDIF
   dbSetOrder( nIND )
   xBUSCA := IndexKey()


   MDS( "Aguarde Atualizando" )
   dbSelectAr( xARQUIVO1 )
   INITVARS()
   CLRVARS()
   dbSelectAr( xARQUIVO2 )
   INITVARS()
   CLRVARS()
   dbSelectAr( xARQUIVO1 )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   WHILE !Eof()
      EQUVARS()
      IF !NOVOOPE( xARQUIVO2, &xBUSCA. )
         dbGoTop()
         IF dbSeek( &xBUSCA. )
            dbRLock()
            REPLVARS( .T., .T. )  // Se nao incluir grava os campos em branco
            dbUnlock()
            IF xARQUIVO2 = "MF01" .AND. Empty( FIELD->BANCO ) .AND. Left( FIELD->NUMERO, 1 ) <> "M"   // mantendo codigo banco
               dbRLock()
               FIELD->BANCO := Val( FIELD->NUMERO )  // antes eram so numero agora tem banco comecando com M
               dbUnlock()
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( xARQUIVO1 )
      dbSkip()
      ZEI_FORT( nLASTREC,,, 1 )
   ENDDO
   FREEVARS()
   dbSelectAr( xARQUIVO1 )
   dbCloseArea()
   dbSelectAr( xARQUIVO2 )
   dbCloseArea()
   IF lAPAGA
      FErase( xARQUIVO1 + ".DBF" )
      FErase( xARQUIVO1 + ".DBT" )
   ENDIF

   RETURN .T.

// + EOF: m_cr.prg
// +
