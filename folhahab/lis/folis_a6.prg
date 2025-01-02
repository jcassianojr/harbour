// +--------------------------------------------------------------------
// +
// +    Programa  : folis_a6.prg Gerar Arquivo para RAIS
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
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"
#include "BOX.CH"

function folis_a6()
CABE2( 'Preparar Arquivo para Rais' )
IF !MDG( 'Voce ja conferiu o Cadastro Empresas, estao OK.' )
FOLIS_D2()
RETU
ENDIF
IF !MDG( 'Voce ja conferiu o Cadastro Funcionarios, estao OK.' )
FOLIS_D1( 1 )
RETU
ENDIF
IF !MDG( 'Voce ja acumulou Rais' )
FOLIS_A3()
RETU
ENDIF
IF !MDG( 'Voce ja conferiu o Acumulo Rais, est„o OK.' )
FOLIS_D1( 2 )
RETU
ENDIF


// Variaveis de Trabalho
ANOBASE := Year( DXDIA )
RAISARQ := "C:\FOLHA\RAIS" + StrZero( ANOBASE, 4 ) + ".TXT              "
GERA    := Date()
SEQ     := 1
FILTRO  := ""
INX     := ""
xrRET   := "2"



IF !netuse( "firma" )
RETU .F.
ENDIF
dbGoTop()
IF !dbSeek( NREMP )
dbCloseAll()
ALERTX( "Falta Cadastro Empresa" )
RETU
ENDIF
xrCGC      := CGC
xrNOME     := RAZAO
xrBAIRRO   := BAIRRO
xrCEP      := CEP
mNAT       := NAT_ESTAB
xrCODIBGE  := CODIBGE
xrCIDADE   := CIDADE
xrESTADO   := ESTADO
xrDDD      := StrTran( DDD, " ", "" )
xrDDD      := StrTran( xrDDD, "0", "" )
xrDDD      := PadR( Left( xrDDD, 2 ), 2 )
xrTEL      := TELEFONE
xPTOREP    := ""
xrPESSOA   := PESSOA
xrCEI      := CEI
mEMAIL     := EMAIL
mPAT       := PAT
mPATMENOS  := mPATMAIS := 0
nPER01     := nPER02 := nPER03 := nPER04 := nPER05 := nPER06 := 0
mRESPONSAV := RESPONSAV
mCPFRESP   := CPFRESP
xrDNRESP   := DNRESP
xCNPJPAT   := REPL( "0", 14 )
xCNPJCON   := REPL( "0", 14 )
xCNPJASS   := REPL( "0", 14 )
xCNPJSIN   := REPL( "0", 14 )
xVALPAT    := 0.00
xVALCON    := 0.00
xVALASS    := 0.00
xVALSIN    := 0.00
DO CASE
CASE PAT = "S"
mPAT := "1"
OTHERWISE
mPAT := "2"
ENDCASE
mPORTE := PORTE
DO CASE
CASE mPORTE = "S"
mPORTE := "1"
CASE mPORTE = "N"
mPORTE := "2"
CASE mPORTE = "0"
mPORTE := "3"
OTHERWISE
mPORTE := "3"
ENDCASE
mSIMPLES := "N"
DO CASE   // Simples 1/2 Diferente Rais/Informe/Dirf/Sefip
CASE SIMPLES = "N" .OR. SIMPLES = "1"
mSIMPLES := "2"
CASE SIMPLES = "S" .OR. SIMPLES = "2" .OR. SIMPLES = "3" .OR. SIMPLES = "4"
mSIMPLES := "1"
ENDCASE
mRAISNEG := RAISNEG
dbCloseAll()

IF Empty( MRAISNEG )
mRAISNEG := "0"
ENDIF
mENCERRA := "2"
mDEND    := ZDATA
IF Empty( mSIMPLES )
mSIMPLES := "2"
ENDIF
dbCloseAll()




IF !netuse( "BCOFGTS" )
RETU .F.
ENDIF
dbGoTop()
IF !dbSeek( NREMP )
dbCloseAll()
ALERTX( "Falta Cadastro Detalhes Empresa" )
RETU
ENDIF
xrEND := ENDERECO
xrNUM := StrZero( Val( NUMEROEMP ), 6 )
xrCOM := COMPLEMEN
dbCloseAll()

xrDATA := Date()

