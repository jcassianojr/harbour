// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ayg.prg
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


MDI( " Ý Requisi‡”es Conforme NF" )
CRIARVARS( "MY01" )
mFORNECEDO := 0
dDATA      := Date()
MDS( "Confirme a Data" )
@ 24, 40 GET dDATA
IF !READCUR()
RETU .F.
ENDIF

aBAI := {}
aDES := {}
IF !USEREDE( "MSBAI", 1, 0 )
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
AAdd( aBAI, ORIGEM + Str( PLANTA, 8 ) )
AAdd( aDES, DESTINO )
dbSkip()
ENDDO
dbCloseArea()


aRETU  := PEGMES( { "M2", "M1" }, .T., { "MM02", "MM01" } )
cARQ   := aRETU[ 5, 1 ]
cARQNF := aRETU[ 5, 2 ]

MDS( "Aguarde Transferencia" )
IF !USEMULT( { { cARQ, 1, 0 }, { cARQNF, 1, 1 }, { "MY01", 1, 99 } } )
dbCloseAll()
RETU .F.
ENDIF
INITVARS()
CLRVARS()
dbSelectAr( cARQ )
dbGoTop()
WHILE !Eof()
IF TIPOENT = "P" .AND. DATA = dDATA .AND. !Empty( OS ) .AND. ;
            ! Empty( CODIGO ) .AND. FATBX <> "S" .AND. !IMPMY   // Aind Nao Importada
