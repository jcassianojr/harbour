// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_af9.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


MDI( "Criar Arquivo BCN->COBSCAD.DBF" )
CAMINHO := ProfileString( "MANA5.INI", "PATH", "COBBCN", hb_cwd() + "\COBBCN" ) + Space( 40 )  //
// CAMINHO := "\COBBCN\"+SPACE(40)
MDS( "Digite o Caminho" )
@ 24, 30 GET CAMINHO
IF !READCUR()
RETU .F.
ENDIF

aLAYG1 := PEGLAY( "MEXPOR1", "MAF901" )

FILTRO  := ''
FILTRO  := RFILORD( "MA01", .F. )
CAMINHO := AllTrim( CAMINHO ) + "COBSACAD"
IF !File( CAMINHO + ".DBF" )
ALERTX( "N„o Encontrei Arquivo " + CAMINHO )
RETU .F.
ENDIF
IF !USECHK( CAMINHO,, .T. )
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "CGC_CPF" )
ordSetFocus( "temp" )


IF !USEREDE( "MA01", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
WHILE !Eof()
mNOMESAC  := Left( NOME, 40 )
mTPINSSAC := IF( PESSOA = "J", 2, 1 )
cCGCTEMP  := StrTran( StrTran( StrTran( CGC, "-", "" ), "/", "" ), ".", "" )
mCGCCPFS  := IF( PESSOA = "J", cCGCTEMP, "000" + cCGCTEMP )
mENDERECO := Left( ENDERECO, 40 )
mBAIRRO   := Left( BAIRRO, 15 )
mCEP      := StrTran( CEP, "-", "" )
mCIDADE   := Left( CIDADE, 15 )
mUF       := ESTADO
mDDD      := DDD
mTELEFONE := StrTran( StrTran( StrTran( TELEFONE, "-", "" ), "/", "" ), ".", "" )
GRAVALAY( aLAY1, "COBSACAD",, .F., mCGCCPFS, .T. )
dbSelectAr( "MA01" )
dbSkip()
ENDDO
dbCloseAll()

// + EOF: m_af9.prg
// +
