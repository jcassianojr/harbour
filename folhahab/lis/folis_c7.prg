*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\CLIPPER\FOLHA\LIS\FOLIS_C7.PRG
*+
*+    Functions: Function FOLISD5()
*+               Function D55()
*+               Function D5X()
*+
*+    Reformatted by Click! 2.03 on Mar-22-2001 at 10:03 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

////#INCLUDE "COMANDO.CH"

if !MDL( 'IMPRIMIR ANEXO INFORME DE RENDIMENTOS', 0 )
   retu
endif
DECLARE TOT[ 10 ], BUS[ 10 ]

MDS( '* CARREGANDO DADOS DA FIRMA *' )
if ! NETUSE("FIRMA") 
   retu
endif
dbgotop()
IF dbseek( NREMP )
   ENDER1 := ENDERECO
   CIDAD  := CIDADE
   ESTAD  := ESTADO
   NRCGC  := CGC
   BAI    := BAIRRO
   CEP1   := CEP
   xrTEL  := TELEFONE
   xrRESN := RESPONSAV
endif
dbcloseall()

DXDIA2  := date()
ANOBASE := year( DXDIA2 )
CONTAR  := 1

@ 21, 00 clea
@ 21, 00 say 'Nome do Respons vel'
@ 22, 00 say 'Qual a data para impressao'
@ 23, 00 say 'Qual o ano base'
@ 24, 00 say 'Quantas Copias Deseja'
@ 21, 40 get xrRESN
@ 22, 40 get DXDIA2
@ 23, 40 get ANOBASE                      pict '####'
@ 24, 40 get CONTAR                       pict '##'
if !READCUR()
   retu .F.
endif

DECLARE OBS[ 16 ]
if MDG( 'Deseja escrever Informarcao Complementar' )
   afill( OBS, spac( 70 ) )
   @ 08, 00 clea
   @ 24, 00 say 'Digite as Observacoes'
   @ 08, 00 get OBS[ 1 ]
   @ 09, 00 get OBS[ 2 ]
   @ 10, 00 get OBS[ 3 ]
   @ 11, 00 get OBS[ 4 ]
   @ 12, 00 get OBS[ 5 ]
   @ 13, 00 get OBS[ 6 ]
   @ 14, 00 get OBS[ 7 ]
   @ 15, 00 get OBS[ 8 ]
   @ 16, 00 get OBS[ 9 ]
   @ 17, 00 get OBS[ 10 ]
   @ 18, 00 get OBS[ 11 ]
   @ 19, 00 get OBS[ 12 ]
   @ 20, 00 get OBS[ 13 ]
   @ 21, 00 get OBS[ 14 ]
   @ 22, 00 get OBS[ 15 ]
   @ 23, 00 get OBS[ 16 ]
   READCUR()
else
   afill( OBS, "" )
endif
COMP  :=  MDG( 'Deseja Anexo Resumido' )
lSOVAL:= MDG("So valores")

INFO1 := .F.

nACU := IRRESC()


if !ARQIRR( nACU, 1,  3 )             //Shared Arede PES
   retu .F.
endif
FILTRO := ''
FI     := trim( FILTRO )
FILTRO := FILTRO( FI )
set filter to &FILTRO
cSELE1:=ALIAS()


if !ARQIRR( nACU, 1,  2 )             //SHARED Arede FO_Irrf
   retu .F.
endif
cSELE2:=ALIAS()

