// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fohd.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOHF.PRG: IMPRIMIR RE FGTS PADRAO CAIXA
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: jcassiano 
// :      Copyright (c) 1997,  jcassiano  S/C Ltda.
// :  Atualizado em: 02/10/97
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"
#include "INKEY.CH"

IF ARQ = 9 .OR. ARQ = 10
MDT( 'Use a op‡„o Folha' )
RETU
ENDIF
IF ARQ = 6
ALERTX( "Nao Disponivel VT" )
RETU .F.
ENDIF
IF !MDL( 'IMPRIMIR RE FGTS PADRAO CAIXA', 0 )
RETU
ENDIF

ATUALIZA := 1.000000
CONTATO  := PadR( OBTER( "FIRMA",, NREMP, "RESPONSAV" ), 20 )
TIPODEP  := "115"
aCTA01   := PEGRELCTA( "FGTS01" )
aCTA02   := PEGRELCTA( "FGTS02" )


SET KEY K_F11 TO TECLAF11
@ 18, 00 SAY 'Qual o Fator de Atualiza‡„o:'
@ 20, 00 SAY 'Confirme o C¢digo de Recolhimento'
@ 18, 40 GET ATUALIZA                            PICT "99999999999.999999"
@ 20, 50 GET TIPODEP                             PICTURE "999"             VALID VERSEHA( "CODFGTS",, TIPODEP, "NOME", '"C¢digo Deposito N„o Cadastrado"' )
IF !READCUR()
SET KEY K_F11
RETU .F.
ENDIF
SET KEY K_F11


nCONT   := 26
nTOT    := 0
nTOT13  := 0
nTOTG   := 0
nTOTG13 := 0
nFL     := 1

IF !netuse( "bcofgts" )
dbCloseAll()
RETU
ENDIF
dbGoTop()
IF !dbSeek( NREMP )
MDT( 'Falta cadastro do Banco Deposit rio' )
RETU
ELSE
cCODFGTS := CODEMP + CODEMPDV + SEQUENCIA + SEQUENDV
ENDIF
dbCloseAll()

IF ZPESSOA = 'J'
INSREP := SubStr( CGC1, 1, 2 ) + SubStr( CGC1, 4, 3 ) + SubStr( CGC1, 8, 3 ) + SubStr( CGC1, 12, 4 ) + SubStr( CGC1, 17, 2 )
ELSE
INSREP := "00" + ZCEI
ENDIF
cMESANO := StrZero( MES, 2 ) + '/' + SubStr( StrZero( ANO, 4 ), 3 )

IF !ARQPES( ARQ, 1, 0 )
dbCloseAll()
RETU
ENDIF
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
INX    := ""
FILORD( .T. )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF ValType( INX ) = "N"
dbSetOrder( INX )
ELSE
ordDestroy( "temp" )
ordCreate(, "temp", inx )
ordSetFocus( "temp" )
ENDIF
SET FILTER TO &FILTRO
cSELE1 := Alias()

IF !ARQUSAR( ARQ )
dbCloseAll()
RETU .F.
ENDIF
cSELE2 := Alias()