mNUMERO  := NUMERO
lCANCELA := .F.
dbSelectAr( cARQNF )
dbGoTop()
IF dbSeek( mNUMERO )
IF CANCELADA = "S"
lCANCELA := .T.
ENDIF
ENDIF
dbSelectAr( cARQ )
IF !lCANCELA
wNOTA := NUMERO
wSEQ  := SEQ
wOS   := OS
@ 24, 00 SAY NUMERO
@ 24, 10 SAY CODIGO
@ 24, 40 SAY OS
EQUVARS()
mQTDE    := CONVUN( mQTDE, mUNID )
mTIPOENT := "P"  // Produto
mTIPO1   := "S"  // Saida
mTIPO2   := "P"  // Produto
mTIPO3   := "NFS"
mCODIGO  := CODIGO
mNUMMB01 := FORNECEDO
nPOS     := AScan( aBAI, mCODIGO + Str( mFORNECEDO, 8 ) )
IF nPOS > 0
mCODIGO := aDES[ nPOS ]
ENDIF
yCODIGO   := mCODIGO
mOLDQTDDE := 0
// mNUMERO:=(mNUMERO*100)+SEQ
mOS := wNOTA + ( SEQ / 100 )
dbSelectAr( "MY01" )
dbGoBottom()
mNUMERO  := NUMERO + 1
wREQUISI := mNUMERO
NOVOOPA( "MY01" )
MAM2K05( "I", "MY01S" )
dbSelectAr( cARQ )
GRAVACAMPO( "IMPMY", ".T." )
ENDIF
ENDIF
dbSelectAr( cARQ )
dbSkip()
ENDDO
RELEASE ALL LIKE M *
dbCloseAll()



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_AYG2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_AYG2

   MDI( " Ý Requisi‡”es Conforme RIF" )
   CRIARVARS( "MY01" )
   mFORNECEDO := 0
   dDATA      := Date()
   MDS( "Confirme a Data" )
   @ 24, 40 GET dDATA
   IF !READCUR()
      RETU .F.
   ENDIF
   cARQ := "RIF"
   @ 23, 00 SAY "Esc Encerra"
   IF !USEMULT( { { cARQ, 1, 3 }, { "MY01", 1, 99 } } )
      dbCloseAll()
      RETU .F.
   ENDIF
   INITVARS()
   CLRVARS()
   dbSelectAr( cARQ )
   dbGoTop()
   dbSeek( dDATA )
   WHILE !Eof()
      @ 24, 70 SAY RecNo()
      WHILE DATA = dDATA .AND. !Eof()
         IF !IMPORTADO
            cIMP := "S"
            @ 24, 00 SAY RIF
            @ 24, 10 SAY CODIGO
            @ 24, 35 SAY OS
            @ 24, 45 SAY QTDE
            @ 24, 55 SAY "Importar "
            @ 24, 65 GET cIMP
            IF !READCUR()
               EXIT
            ENDIF
            IF cIMP = "S"
               yCODIGO   := CODIGO
               wCODIGO   := CODIGO
               wQTDE     := QTDE
               mOLDQTDDE := 0
               mNRNOTA   := RIF
               // mNUMERO:=RIF
               mQTDE    := QTDE
               mTIPOENT := "P"   // Produto
               mTIPO1   := "E"   // Entrada
               mTIPO2   := "P"   // Produto
               mTIPO3   := "RIF"
               mCODIGO  := CODIGO
               mDATA    := DATA
               mUNID    := "PC"
               // mOS:=INT(OS)
               // mITEM:=OS-INT(OS)
               mOS        := RIF
               mDISTRI    := "N"
               mRASTRO    := RASTRO
               mTECNICO   := INSNUM
               mREQINT    := RIF
               mNUMMB01   := CLIENTE
               mFORNECEDO := CLIENTE
               dbSelectAr( "MY01" )
               dbGoBottom()
               mNUMERO := NUMERO + 1
               NOVOOPA( "MY01" )
               MAK2K05( "I", "MY01E" )
               MAY05( "ESTQENT+wQTDE" )
               dbSelectAr( cARQ )
               GRAVACAMPO( "IMPORTADO", ".T." )
            ENDIF
         ENDIF
         dbSelectAr( cARQ )
         dbSkip()
      ENDDO
   ENDDO
   RELEASE ALL LIKE M *
   dbCloseAll()




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAYG01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAYG01( nQTDDE, cARQ, cTIP, dDATLIM )

   IF nQTDDE < 0.0001
      RETU .T.
   ENDIF
   IF ValType( cTIP ) # "C"
      cTIP := "S"
   ENDIF
   dbSelectAr( cARQ )
   netrecapp()
   FIELD->CODIGO  := yCODIGO
   FIELD->OS      := wOS
   FIELD->OF      := 0
   FIELD->QTDDE   := nQTDDE
   FIELD->REQUISI := wREQUISI
   FIELD->NRNOTA  := wNOTA
   FIELD->SEQ     := wSEQ
   FIELD->BAIXA   := dDATA
   FIELD->TIPO    := cTIP
   FIELD->DLIMITE := dDATLIM
   IF Type( "wDPEDI" ) = "D"
      FIELD->DPEDI := wDPEDI
   ENDIF
   IF Type( "wDLIMP" ) = "D"
      FIELD->DLIMP := wDLIMP
   ENDIF
   dbUnlock()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAYG02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAYG02( nQTDDE, cARQ, cARQ2, nOS )

   IF ValType( nOS ) = "N"
      mOS := nOS
   ENDIF
   WHILE !USEREDE( cARQ, 1, 99 )
   ENDDO
   dbSetOrder( 1 )
   WHILE !USEREDE( cARQ2, 1, 99 )
   ENDDO
   dbSetOrder( 1 )
   mQTDEINI := nQTDDE
   dbSelectAr( cARQ )
   dbGoTop()
   dbSeek( PadR( yCODIGO, 24 ) + Str( mOS, 8, 2 ) )
   WHILE AllTrim( yCODIGO ) = AllTrim( CODIGO ) .AND. mOS = OS .AND. mQTDEINI > 0 .AND. !Eof()
      mRESERVA := QTDDE
      DO CASE
      CASE mRESERVA = mQTDEINI
         DELEREG(,, .F., .F. )
         MAYG01( mRESERVA, cARQ2,, DLIMITE )
         mQTDEINI := 0
      CASE mRESERVA > mQTDEINI
         netgrvcam( "QTDDE", QTDDE - mQTDEINI )
         MAYG01( mQTDEINI, cARQ2,, DLIMITE )
         mQTDEINI := 0
      CASE mRESERVA < mQTDEINI
         DELEREG(,, .F., .F. )
         MAYG01( mRESERVA, cARQ2,, DLIMITE )
         mQTDEINI -= mRESERVA
      ENDCASE
      dbSelectAr( cARQ )
      dbSkip()
   ENDDO
   dbSelectAr( cARQ )
   dbCloseArea()
   dbSelectAr( cARQ2 )
   dbCloseArea()
   RETU .T.

// + EOF: m_ayg.prg
// +