xEXERCE := "1"
xEMPSIN := "1"
mCGCCEN := REPL( "0", 14 )

hb_DispBox( 4, 0, 23, 79, B_DOUBLE )
@  4, 2  SAY "CGC" + spac( 17 ) + "Nome"
@  4, 65 SAY "CGC-CENT"
@  6, 2  SAY "eMAIL"
@  7, 2  SAY "End.:" + spac( 31 ) + "No.       Complemento"
@  8, 2  SAY "Bairro" + spac( 10 ) + "Cep" + spac( 7 ) + "Cod.Mu. Cidade" + spac( 10 ) + "UF  DDD Telefone"
@ 10, 2  SAY "Patronal      CNPJ:" + Space( 15 ) + "Valor:"
@ 10, 52 SAY "Sindicalizada  1(Sim)2(Nao)"
@ 11, 2  SAY "Confederativa CNPJ:" + Space( 15 ) + "Valor:"
@ 12, 2  SAY "Assistencial  CNPJ:" + Space( 15 ) + "Valor:"
@ 13, 2  SAY "Sindical      CNPJ:" + Space( 15 ) + "Valor:"
@ 14, 02 SAY "Ano Base      Gera‡„o         Arquivo"
@ 15, 2  SAY "Encerramento Atividade    1(Sim) 2(Nao)"
@ 15, 68 SAY "Tipo Relogio:"
@ 16, 2  SAY "Declaracao Retificacao    1(Retificada)  2(Normal 1¦Entrega)"
@ 17, 2  SAY "Rais Negativa             0(Nao-Com Empregados) 1(Sim-Sem Empregados)"
@ 18, 2  SAY "Responsavel:" + spac( 42 ) + "CPF:"
@ 19, 2  SAY "Porte:  1(Micro)2(Pequeno Porte)3(Outros) Data Nasc Resp:" // 2011 recibo fixo 1
@ 20, 2  SAY "Simples  :  1(Sim) 2(Nao)"
@ 20, 28 SAY "Atividade:  1(Sim) 2(Nao)  Codigo:"
@ 21, 2  SAY "PAT                       1(Sim) 2(Nao) N§<5SalMin       N§>5SalMin"
@ 22, 2  SAY "%Ser.Pro"
@ 22, 15 SAY "%Adm.Coz"
@ 22, 28 SAY "%Ref.Con"
@ 22, 41 SAY "%Ref.Tra"
@ 22, 54 SAY "%Ref Ces"
@ 22, 67 SAY "%Alm.Con"
SET KEY K_F11 TO TECLAF11
@  5, 2  GET xrCGC
@  5, 21 GET xrNOME
@  5, 65 GET mCGCCEN
@  6, 08 GET mEMAIL                                        VALID checkemail( mEMAIL )
@  7, 7  GET xrEND
@  7, 41 GET xrNUM
@  7, 60 GET xrCOM
@  9, 2  GET xrBAIRRO
@  9, 18 GET xrCEP                                         PICTURE "99999-999"
@  9, 28 GET xrCODIBGE
@  9, 36 GET xrCIDADE
@  9, 52 GET xrESTADO                                      PICTURE "!!"
@  9, 56 GET xrDDD
@  9, 61 GET xrTEL // PICTURE "9999-9999" tirado mascara t
@ 10, 21 GET xCNPJPAT
@ 10, 43 GET xvalPAT                                       PICTURE "9999999.99"
@ 10, 66 GET xEMPSIN                                       PICT "!"                                                              VALID XEMPSIN $ "12"
@ 10, 78 GET xPTOREP                                       PICT "99"
@ 11, 21 GET xCNPJCON
@ 11, 43 GET xvalCON                                       PICTURE "9999999.99"
@ 12, 21 GET xCNPJASS
@ 12, 43 GET xvalASS                                       PICTURE "9999999.99"
@ 13, 21 GET xCNPJSIN
@ 13, 43 GET xvalSIN                                       PICTURE "9999999.99"
@ 14, 10 GET ANOBASE                                       PICT "9999"
@ 14, 23 GET GERA
@ 14, 40 GET RAISARQ
@ 15, 25 GET mENCERRA                                      PICT "!"                                                              VALID mENCERRA $ "12"
@ 15, 45 GET mDEND
@ 16, 25 GET xrRET                                         PICT "!"                                                              VALID xrRET $ "12"
@ 16, 64 GET xRDATA
@ 17, 25 GET mRAISNEG                                      PICT "!"                                                              VALID mRAISNEG $ "01"
@ 18, 15 GET mRESPONSAV
@ 18, 61 GET mCPFRESP                                      PICT "999.999.999-99"                                                 VALID VALCPF( mCPFRESP )
@ 19, 08 GET mPORTE                                        PICT "!"                                                              VALID mPORTE $ "123"
@ 19, 61 GET xrDNRESP
@ 20, 12 GET mSIMPLES                                      PICT "!"                                                              VALID mSIMPLES $ "12"
@ 20, 38 GET xEXERCE                                       PICT "!"                                                              VALID xEXERCE $ "12"
@ 20, 62 GET mNAT                                          VALID VERSEHA( "RAISNATJ",, mNAT, "NOME", "'Natureza Juridica Invalida'" )
@ 21, 25 GET mPAT                                          PICT "!"                                                              VALID mPAT $ "12"
@ 21, 52 GET mPATMENOS                                     PICT "999999"
@ 21, 70 GET mPATMAIS                                      PICT "999999"
@ 22, 11 GET nPER01                                        PICT "999"
@ 22, 24 GET nPER02                                        PICT "999"
@ 22, 37 GET nPER03                                        PICT "999"
@ 22, 50 GET nPER04                                        PICT "999"
@ 22, 63 GET nPER05                                        PICT "999"
@ 22, 75 GET nPER06                                        PICT "999"
IF !READCUR()
SET KEY K_F11
RETURN .F.
ENDIF
SET KEY K_F11

