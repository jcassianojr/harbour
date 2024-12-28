// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foca2.prg
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
// :      FOCA2.PRG: Apura‡„o geral da folha
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :*****************************************************************************
// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foca2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foca2

   PARA CC

   IF !MDL( 'APURA€ŽO GERAL DA FOLHA', 0 )
      RETU
   ENDIF
   IF CC = 9 .OR. CC = 10
      ALERTX( "N„o disponivel" )
      RETU
   ENDIF

   ATUALIZA := 1.000000
   MDS( 'Qual o Fator de Atualiza‡„o' )
   @ 24, 40 GET ATUALIZA PICT "99999999999.999999"
   READCUR()

   VENC   := DESC := FL := QTFUN := 0
   CTLIN  := 80
   FILTRO := ""

   IF !ARQPES( CC, 1, 1 )
      dbCloseAll()
      RETU
   ENDIF
   dbGoTop()
   WHILE !Eof()
      IF ( ( Empty( DEMITIDO ) ) .OR. ( Month( DEMITIDO ) >= MES .AND. Year( DEMITIDO ) >= ANO ) )
         IF Year( ADMITIDO ) < ANO .OR. ( Year( ADMITIDO ) = ANO .AND. Month( ADMITIDO ) <= MES )
            QTFUN++
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()

   mTEMP := tmpfile( cRDDEXT )

   nVALPOS := 0
   IF CC = 2 .OR. CC = 3 .OR. CC = 5
      MDS( "Posicao (0) Normal  (1) 1§ Mes  (2) 2§ Mes" )
      @ 24, 60 GET nVALPOS
      READCUR()
   ENDIF


   dbSelectAr( cSELE1 )
   IF !ARQUSAR( CC, 1, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "conta" )
   ordSetFocus( "temp" )
   FILTRO := FILTRO( "" )
   SET FILTER TO &FILTRO


   cSELE1 := Alias()

   IF !ARQCTA( CC, 1, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE2 := Alias()


   CRE := DEB := 0
   IMPRESSORA()
   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      IF CTLIN > 60
         FL++
         @  1, 1   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
         @  2, 25  SAY IMPCHR( cIMPTIT ) + MSG2
         @  3, 100 SAY Time()
         @  3, 110 SAY DXDIA
         @  3, 120 SAY 'FL. ' + StrZero( FL, 4 )
         @  4, 0   SAY REPL( '-', 132 )
         @  5, 0   SAY IMPCHR( cIMPTIT ) + ACENTO( 'Apura‡„o Geral da Folha de ' ) + IF( NRSEN = 'DiReT', 'PRO LABORE ', '' ) + Mmes + '/' + StrZero( Year( DXDIA ), 4 )
         @  6, 0   SAY REPL( '-', 132 )
         @  7, 1   SAY 'CONTA'
         @  7, 7   SAY ACENTO( 'Descrimina‡„o da Conta' )
         @  7, 53  SAY 'HORAS'
         @  7, 64  SAY 'VENCIMENTOS '
         @  7, 86  SAY 'DESCONTOS  '
         @  7, 108 SAY ACENTO( 'VALORES BSICOS' )
         @  8, 0   SAY REPL( '-', 132 )
         CTLIN := 9
      ENDIF
      CTA := CONTA
      TOT := TOT1 := 0.00
      WHILE CTA = CONTA .AND. !Eof()
         DO CASE
         CASE nVALPOS = 1
            TOT += VALORMES1
         CASE nVALPOS = 2
            TOT += VALORMES2
         OTHERWISE
            TOT += VALOR
         ENDCASE
         TOT1 += HORAS
         dbSkip()
      ENDDO
      IMP := .T.
      IF CC # 4 .AND. CC # 6
         IF CTA > 120 .AND. CTA < 150
            IMP := .F.
         ENDIF
         IF CTA = 910 .OR. CTA = 911 .OR. CTA = 505 .OR. CTA = 506
            IMP := .F.
         ENDIF
      ENDIF
      IF IMP .AND. TOT > 0
         @ CTLIN, 2 SAY CTA PICT "###"
         dbSelectAr( cSELE2 )
         dbGoTop()
         dbSeek( CTA )
         @ CTLIN, 6 SAY IF( Found(), DESCR, ACENTO( "Conta n„o Cadastrada" ) )
         dbSelectAr( cSELE1 )
         IF TOT1 # 0
            @ CTLIN, 46 SAY TOT1 PICT '###,###,###.##'
         ENDIF
         COL := 64
         IF CC # 6   // VT
            DO CASE
            CASE CTA > 40 .AND. CTA < 50
               COL := 86
            CASE CTA > 501
               COL := 86
            CASE CTA > 399 .AND. CTA < 502
               COL := 108
            OTHERWISE
               COL := 64
            ENDCASE
         ENDIF
         IF CC = 6
            CRE += IF( ATUALIZA # 1, Round( TOT * ATUALIZA, 2 ), TOT )
         ELSE
            DO CASE
            CASE CTA > 40 .AND. CTA < 50
               DEB += IF( ATUALIZA # 1, Round( TOT * ATUALIZA, 2 ), TOT )
            CASE CTA > 501 .AND. CTA < 999
               DEB += IF( ATUALIZA # 1, Round( TOT * ATUALIZA, 2 ), TOT )
            CASE CTA < 40
               CRE += IF( ATUALIZA # 1, Round( TOT * ATUALIZA, 2 ), TOT )
            CASE CTA > 50 .AND. CTA < 399
               CRE += IF( ATUALIZA # 1, Round( TOT * ATUALIZA, 2 ), TOT )
            ENDCASE
         ENDIF
         TOT := IF( ATUALIZA # 1, Round( TOT * ATUALIZA, 2 ), TOT )
         @ CTLIN, COL SAY TOT PICT '###,###,###,###.##'
         CTLIN++
         IF CC # 6
            DO CASE
            CASE CTA = 399
               VENC := TOT
            CASE CTA = 999
               DESC := TOT
            ENDCASE
         ELSE
            VENC += TOT
         ENDIF
      ENDIF
   ENDDO
   @ PRow() + 1, 0 SAY REPL( '-', 132 )
   @ PRow() + 1, 6 SAY ACENTO( '...........................L¡quido ..===> ' )
   @ PRow(), 64   SAY VENC - DESC                                          PICT '###,###,###,###.##'
   IF Round( CRE, 2 ) # Round( VENC, 2 )
      @ PRow() + 1, 6 SAY ACENTO( "Erro na Totaliza‡„o Cr‚dito" )
      @ PRow(), 50   SAY VENC                                  PICT '###,###,###.##'
      @ PRow(), 64   SAY CRE                                   PICT '###,###,###.##'
      @ PRow(), 78   SAY VENC - CRE                            PICT '###,###,###.##'
   ENDIF
   IF Round( DEB, 2 ) # Round( DESC, 2 )
      @ PRow() + 1, 6 SAY ACENTO( "Erro na Totaliza‡„o D‚bito" )
      @ PRow(), 50   SAY DESC                                 PICT '###,###,###.##'
      @ PRow(), 64   SAY DEB                                  PICT '###,###,###.##'
      @ PRow(), 78   SAY DESC - DEB                           PICT '###,###,###.##'
   ENDIF
   @ PRow() + 1, 6 SAY ACENTO( '.Quantidade de Funcion rios do mˆs ..===> ' )
   @ PRow(), 64   SAY QTFUN                                                PICT '###,###'
   @ PRow() + 1, 0 SAY REPL( '-', 132 )
   IMPFOL()
   VIDEO()
   dbCloseAll()
   IMPEND()
   RETU

// : FIM: FOCA2.PRG

// + EOF: foca2.prg
// +
