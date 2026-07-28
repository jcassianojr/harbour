// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bm6.prg
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

// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
// +
// +    Source Module => J:\empresa\M_BM6.PRG
// +
// +
// +ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ

// Modo de Trabalho no Video
MDI( " Ý C lculo da Apura‡„o de Vendas" )

// Variaveis de Trabalho
CRIARVARS( "MA01" )
CRIARVARS( "MM02" )

// Pegando Cores de Trabalho
MAO001 := COR( "MAO001" )

// declaracao de variaveis
mSUCATA1 := mSUCATA2 := 0.00
mVALPRES := 0

ARQWORK  := "MM02"
ARQWORK2 := "MK01"
ARQWORK3 := "MN01PG"
ARQWORK4 := "MM01"

// Declarando vari veis iniciais de trabalho
GASMESANT := 0.00
DESPMES   := 0.00
nMESUSO   := Month( ZDATA )
nANOUSO   := Year( ZDATA )

MDS( "Confirme a Competencia" )
@ 24, 50 GET nMESUSO
@ 24, 60 GET nANOUSO
IF !READCUR()
RETU .F.
ENDIF

IF MDG( "Revisar Saldos Anteriores" )
PADRAO( 0, 1, 0, "APUITA", "Mes Ano Valor", "' '+STR(mANO)+' '+STR(mMES)+' '+STR(mSALDO,18,2)", "MBM6" )
ENDIF

IF MDG( "Revisar Servicos" )
PADRAO( 0, 1, 0, "APUSER", "Cliente  Ano Mes Valor", "' '+STR(mCLIENTE,8)+' '+STR(mANO,4)+' '+STR(mMES,2)+' '+STR(mVALOR,12,2)", "MBM6A" )
ENDIF

cMESUSO := StrZero( nMESUSO, 2 )
cANOUSO := SubStr( StrZero( nANOUSO, 4 ), 3, 2 )
// xyMES  :=nMESUSO
IF nMESUSO = 1
FATMESANT := OBTER( "APUITA", Str( nANOUSO - 1, 4 ) + Str( 12, 2 ), "SALDO" )
ELSE
FATMESANT := OBTER( "APUITA", Str( nANOUSO, 4 ) + Str( nMESUSO - 1, 2 ), "SALDO" )
ENDIF

IF MDG( "Mes j  Fechado" )
xREFMES  := cANOUSO + cMESUSO
ARQWORK  := "M2" + xREFMES
ARQWORK2 := "K1" + xREFMES
ARQWORK3 := "MN" + xREFMES
ARQWORK4 := "M1" + xREFMES
ELSE
IF MDG( "Deseja Acumulado" )
xREFMES := Space( 20 )
MDS( "Digite Observa‡ao de Cabe‡ario" )
@ 24, 40 GET xREFMES
READCUR()
IF MDG( "Deseja Reacumular" )
aPER := PEDPER( .T. )
SOMAANO( "MM92", "M2",,,,,,, aPER )
SOMAANO( "MK91", "K1",,,,,,, aPER )
SOMAANO( "MN99", "MN",,,,,,, aPER )
SOMAANO( "MM91", "M1",,,,,,, aPER )
ENDIF
ARQWORK  := "MM92"
ARQWORK2 := "MK91"
ARQWORK3 := "MN99"
ARQWORK4 := "MM91"
ENDIF
ENDIF

SetColor( MAO001 )
@ 21, 00 clea
@ 21, 05 SAY "Digite o Faturamento do Mˆs Anterior  => " GET FATMESANT PICT '999,999,999.99'
@ 22, 05 SAY "Digite o Valor Pago no Mˆs Anterior   => " GET GASMESANT PICT '999,999,999.99'
IF !READCUR()
dbCloseAll()
RETU .F.
ENDIF

IF !USEREDE( "APURA", 0, 99 )
RETU
ENDIF
ZAP
dbCloseArea()

IF !USEREDE( "APURA2", 0, 99 )
RETU
ENDIF
ZAP
dbCloseArea()

mDESPMES := GASMESANT

@ 24, 00
@ 24, 05 SAY "Apurando Vendas Aguarde ..."

mTOT1NF := mTOT2NF := mTOT3NF := mTOT4NF := 0.00
mTOT1   := mTOT2 := mTOT3 := mTOT4 := mTOTIPI := 0.00
mTOTS   := mTOTSNF := 0
lTIPO02 := MDG( "Listar Tipo Serv 2-Ferramenta" )
lTIPSER := MDG( "Listar Servi‡os" )

aUFE := {}
IF MDG( "Especificar Grupo Clientes/Fornecedores - Excluir" )
nNUMERO := 0
@ 24, 00 SAY "Cliente No."
@ 24, 60 SAY "Esc ou 0 para encerrar"
WHILE .T.
@ 24, 20 GET nNUMERO
IF !READCUR()
EXIT
ENDIF
IF Empty( nNUMERO )
EXIT
ENDIF
AAdd( aUFE, nNUMERO )
ENDDO
IF Empty( aUFE )
ALERTX( "Grupo NÆo Especificado" )
ENDIF
ENDIF

