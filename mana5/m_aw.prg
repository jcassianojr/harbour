// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aw.prg
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
#include "INKEY.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_aw()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_aw

   PARA nTIPO

   IF ValType( nTIPO ) # "N"
      nTIPO := 1
   ENDIF
   cMW01 := "MW01"
   cMW02 := "MW02"
   cMW03 := "MW03"

   IF nTIPO = 2
      cMW01 := "MW01BX"
      cMW02 := "MW02BX"
      cMW03 := "MW03BX"
      cMY04 := "MY04"
   ENDIF
   IF nTIPO = 3
      cVAR  := MESANO()
      cMW01 := "W1" + cVAR
      cMW02 := "W2" + cVAR
      cMW03 := "W3" + cVAR
      cMY04 := "Y4" + cVAR
   ENDIF

   IF nTIPO = 2 .OR. nTIPO = 3
      IF MDG( "Checar Baixas Requisi‡oes " )
         MAW8( { cMW01, cMW02, cMY04 } )
      ENDIF
   ENDIF


   PRIV xCOMPED, xRECEBER

   PADRAX( 0,, 0, { cMW01, cMW02, cMW03, "MW04" }, "Numero   Fornecedor" + spac( 12 ) + "Telefone" + spac( 7 ) + "Contato" + spac( 6 ) + "Fax", ;
      "' '+STR(mCOMPED,8)+' '+STR(mCOMFOR,8)+' '+mCOMCOG+' '+mCOMDDD+' '+mCOMTEL+' '+mCOMCON+' '+mCOMDDDFAX+' '+mCOMTELFAX", "MAW001", "MAW001", ;
      , {|| MAWDEL() }, {|| MAW01() }, {|| MAW03() }, "MAW", {|| MAWPOSIG() } )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAWDEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAWDEL

// PADDEL(cMW02,STR(xCHAVE,8),"COMPED","xCHAVE")
// PADDEL(cMW03,STR(xCHAVE,8),"COMPED","xCHAVE")
   ALERTX( "Somente Baixa" )
   RETU .F.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAWPOSIG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAWPOSIG

   xRECEBER := mRECEBER
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW01

   xCOMPED := mCOMPED
   xCOMFOR := mCOMFOR
   xCOMCOG := mCOMCOG
   M_AW2()
   IF mRECEBER = "S" .AND. xRECEBER <> "S"
      // PADDEL("MW08",xCOMPED,"xCOMPED","COMPED",4) Apagava todos Reajustes
      IF USEMULT( { { "MW02", 1, 2 }, { "MW08", 1, 99 } } )
         dbSelectAr( "MW02" )
         dbGoTop()
         dbSeek( xCOMPED )
         WHILE xCOMPED = COMPED .AND. !Eof()
            EQUVARS()
            MW08CHK01( .F. )
            dbSelectAr( "MW02" )
            dbSkip()
         ENDDO
         dbSelectAr( "MW02" )
         dbCloseArea()
         dbSelectAr( "MW08" )
         dbCloseArea()
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW02

   IF Empty( mCOMCOG )
      PEGACAMPO( "MB01", "mCOMFOR", { "COGNOME", "CONTATO", "DDD", "TELEFONE", "DDDFAX", "TELEFAX", "CONDPAG" }, { "mCOMCOG", "mCOMCON", "mCOMDDD", "mCOMTEL", "mCOMDDDFAX", "mCOMTELFAX", "mCOMCPAG" } )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW02B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW02B

   IF Empty( mCOMFOR )
      PEGACAMPO( "MB01", "mCOMCOG", { "NUMERO", "CONTATO", "DDD", "TELEFONE", "DDDFAX", "TELEFAX", "CONDPAG" }, { "mCOMFOR", "mCOMCON", "mCOMDDD", "mCOMTEL", "mCOMDDDFAX", "mCOMTELFAX", "mCOMCPAG" }, 2 )
   ENDIF
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAW03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAW03

   mCOMPED := OBTER( "MANEMP", ZNUMERO, "PEDCOM" )
   mCOMPED++
   GRAVAMVAR( "MANEMP", ZNUMERO, "PEDCOM", "mCOMPED" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MW08DEL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MW08DEL( nTIPO )

   nNUMERO := 0
   cCODIGO := Space( 24 )
   cTEXTO  := "Digite "
   cTIPO   := "O"
   DO CASE
   CASE nTIPO = 1
      cTEXTO += "Fornecedor"
   CASE nTIPO = 2
      cTEXTO += "Pedido"
   CASE nTIPO = 3 .OR. nTIPO = 4
      cTEXTO += "Tipo Codigo"
   ENDCASE
   MDS( cTEXTO )
   IF nTIPO = 1 .OR. nTIPO = 2
      @ 24, 20 GET nNUMERO
   ELSE
      @ 24, 20 GET cTIPO   VALID CHECKTAB( "MW0503", "cTIPO", "MW0503",, "LEFT(CODIGO1,1)" )
      @ 24, 23 GET cCODIGO
   ENDIF
   IF !READCUR()
      RETU .F.
   ENDIF
   DO CASE
   CASE nTIPO = 1
      PADDEL( "MW08", nNUMERO, "COMFOR", "nNUMERO", 3 )
   CASE nTIPO = 2
      PADDEL( "MW08", nNUMERO, "COMPED", "nNUMERO", 4 )
   CASE nTIPO = 3
      PADDEL( "MW08", cTIPO + cCODIGO, "ITECOD", "cCODIGO", 1 )
   CASE nTIPO = 4
      GRAVAMVAR( ESTQARQ( cTIPO, 1 ), cCODIGO, { "ULTPRC", "ULTUND", "ULTDATA" }, { "0", "SPACE(2)", "CTOD(SPACE(8))" } )
   ENDCASE
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MW08CAD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MW08CAD

   IF !USEREDE( "MW08", 1, 99 )
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY ITECOD
      lTEM    := VERSEHA( ESTQARQ( ITETIP, 1 ), ITECOD )
      cITETIP := ITETIP
      cITECOD := ITECOD
      dbSelectAr( "MW08" )
      WHILE cITETIP = ITETIP .AND. cITECOD = ITECOD .AND. !Eof()
         IF !lTEM
            DELEREG()
         ENDIF
         dbSkip()
         ZEI_FORT( nLASTREC )
      ENDDO
   ENDDO
   RETU .T.

// + EOF: m_aw.prg
// +
