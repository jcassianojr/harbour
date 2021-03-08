*+께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께
*+
*+    Source Module => J:\ITAESBRA\M_BDIF.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
*+
*+께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께

//#INCLUDE "COMANDO.CH"
MDI( "Resumo DIPAM" )


cTIPOCAN :="T"
@ 23,00 SAY "Grupo (T)odos (C)anceladas (N)? Canceladas"
@ 23,45 get cTIPOCAN PICT "!" VALID cTIPOCAN $ "TCN"
if !READCUR()
   retu .F.
endif


aRETU := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
ARQENT := aRETU[ 5, 1 ]
ARQSAI := aRETU[ 5, 2 ]
mCOMPETENCIA   := aRETU[ 7 ]

aDIPI := array( 33 )
afill( aDIPI, 0 )
aCID   := {}
aCIN   := {}
aERRO  := {}
ZFOL   := 1
lCID:=MDG("Resumo Cidades")
lCOD:=MDG("Resumo Codigos")
lERR:=MDG("Resumo Erros")

IF MDG("Entradas")
  m_bdif01(ARQENT)
ENDIF
IF MDG("Saidas")
   m_bdif01(ARQSAI)
ENDIF

//Totais
nSOMASAI := 0
for X := 11 to 17
   nSOMASAI += aDIPI[ X ]
next X
nSOMAENT := 0
for X := 20 to 28
   nSOMAENT += aDIPI[ X ]
next X

if !CHECKIMP( 0 )
   retu .F.
endif

IMPRESSORA()
if lCOD
   @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
   @  1, 83  say mCOMPETENCIA
   @  1, 97  say ZDATA
   @  1, 113 say left( time(), 5 )
   @  1, 128 say str( ZFOL, 4 )
   @  2,  0  say repl( "-", 132 )
   @  3,  0  say impchr(cIMPTIT) + ACENTO( "DIPAM" )
   @  4,  0  say repl( "=", 80 )
   @  5,  0  say "SAIDAS"
   @  6,  0  say "11 - Vendas Para o Estado              ->"
   @  6, 40  say aDIPI[ 11 ]                                                                                                                                             pict "@E 999,999,999.99"
   @  7,  0  say "12 - Vendas Para Outros Estados        ->"
   @  7, 40  say aDIPI[ 12 ]                                                                                                                                             pict "@E 999,999,999.99"
   @  8,  0  say "13 - Vendas Para o Exterior            ->"
   @  8, 40  say aDIPI[ 13 ]                                                                                                                                             pict "@E 999,999,999.99"
   @  9,  0  say "14 - Transferencias para o Estado      ->"
   @  9, 40  say aDIPI[ 14 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 10,  0  say "15 - Transferencias para outros Estado ->"
   @ 10, 40  say aDIPI[ 15 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 11,  0  say "16 - N꼘 Escrituradas                  ->"
   @ 11, 40  say aDIPI[ 16 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 12,  0  say "17 - Outras                            ->"
   @ 12, 40  say aDIPI[ 17 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 13,  0  say repl( "-", 40 )
   @ 14,  0  say "19 - SOMA(11 A 17)                     ->"
   @ 14, 40  say nSOMASAI                                                                                                                                                pict "@E 999,999,999.99"
   @ 15,  0  say repl( "=", 80 )
   @ 17,  0  say "ENTRADAS"
   @ 18,  0  say "20 - Compras do estado                 ->"
   @ 18, 40  say aDIPI[ 20 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 19,  0  say "21 - Compras de Outros Estados         ->"
   @ 19, 40  say aDIPI[ 21 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 20,  0  say "22 - Compras a produtores do Estado    ->"
   @ 20, 40  say aDIPI[ 22 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 21,  0  say "23 - Importacoes do exterior           ->"
   @ 21, 40  say aDIPI[ 23 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 22,  0  say "24 - Transferencias do Estado          ->"
   @ 22, 40  say aDIPI[ 24 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 23,  0  say "25 - Transferencias de outros Estados  ->"
   @ 23, 40  say aDIPI[ 25 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 24,  0  say "26 - Nao escrituradas                  ->"
   @ 24, 40  say aDIPI[ 26 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 25,  0  say "27 - Nao escrituradas Compra Produtor  ->"
   @ 25, 40  say aDIPI[ 27 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 26,  0  say "28 - Outras                            ->"
   @ 26, 40  say aDIPI[ 28 ]                                                                                                                                             pict "@E 999,999,999.99"
   @ 27,  0  say repl( "-", 40 )
   @ 28,  0  say "30 - SOMA(20 A 28)                     ->"
   @ 28, 40  say nSOMAENT                                                                                                                                                pict "@E 999,999,999.99"
   @ 29,  0  say "Valor Adicionado                       ->"
   @ 29, 40  say nSOMASAI - nSOMAENT                                                                                                                                     pict "@E 999,999,999.99"
   @ 30,  0  say repl( "=", 80 )
   IMPFOL()
endif

if lCID
   CTLIN := 1
   for W := 1 to len( aCID )
      @ CTLIN,  0 say left( aCID[ W ], 2 )
      @ CTLIN,  3 say substr( aCID[ W ], 3 )
      @ CTLIN, 60 say aCIN[ W ]              pict "@E 999,999,999.99"
      CTLIN ++
   next W
   IMPFOL()
endif

if lERR
   CTLIN := 1
   for W := 1 to len( aERRO )
      @ CTLIN,  0 say aERRO[ W ]
      CTLIN ++
   next W
   IMPFOL()
endif
VIDEO()
IMPEND()


FUNC M_BDIF01(cARQ)
   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   IF ! USEMULT({{"MB01", 1, 1 },{"MA01", 1, 1 },{cARQ, 1, 0 }})
      dbcloseall()
      retu .F.
   endif
   if !empty( FILTRO )
      set filter to &FILTRO
   endif
   dbgotop()
   while !eof()
      @ 24, 40 say NUMERO
      nNUMERO := NUMERO
      nDIPAM  := val( DIPAM )
      cCLIFOR := TIPOFOR
      nCLIFOR := FORNECEDO
      dbselectar( if( cCLIFOR = "C", "MA01", "MB01" ) )
      dbgotop()
      if dbseek( nCLIFOR )
         cESTADO := ESTADO
         cCIDADE := CIDADE
         if empty( cESTADO ) .or. empty( cCIDADE )
            aadd( aERRO, cCLIFOR + " " + str( nCLIFOR ) + " " + str( nNUMERO ) + " E Falta Estado ou Cidade" )
         endif
      else
         aadd( aERRO, cCLIFOR + " " + str( nCLIFOR ) + " " + str( nNUMERO ) + " E Nao encotrado Cadastro" )
         cESTADO := "  "
         cCIDADE := ""
      endif
      dbselectar( cARQ )
      if !empty( nDIPAM ).AND.SOMACANCEL()
//         if nDIPAM > 10 .and. nDIPAM < 30 .and. nDIPAM # 19
            aDIPI[ nDIPAM ] += DBASEICM
            nPOS := ascan( aCID, upper( TIRACE( cESTADO + cCIDADE ) ) )
            if nPOS > 0
               aCIN[ nPOS ] += DBASEICM
            else
               aadd( aCID, upper( TIRACE( cESTADO + cCIDADE ) ) )
               aadd( aCIN, DBASEICM )
            endif
//         else
//            aadd( aERRO, cCLIFOR + " " + str( nCLIFOR ) + " " + str( nNUMERO ) + " E Codigo Dipam" )
//         endif
      endif
      dbskip()
   enddo
   dbcloseaLL()



*+ EOF: M_BDIF.PRG
