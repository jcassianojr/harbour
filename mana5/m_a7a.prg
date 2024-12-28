// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a7a.prg
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


// *
// * Carta de Corre‡„o
// *
// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
MDI( " Ý Carta de Corre‡„o" )

// Pegando Cores de Trabalho
PRIV PAD001, PAD002, PAD005, PAD006, PAD007, MA7A01
CORARR( { "MAM401", "MAM402", "MAM405", "MAM406", "MAM407", "MA7A01" }, ;
      { "PAD001", "PAD002", "PAD005", "PAD006", "PAD007", "MA7A01" } )


CRIARVARS( "MM03" )
CRIARVARS( "MA01" )
cDESC1    := "nossa"
cTIPO     := "C"
cENDERECO := PadR( IMP( "ZEND" ) + " - " + IMP( "ZBAR" ) + " - CEP " + IMP( "ZCEP" ) + " - S.P.", 80 )
nNUMERO   := 0
dDATA     := ZDATA
dDATA2    := ZDATA
cNOTA     := Space( 10 )
cSERIE    := Space( 10 )
nERRO1    := nERRO2 := nERRO3 := nERRO4 := nERRO5 := 0
nERRO6    := nERRO7 := nERRO8 := nERRO9 := nERRO10 := 0
aERRO     := Array( 10, 10 )
TELASAY( "MA7A01" )
EDITSAY( "MA7A01" )



IF !IGUALVARS( ARQUSO, nNUMERO )
ALERTX( "Codigo Cliente/Fornec./Transp. n„o Cadastrado" )
RETU .F.
ENDIF


aERRO[ 1, 10 ]  := nERRO1
aERRO[ 2, 10 ]  := nERRO2
aERRO[ 3, 10 ]  := nERRO3
aERRO[ 4, 10 ]  := nERRO4
aERRO[ 5, 10 ]  := nERRO5
aERRO[ 6, 10 ]  := nERRO6
aERRO[ 7, 10 ]  := nERRO7
aERRO[ 8, 10 ]  := nERRO8
aERRO[ 9, 10 ]  := nERRO9
aERRO[ 10, 10 ] := nERRO10



FOR X := 1 TO 10
IF !Empty( aERRO[ X, 10 ] )
IGUALVARS( "MM03", aERRO[ X, 10 ] )
TELASAY( "MAM401" )
EDITSAY( "MAM401" )
aERRO[ X, 01 ] := mLIN01
aERRO[ X, 02 ] := mLIN02
aERRO[ X, 03 ] := mLIN03
aERRO[ X, 04 ] := mLIN04
aERRO[ X, 05 ] := mLIN05
aERRO[ X, 06 ] := mLIN06
aERRO[ X, 07 ] := mLIN07
aERRO[ X, 08 ] := mLIN08
aERRO[ X, 09 ] := mDESMENS
ENDIF
NEXT X

nCOPIA := 1
MDS( "Digite o Numero de Copias" )
@ 24, 40 GET nCOPIA
READCUR()

IF !CHECKIMP( 0 )
RETU .F.
ENDIF

