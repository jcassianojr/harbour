// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo7.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// ****************************************************************************
// :
// :        FO7.PRG: Menu Principal Cadastro de Funcionarios
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em:22/06/98
// :
// :*****************************************************************************

#include "BOX.CH"

cCODEMP := OBTER( "BCOFGTS",, NREMP, "'0'+CODEMP+CODEMPDV+SEQUENCIA+SEQUENDV" )

WHILE .T.
CABEX( "Menu do Cadastro De Funcionarios" )
hb_DispBox( 3, 0, 23, 78, B_DOUBLE + " " )
@ 04, 01 PROM " 1 - Inclui/Altera               "
@ 05, 01 PROM " 2 - Exclui                      "
@ 06, 01 PROM " 3 - Lista Completo              "
@ 07, 01 PROM " 4 - Lista Simples               "
@ 08, 01 PROM " 5 - Lista por Depto             "
@ 09, 01 PROM " 6 - Lista por Setor             "
@ 10, 01 PROM " 7 - Lista por Secao             "
@ 11, 01 PROM " 8 - Exibe                       "
@ 12, 01 PROM " 9 - Historico/Arquivo           "
@ 13, 01 PROM " A - Relacao Dependentes          "  // 10 FO711()
@ 14, 01 PROM " B - Ficha Salario Familia        "  // 11 FO7G
@ 15, 01 PROM " C - Cadastro Dependentes         "  // 12
@ 16, 01 PROM " D - Checagem Inicial Dependentes "  // 13  FO713() depend-fo_pes-->fosfam
@ 17, 01 PROM " E - Checar Cadastro              "  // 14
MENU TO ARQ
TELA := SaveScreen( 07, 00, 17, 21 )
DO CASE
CASE ARQ = 1
FO7A()
CASE ARQ = 2
FO7B()
CASE ARQ = 9
cARQHIS := PEGCAMINI( "FO_CHIS" ) + "FO_CHIS"
PADRAO( cARQHIS, cARQHIS, "' '+STR(mNUMERO,  8)+' '+mNOME+' '+DTOC(mADMISSAO)+' '+DTOC(mDEMISSAO)", "mNUMERO", "Historico Funcionarios", "N£mero   Nome" + spac( 37 ) + "Admiss„o Demiss„o", ;
            {|| PEGCHAVE( "mNUMERO", ULTIMOREG( cARQHIS, "NUMERO", .T. ), "Numero:" ) }, "FOCHIS", "FOCHIS", {|| FO_FOR( "GRUPO='FOCHIS'" ) } )
CASE ARQ = 12
PADRAO( "FOSFAM", "FOSFAM", "' '+STR(mNUMERO,8)+' '+STR(mREQUISI,8)+' '+mNOME+' '+DTOC(mNASCTO)", "STR(mNUMERO,8)+STR(mREQUISI,8)", "Salario Familia", "Funcionario SEQ.  Dependente" + spac( 31 ) + "Nascto", ;
            {|| FOSFAMCHV( 0 ) }, "FOSFAM", "FOSFAM", {|| FO_FOR( "GRUPO='FOSFAM'" ) } )
CASE ARQ = 13
FO713()
CASE ARQ = 14
IF mdg( "Checar Cadastro" )
FO7W()
ENDIF
IF mdg( "Checar codigos" )
FOLIS_D9()
ENDIF
CASE ARQ > 2 .AND. ARQ < 12
FO77()
OTHERWISE
SET COLOR TO
RETU
ENDCASE
ENDDO

// !*****************************************************************************
// !
// !       FO77
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO77()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FO77

   IMPHP()
   FILTRO := gFUNC( "" )
   DO CASE
   CASE ARQ = 3
      FO7C()
   CASE ARQ = 4
      FO7D()
   CASE ARQ = 5
      FO7E( 1 )
   CASE ARQ = 6
      FO7E( 2 )
   CASE ARQ = 7
      FO7E( 3 )
   CASE ARQ = 8
      FO7F( 4 )
   CASE ARQ = 10   // Relacao Dependentes
      FO711()
   CASE ARQ = 11   //
      FO7G()
   ENDCASE
   RETU

