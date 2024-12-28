// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bm2.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_BM2.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bm2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bm2

   PARA cARQ, cSTR, cANO, cAPR, nIND

   MDI( "Dipam" )

   IF MDG( "Deseja Reacumular" )
      IF MDG( "M€s Fechado" )
         cARQ := cSTR + MESANO()
      ENDIF
      IF MDG( "Acumulado" )
         SOMAANO( cANO, cSTR, "PADRAO" )
         cARQ := cANO
      ENDIF
      IF !USEREDE( cARQ, 1, 1 )
         dbCloseAll()
         RETU .F.
      ENDIF
      IF !USEREDE( "DIPAM", 0, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
      ZAP
      dbSetOrder( 1 )
      IF !USEREDE( cAPR, 1, nIND )
         dbCloseAll()
         RETU .F.
      ENDIF
      IF !USEREDE( "FI_NBM", 1, 1 )
         dbCloseAll()
         RETU .F.
      ENDIF
      dbSelectAr( cARQ )
      dbGoTop()
      WHILE !Eof()
         lSOM  := .F.
         cOPER := Left( OPERACAO, 3 )
         DO CASE
         CASE cOPER = "111"
            lSOM := .T.
         CASE cOPER = "113"
            lSOM := .T.
         CASE cOPER = "211"
            lSOM := .T.
         CASE cOPER = "511"
            lSOM := .T.
         CASE cOPER = "513"
            lSOM := .T.
         CASE cOPER = "611"
            lSOM := .T.
         CASE cOPER = "711"
            lSOM := .T.
         ENDCASE
         IF lSOM
            mFORNECEDO := FORNECEDO
            mVALORMER  := VALORMER
            mCODIGO    := CODIGO
            mCLASSIPI  := CLASSIPI
            mNOME      := ""
            dbSelectAr( cAPR )
            dbSeek( mCODIGO )
            IF Found()
               mNOME := NOME
            ENDIF
            IF Empty( mNOME )
               dbSelectAr( "FI_NBM" )
               dbSeek( StrTran( mCLASSIPI, ".", "" ) )
               IF Found()
                  mNOME := DESCRI
               ENDIF
            ENDIF
            IF !NOVOOPE( "DIPAM", Str( mFORNECEDO, 8 ) + mCLASSIPI + mCODIGO )
               field->VALORMER += mVALORMER
            ENDIF
         ENDIF
         dbSelectAr( cARQ )
         dbSkip()
      ENDDO
      dbSelectAr( cARQ )
      dbCloseArea()
      IF !USEREDE( "DIPAM2", 0, 99 )
         RETU .F.
      ENDIF
      ZAP
      dbSetOrder( 1 )
      dbSelectAr( "DIPAM" )
      dbSetOrder( 1 )
      dbGoTop()
      WHILE !Eof()
         xFORNECEDO := FORNECEDO
         nTOT       := 0
         WHILE xFORNECEDO = FORNECEDO .AND. !Eof()
            nTOT += VALORMER
            dbSkip()
         ENDDO
         dbSelectAr( "DIPAM2" )
         netrecapp()
         field->FORNECEDO := xFORNECEDO
         field->VALORMER  := nTOT
         dbSelectAr( "DIPAM" )
      ENDDO
      dbSelectAr( "DIPAM2" )
      dbCloseArea()

      IF !USEREDE( "DIPAM3", 0, 99 )
         RETU .F.
      ENDIF
      ZAP
      dbSetOrder( 1 )
      dbSelectAr( "DIPAM" )
      dbSetOrder( 3 )
      dbGoTop()
      WHILE !Eof()
         xCLASSIPI := CLASSIPI
         xNOME     := NOME
         nTOT      := 0
         WHILE xCLASSIPI = CLASSIPI .AND. xNOME = NOME .AND. !Eof()
            nTOT += VALORMER
            dbSkip()
         ENDDO
         dbSelectAr( "DIPAM3" )
         netrecapp()
         field->CLASSIPI := xCLASSIPI
         field->NOME     := xNOME
         field->VALORMER := nTOT
         dbSelectAr( "DIPAM" )
      ENDDO
      dbCloseAll()
   ENDIF

   IF MDG( "Relatorio Melhores Clientes/Fornecedores" )
      IMPREL( "MM", "MM_00038", "MANREL", "MANRE1" )
   ENDIF

   IF MDG( "Relatorio Melhores Classifica‡”es" )
      IMPREL( "MM", "MM_00039", "MANREL", "MANRE1" )
   ENDIF

// + EOF: M_BM2.PRG

// + EOF: m_bm2.prg
// +
