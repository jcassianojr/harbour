// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bm3.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => J:\ITAESBRA\M_BM3.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// Modo de Trabalho no Video

// #INCLUDE "COMANDO.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bm3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bm3

   PARA cARQPRI, cARQACU, cCARREF, cCABREF

// Modo de Trabalho no Video
   MDI( " н Imprimir RelatЂrio da " + cCABREF )

   cVAR     := "ATUAL"
   lACUMULA := .F.
   ARQWORK  := cARQPRI
   MES      := 0
   ANO      := 0
   cCABAUX  := Space( 40 )
   PERACU()



   FILTRO := "APURA#'N'"
   FILTRO := RFILORD( cARQPRI, .F., FILTRO )
   CTLIN  := NRCOPIA := 1
   VEZES  := 0

   IF !CHECKIMP( 0 )
      RETURN .F.
   ENDIF
   cEMP   := IMP( "ZEMP" )
   cRESET := IMP( "RESET" )

   @ 24, 00
   @ 24, 00 SAY "NЃmero de copias:" GET NRCOPIA PICT '99'
   READCUR()
   IF !USEREDE( ARQWORK, 1, 99 )
      RETU
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   hb_DispBox( 6, 10, 08, 69, B_DOUBLE )
   @ 07, 20 SAY 'Aguarde Acumulando os Valores Para Imprimir'
   @ 09, 20 SAY 'Nota Fiscal : '
   @ 10, 20 SAY 'Emitida em  : '
   @ 11, 20 SAY 'Cliente nro.: '
   @ 12, 20 SAY 'Cognome     : '
// PREPARANDO ACUMULADORES
   aACUM := Array( 2, 10 )
   FOR X := 1 TO 10
      IF X = 1
         aACUM[ 1, X ] := 0
         Y             := 0
      ELSE
         Y             += 10
         aACUM[ 1, X ] := Y
      ENDIF
      aACUM[ 2, X ] := 0.00
   NEXT X
   WHILE !Eof()
      @ 09, 35 SAY NUMERO
      @ 10, 35 SAY DATA
      @ 11, 35 SAY FORNECEDO
      @ 12, 35 SAY COGNOME
      FOR Y := 1 TO 10   // VERIFICAR AS DATAS DE VENCIMENTO DO MM01
         DIAS := ( &( "DAT" + StrZero( Y, 2 ) ) - DATA )  // QTOS DIAS DA EMISSAO
         VAL  := "VAL" + StrZero( Y, 2 )  // VALOR NO VENCIMENTO
         FOR X := 1 TO 10
            IF DIAS <= aACUM[ 1, X ]
               aACUM[ 2, X ] := aACUM[ 2, X ] + &VAL
               EXIT
            ENDIF
            IF X = 10
               aACUM[ 2, 10 ] := aACUM[ 2, X ] + &VAL
            ENDIF
         NEXT
      NEXT
      dbSkip()
   ENDDO
   IMPRESSORA()
   WHILE VEZES < NRCOPIA
      VEZES++
      CTLIN   := 80
      ZPAGINA := 0
      IF !Eof()
         IMPRESSORA()
      ENDIF
      TOT1 := 0.00
      ZPAGINA++
      @  0, 0  SAY cRESET + impchr( cIMPEXP )
      @  0, 0  SAY cEMP
      @  1, 01 SAY 'M_BM3'
      @  1, 59 SAY ACENTO( '    Folha: ' ) + Str( ZPAGINA, 2 )
      @  2, 01 SAY 'Horario: ' + Time()
      @  2, 59 SAY 'Emitida em: ' + DToC( ZDATA )
      @  3, 00 SAY impchr( cIMPTIT ) + cCABREF
      @  4, 0  SAY '*' + repl( '-', 78 ) + '*'
      CTLIN := 5
      @ CTLIN, 17 SAY 'Dias'
      @ CTLIN, 36 SAY 'Valor Faturado'
      @ 06, 0     SAY '*' + repl( '-', 78 ) + '*'
      CTLIN := 07
      FOR X := 1 TO 10
         IF X = 1
            @ CTLIN, 10 SAY 'A Vista '
         ELSE
            IF X = 10
               @ CTLIN, 08 SAY 'Acima de: '
               @ CTLIN, 17 SAY aACUM[ 1, X - 1 ] PICT '99'
               @ CTLIN, 20 SAY 'Dias'
            ELSE
               @ CTLIN, 10 SAY 'Ate -> '
               @ CTLIN, 17 SAY aACUM[ 1, X ] PICT '99'
               @ CTLIN, 20 SAY 'Dias'
            ENDIF
         ENDIF
         @ CTLIN, 36 SAY aACUM[ 2, X ] PICT '999,999,999.99'
         TOT1 += aACUM[ 2, X ]
         CTLIN++
      NEXT
      @ CTLIN, 0 SAY '*' + repl( '-', 78 ) + '*'
      CTLIN++
      @ CTLIN, 36 SAY TOT1 PICT '999,999,999.99'
      CTLIN++
      IF ZPAGINA > 0
         @ CTLIN, 0 SAY '*' + repl( '-', 78 )
         CTLIN++
      ENDIF
   ENDDO
   dbCloseArea()
   IMPFOL()
   VIDEO()
   IMPEND()

// + EOF: M_BM3.PRG

// + EOF: m_bm3.prg
// +
