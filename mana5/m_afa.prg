// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_afa.prg
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


MDI( "Criar Arquivo Sudameris->CLIENTES.DBF" )
CAMINHO := ProfileString( "MANA5.INI", "PATH", "COBSUDA", hb_cwd() + "\COBSUDA" ) + Space( 40 )  //

// CAMINHO := "\COBSUDA\"+SPACE(40)
MDS( "Digite o Caminho" )
@ 24, 30 GET CAMINHO
IF !READCUR()
RETU .F.
ENDIF

aLAYG1 := PEGLAY( "MEXPOR1", "MAFA01" )

FILTRO  := ''
FILTRO  := RFILORD( "MA01", .F. )
CAMINHO := AllTrim( CAMINHO ) + "CLIENTES"
IF !File( CAMINHO + ".DBF" )
ALERTX( "Nao Encontrei Arquivo " + CAMINHO )
RETU .F.
ENDIF
IF !USECHK( CAMINHO,, .T. )
RETU .F.
ENDIF

nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "CPF_CGC" )
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
mTPINSSAC := IF( PESSOA = "J", "02", "01" )
cCGCTEMP  := CGC
mCGCCPFS  := IF( PESSOA = "J", cCGCTEMP, "000" + AllTrim( cCGCTEMP ) )
mENDERECO := Left( ENDERECO, 40 )
mCEP      := StrTran( CEP, "-", "" )
mCIDADE   := Left( CIDADE, 15 )
mUF       := ESTADO
GRAVALAY( aLAY1, "CLIENTES",, .F., mCGCCPFS, .T. )
dbSelectAr( "MA01" )
dbSkip()
ENDDO
dbCloseAll()


// + EOF: m_afa.prg
// +
