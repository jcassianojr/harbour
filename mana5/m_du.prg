// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_du.prg
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


// :*****************************************************************************
// :
// :   M_AS2  .PRG : Lista de Precos - Reajuste
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5/ITAESBRA
// :          Autor: Equipe Disk
// :      Copyright (c) 1994, Disk Soft S/C Ltda.
// :
// :*****************************************************************************


// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"


// Modo de Trabalho no Video
MDI( " Ý Reajuste de Pre‡os " )

// Prepara Variaveis
DATAREF  := DATADES := ZDATA
nFATOR   := 1.0000
QTDETAB  := 20
CLILISTA := 0


// Desenha a Tela
hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
@  8, 17 SAY "Data de Referencia" + spac( 17 ) + ":"
@ 10, 17 SAY "Data Destino" + spac( 23 ) + ":"
@ 12, 17 SAY "Fator de  Reajuste" + spac( 15 ) + ":"
@ 14, 17 SAY "Quantidade de Pre‡os a armazenar   :"
@ 15, 17 SAY "Cliente Lista"
// Get nas Menvars
@  8, 55 GET DATAREF
@ 10, 55 GET DATADES
@ 12, 55 GET nFATOR
@ 14, 55 GET QTDETAB
@ 15, 55 GET CliLista
IF !READCUR()
RETU .F.
ENDIF
IF nFATOR = 0
ALERTX( "Fator em Branco" )
RETU .F.
ENDIF
IF !MDG( "Iniciar Calculo" )
RETU .F.
ENDIF

FILTRO := ""
FILTRO := RFILORD( "MS01", .F. )

CRIARVARS( "MS01" )
CRIARVARS( "MS02" )


IF !USEMULT( { { "MS01", 1, 2 }, { "MS02", 0, 99 } } )
RETU .F.
ENDIF


MDS( "Checando Pre‡os sem produtos" )
dbSelectAr( "MS02" )
dbGoTop()
WHILE !Eof()
mCHAVE := CODIGO
dbSelectAr( "MS01" )
dbGoTop()
lEXISTE := dbSeek( mCHAVE )
dbSelectAr( "MS02" )
IF !lEXISTE
@ 20, 30 SAY mCHAVE
DELEREG(,, .F., .F. )
ENDIF
dbSkip()
ENDDO

dbSelectAr( "MS02" )
dbSetOrder( 5 )   // Codigo Fornecedo Data

dbSelectAr( "MS01" )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY CODIGO
mCODIGO := CODIGO
dbSelectAr( "MS02" )
dbSeek( mCODIGO )
WHILE mCODIGO = CODIGO .AND. !Eof()
mFORNECEDO := FORNECEDO
WHILE mCODIGO = CODIGO .AND. mFORNECEDO = FORNECEDO .AND. !Eof()
IF DATAREF = DATA .AND. FORNECEDO = CLILISTA
EQUVARS()
NETGRVCAM( "ATUAL", "N" )
REG    := RecNo()
mCHAVE := mCODIGO + Str( mFORNECEDO, 5 ) + DToS( DATADES )
mDATA  := DATADES
mVALOR := mVALOR * nFATOR
NOVOOPE(, mCHAVE )
dbGoto( REG )
ENDIF
dbSelectAr( "MS02" )
dbSkip()
ENDDO
ENDDO
dbSelectAr( "MS01" )
dbSkip()
ENDDO


dbSelectAr( "MS01" )
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY CODIGO
mCODIGO := CODIGO
dbSelectAr( "MS02" )
dbSeek( mCODIGO )
WHILE mCODIGO = CODIGO .AND. !Eof()
mFORNECEDO := FORNECEDO
nQTDDE     := 0
nREGINI    := RecNo()
WHILE mCODIGO = CODIGO .AND. mFORNECEDO = FORNECEDO .AND. !Eof()
nQTDDE++
dbSelectAr( "MS02" )
dbSkip()
ENDDO
IF nQTDDE > QTDETAB
nDIF := nQTDDE - QTDETAB
dbGoto( nREGINI )
WHILE mCODIGO = CODIGO .AND. mFORNECEDO = FORNECEDO .AND. !Eof()
IF nDIF > 0
DELEREG(,, .F., .F. )
nDIF--
ENDIF
dbSkip()
ENDDO
ENDIF
ENDDO
dbSelectAr( "MS01" )
dbSkip()
ENDDO



MDS( "Aguarde Fixando o Arquivo" )
dbSelectAr( "MS02" )
PACK
dbCloseAll()

MAOITA01()

// + EOF: m_du.prg
// +
