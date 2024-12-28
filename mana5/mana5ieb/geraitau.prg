// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : geraitau.prg
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

MDI( "Gerar Remessa Combran‡a" )
cContrato  := Space( 12 )
cEMP       := PadR( "ITAESBRA", 30 )
cSUB       := "I"
cIN1       := "10"
cIN2       := "38"
cESP       := "01"
cOCO       := "01"
nSEQ       := 1
cBANCO     := '341'   // Itau
cBANCONOME := Space( 15 )
cARQUIVO   := "C:\BANCOS\       .TXT" + Space( 40 )
@ 08, 09 SAY "Codigo Banco"
@ 08, 30 GET cBANCO         PICT '999' VALID CHECKEXI( "MF01", "cBANCO", "STRVAL(NUMERO)+' '+NOME", "NUMERO", "BANCO", .T. )
READCUR()

cCAR := "   "
PEGACAMPO( "MF01", "cBANCO", { "LEFT(CARTEIRA,3)" }, { "cCAR" } )
IF Empty( CARQ )
cCAR := "112"
ENDIF


DO CASE
CASE cBANCO = '341'
cBANCONOME := PadR( "BANCO ITAU SA", 15 )
cContrato  := PadR( "024900657818", 12 )
CASE cBANCO = '237'
cBANCONOME := PadR( "BRADESCO", 15 )
CASE cBANCO = '353'
cBANCONOME := PadR( "SANTANDER", 15 )
cCONTRATO  := PadR( "21944290895742908957", 20 )
cSUB       := "2"
CASE cBANCO = '479'
cBANCONOME := PadR( "BANKBOSTON", 15 )
cCONTRATO  := Space( 8 )
ENDCASE
TELASAY( "GERCOB" )
EDITSAY( "GERCOB" )

IF !MDG( "Iniciar Gera‡ao Arquivo" )
RETU .F.
ENDIF


FILTRO := RFILORD( "MN01", .F., "" )
IF !USEMULT( { { "MN01", 1, 99 }, { "MB01", 1, 1 }, { "MA01", 1, 1 } } )
RETU .F.
ENDIF


cARQUIVO := StrTran( cARQUIVO, " ", "" )

USO := FCreate( cARQUIVO )
IF FError() # 0
ALERTX( "Erro na Cria‡„o do Arquivo" )
RETU
ENDIF


SET CENTURY OFF
// Header
FWrite( USO, "0" )   // 1
FWrite( USO, "1" )   // 2
FWrite( USO, "REMESSA" )   // 3-9 Remessa
FWrite( USO, "01" )  // 10-11
FWrite( USO, PadR( "COBRANCA", 15 ) )   // 12-26
DO CASE
CASE cBANCO = '479'   // B Boston
FWrite( USO, Space( 2 ) )   // 27-28
FWrite( USO, "1" )  // 29 Producao
FWrite( USO, PadR( cCONTRATO, 8 ) )  // 30-37
FWrite( USO, Space( 9 ) )   // 38-46
CASE cBANCO = '353'   // Santander
FWrite( USO, PadR( cCONTRATO, 20 ) )   // 27-46
// FWRITE(USO,SPACE(2)) //27-28
// FWRITE(USO,"1") //29 Producao
// FWRITE(USO,SPACE(9)) //30-39
// FWRITE(USO,PADR(cCONTRATO,8))  //39-46
OTHERWISE   // Outros Itau
FWrite( USO, PadR( cContrato, 12 ) )   // 27-38
FWrite( USO, Space( 8 ) )   // 39-46
ENDCASE
FWrite( USO, PadR( cEMP, 30 ) )   // 47 Nome do cedente
// FWRITE(USO,strzero(cBANCO,3)) //77-79
FWrite( USO, cBANCO )
FWrite( USO, PadR( cBANCONOME, 15 ) )   // 80-94  Nome do Banco
FWrite( USO, StrTran( DToC( ZDATA ), "/", "" ) )   // 95-100 Data Gravacao
FWrite( USO, Space( 294 ) )  // 101-394
FWrite( USO, StrZero( nSEQ, 6 ) )   // 394-400 Sequencia
FWrite( USO, Chr( 13 ) + Chr( 10 ) )
nSEQ++


