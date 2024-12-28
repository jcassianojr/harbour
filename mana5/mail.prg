// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mail.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function mail()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION mail

   PARA cARQ
   LOCAL cRETU

   IF ValType( cARQ ) # "C"
      cARQ := "MAIL"
   ENDIF
   cRETU := .F.
   MDS( "Checando Correspondencias" )
   WHILE !USEREDE( cARQ, 1, 0 )
   ENDDO
   dbGoTop()
   WHILE !Eof()
      IF Empty( NUMERO )
         netreclock()
         FIELD->NUMERO := RecNo()
         dbUnlock()
      ENDIF
      IF AllTrim( DESTINO ) = AllTrim( ZUSER )
         cRETU := .T.
         EXIT
      ENDIF
      @ 24, 50 SAY RecNo()
      dbSkip()
   ENDDO
   INITVARS()
   CLRVARS()
   dbCloseArea()
   IF !cRETU
      MDT( "Sem Novas Correspondencias" )
      RETU .F.
   ENDIF
   WHILE .T.
      mNUMERO := ESCOLHEXI( cARQ, "", "DTOC(DATA)+' '+ASSUNTO", "RECNO()", "DESTINO=ZUSER", 0 )
      IF ValType( mNUMERO ) = "N"
         cLIDO := "N"
         IF USEREDE( cARQ, 1, 0 )
            // SET FILTER TO NUMERO=mNUMERO
            // DBGOTOP()
            dbGoto( mNUMERO )
            EQUVARS()
            dbCloseArea()
            IF AllTrim( zUSER ) = AllTrim( mDESTINO )
               TELASAY( "MAIL01" )
               nLINHAS := MLCount( mTEXTO )
               FOR X := 1 TO nLINHAS
                  @  6 + X, 2 SAY MemoLine( mTEXTO,, X )
               NEXT X
               EDITSAY( "MAIL01" )
               IF cLIDO = "S" .AND. cARQ == "MAIL"
                  IF USEREDE( "MAILPG", 1, 0 )
                     NetRecApp()
                     REPLVARS( .F. )
                     FIELD->NUMERO := RecNo()
                     FIELD->DATAOK := Date()
                     FIELD->HORAOK := Time()
                     dbCloseArea()
                  ENDIF
                  IF USEREDE( "MAIL", 1, 0 )
                     // SET FILTER TO NUMERO=mNUMERO
                     // DBGOTOP()
                     dbGoto( mNUMERO )
                     netRecdel()
                     dbCloseArea()
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      IF MDG( "Encerrar Consulta" )
         EXIT
      ENDIF
   ENDDO
   dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAILDELUSR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MAILDELUSR

   cUSER := Space( 15 )
   MDS( "Digite o Nome do Usuario" )
   @ 24, 40 GET cUSER
   IF !READCUR()
      RETU .F.
   ENDIF
   cUSER := AllTrim( cUSER )
   MAILDELETE( "cUSER=ALLTRIM(DESTINO)" )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAILDELCOD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MAILDELCOD

   cUSER := Space( 8 )
   MDS( "Digite o Codigo" )
   @ 24, 40 GET cUSER
   IF !READCUR()
      RETU .F.
   ENDIF
   cUSER := AllTrim( cUSER )
   MAILDELETE( "cUSER=ERRO" )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAILDELDATA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MAILDELDATA

   dDATA := ZDATA
   MDS( "Digite o Data Final" )
   @ 24, 40 GET dDATA
   IF !READCUR()
      RETU .F.
   ENDIF
   MAILDELETE( "DATA<=dDATA", dDATA )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAILDELETE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MAILDELETE( cCOND, dDATA )

   MDS( "" )
   IF ValType( dDATA ) # "D"
      dDATA := Date()
   ENDIF
   IF !USEMULT( { { "MAIL", 1, 0 }, { "MAILPG", 1, 0 } } )
      RETU .F.
   ENDIF
   INITVARS()
   dbSelectAr( "MAIL" )
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY RecNo()
      IF &cCOND.
         EQUVARS()
         dbSelectAr( "MAILPG" )
         netrecapp()
         REPLVARS( .F. )
         FIELD->NUMERO := RecNo()
         FIELD->DATAOK := dDATA
         FIELD->HORAOK := Time()
         dbSelectAr( "MAIL" )
         netrecdel()
      ENDIF
      dbSelectAr( "MAIL" )
      dbSkip()
   ENDDO
   dbCloseAll()
   MAILFIX()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAILFIX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MAILFIX()  // ''efetua limpeza da pack e recria para reduzir os memos ->memopack

   IF !USEREDE( "MAIL", 0, 0,,, 300 )   //
      ALERTX( "Arquivo MAIL em uso" )
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "DATA", Date() ) }, {|| Empty( DATA ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netrecdel() }, {|| Empty( DESTINO ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netrecdel() }, {|| Empty( DE ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
   PACK
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "NUMERO", RecNo() ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   dbCloseAll()
   ALERTX( MEMOPACK( ZDIRP + "MAIL\MAIL", .T., .T., "DBFCDX" ) )


   IF !USEREDE( "MAILPG", 0, 0 )   //
      ALERTX( "Arquivo MAILPG em uso" )
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "DATAOK", Date() ) }, {|| Empty( DATAOK ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netrecdel() }, {|| Empty( DESTINO ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netrecdel() }, {|| Empty( DE ) }, {|| zei_fort( nLASTREC,,, 1 ) } )
   PACK
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "NUMERO", RecNo() ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   dbCloseAll()
   ALERTX( MEMOPACK( ZDIRP + "MAIL\MAILPG", .T., .T., "DBFCDX" ) )


// + EOF: mail.prg
// +
