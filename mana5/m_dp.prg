// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_dp.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



cARQ := WIN_GETSAVEFILENAME(, "Salvar Documentacao", hb_cwd(), "txt", "*.txt", 1,, "documentacao.txt" )

lPULAFEC  := MDG( "Pular Arquivos Fechados" )
lPULACEP  := MDG( "Pular Arquivos CEPS" )
lPULACNPJ := MDG( "Pular Arquivos CNPJ/IE" )
lMESARQ   := MDG( "Exibir Mensagem arquivo nao encontrado" )


cTIPO := "D"
MDS( "(D)ocumento (I)ni" )
@ 24, 40 GET cTIPO VALID cTIPO $ "DI"
IF !READCUR()
RETU .F.
ENDIF


aARQ   := {}
aDES   := {}
aCAM   := {}
aDRV   := {}
FILTRO := ""
FILTRO := RFILORD( zARQ, .F. )
IF !USEREDE( zARQ, 1, 1 )
RETU .T.
ENDIF
SET FILTER TO &FILTRO
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbGoTop()
WHILE !Eof()
lINCLUI := .T.
IF ARQUIVO = "DICI"
lINCLUI := .F.
ENDIF

IF ( !Empty( arqANO ) .AND. lPULAFEC ) .OR. ARQUIVO = "MANARQ" .OR. ARQUIVO = "MANARQ1"
// Nao Inclui Na Lista Fechados
lINCLUI := .F.
ENDIF
IF PADRAO = "A" .AND. lPULACEP   // E cep e foi solicitado pular
lINCLUI := .F.
ENDIF
IF lPULACNPJ .AND. ( At( "CNPJIE", ARQUIVO ) > 0 .OR. At( "BAIXA", ARQUIVO ) > 0 )
lINCLUI := .F.
ENDIF

IF lINCLUI
AAdd( aARQ, ARQUIVO )
AAdd( aDES, DESCRICAO )
AAdd( aCAM, LOCALARQ( PADRAO, CAMINHO ) )
AAdd( aDRV, AllTrim( DRIVER ) )
ENDIF
dbSkip()
zei_fort( nLASTREC,,, 1 )
ENDDO
dbCloseAll()

IF !USEREDE( HELPARQ, 1, 1 )
dbCloseAll()
RETU .T.
ENDIF

IF !USEREDE( "DICI", 0, 1 )
dbCloseAll()
RETU .T.
ENDIF
IF lPULACEP
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "C0"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "C1"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "C2"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "C3"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "C4"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "C5"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "G0"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "G1"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "G2"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "G3"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "G4"
DELETE ALL FOR Upper( Left( tabela, 2 ) ) = "G5"
ENDIF
IF lPULACNPJ
DELETE ALL FOR Upper( Left( tabela, 4 ) ) = "CNPJ"
ENDIF

