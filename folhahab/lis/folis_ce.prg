// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_ce.prg
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
// :   FOLIS_C7.PRG: Imprimir Informe de Rendimentos Avulso Juridico
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"

xrRESN := OBTER( "FIRMA",, NREMP, "RESPONSAV" )
DXDIA2 := Date()



@ 21, 00 CLEA
@ 21, 00 SAY 'Nome do Respons†vel'
@ 22, 00 SAY 'Qual a data para impressao'
@ 21, 40 GET xrRESN
@ 22, 40 GET DXDIA2
IF !READCUR()
RETU .F.
ENDIF


// Relatorio.
IF !CHECKIMP( 0 )
RETU .F.
ENDIF



IF !NETUSE( "IRRF01" )  // AREDE("IRRF01","IRRF01",1)
RETU .F.
ENDIF
IF !NETUSE( "IRRF02" )  // AREDE("IRRF02","IRRF02",3)
dbCloseAll()
RETU .F.
ENDIF
dbSelectAr( "IRRF01" )
FILTRO := ''
FILTRO := FILTRO( FILTRO )
SET FILTER TO &FILTRO


IMPRESSORA()
dbSelectAr( "IRRF01" )
dbGoTop()
WHILE !Eof()
mNUMERO := NUMERO
xCONTA  := 1
nTOTREN := 0
nTOTIMP := 0
@  0, 0  SAY REPL( "-", 80 )
@  1, 0  SAY "|         MINISTERIO DA FAZENDA"
@  1, 40 SAY "|   COMPROVANTE ANUAL DE RENDIMENTOS"
@  1, 79 SAY "|"
@  2, 00 SAY "|"
@  2, 40 SAY ACENTO( "| PAGOS OU CREDITADOS E DE RETENÄéO DE" )
@  2, 79 SAY "|"
@  3, 00 SAY "|         SECRETARIA DA RECEITA FEDERAL"
@  3, 40 SAY "|      IMPOSTO DE RENDA NA FONTE"
@  3, 79 SAY "|"
@  4, 00 SAY "|"
@  4, 40 SAY "|          - * PESSOA JURIDICA * -"
@  4, 79 SAY "|"
@  5, 0  SAY REPL( "-", 80 )
@  6, 00 SAY " 1.NR. DO DOCUMENTO"
@  6, 25 SAY ACENTO( " 2.ANO - CALENDèRIO" )
@  6, 50 SAY " 3.FONTE PAGADORA-PESSOA JUR."
@  7, 00 SAY "|" + REPL( "-", 24 ) + "|" + REPL( "-", 24 ) + "|" + REPL( "-", 28 ) + "|"
@  8, 00 SAY "|   " + DOCUMENTO
@  8, 25 SAY "|   " + Str( ANO, 4 )
@  8, 50 SAY "| Carimbo do CGC"
@  8, 79 SAY "|"
@  9, 00 SAY "|" + REPL( "-", 24 ) + "|" + REPL( "-", 24 ) + "|" + REPL( "-", 28 ) + "|"
@ 10, 0  SAY ACENTO( " 4.BENEFICIARIO DOS RENDIMENTOS - " + IF( PESSOA = "F", "PESSOA FISICA", "PESSOA JURIDICA" ) )
@ 10, 50 SAY "|"
@ 10, 79 SAY "|"
@ 11, 0  SAY "|" + REPL( "-", 49 ) + "|"
@ 11, 79 SAY "|"
@ 12, 00 SAY IF( PESSOA = "F", "| CPF: ", "| CGC: " ) + CGC
@ 12, 50 SAY "|"
@ 12, 79 SAY "|"
@ 13, 0  SAY "|" + REPL( "-", 49 ) + "|"
@ 13, 79 SAY "|"
@ 14, 50 SAY "|"
@ 14, 79 SAY "|"
@ 14, 0  SAY "|" + IMPSTR( cIMPCOM ) + " RAZAO SOCIAL: " + IMPSTR( cIMPEXP ) + NOME
@ 15, 0  SAY "|" + REPL( "-", 49 ) + "|"
@ 15, 79 SAY "|"
@ 16, 0  SAY "| ENDERECO:  " + ENDERECO
@ 16, 50 SAY "|"
@ 16, 79 SAY "|"
@ 17, 0  SAY "|" + REPL( "-", 49 ) + "|"
@ 17, 79 SAY "|"
@ 18, 0  SAY "| CIDADE:  " + CIDADE
@ 18, 36 SAY "| UF: " + ESTADO
@ 18, 50 SAY "|"
@ 18, 79 SAY "|"
@ 19, 0  SAY "|" + REPL( "-", 49 ) + "|"
@ 19, 50 SAY "|" + REPL( "-", 28 ) + "|"
@ 19, 79 SAY "|"
@ 20, 00 SAY " 5.RENDIMENTO BRUTO E IMPOSTO DE RENDA RETIDO NA FONTE"
@ 21, 00 SAY "|-----|" + REPL( "-", 9 ) + "|" + REPL( "-", 24 ) + "|" + REPL( "-", 13 ) + "|" + REPL( "-", 9 ) + "|" + REPL( "-", 13 ) + "|"
@ 22, 0  SAY "| MES"
@ 22, 6  SAY "|CODIGO  "
@ 22, 16 SAY "| NATUREZA DO RENDIMENTO"
@ 22, 41 SAY "|RENDIMENTO"
@ 22, 55 SAY "|ALIQUOTA"
@ 22, 79 SAY "|"
@ 22, 65 SAY "|" + IMPSTR( cIMPCOM ) + "IMPOSTO DE RENDA" + IMPSTR( cIMPEXP )
@ 23, 00 SAY "|"
@ 23, 6  SAY "|  DARF  "
@ 23, 41 SAY "|BRUTO R$"
@ 23, 55 SAY "| (%) "
@ 23, 65 SAY "|RETIDO R$"
@ 23, 79 SAY "|"
@ 24, 00 SAY "|-----|" + REPL( "-", 9 ) + "|" + REPL( "-", 24 ) + "|" + REPL( "-", 13 ) + "|" + REPL( "-", 9 ) + "|" + REPL( "-", 13 ) + "|"
CTLIN := 25
dbSelectAr( "IRRF02" )
dbGoTop()
dbSeek( Str( mNUMERO, 8 ) )
WHILE mNUMERO = NUMERO .AND. !Eof()
mRENDA    := 0
mIRRF     := 0
mALIQUOTA := ALIQUOTA
mDARF     := DARF
mNATUREZA := NATUREZA
mMES      := MES
WHILE mNUMERO = NUMERO .AND. MES = mMES .AND. DARF = mDARF .AND. mALIQUOTA = ALIQUOTA .AND. !Eof()
mRENDA  += RENDA
mIRRF   += IRRF
nTOTREN += RENDA
nTOTIMP += IRRF
dbSkip()
ENDDO
xCONTA++
@ CTLIN, 00 SAY "|" + Str( mMES, 4 )
@ CTLIN, 6  SAY "|  " + mDARF
@ CTLIN, 16 SAY "| " + Left( mNATUREZA, 20 )
@ CTLIN, 41 SAY "|"
@ CTLIN, 42 SAY mRENDA                  PICT "@E 999,999.99"
@ CTLIN, 55 SAY "|"
@ CTLIN, 56 SAY mALIQUOTA
@ CTLIN, 65 SAY "|"
@ CTLIN, 66 SAY mIRRF                   PICT "@E 99,999.99"
@ CTLIN, 79 SAY "|"
CTLIN++
@ CTLIN, 00 SAY "|-----|" + REPL( "-", 9 ) + "|" + REPL( "-", 24 ) + "|" + REPL( "-", 13 ) + "|" + REPL( "-", 9 ) + "|" + REPL( "-", 13 ) + "|"
CTLIN++
ENDDO
FOR X := xCONTA TO 12
@ CTLIN, 00 SAY "|     |" + REPL( " ", 9 ) + "|" + REPL( " ", 24 ) + "|" + REPL( " ", 13 ) + "|" + REPL( " ", 9 ) + "|" + REPL( " ", 13 ) + "|"
CTLIN++
@ CTLIN, 00 SAY "|-----|" + REPL( "-", 9 ) + "|" + REPL( "-", 24 ) + "|" + REPL( "-", 13 ) + "|" + REPL( "-", 9 ) + "|" + REPL( "-", 13 ) + "|"
CTLIN++
NEXT X
dbSelectAr( "IRRF01" )
@ CTLIN, 00 SAY "|  " + "TOTAL"
@ CTLIN, 41 SAY "|"
@ CTLIN, 42 SAY nTOTREN       PICT "@E 999,999.99"
@ CTLIN, 55 SAY "|"
@ CTLIN, 65 SAY "|"
@ CTLIN, 66 SAY nTOTIMP       PICT "@E 99,999.99"
@ CTLIN, 79 SAY "|"
CTLIN++
@ CTLIN, 0 SAY REPL( "-", 80 )
CTLIN++
@ CTLIN, 0 SAY ACENTO( " RESPONSèVEL PELAS INFORMAÄôES" )
CTLIN++
@ CTLIN, 0 SAY REPL( "-", 80 )
CTLIN++
@ CTLIN, 0  SAY "| NOME: " + xrRESN
@ CTLIN, 36 SAY "| DATA " + DToC( DXDIA2 )
@ CTLIN, 52 SAY "|  ASSINATURA"
@ CTLIN, 79 SAY "|"
CTLIN++
@ CTLIN, 0 SAY REPL( "-", 80 )
CTLIN++
@ CTLIN, 0 SAY "Aprovado pela IN/SRF nß 120/2000, com as alteraá‰es da IN/SRF nß 288/2003"
dbSkip()
IMPFOL()
ENDDO
dbCloseAll()
VIDEO()
IMPEND()

// + EOF: folis_ce.prg
// +
