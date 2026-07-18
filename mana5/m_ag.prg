// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ag.prg
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


// :*****************************************************************************
// :
// :   M_AG   .PRG : Cadastro de Transportadoras
// :   Linguagem   : harbour
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :  Procs & Fncts: fMAG()
// :
// :    Chamado por:
// :
// :          Chama: fMAG  (fun‡„o em M_AG.PRG )
// :
// :  Arq. Dados   : MG01       - Cadastro de Transportadoras
// :
// :  Indices      : MG01-1     - Numero de Cadastramento
// :                 NUMERO
// :
// :
// :  Documentado em: Junh 6, 1994 as 11:16:48                DISK!  vers„o 5.01
// :*****************************************************************************


// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

PRIV xNUMERO

PADRAX( 0,, 0, { "MG01", "MG02", "MG03" }, "N£mero  Nome" + spac( 38 ) + "Cognome" + spac( 6 ) + "DDD  Telefone", ;
      "' '+STRVAL(mNUMERO,8)+' '+mNOME+' '+mCOGNOME+' '+mDDD+' '+mTELEFONE", "MAG001", "MAG001", ;
      {|| MAGEN2() }, ;
      {|| PADDEL( "MG02", IF( ValType( xNUMERO ) = 'C', xNUMERO, STRVAL( xNUMERO, 8 ) ), "NUMERO", "xCHAVE" ) }, ;
      {|| MAGREP() } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAGEN2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MAGEN2

   IF !USEREDE( "MG01", 1, 1 )
      RETU .F.
   ENDIF
   dbGoTop()
   IF dbSeek( mCHAVE )
      mTRANPORT  := mCHAVE
      mNOMETRANS := NOME
      mENDETRANS := ENDERECO
      mBAIRTRANS := BAIRRO
      mCIDATRANS := CIDADE
      mESTATRANS := ESTADO
      mCEPTRANS  := CEP
      mCHAPA     := CHAPA
      mCGCTRANS  := CGC
      mIETRANS   := INSCR
   ENDIF
   dbCloseArea()
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAGREP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAGREP

   IF MDG( "Deseja Alterar Motoristas" )
      xNUMERO := mNUMERO
      PADRAO( 1, 1, 0, "MG02", "No    Chapa    Motorista", ;
         "' '+STRVAL(mNUMERO,8)+' '+STR(mCODEMP)+' '+mMOTORF", ;
         "MAG2",,, {|| mNUMERO := xCHAVE }, {|| PADARR( "MG02", IF( ValType( xNUMERO ) = 'C', xNUMERO, STRVAL( xNUMERO, 8 ) ), "NUMERO", "XNUMERO" ) } )
   ENDIF
   IF MDG( "Deseja Alterar Frotas" )
      xNUMERO := mNUMERO
      PADRAO( 1, 1, 0, "MG03", "Tranp Codigo Frota Chapa    Cod Motoris. Modelo Ve¡culo", ;
         "' '+STRVAL(mNUMERO,8)+' '+mCODFRO+' '+mCHAPAF+' '+mCODEMP+' '+mMODFRO", ;
         "MAG3",,, {|| mNUMERO := xCHAVE }, {|| PADARR( "MG03", IF( ValType( xNUMERO ) = 'C', xNUMERO, STRVAL( xNUMERO, 8 ) ), "NUMERO", "XNUMERO" ) } )
   ENDIF
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKIPVA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CHECKIPVA( cCOD )

   IF Empty( cCOD )
      RETU .T.
   ENDIF
   IF !USEREDE( "MG04", 1, 1 )
      RETU .F.
   ENDIF
   dbGoTop()
   dbSeek( cCOD )
   IF !Found()
      dbCloseArea()
      RETU .F.
   ENDIF
   mPROFRO := IF( ORIGEM = "IMP", "Importado", "Nacional" )
   mTIPO   := TIPO
   mTIPFRO := OBTER( "MD02", PadR( "TI2VEI", 12 ) + PadR( Str( TIPO, 1 ), 12 ), "LEFT(DESCRICAO,20)" )
   mMARFRO := MARCA
   mMODFRO := MODELO
   dbCloseArea()
   RETU .T.

// + EOF: m_ag.prg
// +
