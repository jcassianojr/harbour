// +--------------------------------------------------------------------
// +
// +    Programa  : folis_c8.prg  DIRF
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

#include "BOX.CH"

FUNCTION folis_c8()

   IF !MDL( '  D.  I.   R.   F.    ', 0 )
      RETU
   ENDIF
   IF !MDG( 'Vocˆ j  acumulou' )
      FOLIS_A5()
      RETU
   ENDIF

   UFIR := IF( MDG( 'Deseja em ufir' ), .T., .F. )
   CENT := IF( MDG( 'Deseja cortar os Centavos' ), .T., .F. )

   FL := 0
   MDS( 'Carregando dados da Empresa' )
   IF !NETUSE( "FIRMA" )
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( NREMP )
      ENDER := ENDERECO
      CIDAD := CIDADE
      ESTAD := ESTADO
      NRCGC := CGC
      MSG2A := COGNOME
   ENDIF
   dbCloseAll()

   DECLARE MESES[ 13 ]
   FOR X := 1 TO 12
      MESES[ X ] = MMES( X )
   NEXT X
   MESES[ 13 ] = '13o. Salario'


   RESP     := SPAC( 30 )
   RESPCPF  := SPAC( 18 )
   RESPFONE := SPAC( 10 )
   RESPLOCA := SPAC( 20 )
   RESPDAT  := DXDIA
   @ 08, 00 CLEA
   SetColor( "+N/GR" )
   hb_DispBox( 8, 0, 23, 78, B_DOUBLE )
   @ 11, 04 SAY "Respons vel :"
   @ 13, 04 SAY "C.P.F." + SPAC( 6 ) + ":"
   @ 15, 04 SAY "Telefone    :"
   @ 17, 04 SAY "Local" + SPAC( 7 ) + ":"
   @ 19, 04 SAY "Emiss„o     :"
   SetColor( "+N/W" )
   @ 08, 00 SAY " - "
   SetColor( "+W/R" )
   @ 08, 03 SAY SPAC( 17 ) + "Digite Dados Complementares Para a Dirf" + SPAC( 20 )
   hb_Scroll( 9, 79, 24, 79 )
   @ 24, 01 SAY SPAC( 78 )
   SetColor( "+N/GR" )
   @ 11, 19 GET RESP
   @ 13, 19 GET RESPCPF
   @ 15, 19 GET RESPFONE
   @ 17, 19 GET RESPLOCA
   @ 19, 19 GET RESPDAT
   READCUR()
   SetColor( "W/N,N/W" )


   nACU := IRRESC()
   IF !ARQIRR( nACU, 1, 3 )  // Shared Arede PES
      RETU .F.
   ENDIF
   cSELE1 := Alias()


   IF !ARQIRR( nACU, 1, 1 )  // SHARED Arede ajudir
      dbCloseAll()
      RETU .F.
   ENDIF
   FILTRO := ''
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO
   cSELE2 := Alias()


   TTVAL1  := TTVAL2 := TTVAL3 := 0
   QTDEFUN := 0
   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      mCPF := CPF
      QTDEFUN++
      WHILE mCPF = CPF .AND. !Eof()
         TTVAL1 := TTVAL1 + IF( UFIR, VALUF1, VALOR1 )
         TTVAL2 := TTVAL2 + IF( UFIR, VALUF2, VALOR2 )
         TTVAL3 := TTVAL3 + IF( UFIR, VALUF3, VALOR3 )
         TTVAL1 := IF( CENT, Int( TTVAL1 ), TTVAL1 )
         TTVAL2 := IF( CENT, Int( TTVAL2 ), TTVAL2 )
         TTVAL3 := IF( CENT, Int( TTVAL3 ), TTVAL3 )
         dbSkip()
      ENDDO
   ENDDO
   IMPRESSORA()
   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      FL++
      @ PRow(), 20    SAY ' DIRF - Declaracao de Imposto Retido na Fonte'
      @ PRow(), 20    SAY ' DIRF - Declaracao de Imposto Retido na Fonte'
      @ PRow() + 1, 60 SAY 'DATA =>'
      @ PRow(), 68    SAY DXDIA
      @ PRow() + 1, 60 SAY '  fl =>'
      @ PRow(), 68    SAY FL                                              PICT '###'
      @ PRow() + 1, 1  SAY IMPCHR( cIMPTIT )
      @ PRow(), 2    SAY MSG2A
      @ PRow() + 1, 1  SAY REPL( '-', 78 )
      @ PRow() + 1, 0  SAY "Qtde Func.->"
      @ PRow(), 13    SAY QTDEFUN                                         PICT '##'
      @ PRow(), 20    SAY "12=>"
      @ PRow(), 23    SAY TTVAL1                                          PICT '###,###,###.##'
      @ PRow(), 40    SAY "13=>"
      @ PRow(), 43    SAY TTVAL2                                          PICT '###,###,###.##'
      @ PRow(), 60    SAY "14=>"
      @ PRow(), 63    SAY TTVAL3                                          PICT '###,###,###.##'
      @ PRow(), 79    SAY '|'
      dbSelectAr( cSELE2 )
      CONTAR := 0
      WHILE !Eof()
         CONTAR++
         IF CONTAR = 2
            CONTAR := 0
            IMPFOL()
         ENDIF
         TVAL1 := TVAL2 := TVAL3 := 0
         CTR   := NUMERO
         mCPF  := CPF
         dbSelectAr( cSELE1 )
         dbGoTop()
         IF dbSeek( CTR )
            @ PRow() + 1, 0 SAY '|'
            @ PRow(), 1   SAY 'nro. do cpf:'
            @ PRow(), 14   SAY CPF
            @ PRow(), 14   SAY CPF
            @ PRow(), 30   SAY 'nome =>'
            @ PRow(), 36   SAY NOME
            @ PRow(), 36   SAY NOME
            @ PRow(), 79   SAY '|'
            @ PRow() + 1, 0 SAY REPL( '=', 80 )
            @ PRow() + 1, 0 SAY '|'
            @ PRow(), 20   SAY 'Rendimento Bruto'
            @ PRow(), 45   SAY 'Deducoes'
            @ PRow(), 56   SAY 'Imposto Retido  Fonte'
            dbSelectAr( cSELE2 )
            FOR X := 1 TO 13
               @ PRow() + 1, 0 SAY '|'
               @ PRow(), 1   SAY MESES[ X ]
               IF CPF = mCPF
                  IF MES = X
                     IF UFIR
                        @ PRow(), 20 SAY IF( CENT, Int( VALUF1 ), VALUF1 ) PICT '###,###,###.##'
                        @ PRow(), 40 SAY IF( CENT, Int( VALUF2 ), VALUF2 ) PICT '###,###,###.##'
                        @ PRow(), 60 SAY IF( CENT, Int( VALUF3 ), VALUF3 ) PICT '###,###,###.##'
                     ELSE
                        @ PRow(), 20 SAY IF( CENT, Int( VALOR1 ), VALOR1 ) PICT '###,###,###.##'
                        @ PRow(), 40 SAY IF( CENT, Int( VALOR2 ), VALOR2 ) PICT '###,###,###.##'
                        @ PRow(), 60 SAY IF( CENT, Int( VALOR3 ), VALOR3 ) PICT '###,###,###.##'
                     ENDIF
                     TVAL1 := TVAL1 + IF( UFIR, VALUF1, VALOR1 )
                     TVAL2 := TVAL2 + IF( UFIR, VALUF2, VALOR2 )
                     TVAL3 := TVAL3 + IF( UFIR, VALUF3, VALOR3 )
                     TVAL1 := IF( CENT, Int( TVAL1 ), TVAL1 )
                     TVAL2 := IF( CENT, Int( TVAL2 ), TVAL2 )
                     TVAL3 := IF( CENT, Int( TVAL3 ), TVAL3 )
                     dbSkip()
                  ENDIF
               ENDIF
               @ PRow(), 79 SAY '|'
            NEXT
            @ PRow() + 1, 0 SAY REPL( '=', 80 )
            @ PRow() + 1, 0 SAY '|'
            @ PRow(), 1   SAY 'TOTAL ........'
            @ PRow(), 20   SAY TVAL1            PICT '###,###,###.##'
            @ PRow(), 40   SAY TVAL2            PICT '###,###,###.##'
            @ PRow(), 60   SAY TVAL3            PICT '###,###,###.##'
            @ PRow(), 79   SAY '|'
            @ PRow() + 1, 0 SAY REPL( '=', 80 )
            IF CONTAR = 1
               @ PRow() + 1, 1 SAY "Responsavel pelo Preenchimento"
               @ PRow() + 1, 0 SAY REPL( '-', 80 )
               @ PRow() + 1, 0 SAY '|'
               @ PRow(), 5   SAY RESP + ' ' + 'cpf:' + respcpf + ' ' + respfone
               @ PRow(), 79   SAY '|'
               @ PRow() + 1, 0 SAY '|'
               @ PRow(), 5   SAY RESPLOCA
               @ PRow(), 30   SAY 'data:'
               @ PRow(), 38   SAY respdat
               @ PRow(), 79   SAY '|'
               @ PRow() + 1, 0 SAY REPL( '=', 80 )
            ENDIF
            IF !Eof()
               IF CPF = mCPF
                  dbSkip()
               ENDIF
               IF CONTAR > 3
                  EXIT
               ENDIF
            ENDIF
         ENDIF
      ENDDO
   ENDDO
   IMPFOL()
   VIDEO()
   dbCloseAll()
   IMPEND()

   RETURN

// : FIM: FOLIS_C8.PRG

// + EOF: folis_c8.prg
// +
