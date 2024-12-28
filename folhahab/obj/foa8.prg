// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foa8.prg
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

// :*****************************************************************************
// :
// :       FOA8.PRG: Transferir fixos di rios para mensal
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 21/12/98     11:30
// :
// :*****************************************************************************

CABEX( 'Transferir fixos di rios para mensal' )
IF !MDG( 'Deseja continuar)' )
RETU .F.
ENDIF
IF !MDG( "Este procedimento apaga folha Mensal Continuar" )
RETU .F.
ENDIF
lAVUL := MDG( "Importar Folha Avulsa" )

netzap( "VTFOLHA" )

IF !NETUSE( PES )
RETU
ENDIF

IF !NETUSE( "VTFIXO" )
dbCloseAll()
RETU
ENDIF
IF !NETUSE( "VTFOLHA" )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( "VTCONTA" )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( "VTCOMP" )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( "VTAVUL" )
dbCloseAll()
RETU
ENDIF

// IF ! AREDEM({{"VTFOLHA","VTFOLHA",0},{"VTFIXO","VTFIXO",1},{"VTCONTA","VTCONTA",1},{"VTCOMP","VTCOMP",1},{PES,PES,1},{"VTAVUL","VTAVUL",1}})
// RETU .F.
// ENDIF


IF lAVUL
dbSelectAr( "VTAVUL" )
INITVARS()
CLRVARS()
dbGoTop()
WHILE !Eof()
EQUVARS()
dbSelectAr( "VTFOLHA" )
netrecapp()
REPLVARS()
dbUnlock()
dbSelectAr( "VTAVUL" )
dbSkip()
ENDDO
ENDIF

dbSelectAr( PES )
SET FILTER TO Empty( DEMITIDO )

dbSelectAr( "VTFIXO" )
dbGoTop()
WHILE !Eof()
mNUMERO := NUMERO
PASS    := 0
dbSelectAr( PES )
dbGoTop()
IF dbSeek( mNUMERO )
PASS := VTDIAS
ENDIF
dbSelectAr( "VTFIXO" )
IF PASS > 0
mCONTA  := CONTA
mCTACOM := CTACOM
mQTDE   := HORAS
aCONTAS := {}
aLANCAR := {}
IF !Empty( mCONTA )
AAdd( aCONTAS, { mCONTA, mQTDE * PASS } )
ENDIF
IF !Empty( mCTACOM )
dbSelectAr( "VTCOMP" )
dbGoTop()
IF dbSeek( mCTACOM )
FOR X := 1 TO 10
cCONTA := "COD" + StrZero( X, 2 )
cQTDE  := "QTD" + StrZero( X, 2 )
IF !Empty( &cCONTA )
AAdd( aCONTAS, { &cCONTA, &cQTDE * mQTDE * PASS } )
ENDIF
NEXT X
ENDIF
ENDIF
FOR X := 1 TO Len( aCONTAS )
mCONTA := aCONTAS[ X, 1 ]
dbSelectAr( "VTCONTA" )
dbGoTop()
IF dbSeek( mCONTA )
AAdd( aLANCAR, { aCONTAS[ X,  1 ], aCONTAS[ X,  2 ], VALOR } )
ENDIF
NEXT X
FOR X := 1 TO Len( aLANCAR )
dbSelectAr( "VTFOLHA" )
dbGoTop()
IF !dbSeek( mNUMERO * 10000 + aLANCAR[ X,  1 ] )
netrecapp()
FIELD->NUMERO   := mNUMERO
FIELD->CONTA    := aLANCAR[ X, 1 ]
FIELD->CONTROLE := mNUMERO * 10000 + aLANCAR[ X, 1 ]
ELSE
netreclock()
ENDIF
FIELD->HORAS := HORAS + aLANCAR[ X, 2 ]   // sOMA pois pode haver composicao
FIELD->VALOR := HORAS * aLANCAR[ X, 3 ]   // de tipos iguais de vt
dbUnlock()
NEXT X
ENDIF
dbSelectAr( "VTFIXO" )
dbSkip()
ENDDO
dbSelectAr( "VTFOLHA" )
FODZER()
dbCloseAll()
RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOA8A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOA8A

   CABEX( 'Programar Dias' )
   PASS := 0
   MDS( 'Quantos dias de passagens' )
   @ 24, 35 GET PASS PICT '####'
   IF !READCUR()
      RETU .F.
   ENDIF
   IF Empty( PASS )
      ALERTX( "Especifique os dias de passagem" )
      RETU .F.
   ENDIF
   IF !netuse( pes )   // AREDE(PES,PES,1)
      RETU
   ENDIF
   SET FILTER TO Empty( DEMITIDO )
   dbGoTop()
   WHILE !Eof()
      netreclock()
      FIELD->VTDIAS := PASS
      dbUnlock()
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOA8B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOA8B

   CABEX( 'Ajustar Dias' )
   PADRAO( PES, PES, "' '+STR(mNUMERO,8)+' '+mNOME+' '+STR(mVTDIAS,3)", "mNUMERO", "Checagem VT", "Codigo Nome" + spac( 37 ) + "Dias", ;
      {|| ALLTRUE() }, {|| ALLTRUE() }, {|| gFOA8B() }, {|| FO_FOR( "GRUPO='VT'" ) } )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOA8B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOA8B

   MDS( "Quantos Dias" )
   @ 24, 40 GET mVTDIAS
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOA8C()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOA8C( cARQ, cIND )

   CABEX( 'Folha Mensal VT' )
   mNUMERO := 0
   mCONTA  := 0
   WHILE .T.
      @ 23, 00 SAY "ESC - Funcionario ou Conta em Branco Encerra"
      MDS( "Funcionario/Conta" )
      @ 24, 30 GET mNUMERO PICT "9999999"
      @ 24, 40 GET mCONTA  PICT "999"
      IF !READCUR()
         EXIT
      ENDIF
      IF Empty( mNUMERO ) .OR. Empty( mCONTA )
         EXIT
      ENDIF
      mVALOR := OBTER( "VTCONTA",, mCONTA, "VALOR" )
      mHORAS := OBTER( cARQ,, mNUMERO * 10000 + mCONTA, "HORAS" )
      @ 24, 50 GET mHORAS PICT "999"
      READCUR()
      WHILE !netuse( carq )
      ENDDO
      dbGoTop()
      IF !dbSeek( mNUMERO * 10000 + mCONTA )
         netrecapp()
         FIELD->NUMERO   := mNUMERO
         FIELD->CONTA    := mCONTA
         FIELD->CONTROLE := mNUMERO * 10000 + mCONTA
      ELSE
         netreclock()
      ENDIF
      FIELD->HORAS := mHORAS
      FIELD->VALOR := HORAS * mVALOR
      dbUnlock()
      dbCloseAll()
   ENDDO
   IF !netuse( carq )  // AREDE(cARQ,cIND,0)
      dbCloseAll()
      RETU
   ENDIF
   FODZER()
   dbCloseArea()
   RETU .T.

// : FIM: FOA8.PRG

// + EOF: foa8.prg
// +
