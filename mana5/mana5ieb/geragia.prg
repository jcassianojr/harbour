// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : geragia.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

MDI( "Ý Importando GIA" )
IF MDG( "Criar Acumulado por CFO" )
M_BDIG( 2 )
ENDIF
IF mdg( "Criar Acumulado por CFO-UF" )
M_BDIO()
ENDIF
IF mdg( "Criar Acumulado ZF/ALC" )
GIAZF()
ENDIF


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
cANO  := StrZero( Year( ZDATA ), 4 )
cMES  := StrZero( Month( ZDATA ), 2 )
cCNAE := "2833900"

cLAYOUT := "0206"


hb_DispBox( 4, 0, 23, 79, B_DOUBLE )
@  5, 2 SAY "Dados do Reponsavel Pelo Arquivo"

@ 06, 02 SAY "Nome do Arquivo"
@ 07, 02 SAY "Competencia"
@ 08, 02 SAY "Cnae"
@ 09, 02 SAY "Layout"
@ 07, 20 GET cMES
@ 07, 24 GET cANO
@ 08, 20 GET cCNAE
@ 09, 20 GET cLAYOUT
IF !READCUR()
RETU .F.
ENDIF

cARQUIVO := WIN_GETSAVEFILENAME(, "Salvar GIA", "C:\TEMP\", "txt", "*.txt", 1,, "G" + cANO + cMES + StrZero( ZNUMERO, 1 ) + ".TXT" )

// cARQUIVO:="C:\TEMP\G"+cANO+cMES+STRZERO(ZNUMERO,1)+".TXT"+SPACE(20)
// @ 06, 20 get cARQUIVO
// IF ! READCUR()
// RETU .F.
// ENDIF

IF !useMULT( { { "APUCFOUF", 1, 99 }, { "APUCFO", 1, 99 }, { "APUCFOZF", 1, 99 } } )
dbCloseArea()
ENDIF
QT10 := QT20 := QT30 := QT31 := 0
dbSelectAr( "APUCFO" )
QT10 := LastRec()

SET CENTURY ON
cARQUIVO := StrTran( cARQUIVO, " ", "" )
USO      := FCreate( cARQUIVO )
IF FError() # 0
ALERTX( "Erro na Criacao do Arquivo" )
RETU
ENDIF
// Mestre
FWrite( USO, "01" )
FWrite( USO, "01" )
FWrite( USO, DToS( ZDATA ) )
FWrite( USO, Left( TIRAOUT( Time() ), 6 ) )
FWrite( USO, "0000" )
FWrite( USO, cLAYOUT )   // 203 ate versao 7.3 //204 versao 7.4 //205 versao 7.5
FWrite( USO, "0001" )  // So Uma Empresa //Somente um 05
FWrite( USO, hb_osNewLine() )
// Empresa
QT10 := 0
dbSelectAr( "APUCFO" )
dbGoTop()
WHILE !Eof()
qt10++
dbSkip()
ENDDO

FWrite( USO, "05" )
FWrite( USO, ACEPAD( TIRAOUT( cIE ), 12 ) )
FWrite( USO, ACEPAD( TIRAOUT( cCGC ), 14 ) )
FWrite( USO, StrZero( Val( cCNAE ), 7 ) )
FWrite( USO, "01" )  // Regime Periodico de Apuracao(RPA)
FWrite( USO, cANO )
FWrite( USO, cMES )
FWrite( USO, "000000" )  // RPA 01 zeros
FWrite( USO, "01" )  // Gia Normal
FWrite( USO, "1" )   // Houve Movimento no Mes
FWrite( USO, "0" )   // Ainda nao foi transmitida
FWrite( USO, GRVVAL( 0, 15, 2 ) )  // Credor Anterior
FWrite( USO, GRVVAL( 0, 15, 2 ) )  // Credor Anterior SubsTrit
FWrite( USO, ACEPAD( TIRAOUT( cCGC ), 14 ) )
FWrite( USO, "0" )   // 0 Gerado pelo Sistema
FWrite( USO, GRVVAL( 0, 15, 2 ) )  // Pre fixado 0 para RPA 01
FWrite( USO, REPL( "0", 32 ) )  // Chave Interna
FWrite( USO, StrZero( QT10, 4 ) )
FWrite( USO, StrZero( QT20, 4 ) )
FWrite( USO, StrZero( QT30, 4 ) )
FWrite( USO, StrZero( QT31, 4 ) )
FWrite( USO, hb_osNewLine() )

dbSelectAr( "APUCFOUF" )
dbSetOrder( 3 )   // Novo CFO Codigo UFGIA

dbSelectAr( "APUCFO" )
dbSetOrder( 2 )   // Novo CFO
dbGoTop()
WHILE !Eof()
QT14    := 0
cCFONEW := AllTrim( CFONEW )
IF Left( cCFONEW, 1 ) = "2" .OR. Left( cCFONEW, 1 ) = "6"  // Somente Interestduais
dbSelectAr( "APUCFOUF" )
dbGoTop()
dbSeek( cCFONEW )
WHILE cCFONEW = AllTrim( CFONEW ) .AND. !Eof()
IF UF <> "ZZ"
QT14++
ENDIF
dbSkip()
ENDDO
ENDIF
dbSelectAr( "APUCFO" )
// Registro CFO
FWrite( USO, "10" )
FWrite( USO, cCFONEW + "00" )
FWrite( USO, GRVVAL( CONTABIL, 15, 2 ) )
FWrite( USO, GRVVAL( BASE, 15, 2 ) )
FWrite( USO, GRVVAL( VALOR, 15, 2 ) )
FWrite( USO, GRVVAL( ISENTA, 15, 2 ) )
FWrite( USO, GRVVAL( outra, 15, 2 ) )
FWrite( USO, GRVVAL( 0, 15, 2 ) )   // Imposto Retido ST
FWrite( USO, GRVVAL( 0, 15, 2 ) )   // Imposto Ret Subistutivo SP
FWrite( USO, GRVVAL( 0, 15, 2 ) )   // Imposto Substituido
FWrite( USO, GRVVAL( 0, 15, 2 ) )   // Outros Impostos
FWrite( USO, StrZero( QT14, 4 ) )
FWrite( USO, hb_osNewLine() )
IF Left( cCFONEW, 1 ) = "2" .OR. Left( cCFONEW, 1 ) = "6"  // Somente Interestduais
dbSelectAr( "APUCFOUF" )
dbSeek( cCFONEW )
WHILE cCFONEW = AllTrim( CFONEW ) .AND. !Eof()
nZONA := 0
IF UF <> "ZZ"
// Registro ESTADO
FWrite( USO, "14" )
FWrite( USO, UFGIA )
FWrite( USO, GRVVAL( CONTABIL, 15, 2 ) )
FWrite( USO, GRVVAL( BASE, 15, 2 ) )
FWrite( USO, GRVVAL( 0, 15, 2 ) )  // Valor Contabil Nao contribuitem
FWrite( USO, GRVVAL( 0, 15, 2 ) )  // Base Contabil nao contribuitem
FWrite( USO, GRVVAL( VALOR, 15, 2 ) )
FWrite( USO, GRVVAL( OUTRA, 15, 2 ) )
FWrite( USO, GRVVAL( 0, 15, 2 ) )  // Imposto Cobrado ST
FWrite( USO, GRVVAL( 0, 15, 2 ) )  // Petroleo Energia
FWrite( USO, GRVVAL( 0, 15, 2 ) )  // Outros Produtos
IF cCFONEW = "6109"
dbSelectAr( "APUCFOZF" )
nZONA := LastRec()
ENDIF
IF nZONA > 0
FWrite( USO, "1" )  // Sem Zona Franca/alc
FWrite( USO, StrZero( nZONA, 4 ) )   // qt18 reg18zona franca
ELSE
FWrite( USO, "0" )  // Sem Zona Franca/alc
FWrite( USO, StrZero( 0, 4 ) )   // qt18 reg18zona franca
ENDIF
FWrite( USO, hb_osNewLine() )
ENDIF
IF nZONA > 0
dbSelectAr( "APUCFOZF" )
dbGoTop()
WHILE !Eof()
FWrite( USO, "18" )
FWrite( USO, StrZero( NF, 6 ) )
FWrite( USO, DToS( DATA ) )
FWrite( USO, GRVVAL( VALOR, 15, 2 ) )
FWrite( USO, TIRAOUT( CNPJ ) )
FWrite( USO, CODMUN )
FWrite( USO, hb_osNewLine() )
dbSkip()
ENDDO
ENDIF
dbSelectAr( "APUCFOUF" )
dbSkip()
ENDDO
ENDIF
dbSelectAr( "APUCFO" )
dbSkip()
ENDDO
FClose( USO )
dbCloseAll()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GIAZF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC GIAZF()

   aRETU   := PERFEC( { "MM01" }, { "M1" }, { "MM91" } )
   cARQSAI := aRETU[ 5, 1 ]
   IF !useMULT( { { "APUCFOZF", 0, 99 }, { cARQSAI, 1, 99 }, { "MA01", 1, 99 } } )
      dbCloseArea()
   ENDIF
   dbSelectAr( "APUCFOZF" )
   ZAP
   dbSelectAr( cARQSAI )
   dbGoTop()
   WHILE !Eof()
      IF CFONEW = "6109"
         mNF     := NUMERO
         mFOR    := FORNECEDO
         mVALOR  := TOTNF
         mDATA   := DATA
         mCNPJ   := ""
         mCODMUN := "00000"
         dbSelectAr( "MA01" )
         dbGoTop()
         IF dbSeek( mFOR )
            mCNPJ := CGC
            DO CASE
            CASE CIDADE = "GUARAJA MIRIM"
               mCODMUN := "00001"
            CASE CIDADE = "BRASILEIA"
               mCODMUN := "00105"
            CASE CIDADE = "CRUZEIRO DO SUL"
               mCODMUN := "00107"
            CASE CIDADE = "MANAUS"
               mCODMUN := "00255"
            CASE CIDADE = "BONFIM"
               mCODMUN := "00307"
            CASE CIDADE = "MACAPA"
               mCODMUN := "00605"
            CASE CIDADE = "PRESIDENTE FIGUEIREDO"
               mCODMUN := "09841"
            CASE CIDADE = "RIO PRETO DA EVA"
               mCODMUN := "09843"
            CASE CIDADE = "TABATINGA"
               mCODMUN := "09847"
            CASE CIDADE = "EPITACIOLANDIA"
               mCODMUN := "99998"
            CASE CIDADE = "PACARAIMA"
               mCODMUN := "99999"
            ENDCASE
         ENDIF
         dbSelectAr( "APUCFOZF" )
         netrecapp()
         FIELD->NF     := mNF
         FIELD->DATA   := mDATA
         FIELD->VALOR  := mVALOR
         FIELD->CNPJ   := mCNPJ
         FIELD->CODMUN := mCODMUN
      ENDIF
      dbSelectAr( cARQSAI )
      dbSkip()
   ENDDO
   dbCloseAll()

// + EOF: geragia.prg
// +
