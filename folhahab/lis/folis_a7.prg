// +--------------------------------------------------------------------
// +
// +    Programa  : folis_a7.prg  Preparar Arquivo DIRF
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
// +
// +--------------------------------------------------------------------
// +

function folis_a7()
CABE2( 'Criar Arquivo para DIRF ' )
IF !MDG( 'Voce ja conferiu o Cadastro Funcionarios, estao OK.' )
FOLIS_D1()
RETU
ENDIF
IF !MDG( 'Vocˆ j  acumulou Informe, e Depois DIRF' )
RETU
ENDIF
IF !MDG( 'Vocˆ j  conferiu o Acumulo DIRF, est„o OK.' )
RETU
ENDIF

nACU := IRRESC()

GRAVA1     := "S"
mrXTEL     := mrXDDD := mrXFAX := ""
xrCGC      := xrNOME := ""
xrDDD      := xrTEL := xrPESSOA := ""
xrRESN     := xrRESC := xrFAX := xrRAMAL := mNOME := mNRCLIEN := ""
mEMAIL     := CPFCNPJ := ""
xNUMEROANT := Space( 12 )
ANO        := "2012"
ANOREF     := "2011"
ARQ        := "C:\FOLHA\DIRF2012.TXT" + Space( 30 )
ARQDET     := "C:\FOLHA\DETA2012.TXT" + Space( 30 )
OPER       := "O"
CODRET     := "0561"
SITU       := "1"
NATUR      := "0"
IDEN       := "0"


IF !DIRFEMPDAD()
RETU .F.
ENDIF

IF !DIRFPEGDAD()
RETU .F.
ENDIF


IF !Empty( ARQDET )
IF !MDG( "Voce ao imprimir Informe Gravou Arquivo de Detalhes" )
RETU .F.
ENDIF
ENDIF

ARQ := AllTrim( ARQ )

mCGC     := SubStr( xrCGC, 1, 2 ) + SubStr( xrCGC, 4, 3 ) + SubStr( xrCGC, 8, 3 )
mEST     := SubStr( xrCGC, 12, 4 ) + SubStr( xrCGC, 17, 2 )
mrCPF    := SubStr( xrRESC, 1, 3 ) + SubStr( xrRESC, 5, 3 ) + SubStr( xrRESC, 9, 3 ) + SubStr( xrRESC, 13, 2 )
mCPFCNPJ := SubStr( CPFCNPJ, 1, 3 ) + SubStr( CPFCNPJ, 5, 3 ) + SubStr( CPFCNPJ, 9, 3 ) + SubStr( CPFCNPJ, 13, 2 )


SEQ     := 1
aTOTREN := Array( 13 )
aTOTDED := Array( 13 )
aTOTIRR := Array( 13 )
AFill( aTOTREN, 0 )
AFill( aTOTDED, 0 )
AFill( ATOTIRR, 0 )
nREG02 := 0


IF !ARQIRR( nACU, 1, 3 )  // shared PES
RETU .F.
ENDIF

ordDestroy( "temp" )
ordCreate(, "temp", "cpf" )
ordSetFocus( "temp" )



cSELE1 := Alias()

IF !ARQIRR( nACU, 1, 1 )  // SHARED ajudir
dbCloseAll()
RETU .F.
ENDIF
cSELE2 := Alias()


// Criando o Arquivo
USO := FCreate( ARQ )
IF FError() # 0
ALERTX( "Erro na Cria‡„o do Arquivo" )
RETU
ENDIF
IF GRAVA1 = "S"
// Gravando Registro 01
DIRFREG01()
ENDIF

dbSelectAr( cSELE1 )
WHILE !Eof()
PETELA( 8 )
aREND := Array( 13 )   // 1
aDEDU := Array( 13 )   // 2
aIRRF := Array( 13 )   // 3
aPREV := Array( 13 )   // 4
aDEPE := Array( 13 )   // 5
aPENS := Array( 13 )   // 6
aPRIV := Array( 13 )   // 7


AFill( aREND, 0 )
AFill( aDEDU, 0 )
AFill( aIRRF, 0 )
AFill( aPREV, 0 )
AFill( aDEPE, 0 )
AFill( aPENS, 0 )
AFill( aPRIV, 0 )


mNOME   := NOME
mNUMERO := NUMERO
mCPF    := SubStr( CPF, 1, 3 ) + SubStr( CPF, 5, 3 ) + SubStr( CPF, 9, 3 ) + SubStr( CPF, 13, 2 )
cCPF    := CPF
GRAVA   := .F.
dbSelectAr( cSELE2 )
FOR X := 1 TO 13
BUSCA := cCPF + Str( X, 2 )
dbGoTop()
IF dbSeek( BUSCA )
GRAVA := .T.
aREND[ X ] = VALUF1
aDEDU[ X ] = VALUF2
aIRRF[ X ] = VALUF3
aPREV[ X ] = VALUF4
aDEPE[ X ] = VALUF5
aPENS[ X ] = VALUF6
aPRIV[ X ] = VALUF7
ENDIF
NEXT X
IF GRAVA
mPESSOA := "F"
USOCGC  := "000" + mCPF
DIRFREG02( "0" )
DIRFREG02( "1" )
DIRFREG02( "2" )
ENDIF
dbSelectAr( cSELE1 )
dbSkip()
ENDDO
dbCloseAll()


