// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdif.prg
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

// +께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께
// +
// +    Source Module => J:\ITAESBRA\M_BDIF.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
// +
// +께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께

// #INCLUDE "COMANDO.CH"
MDI( "Resumo DIPAM" )


cTIPOCAN := "T"
@ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)? Canceladas"
@ 23, 45 GET cTIPOCAN                                     PICT "!" VALID cTIPOCAN $ "TCN"
IF !READCUR()
RETU .F.
ENDIF


aRETU        := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
ARQENT       := aRETU[ 5, 1 ]
ARQSAI       := aRETU[ 5, 2 ]
mCOMPETENCIA := aRETU[ 7 ]

aDIPI := Array( 33 )
AFill( aDIPI, 0 )
aCID  := {}
aCIN  := {}
aERRO := {}
ZFOL  := 1
lCID  := MDG( "Resumo Cidades" )
lCOD  := MDG( "Resumo Codigos" )
lERR  := MDG( "Resumo Erros" )

IF MDG( "Entradas" )
m_bdif01( ARQENT )
ENDIF
IF MDG( "Saidas" )
m_bdif01( ARQSAI )
ENDIF

// Totais
nSOMASAI := 0
FOR X := 11 TO 17
nSOMASAI += aDIPI[ X ]
NEXT X
nSOMAENT := 0
FOR X := 20 TO 28
nSOMAENT += aDIPI[ X ]
NEXT X

IF !CHECKIMP( 0 )
RETU .F.
ENDIF

