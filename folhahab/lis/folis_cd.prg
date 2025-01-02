// +--------------------------------------------------------------------
// +
// +    Programa  : folis_cd.prg Listar 13§ Provisao Acumulada
// +
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


FUNCTION folis_cd()

   IF !MDL( 'Listar 13§ Provis„o Acumulada', 0 )
      RETU
   ENDIF


   lANAL := MDG( "Deseja Resumo Analitico" )
   aXCON := PEGRELCTA( "PROV13" )


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


   IF !NETUSE( "PROV13" )
      dbCloseAll()
      RETU .F.
   ENDIF


   LISTARUE( {| X | FOLISCD( X ) } )

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOLISCD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOLISCD

   PARA COMPARE

   TOTALIZA := .F.
   aCOM     := {}
   aVAL     := {}
   CTLIN    := 80
   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         TOTALIZA := .T.
         IF CTLIN > 55 .AND. lANAL
            FOLISCD01()
         ENDIF
         IF lANAL
            @ CTLIN, 0 SAY REPL( '-', 132 )
            CTLIN++
            @ CTLIN, 0  SAY NUMERO
            @ CTLIN, 6  SAY NOME
            @ CTLIN, 36 SAY ADMITIDO
            CTLIN++
         ENDIF
         mNUMERO := NUMERO
         dbSelectAr( "PROV13" )
         dbGoTop()
         dbSeek( StrZero( mNUMERO, 8 ) )
         WHILE mNUMERO = NUMERO .AND. !Eof()
            IF lANAL
               @ CTLIN, 0  SAY MES
               @ CTLIN, 3  SAY ANO
               @ CTLIN, 8  SAY AVOS
               @ CTLIN, 12 SAY SALARIO + SALVAR PICT '@E 999,999,999.99'
               @ CTLIN, 28 SAY VALOR          PICT '@E 9999,999,999.99'
               @ CTLIN, 44 SAY VALENC         PICT '@E 9999,999,999.99'
               @ CTLIN, 60 SAY VALTOT         PICT '@E 9999,999,999.99'
               @ CTLIN, 76 SAY VALPRI         PICT '@E 9999,999,999.99'
               @ CTLIN, 92 SAY VALLIQ         PICT '@E 9999,999,999.99'
               CTLIN++
            ENDIF
            // Valores Pagos
            VIDEO()
            nDESCONTA := 0
            cARQUSO   := 'FP' + EMP + StrZero( MES, 2 )
            IF !NETUSE( cARQUSO )  // AREDE(cARQUSO,cARQUSO,0)
               dbCloseAll()
               RETU .F.
            ENDIF
            FOR W := 1 TO 15
               IF !Empty( aXCON[ W ] )
                  dbGoTop()
                  dbSeek( mNUMERO * 10000 + aXCON[ W ] )
                  IF Found()
                     nDESCONTA += VALOR
                  ENDIF
               ENDIF
            NEXT W
            dbCloseArea()
            IMPRESSORA()
            dbSelectAr( "PROV13" )
            nPOS := AScan( aCOM, StrZero( ANO, 4 ) + StrZero( MES, 2 ) )
            IF nPOS > 0
               aVAL[ nPOS,  1 ] += VALOR
               aVAL[ nPOS,  2 ] += VALENC
               aVAL[ nPOS,  3 ] += VALTOT
               aVAL[ nPOS,  4 ] += VALPRI
               aVAL[ nPOS,  5 ] += VALLIQ
               aVAL[ nPOS,  6 ] += nDESCONTA
            ELSE
               AAdd( aCOM, StrZero( ANO, 4 ) + StrZero( MES, 2 ) )
               AAdd( aVAL, { VALOR, VALENC, VALTOT, VALPRI, VALLIQ, nDESCONTA } )
            ENDIF
            dbSkip()
         ENDDO
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   IF TOTALIZA
      aANT  := { 0, 0, 0, 0, 0, 0 }
      CTLIN := 80
      FOR W := 1 TO Len( aCOM )
         IF CTLIN > 50
            FOLISCD01()
         ENDIF
         @ CTLIN, 0   SAY Right( aCOM[ W ], 2 )
         @ CTLIN, 4   SAY Left( aCOM[ W ], 4 )
         @ CTLIN, 28  SAY aVAL[ W, 1 ]        PICT '@E 9999,999,999.99'
         @ CTLIN, 44  SAY aVAL[ W, 2 ]        PICT '@E 9999,999,999.99'
         @ CTLIN, 60  SAY aVAL[ W, 3 ]        PICT '@E 9999,999,999.99'
         @ CTLIN, 76  SAY aVAL[ W, 4 ]        PICT '@E 9999,999,999.99'
         @ CTLIN, 92  SAY aVAL[ W, 5 ]        PICT '@E 9999,999,999.99'
         @ CTLIN, 108 SAY aVAL[ W, 6 ]        PICT '@E 9999,999,999.99'
         CTLIN++
         IF W # 1
            @ CTLIN, 0  SAY "Diferen‡a"
            @ CTLIN, 28 SAY aVAL[ W, 1 ] - aANT[ 1 ] PICT '@E 9999,999,999.99'
            @ CTLIN, 44 SAY aVAL[ W, 2 ] - aANT[ 2 ] PICT '@E 9999,999,999.99'
            @ CTLIN, 60 SAY aVAL[ W, 3 ] - aANT[ 3 ] PICT '@E 9999,999,999.99'
            @ CTLIN, 76 SAY aVAL[ W, 4 ] - aANT[ 4 ] PICT '@E 9999,999,999.99'
            @ CTLIN, 92 SAY aVAL[ W, 5 ] - aANT[ 5 ] PICT '@E 9999,999,999.99'
            CTLIN++
         ENDIF
         aANT[ 1 ] := aVAL[ W, 1 ]
         aANT[ 2 ] := aVAL[ W, 2 ]
         aANT[ 3 ] := aVAL[ W, 3 ]
         aANT[ 4 ] := aVAL[ W, 4 ]
         aANT[ 5 ] := aVAL[ W, 5 ]
      NEXT W
      CTLIN++
      IMPFOL()
   ENDIF
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOLISCD01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOLISCD01

   FL++
   @  1, 1   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
   @  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
   @  3, 90  SAY Time()
   @  3, 100 SAY 'DATA ' + DToC( DXDIA )
   @  3, 120 SAY 'FL. ' + StrZero( FL, 4 )
   @  4, 00  SAY IMPCHR( cIMPTIT ) + ACENTO( 'PROVISAO DE 13o Salario: ' + AllTrim( NOMSETOR ) )
   @  5, 0   SAY "MES"
   @  5, 3   SAY "ANO"
   @  5, 9   SAY "AVOS"
   @  5, 16  SAY "SAL.SALV."
   @  5, 34  SAY "VALOR"
   @  5, 48  SAY "Encargos"
   @  5, 64  SAY "Total"
   @  5, 80  SAY "Primeira"
   @  5, 96  SAY "Liquido"
   @  5, 112 SAY "Pago"
   @  6, 0   SAY REPL( '-', 132 )
   CTLIN := 7
   RETU .T.

// : FIM: FOLIS_CD.PRG

// + EOF: folis_cd.prg
// +
