// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_e7.prg
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fores_e7()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fores_e7

   PARA CC

   IF !MDL( 'Listar Rescisao contratual em formulario', 0 )
      RETU
   ENDIF
   IF !NETUSE( "REL2" )  // AREDE( "REL2", "REL2", 1 )
      RETU
   ENDIF
   INITVARS()
   dbGoTop()
   IF !dbSeek( 'RESCISA2' )
      ALERTX( "Configure o Formul rio" )
      dbCloseArea()
      RETU .F.
   ENDIF
   EQUVARS()
   dbCloseArea()

   CABE2( 'Confirme os Dados' )
   CTR        := 0
   HOMO       := Date()
   CODSAQ     := 0
   nPENSAO    := 0000000.00
   cTOMADOR   := Space( 20 )
   cMOTIVO    := Space( 2 )
   cCATEGORIA := Space( 20 )
   @ 18, 00 SAY 'Digite o numero do Funcionario'
   @ 19, 00 SAY 'Qual a Data da Homologa‡„o'
   @ 20, 00 SAY 'Qual o C¢digo de Saque FGTS'
   @ 21, 00 SAY 'CPF/CGC Tomador Servi‡o'
   @ 22, 00 SAY '% Pensao'
   @ 23, 00 SAY 'Cod.Afastamento'
   @ 24, 00 SAY 'Categoria'
   @ 18, 40 GET CTR
   @ 19, 40 GET HOMO
   @ 20, 40 GET CODSAQ
   @ 21, 40 GET cTOMADOR
   @ 22, 40 GET nPENSAO
   @ 23, 40 GET cMOTIVO
   @ 24, 40 GET cCATEGORIA
   IF !READCUR()
      RETU .F.
   ENDIF

   IF !NETUSE( PES )   // AREDE( PES, PES, 1 )
      RETU
   ENDIF
   IF !NETUSE( "FO_RSS" )  // AREDE( "FO_RSS", "FO_RSS", 1 )
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "CONTAS" )  // AREDE( "CONTAS", "CONTAS", 1 )
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "FIRMA" )   // AREDE( "FIRMA", "FIRMA", 1 )
      dbCloseAll()
      RETU
   ENDIF