// Seta o Formulario
IMPRESSORA()
dbSelectAr( cSELE1 )
dbGoTop()
WHILE !Eof()
IF nCONT = 26
@ PRow(), 0   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) ) + REPL( "-", 132 )
@ PRow() + 1, 0 SAY ACENTO( "CGC/CEI" + spac( 8 ) + "C¢digo FGTS    Pessoa/Telefone para Contato    |  Competˆncia" )
@ PRow() + 1, 0 SAY INSREP
@ PRow(), 15   SAY cCODFGTS
@ PRow(), 30   SAY CONTATO
@ PRow(), 51   SAY ZTELEFONE
@ PRow(), 62   SAY "|"
@ PRow(), 68   SAY cMESANO
@ PRow() + 1, 0 SAY ACENTO( "Raz„o Social" + spac( 39 ) + "No Folha   |  C¢digo Rec." )
@ PRow() + 1, 0 SAY MSG2
@ PRow(), 51   SAY StrZero( nFL, 6 )
@ PRow(), 62   SAY "|"
@ PRow(), 69   SAY TIPODEP
@ PRow() + 1, 0 SAY REPL( "-", 132 )
@ PRow() + 1, 0 SAY ACENTO( "NOME" + spac( 27 ) + "PIS/PASEP   ADMISSŽO-Co CONTA FGTS     Base Calculo" + spac( 7 ) + "Base 13o. Sal.  Movimenta‡„o" )
@ PRow() + 1, 0 SAY REPL( "-", 132 )
nFL++
nCONT  := 1
nTOT   := 0
nTOT13 := 0
ENDIF
NUM   := NUMERO
REC   := 0
REC13 := 0
dbSelectAr( cSELE2 )
dbGoTop()
dbSeek( NUM * 10000 )
WHILE NUm = NUMERO .AND. !Eof()
FOR X := 1 TO 15
IF aCTA01[ X ] = CONTA
REC += VALOR
ENDIF
IF aCTA02[ X ] = CONTA
REC13 += VALOR
ENDIF
NEXT X
dbSkip()
ENDDO
REC   := IF( ATUALIZA # 1, Round( REC * ATUALIZA, 2 ), REC )
REC13 := IF( ATUALIZA # 1, Round( REC13 * ATUALIZA, 2 ), REC13 )
dbSelectAr( cSELE1 )
IF Empty( DEMITIDO ) .OR. Month( DEMITIDO ) >= MES
@ PRow() + 1, 0 SAY NOME
@ PRow(), 31   SAY PIS
@ PRow(), 43   SAY ADMITIDO
@ PRow(), 52   SAY TIPFGTS
@ PRow(), 55   SAY CONTAFGTS
IF REC > 0  // .AND.MOTIVO#"02"
@ PRow(), 67 SAY REC PICTURE "@E 999,999,999,999.99"
nTOT  += REC
nTOTG += REC
ENDIF
IF REC13 > 0  // .AND.MOTIVO#"02"
@ PRow(), 86 SAY REC13 PICTURE "@E 999,999,999,999.99"
nTOT13  += REC13
nTOTG13 += REC13
ENDIF
IF Month( DEMITIDO ) = MES
@ PRow(), 105 SAY DEMITIDO
@ PRow(), 114 SAY FGTSMOT
ENDIF
ENDIF
dbSelectAr( cSELE1 )
dbSkip()
nCONT++
IF nCONT = 26
@ PRow() + 1, 0  SAY REPL( "-", 132 )
@ PRow() + 1, 55 SAY "TOTAL" + spac( 10 ) + "Base Calculo" + spac( 7 ) + ACENTO( "Base13o Sal rio    Base+Base 13O. " )
@ PRow() + 1, 55 SAY "A RECOLHER"
@ PRow(), 67    SAY nTOT                                                                                 PICTURE "@E 999,999,999,999.99"
@ PRow(), 86    SAY nTOT13                                                                               PICTURE "@E 999,999,999,999.99"
@ PRow(), 105   SAY nTOT + nTOT13                                                                          PICTURE "@E 999,999,999,999.99"
@ PRow() + 1, 0  SAY REPL( "-", 132 )
IMPFOL()
ENDIF
ENDDO
IF nTOT + nTOT13 > 0
@ PRow() + 1, 0  SAY REPL( "-", 132 )
@ PRow() + 1, 55 SAY "TOTAL" + spac( 10 ) + "Base Calculo" + spac( 7 ) + ACENTO( "Base13o Sal rio    Base+Base 13O. " )
@ PRow() + 1, 55 SAY "A RECOLHER"
@ PRow(), 67    SAY nTOT                                                                                      PICTURE "@E 999,999,999,999.99"
@ PRow(), 86    SAY nTOT13                                                                                    PICTURE "@E 999,999,999,999.99"
@ PRow(), 105   SAY nTOT + nTOT13                                                                               PICTURE "@E 999,999,999,999.99"
@ PRow() + 1, 0  SAY REPL( "-", 132 )
@ PRow() + 1, 0  SAY REPL( "-", 132 )
@ PRow() + 1, 55 SAY "TOTAL GERAL" + spac( 4 ) + "Base Calculo" + spac( 7 ) + ACENTO( "Base13o Sal rio    Base+Base 13O. " )
@ PRow() + 1, 55 SAY "A RECOLHER"
@ PRow(), 67    SAY nTOTG                                                                                     PICTURE "@E 999,999,999,999.99"
@ PRow(), 86    SAY nTOTG13                                                                                   PICTURE "@E 999,999,999,999.99"
@ PRow(), 105   SAY nTOTG + nTOTG13                                                                             PICTURE "@E 999,999,999,999.99"
@ PRow() + 1, 0  SAY REPL( "-", 132 )
IMPFOL()
ENDIF
dbCloseAll()
VIDEO()
IMPEND()
mTEMP := tmpfile( cRDDEXT )
RETU

// : FIM: FOHD.PRG

// + EOF: fohd.prg
// +
