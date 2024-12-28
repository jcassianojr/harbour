// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_af6.prg
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


MDI( "Criar Arquivo Itau->DBSAC.DBF" )
CAMINHO := ProfileString( "MANA5.INI", "PATH", "ITAUSIG", hb_cwd() + "\ITAUSIG" ) + Space( 40 )  //
// "\ITAUSIG\"+SPACE(40)
MDS( "Digite o Caminho" )
@ 24, 30 GET CAMINHO
IF !READCUR()
RETU .F.
ENDIF
CAMINHO := AllTrim( CAMINHO ) + "DBSAC"
IF !File( CAMINHO + ".DBF" )
ALERTX( "N„o Encontrei Arquivo " + CAMINHO )
RETU .F.
ENDIF


aLAYG := PEGLAY( "MEXPOR1", "MAF601" )

FILTRO := ''
FILTRO := RFILORD( "MA01", .F. )
IF !USECHK( CAMINHO,, .T. )
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", "CODSAC" )
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
mCODSAC   := Str( NUMERO, 8 )
mNOMESAC  := Left( NOME, 30 )
mTPINSSAC := IF( PESSOA = "J", "02", "01" )
cCGCTEMP  := StrTran( StrTran( StrTran( CGC, "-", "" ), "/", "" ), ".", "" )
mCGCCPFS  := IF( PESSOA = "J", cCGCTEMP, "000" + cCGCTEMP )
mENDERECO := Left( ENDERECO2, 40 )
mBAIRRO   := Left( BAIRRO2, 12 )
mCEP      := StrTran( CEP2, "-", "" )
mCIDADE   := Left( CIDADE2, 15 )
mUF       := ESTADO2
GRAVALAY( aLAYG, "DBSAC",, .F., mCODSAC, .T. )
dbSelectAr( "MA01" )
dbSkip()
ENDDO
dbCloseAll()


// + EOF: m_af6.prg
// +
