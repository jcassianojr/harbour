// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_af8.prg
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


MDI( "Criar Arquivo Banco do Brasil->BBSAC.DBF" )
// CAMINHO := "\BBCBR\DADOS\"+SPACE(40)
CAMINHO := ProfileString( "MANA5.INI", "PATH", "BBCBR", hb_cwd() + "\BBCBR\DADOS\" ) + Space( 40 )   //

MDS( "Digite o Caminho" )
@ 24, 30 GET CAMINHO
IF !READCUR()
RETU .F.
ENDIF

aLAYG1 := PEGLAY( "MEXPOR1", "MAF801" )

FILTRO  := ''
FILTRO  := RFILORD( "MA01", .F. )
CAMINHO := AllTrim( CAMINHO ) + "BBSAC"
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
ordCreate(, "temp", "NR_INS_SAC" )
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
mNOMESAC  := Left( NOME, 37 )
mTPINSSAC := IF( PESSOA = "J", "02", "01" )
cCGCTEMP  := StrTran( StrTran( StrTran( CGC3, "-", "" ), "/", "" ), ".", "" )
mCGCCPFS  := IF( PESSOA = "J", cCGCTEMP, "000" + cCGCTEMP )
mENDERECO := Left( ENDERECO3, 37 )
mBAIRRO   := Left( BAIRRO3, 12 )
mCEP      := StrTran( CEP3, "-", "" )
mCIDADE   := Left( CIDADE3, 15 )
mUF       := ESTADO3
GRAVALAY( aLAY1, "BBSAC",, .F., mCGCCPFS, .T. )
dbSelectAr( "MA01" )
dbSkip()
ENDDO
dbCloseAll()
ALERTX( "N„o se esque‡a de Reordenar Arquivos no Programa do BANCO DO BRASIL" )

// + EOF: m_af8.prg
// +
