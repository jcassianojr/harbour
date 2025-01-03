// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_b2.prg Listar Planilha de F‚rias Completa
// +
// +
// +
// +     Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


FUNCTION fores_b2()

   IF !MDL( 'Listar Planilha de Ferias Completa', 0 )
      RETU
   ENDIF
   FILTRA := IF( MDG( 'Deseja Excluir Periodos ja  baixados' ), "NUMERO=VAR3.AND.BAIXADO#'S'", "NUMERO=VAR3" )

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

   IF !NETUSE( "FO_FER" )
      RETU
   ENDIF


   CTLIN := 80
   FL    := 0


   SALTO := 0
   IMPRESSORA()
   dbSelectAr( PES )
   dbGoTop()
   CABB2()
   WHILE !Eof()
      IF PRow() > 60
         CABB2()
      ENDIF
      CABB22()
      VAR3 := NUMERO
      dbSelectAr( "FO_FER" )
      SET FILTER TO &FILTRA
      dbGoTop()
      WHILE !Eof()
         IF PRow() > 60
            IMPFOL()
            CABB2()
            CABB22()
            dbSelectAr( "FO_FER" )
         ENDIF
         @ PRow() + SALTO, 0 SAY '|'
         SALTO := 1
         @ PRow(), 47  SAY DATFERIAS
         @ PRow(), 56  SAY DATFERIASF
         @ PRow(), 64  SAY '|'
         @ PRow(), 66  SAY '30'
         @ PRow(), 69  SAY '|'
         @ PRow(), 72  SAY FALTAS
         @ PRow(), 76  SAY '|'
         @ PRow(), 79  SAY DIASJUS
         @ PRow(), 82  SAY '|'
         @ PRow(), 85  SAY BAIXADO
         @ PRow(), 87  SAY '|'
         @ PRow(), 89  SAY DIASPAGO3
         @ PRow(), 92  SAY '|'
         @ PRow(), 94  SAY DIASGOZA3
         @ PRow(), 97  SAY '|'
         @ PRow(), 98  SAY GOZOU1DE
         @ PRow(), 107 SAY GOZOU1ATE
         @ PRow(), 115 SAY '|'
         @ PRow(), 116 SAY ABONO1DE
         @ PRow(), 125 SAY ABONO1ATE
         @ PRow(), 133 SAY '|'
         @ PRow(), 134 SAY GOZOU2DE
         @ PRow(), 143 SAY GOZOU2ATE
         @ PRow(), 151 SAY '|'
         @ PRow(), 152 SAY PROGRAMA
         @ PRow(), 161 SAY PROGRAMA1
         @ PRow(), 169 SAY '|'
         @ PRow(), 170 SAY REPL( '_', 48 )
         @ PRow(), 219 SAY '|'
         dbSkip()
      ENDDO
      @ PRow() + 1, 0 SAY REPL( '-', 219 )
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   IMPFOL()
   VIDEO()
   dbCloseAll()
   IMPEND()

   RETURN

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABB2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CABB2

   FL := FL + 1
   @ PRow(), 1     SAY IMPSTR( cIMPEXP )
   @ PRow() + 1, 20  SAY IMPCHR( cIMPTIT ) + MSG2
   @ PRow() + 1, 100 SAY Time()
   @ PRow(), 110    SAY 'DATA => ' + DToC( DXDIA )
   @ PRow(), 120    SAY 'FL. ' + StrZero( FL, 4 )
   @ PRow() + 1, 0   SAY REPL( '-', 132 )
   @ PRow() + 1, 20  SAY IMPCHR( cIMPTIT ) + 'FICHA COMPLETA DE FERIAS'
   @ PRow() + 1, 0   SAY REPL( '-', 131 ) + IMPSTR( cIMPCOM )
   @ PRow() + 1, 0   SAY '|NRo. |NOME'
   @ PRow(), 37     SAY '|ADMITIDO|PERIODO AQUISICAO|DIAS|FALTAS| JUS | OK |PAGO|GOZA'
   @ PRow(), 97     SAY '|1. FERIAS GOZADAS|ABONO  PECUNIARIO|2. FERIAS GOZADAS|'
   @ PRow(), 152    SAY 'PROGRAMA  FERIAS |OBSERVACOES'
   @ PRow(), 219    SAY '|'
   @ PRow() + 1, 0   SAY REPL( '-', 219 )
   RETU

// !*****************************************************************************
// !
// !       CABB22
// !
// !    Chamado por: FORES_B2.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABB22()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABB22

   dbSelectAr( PES )
   @ PRow() + 1, 0 SAY '|' + Str( NUMERO, 5 ) + '|' + NOME
   @ PRow(), 37   SAY '|' + DToC( ADMITIDO ) + '|'
   SALTO := 0
   RETU
// : FIM: FORES_B2.PRG

// + EOF: fores_b2.prg
// +
