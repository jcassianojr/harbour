// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foe23.prg
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
// :     FOE23.PRG : RELATORIO FOLHA DE PAGAMENTO P/ FUNCIONARIO
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 21/07/98
// :
// :*****************************************************************************

#include "BOX.CH"
#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foe23()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foe23

   PARA CC

   IF CC = 9 .OR. CC = 10
      MDT( 'Use a opcao Folha de Pagamento' )
      RETU
   ENDIF

   IF !ARQUSAR( CC, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE1 := Alias()

   IF !ARQPES( CC, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   FILTRO := ''
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO
   cSELE2 := Alias()

   IF !ARQCTA( CC )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE3 := Alias()

   hb_DispBox( 1, 0, 24, 79, B_DOUBLE + " " )
   @  2, 09 SAY "-" + SPAC( 41 ) + "SALARIO " + REPL( '-', 3 ) + Chr( 16 )
   @  3, 00 SAY 'Ç' + REPL( '-', 6 ) + "-" + REPL( '-', 32 ) + "-" + REPL( '-', 8 ) + "-" + REPL( '-', 14 ) + "-" + REPL( '-', 14 ) + '¶'
   @  4, 02 SAY "CTA  Ý Descricao" + SPAC( 22 ) + "Ý HORAS  Ý VENCIMENTOS  Ý  DESCONTOS"
   @  5, 00 SAY 'Ç' + REPL( '-', 6 ) + "+" + REPL( '-', 32 ) + "+" + REPL( '-', 8 ) + "+" + REPL( '-', 14 ) + "+" + REPL( '-', 14 ) + '¶'
   FOR X := 06 TO 21
      @ X, 07 SAY "Ý" + SPAC( 32 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 14 ) + "Ý"
   NEXT
   @ 22, 00 SAY 'Ç' + REPL( '-', 6 ) + "-" + REPL( '-', 32 ) + "+" + REPL( '-', 8 ) + "-" + REPL( '-', 14 ) + "-" + REPL( '-', 14 ) + '¶'
   @ 23, 01 SAY Chr( 17 ) + "Retorna            " + SPAC( 19 ) + "Ý LIQUIDO " + REPL( '-', 3 ) + Chr( 16 )
   @ 24, 40 SAY "-"

   FL    := 0
   TLIQ  := VENC := DESC := TSALDO := 0.00
   CTLIN := 6
   nKEY  := 255
   NOBREAK()

   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof() .AND. !Bof()
      NR1 := NUMERO
      dbSelectAr( cSELE1 )
      dbGoTop()
      dbSeek( NR1 * 10000 )
      IF NR1 # NUMERO
         dbSelectAr( cSELE2 )
         IF nKEY = K_LEFT
            dbSkip( - 1 )
         ELSE
            dbSkip()
         ENDIF
         LOOP
      ENDIF
      dbSelectAr( cSELE2 )
      SALM := SALH := VAR1 := 0
      SALHM()
      @ 02, 02 SAY numero PICTURE "######"
      @ 02, 11 SAY NOME
      @ 02, 65 SAY VAR1   PICTURE "###,###,###.##"
      dbSelectAr( cSELE1 )
      WHILE NR1 = NUMERO .AND. !Eof()
         IF CTLIN >= 22
            nKEY := HOTINKEY( 0 )
            IF nKEY = K_ESC
               dbCloseAll()
               RETU
            ENDIF
            CTLIN := 6
            @ 06, 00 CLEA TO 21, 79
            FOR X := 6 TO 21
               @ X, 00 SAY "Ý      Ý" + SPAC( 32 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 14 ) + "Ý              Ý"
            NEXT
         ENDIF
         CTA := CONTA
         IMP := .T.
         IF CC # 4 .AND. CC # 8 .AND. CC # 6
            IF CTA > 120 .AND. CTA < 150
               IMP := .F.
            ENDIF
            IF CTA = 910 .OR. CTA = 911 .OR. CTA = 505 .OR. CTA = 506
               IMP := .F.
            ENDIF
         ENDIF
         IF IMP
            IF CTA < 400 .OR. CTA > 501 .OR. CC = 6
               @ CTLIN, 2 SAY CTA PICT '###'
               dbSelectAr( cSELE3 )
               dbGoTop()
               IF dbSeek( CTA )
                  @ CTLIN, 9 SAY SubStr( DESCR, 1, 30 )
                  TIP := TIPO
               ENDIF
               dbSelectAr( cSELE1 )
               IF HORAS # 0
                  @ CTLIN, 42 SAY HORAS PICT '###.##'
               ENDIF
               COL := 50
               DO CASE
               CASE CTA > 40 .AND. CTA < 50 .AND. CC # 6
                  COL := 65
               CASE CTA > 500 .AND. CC # 6
                  COL := 65
               ENDCASE
               @ CTLIN, COL SAY VALOR PICT '###,###,###.##'
               CTLIN++
            ENDIF
         ENDIF
         DO CASE
         CASE CONTA = 399 .AND. CC # 6
            VENC := VALOR
         CASE CONTA = 999 .AND. CC # 6
            DESC := VALOR
         ENDCASE
         dbSkip()
      ENDDO
      SALDO := VENC - DESC
      IF CC # 6
         @ 23, 65 SAY SALDO PICTURE "###,###,###.##"
      ENDIF
      nKEY := HOTINKEY( 0 )
      IF nKEY = K_ESC
         dbCloseAll()
         RETU
      ENDIF
      @ 06, 00 CLEA TO 21, 79
      FOR X := 6 TO 21
         @ X, 00 SAY "Ý      Ý" + SPAC( 32 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 14 ) + "Ý              Ý"
      NEXT
      VENC  := DESC := 0.00
      CTLIN := 6
      dbSelectAr( cSELE2 )
      IF nKEY = K_LEFT
         dbSkip( - 1 )
      ELSE
         dbSkip()
      ENDIF
   ENDDO
   dbCloseAll()
   RETU

// : FIM: FOE23.PRG

// + EOF: foe23.prg
// +