// Registros
dbSelectAr( "MN01" )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
WHILE !Eof()
IF GERACOB = "S" .AND. ( BANCO = cBANCO .OR. Empty( BANCO ) )
FWrite( USO, "1" )   // 001-001Tipo Registro
FWrite( USO, "02" )  // 003-003 Tipo Inscr 01-CPF 02-CGC
FWrite( USO, StrZero( 0, 14 ) )   // 004-0017 Inscr
IF cBANCO = '353'
FWrite( USO, PadR( cContrato, 20 ) )   // 018-037 Contrato AgDc4Conta8Conta8
ELSE
FWrite( USO, PadR( cContrato, 12 ) )   // Contrato
FWrite( USO, Space( 4 ) )   // Brancos
FWrite( USO, Space( 4 ) )   // Instru‡ao Alegacao
ENDIF
FWrite( USO, Space( 25 ) )   // 038-062 Identificaco Empresa
FWrite( USO, StrZero( 0, 8 ) )  // 063-070 Titulo Banco
IF cBANCO = '353'
FWrite( USO, "000000" )   // 071-076 Data Segundo Desconto
FWrite( USO, " " )  // 077-077 Branco
FWrite( USO, "0" )  // 078-078 Informacao de Multa
FWrite( USO, "0000" )   // 079-082 Multa por atraso
FWrite( USO, "00" )   // 083-084 Unidade de Valor Moeda corrente00
FWrite( USO, StrZero( 0, 13 ) )  // 085-097 Valor do Titulo Outra Unidade
FWrite( USO, Space( 4 ) )   // 098-101 Brancos
FWrite( USO, "000000" )   // 102-107 Data para Cobranca de Multa
ELSE
FWrite( USO, StrZero( 0, 13 ) )  // Qtde Moedas(13)
FWrite( USO, cCAR )   // Numero carteira(3)
FWrite( USO, Space( 21 ) )  // Uso Banco(21)
ENDIF
FWrite( USO, cSUB )  // 108-108 Carteira
FWrite( USO, cOCO )  // 109-110 Codigo Ocorrencia
FWrite( USO, PadR( AllTrim( Str( NUMERO, 8 ) ), 10 ) )   // 111-120 N§ Documento
FWrite( USO, StrTran( DToC( VENCIMENT ), "/", "" ) )   // 121-126 Vencimento
mVALATUAL := VALOR + JUROS - ABATER + JURVAL - VALPIS - VALFIN
FWrite( USO, GRVVAL( mVALATUAL, 13, 2 ) )  // Valor com os Abatimentos
// FWRITE(USO,strzero(cBANCO,3)) //codigo do Banco
FWrite( USO, cBANCO )  // codigo do Banco
FWrite( USO, StrZero( 0, 5 ) )  // Agencia Cobranca
FWrite( USO, cESP )  // Especia do titulo
FWrite( USO, "N" )   // Aceito s/n
FWrite( USO, StrTran( DToC( DATA ), "/", "" ) )  // Emissao Titulo
FWrite( USO, cIN1 )  // 1§ Instru‡ao
FWrite( USO, cIN2 )  // 2¦ Instru‡ao
FWrite( USO, StrZero( 0, 13 ) )   // Juros
FWrite( USO, Space( 6 ) )  // Desconto ate
FWrite( USO, StrZero( 0, 13 ) )   // Valor desconto
FWrite( USO, StrZero( 0, 13 ) )   // Iof
FWrite( USO, StrZero( 0, 13 ) )   // Abatimento
mTIPOCLI   := TIPOCLI
mFORNECEDO := FORNECEDO
mNUMERO    := NUMERO
dbSelectAr( "MA01" )
IF mTIPOCLI = "F"
dbSelectAr( "MB01" )
ENDIF
dbGoTop()
IF !dbSeek( mFORNECEDO )
ALERTX( "Cliente/Fornecedo Nao Encontrado NF" + Str( mNUMERO ) )
FClose( USO )
FErase( USO )
dbCloseAll()
RETU
ENDIF
FWrite( USO, IF( PESSOA = "J", "02", "01" ) )  // tipo
FWrite( USO, StrZero( Val( TIRAOUT( CGC ) ), 14 ) )   // CGC
FWrite( USO, PadR( TIRAOUT( NOME ), 30 ) )  // NOme
FWrite( USO, Space( 10 ) )   // Brancos
IF mTIPOCLI = "F"
FWrite( USO, PadR( TIRAOUT( ENDERECO ), 40 ) )   // Endereco
FWrite( USO, PadR( TIRAOUT( BAIRRO ), 12 ) )   // Bairro
FWrite( USO, StrZero( Val( TIRAOUT( CEP ) ), 8 ) )   // Cep
FWrite( USO, PadR( TIRAOUT( CIDADE ), 15 ) )   // Cidade
FWrite( USO, Upper( ESTADO ) )  // Estado
ELSE
FWrite( USO, PadR( TIRAOUT( ENDERECO2 ), 40 ) )  // Endereco
FWrite( USO, PadR( TIRAOUT( BAIRRO2 ), 12 ) )  // Bairro
FWrite( USO, StrZero( Val( TIRAOUT( CEP2 ) ), 8 ) )  // Cep
FWrite( USO, PadR( TIRAOUT( CIDADE2 ), 15 ) )  // Cidade
FWrite( USO, Upper( ESTADO2 ) )   // Estado
ENDIF
FWrite( USO, Space( 30 ) )   // Brancos
FWrite( USO, Space( 4 ) )  // Complemenos
FWrite( USO, Space( 6 ) )  // Data MOra
FWrite( USO, "00" )  // Qtdias
FWrite( USO, " " )   // Brancos
FWrite( USO, StrZero( nSEQ, 6 ) )   // Sequencial
FWrite( USO, Chr( 13 ) + Chr( 10 ) )
nSEQ++
dbSelectAr( "MN01" )
GRAVACAMPO( "GERACOB", "'G'" )
IF Empty( BANCO )
GRAVACAMPO( "BANCO", "cBANCO" )
ENDIF
ENDIF
dbSkip()
ENDDO
// Trailer
FWrite( USO, "9" )
FWrite( USO, Space( 393 ) )
FWrite( USO, StrZero( nSEQ, 6 ) )
FWrite( USO, Chr( 13 ) + Chr( 10 ) )
FWrite( USO, Chr( 26 ) )
FClose( USO )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MANVOLTG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MANVOLTG

   MDI( " Ý Retornar Geradas" )
   cARQ   := "MN01"
   dDATA  := ZDATA
   dDATF  := ZDATA
   cBANCO := '341'
   @ 24, 00 SAY "Digite Data Emiss„o/Banco"
   @ 24, 40 GET dDATA
   @ 24, 50 GET dDATF
   @ 24, 60 GET cBANCO                      PICT '999' VALID CHECKEXI( "MF01", "cBANCO", "STRVAL(NUMERO)+' '+NOME", "NUMERO", "BANCO", .T. )
   IF !readcur()
      RETU .F.
   ENDIF
   FILTRO := RFILORD( "MN01", .F., "" )
   IF !MDG( "Retornar Geradas" )
      RETU .F.
   ENDIF

   IF !USEREDE( cARQ, 1, 99 )
      RETU .F.
   ENDIF
   dbSelectAr( cARQ )
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY RecNo()
      IF GERACOB = "G" .AND. BANCO = cBANCO
         IF DATA >= dDATA .AND. DATA <= dDATF
            GRAVACAMPO( "GERACOB", "'S'" )
         ENDIF
      ENDIF
      dbSelectAr( cARQ )
      dbSkip()
   ENDDO
   dbCloseAll()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MANPISCON()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MANPISCON

   LOCAL nPERPIS, nPERFIN

   nPERPIS := 0.1
   nPERFIN := 0.5
   MDI( " Ý Gerar Pis-Confins" )
   @ 24, 00 SAY "Digite Pis/Confins"
   @ 24, 40 GET nPERPIS              PICT "99.99"
   @ 24, 50 GET nPERFIN              PICT "99.99"
   IF !readcur()
      RETU .F.
   ENDIF
   FILTRO := RFILORD( "MN01", .F., "" )
   IF !MDG( "Gerar Pis/Confins" )
      RETU .F.
   ENDIF
   IF !USEREDE( "MN01", 1, 99 )
      RETU .F.
   ENDIF
   dbSelectAr( "MN01" )
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY RecNo()
      nVALPIS   := Round( VALOR * nPERPIS / 100, 2 )
      nVALFIN   := Round( VALOR * nPERFIN / 100, 2 )
      nVALATUAL := VALOR + JUROS - ABATER + JURVAL - nVALPIS - nVALFIN   // Nvalpis/fin precisam ser os caluldos
      GRAVACAMPO( { "VALPIS", "VALFIN", "VALATUAL" }, { nVALPIS, nVALFIN, nVALATUAL },, .T., .F., .F. )
      dbSelectAr( "MN01" )
      dbSkip()
   ENDDO
   dbCloseAll()

// + EOF: geraitau.prg
// +
