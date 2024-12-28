// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_33.prg
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



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO_33()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO_33

   PARA nTIP33

   IF !MDL( 'FOPTO_33 - Relacao Diaria de Entradas e Saidas' )
      RETU
   ENDIF
   cPN := "PN" + ANOMESW

   DIAX := Date()
   IF nTIP33 = 2 .OR. nTIP33 = 1
      MDS( 'De que dia Deseja o Relatorio' )
      @ 24, 40 GET DIAX
      READCUR()
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


   IF !netuse( cPN )
      dbCloseAll()
      RETU
   ENDIF

   IF nTIP33 = 2 .OR. nTIP33 = 4
      cPD := PARQDIO()
      IF !NETUSE( cPD )
         dbCloseAll()
         RETU
      ENDIF
   ENDIF

   PAG := 1
   LISTARUE( {| X | FOPTO33( X ) }, {|| RODAP() } )
   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO33()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO33

   PARA COMPARE

   dbSelectAr( pes )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         cTIT33 := ""
         cSUB33 := ""
         IF nTIP33 = 1
            cTIT33 := 'Relacao Diaria de Entradas e Saidas'
            cSUB33 := 'Entrada Almoco Saida'
         ENDIF
         IF nTIP33 = 2
            cTIT33 := 'Relacao Diaria Passagens Cartao'
            cSUB33 := 'Passagens'
         ENDIF
         IF nTIP33 = 3
            cTIT33 := 'Relacao Mensal de Frequencia'
            cSUB33 := 'Qtde Dias '
         ENDIF
         IF nTIP33 = 4
            cTIT33 := 'Relacao Mensal Passagem'
            cSUB33 := 'Qtde Dias '
         ENDIF
         IF PAG = 1
            CABEC( cTIT33, cSUB33,, NOMSETOR )
         ENDIF
         IF PRow() > 52
            RODAP()
            CABEC( cTIT33, cSUB33,, NOMSETOR )
         ENDIF
         @ PRow() + 1, 0 SAY Str( NUMERO, 8 ) + '-' + Left( NOME, 30 )
         NUM   := NUMERO
         CONTA := 0
         BUSCA := Str( NUMERO, 8 ) + DToS( DIAX )
         IF nTIP33 = 3 .OR. nTIP33 = 4
            BUSCA := Str( NUMERO, 8 )
         ENDIF
         IF nTIP33 = 1
            dbSelectAr( cPN )
            dbGoTop()
            IF dbSeek( BUSCA )
               @ PRow(), 50     SAY ENT
               @ PRow(), PCol() SAY MUDENT
               IF Empty( ALS ) .AND. Empty( ALE )
                  // @ prow(), 58 say "AS"
               ELSE
                  @ PRow(), 56     SAY ALS
                  @ PRow(), PCol() SAY MUDALS
                  @ PRow(), 62     SAY ALE
                  @ PRow(), PCol() SAY MUDALE
               ENDIF
               @ PRow(), 68     SAY SAI
               @ PRow(), PCol() SAY MUDSAI
            ENDIF
         ENDIF
         IF nTIP33 = 2
            COL := 40
            dbSelectAr( cPD )
            dbGoTop()
            dbSeek( BUSCA )
            WHILE NUM = NUMERO .AND. DATA = DIAX .AND. !Eof()
               @ PRow(), COL SAY HORA
               COL += 6
               dbSkip()
            ENDDO
         ENDIF
         IF nTIP33 = 3
            dbSelectAr( cPN )
            dbGoTop()
            dbSeek( BUSCA )
            WHILE NUM = NUMERO .AND. !Eof()
               IF ENT # 0
                  CONTA++
               ENDIF
               dbSkip()
            ENDDO
            @ PRow(), 50 SAY CONTA PICT '##'
         ENDIF
         IF nTIP33 = 4
            dbSelectAr( cPd )
            dbGoTop()
            dbSeek( BUSCA )
            WHILE NUM = NUMERO .AND. !Eof()
               CONTA++
               DIAX := DATA
               WHILE NUM = NUMERO .AND. DATA = DIAX .AND. !Eof()
                  dbSkip()
               ENDDO
            ENDDO
            @ PRow(), 50 SAY CONTA PICT '##'
         ENDIF

      ENDIF
      dbSelectAr( pes )
      dbSkip()
   ENDDO


// + EOF: fopto_33.prg
// +