IMPRESSORA()
@ prow(), 0 say IMPCHR( 18 )
DBSELECTAR(cSELE1)
dbgotop()
while !eof()
   CTR  := NUMERO
   mCPF := CPF
   for X := 1 to CONTAR
      if ! Lsoval
         @ prow(), 1      say "MINISTERIO DA ECONOMIA,FAZENDA E PLANEJAMENTO SECRETARIA DA FAZENDA NACIONAL"
         @ prow() + 1, 1  say "Departamento da Receita Federal"
         @ prow(), 50     say "IMPOSTO DE RENDA PESSOA FISICA"
         @ prow() + 1, 30 say IMPCHR( 14 ) + 'ANEXO'
         @ prow() + 1, 0  say "COMPROVANTE DE RENDIMENTOS PAGOS E DE RETENCAO DE IMPOSTO DE RENDA NA FONTE"
         @ prow() + 1, 0  say repl( '=', 80 )
         @ prow() + 1, 0  say '|'
         @ prow(), 2      say 'FONTE PAGADORA PESSOA JURIDICA'
         @ prow(), 36     say '2 FONTE PAGADORA PESSOA FISICA'
         @ prow(), 79     say '|'
         @ prow() + 1, 0  say '|'
         @ prow(), 36     say 'nro. do cpf do pagador :'
         @ prow(), 79     say '|'
         @ prow() + 1, 0  say '|'
         @ prow(), 37     say 'nome do pagador'
         @ prow(), 79     say '|'
         @ prow(), 3      say IMPCHR( 15 ) + IMPCHR( 14 ) + 'CGC: ' + NRCGC + IMPCHR( 18 )
         @ prow() + 1, 0  say '|'
         @ prow(), 79     say '|'
         @ prow(), 5      say IMPCHR( 15 ) + MSG2 + IMPCHR( 18 )
         @ prow() + 1, 0  say '|'
         @ prow(), 37     say 'endereco  '
         @ prow(), 79     say '|'
         @ prow(), 6      say IMPCHR( 15 ) + ENDER1 + IMPCHR( 18 )
         @ prow() + 1, 0  say '|'
         @ prow(), 37     say ""
         @ prow(), 79     say '|'
         @ prow(), 6      say IMPCHR( 15 ) + BAI + ' - CEP ' + CEP1 + IMPCHR( 18 )
         @ prow() + 1, 0  say '|'
         @ prow(), 37     say 'cidade                 '
         @ prow(), 76     say '|'
         @ prow(), 77     say 'UF'
         @ prow(), 79     say '|'
         @ prow(), 6      say IMPCHR( 15 ) + trim( CIDAD ) + ' - ' + ESTAD + IMPCHR( 18 )
         @ prow() + 1, 0  say '|'
         @ prow(), 79     say '|'
      endif
      @ prow() + 1, 0  say repl( '=', 80 )
      @ prow() + 1, 0  say '|'
      @ prow(), 1      say 'ano base'
      @ prow(), 9      say '|'
      @ prow(), 10     say 'pessoa beneficiaria dos rendimentos'
      @ prow(), 79     say '|'
      @ prow() + 1, 0  say '|'
      @ prow(), 9      say '|'
      @ prow(), 10     say 'nro. do cpf'
      @ prow(), 32     say '|'
      @ prow(), 33     say 'nome completo'
      @ prow(), 79     say '|'
      @ prow() + 1, 0  say '|'
      @ prow(), 2      say ANOBASE
      @ prow(), 9      say '|'
      @ prow(), 10     say CPF
      @ prow(), 32     say '|'
      @ prow(), 33     say NOME
      @ prow(), 79     say '|'
      @ prow(), 2      say ANOBASE
      @ prow(), 10     say CPF
      @ prow(), 33     say NOME
      @ prow(), 33     say NOME
      @ prow() + 1, 0  say repl( '-', 80 )
      @ prow() + 1, 0  say '|'
      @ prow(), 1      say 'natureza do rendimento :'
      @ prow(), 26     say 'RENDIMENTO DO TRABALHO ASSALARIADO'
      @ prow(), 26     say 'RENDIMENTO DO TRABALHO ASSALARIADO'
      @ prow(), 79     say '|'
      sele 2
      @ prow() + 1, 0 say repl( '=', 80 )
      @ prow() + 1, 1 say '4 - RENDIMENTOS TRIBUTAVEIS, DEDUCOES E IMPOSTO RETIDO NA FONTE'
      if COMP
         D55( 401, '01. Total dos Rendimentos' )
         D55( 402, '02. Contribuicao Previdenciaria Oficial' )
         D55( 403, '03. Contribuicao Previdenciaria Privada' )
         D55( 404, '04. Pensao Judicial' )
         D55( 407, '05. Dependentes' )
         D55( 405, '06. Imposto Retido na Fonte' )
      else
         aTIT := {}
         aadd( aTIT, '01. Rendimentos' )
         aadd( aTIT, '02. Prev. Oficial' )
         aadd( aTIT, '03. Prev. Privada' )
         aadd( aTIT, '04. Pensao Jud.' )
         aadd( aTIT, '05. Dependentes.' )
         aadd( aTIT, '06. Imp.Ret. Fonte' )
         FOLISD5( { 401, 402, 403, 404, 407, 405 }, aTIT )
      endif
      @ prow() + 1, 0 say IMPCHR( 18 ) + repl( '=', 80 )
      @ prow() + 1, 1 say '5 - RENDIMENTOS ISENTOS E NAO TRIBUTAVEIS'
      if COMP
         D55( 501, '01. Salario Familia ' )
         D55( 502, '02. Proventos Aposentados ou Reforma' )
         D55( 503, '03. Diarias Ajuda de Custo' )
         D55( 504, '04. Pens„o Proventos' )
         D55( 505, '05. Lucro ou Dividendo Apurado' )
         D55( 506, '06. Valores Pagos a titulares ou Socios' )
         D55( 507, '07. Outros' )
      else
         aTIT := {}
         aadd( aTIT, '01.Salario Familia ' )
         aadd( aTIT, '02.Proventos Aposentados ou Reforma' )
         aadd( aTIT, '03.Diarias Ajuda de Custo' )
         aadd( aTIT, '04.Pens„o Proventos' )
         aadd( aTIT, '05.Lucro ou Dividendo Apurado' )
         aadd( aTIT, '06.Valores Pagos a titulares ou Socios' )
         aadd( aTIT, '07.Outros' )
         FOLISD5( { 501, 502, 503, 504, 505, 506, 507 }, aTIT )
         @ prow() + 1, 0 say IMPCHR( 18 ) + repl( '=', 80 )
         IMPFOL()
      endif
      @ prow() + 1, 0 say IMPCHR( 18 ) + repl( '=', 80 )
      @ prow() + 1, 1 say '6 - RENDIMENTOS SUJEITOS A TRIBUTACAO EXCLUSIVA'
      if COMP
         D55( 601, '01. DECIMO TERCEIRO SALARIO' )
         D55( 611, '02. Outros' )
      else
         FOLISD5( { 601, 611 }, { '01 13o. Salario', '02. Outros ' } )
      endif
      @ prow() + 1, 0 say IMPCHR( 18 ) + repl( '=', 80 )
      if ! lsoval
         @ prow() + 1, 1 say '7 - INFORMACOES COMPLEMENTARES'
         if INFO1
           @ prow() + 1, 0 say '504:FGTS/INDENIZACOES/ABONO'
         endif
         LIM := if( COMP, 2, 16 )
         for W := 1 to LIM
            @ prow() + 1, 0 say OBS[ W ]
         next W
         @ prow() + 1, 0  say repl( '=', 80 )
         @ prow() + 1, 1  say '8 - NOME E ASSINATURA DO RESPONSAVEL PELAS INFORMACOES'
         @ prow() + 1, 5  say 'DATA :'
         @ prow(), 15     say DXDIA2
         @ prow(), 38     say MSG2
         @ prow() + 1, 38 say ''
         @ prow() + 1, 38 say 'Instrucao Normativa-SRF-No. 120/2000'
         @ prow() + 1, 0  say repl( '=', 80 )
      endif
      @ prow() + 1, 0  say IMPFOL()
      DBSELECTAR(cSELE1)
   next X
   DBSELECTAR(cSELE1)
   dbskip()
