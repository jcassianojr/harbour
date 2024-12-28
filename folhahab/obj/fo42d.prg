// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo42d.prg
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
// :      FO42D.PRG: Nome do Programa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/07/94     14:55
// :
// :*****************************************************************************

IMPHP()


PARA CC
IF !MDL( 'Listar Projecao Salarial', 0 )
RETU
ENDIF
POS1 := SPAC( 40 )
MDS( 'Digite Cabe‡ario Complementar' )
@ 24, 35 GET POS1
IF !READCUR()
RETU .F.
ENDIF

IF !NETUSE( pes )
dbCloseAll()
RETU
ENDIF
FILTRO := ''
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

IF !netuse( "FO_PSL" )
dbCloseAll()
RETU
ENDIF

LISTARUE( {| X | FO42K( X ) } )

dbCloseAll()

// !*****************************************************************************
// !
// !         Fun‡„o: FO42K()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO42K()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FO42K

   PARA COMPARE

   SALTOT1 := SALTOT2 := SALTOT3 := QTFUN := 0
   CTLIN   := 80
   dbSelectAr( pes )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         mNUMERO := NUMERO
         dbSelectAr( "fo_psl" )
         dbGoTop()
         IF dbSeek( mNUMERO )
            IF CTLIN > 55
               FL++
               @  1, 0   SAY IF( IM1 = 'A', IMPSTR( Cimpcom ), IMPstr( Cimpexp ) )
               @  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
               @  3, 18  SAY IMPCHR( cIMPTIT ) + 'PROJECAO SALARIAL ' + NOMSETOR
               @  5, 0   SAY POS1
               @  5, 100 SAY Time()
               @  5, 110 SAY Date()
               @  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
               @  6, 0   SAY REPL( '-', 132 )
               @  7, 0   SAY 'NUM'
               @  7, 7   SAY 'NOME'
               @  7, 38  SAY 'ADMISSAO'
               @  7, 49  SAY 'FUNCAO'
               @  7, 70  SAY "SALARIO INICIAL" + SPAC( 9 ) + "SALARIO MES 1" + SPAC( 10 ) + "SALARIO MES2"
               @  8, 0   SAY REPL( '-', 132 )
               CTLIN := 9
            ENDIF
            @ CTLIN, 0   SAY NUMERO
            @ CTLIN, 7   SAY NOME
            @ CTLIN, 40  SAY ADMITIDO
            @ CTLIN, 49  SAY FUNCAO
            @ CTLIN, 70  SAY SALANT   PICT '###,###,###.##'
            @ CTLIN, 87  SAY TAXA1    PICT '##.##%'
            @ CTLIN, 94  SAY SALATU   PICT '###,###,###.##'
            @ CTLIN, 110 SAY TAXA2    PICT '##.##%'
            @ CTLIN, 117 SAY SALPRO   PICT '###,###,###.##'
            SALTOT1 += SALTOT1
            SALTOT2 += SALTOT2
            SALTOT3 += SALTOT3
            QTFUN++
            CTLIN++
         ENDIF
      ENDIF
      dbSelectAr( pes )
      dbSkip()
   ENDDO
   IF QTFUN > 0
      @ PRow() + 1, 0  SAY REPL( '-', 132 )
      @ PRow() + 1, 20 SAY 'Quantidade de Funcionarios --> '
      @ PRow(), 53    SAY QTFUN                             PICTURE '###'
      @ PRow() + 1, 20 SAY 'Total Mes Incial'
      @ PRow(), 70    SAY SALTOT1                           PICT '#,###,###,###.##'
      @ PRow() + 1, 20 SAY 'Total 1o. Mes'
      @ PRow(), 70    SAY SALTOT2                           PICT '#,###,###,###.##'
      @ PRow() + 1, 20 SAY 'Total 2o. Mes'
      @ PRow(), 70    SAY SALTOT3                           PICT '#,###,###,###.##'
      IMPFOL()
   ENDIF

// : FIM: FO42D.PRG

// + EOF: fo42d.prg
// +
