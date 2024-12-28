// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bm9.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_BM9.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bm9()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bm9

   PARA cARQPRI

   MDI( "Resumo Checagem de Cabec rios Itens" )
   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF

   CTLIN := 80

   IF cARQPRI = "MM01"
      aRETU := PERFEC( { "MM01", "MM02" }, { "M1", "M2" }, { "MM91", "MM92" } )
   ELSE
      aRETU := PERFEC( { "MK01", "MK02" }, { "K1", "K2" }, { "MK91", "MK92" } )
   ENDIF

   nMESUSO  := aRETU[ 1 ]
   nANOUSO  := aRETU[ 2 ]
   cCAB     := aRETU[ 7 ]
   ARQWORK1 := aRETU[ 5, 1 ]
   ARQWORK2 := aRETU[ 5, 2 ]

   IF !USEMULT( { { ARQWORK1, 1, 99 }, { ARQWORK2, 1, 99 } } )
      RETU .F.
   ENDIF

   mds( "Valores" )
   IMPRESSORA()
   dbSelectAr( ARQWORK2 )
   nLASTREC := LastRec()
   dbGoTop()
   WHILE !Eof()
      xNUMERO    := if( cARQPRI = "MM01", NUMERO, NRNOTA )
      xFORNECEDO := FORNECEDO
      nTOTMER    := nTOTIPI := nTOTNF := 0
      WHILE xNUMERO = if( cARQPRI = "MM01", NUMERO, NRNOTA ) .AND. IF( cARQPRI = "MM01", .T., xFORNECEDO = FORNECEDO ) .AND. !Eof()
         nTOTMER += VALORMER
         nTOTIPI += VALORIPI
         nTOTNF  += VALORTOT
         VIDEO()
         ZEI_FORT( nLASTREC )
         IMPRESSORA()
         dbSkip()
      ENDDO
      m_BM9CAB()
      dbSelectAr( ARQWORK1 )
      dbGoTop()
      IF !dbSeek( IF( cARQPRI = "MK01", Str( xNUMERO, 8 ) + Str( xFORNECEDO, 5 ), xNUMERO ) )
         m_BM9CAB()
         @ CTLIN, 0 SAY "Nota Fiscal n„o Encontrada -> " + Str( xNUMERO, 8 )
         CTLIN++
         VIDEO()
         IF MDG( "NF n„o Encontrada -> " + Str( xNUMERO, 8 ) + " Apagar" )
            netrecdel()
         ENDIF
         IMPRESSORA()
      ELSE
         IF Round( nTOTMER, 2 ) # Round( TOTMER, 2 ) .OR. ;
               Round( nTOTIPI, 2 ) # Round( TOTIPI, 2 ) .OR. ;
               Round( nTOTNF, 2 ) # Round( TOTNF, 2 )
            m_BM9CAB()
            @ CTLIN, 0  SAY Str( xNUMERO, 8 ) + " Cabecario"
            @ CTLIN, 20 SAY TOTMER                      PICT "@E 999,999,999.99"
            @ CTLIN, 40 SAY TOTIPI                      PICT "@E 999,999,999.99"
            @ CTLIN, 60 SAY TOTNF                       PICT "@E 999,999,999.99"
            CTLIN++
            @ CTLIN, 0  SAY Str( xNUMERO, 8 ) + " Itens    "
            @ CTLIN, 20 SAY nTOTMER                     PICT "@E 999,999,999.99"
            @ CTLIN, 40 SAY nTOTIPI                     PICT "@E 999,999,999.99"
            @ CTLIN, 60 SAY nTOTNF                      PICT "@E 999,999,999.99"
            CTLIN++
         ENDIF
      ENDIF
      dbSelectAr( ARQWORK2 )
   ENDDO
   VIDEO()
   MDS( "Fixando Apura‡„o" )
   IMPRESSORA()
   dbSelectAr( ARQWORK1 )
   nLASTREC := LastRec()
   dbGoTop()
   WHILE !Eof()
      yAPURA     := APURA
      mCOD       := ""   // Vazio Padrao para apura N
      xNUMERO    := if( cARQPRI = "MM01", NUMERO, NRNOTA )
      xFORNECEDO := FORNECEDO
      yESPECIE   := ESPECIE
      nTOTNF     := 0
      IF cARQPRI = "MK01"
         IF yAPURA = "S"
            IF Empty( COD )  // Tenta Itens NF
               mCOD := Left( OBTER( "MK02", xNUMERO, "CODDEP", 4 ), 3 )
               IF !Empty( mCOD )
                  GRAVACAMPO( "COD", "mCOD",,, .F. )
               ENDIF
               IF Empty( COD )   // Tenta Cadastro Fornecedor
                  mCOD := Left( OBTER( "MB01", FORNECEDO, "CTACONTB" ), 3 )
                  IF !Empty( mCOD )
                     GRAVACAMPO( "COD", "mCOD",,, .F. )
                  ENDIF
               ENDIF
            ELSE
               mCOD := COD   // Pega o Codigo Gravado
            ENDIF
         ELSE
            GRAVACAMPO( "COD", "SPACE(3)",,, .F. )
         ENDIF
      ENDIF

      dbSelectAr( ARQWORK2 )
      dbGoTop()
      IF cARQPRI = "MM01"
         dbSeek( Str( xNUMERO, 8 ) )
      ELSE
         dbSeek( Str( xNUMERO, 8 ) + Str( xFORNECEDO, 5 ) )
      ENDIF
      WHILE if( cARQPRI = "MM01", NUMERO, NRNOTA ) = xNUMERO .AND. IF( cARQPRI = "MM01", .T., xFORNECEDO = FORNECEDO ) .AND. !Eof()
         IF APURA # yAPURA
            gravacampo( "APURA", "yAPURA",,, .F. )
            m_bm9cab()
            @ CTLIN, 0 SAY "Nota Fiscal " + Str( xNUMERO, 8 ) + " Sequencia " + Str( IF( CARQPRI = "MK01", ITEM, SEQ ), 3 ) + " Erro apura Fixado"
            CTLIN++
         ENDIF
         IF FORNECEDO # xFORNECEDO
            gravacampo( "FORNECEDO", "xFORNECEDO",,, .F. )
            m_bm9cab()
            @ CTLIN, 0 SAY "Nota Fiscal " + Str( xNUMERO, 8 ) + " Sequencia " + Str( IF( CARQPRI = "MK01", ITEM, SEQ ), 3 ) + " Erro No.Cli/Fornecedo Fixado"
            CTLIN++
         ENDIF
         IF cARQPRI <> "MK01"
            IF ESPECIE # yESPECIE
               gravacampo( "ESPECIE", "yESPECIE",,, .F. )
               m_bm9cab()
               @ CTLIN, 0 SAY "Nota Fiscal " + Str( xNUMERO, 8 ) + " Sequencia " + Str( IF( CARQPRI = "MK01", ITEM, SEQ ), 3 ) + " Erro especie Fixado"
               CTLIN++
            ENDIF
         ENDIF
         IF cARQPRI = "MK01"
            IF yAPURA = "S" .AND. Empty( CODDEP )
               IF !Empty( mCOD )
                  GRAVACAMPO( "CODDEP", "mCOD",,, .F. )
               ELSE
                  IF TIPOENT $ 'MCORPS'
                     mCODDEP := Left( OBTER( ESTQARQ( TIPOENT, 1 ), CODIGO, "CTACONTB" ), 3 )
                     IF !Empty( mCODDEP )
                        GRAVACAMPO( "CODDEP", "mCODDEP",,, .F. )
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
            IF yAPURA = "N"
               GRAVACAMPO( "CODDEP", "SPACE(3)",,, .F. )
            ENDIF
         ENDIF
         IF CFONEW = "5101" .OR. CFONEW = "6101" .OR. CFONEW = "5102" .OR. CFONEW = "6102"
            IF TIPOSERV <> "1"
               m_bm9cab()
               @ CTLIN, 0 SAY "Nota Fiscal " + Str( xNUMERO, 8 ) + " Sequencia " + Str( IF( CARQPRI = "MK01", ITEM, SEQ ), 3 ) + " " + CFONEW + " Servico " + TIPOSERV
               CTLIN++
            ENDIF
         ENDIF
         IF CFONEW = "5124" .OR. CFONEW = "6124"
            IF TIPOSERV <> "3"
               m_BM9CAB()
               @ CTLIN, 0 SAY "Nota Fiscal " + Str( xNUMERO, 8 ) + " Sequencia " + Str( IF( CARQPRI = "MK01", ITEM, SEQ ), 3 ) + " " + CFONEW + " Servico " + TIPOSERV
               CTLIN++
            ENDIF
         ENDIF
         dbSkip()
      ENDDO
      dbSelectAr( ARQWORK1 )
      dbSkip()
      VIDEO()
      ZEI_FORT( nLASTREC )
      IMPRESSORA()
   ENDDO
   IMPFOL()
   VIDEO()
   dbCloseAll()
   IMPEND()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_BM9CAB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC m_BM9CAB()

   IF CTLIN > 50
      @  0, 0 SAY "Checagem itens Cabecarios Nota Fiscal"
      @  1, 0 SAY repl( "=", 80 )
      CTLIN := 2
   ENDIF

// + EOF: M_BM9.PRG

// + EOF: m_bm9.prg
// +