IF !USEMULT( { { "MA01", 1, 1 }, { "MB01", 1, 1 }, { ARQWORK4, 1, 1 }, { "APURA", 1, 1 }, { "APUSER", 1, 99 }, { ARQWORK, 1, 2 } } )
RETU
ENDIF

dbSelectAr( ARQWORK )
SET FILTER TO APURA # "N"
dbGoTop()
WHILE !Eof()
FORN      := FORNECEDO
mCOGNOME  := Space( 12 )
mGRUPOEMP := Space( 12 )
nNUMERO   := 0
WHILE FORN = FORNECEDO .AND. !Eof()
@ 24, 40 SAY FORNECEDO PICT '99999'
@ 24, 50 SAY NUMERO    PICT "999999"
@ 24, 63 SAY VALORTOT  PICT '@E 999,999,999.99'
nNUMERO := NUMERO
IF AScan( aUFE, FORN ) = 0   // Se nao estiver lista excluidos
DO CASE
CASE TIPOSERV = "1"  // Produ‡„o
mTOT1   := ( VALORTOT - VALORIPI ) + mTOT1
mTOT1NF := VALORTOT + mTOT1NF
CASE TIPOSERV = "2"  // Ferram.
IF lTIPO02
mTOT2   := ( VALORTOT - VALORIPI ) + mTOT2
mTOT2NF := VALORTOT + mTOT2NF
ENDIF
CASE TIPOSERV = "3"  // Mo.Produ‡„o
mTOT3   := ( VALORTOT - VALORIPI ) + mTOT3
mTOT3NF := VALORTOT + mTOT3NF
CASE TIPOSERV = "4"  // Mo.Ferram.
mTOT4   := ( VALORTOT - VALORIPI ) + mTOT4
mTOT4NF := VALORTOT + mTOT4NF
CASE TIPOSERV = "5"
mSUCATA1 := ( VALORTOT - VALORIPI ) + mSUCATA1
mSUCATA2 := VALORTOT + mSUCATA2
ENDCASE
IF TIPOSERV >= "1" .AND. TIPOSERV <= "5"
IF TIPOSERV <> "2" .OR. lTIPO02
mTOTIPI := VALORIPI + mTOTIPI
ENDIF
ENDIF
ENDIF
dbSkip()
ENDDO
mTIPOCLI := "C"
dbSelectAr( ARQWORK4 )
dbGoTop()
IF dbSeek( nNUMERO )
mTIPOCLI := if( Empty( TIPOCLI ), "C", TIPOCLI )
ENDIF
dbSelectAr( if( mTIPOCLI = "F", "MB01", "MA01" ) )
dbGoTop()
IF dbSeek( FORN )
mCOGNOME := COGNOME
IF mTIPOCLI = "C"
mGRUPOEMP := GRUPOEMP
ENDIF
ENDIF
IF lTIPSER
dbSelectAr( "APUSER" )
dbGoTop()
dbSeek( Str( FORN, 8 ) + Str( nANOUSO, 4 ) + Str( nMESUSO, 2 ) )
WHILE FORN = CLIENTE .AND. ANO = nANOUSO .AND. MES = nMESUSO .AND. !Eof()
mTOTS   += VALOR
mTOTSNF += VALOR
dbSkip()
ENDDO
ENDIF

mTOTALMER := mTOT1 + mTOT2 + mTOT3 + mTOT4 + mTOTS
mTOTAL    := mTOTIPI + mTOTALMER
IF mTOTALMER > 0   // .AND.aSCAN(aUFE,FORN)=0 movido loop soma acima
// Para exluir todos tipos sucata...
dbSelectAr( "APURA" )
netrecapp()
field->FORNECEDO := FORN
field->COGNOME   := mCOGNOME
field->GRUPOEMP  := mGRUPOEMP
field->PROD      := mTOT1
field->FERRA     := mTOT2
field->MOPROD    := mTOT3
field->MOFERRA   := mTOT4
field->SERV      := mTOTS
field->TOTALMER  := mTOTALMER
field->TOTAL     := mTOTAL
field->PROD2     := mTOT1NF
field->FERRA2    := mTOT2NF
field->MOPROD2   := mTOT3NF
field->MOFERRA2  := mTOT4NF
field->SERV2     := mTOTSNF
ENDIF
// zerando vari veis de trabalho.
mTOTALMER := mTOTAL := 0.00
mTOT1NF   := mTOT2NF := mTOT3NF := mTOT4NF := 0.00
mTOT1     := mTOT2 := mTOT3 := mTOT4 := mTOTIPI := 0.00
mTOTS     := mTOTSNF := 0
dbSelectAr( ARQWORK )
ENDDO