IMPRESSORA()
IF lCOD
@  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
@  1, 83  SAY mCOMPETENCIA
@  1, 97  SAY ZDATA
@  1, 113 SAY Left( Time(), 5 )
@  1, 128 SAY Str( ZFOL, 4 )
@  2, 0   SAY repl( "-", 132 )
@  3, 0   SAY impchr( cIMPTIT ) + ACENTO( "DIPAM" )
@  4, 0   SAY repl( "=", 80 )
@  5, 0   SAY "SAIDAS"
@  6, 0   SAY "11 - Vendas Para o Estado              ->"
@  6, 40  SAY aDIPI[ 11 ]                                                                                                                           PICT "@E 999,999,999.99"
@  7, 0   SAY "12 - Vendas Para Outros Estados        ->"
@  7, 40  SAY aDIPI[ 12 ]                                                                                                                           PICT "@E 999,999,999.99"
@  8, 0   SAY "13 - Vendas Para o Exterior            ->"
@  8, 40  SAY aDIPI[ 13 ]                                                                                                                           PICT "@E 999,999,999.99"
@  9, 0   SAY "14 - Transferencias para o Estado      ->"
@  9, 40  SAY aDIPI[ 14 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 10, 0   SAY "15 - Transferencias para outros Estado ->"
@ 10, 40  SAY aDIPI[ 15 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 11, 0   SAY "16 - N꼘 Escrituradas                  ->"
@ 11, 40  SAY aDIPI[ 16 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 12, 0   SAY "17 - Outras                            ->"
@ 12, 40  SAY aDIPI[ 17 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 13, 0   SAY repl( "-", 40 )
@ 14, 0   SAY "19 - SOMA(11 A 17)                     ->"
@ 14, 40  SAY nSOMASAI                                                                                                                            PICT "@E 999,999,999.99"
@ 15, 0   SAY repl( "=", 80 )
@ 17, 0   SAY "ENTRADAS"
@ 18, 0   SAY "20 - Compras do estado                 ->"
@ 18, 40  SAY aDIPI[ 20 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 19, 0   SAY "21 - Compras de Outros Estados         ->"
@ 19, 40  SAY aDIPI[ 21 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 20, 0   SAY "22 - Compras a produtores do Estado    ->"
@ 20, 40  SAY aDIPI[ 22 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 21, 0   SAY "23 - Importacoes do exterior           ->"
@ 21, 40  SAY aDIPI[ 23 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 22, 0   SAY "24 - Transferencias do Estado          ->"
@ 22, 40  SAY aDIPI[ 24 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 23, 0   SAY "25 - Transferencias de outros Estados  ->"
@ 23, 40  SAY aDIPI[ 25 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 24, 0   SAY "26 - Nao escrituradas                  ->"
@ 24, 40  SAY aDIPI[ 26 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 25, 0   SAY "27 - Nao escrituradas Compra Produtor  ->"
@ 25, 40  SAY aDIPI[ 27 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 26, 0   SAY "28 - Outras                            ->"
@ 26, 40  SAY aDIPI[ 28 ]                                                                                                                           PICT "@E 999,999,999.99"
@ 27, 0   SAY repl( "-", 40 )
@ 28, 0   SAY "30 - SOMA(20 A 28)                     ->"
@ 28, 40  SAY nSOMAENT                                                                                                                            PICT "@E 999,999,999.99"
@ 29, 0   SAY "Valor Adicionado                       ->"
@ 29, 40  SAY nSOMASAI - nSOMAENT                                                                                                                 PICT "@E 999,999,999.99"
@ 30, 0   SAY repl( "=", 80 )
IMPFOL()
ENDIF

IF lCID
CTLIN := 1
FOR W := 1 TO Len( aCID )
@ CTLIN, 0  SAY Left( aCID[ W ], 2 )
@ CTLIN, 3  SAY SubStr( aCID[ W ], 3 )
@ CTLIN, 60 SAY aCIN[ W ]           PICT "@E 999,999,999.99"
CTLIN++
NEXT W
IMPFOL()
ENDIF

IF lERR
CTLIN := 1
FOR W := 1 TO Len( aERRO )
@ CTLIN, 0 SAY aERRO[ W ]
CTLIN++
NEXT W
IMPFOL()
ENDIF
VIDEO()
IMPEND()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_BDIF01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_BDIF01( cARQ )

   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   IF !USEMULT( { { "MB01", 1, 1 }, { "MA01", 1, 1 }, { cARQ, 1, 0 } } )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 40 SAY NUMERO
      nNUMERO := NUMERO
      nDIPAM  := Val( DIPAM )
      cCLIFOR := TIPOFOR
      nCLIFOR := FORNECEDO
      dbSelectAr( if( cCLIFOR = "C", "MA01", "MB01" ) )
      dbGoTop()
      IF dbSeek( nCLIFOR )
         cESTADO := ESTADO
         cCIDADE := CIDADE
         IF Empty( cESTADO ) .OR. Empty( cCIDADE )
            AAdd( aERRO, cCLIFOR + " " + Str( nCLIFOR ) + " " + Str( nNUMERO ) + " E Falta Estado ou Cidade" )
         ENDIF
      ELSE
         AAdd( aERRO, cCLIFOR + " " + Str( nCLIFOR ) + " " + Str( nNUMERO ) + " E Nao encotrado Cadastro" )
         cESTADO := "  "
         cCIDADE := ""
      ENDIF
      dbSelectAr( cARQ )
      IF !Empty( nDIPAM ) .AND. SOMACANCEL()
         // if nDIPAM > 10 .and. nDIPAM < 30 .and. nDIPAM # 19
         aDIPI[ nDIPAM ] += DBASEICM
         nPOS := AScan( aCID, Upper( TIRACE( cESTADO + cCIDADE ) ) )
         IF nPOS > 0
            aCIN[ nPOS ] += DBASEICM
         ELSE
            AAdd( aCID, Upper( TIRACE( cESTADO + cCIDADE ) ) )
            AAdd( aCIN, DBASEICM )
         ENDIF
         // else
         // aadd( aERRO, cCLIFOR + " " + str( nCLIFOR ) + " " + str( nNUMERO ) + " E Codigo Dipam" )
         // endif
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()



// + EOF: M_BDIF.PRG

// + EOF: m_bdif.prg
// +