RAISARQ := AllTrim( RAISARQ )

USO := FCreate( RAISARQ )   // ABRINDO ARQUIVO
IF FError() # 0
ALERTX( "Erro na CriaCAo do Arquivo" )
RETU
ENDIF
lPRIMA := .T.
mFUN   := 0

IF !NETUSE( "FIRMA" )
RETU
ENDIF
dbGoTop()
IF dbSeek( NREMP )
mRZA := PadR( TIRACE( Upper( RAZAO ) ), 52 )
mEND := TIRACE( Upper( ENDERECO ) + SPAC( 20 ) )
mBAI := PadR( TIRACE( Upper( BAIRRO ) + SPAC( 4 ) ), 19 )
mMUN := TIRACE( Upper( CIDADE ) + SPAC( 15 ) )
mUFE := TIRACE( Upper( ESTADO ) )
mCEP := SubStr( CEP, 1, 5 ) + SubStr( CEP, 7 )
mATI := SubStr( ATIVIDADE, 1, 7 )
mPRO := NR_SOCIOS
mFAM := NR_FAMILIA
tCGC := CGC
IF PESSOA = 'J'
mCGC := SubStr( tCGC, 1, 2 ) + SubStr( tCGC, 4, 3 ) + SubStr( tCGC, 8, 3 ) + SubStr( tCGC, 12, 4 ) + SubStr( tCGC, 17, 2 )
mINC := "1"   // INDICA CGC
ELSE
mCGC := "00" + CEI
mINC := "3"   // INDICA CEI
ENDIF
ELSE
dbCloseArea()
ALERTX( "Cheque Cadastro Empresa" )
ENDIF
mALTINS  := ALTINS
mTIPINS  := TIPINS
mALTEND  := ALTEND
mPAG01   := PAG01
mPAG02   := PAG02
mPAG03   := PAG03
mPAG04   := PAG04
mPAG05   := PAG05
mCGCANT  := CGCANT
mCGCANT  := StrTran( mCGCANT, "/", "" )
mCGCANT  := StrTran( mCGCANT, ".", "" )
mCGCANT  := StrTran( mCGCANT, "-", "" )
mCGCANT  := StrTran( mCGCANT, " ", "" )
mCODIBGE := CODIBGE
mDBASE   := DBASE
mTEL     := StrTran( TELEFONE, "-", "" )
mTEL     := StrTran( mTEL, " ", "0" )
mTEL     := StrZero( Val( mTEL ), 8 )
mDDD     := StrTran( DDD, "0", "" )
mDDD     := StrTran( mDDD, " ", "" )
mDDD     := StrZero( Val( DDD ), 2 )
dbCloseArea()

