// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foid.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOID.PRG: APURA€ŽO GERAL PARA CONTABILIDADE
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     12:16
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************
// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foid()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foid

   PARA CC

   IF !MDL( 'APURA€ŽO GERAL PARA CONTABILIDADE', 0 )
      RETU
   ENDIF
   aCON := {}
   aVAL := {}

   nrMES := MESTRAB
   nrANO := ANO
   MDS( "Confirme a Competencia" )
   @ 24, 40 GET nrMES PICT "99"
   @ 24, 60 GET nrANO PICT "9999"
   READCUR()

   IF !ARQUSAR( CC, 1 )
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "CONTA" )
   ordSetFocus( "temp" )

   cSELE1 := Alias()

   IF !ARQCTA( CC, 1, 1 )
      dbCloseAll()
      RETU
   ENDIF
   cSELE2 := Alias()

   lCCOR := netuse( "CCOR" )   // AREDE("CCCOR","CCCOR",1)
   IF lCCOR
      lARQTXT := MDG( "Criar Arquivo" )
      IF lARQTXT
         cARQTXT := "A" + StrZero( nrANO, 4 ) + StrZero( nrMES, 2 ) + ".TXT"
         nHANDLE := FCreate( cARQTXT )
         IF FError() # 0
            ALERTX( "Erro na Cria‡„o do Arquivo" )
            RETU
         ENDIF
      ENDIF
   ENDIF


   DEB   := VEN := FL := TOT := 0
   CTLIN := 80
   DESC  := HIST := CODC := CODD := ""

   IMPRESSORA()
   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      IF CTLIN > 55
         IF CTLIN # 80
            @ PRow() + 1, 0 SAY REPL( '-', 132 )
         ENDIF
         FL++
         @  1, 1   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
         @  2, 25  SAY IMPCHR( cIMPTIT ) + MSG2
         @  3, 100 SAY Time()
         @  3, 110 SAY DXDIA
         @  3, 120 SAY 'FL. ' + StrZero( FL, 4 )
         @  4, 0   SAY REPL( '-', 132 )
         @  5, 20  SAY IMPCHR( cIMPTIT ) + 'Apuracao Geral Contabilidade ' + MMES + '/' + StrZero( ANO, 4 )
         @  6, 0   SAY REPL( '-', 132 )
         @  7, 1   SAY 'CONTA'
         @  7, 7   SAY 'DESCRIMINACAO DA CONTA'
         @  7, 45  SAY 'VALOR'
         @  7, 68  SAY 'N.Lancto.'
         @  7, 78  SAY 'Conta Contabil'
         @  7, 125 SAY 'Hist.'
         @  8, 0   SAY REPL( '-', 132 )
         CTLIN := 9
      ENDIF
      CTA := CONTA
      TOT := 0
      WHILE CTA = CONTA .AND. !Eof()
         TOT += VALOR
         dbSkip()
      ENDDO
      IMP := .T.
      dbSelectAr( cSELE2 )   // Verifica se Imprime
      dbGoTop()
      IF dbSeek( CTA )
         IF LISCON = "N"
            IMP := .F.
         ENDIF
      ENDIF
      IF CC # 4 .AND. CC # 6   // Contas Reservadas 13o. Salario
         IF CTA > 120 .AND. CTA < 150
            IMP := .F.
         ENDIF
         IF CTA = 910 .OR. CTA = 911 .OR. CTA = 505 .OR. CTA = 506
            IMP := .F.
         ENDIF
      ENDIF
      IF IMP
         FOID04()
         FOID05()
      ENDIF
      dbSelectAr( cSELE1 )
   ENDDO
   dbCloseAll()
   dbSelectAr( cSELE1 )
   VIDEO()
   IF NETUSE( "GINSSE" )
      lCCOR := .F.   // Contas Especias j  e por Empresa
      IF !NETUSE( "CCESP" )
         dbCloseAll()
         RETU .F.
      ENDIF
      IF !NETUSE( "PROV13" )
         dbCloseAll()
         RETU .F.
      ENDIF
      MDS( "Aguarde Preparando Provisao 13S" )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      ordDestroy( "temp" )
      ordCreate(, "temp", "STRZERO(ANO,4)+STRZERO(MES,2)" )
      ordSetFocus( "temp" )


      IF !NETUSE( "PROVFE" )
         dbCloseAll()
         RETU .F.
      ENDIF
      MDS( "Aguarde Preparando Provisao FER" )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      ordDestroy( "temp" )
      ordCreate(, "temp", "STRZERO(ANO,4)+STRZERO(MES,2)" )
      ordSetFocus( "temp" )


      IMPRESSORA()
      dbSelectAr( "CCESP" )
      WHILE !Eof()
         CTA    := CODIGO
         cCAMPO := CAMPO
         DESC   := DESCR
         HIST   := StrZero( CO_HIS, 3 )
         CODC   := 'C-' + CO_COD + '/' + Str( CO_CODR, 6 )
         CODD   := 'D-' + CO_CODD + '/' + Str( CO_CODRD, 6 )
         IF TIPO = "I" .AND. NREMP = NUMEMP
            dbSelectAr( "GINSSE" )
            dbGoTop()
            IF dbSeek( StrZero( NREMP, 5 ) + StrZero( nrANO, 4 ) + StrZero( nrMES, 2 ) )
               TOT := &cCAMPO.
               dbSelectAr( "CCESP" )
               FOID05()
            ENDIF
         ENDIF
         dbSelectAr( "CCESP" )
         IF TIPO = "1" .AND. NREMP = NUMEMP
            TOT := FOID06( "PROV13", cCAMPO )
            dbSelectAr( "CCESP" )
            FOID05()
         ENDIF
         dbSelectAr( "CCESP" )
         IF TIPO = "F" .AND. NREMP = NUMEMP
            TOT := FOID06( "PROVFE", cCAMPO )
            dbSelectAr( "CCESP" )
            FOID05()
         ENDIF
         dbSelectAr( "CCESP" )
         dbSkip()
      ENDDO
      dbCloseAll()
   ENDIF
   IMPRESSORA()
   FOID02( 30, 30 )
   FOID01( .F. )
   VIDEO()
   IMPEND()
   IF lARQTXT
      FWrite( nHANDLE, Chr( 26 ) )
      FClose( nHANDLE )
      IF MDG( "Visualizar Arquivo Remessa" )
         VERTXT( cARQTXT )
      ENDIF
      IF MDG( "Imprimir Arquivo Remessa" )
         IMPARQ( cARQTXT )
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOID01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOID01( lMES )

   CTLIN := 80
   DEB   := VEN := 0
   FOR W := 1 TO Len( aCON )
      IF CTLIN > 50
         @  1, 1   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
         @  2, 25  SAY IMPCHR( cIMPTIT ) + MSG2
         @  3, 100 SAY Time()
         @  3, 110 SAY DXDIA
         @  3, 120 SAY 'FL. ' + StrZero( FL, 4 )
         @  4, 0   SAY REPL( '-', 132 )
         @  5, 20  SAY IMPCHR( cIMPTIT ) + 'Apuracao Geral Contabilidade ' + MMES + '/' + StrZero( ANO, 4 )
         @  6, 0   SAY REPL( '-', 132 )
         @  7, 1   SAY 'CONTA'
         @  7, 45  SAY 'Credito'
         @  7, 65  SAY 'Debito'
         @  8, 0   SAY REPL( '-', 132 )
         CTLIN := 9
         IF lMES
            FOI2B01()
         ENDIF
      ENDIF
      @ CTLIN, 2  SAY aCON[ W ]
      @ CTLIN, 45 SAY aVAL[ W, 1 ] PICT '###,###,###,###.##'
      @ CTLIN, 65 SAY aVAL[ W, 2 ] PICT '###,###,###,###.##'
      IF lARQTXT
         FWrite( nHANDLE, StrTran( PadR( StrTran( aCON[ W ], ".", "" ), 13 ), " ", "0" ) )
         FWrite( nHANDLE, StrTran( StrZero( aVAL[ W,  1 ], 13, 2 ), ".", "" ) )
         FWrite( nHANDLE, StrTran( StrZero( aVAL[ W,  2 ], 13, 2 ), ".", "" ) )
         IF lMES
            DO CASE
            CASE CC = 1
               FWrite( nHANDLE, StrZero( DEP, 4 ) + "000000" )
            CASE CC = 2
               FWrite( nHANDLE, StrZero( DEP, 4 ) + StrZero( SET, 3 ) + "000" )
            CASE CC = 3
               FWrite( nHANDLE, StrZero( DEP, 4 ) + StrZero( SET, 3 ) + StrZero( SEC, 3 ) )
            ENDCASE
         ENDIF
         FWrite( nHANDLE, Chr( 13 ) + Chr( 10 ) )
      ENDIF
      CTLIN++
      VEN += aVAL[ W, 1 ]
      DEB += aVAL[ W, 2 ]
   NEXT W
   FOID02( 45, 65 )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOID02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOID02( nCOL1, nCOL2 )

   @ PRow() + 1, 0  SAY REPL( '-', 132 )
   @ PRow() + 1, 0  SAY 'Resumo Geral'
   @ PRow() + 1, 0  SAY 'Total Creditos'
   @ PRow(), nCOL1 SAY VEN              PICT '###,###,###,###.##'
   @ PRow() + 1, 0  SAY 'Total Debitos'
   @ PRow(), nCOL2 SAY DEB              PICT '###,###,###,###.##'
   @ PRow() + 1, 0  SAY REPL( '-', 132 )
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOID03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOID03

   IF !Empty( CO_COD ) .OR. !Empty( CO_CODR )
      VEN  += TOT
      nPOS := AScan( aCON, CO_COD )
      IF nPOS > 0
         aVAL[ nPOS,  1 ] += TOT
      ELSE
         AAdd( aCON, CO_COD )
         AAdd( aVAL, { TOT, 0 } )
      ENDIF
   ENDIF
   IF !Empty( CO_CODD ) .OR. !Empty( CO_CODRD )
      DEB  += TOT
      nPOS := AScan( aCON, CO_CODD )
      IF nPOS > 0
         aVAL[ nPOS,  2 ] += TOT
      ELSE
         AAdd( aCON, CO_CODD )
         AAdd( aVAL, { 0, TOT } )
      ENDIF
   ENDIF
   RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOID04()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOID04( cCONTA )

   LOCAL lIND := .F.

   IF ValType( cCONTA ) # "C"
      cCONTA := "CONTAS"
   ENDIF
   DESC := 'Conta nao Cadastrada'
   HIST := "   "
   CODC := Space( 20 )
   CODD := Space( 20 )
   IF lCCOR
      dbSelectAr( "CCCOR" )
      dbGoTop()
      IF dbSeek( Str( CTA, 4 ) + Str( NREMP, 5 ) )
         HIST := StrZero( CO_HIS, 3 )
         CODC := 'C-' + CO_COD + '/' + Str( CO_CODR, 6 )
         CODD := 'D-' + CO_CODD + '/' + Str( CO_CODRD, 6 )
         lIND := .T.
      ENDIF
   ENDIF
   dbSelectAr( cCONTA )
   dbGoTop()
   IF dbSeek( CTA )
      DESC := DESCR
      IF lIND  // Dados Individuais Retorna
         RETU .T.
      ENDIF
      HIST := StrZero( CO_HIS, 3 )
      CODC := 'C-' + CO_COD + '/' + Str( CO_CODR, 6 )
      CODD := 'D-' + CO_CODD + '/' + Str( CO_CODRD, 6 )
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOID05()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOID05()

   @ CTLIN, 2   SAY CTA        PICT "###"
   @ CTLIN, 6   SAY DESC
   @ CTLIN, 45  SAY TOT        PICT '###,###,###,###.##'
   @ CTLIN, 69  SAY '________'
   @ CTLIN, 79  SAY CODD
   @ CTLIN, 102 SAY CODC
   @ CTLIN, 125 SAY HIST
   CTLIN++
   FOID03()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOID06()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOID06( cARQ, cCAMPO )

   LOCAL nRETU := 0

   VIDEO()
   MDS( "Acumulando Provis„o: " + cARQ + " " + cCAMPO )
   dbSelectAr( cARQ )
   dbGoTop()
   dbSeek( StrZero( nrANO, 4 ) + StrZero( nrMES, 2 ) )
   WHILE nrANO = ANO .AND. nrMES = MES .AND. !Eof()
      nRETU += &cCAMPO
      dbSkip()
   ENDDO
   IMPRESSORA()
   RETU nRETU
// : FIM: FOID.PRG

// + EOF: foid.prg
// +
