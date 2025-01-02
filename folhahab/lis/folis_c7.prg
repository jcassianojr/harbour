// +--------------------------------------------------------------------
// +
// +    Programa  : folis_c7.prg  IMPRIMIR ANEXO INFORME DE RENDIMENTOS
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

function folis_c7()
IF !MDL( 'IMPRIMIR ANEXO INFORME DE RENDIMENTOS', 0 )
RETU
ENDIF
DECLARE TOT[ 10 ], BUS[ 10 ]

MDS( '* CARREGANDO DADOS DA FIRMA *' )
IF !NETUSE( "FIRMA" )
RETU
ENDIF
dbGoTop()
IF dbSeek( NREMP )
ENDER1 := ENDERECO
CIDAD  := CIDADE
ESTAD  := ESTADO
NRCGC  := CGC
BAI    := BAIRRO
CEP1   := CEP
xrTEL  := TELEFONE
xrRESN := RESPONSAV
ENDIF
dbCloseAll()

DXDIA2  := Date()
ANOBASE := Year( DXDIA2 )
CONTAR  := 1

@ 21, 00 clea
@ 21, 00 SAY 'Nome do Respons vel'
@ 22, 00 SAY 'Qual a data para impressao'
@ 23, 00 SAY 'Qual o ano base'
@ 24, 00 SAY 'Quantas Copias Deseja'
@ 21, 40 GET xrRESN
@ 22, 40 GET DXDIA2
@ 23, 40 GET ANOBASE                      PICT '####'
@ 24, 40 GET CONTAR                       PICT '##'
IF !READCUR()
RETU .F.
ENDIF

DECLARE OBS[ 16 ]
IF MDG( 'Deseja escrever Informarcao Complementar' )
AFill( OBS, spac( 70 ) )
@ 08, 00 clea
@ 24, 00 SAY 'Digite as Observacoes'
@ 08, 00 GET OBS[ 1 ]
@ 09, 00 GET OBS[ 2 ]
@ 10, 00 GET OBS[ 3 ]
@ 11, 00 GET OBS[ 4 ]
@ 12, 00 GET OBS[ 5 ]
@ 13, 00 GET OBS[ 6 ]
@ 14, 00 GET OBS[ 7 ]
@ 15, 00 GET OBS[ 8 ]
@ 16, 00 GET OBS[ 9 ]
@ 17, 00 GET OBS[ 10 ]
@ 18, 00 GET OBS[ 11 ]
@ 19, 00 GET OBS[ 12 ]
@ 20, 00 GET OBS[ 13 ]
@ 21, 00 GET OBS[ 14 ]
@ 22, 00 GET OBS[ 15 ]
@ 23, 00 GET OBS[ 16 ]
READCUR()
ELSE
AFill( OBS, "" )
ENDIF
COMP   := MDG( 'Deseja Anexo Resumido' )
lSOVAL := MDG( "So valores" )

INFO1 := .F.

nACU := IRRESC()


IF !ARQIRR( nACU, 1, 3 )  // Shared Arede PES
RETU .F.
ENDIF
FILTRO := ''
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO
cSELE1 := Alias()


IF !ARQIRR( nACU, 1, 2 )  // SHARED Arede FO_Irrf
RETU .F.
ENDIF
cSELE2 := Alias()

