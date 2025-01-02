// +--------------------------------------------------------------------
// +
// +    Programa  : folis_c2.prg  Listar SalArio VariAvel
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function folis_c2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION folis_c2

   PARA CC

   IF !MDL( 'Listar Sal rio Vari vel', 0 )
      RETU
   ENDIF

   IF !NETUSE( carq )
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

   IF CC = 0
      IF !NETUSE( "FO_VAR" )
         RETU
      ENDIF
   ENDIF
   IF CC = 1
      IF !NETUSE( "FO_VBR" )
         RETU
      ENDIF
   ENDIF
   cSELE2 := Alias()
   FILTRA := 'NUMERO=NUM'
   FL     := 0
   SET DEVI TO PRIN
   CABVAR()
   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      NUM := NUMERO
      NOM := NOME
      TOT := 0
      dbSelectAr( cSELE2 )
      SET FILTER TO &FILTRA
      dbGoTop()
      WHILE !Eof()
         IF PRow() > 56
            IMPFOL()
            CABVAR()
         ENDIF
         @ PRow() + 1, 00 SAY NUM
         @ PRow(), 11    SAY SubStr( NOM, 1, 25 )
         @ PRow(), 38    SAY CONTA
         @ PRow(), 45    SAY TIPO
         @ PRow(), 50    SAY NIV13S
         @ PRow(), 54    SAY HORAS            PICT "###.##"
         @ PRow(), 62    SAY VALOR            PICT "###,###,###,###.##"
         TOT += VALOR
         dbSelectAr( cSELE2 )
         dbSkip()
      ENDDO
      IF TOT > 0
         @ PRow() + 1, 62 SAY TOT          PICT "###,###,###,###.##"
         @ PRow() + 1, 00 SAY REPL( '-', 80 )
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   dbCloseAll()
   @ PRow() + 1, 00 SAY REPL( '-', 80 )
   IMPFOL()
   VIDEO()
   IMPEND()
   RETU

// !*****************************************************************************
// !
// !       CABVAR
// !
// !    Chamado por: FOLIS_C2.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABVAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABVAR

   FL++
   @ PRow(), 00    SAY IMPCHR( cIMPTIT ) + MSG2
   @ PRow() + 1, 50 SAY Time()
   @ PRow(), 60    SAY Date()
   @ PRow(), 70    SAY 'FL. ' + StrZero( FL, 4 )
   @ PRow() + 1, 00 SAY REPL( '-', 80 )
   @ PRow() + 1, 00 SAY IMPCHR( cIMPTIT ) + ACENTO( 'Sal rio Vari vel' )
   @ PRow() + 1, 00 SAY REPL( '-', 80 )
   @ PRow() + 1, 00 SAY ACENTO( "N£mero     Nome" + SPAC( 22 ) + "Conta Tipo N¡vel Horas   Valor" )
   @ PRow() + 1, 00 SAY REPL( '-', 80 )
   RETU
// : FIM: FOLIS_C2.PRG

// + EOF: folis_c2.prg
// +
