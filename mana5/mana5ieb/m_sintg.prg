// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_sintg.prg
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

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_SINTG.PRG
// +
// +    Functions: Function SINTG01()
// +
// +    Reformatted by Click! 2.03 on Nov-27-2002 at  1:48 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
#include "BOX.CH"

GRAVA50 := "S"
GRAVA51 := "S"
GRAVA54 := "S"
GRAVA53 := "N"
GRAVA70 := "S"
nREG50  := 0
nREG51  := 0
nREG54  := 0
nREG53  := 0
nREG70  := 0
nREG75  := 0
cANO    := StrZero( Year( ZDATA ), 4 )
cMES    := StrZero( Month( ZDATA ), 2 )
// cARQ:="C:\TEMP\S"+cANO+cMES+STRZERO(ZNUMERO,1)+".TXT"+SPACE(10)
cARQ := WIN_GETSAVEFILENAME(, "Salvar Sintegra", "C:\TEMP\", "txt", "*.txt", 1,, "S" + cANO + cMES + StrZero( ZNUMERO, 1 ) + ".TXT" )


MDI( " Gera SINTEGRA " )
IF !USEREDE( "MANEMP", 1, 1 )
RETU .F.
ENDIF
dbGoTop()
IF !dbSeek( ZNUMERO )
dbCloseAll()
ALERTX( "Falta Cadastro Empresa" )
RETU
ELSE
cCGC      := CGC
cIE       := INSCR
cCIDADE   := CIDADE
cESTADO   := ESTADO
cNOME     := NOME
cTELEFAX  := TELEFAX
cDDDFAX   := DDDFAX
cENDERE   := ENDERECO
cBAIRRO   := BAIRRO
cCEP      := CEP
cCONTATO  := CONTATO
cDDD      := DDD
cTELEFONE := TELEFONE
ENDIF
dbCloseAll()

dINI := dFIM := ZDATA

cNUMERO   := "0"
cENDERECO := cENDERE
nPOS      := At( ",", cENDERE )
IF nPOS > 0
cENDERECO := SubStr( cENDERE, 1, nPOS - 1 )
cNUMERO   := SubStr( cENDERE, nPOS + 1 )
ENDIF

IF Empty( cCONTATO )
cCONTATO := "Contato"
ENDIF
cIE       := ACEPAD( TIRAOUT( cIE ), 14 )
cENDEREDO := ACEPAD( TIRAOUT( cENDERECO ), 34 )
cBAIRRO   := ACEPAD( TIRAOUT( cBAIRRO ), 15 )
cCONTATO  := ACEPAD( cCONTATO, 28 )
cNUMERO   := ACEPAD( cNUMERO, 5 )
cNOME     := ACEPAD( TIRAOUT( cNOME ), 35 )
cCIDADE   := ACEPAD( TIRAOUT( cCIDADE ), 30 )
cCON      := "3"  // XX/02 4.1.0 //3 Versao 5.0.2
cOPE      := "3"
cFIN      := "1"

cDDD      := StrZero( Val( TIRAOUT( cDDD ) ), 2 )
cTELEFONE := StrZero( Val( TIRAOUT( cTELEFONE ) ), 8 )
cDDDFAX   := StrZero( Val( TIRAOUT( cDDDFAX ) ), 2 )
cTELEFAX  := StrZero( Val( TIRAOUT( cTELEFAX ) ), 8 )

hb_DispBox( 4, 0, 23, 79, B_DOUBLE )
@  5, 2  SAY "Dados do Reponsavel Pelo Arquivo"
@  6, 2  SAY "Endereco"
@  6, 23 SAY "Numero"
@  6, 29 SAY "Bairro"
@  6, 45 SAY "Cidade"
@  6, 77 SAY "UF"
@  8, 02 SAY "CGC"
@  8, 22 SAY "IE"
@  8, 42 SAY "Nome"
@ 10, 02 SAY "DDD Telefone DDDFAX FaxNo. CEP"
@ 10, 42 SAY "Contato"
@ 13, 02 SAY "Opera‡Жo"
@ 13, 22 SAY "(1)Inter-Subs (2)Inter (3)Todas"
@ 15, 02 SAY "Finaliade"
@ 15, 22 SAY "(1)Normal (2)Ret.Sub (3)Ret.Adc (4)Ret.Cor (5)Desfaz"
@ 19, 02 SAY "Nome do Arquivo"
@ 19, 50 SAY "Periodo"
@ 21, 02 SAY "Grava Reg 50"
@ 21, 22 SAY "Grava Reg 51"
@ 21, 42 SAY "Grava Reg 54"
@ 22, 02 SAY "Grava Reg 53"
@ 22, 22 SAY "Grava Reg 70"
@  7, 2  GET cENDERECO
@  7, 23 GET cNUMERO
@  7, 29 GET cBAIRRO
@  7, 45 GET cCIDADE
@  7, 77 GET cESTADO
@  9, 2  GET cCGC
@  9, 22 GET cIE
@  9, 42 GET cNOME
@ 11, 02 GET cDDD
@ 11, 06 GET cTELEFONE
@ 11, 16 GET cDDDFAX
@ 11, 20 GET cTELEFAX
@ 11, 30 GET cCEP
@ 11, 42 GET cCONTATO
@ 13, 18 GET cOPE
@ 15, 18 GET cFIN
@ 19, 20 GET cARQ
@ 19, 60 GET dINI
@ 19, 70 GET dFIM
@ 21, 15 GET GRAVA50
@ 21, 35 GET GRAVA51
@ 21, 65 GET GRAVA54
@ 22, 15 GET GRAVA53
@ 22, 35 GET GRAVA70
IF !READCUR()
RETU .F.
ENDIF

cARQ := StrTran( cARQ, " ", "" )

IF !USEMULT( { { "SINT50", 0, 1 }, { "SINT51", 0, 1 }, { "SINT70", 0, 1 }, ;
         { "SINT54", 0, 1 }, { "SINT75", 0, 1 }, { "SINT53", 0, 1 } } )
RETU .F.
ENDIF
USO := FCreate( cARQ )
IF FError() # 0
ALERTX( "Erro na Cria‡„o do Arquivo" )
RETU
ENDIF


FWrite( uso, "10" )
FWrite( uso, StrZero( Val( TIRAOUT( cCGC ) ), 14 ) )
FWrite( uso, ACEPAD( cIE, 14 ) )
FWrite( uso, ACEPAD( cNOME, 35 ) )
FWrite( uso, ACEPAD( cCIDADE, 30 ) )
FWrite( uso, cESTADO )
FWrite( uso, cDDDFAX + cTELEFAX )
FWrite( uso, DToS( dINI ) )
FWrite( uso, DToS( dFIM ) )
FWrite( uso, cCON )
FWrite( uso, cOPE )
FWrite( uso, cFIN )
FWrite( USO, hb_osNewLine() )

FWrite( uso, "11" )
FWrite( uso, ACEPAD( cENDERECO, 34 ) )
FWrite( uso, StrZero( Val( cNUMERO ), 5 ) )
FWrite( uso, Space( 22 ) )
FWrite( uso, ACEPAD( cBAIRRO, 15 ) )
FWrite( uso, StrZero( Val( TIRAOUT( cCEP ) ), 8 ) )
FWrite( uso, ACEPAD( cCONTATO, 28 ) )
FWrite( uso, "00" + cDDD + cTELEFONE )
FWrite( USO, hb_osNewLine() )

IF GRAVA50 = "S"
SINTG01( "SINT50" )
ENDIF
IF GRAVA51 = "S"
SINTG01( "SINT51" )
ENDIF

IF GRAVA53 = "S"
SINTG01( "SINT53" )
ENDIF


IF GRAVA54 = "S"
dbSelectAr( "SINT75" )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netgrvcam( "gerado", .F. ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
@ 24, 00 SAY "SINT54"
dbSelectAr( "SINT54" )
dbGoTop()
WHILE !Eof()
@ 24, 10 SAY RecNo()
IF cOPE = "3" .OR. UF # cESTADO   // todas operacoes ou interestaduais
FWrite( uso, "54" )   // 1
FWrite( uso, StrZero( Val( TIRAOUT( CGC ) ), 14 ) )  // 2
FWrite( uso, StrZero( MODELO, 2 ) )  // 3
FWrite( uso, Left( SERIE, 3 ) )  // 4
// fwrite( uso, left( SUB, 2 ) )
IF numero > 999999
cNUMERO := StrZero( NUMERO, 8 )
cNUMERO := Right( cNUMERO, 6 )
FWrite( uso, cNUMERO )   // 5
ELSE
FWrite( uso, StrZero( NUMERO, 6 ) )   // 5
ENDIF
FWrite( uso, CFOP )   // 6
FWrite( uso, StrZero( SITUACAO, 3 ) )  // 7
FWrite( uso, StrZero( ITEM, 3 ) )  // 8
FWrite( uso, ACEPAD( CODIGORED, 14 ) )   // 9
FWrite( uso, GRVVAL( QTDE, 11, 3 ) )  // 10
FWrite( uso, GRVVAL( VALORMER, 12, 2 ) )  // 11
FWrite( uso, GRVVAL( DESCONTO, 12, 2 ) )  // 12
FWrite( uso, GRVVAL( BASEICM, 12, 2 ) )   // 13
FWrite( uso, GRVVAL( BASESUB, 12, 2 ) )   // 13 Base de Calculo Sub Tributaria
FWrite( uso, GRVVAL( VALORIPI, 12, 2 ) )  // 15
FWrite( uso, GRVVAL( ICM, 4, 2 ) )  // 16
FWrite( USO, hb_osNewLine() )
nREG54++
mCODIGORED := CODIGORED
IF ITEM <= 990   // 991 a 999 frete seguro outros
dbSelectAr( "SINT75" )
dbGoTop()
IF dbSeek( mCODIGORED )
netgrvcam( "GERADO", .T. )
ENDIF
ENDIF
dbSelectAr( "SINT54" )
ENDIF
dbSkip()
ENDDO
ENDIF

IF GRAVA70 = "S"  // 70 Conhecimento de Transporte
SINTG01( "SINT70" )
ENDIF

IF GRAVA54 = "S"  // 75 54 acima
@ 24, 00 SAY "SINT75"
dbSelectAr( "SINT75" )
dbGoTop()
WHILE !Eof()
@ 24, 10 SAY RecNo()
IF GERADO
FWrite( uso, "75" )
FWrite( uso, DToS( dINI ) )
FWrite( uso, DToS( dFIM ) )
FWrite( uso, ACEPAD( CODIGORED, 14 ) )
FWrite( uso, ACEPAD( TIRAOUT( CLASSIPI ), 8 ) )
FWrite( uso, ACEPAD( DESCRICAO, 53 ) )
FWrite( uso, ACEPAD( UNID, 6 ) )
// fwrite( uso, strzero( SITUACAO, 3 ) )
FWrite( uso, grvval( IPI, 5, 2 ) )
FWrite( uso, grvval( ICM, 4, 2 ) )
IF REDICM > 0
nPERICM := 100 - REDICM
FWrite( uso, GRVVAL( nPERICM, 5, 2 ) )
ELSE
FWrite( uso, GRVVAL( 0, 5, 2 ) )
ENDIF
FWrite( uso, GRVVAL( SUBICM, 13, 2 ) )
FWrite( USO, hb_osNewLine() )
nREG75++
ENDIF
dbSkip()
ENDDO
ENDIF

nSPACE := 85
nGER   := 3   // 10 E 11 E 90

FWrite( USO, "90" )
FWrite( uso, StrZero( Val( TIRAOUT( cCGC ) ), 14 ) )
FWrite( uso, ACEPAD( cIE, 14 ) )
IF GRAVA50 = "S"
FWrite( uso, "50" )
FWrite( uso, StrZero( nREG50, 8 ) )
nSPACE -= 10
nGER   += nREG50
ENDIF
IF GRAVA51 = "S"
FWrite( uso, "51" )
FWrite( uso, StrZero( nREG51, 8 ) )
nSPACE -= 10
nGER   += nREG51
ENDIF
IF GRAVA53 = "S"
FWrite( uso, "53" )
FWrite( uso, StrZero( nREG53, 8 ) )
nSPACE -= 10
nGER   += nREG53
ENDIF
IF GRAVA54 = "S"  // 54 75 Abaixo
FWrite( uso, "54" )
FWrite( uso, StrZero( nREG54, 8 ) )
nSPACE -= 10
nGER   += nREG54
ENDIF
IF GRAVA70 = "S"
FWrite( uso, "70" )
FWrite( uso, StrZero( nREG70, 8 ) )
nSPACE -= 10
nGER   += nREG70
ENDIF
IF GRAVA54 = "S"  // 75 Requerido quando 54
FWrite( uso, "75" )
FWrite( uso, StrZero( nREG75, 8 ) )
nSPACE -= 10
nGER   += nREG75
ENDIF

FWrite( uso, "99" )
FWrite( uso, StrZero( nGER, 8 ) )
FWrite( uso, Space( nSPACE ) )
FWrite( uso, "1" )
FWrite( USO, hb_osNewLine() )

FClose( USO )
dbCloseAll()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function SINTG01()
// +
// +    Called from ( m_sintg.prg  )   2 -
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SINTG01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC SINTG01( cARQ )

   @ 24, 00 SAY cARQ
   dbSelectAr( cARQ )
   dbGoTop()
   WHILE !Eof()
      @ 24, 10 SAY RecNo()
      IF cOPE = "3" .OR. UF # cESTADO
         FWrite( uso, TIPO )
         IF UF = "XX" .OR. UF = "EX"
            FWrite( uso, REPL( "0", 14 ) )
         ELSE
            FWrite( uso, StrZero( Val( TIRAOUT( CGC ) ), 14 ) )
         ENDIF
         IF UF = "XX" .OR. UF = "EX"
            FWrite( uso, ACEPAD( "ISENTO", 14 ) )
         ELSE
            FWrite( uso, ACEPAD( TIRAOUT( IE ), 14 ) )
         ENDIF
         FWrite( uso, DToS( DATA ) )
         IF UF = "XX" .OR. UF = "EX"
            FWrite( uso, "EX" )
         ELSE
            FWrite( uso, UF )
         ENDIF
         IF cARQ = "SINT50" .OR. cARQ = "SINT53"
            FWrite( uso, StrZero( MODELO, 2 ) )
            FWrite( uso, Left( SERIE, 3 ) )
            // fwrite( uso, left( SUB, 2 ) )
         ENDIF
         IF cARQ = "SINT51"
            FWrite( uso, Left( SERIE, 3 ) )
            // fwrite( uso, left( SUB, 2 ) )
         ENDIF
         IF cARQ = "SINT70"
            FWrite( uso, StrZero( MODELO, 2 ) )
            FWrite( uso, Left( SERIE, 1 ) )
            FWrite( uso, Left( SUB, 2 ) )
         ENDIF
         IF numero > 999999
            cNUMERO := StrZero( NUMERO, 8 )
            cNUMERO := Right( cNUMERO, 6 )
            FWrite( uso, cNUMERO )
         ELSE
            FWrite( uso, StrZero( NUMERO, 6 ) )
         ENDIF
         FWrite( uso, CFOP )
         IF cARQ = "SINT50"
            FWrite( uso, "P" )
         ENDIF
         IF cARQ = "SINT53"
            FWrite( uso, "T" )
         ENDIF
         nVALORTOT := VALORTOT
         IF nVALORTOT = 0
            nVALORTOT := 0.01
         ENDIF
         DO CASE
         CASE carq = "SINT53"
            FWrite( uso, GRVVAL( BASE, 13, 2 ) )
            FWrite( uso, GRVVAL( VALOR, 13, 2 ) )
            FWrite( uso, GRVVAL( 0, 13, 2 ) )   // Despesas Acessorias
         CASE carq = "SINT70"
            FWrite( uso, GRVVAL( nVALORTOT, 13, 2 ) )
            FWrite( uso, GRVVAL( BASE, 14, 2 ) )
            FWrite( uso, GRVVAL( VALOR, 14, 2 ) )
            FWrite( uso, GRVVAL( ISENTA, 14, 2 ) )
            FWrite( uso, GRVVAL( OUTRAS, 14, 2 ) )
         OTHERWISE
            FWrite( uso, GRVVAL( nVALORTOT, 13, 2 ) )
            IF cARQ = "SINT50"
               FWrite( uso, GRVVAL( BASE, 13, 2 ) )
            ENDIF
            FWrite( uso, GRVVAL( VALOR, 13, 2 ) )
            FWrite( uso, GRVVAL( ISENTA, 13, 2 ) )
            FWrite( uso, GRVVAL( OUTRAS, 13, 2 ) )
         ENDCASE
         IF cARQ = "SINT51"
            FWrite( uso, Space( 20 ) )
         ENDIF
         IF cARQ = "SINT50"
            FWrite( uso, GRVVAL( ALIQUOTA, 4, 2 ) )
         ENDIF
         IF cARQ = "SINT70"
            FWrite( uso, FRETE )
         ENDIF
         FWrite( uso, SITUACAO )
         IF cARQ = "SINT53"
            FWrite( uso, Space( 1 ) )   // Codigo Antecipacao tributaria
            FWrite( uso, Space( 29 ) )
         ENDIF
         FWrite( USO, hb_osNewLine() )
         DO CASE
         CASE cARQ = "SINT50"
            nREG50++
         CASE cARQ = "SINT51"
            nREG51++
         CASE cARQ = "SINT53"
            nREG53++
         CASE cARQ = "SINT70"
            nREG70++
         ENDCASE
      ENDIF
      dbSkip()
   ENDDO
   RETU

// + EOF: M_SINTG.PRG

// + EOF: m_sintg.prg
// +
