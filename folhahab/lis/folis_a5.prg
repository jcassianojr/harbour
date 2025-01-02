// +--------------------------------------------------------------------
// +
// +    Programa  : folis_a5.prg  Acumular Dados para DIRF
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +

function folis_a5()
CABE2( '* ACUMULADO DADOS P/DIRF *' )
IF !MDG( 'Voce ja acumulou Informe de Rendimentos' )
FOLIS_A4()
RETU
ENDIF
SetColor( "W/N,N/W" )
@ 08, 00 CLEA
nACU    := IRRESC()
nFATCAT := 0
@ 21, 00 SAY "Digite o Teto de Corte Rendimentos Funcionarios Sem Retencao"
@ 22, 00 SAY "Digite 0000000.01 - Incluir Todos Funcionarios Sem Retencao"
@ 23, 00 SAY "Digite 0 - Para nao Incluir Funcionarios Sem Retencao"
@ 24, 60 GET nFATCAT                                                        PICT "9999999.99"
IF !READCUR()
RETU .F.
ENDIF

IF !ARQIRR( nACU, 1, 2 )  // shared  fo_irrf
RETU .F.
ENDIF
cSELE1 := Alias()
IF !ARQIRR( nACU, 0, 1 )  // exclusive ajudir
dbCloseAll()
RETU .F.
ENDIF
cSELE2 := Alias()
FLock()
ZAP
MDS( 'Acumulando Dados Aguarde' )
dbSelectAr( cSELE1 )
dbGoTop()
WHILE !Eof()
lVAL1 := .F.
lVAL2 := .F.
lVAL3 := .F.
lVAL4 := .F.
lVAL5 := .F.
lVAL6 := .F.
lVAL7 := .F.
CTR   := NUMERO
mCPF  := CPF
IF Empty( mCPF ) .OR. mCPF = "000.000.000-00"
ALERTX( "Sem CPF - Funcionario no. " + Str( CTR ) )
IF !MDG( "Continuar Mesmo Assim" )
dbCloseAll()
RETU
ENDIF
ENDIF
// MES
MER := MES
IF CODREN > 600 .AND. CODREN < 610
MER := 13
ENDIF
DO CASE
CASE CODREN = 401  // rendimentos
lVAL1 := .T.
CASE CODREN = 402  // deducoes e Previdencia Oficial
lVAL2 := .T.
lVAL4 := .T.
CASE CODREN = 403  // Previdencia Privada
lVAL7 := .T.
CASE CODREN = 404  // Pensao Alimenticia
lVAL2 := .T.
lVAL6 := .T.
CASE CODREN = 405  // Imposto Retido na Fonte
lVAL3 := .T.
CASE CODREN = 407  // Deducoes Dependentes
VAL2  := .T.
lVAL5 := .T.
ENDCASE

VAL := VALOR
VAU := VALUFIR


CTRC := mCPF + Str( MER, 2 )
dbSelectAr( cSELE2 )
dbGoTop()
IF !dbSeek( CTRC )
NETRECAPP()
FIELD->NUMERO := CTR
FIELD->CPF    := mCPF
FIELD->MES    := MER
ELSE
NETRECLOCK()
ENDIF
DO CASE
CASE lVAL1   // rendimentos
FIELD->VALOR1 := VALOR1 + VAL
FIELD->VALUF1 := VALUF1 + VAU
CASE lVAL2   // inss+dependentes+pensao
FIELD->VALOR2 := VALOR2 + VAL
FIELD->VALUF2 := VALUF2 + VAU
CASE lVAL3   // Imposto Retido na Fonte
FIELD->VALOR3 := VALOR3 + VAL
FIELD->VALUF3 := VALUF3 + VAU
CASE lVAL4   // deducoes e Previdencia Oficial
FIELD->VALOR4 := VALOR4 + VAL
FIELD->VALUF4 := VALUF4 + VAU
CASE lVAL5   // Deducoes Dependentes
FIELD->VALOR5 := VALOR5 + VAL
FIELD->VALUF5 := VALUF5 + VAU
CASE lVAL6   // Pensao Alimenticia
FIELD->VALOR6 := VALOR6 + VAL
FIELD->VALUF6 := VALUF6 + VAU
CASE lVAL7   // Previdencia Privada
FIELD->VALOR7 := VALOR7 + VAL
FIELD->VALUF7 := VALUF7 + VAU
ENDCASE
dbUnlock()
dbSelectAr( cSELE1 )
dbSkip()
ENDDO
dbCloseAll()


MDS( 'Aguarde Terminando acumulacao' )
IF !ARQIRR( nACU, 0, 1 )  // exclusive Arede ajudir
dbCloseAll()
RETU .F.
ENDIF
WHILE !Eof()
mCPF    := CPF
nREC    := RecNo()
nVALOR3 := 0
nVALOR1 := 0
WHILE CPF = mCPF .AND. !Eof()
nVALOR1 += VALOR1
nVALOR3 += VALOR3
dbSkip()
ENDDO
IF nVALOR3 = 0
IF nFATCAT = 0 .OR. nVALOR1 <= nFATCAT
dbGoto( nREC )
WHILE CPF = mCPF .AND. !Eof()
PCK := .T.
NETRECDEL()
dbSkip()
ENDDO
ENDIF
ENDIF
ENDDO
FLock()
PACK
dbCloseAll()
RETUrn


// + EOF: folis_a5.prg
// +
