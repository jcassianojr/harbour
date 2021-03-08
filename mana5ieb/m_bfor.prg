*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\ITAESBRA\M_BFOR.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-10-2002 at  3:07 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

MDI( " н Apurando Business Plan Fornecedor" )

dINI := dFIM := ZDATA
nANO := year( ZDATA )
MDS( "Digite o Periodo" )
@ 24, 20 get dINI
@ 24, 30 get dFIM
@ 24, 40 get nANO pict "9999"
READCUR()

if MDG( "Apurar CRM" )
   if !USEMULT( { { "BPFORC", 0, 99 }, { "CRM", 1, 2 } } )  //Data
      retu .F.
   endif
   dbselectar( "BPFORC" )
   zap
   dbselectar( "CRM" )
   dbgotop()
   dbseek( dINI )
   while DATA <= dFIM .and. !eof()
      @ 24, 00 say CRM
      @ 24, 10 say CLIFOR
      mFORNECEDO := CLIFOR
      mTIPO      := TIPCAD
      if mTIPO = "F"
         dbselectar( "BPFORC" )
         dbgotop()
         if !dbseek( mFORNECEDO )
            netrecapp()
            field->FORNECEDO := mFORNECEDO
         endif
      endif
      dbselectar( "CRM" )
      dbskip()
   enddo
   dbcloseall()
endif

if MDG( "Apurar NFC")
   if !USEMULT( { { "BPFORC", 1, 1 }, { "BPFORR", 0, 99 }, { "MB01", 1, 1 } } )
      retu .F.
   endif
   dbselectar( "BPFORR" )
   zap
   MDS( "" )
   for X = 1 to 12
      @ 24, 00 say X
      cARQUIVO := "K1" + right( strzero( nANO, 4 ), 2 ) + strzero( X, 2 )
      if USEREDE( cARQUIVO, 1, 2 )      //Fornecedo
         dbselectar( "BPFORC" )
         dbgotop()
         while !eof()
            mFORNECEDO := FORNECEDO
            @ 24, 10 say mFORNECEDO
            mVALOR   := 0
            mCOGNOME := ""
            mGRUPO   := ""
            dbselectar( cARQUIVO )
            dbgotop()
            dbseek( mFORNECEDO )
            while mFORNECEDO = FORNECEDO .and. !eof()
               mVALOR += TOTNF
               dbskip()
            enddo
            if mVALOR > 0
               dbselectar( "MB01" )
               dbgotop()
               if dbseek( mFORNECEDO )
                  mCOGNOME := COGNOME
                  mGRUPO   := CODMAT
               endif
               dbselectar( "BPFORR" )
               netrecapp()
               field->COGNOME   := mCOGNOME
               field->GRUPO     := mGRUPO
               field->FORNECEDO := mFORNECEDO
               field->VALOR     := mVALOR
               field->ANO       := nANO
               field->MES       := X
            endif
            dbselectar( "BPFORC" )
            dbskip()
         enddo
         dbselectar( cARQUIVO )
         dbclosearea()
      endif
   next X
   dbselectar( "BPFORC" )
   dbcloseall()
endif
if MDG( "Calcular Percentual" )
   mds("")
   if USEREDE( "BPFORR", 1, 99)
      dbselectar( "BPFORR" )
      for X = 1 to 12
         @ 24,00 SAY X
         nTOTAL := 0
         dbgotop()
         dbseek( str( nANO, 4 ) + str( X, 2 ) )
         while nANO = ANO .and. MES = X .and. !eof()
            @ 24,10 SAY FORNECEDO
            nTOTAL += VALOR
            dbskip()
         enddo
         dbgotop()
         dbseek( str( nANO, 4 ) + str( X, 2 ) )
         while nANO = ANO .and. MES = X .and. !eof()
            @ 24,20 SAY FORNECEDO
            netgrvcam("PERC",PERC( VALOR,nTOTAL ))
            dbskip()
         enddo
      next X
      dbcloseall()
   endif
endif

*+ EOF: M_BFOR.PRG
