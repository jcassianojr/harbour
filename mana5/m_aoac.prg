// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aoac.prg
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


// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

PRIV xAC


PADRAX( 0,, 0, { "AC", "ACI" }, "No.      T Codigo     Aplica‡„o", ;
      "' '+STR(mAC,8)+' '+mTIPO+' '+mCODIGO+' '+mAPLICACAO", "MOAC01", "MOAC01", ;
      ,, {|| MAOACPOS() }, {|| mAC := ULTIMOREG( "AC", "AC", "mAC" ) } ;
      , "MOAC" )

MDS( "Aguarde Atualizando Saldos" )
IF !USEMULT( { { "AC", 1, 99 }, { "ACI", 1, 99 } } )
RETU .F.
ENDIF
dbSelectAr( "ACI" )
dbSetOrder( 2 )
dbSelectAr( "AC" )
dbGoTop()
WHILE !Eof()
mAC    := AC
mPESO  := PESO
nSALDO := 0
dbSelectAr( "ACI" )
dbGoTop()
dbSeek( Str( MAC, 8 ) )
WHILE mAC = AC .AND. !Eof()
nSALDO := nSALDO + ENTKG - SAIKG
netreclock()
FIELD->SALKG := nSALDO
FIELD->SALPC := Round( SALKG / mPESO, 0 )
dbUnlock()
dbSkip()
ENDDO
dbSelectAr( "AC" )
dbSkip()
ENDDO ()
dbCloseAll()




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAOACPOS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAOACPOS

   xAC := mAC
   PADRAO( 1, 1, 0, "ACI", "No.      Item Data    Pe‡as      Kilos      Pe‡as      Kilos", ;
      "' '+STR(mAC,8)+' '+STR(mITEM,3)+' '+DTOC(mDATA)+' '+STR(mENTPC,10)+' '+STR(mENTKG,10,4)+' '+STR(mSAIPC,10)+' '+STR(mSAIKG,10,4)", "MOAI",,, ;
      {|| MOACIINS() }, {|| PADARR( "ACI", Str( xAC, 8 ), "AC", "XAC" ) } )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MOACIINS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MOACIINS

   mAC := xAC
   ULTIMOITEM( "ACI", Str( xAC, 8 ), "AC", "XAC", "ITEM", "mITEM", .T. )
   RETU .T.

// + EOF: m_aoac.prg
// +
