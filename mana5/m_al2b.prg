// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_al2b.prg
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


// #INCLUDE "COMANDO.CH"
dDATAINI := dDATAFIM := ZDATA
yNRNOTA  := 0
yFATURA  := 0.00
MDI( " þ ",,, "ML02" )
MDS( "Digite o Periodo de programa‡„o e Nota Inicial" )
@ 24, 40 GET dDATAINI
@ 24, 50 GET dDATAFIM
@ 24, 60 GET yNRNOTA
IF !READCUR()
RETU .F.
ENDIF
MDS( "Digite o Valor do Faturmanento" )
@ 24, 40 GET yFATURA
IF !READCUR()
RETU .F.
ENDIF

IF !USEMULT( { { "ML01", 1, 99 }, { "ML02", 1, 1 } } )
RETU .F.
ENDIF

dbSelectAr( "ML01" )
INITVARS()
CLRVARS()
dbSelectAr( "ML02" )
INITVARS()
CLRVARS()

MDS( "Aguarde Transferencia" )
dbSelectAr( "ML02" )
dbGoTop()
WHILE !Eof()
EQUVARS()
IF Empty( mNRNOTA )
mNRNOTA := yNRNOTA
yNRNOTA++
ENDIF
IF !Empty( mFATPER )
mVALOR  := Round( yFATURA * mFATPER / 100, 2 )
mTOTFAT := Round( yFATURA * mFATPER / 100, 2 )
ENDIF
dREF := dDATAINI
WHILE dREF <= dDATAFIM
// Entrega Semanal
IF VENTIP = "S"
// O dia da semana Coincide com o da Entrega
IF DoW( dREF ) = DATENT
mVENCIMENT := dREF
NOVOOPE( "ML01", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
dbSelectAr( "ML02" )
ENDIF
ENDIF
// Entrega Mensal
IF VENTIP = "M"
// O dia do mes Coincide com o da Entrega
IF Day( dREF ) = DATENT
mVENCIMENT := dREF
NOVOOPE( "ML01", DToS( mVENCIMENT ) + Str( mNRNOTA, 8 ) + mTIPFAT )
dbSelectAr( "ML02" )
ENDIF
ENDIF
dREF++
ENDDO
dbSelectAr( "ML02" )
dbSkip()
ENDDO
dbCloseAll()

RELEASE ALL LIKE M *





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AL2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_AL2

   PADRAO( 0, 1, 0, "ML02", "Fatura     Vencera  CLIENTE         Valor Receber      DDD+Telefone", "' '+STR(mNRNOTA,8)+' '+mTIPFAT+' '+STR(mDATENT)+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mVALOR,18,2)+' '+mDDD+' '+mTELEFONE", "MAL2" )
   RETU

// + EOF: m_al2b.prg
// +
