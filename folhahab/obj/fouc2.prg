// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fouc2.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :      FOUC2.PRG: Cadastro de Admitidos e Demitidos
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1997,  jcassiano  S/C Ltda.
// :  Atualizado em: 02/10/97
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"
#include "INKEY.CH"

CABEX( 'Cadastro de Admitidos e Demitidos' )

PRIV HELPDBF := "100329"
POS1 := SPAC( 40 )
aNUM := {}
aCOD := {}
aTIP := {}

CTA10    := CTA20 := CTA25 := CTA31 := CTA32 := CTA35 := CTA40 := 0
CTA43    := CTA45 := CTA50 := CTA60 := CTA70 := CTA80 := 0
CTFOL    := ATIVOS := SALM := 0
aTELA    := TELAPEG( "CAGED" )
cCOMANO  := StrZero( Year( DXDIA ), 4 )
cCOMMES  := StrZero( MESTRAB, 2 )
cCONTATO := PadR( OBTER( "FIRMA",, NREMP, "RESPONSAV" ), 20 )
cNUMCON  := PadR( OBTER( "FIRMA",, NREMP, "CONCAGED" ), 7 )
mPORTE   := PadR( OBTER( "FIRMA",, NREMP, "PORTE" ), 1 )
IF mPORTE = "O"
mPORTE := "N"
ENDIF
IF mPORTE = "N"
mPORTE := "1"
ELSE
mPORTE := "2"
ENDIF




// @ 16,00 SAY 'Arquivo'
// @ 18,00 SAY 'Caminho para gerar arquivo'
@ 20, 00 SAY 'Confime a Competencia'
@ 22, 00 SAY 'Digite Cabecario Complementar'
// @ 16,40 GET cARQNOM
// @ 18,40 GET CAMINHO
@ 20, 40 GET cCOMMES
@ 20, 45 GET cCOMANO
@ 22, 40 GET POS1
IF !READCUR()
RETU
ENDIF

cARQ := WIN_GETSAVEFILENAME(, "Arquivo caged", "c:\temp\", "txt", "*.txt", 1,, "C" + cCOMANO + ".M" + cCOMMES )


IF !netuse( pes )
RETU
ENDIF
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO)).AND.CATEGORIA<>"11".AND.CATEGORIA<>"05"'
SET FILTER TO &FILTRO

// 1a. Passagens Admitidos
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
IF Month( ADMITIDO ) = MES .AND. Year( ADMITIDO ) = ANO
PETELA( 4 )
FOUC2A( 1 )
ENDIF
IF Year( ADMITIDO ) < ANO .OR. Month( ADMITIDO ) < MESc
ATIVOS++
ENDIF
dbSkip()
ENDDO

// 2a. Passagens Demitidos
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
IF Month( DEMITIDO ) = MES .AND. Year( DEMITIDO ) = ANO
PETELA( 7 )
FOUC2A( 2 )
ENDIF
dbSkip()
ENDDO

IF CTFOL = 0
dbCloseAll()
RETU
ENDIF




IF MDG( "Gerar arquivo Rais" )
IF !netuse( "FIRMA" )
dbCloseAll()
RETU
ENDIF

