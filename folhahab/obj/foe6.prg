// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foe6.prg
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
// :       FOE6.PRG: Apura‡„o geral da folha
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:58
// :
// :*****************************************************************************
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foe6()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foe6

   PARA CC

   CABEX( 'Apura‡„o geral da folha ' )

   IF !ARQUSAR( CC, 1, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "conta" )
   ordSetFocus( "temp" )

   cSELE1 := Alias()

   IF !ARQCTA( CC )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE2 := Alias()


   dbSelectAr( cSELE1 )
   FILTRO := ''
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO
   hb_DispBox( 3, 0, 24, 79, B_DOUBLE + " " )
   @  3, 6 SAY "-" + REPL( '-', 37 ) + "-" + REPL( '-', 13 ) + "-"
   @  4, 2 SAY "CTA Ý DESCRIMINACAO DA CONTA" + SPAC( 14 ) + "Ý HORAS" + SPAC( 7 ) + "Ý   TOTAL"
   @  5, 0 SAY 'Ç' + REPL( '-', 5 ) + "+" + REPL( '-', 37 ) + "+" + REPL( '-', 13 ) + "+" + REPL( '-', 20 ) + '¶'
   FOR X := 6 TO 21
      @ X, 6 SAY "Ý" + SPAC( 37 ) + "Ý" + SPAC( 13 ) + "Ý"
   NEXT X
   @ 22, 00 SAY 'Ç' + REPL( '-', 5 ) + "-" + REPL( '-', 33 ) + "-" + REPL( '-', 3 ) + "-" + REPL( '-', 13 ) + "-" + REPL( '-', 20 ) + '¶'
   @ 23, 02 SAY "Continua (S/N) " + REPL( '-', 3 ) + Chr( 16 ) + SPAC( 19 ) + "Ý Liquido " + REPL( '-', 3 ) + Chr( 16 )
   @ 24, 40 SAY "-"

   VENC  := DESC := LIQ := 0
   CTLIN := 6
   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      IF CTLIN > 21
         LIQ := VENC - DESC
         @ 23, 65 SAY LIQ PICTURE "###,###,###.##"
         Inkey( 0 )
         IF LastKey() = 27
            dbCloseAll()
            RETU
         ENDIF
         @  6, 0 CLEAR TO 21, 79
         FOR X := 6 TO 21
            @ X, 00 SAY "Ý     Ý" + SPAC( 37 ) + "Ý" + SPAC( 13 ) + "Ý                    Ý"
         NEXT
         CTLIN := 6
      ENDIF
      CTA := CONTA
      HOR := VAL := 0
      IMP := .T.
      IF CC # 4 .AND. CC # 6 .AND. CC # 8  // 13o. e VT RPA
         IF CTA > 120 .AND. CTA < 150
            IMP := .F.
         ENDIF
         IF CTA = 910 .OR. CTA = 911 .OR. CTA = 505 .OR. CTA = 506
            IMP := .F.
         ENDIF
      ENDIF
      IF IMP
         dbSelectAr( cSELE1 )
         WHILE CTA = CONTA .AND. !Eof()
            HOR := HOR + HORAS
            VAL := VAL + VALOR
            dbSkip()
         ENDDO
         DO CASE
         CASE CTA = 399 .AND. CC # 6
            VENC := VAL
         CASE CTA = 999 .AND. CC # 6
            DESC := VAL
         ENDCASE
         @ CTLIN, 02 SAY CTA PICTURE "###"
         dbSelectAr( cSELE2 )
         dbGoTop()
         dbSeek( CTA )
         @ CTLIN, 08 SAY IF( Found(), DESCR, 'Conta nao Cadastrada' )
         IF HOR # 0
            @ CTLIN, 46 SAY HOR PICT '###,###.##'
         ENDIF
         @ CTLIN, 65 SAY VAL PICT '###,###,###.##'
         CTLIN++
      ELSE
         dbSelectAr( cSELE1 )
         WHILE CONTA = CTA .AND. !Eof()
            dbSkip()
         ENDDO
      ENDIF
      dbSelectAr( cSELE1 )
   ENDDO
   LIQ := VENC - DESC
   @ 23, 65 SAY LIQ PICTURE "###,###,###.##"
   Inkey( 0 )
   dbCloseAll()
   RETU
// : FIM: FOE6.PRG

// + EOF: foe6.prg
// +