// Fechando o arquivo
FWrite( USO, Chr( 26 ) )
FClose( USO )

IF MDG( "Deseja Ver o Arquivo dirf" )
VERTXT( ARQ )
ENDIF
IF MDG( "Deseja imprimir o Arquivo dirf" )
imparq( ARQ,,,,,,, 730, )
ENDIF

ALERTX( "N„o Esque‡a de Utilizar o Validador" )

IF Empty( ARQDET )
RETU .F.
ENDIF
nSEQ := 1
IF !netuse( "IRRF" )  // AREDE("IRRF","IRRF",1)
dbCloseAll()
RETU .F.
ENDIF
// Criando o Arquivo Detalhes
USO := FCreate( ARQDET )
IF FError() # 0
ALERTX( "Erro na Cria‡„o do Arquivo" )
RETU
ENDIF
dbGoTop()
WHILE !Eof()
mCPF := SubStr( CPF, 1, 3 ) + SubStr( CPF, 5, 3 ) + SubStr( CPF, 9, 3 ) + SubStr( CPF, 13, 2 )
FWrite( USO, mCPF )
FWrite( USO, GRVVAL( V402, 15, 2 ) )  // Prev Oficial
FWrite( USO, GRVVAL( V403, 15, 2 ) )  // Prev Privada
FWrite( USO, GRVVAL( V404, 15, 2 ) )  // Pensao
FWrite( USO, GRVVAL( V502, 15, 2 ) )  // Aposentadoria
FWrite( USO, GRVVAL( V503, 15, 2 ) )  // Diarias
FWrite( USO, GRVVAL( V504, 15, 2 ) )  // invalidez
FWrite( USO, GRVVAL( V505, 15, 2 ) )  // lucro
FWrite( USO, GRVVAL( V506, 15, 2 ) )  // titulares
FWrite( USO, GRVVAL( V507, 15, 2 ) )  // Indenizacoes
FWrite( USO, ACEPAD( OBS02, 60 ) )   // Descricao Outros
nVAL := V611 - ( V612 + V617 + V614 )  // Saldo Outras
IF nVAL > 0
FWrite( USO, GRVVAL( nVAL, 15, 2 ) )
ELSE
FWrite( USO, GRVVAL( 0, 15, 2 ) )
ENDIF
FWrite( USO, ACEPAD( AllTrim( OBS03 ) + " " + AllTrim( OBS04 ) + " " + OBS05, 200 ) )  // Inf.Complementares
FWrite( USO, Chr( 13 ) + Chr( 10 ) )
nSEQ++
dbSkip()
ENDDO
dbCloseArea()
FWrite( USO, Chr( 26 ) )
FClose( USO )
IF MDG( "Deseja Ver o Arquivo Detalhes" )
VERTXT( ARQDET )
ENDIF
IF MDG( "Deseja imprimir o Arquivo Detalhes" )
imparq( ARQDET,,,,,,, 421, )
ENDIF
RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DIRFEMPDAD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC DIRFEMPDAD()

   IF !NETUSE( "FIRMA" )
      RETU .F.
   ENDIF
   dbGoTop()
   IF !dbSeek( NREMP )
      dbCloseAll()
      ALERTX( "Falta Cadastro Empresa" )
      RETU .F.
   ENDIF
   xrCGC    := CGC
   xrNOME   := ACEPAD( RAZAO, 60 )
   xrDDD    := DDD
   xrTEL    := TELEFONE
   xrPESSOA := PESSOA
   xrRESN   := ACEPAD( RESPONSAV, 60 )
   xrRESC   := CPFRESP
   CPFCNPJ  := CPFRESP
   xrFAX    := FAX
   xrRAMAL  := ACEPAD( RAMAL, 6 )
   mNRCLIEN := NRCLIEN
   mEMAIL   := ACEPAD( EMAIL, 50 )
   dbCloseAll()
   mrXTEL := StrTran( xrTEL, "-", "" )
   mrXTEL := StrTran( mrXTEL, " ", "0" )
   mrXTEL := StrZero( Val( mrxTEL ), 8 )
   mrXFAX := StrTran( xrFAX, "-", "" )
   mrXFAX := StrTran( mrXFAX, " ", "0" )
   mrXFAX := StrZero( Val( mrxFAX ), 8 )
   mrXDDD := StrZero( Val( XRDDD ), 4 )
   RETUrn .T.

// + EOF: folis_a7.prg
// +