IF !NETUSE( "BCOFGTS" )
RETU
ENDIF
dbGoTop()
IF dbSeek( NREMP )
mXNOM := PadR( Upper( ENDERECO ), 40 )
mXNUM := StrZero( Val( NUMEROEMP ), 6 )
mXCOM := PadR( Upper( COMPLEMENT ), 21 )
ELSE
dbCloseArea()
ALERTX( "Cheque Cadastro Empresa" )
ENDIF
dbCloseArea()

SetColor( "W/N,N/W" )
// Registro tipo zero CabeCario So uma vez
IF lPRIMA
mrXEND := PadR( Upper( xrEND ), 40 )
mrXNUM := PadR( Upper( xrNUM ), 6 )
mrXCOM := PadR( Upper( xrCOM ), 21 )
mrXTEL := StrTran( xrTEL, "-", "" )
mrXTEL := StrTran( mrXTEL, " ", "0" )
mrXTEL := StrZero( Val( mrxTEL ), 9 )   // 2012 9 digitos 2011 8 digitos
mrXDDD := StrZero( Val( XRDDD ), 2 )
xmRZA  := PadR( TIRACE( Upper( xrNOME ) + SPAC( 20 ) ), 40 )
xmBAI  := PadR( TIRACE( Upper( xrBAIRRO ) + SPAC( 4 ) ), 19 )
xmMUN  := PadR( TIRACE( Upper( xrCIDADE ) ), 30 )
xmUFE  := TIRACE( Upper( xrESTADO ) )
xmCEP  := SubStr( xrCEP, 1, 5 ) + SubStr( xrCEP, 7 )
xtCGC  := xrCGC
// xMAIL:=PADR(TIRACE(UPPER(mEMAIL)),39)
// aumento 45 rais2003
xMAIL := PadR( TIRACE( Upper( mEMAIL ) ), 45 )
IF xRPESSOA = 'J'
xmCGC := SubStr( xtCGC, 1, 2 ) + SubStr( xtCGC, 4, 3 ) + SubStr( xtCGC, 8, 3 ) + SubStr( xtCGC, 12, 4 ) + SubStr( xtCGC, 17, 2 )
xmINC := "1"  // INDICA CGC
ELSE
IF Empty( xRCEI )
xmCGC := StrTran( xtCGC, ".", "" )
xmCGC := StrTran( xmCGC, "-", "" )
xmCGC := StrTran( xmCGC, " ", "" )
xmCGC := StrZero( Val( xmCGC ), 14 )
xmINC := "4"   // INDICA CPF
ELSE
xmCGC := "00" + xRCEI
xmINC := "3"   // INDICA CEI
ENDIF
ENDIF
mXRDATA   := StrZero( Day( xrDATA ), 2 ) + StrZero( Month( xrDATA ), 2 ) + StrZero( Year( xrDATA ), 4 )
mXRDNRESP := StrZero( Day( xrDNRESP ), 2 ) + StrZero( Month( xrDNRESP ), 2 ) + StrZero( Year( xrDDNRESP ), 4 )
xGERA     := StrZero( Day( GERA ), 2 ) + StrZero( Month( GERA ), 2 ) + StrZero( Year( GERA ), 4 )
FWrite( USO, StrZero( SEQ, 6 ) )
FWrite( USO, XMCGC )
FWrite( USO, "00" )
FWrite( USO, "0" )
FWrite( USO, "1" )
FWrite( USO, XMCGC )
FWrite( USO, xmINC )
FWrite( USO, xmRZA )
FWrite( USO, mrXEND )
FWrite( USO, mrXNUM )
FWrite( USO, mrXCOM )
FWrite( USO, xmBAI )
FWrite( USO, xmCEP )
FWrite( USO, xrCODIBGE )
FWrite( USO, xmMUN )
FWrite( USO, xmUFE )
FWrite( USO, mrXDDD )
FWrite( USO, mrXTEL )
FWrite( USO, xrRET )
FWrite( USO, IF( xrRET = "1", mxrDATA, "00000000" ) )
FWrite( USO, xGERA )
FWrite( USO, xMAIL )
FWrite( USO, PadR( mRESPONSAV, 52 ) )
FWrite( USO, Space( 24 ) )  // FWRITE(USO,SPACE(20))
// FWRITE(USO,"0551")
FWrite( USO, StrZero( Val( TIRAOUT( mCPFRESP ) ), 11 ) )
FWrite( USO, StrZero( 0, 12 ) )  // CREA
FWrite( USO, mxrDNRESP )
FWrite( USO, repl( " ", 159 ) )  // FWRITE(USO,repl(" ",160)) um a menos 8/9 digitos telefone 2012
FWrite( USO, Chr( 13 ) + Chr( 10 ) )
SEQ++
lPRIMA := .F.
ENDIF