// if ! NETUSE("BCOFGTS")
// dbcloseall()
// retu
// endif
   IF !NETUSE( "RESFOR" )  // AREDE( "RESFOR", "RESFOR", 1 )
      dbCloseAll()
      RETU
   ENDIF

   dbSelectAr( PES )
   dbGoTop()
   IF !dbSeek( CTR )
      MDT( 'Funcion rio n„o Encontrado' )
      dbCloseAll()
      RETU
   ENDIF
   MEF := Month( DEMITIDO )

   dbSelectAr( "RESFOR" )
   dbGoTop()
   IF !dbSeek( CTR )
      netrecapp()
      field->NUMERO := CTR
   ELSE
      netreclock()
      FOR X := 29 TO 55
         cVAR          := "VAL" + StrZero( X, 2 )
         field->&cVAR. := 0
         cVAR          := "HOR" + StrZero( X, 2 )
         field->&cVAR. := 0
      NEXT X
      // NÆo efetura unlock pois grava valores embaixo
   ENDIF

   xCAUSA := OBTER( "FO_RCAU", "", MOTIVO, "NOME" )
   dbSelectAr( "FO_RSS" )
   xVAL1 := VALCTA( CTR, 109 )
   xVAL1 += VALCTA( CTR, 905 )
   IF xVAL1 > 0 .AND. MDG( "Experiencia Termino Contrato a Termo" )
      xCAUSA := 'Termino de Contrato a Termo '
   ENDIF
   MDS( "Confirme Motivo" )
   @ 24, 20 GET xCAUSA
   READCUR()

   dbSelectAr( PES )
   SALH := SALM := VAR1 := 0
   SALHM( if( MEF # 0, MEF, MES ) )
   XTIPO := CHECKTAB( "TSA2" + TIPO + "    ",,, "Tipo nao Cadastrado", 2 )

   nVEN := nDES := 0

   dbSelectAr( "CONTAS" )
   WHILE !Eof()
      IF !Empty( POSREC )
         IF POSREC > 28 .AND. POSREC < 56 .AND. POSREC # 46 .AND. POSREC # 54 .AND. POSREC # 55  // Totais e Fora
            nCONTA := CODIGO
            nPOS   := POSREC
            cDESC  := DESCR
            dbSelectAr( "FO_RSS" )
            dbGoTop()
            IF dbSeek( CTR * 10000 + nCONTA )
               nHORAS := HORAS
               nVALOR := VALOR
               IF nVALOR > 0
                  dbSelectAr( "RESFOR" )
                  netreclock()
                  cVAR          := "VAL" + StrZero( nPOS, 2 )
                  field->&cVAR. := &cVAR. + nVALOR   // Soma ctas multiplas
                  cVAR          := "HOR" + StrZero( nPOS, 2 )
                  field->&cVAR. := &CVAR. + nHORAS
                  cVAR          := "DES" + StrZero( nPOS, 2 )
                  field->&cVAR. := cDESC
                  IF nPOS < 46
                     nVEN += nVALOR
                  ELSE
                     nDES += nVALOR
                  ENDIF
                  dbUnlock()
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( "CONTAS" )
      dbSkip()
   ENDDO
   dbSelectAr( "RESFOR" )
   netreclock()
   field->VAL46 := nVEN
   field->VAL54 := nDES
   field->VAL55 := nVEN - nDES
   dbUnlock()
   TELASAY( "RESFOR" )
   EDITSAY( "RESFOR" )

// SET PRINT ON
// QQOUT(IMPCHR(27)+'C'+IMPCHR(73))
// QQOUT(cIMPNEG)
// SET PRINT OFF
   IMPRESSORA()

   @  0, 0 SAY IMPSTR( cIMPCOM )

   dbSelectAr( "FIRMA" )
   dbGoTop()
   dbSeek( NREMP )
   @ PRow() + mA, mB SAY CGC
   @ PRow(), mC    SAY RAZAO
   @ PRow() + mD, mB SAY ENDERECO
   @ PRow(), mE    SAY BAIRRO
   @ PRow() + MD, mB SAY CIDADE
   @ PRow(), mF    SAY ESTADO
   @ PRow(), mG    SAY CEP
   @ PRow(), mH    SAY ATIVIDADE
   @ PRow(), mE    SAY cTOMADOR
   dbSelectAr( PES )
   @ PRow() + mJ, mB    SAY PIS
   @ PRow(), mC       SAY NOME
   @ PRow() + mD, mB    SAY ENDER + "," + AllTrim( ENDNUM ) + " " + AllTrim( ENDCOMPL )
   @ PRow(), mE       SAY BAIRRO
   @ PRow() + MD, mB    SAY CIDADE
   @ PRow(), mF       SAY ESTADO
   @ PRow(), mG       SAY CEP
   @ PRow(), mI       SAY IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, CPF, PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 digitos do CPF e o campo Serie, com os 4 digitos restantes
   @ PRow() + MD, mB    SAY CPF
   @ PRow(), mK       SAY NASC
   @ PRow(), mL       SAY MAE
   @ PRow() + MJ, mB    SAY VAR1                                                                                                                                                           PICT '@E ###,###,###.##'
   @ PRow(), PCol() + 1 SAY xTIPO
   @ PRow(), mM       SAY ADMITIDO
   IF !Empty( AVISOPREV )
      @ PRow(), mN SAY AVISOPREV
   ENDIF
   @ PRow(), mE    SAY DEMITIDO
   @ PRow() + MD, mB SAY xCAUSA
   @ PRow(), mO    SAY cMOTIVO
   @ PRow(), mP    SAY nPENSAO
   @ PRow(), mQ    SAY cCATEGORIA

   dbSelectAr( "RESFOR" )
   FOR X := 1 TO 9
      // 1 COLUNA
      Z    := X + 28
      cVAR := "HOR" + StrZero( Z, 2 )
      IF X = 1
         @ PRow() + mJ, 0 SAY ""
      ELSE
         IF Z > 29 .AND. Z < 35 .OR. Z = 36 .AND. &cVAR. > 0
            @ PRow() + MD, MR SAY &cVAR.
         ELSE
            @ PRow() + MD, 0 SAY ""
         ENDIF
      ENDIF
      cVAR := "VAL" + StrZero( Z, 2 )
      IF &cVAR. > 0
         @ PRow(), MS SAY &cVAR.
      ENDIF

      // 2 COLLUNA
      Z := X + 37
      IF Z = 40
         cVAR := "HOR" + StrZero( Z, 2 )
         IF &CVAR. > 0
            @ PRow(), MT SAY &cVAR.
         ENDIF
      ENDIF
      IF Z > 41 .AND. Z < 46
         cVAR := "DES" + StrZero( Z, 2 )
         @ PRow(), MU SAY PadR( &cVAR., 20 )
      ENDIF
      cVAR := "VAL" + StrZero( Z, 2 )
      IF &cVAR. > 0
         @ PRow(), MV SAY &cVAR.
      ENDIF

      // 3 COLUNA
      Z := X + 46
      IF Z = 51 .OR. Z = 52 .OR. Z = 53
         cVAR := "DES" + StrZero( Z, 2 )
         @ PRow(), MW SAY PadR( &cVAR., 20 )
      ENDIF
      cVAR := "VAL" + StrZero( Z, 2 )
      IF &CVAR. > 0
         @ PRow(), MX SAY &cVAR.
      ENDIF

   NEXT X

   dbSelectAr( "FIRMA" )
   @ PRow() + mY, mB SAY AllTrim( CIDADE ) + ", " + DToC( HOMO )

   IMPFOL()
   VIDEO()
// SET PRINT ON
// QQOUT(cIMPNER)
// QQOUT(IMPCHR(27)+'C'+IMPCHR(66))
// SET PRINT OFF
   dbCloseAll()
   IMPEND()
   RETU


// + EOF: fores_e7.prg
// +
