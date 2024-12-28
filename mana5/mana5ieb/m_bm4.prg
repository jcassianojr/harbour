// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bm4.prg
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

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_BM4.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_bm4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_bm4

   PARA cARQPRI, cARQACU, cCARREF, cCABREF

// Modo de Trabalho no Video
   MDI( " Э Imprimir Relatўrio da " + cCABREF )

   cVAR     := "ATUAL"
   lACUMULA := .F.
   ARQWORK  := cARQPRI
   MES      := 0
   ANO      := 0
   cCABAUX  := Space( 40 )
   PERACU()

   FILTRO := 'APURA#"N"'
   FILTRO := RFILORD( cARQPRI, .F., FILTRO )

   IF !CHECKIMP( 0 )
      RETURN .F.
   ENDIF


   MDS( "Aguarde Montando Relatorio" )
   IF !USEREDE( ARQWORK, 1, 99 )
      RETU .F.
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF

   IMPRESSORA()

   TOT1 := TOT2 := TOT3 := 0.00
   @ PRow(), 1    SAY "ITAESBRA INDUSTRA MECANICA LTDA."
   @ PRow() + 1, 23 SAY cCABREF
   @ PRow() + 1, 0  SAY repl( '-', 78 )
   @ PRow() + 1, 0  SAY 'N.Fis'
   @ PRow(), 06    SAY 'Emiss„o'
   @ PRow(), 16    SAY 'Cliente'
   @ PRow(), 34    SAY 'CFO'
   @ PRow(), 42    SAY 'Vencim.'
   @ PRow(), 51    SAY 'Total Mercador.'
   @ PRow(), 64    SAY 'Total Nota '
   @ PRow() + 1, 00 SAY repl( '-', 78 )

   dbGoTop()
   WHILE !Eof()
      @ PRow() + 1, 00 SAY NUMERO            PICT '99999'
      @ PRow(), 06    SAY DATA
      @ PRow(), 15    SAY FORNECEDO         PICT '99999'
      @ PRow(), 21    SAY COGNOME
      @ PRow(), 34    SAY AllTrim( OPERACAO )
      @ PRow(), 42    SAY DAT01
      @ PRow(), 51    SAY TOTMER            PICT '@E 99999,999.99'
      @ PRow(), 64    SAY TOTNF             PICT '@E 99999,999.99'
      TOT1 += TOTMER
      TOT3 += TOTNF
      dbSkip()
   ENDDO
   @ PRow() + 1, 1  SAY repl( '-', 78 )
   @ PRow() + 1, 10 SAY "Totais Gerais : "
   @ PRow(), 51    SAY TOT1               PICT '@E 99999,999.99'
   @ PRow(), 64    SAY TOT3               PICT '@E 99999,999.99'
   @ PRow() + 1, 1  SAY repl( '=', 78 )
   dbCloseArea()
   IMPFOL()
   VIDEO()
   IMPEND()


// + EOF: M_BM4.PRG

// + EOF: m_bm4.prg
// +