// Registro Tipo 1 Empresa
FWrite( USO, StrZero( SEQ, 6 ) )
FWrite( USO, mCGC )
FWrite( USO, "00" )
FWrite( USO, "1" )
FWrite( USO, PadR( mRZA, 52 ) )
FWrite( USO, mXNOM )
FWrite( USO, mXNUM )
FWrite( USO, mXCOM )
FWrite( USO, mBAI )
FWrite( USO, mCEP )
FWrite( USO, mCODIBGE )
FWrite( USO, PadR( mMUN, 30 ) )
FWrite( USO, PadR( mUFE, 2 ) )
FWrite( USO, mDDD )
FWrite( USO, mTEL )
FWrite( USO, xMAIL )
FWrite( USO, mATI )
FWrite( USO, mNAT )
FWrite( USO, StrZero( mPRO, 2 ) )
FWrite( USO, StrZero( mDBASE, 2 ) )
FWrite( USO, mINC )  // 1=CGC 3=CEI
FWrite( USO, mRAISNEG )
FWrite( USO, "00" )  // Zeros
FWrite( USO, REPL( "0", 12 ) )
FWrite( USO, StrZero( ANOBASE, 4 ) )
FWrite( USO, mPORTE )
FWrite( USO, mSIMPLES )
FWrite( USO, mPAT )
FWrite( USO, StrZero( mPATMENOS, 6 ) )
FWrite( USO, StrZero( mPATMAIS, 6 ) )
FWrite( USO, StrZero( nPER01, 3 ) )
FWrite( USO, StrZero( nPER02, 3 ) )
FWrite( USO, StrZero( nPER03, 3 ) )
FWrite( USO, StrZero( nPER04, 3 ) )
FWrite( USO, StrZero( nPER05, 3 ) )
FWrite( USO, StrZero( nPER06, 3 ) )
FWrite( USO, mENCERRA )
FWrite( USO, IF( mENCERRA = "1", mDEND, "00000000" ) )
FWrite( USO, XCNPJPAT )  // cnpj entidade patronal
FWrite( USO, GRVVAL( XVALPAT, 9, 2 ) )   // valor entidade patronal
FWrite( USO, XCNPJSIN )  // cnpj entidade contribuicao sindical
FWrite( USO, GRVVAL( XVALSIN, 9, 2 ) )   // valor entidade contribuicao sindical
FWrite( USO, XCNPJASS )  // cnpj entidade contribuicao assistencial
FWrite( USO, GRVVAL( XVALASS, 9, 2 ) )   // valor entidade contribuicao assistencial
FWrite( USO, XCNPJCON )  // cnpj entidade contribuicao confederativa
FWrite( USO, GRVVAL( XVALCON, 9, 2 ) )   // valor entidade contribuicao confederativa
FWrite( USO, xEXERCE )   // Exerceu atividade
FWrite( uso, mCGCCEN )   // cnpj centralizadora
FWrite( uso, XEMPSIN )   // sindicalizada 1sim 2ano
FWrite( uso, xPTOREP )   // TIPO REp
FWrite( uso, repl( " ", 85 ) )  // Brancos
FWrite( USO, StrZero( NREMP, 12 ) )   // Codigo da Empresa
FWrite( USO, Chr( 13 ) + Chr( 10 ) )   // FECHAR LINHA

SEQ++
PATHRE := hb_cwd() + 'EMP' + ANOWORK + StrZero( NREMP, 3 ) + "\"
IF NRSEN <> 'DiReT'
PESRE   := PATHRE + 'FO_PES'
FOLRE   := 'FP' + EMP + ARQMES
ARQRAIS := PATHRE + 'FORAIS'
ELSE
PESRE   := PATHRE + 'FO_DIR'
FOLRE   := 'SO' + EMP + ARQMES
ARQRAIS := PATHRE + 'FORAISD'
ENDIF

