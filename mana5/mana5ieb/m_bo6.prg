// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bo6.prg
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

// +
// +
// +    Source Module => J:\ITAESBRA\M_BO6.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +

MDI( "þ Aviso de Embarque" )
PARA nTIPO

nNUMERO  := 0
mFATURA  := 0
nCLIENTE := 0
nDEC     := 0
nSEQ     := 0
cPLANTA  := "C1 "
cDOCA    := "B1" + Space( 12 )
cCAMINHO := ProfileString( "MANA5.INI", "PATH", "AVB", hb_cwd() + "\CDA\TXT\" ) + Space( 40 )  // "\CDA\TXT\" + space( 40 )
cTIME    := StrTran( Time(), ":", "" )
cENTREGA := SubStr( DToS( ZDATA + 1 ), 3 )

aRETU := PEGMES( { "M1", "M2" }, .T., { "MM01", "MM02" } )
xARQ  := aRETU[ 5, 1 ]
xAR2  := aRETU[ 5, 2 ]

cDATA := SubStr( DToS( ZDATA ), 3 )

IF nTIPO = 1  // GM
cASSUNTO := "GMB.AVISO.PROD" + Space( 60 )
ENDIF
IF nTIPO = 2  // FORD
cASSUNTO := "DUT.P5VFBR.RVS.ASN" + Space( 59 )
ENDIF

cTIPO := "P"

@ 10, 00 SAY "Digite o Numero da Nota Fiscal/ Fatura"
@ 11, 00 SAY "Digite o Numero Sequencial"
@ 12, 00 SAY "Digite o Codigo da Planta/Doca"
@ 13, 00 SAY "Caminho"
@ 14, 00 SAY "Assunto"
@ 15, 00 SAY "Tipo Fornecimento"
@ 16, 00 SAY "Data Hora:"
@ 17, 00 SAY "Entrega:"
@ 15, 22 SAY "(R)eposicao (P)roducao (E)xportacao (X)Outros (A)mostra"
@ 10, 40 GET nNUMERO                                                   VALID ALLTRUE( PEGACAMPO( xARQ, "nNUMERO", "FORNECEDO", "nCLIENTE" ) ) ;
      .AND. ALLTRUE( PEGACAMPO( "MA01", "nCLIENTE", { "PLANTA", "DOCA" }, { "cPLANTA", "cDOCA" } ) )
@ 10, 50 GET mFATURA
@ 11, 40 GET nSEQ
@ 12, 40 GET cPLANTA
@ 12, 50 GET cDOCA
@ 13, 15 GET cCAMINHO
@ 14, 20 GET cASSUNTO
@ 15, 20 GET cTIPO    PICT "!" VALID cTIPO $ "RPEXA"
@ 16, 20 GET cTIME
@ 16, 30 GET cDATA
@ 17, 20 GET cENTREGA
IF !READCUR()
RETU .F.
ENDIF

lCONV := MDG( "Converter Unidade" )

cARQ  := AllTrim( cCAMINHO ) + "AE" + StrZero( nSEQ, 5 ) + ".TXT"
cARQ2 := AllTrim( cCAMINHO ) + "MGR" + StrZero( nSEQ, 5 ) + ".ENV"

IF !USEREDE( xARQ, 1, 1 )
RETU .F.
ENDIF

dbSelectAr( xARQ )
dbGoTop()
IF !dbSeek( nNUMERO )
dbCloseAll()
ALERTX( "Nao achei Nota Fiscal" )
RETU .F.
ENDIF

IF !USEREDE( xAR2, 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
IF !lCONV   // Pegando casas
dbGoTop()
dbSeek( Str( nNUMERO, 8 ) )
WHILE NUMERO = nNUMERO .AND. !Eof()
DO CASE
CASE UNID = "CT"
nDEC := 2
CASE UNID = "ML"
nDEC := 3
ENDCASE
dbSkip()
ENDDO
ENDIF
IF !USEREDE( "MO01", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF

// Arquivo ENDV
nHANDLE := FCreate( AllTrim( cARQ2 ) )
IF FError() # 0
ALERTX( "Erro na Criacao do Arquivo" )
RETU
ENDIF
FWrite( nHANDLE, "AE" + StrZero( nSEQ, 5 ) + ".TXT" + Chr( 13 ) + Chr( 10 ) )
FWrite( nHANDLE, AllTrim( cASSUNTO ) + Chr( 13 ) + Chr( 10 ) )
IF nTIPO = 1  // GM
FWrite( nHANDLE, "27459" + Chr( 13 ) + Chr( 10 ) )
ENDIF
IF nTIPO = 2  // FORD
FWrite( nHANDLE, "41195" + Chr( 13 ) + Chr( 10 ) )
ENDIF

FWrite( nHANDLE, Chr( 26 ) )
FClose( nHANDLE )

nHANDLE := FCreate( AllTrim( cARQ ) )
IF FError() # 0
ALERTX( "Erro na Criacao do Arquivo" )
RETU
ENDIF
dbSelectAr( xARQ )
nREG := 0
// ITP
nREG++
FWrite( nHANDLE, "ITP" )
FWrite( nHANDLE, "004" )
FWrite( nHANDLE, "04" )
FWrite( nHANDLE, StrZero( nSEQ, 5 ) )
FWrite( nHANDLE, cDATA )
FWrite( nHANDLE, cTIME )
FWrite( nHANDLE, "61381323000167" )
IF nTIPO = 1  // GM
FWrite( nHANDLE, "59275792000150" )
ENDIF
IF nTIPO = 2  // FORD
FWrite( nHANDLE, "57290355001313" )
ENDIF
FWrite( nHANDLE, Space( 8 ) )
FWrite( nHANDLE, Space( 8 ) )
FWrite( nHANDLE, Space( 25 ) )
FWrite( nHANDLE, Space( 25 ) )
FWrite( nHANDLE, Space( 9 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
// AE1
nREG++
FWrite( nHANDLE, "AE1" )
IF Empty( mFATURA )
FWrite( nHANDLE, StrZero( nNUMERO, 6 ) )
ELSE
FWrite( nHANDLE, StrZero( mFATURA, 6 ) )
ENDIF
FWrite( nHANDLE, "    " )
FWrite( nHANDLE, SubStr( DToS( DATA ), 3 ) )  // MM01
FWrite( nHANDLE, "000" )
FWrite( nHANDLE, StrTran( StrZero( TOTNF, 18, 2 ), ".", "" ) )
IF !lCONV   // Casas decimais
FWrite( nHANDLE, Str( nDEC, 1 ) )
ELSE
FWrite( nHANDLE, "0" )
ENDIF
FWrite( nHANDLE, Left( OPERACAO, 3 ) )
FWrite( nHANDLE, StrTran( StrZero( TOTICM, 18, 2 ), ".", "" ) )
FWrite( nHANDLE, SubStr( DToS( DAT01 ), 3 ) )
FWrite( nHANDLE, "00" )
FWrite( nHANDLE, StrTran( StrZero( TOTIPI, 18, 2 ), ".", "" ) )
FWrite( nHANDLE, cPLANTA )
IF nTIPO = 1  // GM
FWrite( nHANDLE, "000000" )
ENDIF
IF nTIPO = 2  // FORD
FWrite( nHANDLE, cENTREGA )
ENDIF
FWrite( nHANDLE, Space( 4 ) )
FWrite( nHANDLE, Space( 30 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
// NF2 OPCIONAL
nREG++
FWrite( nHANDLE, "NF2" )
FWrite( nHANDLE, repl( "0", 17 ) )  // Despesas Acessorias
FWrite( nHANDLE, repl( "0", 17 ) )  // Valor do Frete
FWrite( nHANDLE, repl( "0", 17 ) )  // Valor do Seguro
FWrite( nHANDLE, repl( "0", 17 ) )  // Valor do Desconto
FWrite( nHANDLE, Space( 57 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
// NF3 OPCIONAL
nREG++
FWrite( nHANDLE, "NF3" )
FWrite( nHANDLE, repl( "0", 6 ) )   // 1a Data
FWrite( nHANDLE, repl( "0", 4 ) )   // Perc %
FWrite( nHANDLE, repl( "0", 6 ) )   // 2a Data
FWrite( nHANDLE, repl( "0", 4 ) )   // Perc %
FWrite( nHANDLE, repl( "0", 6 ) )   // 3a Data
FWrite( nHANDLE, repl( "0", 4 ) )   // Perc %
FWrite( nHANDLE, repl( "0", 6 ) )   // 4a Data
FWrite( nHANDLE, repl( "0", 4 ) )   // Perc %
FWrite( nHANDLE, repl( "0", 6 ) )   // 5a Data
FWrite( nHANDLE, repl( "0", 4 ) )   // Perc %
FWrite( nHANDLE, repl( "0", 6 ) )   // 6a Data
FWrite( nHANDLE, repl( "0", 4 ) )   // Perc %
FWrite( nHANDLE, Space( 65 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
dbSelectAr( xAR2 )
dbGoTop()
dbSeek( Str( nNUMERO, 8 ) )
WHILE NUMERO = nNUMERO .AND. !Eof()
// AE2
nREG++
FWrite( nHANDLE, "AE2" )
FWrite( nHANDLE, StrZero( SEQ, 3 ) )
IF Empty( PEDIDOCLI )
mOS := OS
dbSelectAr( "MO01" )
dbGoTop()
dbSeek( mOS )
IF Found() .AND. !Empty( PEDIDOCLI )
FWrite( nHANDLE, PadR( PEDIDOCLI, 12 ) )
ELSE
dbSelectAr( xAR2 )
FWrite( nHANDLE, PadR( PEDIDOCLI, 12 ) )
ENDIF
dbSelectAr( xAR2 )
ELSE
FWrite( nHANDLE, PadR( PEDIDOCLI, 12 ) )
ENDIF
FWrite( nHANDLE, PadR( StrTran( CODIGO, ".", "" ), 30 ) )
nQTDDE := QTDE
IF lCONV
nQTDDE := CONVUN( nQTDDE, UNID )
nQTDDE := Int( nQTDDE )
FWrite( nHANDLE, StrZero( nQTDDE, 9 ) )
ELSE
DO CASE
CASE UNID = "CT"
cQTDE := StrZero( nQTDDE, 10, 2 )
CASE UNID = "ML"
cQTDE := StrZero( nQTDDE, 10, 3 )
OTHERWISE
cQTDE := StrZero( nQTDDE, 9 )
ENDCASE
cQTDE := PadR( StrTran( cQTDE, ".", "" ), 9 )
FWrite( nHANDLE, cQTDE )
ENDIF
IF lCONV
FWrite( nHANDLE, "PC" )
ELSE
FWrite( nHANDLE, PadR( UNID, 2 ) )
ENDIF
FWrite( nHANDLE, StrZero( Val( StrTran( CLASSIPI, ".", "" ) ), 10 ) )
FWrite( nHANDLE, StrZero( IPI, 4 ) )
IF lCONV
DO CASE
CASE UNID = "CT"
FWrite( nHANDLE, StrTran( StrZero( PRECO / 100, 18, 2 ), ".", "" ) )
CASE UNID = "ML"
FWrite( nHANDLE, StrTran( StrZero( PRECO / 1000, 18, 2 ), ".", "" ) )
OTHERWISE
FWrite( nHANDLE, StrTran( StrZero( PRECO, 18, 2 ), ".", "" ) )
ENDCASE
ELSE
FWrite( nHANDLE, StrTran( StrZero( PRECO, 18, 2 ), ".", "" ) )
ENDIF
FWrite( nHANDLE, StrZero( 0, 9 ) )
IF nTIPO = 1   // GM
FWrite( nHANDLE, "  " )
ENDIF
IF nTIPO = 2   // FORD
IF lCONV
FWrite( nHANDLE, "PC" )
ELSE
FWrite( nHANDLE, PadR( UNID, 2 ) )
ENDIF
ENDIF
FWrite( nHANDLE, StrZero( 0, 9 ) )
FWrite( nHANDLE, "  " )
FWrite( nHANDLE, cTIPO )
FWrite( nHANDLE, StrZero( 0, 4 ) )
FWrite( nHANDLE, StrZero( 0, 11 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
// AE4
nREG++
FWrite( nHANDLE, "AE4" )
FWrite( nHANDLE, StrTran( StrZero( ICM, 5, 2 ), ".", "" ) )
FWrite( nHANDLE, StrTran( StrZero( BASEICM, 18, 2 ), ".", "" ) )
FWrite( nHANDLE, StrTran( StrZero( VALORICM, 18, 2 ), ".", "" ) )
FWrite( nHANDLE, StrTran( StrZero( VALORIPI, 18, 2 ), ".", "" ) )
FWrite( nHANDLE, Left( CODICM, 2 ) )   // Mudou 2 para 3 digitos
FWrite( nHANDLE, Space( 30 ) )
FWrite( nHANDLE, StrZero( 0, 6 ) )
FWrite( nHANDLE, Space( 32 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
dbSkip()
ENDDO
// AE3
nREG++
FWrite( nHANDLE, "AE3" )
IF nTIPO = 1  // GM
FWrite( nHANDLE, "59275792000150" )
FWrite( nHANDLE, "59275792000150" )
ENDIF
IF nTIPO = 2  // FORD
FWrite( nHANDLE, "57290355001313" )
FWrite( nHANDLE, "57290355001313" )
ENDIF

FWrite( nHANDLE, PadR( cDOCA, 14 ) )
FWrite( nHANDLE, Space( 83 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )

// FTP
nREG++
FWrite( nHANDLE, "FTP" )
FWrite( nHANDLE, StrZero( 0, 5 ) )
FWrite( nHANDLE, StrZero( nREG, 9 ) )
FWrite( nHANDLE, StrZero( 0, 17 ) )
FWrite( nHANDLE, " " )
FWrite( nHANDLE, Space( 93 ) )
FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
FWrite( nHANDLE, Chr( 26 ) )
FClose( nHANDLE )
dbCloseAll()

IF MDG( "Deseja Ver o Arquivo" )
VERTXT( cARQ )
ENDIF
IF MDG( "Deseja imprimir o Arquivo" )
// imparq(cARQ)
imparq( cARQ,,,,,,, 128, )
ENDIF

// + EOF: M_BO6.PRG

// + EOF: m_bo6.prg
// +