IMPRESSORA()
FOR Z := 1 TO nCOPIA
@ PRow() + 1, 0 SAY PadR( ACENTO( "ITAESBRA  Ind£stria Mecƒnica Ltda." ), 80 )
@ PRow(), 0   SAY PadR( ACENTO( "ITAESBRA  Ind£stria Mecƒnica Ltda." ), 80 )
@ PRow() + 1, 0 SAY ACENTO( "-----------------------------------------------------------------------------" )
@ PRow() + 1, 0 SAY ACENTO( "C.G.C. 61.381.323/0001-67   Inscricao 103.689.678.113" )
@ PRow() + 1, 0 SAY ACENTO( cENDERECO )
@ PRow() + 1, 0 SAY ACENTO( "Telefone:(11)6948-8899 - Fax:(11)6948-8883" )
@ PRow() + 1, 0 SAY ACENTO( "=============================================================================" )
@ PRow() + 2, 0 SAY ACENTO( "                              S„o Paulo, " + StrZero( Day( dDATA ), 2 ) + " de " + CMES( dDATA ) + " de " + StrZero( Year( dDATA ), 4 ) )
@ PRow() + 2, 0 SAY ACENTO( mNOME )
@ PRow() + 1, 0 SAY ACENTO( mEndereco )
@ PRow() + 1, 0 SAY ACENTO( mCIDADE ) + " - " + mESTADO
@ PRow() + 1, 0 SAY ACENTO( mCEP )
@ PRow() + 2, 0 SAY ACENTO( "Prezados Senhores:-" )
@ PRow() + 2, 0 SAY ACENTO( "Comunicamos a V.Sa. que a " + cDESC1 + " Nota Fiscal de nr. " + cNOTA + IF( Empty( cSERIE ), "", " S‚rie " + cSERIE ) )
@ PRow() + 1, 0 SAY ACENTO( "Data de " + DToC( dDATA2 ) + " , a nosso entender, deixou de atender a legisla‡„o fiscal," )
@ PRow() + 1, 0 SAY ACENTO( "e para sua regulariza‡„o informamos:" )
@ PRow() + 1, 0 SAY ACENTO( "-----------------------------------------------------------------------------" )
@ PRow() + 1, 0 SAY ACENTO( "                  RETIFICA€™ES A SEREM CONSIDERADAS" )
@ PRow() + 1, 0 SAY ACENTO( "-----------------------------------------------------------------------------" )
FOR X := 1 TO 10
IF !Empty( aERRO[ X, 10 ] )
@ PRow() + 1, 0 SAY ACENTO( Str( aERRO[ X, 10 ] ) + " - " + aERRO[ X, 09 ] )
FOR Y := 1 TO 8
IF !Empty( aERRO[ X, Y ] )
@ PRow() + 1, 5 SAY ACENTO( aERRO[ X, Y ] )
ENDIF
NEXT Y
ENDIF
NEXT X
@ PRow() + 1, 0 SAY ACENTO( "-----------------------------------------------------------------------------" )
@ PRow() + 1, 0 SAY ACENTO( "Assim sendo, Solicitamos:" )
@ PRow() + 1, 0 SAY ACENTO( "1. Devolverem copia da Presente devidamente protocolada." )
@ PRow() + 1, 0 SAY ACENTO( "2. Efetuarem as corre‡”es nos itens assinalados." )
@ PRow() + 1, 0 SAY ACENTO( "3. Enviarem Nota Fiscal Complementar  (Se for o Caso)" )
@ PRow() + 1, 0 SAY ACENTO( "   Carta Emitida na forma do art.173, paragrafo 3. do decreto 87981/82 (RIPI)" )
@ PRow() + 1, 0 SAY ACENTO( "pelo n„o entendimento ao disposto no art.83, decreto 17727/81(RICM)." )
@ PRow() + 1, 0 SAY ACENTO( "=============================================================================" )
@ PRow() + 1, 0 SAY ACENTO( "                           DECLARA€ŽO" )
@ PRow() + 1, 0 SAY ACENTO( "    Declaramos, a quem possa - interessar, que os valores referentes aos" )
@ PRow() + 1, 0 SAY ACENTO( "Impostos (IPI e ICM) foram lan‡ados em nossos livros fiscais obedecendo as" )
@ PRow() + 1, 0 SAY ACENTO( "corre‡”es Mencionadas." )
@ PRow() + 2, 0 SAY ACENTO( "Atenciosamente        ITAESBRA IND—STRIA MECANICA LTDA" )
@ PRow() + 2, 0 SAY ACENTO( "                      ________________________________" )
@ PRow() + 1, 0 SAY ACENTO( "                             Depto Fiscal" )
@ PRow() + 1, 0 SAY ACENTO( "=============================================================================" )
@ PRow() + 1, 0 SAY ACENTO( "---------------------- Acusamos o Recebimento da 1a. Via --------------------" )
@ PRow() + 1, 0 SAY ACENTO( "|                                                                           |" )
@ PRow() + 1, 0 SAY ACENTO( "| _____________________, ____/____/____ ___________________________________ |" )
@ PRow() + 1, 0 SAY ACENTO( "| LOCAL                  DATA             CARIMBO E ASSINATURA              |" )
@ PRow() + 1, 0 SAY ACENTO( "-----------------------------------------------------------------------------" )
IMPFOL()
NEXT Z
VIDEO()
IMPEND()

// + EOF: m_a7a.prg
// +