nHANDLE := FCreate( AllTrim( cARQ ) )
IF FError() # 0
ALERTX( "Erro na Criacao do Arquivo" )
RETU
ENDIF
nARQ := Len( aARQ )
// xGRAF := 0
// xPOS  := 1
// GRAF  := nARQ
// MARCAR()
nLASTREC := nARQ
zei_fort( nLASTREC,,, 0 )
FOR Y := 1 TO nARQ
mARQUIVO   := aARQ[ Y ]
mDESCRICAO := aDES[ Y ]
MDS( mARQUIVO )
IF cTIPO = "D"
FWrite( nHANDLE, "|" + Replicate( '-', 78 ) + "|" + hb_osNewLine() )
FWrite( nHANDLE, '|' + PadC( AllTrim( mARQUIVO ) + ".DBF", 78 ) + '|' + hb_osNewLine() )
FWrite( nHANDLE, '|' + PadC( "Descricao: " + AllTrim( mDESCRICAO ), 78 ) + '|' + hb_osNewLine() )
FWrite( nHANDLE, "|" + Replicate( '-', 78 ) + "|" + hb_osNewLine() )
FWrite( nHANDLE, 'Sumario dos Campos:' + hb_osNewLine() )
FWrite( nHANDLE, Replicate( '=', 78 ) + hb_osNewLine() )
FWrite( nHANDLE, '' + hb_osNewLine() )
ELSE
FWrite( nHANDLE, "[" + AllTrim( mARQUIVO ) + ".DBF]" + hb_osNewLine() )
FWrite( nHANDLE, "CAMINHO=" + AllTrim( aCAM[ Y ] ) + hb_osNewLine() )
IF Empty( aDRV[ Y ] )
FWrite( nHANDLE, "DRIVER=DBFCDX" + hb_osNewLine() )
ELSE
FWrite( nHANDLE, "DRIVER=" + aDRV[ Y ] + hb_osNewLine() )
ENDIF
ENDIF
IF mARQUIVO # HELPARQ
IF USEREDE( AllTrim( mARQUIVO ), 1, 0,, lMESARQ )
IF cTIPO = "D"
FWrite( nHANDLE, Str( FCount(), 5 ) + ' Campos Definidos' + hb_osNewLine() )
ENDIF
aESTRU := dbStruct()
dbCloseArea()
ELSE
aESTRU := {}
ENDIF
ELSE
dbSelectAr( HELPARQ )
IF cTIPO = "D"
FWrite( nHANDLE, Str( FCount(), 5 ) + ' Campos Definidos' + hb_osNewLine() )
ENDIF
aESTRU := dbStruct()
ENDIF
IF cTIPO = "D"
FWrite( nHANDLE, '' + hb_osNewLine() )
FWrite( nHANDLE, "Campo Nome" + spac( 7 ) + "Tipo     Tam Dec Descricao" + hb_osNewLine() )
FWrite( nHANDLE, Replicate( '-', 78 ) + hb_osNewLine() )
ENDIF
FIM := Len( aESTRU )
FOR X := 1 TO FIM
IF cTIPO = "D"
FWrite( nHANDLE, Str( X, 5 ) + " " )
FWrite( nHANDLE, PadR( aESTRU[ X, 1 ], 10 ) + " " )
FWrite( nHANDLE, TIPOCAMPO( aESTRU[ X, 2 ] ) + " " )
FWrite( nHANDLE, Str( aESTRU[ X, 3 ], 3 ) + " " )
FWrite( nHANDLE, Str( aESTRU[ X, 4 ], 3 ) + " " )
ENDIF
mCHAVE := PadR( mARQUIVO, 8 ) + "M" + PadR( aESTRU[ X, 1 ], 9 )
dbSelectAr( HELPARQ )
dbGoTop()
IF dbSeek( mCHAVE )
IF cTIPO = "D"
FWrite( nHANDLE, DADO )
ENDIF
ENDIF
IF cTIPO = "D"
FWrite( nHANDLE, hb_osNewLine() )
ENDIF
dbSelectAr( "DICI" )
dbGoTop()
mCHAVE := PadR( mARQUIVO, 30 ) + PadR( aESTRU[ X, 1 ], 10 )
IF !dbSeek( mCHAVE )
NETRECAPP()
field->tabela := mARQUIVO
field->campo  := aESTRU[ X, 1 ]
field->tipo   := aESTRU[ X, 2 ]
field->tam    := aESTRU[ X, 3 ]
field->dec    := aESTRU[ X, 4 ]
ENDIF
NEXT X
aIND := {}
aIN1 := {}
aCHA := {}
WHILE !USEREDE( zARQ1, 1, 1 )
ENDDO
dbSeek( PadR( mARQUIVO, 8 ) + Str( 1, 2 ) )
WHILE ARQUIVO = PadR( mARQUIVO, 8 ) .AND. !Eof()
AAdd( aIND, INDICE )
AAdd( aIN1, DESC )
AAdd( aCHA, INDEXP )
dbSkip()
ENDDO
dbCloseArea()
FIM := Len( aIND )
IF cTIPO = "D"
FWrite( nHANDLE, + hb_osNewLine() )
FWrite( nHANDLE, "Sumario dos Indices" + hb_osNewLine() )
FWrite( nHANDLE, Replicate( '=', 78 ) + hb_osNewLine() )
FWrite( nHANDLE, hb_osNewLine() )
FWrite( nHANDLE, Str( FIM, 4 ) + ' Indices Definidos:' + hb_osNewLine() )
FWrite( nHANDLE, hb_osNewLine() )
FWrite( nHANDLE, 'Nome       Descricao' + hb_osNewLine() )
FWrite( nHANDLE, '           Expressao Chave' + hb_osNewLine() )
FWrite( nHANDLE, Replicate( '=', 78 ) + hb_osNewLine() )
ELSE
FWrite( nHANDLE, "NUMMAINTAINED=" + Str( FIM, 1 ) + hb_osNewLine() )
ENDIF
IF cTIPO = "I"
FWrite( nHANDLE, "MAINTAIN0=" + AllTrim( mARQUIVO ) + ".CDX" + hb_osNewLine() )
ENDIF
FOR I := 1 TO FIM
IF cTIPO = "D"
FWrite( nHANDLE, PadR( aIND[ I ], 10 ) + " " + PadR( aIN1[ I ], 50 ) + hb_osNewLine() )
FWrite( nHANDLE, "           " + aCHA[ I ] + hb_osNewLine() )
FWrite( nHANDLE, "           " + MDPCHAVEI( aCHA[ I ] ) + hb_osNewLine() )
FWrite( nHANDLE, "----------" + hb_osNewLine() )
ELSE
FWrite( nHANDLE, "TAG" + Str( I - 1, 1 ) + "=" + AllTrim( aIND[ I ] ) + hb_osNewLine() )
FWrite( nHANDLE, "INDEX" + Str( I - 1, 1 ) + "=" + AllTrim( aCHA[ I ] ) + hb_osNewLine() )
FWrite( nHANDLE, "INDEXFIELDS" + Str( I - 1, 1 ) + "=" + MDPCHAVEI( AllTrim( aCHA[ I ] ) ) + hb_osNewLine() )
ENDIF
NEXT
IF cTIPO = "I"
FWrite( nHANDLE, hb_osNewLine() )
ENDIF
zei_fort( nLASTREC,,, 1 )
// xGRAF ++
NEXT Y
dbCloseAll()
FClose( nHANDLE )
fixar( "DICI" )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TIPOCAMPO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TIPOCAMPO( cTIP )

   LOCAL cTIPO

   DO CASE
   CASE cTIP = "C"
      cTIPO := "Caracter"
   CASE cTIP = "N"
      cTIPO := "Numerico"
   CASE cTIP = "D"
      cTIPO := "Data    "
   CASE cTIP = "L"
      cTIPO := "Logico  "
   CASE cTIP = "M"
      cTIPO := "Memo    "
   OTHERWISE
      cTIPO := "????????"
   ENDCASE

   RETURN cTIPO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDPCHAVEI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MDPCHAVEI( cICHAVE )   // Cria string campo1,campo2,... para create index em sql

   LOCAL nPOS
   LOCAL cCHAVE
   LOCAL cTMPCHV
   LOCAL aICampos
   LOCAL I

   cCHAVE   := ""
   aicampos := hb_ATokens( cICHAVE, "+" )
   FOR I := 1 TO Len( aICampos )
      cTMPCHV := aICampos[ I ]
      nPOS    := At( "(", cTMPCHV )
      IF nPOS >= 0
         cTMPCHV := SubStr( cTMPCHV, nPOS + 1 )
      ENDIF
      nPOS := At( "(", cTMPCHV )
      IF nPOS > 0
         cTMPCHV := SubStr( cTMPCHV, nPOS + 1 )
      ENDIF
      nPOS := At( ")", cTMPCHV )
      IF nPOS > 0
         cTMPCHV := SubStr( cTMPCHV, 1, nPOS - 1 )
      ENDIF
      nPOS := At( ",", cTMPCHV )
      IF nPOS > 0
         cTMPCHV := SubStr( cTMPCHV, 1, nPOS - 1 )
      ENDIF
      cCHAVE += cTMPCHV
      IF I <> Len( aICAMPOS )
         cCHAVE += ","
      ENDIF
   NEXT I

   RETURN cCHAVE

// + EOF: m_dp.prg
// +
