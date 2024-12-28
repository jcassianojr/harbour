// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_c9.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FOLIS_C9.PRG: Listar Rais
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"

IF !MDL( 'Listar RAIS', 0 )
RETU
ENDIF

MESTADO  := ""
MCIDADE  := ""
MNESTADO := ""
MNCIDADE := ""
MPAIS    := ""


MDS( 'Carregando dados da firma' )
IF !netuse( "firma" )
RETU
ENDIF
dbGoTop()
dbSeek( NREMP )
IF Found()
ENDERR  := ENDERECO
BAIRRR  := BAIRRO
CIDADR  := CIDADE
ESTADR  := ESTADO
CPR     := CEP
NRCGCR  := CGC
ATI     := ATIVIDADE
NAT     := NAT_ESTAB
SOC     := NR_SOCIOS
FAMIL   := NR_FAMILIA
SCGC    := CGCANT
XENDERE := ALTEND
ENDIF
dbCloseAll()




ANOBAS := Year( DXDIA )
MDS( "Confirme o Ano Base" )
@ 24, 40 GET ANOBAS PICT '####'
READCUR()




XLF := 0

IF !NETUSE( pes )
dbCloseAll()
RETU
ENDIF
FILTRO := ''
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

IF !NETUSE( "FORAIS" )
dbCloseAll()
RETU .F.
ENDIF

dbSelectAr( pes )
dbGoTop()
WHILE !Eof()
XLF++
dbSkip()
ENDDO
XLF1 := Int( XLF / 5 )
IF Int( XLF / 5 ) # XLF / 5
XLF1++
ENDIF
XLF2 := StrZero( XLF1, 4 )


FL     := 1
PAGINA := 0

SALTO := 3
SET PRIN ON
?? Chr( 27 ) + 'C' + Chr( 51 )
SET PRIN OFF
SET DEVI TO PRINT
dbSelectAr( PES )
dbGoTop()
CABRAIS()
SALTO := 8
WHILE !Eof()
ALLTRUE( CHECKCID(,, .F., IBGE, { { "UF", "mESTADO" }, { "NOME", "mCIDADE" } } ) )
ALLTRUE( CheckBacen( NASCPAIS, mPAIS, .F., { { "STRZERO(BACEN,4)", "NACPAIS" }, { "NOME", "mPAIS" } } ) )
IF PAGINA = 5
PAGINA := 0
FL++
CABRAIS()
ENDIF
PAGINA++
mNUMERO := NUMERO
dbSelectAr( "forais" )
dbGoTop()
IF dbSeek( Str( nanouso, 4 ) + Str( mNUMERO, 8 ) )
netrecapp()
field->numero := mNUMERO
field->ano    := anouso
ENDIF
dbSelectAr( pes )
@ PRow() + 3, 7 SAY PIS
@ PRow(), 20   SAY NOME
@ PRow(), 62   SAY AVOSM
@ PRow(), 65   SAY RAIZJAN                                                                                                                                                                                                       PICT '@E ####,###.##'
@ PRow(), 78   SAY RAIZFEV                                                                                                                                                                                                       PICT '@E ####,###.##'
@ PRow(), 91   SAY RAIZMAR                                                                                                                                                                                                       PICT '@E ####,###.##'
@ PRow(), 104  SAY RAIZABR                                                                                                                                                                                                       PICT '@E ####,###.##'
@ PRow() + 2, 5 SAY IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ) + "/" + SubStr( TIRAOUT( CPF ), 8 ), PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
@ PRow(), 20   SAY NASC
@ PRow(), 31   SAY ADMITIDO
@ PRow(), 41   SAY '1'
@ PRow(), 44   SAY StrZero( Month( ADMITIDO ), 2 ) + '/' + Right( Str( Year( ADMITIDO ), 4 ), 2 )
@ PRow(), 48   SAY SAL13_1                                                                                                                                                                                                       PICT '@E ####,###.##'
@ PRow(), 62   SAY MES_1
@ PRow(), 65   SAY RAIZMAI                                                                                                                                                                                                       PICT '@E ####,###.##'
@ PRow(), 78   SAY RAIZJUN                                                                                                                                                                                                       PICT '@E ####,###.##'
@ PRow(), 91   SAY RAIZJUL                                                                                                                                                                                                       PICT '@E ####,###.##'
@ PRow(), 104  SAY RAIZAGO                                                                                                                                                                                                       PICT '@E ####,###.##'
@ PRow() + 2, 5 SAY OBTER( "FUNCAO",, FOPES->FUNCAO, "CBONEW" ) // CBONEW
@ PRow(), 11   SAY FORAIS->RAISVINC
@ PRow(), 13   SAY FORAIS->RAISSITU
@ PRow(), 15   SAY ESCRAIS
@ PRow(), 17   SAY NASCPAIS
IF NACPAIS <> "1058"
@ PRow(), 21 SAY Str( ANONASCI ) + ' ' + mPAIS
ENDIF
IF Empty( DEMITIDO )
@ PRow(), 20 SAY SALDEZ PICT '@E ###########.##'
ELSE
MESDEM := Month( DEMITIDO )
XSAL   := 'SAL' + SubStr( MMES( MESDEM ), 1, 3 )
XSAL   := &XSAL.
@ PRow(), 20 SAY XSAL                                           PICT '@E ###########.##'
@ PRow(), 41 SAY StrZero( Day( DEMITIDO ), 2 ) + '/' + StrZero( MESDEM, 2 )
@ PRow(), 47 SAY MOTIVO
ENDIF
@ PRow(), 35  SAY TIPO
@ PRow(), 37  SAY HRSEM   PICT '##'
@ PRow(), 48  SAY SAL13_2 PICT '@E ####,###.##'
@ PRow(), 62  SAY MES_2
@ PRow(), 65  SAY RAIZSET PICT '@E ####,###.##'
@ PRow(), 78  SAY RAIZOUT PICT '@E ####,###.##'
@ PRow(), 91  SAY RAIZNOV PICT '@E ####,###.##'
@ PRow(), 104 SAY RAIZDEZ PICT '@E ####,###.##'
dbSkip()
ENDDO
IMPFOL()
VIDEO()
SET PRINT ON
?? Chr( 27 ) + 'C' + Chr( 66 )
SET PRINT OFF
dbCloseAll()
IMPEND()
RETU

// !*****************************************************************************
// !
// !       CABRAIS
// !
// !    Chamado por: FOLIS_C9.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABRAIS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CABRAIS

   @ PRow() + SALTO, 5 SAY MSG2
   @ PRow() + 2, 7    SAY ENDERR
   @ PRow() + 1, 103  SAY StrZero( FL, 4 ) + '/' + XLF2
   @ PRow(), 114     SAY ANOBAS                 PICT '####'
   @ PRow() + 1, 7    SAY BAIRRR
   @ PRow() + 2, 7    SAY CPR
   @ PRow(), 19      SAY CIDADR
   @ PRow(), 55      SAY ESTADR
   IF SCGC <> SPAC( 18 )
      @ PRow(), 103 SAY 'X'
   ENDIF
   IF XENDERE <> ' '
      @ PRow(), 111 SAY 'X'
   ENDIF
   @ PRow() + 2, 61 SAY CGC
   @ PRow(), 84    SAY ATI
   @ PRow(), 90    SAY NAT
   @ PRow(), 93    SAY SOC   PICT '##'
   @ PRow(), 96    SAY FAMIL PICT '##'
   @ PRow(), 101   SAY SCGC
   RETU

// : FIM: FOLIS_C9.PRG

// + EOF: folis_c9.prg
// +