// !*****************************************************************************
// !
// !       FO713
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO713()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FO713( nNUMERO )

   IF !MDG( "Deseja Realmente Importar" )
      RETU .F.
   ENDIF
   IF !NETUSE( "FOSFAM" )
      RETURN .F.
   ENDIF
   IF File( ZDIRE + "FOOPES.DBF" )
      IF !NETUSE( FOOPES )
         dbCloseAll()
         RETU
      ENDIF
   ELSE
      IF !NETUSE( PES )
         dbCloseAll()
         RETU
      ENDIF
   ENDIF
// SET FILTER TO EMPTY(DEMITIDO)
   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      IF DEPENDE <> -1  // Evita importar novamente
         FO713A( DEPEND1, DEPDAT1, 1 )
         FO713A( DEPEND2, DEPDAT2, 2 )
         FO713A( DEPEND3, DEPDAT3, 3 )
         FO713A( DEPEND4, DEPDAT4, 4 )
         FO713A( DEPEND5, DEPDAT5, 5 )
         FO713A( DEPEND6, DEPDAT6, 6 )
         FO713A( DEPEND7, DEPDAT7, 7 )
         FO713A( DEPEND8, DEPDAT8, 8 )
         FO713A( DEPEND9, DEPDAT9, 9 )
         FO713A( DEPEND10, DEPDAT10, 10 )
         dbSelectAr( PES )
         NETRECLOCK()
         FIELD->DEPENDE := -1
         dbUnlock()
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU .T.

// !*****************************************************************************
// !
// !       FO713A
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO713A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FO713A( cVAR, cDAT, nSEQ )

   IF !Empty( cVAR )
      dbSelectAr( "FOSFAM" )
      dbGoTop()
      IF !dbSeek( Str( mNUMERO, 8 ) + Str( nSEQ, 8 ) )
         NETRECAPP()
         FIELD->NUMERO  := mNUMERO
         FIELD->REQUISI := nSEQ
         FIELD->NOME    := cVAR
         FIELD->NASCTO  := cDAT
      ELSE
         NETRECLOCK()
      ENDIF
      IF Empty( BAIXA ) .AND. ZDATA - FOSFAM->NASCTO > 5114
         FOSFAM->BAIXA  := NASCTO + 5114   // "S" //14anos*365 +4 dias anos Bissestos
         FOSFAM->SALFAM := "N"
      ENDIF
      dbUnlock()
      dbSelectAr( PES )
   ENDIF



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOSFAMCHV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOSFAMCHV( mNUMERO )

   mREQUISI := 0
   MDS( "Digite Numero e Sequencia" )
   @ 24, 20 GET mNUMERO  PICT '9999999' WHEN mNUMERO = 0
   @ 24, 30 GET mREQUISI PICT '9999999'
   READCUR()
   mCHAVE := Str( mNUMERO, 8 ) + Str( mREQUISI, 8 )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOSFAMREG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOSFAMREG( lMES )

   IF Len( AllTrim( mNREGIS ) ) = 32
      IF CHECKRICI( mNREGIS, lMES )
         mNCARTORIO := SubStr( mNREGIS, 1, 6 )
         mLIVRO     := SubStr( mNREGIS, 16, 5 )
         mFOLHA     := SubStr( mNREGIS, 21, 3 )
         mTERMO     := SubStr( mNREGIS, 24, 7 )
         IF Empty( mCARTORIO )
            mCARTORIO := SubStr( mNREGIS, 1, 6 )
         ENDIF
      ELSE
         RETURN .F.
      ENDIF
   ENDIF

   RETURN .T.


// + EOF: fo7.prg
// +
