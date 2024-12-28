// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3k.prg
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
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
// +    Function fopto_3k()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_3k

   PARA nTipo

   cARQ := "XXXX"
   IF nTIPO = 1  // Atuais
      carq := IF( lSECBCO, "BCOBAK", "BCOHRS" )
   ENDIF
   IF nTIPO = 2  // Arquivados
      carq := IF( lSECBCO, "BCODEK", "BCODEM" )
   ENDIF


   IF !MDL( 'FOPTO_3K - Listagem Saldo Banco Horas' )
      RETU
   ENDIF

   cTIPLIS := "A"
   cTIPREL := "D"
   MDS( "(H)oras (D)ias (A)mbos" )
   @ 24, 40 GET cTIPLIS VALID cTIPLIS $ "HDA" PICT "!"
   IF !READCUR()
      RETU .F.
   ENDIF

   MDS( "(D)etalhado (S)aldos" )
   @ 24, 40 GET cTIPREL VALID cTIPREL $ "DS" PICT "!"
   IF !READCUR()
      RETU .F.
   ENDIF

   IF !NETUSE( pes )
      dbCloseAll()
      RETU
   ENDIF
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
   INX    := ""
   FILORD( .T. )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF ValType( INX ) = "N"
      dbSetOrder( INX )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", inx )
      ordSetFocus( "temp" )
   ENDIF
   SET FILTER TO &FILTRO



   IF !NETUSE( carQ )  // !AREDE(cARQ,cARQ,1 )
      dbCloseAll()
      RETU
   ENDIF
   FILTRA := ''
   FILTRA := FILTRO( FILTRA )
   SET FILTER TO &FILTRA

   nTOTHOR  := 0
   nTOTDIA  := 0
   CTLINOLD := 0
   CTLIN    := 80
   LISTARUE( {| X | FOPTO3K( X ) }, {|| FO3KTOT() } )


   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO3KTOT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO3KTOT

   CTLIN := CTLINOLD
   CTLIN++
   @ CTLIN, 0 SAY repl( "-", if( cTIPREL = "S", 80, 132 ) )
   CTLIN++
   @ CTLIN, 0 SAY "Total Geral"
   IF cTIPLIS = "A" .OR. cTIPLIS = "H"
      @ CTLIN, 60 SAY nTOTHOR PICT "@E 999999.99"
   ENDIF
   IF cTIPLIS = "A" .OR. cTIPLIS = "D"
      @ CTLIN, 70 SAY nTOTDIA PICT "@E 999999.99"
   ENDIF
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO3K()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO3K

   PARA COMPARE

   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         mNUMERO := NUMERO
         mNOME   := NOME
         IF CTLIN > 55
            @  0, 0  SAY if( cTIPREL = "D", IMPSTR( cIMPCOM ), "" ) + "Saldo Banco Horas/Dias"
            @  1, 0  SAY "Funcionario"
            @  1, 50 SAY "Mes"
            @  1, 54 SAY "Ano"
            IF cTIPREL = "D"
               @  1, 60 SAY "Anterior"
               @  1, 70 SAY "Credito"
               @  1, 80 SAY "Debito"
               @  1, 90 SAY "Saldo"
            ELSE
               @  1, 64 SAY "Horas"
               @  1, 74 SAY "Dias"
            ENDIF
            @  2, 0 SAY NOMSETOR
            @  3, 0 SAY repl( "=", if( cTIPREL = "S", 80, 132 ) )
            CTLIN := 4
         ENDIF
         nTOTFUNHOR := 0
         nTOTFUNDIA := 0
         dbSelectAr( cARQ )
         dbGoTop()
         dbSeek( Str( mNUMERO, 8 ) )
         WHILE mNUMERO = NUMERO .AND. !Eof()
            @ CTLIN, 0  SAY mNUMERO
            @ CTLIN, 9  SAY Left( mNOME, 38 )
            @ CTLIN, 49 SAY MES
            @ CTLIN, 52 SAY ANO
            IF ( cTIPLIS = "A" .OR. cTIPLIS = "H" ) .AND. cTIPREL = "D"
               @ CTLIN, 57 SAY "Hrs"
               @ CTLIN, 60 SAY SALANT  PICT "@E 99,999.99"
               @ CTLIN, 70 SAY CREDITO PICT "@E 99,999.99"
               @ CTLIN, 80 SAY DEBITO  PICT "@E 99,999.99"
               @ CTLIN, 90 SAY SALDO   PICT "@E 99,999.99"
               CTLIN++
            ENDIF
            IF ( cTIPLIS = "A" .OR. cTIPLIS = "D" ) .AND. cTIPREL = "D"
               @ CTLIN, 57 SAY "Dia"
               @ CTLIN, 60 SAY DIAANT PICT "@E 99,999.99"
               @ CTLIN, 70 SAY DIACRE PICT "@E 99,999.99"
               @ CTLIN, 80 SAY DIADEB PICT "@E 99,999.99"
               @ CTLIN, 90 SAY DIASAL PICT "@E 99,999.99"
               CTLIN++
            ENDIF
            IF cTIPREL = "S"
               IF cTIPLIS = "A" .OR. cTIPLIS = "H"
                  @ CTLIN, 59 SAY SALDO PICT "@E 999,999.99"
               ENDIF
               IF cTIPLIS = "A" .OR. cTIPLIS = "D"
                  @ CTLIN, 69 SAY DIASAL PICT "@E 999,999.99"
               ENDIF
               CTLIN++
            ENDIF
            nTOTFUNHOR := SALDO  // pega o ultimo saldo
            nTOTFUNDIA := DIASAL   // pega o ultimo saldo
            dbSkip()
         ENDDO
         nTOTHOR += nTOTFUNHOR
         nTOTDIA += nTOTFUNDIA
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   CTLINOLD := CTLIN
   CTLIN    := 80


// + EOF: fopto_3k.prg
// +