IMPRESSORA()
@ PRow(), 0 SAY IMPCHR( 18 )
dbSelectAr( cSELE1 )
dbGoTop()
WHILE !Eof()
CTR  := NUMERO
mCPF := CPF
FOR X := 1 TO CONTAR
IF !Lsoval
@ PRow(), 1    SAY "MINISTERIO DA ECONOMIA,FAZENDA E PLANEJAMENTO SECRETARIA DA FAZENDA NACIONAL"
@ PRow() + 1, 1  SAY "Departamento da Receita Federal"
@ PRow(), 50    SAY "IMPOSTO DE RENDA PESSOA FISICA"
@ PRow() + 1, 30 SAY IMPCHR( 14 ) + 'ANEXO'
@ PRow() + 1, 0  SAY "COMPROVANTE DE RENDIMENTOS PAGOS E DE RETENCAO DE IMPOSTO DE RENDA NA FONTE"
@ PRow() + 1, 0  SAY repl( '=', 80 )
@ PRow() + 1, 0  SAY '|'
@ PRow(), 2    SAY 'FONTE PAGADORA PESSOA JURIDICA'
@ PRow(), 36    SAY '2 FONTE PAGADORA PESSOA FISICA'
@ PRow(), 79    SAY '|'
@ PRow() + 1, 0  SAY '|'
@ PRow(), 36    SAY 'nro. do cpf do pagador :'
@ PRow(), 79    SAY '|'
@ PRow() + 1, 0  SAY '|'
@ PRow(), 37    SAY 'nome do pagador'
@ PRow(), 79    SAY '|'
@ PRow(), 3    SAY IMPCHR( 15 ) + IMPCHR( 14 ) + 'CGC: ' + NRCGC + IMPCHR( 18 )
@ PRow() + 1, 0  SAY '|'
@ PRow(), 79    SAY '|'
@ PRow(), 5    SAY IMPCHR( 15 ) + MSG2 + IMPCHR( 18 )
@ PRow() + 1, 0  SAY '|'
@ PRow(), 37    SAY 'endereco  '
@ PRow(), 79    SAY '|'
@ PRow(), 6    SAY IMPCHR( 15 ) + ENDER1 + IMPCHR( 18 )
@ PRow() + 1, 0  SAY '|'
@ PRow(), 37    SAY ""
@ PRow(), 79    SAY '|'
@ PRow(), 6    SAY IMPCHR( 15 ) + BAI + ' - CEP ' + CEP1 + IMPCHR( 18 )
@ PRow() + 1, 0  SAY '|'
@ PRow(), 37    SAY 'cidade                 '
@ PRow(), 76    SAY '|'
@ PRow(), 77    SAY 'UF'
@ PRow(), 79    SAY '|'
@ PRow(), 6    SAY IMPCHR( 15 ) + Trim( CIDAD ) + ' - ' + ESTAD + IMPCHR( 18 )
@ PRow() + 1, 0  SAY '|'
@ PRow(), 79    SAY '|'
ENDIF
@ PRow() + 1, 0 SAY repl( '=', 80 )
@ PRow() + 1, 0 SAY '|'
@ PRow(), 1   SAY 'ano base'
@ PRow(), 9   SAY '|'
@ PRow(), 10   SAY 'pessoa beneficiaria dos rendimentos'
@ PRow(), 79   SAY '|'
@ PRow() + 1, 0 SAY '|'
@ PRow(), 9   SAY '|'
@ PRow(), 10   SAY 'nro. do cpf'
@ PRow(), 32   SAY '|'
@ PRow(), 33   SAY 'nome completo'
@ PRow(), 79   SAY '|'
@ PRow() + 1, 0 SAY '|'
@ PRow(), 2   SAY ANOBASE
@ PRow(), 9   SAY '|'
@ PRow(), 10   SAY CPF
@ PRow(), 32   SAY '|'
@ PRow(), 33   SAY NOME
@ PRow(), 79   SAY '|'
@ PRow(), 2   SAY ANOBASE
@ PRow(), 10   SAY CPF
@ PRow(), 33   SAY NOME
@ PRow(), 33   SAY NOME
@ PRow() + 1, 0 SAY repl( '-', 80 )
@ PRow() + 1, 0 SAY '|'
@ PRow(), 1   SAY 'natureza do rendimento :'
@ PRow(), 26   SAY 'RENDIMENTO DO TRABALHO ASSALARIADO'
@ PRow(), 26   SAY 'RENDIMENTO DO TRABALHO ASSALARIADO'
@ PRow(), 79   SAY '|'
SELE 2
@ PRow() + 1, 0 SAY repl( '=', 80 )
@ PRow() + 1, 1 SAY '4 - RENDIMENTOS TRIBUTAVEIS, DEDUCOES E IMPOSTO RETIDO NA FONTE'
IF COMP
D55( 401, '01. Total dos Rendimentos' )
D55( 402, '02. Contribuicao Previdenciaria Oficial' )
D55( 403, '03. Contribuicao Previdenciaria Privada' )
D55( 404, '04. Pensao Judicial' )
D55( 407, '05. Dependentes' )
D55( 405, '06. Imposto Retido na Fonte' )
ELSE
aTIT := {}
AAdd( aTIT, '01. Rendimentos' )
AAdd( aTIT, '02. Prev. Oficial' )
AAdd( aTIT, '03. Prev. Privada' )
AAdd( aTIT, '04. Pensao Jud.' )
AAdd( aTIT, '05. Dependentes.' )
AAdd( aTIT, '06. Imp.Ret. Fonte' )
FOLISD5( { 401, 402, 403, 404, 407, 405 }, aTIT )
ENDIF
@ PRow() + 1, 0 SAY IMPCHR( 18 ) + repl( '=', 80 )
@ PRow() + 1, 1 SAY '5 - RENDIMENTOS ISENTOS E NAO TRIBUTAVEIS'
IF COMP
D55( 501, '01. Salario Familia ' )
D55( 502, '02. Proventos Aposentados ou Reforma' )
D55( 503, '03. Diarias Ajuda de Custo' )
D55( 504, '04. Pens„o Proventos' )
D55( 505, '05. Lucro ou Dividendo Apurado' )
D55( 506, '06. Valores Pagos a titulares ou Socios' )
D55( 507, '07. Outros' )
ELSE
aTIT := {}
AAdd( aTIT, '01.Salario Familia ' )
AAdd( aTIT, '02.Proventos Aposentados ou Reforma' )
AAdd( aTIT, '03.Diarias Ajuda de Custo' )
AAdd( aTIT, '04.Pens„o Proventos' )
AAdd( aTIT, '05.Lucro ou Dividendo Apurado' )
AAdd( aTIT, '06.Valores Pagos a titulares ou Socios' )
AAdd( aTIT, '07.Outros' )
FOLISD5( { 501, 502, 503, 504, 505, 506, 507 }, aTIT )
@ PRow() + 1, 0 SAY IMPCHR( 18 ) + repl( '=', 80 )
IMPFOL()
ENDIF
@ PRow() + 1, 0 SAY IMPCHR( 18 ) + repl( '=', 80 )
@ PRow() + 1, 1 SAY '6 - RENDIMENTOS SUJEITOS A TRIBUTACAO EXCLUSIVA'
IF COMP
D55( 601, '01. DECIMO TERCEIRO SALARIO' )
D55( 611, '02. Outros' )
ELSE
FOLISD5( { 601, 611 }, { '01 13o. Salario', '02. Outros ' } )
ENDIF
@ PRow() + 1, 0 SAY IMPCHR( 18 ) + repl( '=', 80 )
IF !lsoval
@ PRow() + 1, 1 SAY '7 - INFORMACOES COMPLEMENTARES'
IF INFO1
@ PRow() + 1, 0 SAY '504:FGTS/INDENIZACOES/ABONO'
ENDIF
LIM := if( COMP, 2, 16 )
FOR W := 1 TO LIM
@ PRow() + 1, 0 SAY OBS[ W ]
NEXT W
@ PRow() + 1, 0  SAY repl( '=', 80 )
@ PRow() + 1, 1  SAY '8 - NOME E ASSINATURA DO RESPONSAVEL PELAS INFORMACOES'
@ PRow() + 1, 5  SAY 'DATA :'
@ PRow(), 15    SAY DXDIA2
@ PRow(), 38    SAY MSG2
@ PRow() + 1, 38 SAY ''
@ PRow() + 1, 38 SAY 'Instrucao Normativa-SRF-No. 120/2000'
@ PRow() + 1, 0  SAY repl( '=', 80 )
ENDIF
@ PRow() + 1, 0 SAY IMPFOL()
dbSelectAr( cSELE1 )
NEXT X
dbSelectAr( cSELE1 )
dbSkip()
ENDDO
video()
dbCloseAll()
IMPEND()
RETUrn


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOLISD5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOLISD5( aBUS, aTIT )

   @ PRow() + 1, 0 SAY IMPCHR( 15 ) + 'MES'
   FOR Y := 1 TO Len( aTIT )
      @ PRow(), ( Y * 18 ) - 5 SAY aTIT[ Y ]
   NEXT Y
   AFill( TOT, 0 )
   FOR Y := 1 TO 12
      @ PRow() + 1, 0 SAY MMES( Y )
      COL := 10
      FOR W := 1 TO Len( aBUS )
         D5X( aBUS[ W ] )
         COL += 18
      NEXT W
   NEXT Y
   @ PRow() + 1, 0 SAY 'Total'
   COL := 10
   FOR Y := 1 TO Len( aBUS )
      IF TOT[ Y ] # 0
         @ PRow(), COL SAY TOT[ Y ] PICT '###,###,###.##'
      ENDIF
      COL += 18
      IF aBUS[ Y ] = 507 .AND. TOT[ Y ] > 0
         INFO1 := .T.
      ENDIF
   NEXT Y
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function D55()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC D55

   PARA BUS1, TITULO

   BUS[ 1 ] = BUS1
   AFill( TOT, 0 )
   @ PRow() + 1, 0 SAY IMPCHR( 15 )
   FOR Y := 1 TO 12
      W   := 1
      COL := 4 + if( Y < 7, ( Y - 1 ) * 22, ( Y - 7 ) * 22 )
      @ PRow() + if( Y = 7, 1, 0 ), COL - 4 SAY SubStr( MMES( Y ), 1, 3 )
      D5X( BUS1 )
   NEXT Y
   @ PRow() + 1, 0 SAY TITULO
   @ PRow(), 40   SAY ': Total->'
   IF TOT[ 1 ] # 0
      @ PRow(), 50 SAY TOT[ 1 ] PICT '###,###,###.##'
   ENDIF
   IF BUS[ 1 ] = 507 .AND. TOT[ 1 ] # 0
      INFO1 := .T.
   ENDIF
   RETU ( .T. )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function D5X()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC D5X( nCOD )

   VALE := PEGVALD5X( mCPF + Str( nCOD, 3 ) + Str( Y, 2 ) )
   IF VALE > 0
      IF nCOD = 601
         VALE -= PEGVALD5X( mCPF + "602" + Str( Y, 2 ) )
         VALE -= PEGVALD5X( mCPF + "607" + Str( Y, 2 ) )
         VALE -= PEGVALD5X( mCPF + "604" + Str( Y, 2 ) )
      ENDIF
      IF nCOD = 611
         VALE -= PEGVALD5X( mCPF + "612" + Str( Y, 2 ) )
         VALE -= PEGVALD5X( mCPF + "617" + Str( Y, 2 ) )
         VALE -= PEGVALD5X( mCPF + "614" + Str( Y, 2 ) )
      ENDIF
      VALE := if( VALE < 0, 0, VALE )
      IF VALE > 0
         @ PRow(), COL SAY VALE PICT '###,###,###.##'
      ENDIF
   ENDIF
   TOT[ W ] = TOT[ W ] + VALE
   RETU ( .T. )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGVALD5X()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGVALD5X( cBUSCA )

   LOCAL nRETU

   nRETU := 0
   dbGoTop()
   IF dbSeek( cBUSCA )
      nRETU := VALOR
   ENDIF
   RETU nRETU



// + EOF: folis_c7.prg
// +
