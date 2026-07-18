// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foe21.prg
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
// :     FOE21.PRG : Exibir no Video premio e adiantamento
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 30/06/98
// :
// :*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foe21()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foe21

   PARA CX, MASS

   @  4, 0 CLEA
   @  4, 0 SAY "Resumo de: " + MASS
   @  5, 0 SAY REPL( '-', 79 ) + "+"
   @  6, 1 SAY "Nro.    Sal rio" + SPAC( 6 ) + "Base I.R.R.F.     Valor" + SPAC( 8 ) + "IRRF+PENSŽO     L¡quido"
   @  7, 0 SAY REPL( '-', 6 ) + "-" + REPL( '-', 14 ) + "-" + REPL( '-', 14 ) + "-" + REPL( '-', 14 ) + "-" + REPL( '-', 13 ) + "-" + REPL( '-', 13 ) + "+"
   @ 23, 0 SAY REPL( '-', 80 )
   @ 24, 0 SAY "Funcion rios " + Chr( 16 ) + SPAC( 6 ) + Chr( 16 )
   CTAC := IF( CX = 2, 41, 445 )
   CTAD := IF( CX = 2, 501, 527 )
   CTAP := IF( CX = 2, 403, 409 )

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

   IF !netuse( fol )
      RETU
   ENDIF
   LIN    := 8
   TOTCRE := TOTDEB := TOTFUN := TOTIRR := 0.00
   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      IF LIN > 22
         TOTLIQ := TOTCRE - TOTDEB
         @ 24, 14 SAY TOTFUN PICTURE "#####"
         @ 24, 22 SAY TOTIRR PICT "###,###,###.##"
         @ 24, 37 SAY TOTCRE PICT "###,###,###.##"
         @ 24, 52 SAY TOTDEB PICT "##,###,###.##"
         @ 24, 66 SAY TOTLIQ PICT "###,###,###.##"
         READCUR()
         KEY := Inkey( 0 )
         IF KEY = 27
            dbCloseAll()
            RETU
         ENDIF
         LIN := 8
         @ 08, 00 CLEA TO 22, 79
      ENDIF
      NUM := NUMERO
      dbSelectAr( FOL )
      VCRE := VALCTA( NUM, CTAC ) + IF( CX = 2, VALCTA( NUM, 997 ), 0 )
      VDEB := VALCTA( NUM, CTAD ) - IF( CX = 2, VALCTA( NUM, 438 ), 0 )
      VIRR := VALCTA( NUM, CTAP )
      LIQ  := VCRE - VDEB
      IF LIQ # 0
         dbSelectAr( cSELE1 )
         VAR1 := SALH := SALM := 0.00
         SALHM()
         @ LIN, 00 SAY NUMERO PICT "######"
         @ LIN, 07 SAY VAR1   PICT "@E ###,###,###.##"
         @ LIN, 22 SAY VIRR   PICT "@E ###,###,###.##"
         @ LIN, 37 SAY VCRE   PICT "@E ###,###,###.##"
         @ LIN, 52 SAY VDEB   PICT "@E ##,###,###.##"
         @ LIN, 66 SAY LIQ    PICT "@E ###,###,###.##"
         TOTIRR += TOTIRR
         TOTCRE += TOTCRE
         TOTDEB += TOTDEB
         TOTFUN++
         LIN++
      ENDIF
      dbSelectAr( cSELE1 )
      dbSkip()
   ENDDO
   dbCloseAll()
   TOTLIQ := TOTCRE - TOTDEB
   @ 24, 14 SAY TOTFUN PICTURE "#####"
   @ 24, 22 SAY TOTIRR PICT "@E ###,###,###.##"
   @ 24, 37 SAY TOTCRE PICT "@E ###,###,###.##"
   @ 24, 52 SAY TOTDEB PICT "@E ##,###,###.##"
   @ 24, 66 SAY TOTLIQ PICT "@E ###,###,###.##"
   Inkey( 0 )
   RETU

// : FIM: FOE21.PRG

// + EOF: foe21.prg
// +