IF !NETUSE( PESRE )
dbCloseAll()
FClose( USO )
RETU .F.
ENDIF
FILTRO   := 'EMPTY(DEMITIDO) .OR. YEAR(DEMITIDO)=ANOBASE'
FILFUN   := FILTRO( FILTRO )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "pis" )  // eval zei_fort(nLASTREC,,,1)
ordSetFocus( "temp" )
SET FILTER TO &FILFUN

IF !NETUSE( ARQRAIS )
dbCloseAll()
RETU .F.
ENDIF

dbSelectAr( PESRE )
dbGoTop()
WHILE !Eof()
PETELA( 8 )
mNUMERO := NUMERO
mPIS    := PIS
mNOM    := TIRACE( Upper( NOME ) )
mCTP    := IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, StrZero( Val( TIRAOUT( CPF ) ), 13 ), StrZero( Val( PROFIS ), 8 ) + StrZero( Val( SERIE ), 5 ) )
mNSC    := StrZero( Day( NASC ), 2 ) + StrZero( Month( NASC ), 2 ) + StrZero( Year( NASC ), 4 )
mADM    := StrZero( Day( ADMITIDO ), 2 ) + StrZero( Month( ADMITIDO ), 2 ) + StrZero( Year( ADMITIDO ), 4 )
tFGTS   := DToC( FGTS )
mFGT    := SUBST( tFGTS, 4, 2 ) + SubStr( tFGTS, 7, 2 )

// Rais 2003 Cbo Novo
// mCBO=SUBSTR(CBO,1,5)

mCBO  := OBTER( "FUNCAO",, FUNCAO, "CBONEW" )  // CBONEW CBONEW
mRACA := OBTER( "FO_TAB",, "RACS" + AllTrim( Str( RACS ) ), "CODIG2" )
mDEFI := IF( Empty( DEFICI ), "0", DEFICI )
IF mDEFI = "S"
mDEFI := "9"  // forca preenchimento valores validos 1-6
ENDIF
IF mDEFI = "N"
mDEFI := "0"
ENDIF
mSEXO := IF( SEXO = "M", "1", "2" )
mSIND := IF( Empty( SOCIOSIND ), "N", SOCIOSIND )
mSIND := IF( mSIND = "N", "2", "1" )

mESC := ESCRAIS  // STRZERO(ESCOLA,2)
IF mESC = "10"
mESC := "09"
ENDIF
IF mESC = "11"
mESC := "10"
ENDIF
IF mESC = "12"
mESC := "11"
ENDIF


