// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_al3.prg
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


// Fechamento do Contas a Pagas e Recebidas
//
//


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_al3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_al3

   PARA cARQREF, cSTRREF, cVARREF, cARQRE2, cSTRRE2, cVARASS, cARQRE3, cSTRRE3, cVARAS3

   MDI( " Ý Fechamento Mensal " )
   @ 22, 00 SAY cARQREF
   lSEG := .F.
   lTER := .F.
   IF ValType( cARQRE2 ) = "C" .AND. ValType( cSTRRE2 ) = "C" .AND. ValType( cVARASS ) = "C"
      lSEG := .T.
   ENDIF
   IF ValType( cARQRE3 ) = "C" .AND. ValType( cSTRRE3 ) = "C" .AND. ValType( cVARAS3 ) = "C"
      lTER := .T.
   ENDIF
// IF VALTYPE(cREFER)="C"
// cMESANO:=cSTRREF+cREFER
// ELSE
// cMESANO:=cSTRREF+MESANO()
// ENDIF

   aRETU   := PEGMES( { "" }, .F., { "" } )
   cMES    := aRETU[ 3 ]
   cANO    := aRETU[ 4 ]
   cMESANO := cSTRREF + cANO + cMES
   cDIRE   := ZDIRP + "E" + StrZero( znumero, 3 ) + StrZero( aRETU[ 2 ], 4 ) + "\"
   IF Empty( Aretu[ 1 ] ) .OR. Empty( Aretu[ 2 ] )
      ALERTX( "Ano e(ou) Mes NÆo Preenchido(s)" )
      RETU .F.
   ENDIF

   CRIARVARS( cARQREF )
   IF cARQREF = "MAIL"
      CHECKARQ( cARQREF, cMESANO,, .F., cDIRE, aRETU[ 2 ], aRETU[ 1 ] )
   ELSE
      CHECKARQ( cARQREF, cMESANO,,, cDIRE, aRETU[ 2 ], aRETU[ 1 ] )
   ENDIF
   IF lSEG
      cMESAN2 := cSTRRE2 + cANO + cMES
      CRIARVARS( cARQRE2 )
      CHECKARQ( cARQRE2, cMESAN2,,, cDIRE, aRETU[ 2 ], aRETU[ 1 ] )
   ENDIF
   IF lTER
      cMESAN3 := cSTRRE3 + cANO + cMES
      CRIARVARS( cARQRE3 )
      CHECKARQ( cARQRE3, cMESAN3,,, cDIRE, aRETU[ 2 ], aRETU[ 1 ] )
   ENDIF
   IF !MDG( "Iniciar Fechamento" + Str( aRETU[ 1 ] ) + "/" + Str( aRETU[ 2 ] ) )
      RETU .F.
   ENDIF
   IF cARQREF = "MAIL"
      IF !USEREDE( cARQREF, 1, 0 )   //
         RETU .F.
      ENDIF
      IF !USEREDE( cMESANO, 1, 0 )
         dbCloseAll()
         RETU .F.
      ENDIF
   ELSE
      IF !USEREDE( cARQREF, 1, 99 )  //
         RETU .F.
      ENDIF
      IF !USEREDE( cMESANO, 1, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
   ENDIF
   IF lSEG
      IF !USEREDE( cARQRE2, 1, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
      IF !USEREDE( cMESAN2, 1, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
   ENDIF
   IF lTER
      IF !USEREDE( cARQRE3, 1, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
      IF !USEREDE( cMESAN3, 1, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
   ENDIF
   MDS()
   @ 22, 00 SAY cARQREF
   dbSelectAr( cARQREF )
   nLASTREC := LastRec()
   nPOSREC  := 1
   dbGoTop()
   WHILE !Eof()
      IF ValType( cVARREF ) # "C"
         dDATAREF := DATAPG
      ELSE
         dDATAREF := &cVARREF.
      ENDIF
      @ 24, 00 SAY Str( RecNo(), 8 )
      @ 24, 09 SAY dDATAREF
      IF StrZero( Month( dDATAREF ), 2 ) = cMES .AND. ;
            SubStr( StrZero( Year( dDATAREF ), 4 ), 3, 2 ) = cANO
         EQUVARS()
         IF lSEG
            xCHAVE := &cVARASS.
            @ 24, 18 SAY xCHAVE
         ENDIF
         IF lTER
            xCHAV3 := &cVARAS3.
         ENDIF
         NOVOOPA( cMESANO,,, .F. )
         DELEREG( cARQREF,,, .F. )
         IF lSEG
            dbSelectAr( cARQRE2 )
            dbGoTop()
            dbSeek( xCHAVE )
            WHILE !Eof()
               EQUVARS()
               IF xCHAVE = &cVARASS.
                  NOVOOPA( cMESAN2,,, .F. )
                  DELEREG( cARQRE2,,, .F. )
               ELSE
                  EXIT
               ENDIF
               dbSkip()
            ENDDO
         ENDIF
         IF lTER
            dbSelectAr( cARQRE3 )
            dbGoTop()
            dbSeek( xCHAV3 )
            WHILE !Eof()
               EQUVARS()
               IF xCHAV3 = &cVARAS3.
                  NOVOOPA( cMESAN3,,, .F. )
                  DELEREG( cARQRE3,,, .F. )
               ELSE
                  EXIT
               ENDIF
               dbSkip()
            ENDDO
         ENDIF
      ENDIF
      dbSelectAr( cARQREF )
      dbSkip()
      zei_fort( nLASTREC, .T., nPOSREC )
      nPOSREC++
   ENDDO
   dbCloseAll()
   lFIXUSER := ZUSER <> "SOFTEC" .OR. MDG( "Fixar" + CARQREF )
   IF cARQREF = "MAIL"
      IF lFIXUSER
         FIXAR( cARQREF, .F. )
      ENDIF
   ELSE
      IF lFIXUSER
         FIXAR( cARQREF )
      ENDIF
   ENDIF
   IF lSEG
      IF lFIXUSER
         FIXAR( cARQRE2 )
      ENDIF
   ENDIF
   IF lTER
      IF cARQRE3 = "MM06"  // Itens de NF Canceladas
         IF !USEREDE( cARQRE3, 1, 99 )
            dbCloseAll()
            RETU .F.
         ENDIF
         IF !USEREDE( cMESAN3, 1, 99 )
            dbCloseAll()
            RETU .F.
         ENDIF
         dbSelectAr( cARQRE3 )
         WHILE !Eof()
            IF StrZero( Month( dCANCEL ), 2 ) = cMES .AND. ;
                  SubStr( StrZero( Year( dCANCEL ), 4 ), 3, 2 ) = cANO
               EQUVARS()
               NOVOOPA( cMESN3,,, .F. )
               DELEREG( cARQRE3,,, .F. )
            ENDIF
            dbSelectAr( cARQRE3 )
            dbSkip()
         ENDDO
         dbCloseAll()
      ENDIF
      IF lFIXUSER
         FIXAR( cARQRE3 )
      ENDIF
   ENDIF
   IF cARQREF = "MAIL"
      IF lFIXUSER
         MAILFIX()
      ENDIF
   ENDIF

// + EOF: m_al3.prg
// +