enddo
video()
dbcloseall()
IMPEND()
retu

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function FOLISD5()
*+
*+    Called from ( folis_c7.prg )   3 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func FOLISD5( aBUS, aTIT )

@ prow() + 1, 0 say IMPCHR( 15 ) + 'MES'
for Y := 1 to len( aTIT )
   @ prow(), ( Y * 18 ) - 5 say aTIT[ Y ]
next Y
afill( TOT, 0 )
for Y := 1 to 12
   @ prow() + 1, 0 say MMES( Y )
   COL := 10
   for W := 1 to len( aBUS )
      D5X( aBUS[ W ] )
      COL += 18
   next W
next Y
@ prow() + 1, 0 say 'Total'
COL := 10
for Y := 1 to len( aBUS )
   if TOT[ Y ] # 0
      @ prow(), COL say TOT[ Y ] pict '###,###,###.##'
   endif
   COL += 18
   if aBUS[ Y ] = 507 .and. TOT[ Y ] > 0
      INFO1 := .T.
   endif
next Y
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function D55()
*+
*+    Called from ( folis_c7.prg )  15 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func D55

para BUS1, TITULO
BUS[ 1 ] = BUS1
afill( TOT, 0 )
@ prow() + 1, 0 say IMPCHR( 15 )
for Y := 1 to 12
   W   := 1
   COL := 4 + if( Y < 7, ( Y - 1 ) * 22, ( Y - 7 ) * 22 )
   @ prow() + if( Y = 7, 1, 0 ), COL - 4 say substr( MMES( Y ), 1, 3 )
   D5X( BUS1 )
next Y
@ prow() + 1, 0 say TITULO
@ prow(), 40    say ': Total->'
if TOT[ 1 ] # 0
   @ prow(), 50 say TOT[ 1 ] pict '###,###,###.##'
endif
if BUS[ 1 ] = 507 .and. TOT[ 1 ] # 0
   INFO1 := .T.
endif
retu ( .T. )

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function D5X()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func D5X( nCOD )
VALE :=PEGVALD5X(mCPF + str( nCOD, 3 ) + str( Y, 2 ))
IF VALE>0
   if nCOD = 601
      VALE-=PEGVALD5X(mCPF + "602" + str( Y, 2 ))
      VALE-=PEGVALD5X(mCPF + "607" + str( Y, 2 ))
      VALE-=PEGVALD5X(mCPF + "604" + str( Y, 2 ))
   endif
   if nCOD = 611
      VALE-=PEGVALD5X(mCPF + "612" + str( Y, 2 ))
      VALE-=PEGVALD5X(mCPF + "617" + str( Y, 2 ))
      VALE-=PEGVALD5X(mCPF + "614" + str( Y, 2 ))
   endif
   VALE := if( VALE < 0, 0, VALE )
   if VALE > 0
      @ prow(), COL say VALE pict '###,###,###.##'
   endif
endif
TOT[ W ] = TOT[ W ] + VALE
retu ( .T. )

FUNC PEGVALD5X(cBUSCA)
LOCAL nRETU
nRETU:=0
dbgotop()
IF dbseek( cBUSCA )
   nRETU := VALOR
endif
RETU nRETU


*+ EOF: FOLIS_C7.PRG