mTIP := TIPO
mNAC := BacenNacion( NASCPAIS )
mNAC := StrZero( mNAC, 2 )  // layout ainda 2
mCHE := IF( mNAC # "10", StrZero( ANONASCI, 4 ), "0000" )

IF Empty( DEMITIDO )
tSAL := SALDEZ
ELSE
MESDEM := Month( DEMITIDO )
XSAL   := MMES( Month( DEMITIDO ) )
XSAL   := SubStr( XSAL, 1, 3 )
XSAL   := 'SAL' + XSAL
tSAL   := &XSAL
ENDIF
tSAL := StrZero( tSAL, 10, 2 )
mSAL := StrTran( tSAL, ".", "" )
mHOR := StrZero( HRSEM, 2 )

tDEM := DToC( DEMITIDO )
mDEM := IF( Empty( DEMITIDO ), '0000', SUBST( tDEM, 1, 2 ) + SubStr( tDEM, 4, 2 ) )
mCPF := StrTran( CPF, ".", "" )
mCPF := StrTran( mCPF, "-", "" )
mCPF := StrTran( mCPF, " ", "" )
mCPF := StrZero( Val( mCPF ), 11 )

dbSelectAr( "FORAIS" )
dbGoTop()
IF dbSeek( Str( ANOUSO, 4 ) + Str( mNUMERO, 8 ) )
mVIN     := RAISVINC
mSIT     := RAISSITU
mMOT     := IF( Empty( RAISDEM ), '00', RAISDEM )
mALVARA  := IF( Empty( ALVARA ), "N", ALVARA )
mALVARA  := IF( mALVARA = "N", "2", "1" )
mTIPOADM := TIPOADM
m13B     := StrZero( MES_1, 2 )
m13D     := StrZero( MES_2, 2 )
// mNES    = STRZERO(AVOSM,2)
m13A    := GRVVAL( SAL13_1, 9, 2 )
m13C    := GRVVAL( SAL13_2, 9, 2 )
mJAN    := GRVVAL( RAIZJAN, 9, 2 )
mFEV    := GRVVAL( RAIZFEV, 9, 2 )
mMAR    := GRVVAL( RAIZMAR, 9, 2 )
mABR    := GRVVAL( RAIZABR, 9, 2 )
mMAI    := GRVVAL( RAIZMAI, 9, 2 )
mJUN    := GRVVAL( RAIZJUN, 9, 2 )
mJUL    := GRVVAL( RAIZJUL, 9, 2 )
mAGO    := GRVVAL( RAIZAGO, 9, 2 )
mSET    := GRVVAL( RAIZSET, 9, 2 )
mOUT    := GRVVAL( RAIZOUT, 9, 2 )
mNOV    := GRVVAL( RAIZNOV, 9, 2 )
mDEZ    := GRVVAL( RAIZDEZ, 9, 2 )
mAVISO  := GRVVAL( RAIZAVI, 9, 2 )
lGRAVA  := .T.
TOTRAIZ := RAIZJAN + RAIZFEV + RAIZMAR + RAIZABR + RAIZMAI + RAIZJUN
TOTRAIZ := TOTRAIZ + RAIZJUL + RAIZAGO + RAIZSET + RAIZOUT + RAIZNOV + RAIZDEZ
TOTRAIZ := TOTRAIZ + SAL13_1 + SAL13_2 + RAIZAVI
IF TOTRAIZ = 0
IF MDG( "Funcionário sem Remuneração - Excluir Rais" )
lGRAVA := .F.
ENDIF
ENDIF
IF lGRAVA
FWrite( USO, StrZero( SEQ, 6 ) )
FWrite( USO, mCGC )
FWrite( USO, "00" )
FWrite( USO, '2' )
FWrite( USO, mPIS )
FWrite( USO, PadR( mNOM, 52 ) )
FWrite( USO, mNSC )
FWrite( USO, mNAC )
FWrite( USO, mCHE )
FWrite( USO, mESC )
FWrite( USO, mCPF )
FWrite( USO, mCTP )
FWrite( USO, mADM )
FWrite( USO, PadR( mTIPOADM, 2 ) )
FWrite( USO, mSAL )
FWrite( USO, mTIP )
FWrite( USO, mHOR )
FWrite( USO, mCBO )
FWrite( USO, mVIN )
FWrite( USO, mMOT )
FWrite( USO, mDEM )

FWrite( USO, mJAN )
FWrite( USO, mFEV )
FWrite( USO, mMAR )
FWrite( USO, mABR )
FWrite( USO, mMAI )
FWrite( USO, mJUN )
FWrite( USO, mJUL )
FWrite( USO, mAGO )
FWrite( USO, mSET )
FWrite( USO, mOUT )
FWrite( USO, mNOV )
FWrite( USO, mDEZ )
FWrite( USO, m13A )
FWrite( USO, m13B )
FWrite( USO, m13C )
FWrite( USO, m13D )

FWrite( USO, mRACA )
FWrite( USO, IF( mDEFI = "0", "2", "1" ) )  // 0 sem deficiencia 1=sim 2=nao
FWrite( USO, mDEFI )  // Codigo da deficiencia
FWrite( USO, mALVARA )
FWrite( USO, mAVISO )
FWrite( USO, mSEXO )

// Incluido Afastamentos Rais 2003
// 1Ý
FWrite( USO, StrZero( Val( CODAFA01 ), 2 ) )
FWrite( USO, StrZero( Val( INIAFA01 ), 4 ) )
FWrite( USO, StrZero( Val( FIMAFA01 ), 4 ) )
// 2Ý
FWrite( USO, StrZero( Val( CODAFA02 ), 2 ) )
FWrite( USO, StrZero( Val( INIAFA02 ), 4 ) )
FWrite( USO, StrZero( Val( FIMAFA02 ), 4 ) )
// 3Ý
FWrite( USO, StrZero( Val( CODAFA03 ), 2 ) )
FWrite( USO, StrZero( Val( INIAFA03 ), 4 ) )
FWrite( USO, StrZero( Val( FIMAFA03 ), 4 ) )
// Qtde Dias
FWrite( USO, StrZero( DIASAFA, 3 ) )


FWrite( USO, GRVVAL( RAIZFER, 8, 2 ) )  // ferias indenizadas

FWrite( USO, GRVVAL( RAIZBCH, 8, 2 ) )  // banco de horas
FWrite( uso, StrZero( MESBCH, 2 ) )  // qtde competencias

FWrite( USO, GRVVAL( RAIZACR, 8, 2 ) )  // acrescimo categoria
FWrite( uso, StrZero( MESACR, 2 ) )  // qtde competencias

FWrite( USO, GRVVAL( RAIZGRA, 8, 2 ) )  // gratificacoes
FWrite( uso, StrZero( MESGRA, 2 ) )  // qtde competencias

FWrite( USO, GRVVAL( RAIZMUL, 8, 2 ) )  // multa fgts


// 1a Ocorrencia
FWrite( USO, StrZero( Val( CGCSOC1 ), 14 ) )   // cnpj entidade contribuicao associativa
FWrite( USO, GRVVAL( VALSOC1, 8, 2 ) )  // valor entidade contribuicao associativa
// 2a Ocorrencia
FWrite( USO, StrZero( Val( CGCSOC2 ), 14 ) )   // cnpj entidade contribuicao associativa
FWrite( USO, GRVVAL( VALSOC2, 8, 2 ) )  // valor entidade contribuicao associativa
// contibuicao sindical
FWrite( USO, StrZero( Val( CGCSIN ), 14 ) )  // cnpj
FWrite( USO, GRVVAL( VALSIN, 8, 2 ) )   // valor
// contibuicao assistencial
FWrite( USO, StrZero( Val( CGCASS ), 14 ) )  // cnpj
FWrite( USO, GRVVAL( VALASS, 8, 2 ) )   // valor
// contibuicao confederativa
FWrite( USO, StrZero( Val( CGCCON ), 14 ) )  // cnpj
FWrite( USO, GRVVAL( VALCON, 8, 2 ) )   // valor

// codigo municipio servicos
FWrite( USO, StrZero( Val( IBGECOD ), 7 ) )  // valor

// horas trabalhadas
FWrite( USO, StrZero( horjan, 3 ) )  // jan
FWrite( USO, StrZero( horfev, 3 ) )  // fev
FWrite( USO, StrZero( hormar, 3 ) )  // mar
FWrite( USO, StrZero( horabr, 3 ) )  // abr
FWrite( USO, StrZero( hormai, 3 ) )  // mai
FWrite( USO, StrZero( horjun, 3 ) )  // jun
FWrite( USO, StrZero( horjul, 3 ) )  // jul
FWrite( USO, StrZero( horago, 3 ) )  // ago
FWrite( USO, StrZero( horset, 3 ) )  // set
FWrite( USO, StrZero( horout, 3 ) )  // out
FWrite( USO, StrZero( hornov, 3 ) )  // nov
FWrite( USO, StrZero( hordez, 3 ) )  // dez

FWrite( USO, mSIND )  // Sindicalizado 1 sim 2 nao
FWrite( USO, StrZero( mNUMERO, 6 ) )
FWrite( USO, StrZero( NREMP, 6 ) )
FWrite( USO, Chr( 13 ) + Chr( 10 ) )  // FECHAR LINHA
mFUN++
SEQ++
ENDIF
ENDIF
dbSelectAr( PESRE )
dbSkip()
ENDDO
dbCloseArea()


// Encerramento do Arquivo  9
FWrite( USO, StrZero( SEQ, 6 ) )  // 06
FWrite( USO, mCGC )  // 14
FWrite( USO, "00" )  // 02
FWrite( USO, "9" )   // 01
FWrite( USO, StrZero( 1, 6 ) )  // 06
FWrite( USO, StrZero( mFUN, 6 ) )   // 06
FWrite( USO, Space( 516 ) )  // 515
FWrite( USO, Chr( 13 ) + Chr( 10 ) )   // FECHAR LINHA
FWrite( USO, Chr( 26 ) )   // FECHAMENTO ARQUIVO
FClose( USO )

IF MDG( "Deseja Ver o Arquivo" )
VERTXT( RAISARQ )
ENDIF
IF MDG( "Deseja imprimir o Arquivo" )
imparq( RAISARQ,,,,,,, 550, )
ENDIF

ALERTX( "NAo EsqueCa de Utilizar o Validador/Importador" )

RETUrn




// + EOF: folis_a6.prg
// +
