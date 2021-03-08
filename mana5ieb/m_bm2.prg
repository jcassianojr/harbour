*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BM2.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"
function m_bm2
para cARQ, cSTR, cANO, cAPR, nIND
MDI( "Dipam" )

if MDG( "Deseja Reacumular" )
   if MDG( "M€s Fechado" )
      cARQ := cSTR + MESANO()
   endif
   if MDG( "Acumulado" )
      SOMAANO( cANO, cSTR, "PADRAO" )
      cARQ := cANO
   endif
   if !USEREDE( cARQ, 1, 1 )
      dbcloseall()
      retu .F.
   endif
   if !USEREDE( "DIPAM", 0, 99 )
      dbcloseall()
      retu .F.
   endif
   zap
   dbsetorder( 1 )
   if !USEREDE( cAPR, 1, nIND )
      dbcloseall()
      retu .F.
   endif
   if !USEREDE( "FI_NBM", 1, 1 )
      dbcloseall()
      retu .F.
   endif
   dbselectar( cARQ )
   dbgotop()
   while !eof()
      lSOM  := .F.
      cOPER := left( OPERACAO, 3 )
      do case
      case cOPER = "111"
         lSOM := .T.
      case cOPER = "113"
         lSOM := .T.
      case cOPER = "211"
         lSOM := .T.
      case cOPER = "511"
         lSOM := .T.
      case cOPER = "513"
         lSOM := .T.
      case cOPER = "611"
         lSOM := .T.
      case cOPER = "711"
         lSOM := .T.
      endcase
      if lSOM
         mFORNECEDO := FORNECEDO
         mVALORMER  := VALORMER
         mCODIGO    := CODIGO
         mCLASSIPI  := CLASSIPI
         mNOME      := ""
         dbselectar( cAPR )
         dbseek( mCODIGO )
         if found()
            mNOME := NOME
         endif
         if empty( mNOME )
            dbselectar( "FI_NBM" )
            dbseek( strtran( mCLASSIPI, ".", "" ) )
            if found()
               mNOME := DESCRI
            endif
         endif
         if !NOVOOPE( "DIPAM", str( mFORNECEDO, 8 ) + mCLASSIPI + mCODIGO )
            field->VALORMER += mVALORMER
         endif
      endif
      dbselectar( cARQ )
      dbskip()
   enddo
   dbselectar( cARQ )
   dbclosearea()
   if !USEREDE( "DIPAM2", 0, 99 )
      retu .F.
   endif
   zap
   dbsetorder( 1 )
   dbselectar( "DIPAM" )
   dbsetorder( 1 )
   dbgotop()
   while !eof()
      xFORNECEDO := FORNECEDO
      nTOT       := 0
      while xFORNECEDO = FORNECEDO .and. !eof()
         nTOT += VALORMER
         dbskip()
      enddo
      dbselectar( "DIPAM2" )
      netrecapp()
      field->FORNECEDO := xFORNECEDO
      field->VALORMER  := nTOT
      dbselectar( "DIPAM" )
   enddo
   dbselectar( "DIPAM2" )
   dbclosearea()

   if !USEREDE( "DIPAM3", 0, 99 )
      retu .F.
   endif
   zap
   dbsetorder( 1 )
   dbselectar( "DIPAM" )
   dbsetorder( 3 )
   dbgotop()
   while !eof()
      xCLASSIPI := CLASSIPI
      xNOME     := NOME
      nTOT      := 0
      while xCLASSIPI = CLASSIPI .and. xNOME = NOME .and. !eof()
         nTOT += VALORMER
         dbskip()
      enddo
      dbselectar( "DIPAM3" )
      netrecapp()
      field->CLASSIPI := xCLASSIPI
      field->NOME     := xNOME
      field->VALORMER := nTOT
      dbselectar( "DIPAM" )
   enddo
   dbcloseall()
endif

if MDG( "Relatorio Melhores Clientes/Fornecedores" )
   IMPREL( "MM", "MM_00038", "MANREL", "MANRE1" )
endif

if MDG( "Relatorio Melhores Classifica‡”es" )
   IMPREL( "MM", "MM_00039", "MANREL", "MANRE1" )
endif

*+ EOF: M_BM2.PRG