nSEQ := 1
USO  := FCreate( cARQ )  // ABRINDO ARQUIVO
IF FError() # 0
ALERTX( "Erro na Criacao do Arquivo" )
RETU
ENDIF
dbSelectAr( "FIRMA" )
IF PESSOA = 'J'
mCGC := SubStr( CGC, 1, 2 ) + SubStr( CGC, 4, 3 ) + SubStr( CGC, 8, 3 ) + SubStr( CGC, 12, 4 ) + SubStr( CGC, 17, 2 )
mPES := "1"
ELSE
mCGC := "00" + CEI
mPES := "2"
ENDIF
xCEP      := StrTran( CEP, "-", "" )
xCEP      := StrTran( XCEP, " ", "0" )
xTELEFONE := StrTran( TELEFONE, "-", "" )
xTELEFONE := StrTran( XTELEFONE, " ", "0" )
// Regitro tipo A
FWrite( USO, "A" )
FWrite( USO, "2" )
FWrite( USO, cNUMCON )
FWrite( USO, cCOMMES )
FWrite( USO, cCOMANO )
FWrite( USO, "2" )
FWrite( USO, StrZero( nSEQ, 5 ) )
FWrite( USO, mPES )
FWrite( USO, PadR( mCGC, 14 ) )
FWrite( USO, ACEPAD( RAZAO, 35 ) )
FWrite( USO, ACEPAD( ENDERECO, 40 ) )  // Logradouro
FWrite( USO, PadR( xCEP, 8 ) )
FWrite( USO, ACEPAD( ESTADO, 2 ) )
FWrite( USO, ACEPAD( DDD, 4 ) )
FWrite( USO, PadR( xTELEFONE, 8 ) )
FWrite( USO, PadR( RAMAL, 5 ) )
FWrite( USO, "00001" )
FWrite( USO, StrZero( Len( aNUM ), 5 ) )
FWrite( USO, "  " + hb_osNewLine() )
// Regitro tipo b
nSEQ++
FWrite( USO, "B" )
FWrite( USO, mPES )
FWrite( USO, PadR( mCGC, 14 ) )
FWrite( USO, StrZero( nSEQ, 5 ) )
FWrite( USO, "2" )
FWrite( USO, "1" )
FWrite( USO, PadR( xCEP, 8 ) )
FWrite( USO, PadR( ATIVIDADE, 5 ) )
FWrite( USO, ACEPAD( RAZAO, 40 ) )
FWrite( USO, ACEPAD( ENDERECO, 40 ) )
FWrite( USO, ACEPAD( BAIRRO, 20 ) )
FWrite( USO, ACEPAD( ESTADO, 2 ) )
FWrite( USO, StrZero( ATIVOS, 5 ) )
FWrite( USO, mPORTE )
FWrite( USO, Space( 6 ) )
FWrite( USO, hb_osNewLine() )
FOR X := 1 TO Len( aNUM )
dbSelectAr( PES )
dbGoTop()
IF dbSeek( aNUM[ X ] )
DATANAS := StrZero( Day( NASC ), 2 ) + StrZero( Month( NASC ), 2 ) + StrZero( Year( NASC ), 4 )
DATADM  := StrZero( Day( ADMITIDO ), 2 ) + StrZero( Month( ADMITIDO ), 2 ) + StrZero( Year( ADMITIDO ), 4 )
SALM    := 0   // Zero o Salario Evitar Erro Chamafuncao
SALHM()
cSALM   := StrZero( SALM, 9, 2 )
cSALM   := StrTran( cSALM, ".", "" )
cHRME   := PadR( Int( HRSEM ), 2 )
mESCOLA := Val( ESCRAIS )
IF mESCOLA > 9
mESCOLA := 9
ENDIF

// Regitro tipo C
nSEQ++
FWrite( USO, "C" )
FWrite( USO, mPES )
FWrite( USO, PadR( mCGC, 14 ) )
FWrite( USO, StrZero( nSEQ, 5 ) )
FWrite( USO, PIS )
FWrite( USO, IF( SEXO = "M", "1", "2" ) )
FWrite( USO, DATANAS )
FWrite( USO, Str( mESCOLA, 1 ) )
FWrite( USO, Space( 5 ) )
FWrite( USO, cSALM )
FWrite( USO, cHRME )
FWrite( USO, DATADM )
FWrite( USO, StrZero( aCOD[ X ], 2 ) )
FWrite( USO, IF( aTIP[ X ] = 1, "00", StrZero( Day( DEMITIDO ), 2 ) ) )
FWrite( USO, ACEPAD( NOME, 40 ) )
FWrite( USO, Right( PROFIS, 7 ) )
FWrite( USO, Right( SERIE, 3 ) )
FWrite( USO, ACEPAD( CTPSUF, 2 ) )
FWrite( USO, Space( 7 ) )
mRACA := OBTER( "FO_TAB",, "RACS" + AllTrim( Str( RACS ) ), "CODIG2" )
FWrite( USO, mRACA )
IF Val( DEFICI ) > 0
FWrite( USO, "2" )
ELSE
FWrite( USO, "1" )
ENDIF
FWrite( USO, OBTER( "FUNCAO",, FUNCAO, "CBONEW" ) )
FWrite( USO, Space( 14 ) )
FWrite( USO, hb_osNewLine() )
ENDIF
NEXT X




