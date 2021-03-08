*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_AOCRM.PRG
*+
*+    Reformatted by Click! 2.03 on Jul-5-2002 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

dDATA := ZDATA
MDS( "Qual Data" )
@ 24, 40 get dDATA
if !READCUR()
   retu .F.
endif
CRIARVARS( "PE01BX" )

if !USEREDE( "CRM", 1, 2 )
   dbcloseall()
   retu .F.
endif
dbselectar( "CRM" )
dbgotop()
dbseek( dDATA )
while dDATA = DATA .and. !eof()
   if TIPOE = "M" .or. TIPOE = "C"
      lGRAVOU := .F.
      for X := 1 to 2
         xTIPOE     := TIPOE
         xCODIGO    := padr( CBUSCA, 24 )
         xNRNOTASAI := if( X = 1, MNRNOTA, NRNOTB )
         xDATASAI   := DATA
         xTOTKGSAI  := if( X = 1, QTDEA, QTDEB )
         xCRM       := CRM
         xPEDIDO    := PRPED
         xITEM      := PRITE
         xCLIFOR    := CLIFOR
         do case
         case CRM->GRAVAUP = "S"
            ALERTX( "Crm: " + str( xCRM ) + " Ja Gravado" )
         case empty( xCODIGO )
            ALERTX( "Crm: " + str( xCRM ) + " sem Codigo Produto" )
         case empty( xDATASAI )
            ALERTX( "Crm: " + str( xCRM ) + " sem data" )
         case empty( xTOTKGSAI )
            ALERTX( "Crm: " + str( xCRM ) + " sem quantidade" )
         case empty( xPEDIDO ) .or. empty( xITEM )
            ALERTX( "Crm: " + str( xCRM ) + " sem Programa Recebimento " )
         otherwise
            if IGUALVARS( "PE01", str( xPEDIDO, 5 ) + str( xITEM, 2 ) )
               mDATASAI   := xDATASAI
               mNRNOTASAI := xNRNOTASAI
               mTOTKGSAI  := xTOTKGSAI
               mTOTKGEST  := mTOTKGANT - mTOTKGSAI
               mCRM       := xCRM
               mPEDIDO    := xPEDIDO
               mITEM      := xITEM
               BAIXAREM( "PE01", "PE01BX", str( mPEDIDO, 5 ) + str( mITEM, 2 ) )
               lGRAVOU := .T.
               mTIPO   := xTIPOE
               mCODIGO := xCODIGO
               mUNROTA := xNRNOTASAI
               mUDATA  := xDATASAI
               mUFORNE := xCLIFOR
               mUQTDE  := xTOTKGSAI
               xCODIGO := padr( xCODIGO, 24 )
               if VERSEHA( "PECRT", xTIPOE + xCODIGO + str( xCLIFOR, 8 ) )
                  REPORVARS( "PECRT", xTIPOE + xCODIGO + str( xCLIFOR, 8 ) )
               else
                  APAGAREG( "PECRT", xTIPOE + xCODIGO + str( xCLIFOR, 8 ), .F., .F. )
               endif
            else
               ALERTX( "N„o Encontrei Programa Recebimento: " + str( xPEDIDO ) + "." + str( xITEM ) )
            endif
         endcase
      next X
      if lGRAVOU
         dbselectar( "CRM" )
         netgrvcam("GRAVAUP","S")
         dbunlock()
      endif
   endif
   dbselectar( "CRM" )
   dbskip()
enddo
dbcloseall()

*+ EOF: M_AOCRM.PRG