// Servicos Sem Nota Fiscal de Saida
IF lTIPSER
dbSelectAr( "APUSER" )
dbSetOrder( 2 )
dbGoTop()
dbSeek( Str( nANOUSO, 4 ) + Str( nMESUSO, 2 ) )
WHILE ANO = nANOUSO .AND. MES = nMESUSO .AND. !Eof()
mFORNECEDO := CLIENTE
mCOGNOME   := ""
mGRUPOEMP  := ""
// zerando vari veis de trabalho.
mTOTS := 0
WHILE mFORNECEDO = CLIENTE .AND. ANO = nANOUSO .AND. MES = nMESUSO .AND. !Eof()
IF SEMNOTA = "S"
mTOTS += VALOR
ENDIF
dbSkip()
ENDDO
IF mTOTS > 0
dbSelectAr( "MA01" )
dbGoTop()
IF dbSeek( mFORNECEDO )
mCOGNOME  := COGNOME
mGRUPOEMP := GRUPOEMP
ENDIF
IF mTOTS > 0 .AND. AScan( aUFE, mFORNECEDO ) = 0
dbSelectAr( "APURA" )
netrecapp()
field->FORNECEDO := mFORNECEDO
field->COGNOME   := mCOGNOME
field->GRUPOEMP  := mGRUPOEMP
field->SERV      := mTOTS
field->TOTALMER  := mTOTS
field->TOTAL     := mTOTS
field->SERV2     := mTOTS
ENDIF
ENDIF
dbSelectAr( "APUSER" )
ENDDO
dbCloseAll()
ENDIF

@ 24, 00
@ 24, 05 SAY "Fazendo os C lculos da Apura‡„o de Vendas"
aGRAVA := {}

IF !USEREDE( "APURA", 0, 99 )
dbCloseAll()
RETU
ENDIF
dbGoTop()
mTOTMERC := mSUCATA1 + mVALPRES   // Soma Sucata e Presta‡„o de Servicos
WHILE !Eof()
mTOTMERC += TOTALMER   // Soma as Notas Apuradas
dbSkip()
ENDDO
dbGoTop()
WHILE !Eof()
// Declara‡„o de vari veis
AAdd( aGRAVA, { FORNECEDO, COGNOME, GRUPOEMP, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } )
// 1         2          3   4 5 6 7 8 9 10 11 12 13 14 15
nPOS  := Len( aGRAVA )
mCOGN := COGNOME
WHILE mCOGN = COGNOME .AND. !Eof()
aGRAVA[ NPOS, 4 ] += PROD
aGRAVA[ NPOS, 5 ] += FERRA
aGRAVA[ NPOS, 6 ] += MOPROD
aGRAVA[ NPOS, 7 ] += MOFERRA
aGRAVA[ NPOS, 8 ] += TOTALMER
aGRAVA[ NPOS, 9 ] += total
aGRAVA[ NPOS, 10 ] += PROD2
aGRAVA[ NPOS, 11 ] += FERRA2
aGRAVA[ NPOS, 12 ] += MOPROD2
aGRAVA[ NPOS, 13 ] += MOFERRA2
aGRAVA[ NPOS, 14 ] += SERV
aGRAVA[ NPOS, 15 ] += SERV2
dbSkip()
ENDDO
ENDDO
dbCloseAll()

IF !USEREDE( "APURA2", 0, 99 )
dbCloseAll()
RETU
ENDIF
ZAP
FOR X := 1 TO Len( aGRAVA )
IF aGRAVA[ X, 9 ] > 0
netrecapp()
field->FORNECEDO := aGRAVA[ X, 1 ]
field->COGNOME   := aGRAVA[ X, 2 ]
field->GRUPOEMP  := aGRAVA[ X, 3 ]
field->PROD      := aGRAVA[ X, 4 ]
field->FERRA     := aGRAVA[ X, 5 ]
field->MOPROD    := aGRAVA[ X, 6 ]
field->MOFERRA   := aGRAVA[ X, 7 ]
field->TOTALMER  := aGRAVA[ X, 8 ]
field->TOTAL     := aGRAVA[ X, 9 ]
field->PROD2     := aGRAVA[ X, 10 ]
field->FERRA2    := aGRAVA[ X, 11 ]
field->MOPROD2   := aGRAVA[ X, 12 ]
field->MOFERRA2  := aGRAVA[ X, 13 ]
field->SERV      := aGRAVA[ X, 14 ]
field->SERV2     := aGRAVA[ X, 15 ]
field->PORCENTO  := PERC( TOTALMER, mTOTMERC )
ENDIF
NEXT X
dbCloseAll()

M_BM6A()

@ 24, 00
RETU

// + EOF: M_BM6.PRG

// + EOF: m_bm6.prg
// +