FWrite( USO, Chr( 26 ) )
FClose( USO )
ENDIF
IF !MDG( "Imprimir" )
RETU .F.
ENDIF

IF !MDL( 'Cad.Geral Empreg.Desemp. 4923/65', 0 )
RETU .F.
ENDIF

CTLIN := 80
FL    := 0
nENT  := CTA10 + CTA20 + CTA25 + CTA35 + CTA70  // ENTRADAS
nSAI  := CTA31 + CTA32 + CTA40 + CTA43 + CTA45 + CTA50 + CTA60 + CTA80
CTAG  := ATIVOS + nENT - nSAI   // SALDO


IF !NETUSE( "CAGED" )
dbCloseAll()
RETU
ENDIF

IMPRESSORA()

FOR X := 1 TO Len( aNUM )
dbSelectAr( PES )
dbGoTop()
IF dbSeek( aNUM[ X ] )
IF CTLIN > 55
FL++
@  1, 1  SAY impstr( Cimpcom )
@  2, 20 SAY IMPCHR( cIMPTIT ) + MSG2
@  3, 5  SAY IMPCHR( cIMPTIT ) + ' CADASTRO GERAL DE EMPREGADOS E DESEMPREGADOS LEI 4.923/65'
@  5, 0  SAY POS1
@  5, 50 SAY Time()
@  5, 60 SAY DXDIA
@  5, 70 SAY 'FL. ' + StrZero( FL, 4 )
@  6, 1  SAY CGC1 + "-" + MSG2
@  7, 0  SAY REPL( '-', 80 )
CTLIN := 8
IF FL = 1
dbSelectAr( "CAGED" )
dbGoTop()
WHILE !Eof()
@ CTLIN, 0 SAY CODIGO
@ CTLIN, 4 SAY TIRACE( DESCRICAO )
cVAR  := "CTA" + CODIGO
nQTDE := &cVAR.
@ CTLIN, 55 SAY nQTDE
CTLIN++
dbSkip()
ENDDO
@ CTLIN, 0 SAY REPL( '-', 80 )
CTLIN++
ENDIF
ENDIF
dbSelectAr( PES )
@ CTLIN, 0  SAY NUMERO
@ CTLIN, 9  SAY ADMITIDO
@ CTLIN, 18 SAY DEMITIDO
@ CTLIN, 27 SAY StrZero( aCOD[ X ], 2 )
@ CTLIN, 30 SAY NOME
CTLIN++
ENDIF
NEXT X
@ PRow() + 0, 0 SAY REPL( '-', 80 )
IMPFOL()
VIDEO()
dbCloseAll()
IMPEND()
RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOUC2A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOUC2A( nTIPO )

   TELASAY( aTELA )
   SET KEY K_F11 TO TECLAF11
   @ 12, 12 SAY ADMITIDO
   @ 14, 12 SAY DEMITIDO
   @  8, 33 GET MOTIVODEM VALID VERSEHA( "CAGED",, Str( MOTIVODEM, 2 ), "DESCRICAO", "'C¢digo CAGED inconsistente '" )
   IF nTIPO = 1
      @  8, 36 SAY "ADMISSAO"
   ELSE
      @  8, 36 SAY "DEMISSAO"
   ENDIF
   READCUR()
   SetKey( K_F11, nil )
   DO CASE
   CASE MOTIVODEM = 10
      CTA10++
   CASE MOTIVODEM = 20
      CTA20++
   CASE MOTIVODEM = 25
      CTA25++
   CASE MOTIVODEM = 31
      CTA31++
   CASE MOTIVODEM = 32
      CTA32++
   CASE MOTIVODEM = 35
      CTA35++
   CASE MOTIVODEM = 40
      CTA40++
   CASE MOTIVODEM = 43
      CTA43++
   CASE MOTIVODEM = 45
      CTA45++
   CASE MOTIVODEM = 50
      CTA50++
   CASE MOTIVODEM = 60
      CTA60++
   CASE MOTIVODEM = 70
      CTA70++
   CASE MOTIVODEM = 80
      CTA80++
   ENDCASE
   CTFOL++
   AAdd( aNUM, NUMERO )
   AAdd( aCOD, MOTIVODEM )
   AAdd( aTIP, nTIPO )
   RETU .T.

// : FIM: FOUC2.PRG

// + EOF: fouc2.prg
// +
