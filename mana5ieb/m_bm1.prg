*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BM1.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function m_bm1
para cARQPRI

if cARQPRI="MM01"
   cCABREF:="Resumo NF Saidas"
   aRETU   := PERFEC( { "MM01" }, { "M1" }, { "MM91" } ,{ "PADRAO" }  )
else
   cCABREF:="Resumo NF Entradas"
   aRETU   := PERFEC( { "MK01" }, { "K1" }, { "MK91" },{ "PADRAO" }   )
endif



//Modo de Trabalho no Video
MDI( " Э Imprimir Relatўrio da " + cCABREF )

lCOM:=MDG("Comprimido")

if !CHECKIMP( 0 )
   retu .F.
endif
cEMP   := IMP( "ZEMP" )
cRESET := IMP( "RESET" )


nMES:= aRETU[ 1 ]
nANO:= aRETU[ 2 ]
ARQWORK := aRETU[ 5, 1 ]
cCAB    := aRETU[ 7 ]


OPCAO( 10, 10, " A - Marcados Para Apurar     ", 65 )
OPCAO( 12, 10, " B - Marcados Para NЋO Apurar ", 66 )
OPCAO( 14, 10, " C - Todos os Itens           ", 67 )
nAPURA := menu(, 0 )
FILTRO := ""
do case
case nAPURA = 1
   FILTRO := 'APURA#"N"'
case nAPURA = 2
   FILTRO := 'APURA="N"'
endcase

FILTRO := RFILORD( cARQPRI, .F., FILTRO )
CTLIN  := NRCOPIA := 1
VEZES  := 0
@ 24, 00
@ 24, 00 say "NЈmero de cўpias:" get NRCOPIA pict '99'
READCUR()

if !USEREDE( ARQWORK, 1, 1 )
   retu
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif

IMPRESSORA()
if Lcom
   @ 0,0 SAY IMPSTR(aCHR[1])
endif

for W := 1 to NRCOPIA
   CTLIN   := 80
   ZPAGINA := 0
   TOT1    := TOT2 := TOT3 := TOT4 := TOT5 := 0.00
   dbgotop()
   while !eof()
      if CTLIN > 55
         ZPAGINA ++
         @  0,  0  say cEMP
         IF cARQPRI="MM01"
            @  1, 01 say 'M_BM1'
         ELSE
            @  1, 01 say 'M_BK1'
         ENDIF
         @  1, 20 say cCABREF
         @  1, 80 SAY TIME()
         @  1, 90 say 'Emitida em: ' + dtoc( ZDATA )
         @  1,110 say ACENTO( '    Folha: ' ) + str( ZPAGINA, 2 )
         @  2,  0 say repl( '-', 132 )
         @ 03, 00  say 'N.Fis'
         @ 03, 12  say ' Emissao'
         @ 03, 24  say 'Cliente Destinado'
         @ 03, 47  say 'Operacao'
         @ 03, 58  say 'Vencimento' // NOVO
         @ 03, 73  say 'Total Mercador'
         @ 03, 95  say 'Total da Nota '
         @ 04,  0  say repl( '-', 132 )
         CTLIN := 5
      endif
      IF cARQPRI="MM01"
         @ CTLIN, 00 say NUMERO  pict '99999999'
      ELSE
         @ CTLIN, 00 say NRNOTA  pict '99999999'
      ENDIF
      @ CTLIN, 12 say DATA
      @ CTLIN, 24 say strzero( FORNECEDO, 4 )
      @ CTLIN, 30 say COGNOME
      @ CTLIN, 48 say IF(EMPTY(CFONEW),left( OPERACAO, 10 ),ALLTRIM(CFONEW)+"/"+ALLTRIM(CFONEWB))
      @ CTLIN, 58 say DAT01
      @ CTLIN, 73 say TOTMER  pict '999,999,999.99'
      @ CTLIN, 95 say TOTNF   pict '999,999,999.99'
      TOT1 += TOTMER
      TOT3 += TOTNF
      CTLIN ++
      dbskip()
   enddo
   @ CTLIN,  0 say '*' + repl( '-', 131 ) + '*'
   CTLIN ++
   @ CTLIN, 56 say TOT1 pict '999,999,999.99'
   @ CTLIN, 87 say TOT3 pict '999,999,999.99'
   CTLIN ++
   if ZPAGINA > 0
      @ CTLIN,  0 say '*' + repl( '-', 131 ) + '*'
      CTLIN ++
   endif
   ZPAGINA := 0
next W
VIDEO()
dbclosearea()
IMPEND()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function PERACU()
*+
*+    Called from ( m_bdia.prg   )   1 -
*+                ( m_bdib.prg   )   1 -
*+                ( m_bdic.prg   )   1 -
*+                ( m_bm1.prg    )   1 - function peracu()
*+                ( m_bm3.prg    )   1 - function peracu()
*+                ( m_bm4.prg    )   1 - function peracu()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func PERACU

if MDG( "Mes j  Fechado" )
   cVAR    := MESANO()
   ARQWORK := cCARREF + cVAR
   if MDG( "Deseja Convertido" )
      MES := val( right( cVAR, 2 ) )
      ANO := val( "19" + left( cVAR, 2 ) )
      MDS( "Confirme MES/ANO Conversao" )
      @ 24, 40 get MES
      @ 24, 60 get ANO
      READCUR()
      lACUMULA := .T.
   endif
endif
if MDG( "Acumulado" )
   if MDG( "Deseja Reacumular" )
      SOMAANO( cARQACU, cCARREF, "PADRAO" )                 //pela competencia
   endif
   ARQWORK  := cARQACU
   lACUMULA := .T.
endif
MDS( "Informe Cabe‡ario Auxiliar" )
@ 24, 30 get cCABAUX
READCUR()
retu .T.

*+ EOF: M_BM1.PRG
