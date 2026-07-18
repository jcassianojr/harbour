// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : focd.prg
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
// :       FOCD.PRG: Pagamento Executado Completo
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     11:39
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function focd()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION focd

   PARA CC, CW

   IF CC = 9 .OR. CC = 10
      MDT( 'Use a op‡„o Rela‡„o' )
      RETU
   ENDIF
   IF !MDL( 'Pagamento Executado Completo', 0 )
      RETU
   ENDIF

   MASS := IF( NRSEN # "DiReT", 'PAGAMENTO EXECUTADO COMPLETO ', ACENTO( 'PAGAMENTO  DE  PR•-LABORE ' ) )

   ATUALIZA := 1.000000
   LIMITE   := 2
   nVALPOS  := 0
   @ 22, 00 CLEA
   @ 22, 00 SAY 'Qual o Fator de Atualiza‡„o'
   @ 23, 00 SAY 'Quantos Funcion rios por folha '
   @ 22, 40 GET ATUALIZA                          PICT "99999999999.999999"
   @ 23, 40 GET LIMITE                            PICT '#'
   IF CC = 2 .OR. CC = 3 .OR. CC = 5
      @ 24, 00 SAY "Posicao (0) Normal  (1) 1§ Mes  (2) 2§ Mes"
      @ 24, 60 GET nVALPOS
   ENDIF
   READCUR()

   IF !ARQUSAR( CC, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE1 := Alias()

   IF !ARQPES( CC, 1, 0 )
      dbCloseAll()
      RETU .F.
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


   cSELE2 := Alias()

   IF !ARQCTA( CC, 1, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE3 := Alias()

   IF !NETUSE( "FUNCAO" )  // AREDE("FUNCAO","FUNCAO",1)
      dbCloseAll()
      RETU
   ENDIF
   IF CW > 1
      IF !NETUSE( "DEPTO" )  // /AREDE("DEPTO","DEPTO",1)
         dbCloseAll()
         RETU
      ENDIF
      DO CASE
      CASE CW = 2
         FILTRA := 'SETOR=0.AND.SECAO=0'
         COMPAR := 'DEP=DEPTO'
      CASE CW = 3
         FILTRA := 'SETOR#0.AND.SECAO=0'
         COMPAR := 'DEP=DEPTO.AND.SET=SETOR'
      CASE CW = 4
         FILTRA := 'SETOR#0.AND.SECAO#0'
         COMPAR := 'DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
      ENDCASE
      SET FILTER TO &FILTRA
   ENDIF


   CRE := DEB := FL := VENC := DESC := CONTAR := 0
   IMPRESSORA()
   IF CW = 1
      NOMSETOR := ""
      FOCDX( ".T." )
   ELSE
      dbSelectAr( "DEPTO" )
      dbGoTop()
      WHILE !Eof()
         NOMSETOR := NOMEC
         DEP      := DEPTO
         SET      := SETOR
         SEC      := SECAO
         FOCDX( COMPAR )
         dbSelectAr( "DEPTO" )
         dbSkip()
      ENDDO
   ENDIF
   dbCloseAll()
   IMPFOL()
   VIDEO()
   IMPEND()
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: FOCDX()
// !
// !    Chamado por: FOCD.PRG
// !
// !          Chama: SALHM()            (fun‡„o    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOCDX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOCDX

   PARA COMPARE

   CTLIN := 80
   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         NR1   := NUMERO
         BUSCA := .T.
         LISTE := .F.
         IF CONTAR = LIMITE
            CTLIN  := 59
            CONTAR := 0
         ENDIF
         PRIMA := .F.
         Y     := 1
         dbSelectAr( cSELE1 )
         WHILE .T.
            CTX := ( NR1 * 10000 ) + Y
            IF CC = 7 .OR. CC = 8
               CTX := ( NR1 * 10000 ) + mSEMANA * 1000 + Y
            ENDIF
            dbGoTop()
            IF dbSeek( CTX )
               PRIMA := .T.
               EXIT
            ENDIF
            Y++
            IF Y > 999
               EXIT
            ENDIF
         ENDDO
         dbSelectAr( cSELE2 )
         IF PRIMA .OR. SITUACAO # ' '
            IF CTLIN > 48
               FL++
               @  1, 0   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
               @  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
               @  3, 05  SAY IMPCHR( cIMPTIT ) + MASS + MMES + '/' + StrZero( ANO, 4 ) + " " + NOMSETOR
               @  5, 0   SAY ACENTO( 'Exibicao por: ' ) + inx
               @  5, 40  SAY IF( ARQ = 4, ACENTO( '13o. Sal rio' ), '' )
               @  5, 100 SAY Time()
               @  5, 110 SAY DXDIA
               @  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
               @  6, 0   SAY REPL( '-', 132 )
               CTLIN := 7
            ENDIF
            CONTAR++
            @ CTLIN, 2  SAY '-DEPTO-'
            @ CTLIN, 11 SAY '-SETOR-'
            @ CTLIN, 20 SAY ACENTO( '-SECAO-' )
            @ CTLIN, 29 SAY ACENTO( '-NUMERO-' )
            @ CTLIN, 39 SAY ACENTO( '-NOME DO FUNCIONARIO----------' )
            @ CTLIN, 72 SAY ACENTO( '- Sal rio Base -' )
            // * SALARIO
            SALH := SALM := VAR1 := 0
            SALHM()
            @ CTLIN, 90 SAY ACENTO( '-Codigo e Nome Interno da Funcao--------' )
            CTLIN++
            @ CTLIN, 1  SAY '|  ' + Str( DEPTO, 4 ) + ' |'
            @ CTLIN, 10 SAY '|  ' + Str( SETOR, 3 ) + '  |'
            @ CTLIN, 19 SAY '|  ' + Str( SECAO, 3 ) + '  |'
            @ CTLIN, 28 SAY '|  ' + Str( NUMERO, 5 ) + ' |'
            @ CTLIN, 38 SAY '|' + NOME + '|'
            @ CTLIN, 71 SAY '|'
            @ CTLIN, 72 SAY VAR1                     PICTURE '###,###,###.##'
            @ CTLIN, 88 SAY '|'
            @ CTLIN, 89 SAY '|' + Str( FUNCAO, 4 ) + '-'
            @ CTLIN, 4  SAY Str( DEPTO, 4 )
            @ CTLIN, 13 SAY Str( SETOR, 3 )
            @ CTLIN, 22 SAY Str( SECAO, 3 )
            @ CTLIN, 31 SAY Str( NUMERO, 5 )
            @ CTLIN, 39 SAY NOME
            @ CTLIN, 72 SAY VAR1                     PICTURE '###,###,###.##'
            FUNCA := FUNCAO
            dbSelectAr( "FUNCAO" )
            dbGoTop()
            dbSeek( FUNCA )
            @ CTLIN, 95  SAY IF( Found(), SubStr( NOME, 1, 35 ), ACENTO( 'Funcao nao cadastrada' ) )
            @ CTLIN, 131 SAY '|'
            CTLIN++
            @ CTLIN, 2  SAY '-------'
            @ CTLIN, 11 SAY '-------'
            @ CTLIN, 20 SAY '-------'
            @ CTLIN, 29 SAY '--------'
            @ CTLIN, 39 SAY '------------------------------'
            @ CTLIN, 72 SAY '----------------'
            @ CTLIN, 90 SAY '----------------------------------------'
            CTLIN++
            dbSelectAr( cSELE2 )
            IF CC # 8
               IF SITUACAO # ' '
                  @ CTLIN, 10 SAY CHECKTAB( "SITU" + SITUACAO + "    ",,, "Situacao nao Cadastrado", 2 )
                  CTLIN++
               ENDIF
            ENDIF

            IF PRIMA
               @ CTLIN, 1  SAY 'CONTA'
               @ CTLIN, 7  SAY ACENTO( 'DESCRIMINA€ŽO DA CONTA' )
               @ CTLIN, 43 SAY 'HORAS'
               @ CTLIN, 49 SAY '  VENCIMENTOS'
               @ CTLIN, 64 SAY '    DESCONTOS'
               @ CTLIN, 79 SAY ACENTO( 'VALORES BSICOS DE CALCULO' )
               CTLIN++
               dbSelectAr( cSELE1 )
               WHILE NUMERO = NR1 .AND. !Eof()
                  WHILE CONTA > 400 .AND. CONTA < 502
                     dbSkip()
                  ENDDO
                  IF Eof() .OR. NUMERO # NR1
                     EXIT
                  ENDIF
                  CTA := CONTA
                  IMP := .T.
                  IF CC # 4 .AND. CC # 6
                     IF CTA > 120 .AND. CTA < 150
                        IMP := .F.
                     ENDIF
                     IF CTA = 910 .OR. CTA = 911 .OR. CTA = 505 .OR. CTA = 506
                        IMP := .F.
                     ENDIF
                  ENDIF
                  IF IMP
                     CTLIN++
                     @ CTLIN, 2 SAY CONTA PICT "###"
                     dbSelectAr( cSELE3 )
                     dbGoTop()
                     dbSeek( CTA )
                     @ CTLIN, 6 SAY IF( Found(), DESCR, ACENTO( "Conta n„o Cadastrada" ) )
                     dbSelectAr( cSELE1 )
                     IF HORAS # 0
                        @ CTLIN, 42 SAY HORAS
                     ENDIF
                     COL := 49
                     IF CC # 6
                        IF ( CTA > 40 .AND. CTA < 50 ) .OR. CTA > 501
                           COL := 64
                        ENDIF
                     ENDIF
                     @ CTLIN, COL SAY FOCD01() PICT '###,###,###.##'
                     // ** colocar os valores basicos a direita
                     REG := RecNo()
                     IF BUSCA .AND. CC # 6
                        FOR Y := 400 TO 501
                           CTX := ( NR1 * 10000 ) + Y
                           dbSelectAr( cSELE1 )
                           dbGoTop()
                           IF dbSeek( CTX )
                              LISTE   := .T.
                              BASEREC := RecNo()
                              Y       := 501
                           ENDIF
                        NEXT Y
                        BUSCA := .F.
                     ENDIF
                     IF LISTE .AND. CC # 6
                        dbGoto( BASEREC )
                        CTA := CONTA
                        @ CTLIN, 79 SAY CONTA PICT "###"
                        dbSelectAr( cSELE3 )
                        dbGoTop()
                        dbSeek( CTA )
                        @ CTLIN, 83 SAY IF( Found(), DESCR, ACENTO( "Conta n„o Cadastrada" ) )
                        dbSelectAr( cSELE1 )
                        @ CTLIN, 118 SAY FOCD01() PICT '###,###,###.##'
                        dbSkip()
                        IF CONTA > 501 .OR. NUMERO # NR1 .OR. Eof()
                           LISTE := .F.
                        ENDIF
                        BASEREC := RecNo()
                     ENDIF
                     dbGoto( REG )
                     IF CC # 6
                        DO CASE
                        CASE CONTA = 399
                           VENC := FOCD01()
                        CASE CONTA = 999
                           DESC := FOCD01()
                        CASE CONTA < 40
                           CRE += FOCD01()
                        CASE CONTA > 40 .AND. CONTA < 50
                           DEB += FOCD01()
                        CASE CONTA > 50 .AND. CONTA < 399
                           CRE += FOCD01()
                        CASE CONTA > 501
                           DEB += FOCD01()
                        ENDCASE
                     ELSE
                        VENC += FOCD01()
                        CRE  += FOCD01()
                     ENDIF
                  ENDIF
                  dbSelectAr( cSELE1 )
                  dbSkip()
               ENDDO
               IF LISTE .AND. CC # 6
                  // * EMBUTIR OS VALORES BASICOS QUE NAO COUBERAM
                  dbSelectAr( cSELE1 )
                  dbGoto( BASEREC )
                  WHILE CONTA < 502 .AND. !Eof() .AND. NUMERO = NR1
                     CTA := CONTA
                     CTLIN++
                     @ CTLIN, 79 SAY CONTA PICT "###"
                     dbSelectAr( cSELE3 )
                     dbGoTop()
                     dbSeek( CTA )
                     @ CTLIN, 83 SAY IF( Found(), DESCR, ACENTO( "Conta n„o Cadastrada" ) )
                     dbSelectAr( cSELE1 )
                     @ CTLIN, 119 SAY FOCD01() PICT '##,###,###.##'
                     dbSkip()
                  ENDDO
               ENDIF
               SALDO := VENC - DESC
               CTLIN++
               @ CTLIN, 6  SAY '...........................LIQUIDO ..===> '
               @ CTLIN, 50 SAY SALDO                                        PICT '###,###,###.##'
               IF Round( CRE, 2 ) # Round( VENC, 2 )
                  CTLIN++
                  @ CTLIN, 6  SAY ACENTO( "Erro na Totaliza‡„o Cr‚dito" )
                  @ CTLIN, 50 SAY VENC                                  PICT '###,###,###.##'
                  @ CTLIN, 64 SAY CRE                                   PICT '###,###,###.##'
                  @ CTLIN, 78 SAY VENC - CRE                            PICT '###,###,###.##'
               ENDIF
               IF Round( DEB, 2 ) # Round( DESC, 2 )
                  CTLIN++
                  @ CTLIN, 6  SAY ACENTO( "Erro na Totaliza‡„o D‚bito" )
                  @ CTLIN, 50 SAY DESC                                 PICT '###,###,###.##'
                  @ CTLIN, 64 SAY DEB                                  PICT '###,###,###.##'
                  @ CTLIN, 78 SAY DESC - DEB                           PICT '###,###,###.##'
               ENDIF
               CRE := DEB := VENC := DESC := 0.00
               CTLIN++
               @ CTLIN, 0 SAY REPL( '-', 132 )
               @ CTLIN, 0 SAY REPL( '-', 132 )
               CTLIN++
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO
   RETU ( .T. )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOCD01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOCD01

   LOCAL nVALOR := 0

   DO CASE
   CASE nVALPOS = 1
      nVALOR := VALORMES1
   CASE nVALPOS = 2
      nVALOR := VALORMES2
   OTHERWISE
      nVALOR := VALOR
   ENDCASE
   IF ATUALIZA # 1
      nVALOR := Round( nVALOR * ATUALIZA, 2 )
   ENDIF
   RETU nVALOR

// : FIM: FOCD.PRG

// + EOF: focd.prg
// +
