// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fog2.prg
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

// :*****************************************************************************
// :
// :       FOG2.PRG: Listar Planilha de apontamento de dados
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 21/07/98
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fog2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fog2

   PARA CC

   IF !MDL( 'Listar Planilha de apontamento de dados', 0 )
      RETU
   ENDIF
   nARQ := 1
   IF MDG( "Folha RPA" )
      nARQ := 8
   ENDIF

   REP1 := IF( CC = 0, 3, 2 )
   REP2 := IF( CC = 0, 9, 18 )
   POS1 := SPAC( 40 )
   MDS( 'Digite Cabe‡ario Complementar' )
   @ 24, 35 GET POS1
   READCUR()

   DECLARE CON[ 18 ]
   PLAN := SPAC( 6 )
   MDS( 'Digite Planilha de entrada' )
   @ 24, 35 GET PLAN
   READCUR()

   IF !NETUSE( "FO_PLENT" )
      dbCloseAll()
      RETU
   ENDIF
   dbGoTop()
   dbSeek( PLAN )
   IF Found()
      FOR X := 1 TO 18
         MACRO := 'C' + StrZero( X, 2 )
         CON[ X ] = &MACRO
      NEXT X
   ELSE
      AFill( CON, 0 )
   ENDIF
   dbCloseAll()

   IF CC = 1
      DECLARE DES[ 18 ]
      IF !ARQCTA( nARQ )
         RETU
      ENDIF
      FOR X := 1 TO 18
         BUSCA := CON[ X ]
         dbGoTop()
         IF dbSeek( BUSCA )
            DES[ X ] = DESCR
         ELSE
            DES[ X ] = ""
         ENDIF
      NEXT X
      dbCloseAll()
   ENDIF

   IF !ARQPES( nARQ, 1, 0 )
      RETU .F.
   ENDIF
   cSELE1 := Alias()
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))'
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

   IF !NETUSE( "FUNCAO" )
      dbCloseAll()
      RETU .F.
   ENDIF

   FL := 0
   IMPRESSORA()
   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      FL++
      @  1, 1  SAY impstr( Cimpexp )
      @  2, 0  SAY IMPCHR( cIMPTIT ) + MSG2
      @  3, 0  SAY ' PLANILHA DE ENTRADA DE DADOS: ' + MMES + '/' + StrZero( ANO, 4 )
      @  5, 0  SAY POS1
      @  5, 50 SAY Time()
      @  5, 60 SAY DXDIA
      @  5, 70 SAY 'FL. ' + StrZero( FL, 4 )
      FOR X := 1 TO REP1
         @ PRow() + 1, 0 SAY REPL( '=', 80 )
         @ PRow() + 1, 0 SAY "DEP  SET SEC CHA Numero Nome" + SPAC( 27 ) + "Admissao Funcao"
         @ PRow() + 1, 0 SAY DEPTO
         @ PRow(), 5   SAY SETOR
         @ PRow(), 9   SAY SECAO
         @ PRow(), 13   SAY CHAPA
         @ PRow(), 17   SAY NUMERO
         @ PRow(), 24   SAY NOME
         @ PRow(), 55   SAY ADMITIDO
         @ PRow(), 64   SAY OBTER( "FUNCAO",, FUNCAO, "FNOME" )
         IF nARQ = 1
            dbSelectAr( cSELE1 )
            @ PRow() + 1, 0 SAY "Tipo   - Sal.Mes Anterior:" + SPAC( 20 ) + "Sal.Mes Atual:"
            @ PRow(), 5   SAY TIPO
            IF MES > 1
               XSAL   := 'SAL' + SubStr( MMES( MES - 1 ), 1, 3 )
               SALANT := &XSAL
               @ PRow(), 27 SAY SALANT
            ENDIF
            VAR1 := SALH := SALM := 0
            SALHM()
            @ PRow(), 61 SAY VAR1
         ENDIF
         @ PRow() + 1, 0 SAY REPL( '=', 80 )
         IF CC = 0
            @ PRow() + 1, 0 SAY "| Conta | H o r a s | Valor" + SPAC( 13 ) + "| Conta | H o r a s | Valor" + SPAC( 12 ) + "|"
         ELSE
            @ PRow() + 1, 0 SAY "| Conta | Descricao" + SPAC( 14 ) + "| H o r a s | Valor" + SPAC( 12 ) + "| Obs:" + SPAC( 9 ) + "|"
         ENDIF
         @ PRow() + 1, 0 SAY REPL( '-', 80 )
         FOR W := 1 TO REP2
            IF CC = 0
               @ PRow() + 1, 0 SAY "|       |___________|___________________|       |___________|__________________|"
               IF CON[ W * 2 - 1 ] # 0
                  @ PRow(), 3 SAY CON[ W * 2 - 1 ]
               ENDIF
               IF CON[ W * 2 ] # 0
                  @ PRow(), 43 SAY CON[ W * 2 ]
               ENDIF
            ELSE
               @ PRow() + 1, 0 SAY "|       | " + SPAC( 22 ) + " |___________|__________________|______________|"
               IF CON[ W ] # 0
                  @ PRow(), 3 SAY CON[ W ]
                  @ PRow(), 10 SAY impstr( Cimpcom ) + ( DES[ W ] ) + impstr( Cimpexp )
               ENDIF
            ENDIF
         NEXT W
         dbSkip()
         IF Eof()
            EXIT
         ENDIF
      NEXT X
      @ PRow() + 1, 0 SAY REPL( '-', 80 )
   ENDDO
   dbCloseAll()
   IMPFOL()
   VIDEO()
   IMPEND()
   FErase( mTEMP )
   RETU

// : FIM: FOG2.PRG

// + EOF: fog2.prg
// +
