*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_AYCRM.PRG
*+
*+    Reformatted by Click! 2.03 on Jul-2-2002 at  5:10 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

priv mFORNECEDO := 0
priv xCODIGO
priv yCODIGO
priv xTIPO1
priv xTIPO2
priv mTIPOENT
priv mNRNOTA
priv mOLDQTDDE
dDATA   := ZDATA
ARQWORK := "MY01"

MDS( "Digite a data da Entrega" )
@ 24, 40 get dDATA
if !READCUR()
   retu .F.
endif
CRIARVARS( "MY01" )
if ! USEMULT({{ "CRM", 1, 2 },{"MY01",1,99}})
   dbcloseall()
   retu .F.
endif
dbselectar( "CRM" )
nLASTREC:=LASTREC()
nPOSREC:=1
dbgotop()
//dbseek( dDATA ) //Tem que ser pela data entrega
while ! eof() //dDATA = DATA .and. !eof()
   if TIPOE = "C" .or. TIPOE = "M"
      lGRAVOU := .F.
      for X := 1 to 2
         dbselectar( "CRM" )
         IF ! EMPTY(if( X = 1, NRNOTA, NRNOTB )).AND.dDATA=if( X = 1, ENTREGA, ENTREG2)
            mCODIGO  := padr( CBUSCA, 24 )
            mNRNOTA  := if( X = 1, NRNOTA, NRNOTB )
            mDATA    := DATA
            mQTDE    := if( X = 1, QTDEA, QTDEB )
            mCRM     := CRM
            xCRM     := CRM
            mOS      := CRM
            mTIPO1   := "E"
            mTIPO2   := TIPOE
            mNUMMB01 := CLIFOR
            mUNID    := UNID
            mDISTRI  := "S"
            if mQTDE > 0
               do case
                  case CRM->GRAVOUY = "S"
                       ALERTX( "Crm: " + str( xCRM ) + " J  Gravado" )
                  case empty( mCODIGO )
                       ALERTX( "Crm: " + str( xCRM ) + " sem Codigo Produto" )
                  case empty( mNRNOTA )
                       ALERTX( "Crm: " + str( xCRM ) + " sem numero nota entrada" )
                  case empty( mDATA )
                       ALERTX( "Crm: " + str( xCRM ) + " sem data" )
                  case empty( mQTDE )
                       ALERTX( "Crm: " + str( xCRM ) + " sem quantidade" )
                  otherwise
                      xCODIGO  := mCODIGO
                      yCODIGO  := mCODIGO
                      xTIPO1   := mTIPO1
                      xTIPO2   := mTIPO2
                      mTIPOENT := mTIPO2
                      mTIPO3   := "CRM"
                      lGRAVOU  := .T.
                      INCLUI   := .T.
                      DBSELECTAR("MY01")
                      DBGOBOTTOM()
                      mNUMERO:=NUMERO+1
                      NOVOOPA("MY01")
                      MAK2K05("I","MY01E")
               endcase
            endif
         endif
      next X
      if lGRAVOU
         dbselectar( "CRM" )
         GRAVACAMPO("GRAVOUY","'S'")
      endif
   endif
   dbselectar( "CRM" )
   ZEI_FORT(nLASTREC,,nPOSREC)
   dbskip()
   nPOSREC++
enddo
dbcloseall()

*+ EOF: M_AYCRM.PRG
