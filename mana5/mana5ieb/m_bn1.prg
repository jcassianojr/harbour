// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bn1.prg
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => J:\ITAESBRA\M_BN1.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
MDI( " н Imprimir Duplicata a Receber Direto no Formul rio " )

// Checa a Impressora
IF !CHECKIMP( 0 )
RETURN .F.
ENDIF

// Filtro da Listagem
FILTRO := 'IMPDUP#"N".AND.IMPDUP#"I"'
FILTRO := RFILORD( "MN01", .F., FILTRO )
// lCFO:=MDG("Imprimir CFO Novo")

// Abertura do Arquivo
IF !USEmult( { { "MA01", 1, 1 }, { "MB01", 1, 1 }, { "MN01", 1, 1 } } )
RETU
ENDIF
dbSelectAr( "MN01" )

IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
IF Eof()
dbCloseAll()
RETU .F.
ENDIF

SET PRINT ON
QQOut( IMPCHR( 27 ) + 'C' + IMPCHR( 36 ) )
SET PRINT OFF

CTLIN   := 80
ZPAGINA := 0
impressora()
dbSelectAr( "MN01" )
dbGoTop()
WHILE !Eof()
@ 03, 49 SAY impchr( cIMPEXP ) + SubStr( OPERACAO, 1, 4 ) // 02,49
IF SubStr( OPERACAO, 1, 4 ) = "511" .OR. SubStr( OPERACAO, 1, 4 ) = "611"
@ 03, 54 SAY '- V E N D A S'
ELSE
IF SubStr( OPERACAO, 1, 4 ) = "513" .OR. SubStr( OPERACAO, 1, 4 ) = "613"
@ 03, 54 SAY 'MAO DE OBRA'
ENDIF
ENDIF
IF CODCOMP = "1"
@ 04, 49 SAY 'COMPLEMENTAR'
ENDIF
CTLIN := 5
@ CTLIN, 49 SAY 'RODOVIARIA'
CTLIN++
@ CTLIN, 49 SAY DATA
CTLIN += 4
@ CTLIN, 17      SAY NUMERO          PICT '999999'
@ CTLIN, 24      SAY TIPFAT
@ PRow(), PCol() SAY impchr( cIMPCOM )
@ CTLIN, 29      SAY VALOR - ABATER  PICT '@E 9,999,999,999.99'
@ PRow(), PCol() SAY impchr( cIMPEXP )
@ CTLIN, 51      SAY NUMERO          PICT '999999'
@ CTLIN, 60      SAY VENCIMENT
CTLIN      += 3
CTLIN      += 1
mFORNECEDO := FORNECEDO
mTIPOCLI   := TIPOCLI
IF TIPOCLI = "F"
dbSelectAr( "MB01" )
ELSE
dbSelectAr( "MA01" )
ENDIF
dbGoTop()
IF dbSeek( mFORNECEDO )
@ CTLIN, 23 SAY " ( " + StrZero( mFORNECEDO, 5 ) + " )"
CTLIN++
@ CTLIN, 23 SAY Trim( NOME )
CTLIN++
@ CTLIN, 23 SAY ENDERECO
CTLIN++
@ CTLIN, 23 SAY CIDADE
@ CTLIN, 58 SAY ESTADO
CTLIN++
IF mTIPOCLI = "F"
@ CTLIN, 23 SAY Trim( ENDERECO ) + ' ' + Trim( CIDADE ) + ' ' + Trim( ESTADO ) + ' ' + Trim( CEP )
ELSE
@ CTLIN, 23 SAY Trim( ENDERECO2 ) + ' ' + Trim( CIDADE2 ) + ' ' + Trim( ESTADO2 ) + ' ' + Trim( CEP2 )
ENDIF
CTLIN += 2
@ CTLIN, 23 SAY CGC
IF mTIPOCLI = "F"
@ CTLIN, 47 SAY IESTADUAL
ELSE
@ CTLIN, 47 SAY INSCR
ENDIF
CTLIN += 2
ELSE
CTLIN += 8
ENDIF
dbSelectAr( "MN01" )
@ CTLIN, 23 SAY impchr( cIMPCOM ) + EXT( VALOR - ABATER, 1, 80, 80, 0 ) + impchr( cIMPEXP )
CTLIN++
@ CTLIN, 23 SAY impchr( cIMPCOM ) + EXT( VALOR - ABATER, 2, 80, 80, 0 ) + impchr( cIMPEXP )
CTLIN++
@ CTLIN, 1 SAY IMPCHR( 13 )
NETGRVCAM( "IMPDUP", "N" )
dbSkip()
ENDDO
dbCloseAll()
IMPFOL()
video()
SET PRINT ON
QQOut( IMPCHR( 27 ) + 'C' + IMPCHR( 66 ) )
SET PRINT OFF
IMPEND()

// + EOF: M_BN1.PRG

// + EOF: m_bn1.prg
// +
