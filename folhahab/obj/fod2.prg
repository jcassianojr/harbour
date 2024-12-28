// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fod2.prg
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
// :      FOD2.PRG : Calcular a folha de pagamento
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 03/03/99
// :
// :*****************************************************************************



// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fod2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fod2

   PARA nFOLTIP

   IF nFOLTIP = 1
      CABEX( 'Calcular a Folha de Pagamento' )
   ELSE
      CABEX( 'Calcular a Folha de Pagamento Complementar' )
   ENDIF
   SetColor( "R/GR" )
   hb_DispBox( 08, 00, 21, 79, B_DOUBLE + " " )
   @ 10, 03 SAY "Aten‡„o:"
   @ 12, 03 SAY "Vocˆ s¢ poder  Calcular o pagamento ap¢s ter iniciado o mˆs !!!"
   @ 14, 03 SAY "Caso vocˆ j  tenha iniciado o mˆs digite S para o programa continuar."
   @ 16, 03 SAY "Caso n„o tenha iniciado digite N, inicie o mˆs, depois retorne."
   @ 18, 03 SAY "Caso vocˆ j  tenha iniciado para o c lculo do adiantamento n„o ter "
   @ 19, 08 SAY "necessidade de reiniciar."
   CLSCOR()
   IF !MDG( 'Deseja continuar' )
      IF nFOLTIP = 1
         IF MDG( 'Deseja Inciar Agora o Mˆs' )
            FOD7()
         ELSE
            RETU .F.
         ENDIF
      ENDIF
   ENDIF
   MUDADATA()

   SetColor( "R/GR" )
   hb_DispBox( 08, 00, 21, 79, B_DOUBLE + " " )
   @ 10, 03 SAY "Aten‡„o:"
   @ 12, 03 SAY "N„o se esquece de Verificar se houve altera‡”es na:"
   @ 14, 03 SAY "- Tabelas de INSS, IRRF"
   @ 16, 03 SAY "- Tabelas de Descontos de Assistencias M‚dica e Odontologica"
   @ 18, 03 SAY "- Cadastro de Sindicatos - Mensalidades e Contribui‡”es."
   @ 20, 03 SAY "- Ter Efetuados as transferencias Ferias/Rescisao."
   CLSCOR()
   IF !MDG( 'As tabelas est…o OK, Podemos Calcular ' )
      RETU
   ENDIF

   CLSROW( 7 )
   DOMINGO := 5
   MDS( 'Quantidade de Dias(DSR) do Mˆs para Adicional de DSR ' )
   @ 24, 70 GET DOMINGO PICT '#'
   READCUR()

   MDS( 'Carregando tabela IAPAS ' )
   IF !netuse( "tabinss" )   // BREDE("TABINSS",1)
      RETU .F.
   ENDIF
   dbGoto( MESTRAB )
   IN1  := ATESAL1
   IN2  := ATESAL2
   IN3  := ATESAL3
   IN4  := ATESAL4
   IN5  := ATESAL5
   IN6  := ATESAL6
   IN7  := ATESAL7
   TX1  := ( TAXA1 / 100 )
   TX2  := ( TAXA2 / 100 )
   TX3  := ( TAXA3 / 100 )
   TX4  := ( TAXA4 / 100 )
   TX5  := ( TAXA5 / 100 )
   TX6  := ( TAXA6 / 100 )
   TX7  := ( TAXA7 / 100 )
   TXI1 := ( TAXAI1 / 100 )
   TXI2 := ( TAXAI2 / 100 )
   TXI3 := ( TAXAI3 / 100 )
   TXI4 := ( TAXAI4 / 100 )
   TXI5 := ( TAXAI5 / 100 )
   TXI6 := ( TAXAI6 / 100 )
   TXI7 := ( TAXAI7 / 100 )
   TX   := 0
   TXI  := 0
   DO CASE
   CASE TX7 <> 0.00
      TX  := TX7
      TXI := TXI7
   CASE TX6 <> 0.00
      TX  := TX6
      TXI := TXI6
   CASE TX5 <> 0.00
      TX  := TX5
      TXI := TXI5
   CASE TX4 <> 0.00
      TX  := TX4
      TXI := TXI4
   CASE TX3 <> 0.00
      TX  := TX3
      TXI := TXI3
   CASE TX2 <> 0.00
      TX  := TX2
      TXI := TXI2
   CASE TX1 <> 0.00
      TX  := TX1
      TXI := TXI1
   ENDCASE
   TETOINPS   := TETOMAXIMO
   TETOINPSI  := TETOIRRF
   SALFAMILIA := FAMILIA
   SALFAMIL1  := FAMILIA1
   TETOFAMIL  := TETOSALFA
   TETOFAMI1  := TETOSALF1
   INSSDESC   := DESCONTO
   dbCloseAll()

   MDS( 'Carregando tabela IRRF' )
   QTDEIRRF   := VDEPENDE := DESC_MINIMO := IRRF1 := IRTX1 := IRPA1 := 0
   IRRF2      := IRTX2 := IRPA2 := IRRF3 := IRTX3 := IRPA3 := IRRF4 := IRTX4 := IRPA4 := 0
   IRRF5      := IRTX5 := IRPA5 := IRRF6 := IRTX6 := IRPA6 := IRRF7 := IRTX7 := IRPA7 := 0
   ARREIRRF   := DESPIRRF := 'N'
   mFATORIRRF := mFATORIRR2 := 0
   IF RECOIRRF # 'S'
      MESTRAB++
   ENDIF
   TABIRRF()
   IF RECOIRRF # 'S'
      MESTRAB++
   ENDIF

   MDS( 'Carregando Tabela de Refei‡„o' )
   ALMOCO := ARREDOR := 0
   PROD   := .F.
   IF !netuse( "firma" )   // AREDE("FIRMA","FIRMA",0)
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( NREMP )
      XSAL    := LTrim( MMES )
      XSAL    := SubStr( XSAL, 1, 3 )
      XSAL    := 'SAL' + XSAL
      ALMOCO  := &XSAL
      ARREDOR := ARREDONDA
      IF PRODU = 'S'
         PROD := .T.
      ENDIF
   ENDIF
   dbCloseAll()

   MDS( 'Carregando Tabela Assistˆncia M‚dica' )
   VAASSMED := PEGVALTAB( "ASSMED" )

   MDS( 'Carregando Tabela Assistˆncia Odont¢gica' )
   VAASSODO := PEGVALTAB( "ASSODO" )


// Carregando Truncar FGTS
   mTRUNCAR := OBTER( "BCOFGTS",, NREMP, "TRUNCAR" )
   mTRUNCA2 := OBTER( "BCOFGTS",, NREMP, "TRUNCA2" )

   PUBLIC SALH, SALM
   XA := XB := XC := XD := XE := XF := 1
   IF !netuse( pes )
      RETU
   ENDIF
   FILTRO := 'EMPTY(DEMITIDO)'
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   dbCloseAll()

   IF nFOLTIP = 2
      IF MDG( "Deseja Importar Folha" )
         nMESIMP := 0
         MDS( "Digite o Mes" )
         @ 24, 40 GET nMESIMP RANGE 1, 12
         IF !READCUR()
            RETU .F.
         ENDIF
         IF nMESIMP > 0 .AND. nMESIMP < 13
            FOLIMP := ZDIRE + IF( NRSEN <> 'DiReT', 'FP', 'SO' ) + EMP + StrZero( nMESIMP, 2 )


            MDS( "Aguarde Importando" )
            netzap( "fo_comp" )
            IF !netuse( "fo_comp" )  // AREDE("FO_COMP","FO_COMP",0)
               RETU .F.
            ENDIF
            INITVARS()
            CLRVARS()

            nLASTREC := NetRegCount( folimp )
            zei_fort( nLASTREC,,, 0 )
            APPEND FROM &FOLIMP WHILE zei_fort( nLASTREC,,, 1 )


            dbGoTop()
            WHILE !Eof()
               nRECNO := RecNo()
               IF CONTA # 996
                  netreclock()
                  FIELD->MES1      := nMESIMP
                  FIELD->VALORMES1 := VALOR
                  dbUnlock()
               ENDIF
               IF CONTA = 440
                  EQUVARS()
                  netrecapp()
                  mCONTA     := 996
                  mCONTROLE  := ( mNUMERO * 10000 ) + mCONTA
                  mVALORMES1 := 0
                  mVALORMES2 := 0
                  REPLVARS()
                  dbGoto( nRECNO )
               ENDIF
               dbSkip()
            ENDDO
            dbCloseAll()
         ENDIF
      ENDIF
      MDS( "Confirme o Arredondamento" )
      @ 24, 40 GET ARREDOR
      READCUR()
   ENDIF

   FOD2BAS()
   FOD2CRE()
   FOD2DES()
   IF MDG( 'Deseja criar Conta de encargos' )
      FOD2ENC()
   ENDIF


   IF nFOLTIP = 2
      IF !netuse( "fo_comp" )  // AREDE("FO_COMP","FO_COMP",0)
         RETU .F.
      ENDIF
      dbGoTop()
      WHILE !Eof()
         netreclock()
         IF VALOR > 0 .AND. CONTA # 440 .AND. CONTA # 996
            IF VALOR > VALORMES1
               FIELD->VALORMES2 := VALOR - VALORMES1
            ELSE
               FIELD->VALORMES2 := 0
            ENDIF
            FIELD->MES2 := MES
         ENDIF
         IF VALOR > 0 .AND. CONTA = 440
            FIELD->VALORMES2 := VALOR
            FIELD->MES2      := MES
         ENDIF
         dbUnlock()
         IF Empty( VALOR ) .AND. Empty( VALORMES1 ) .AND. Empty( VALORMES2 )
            netrecdel()
         ENDIF
         dbSkip()
      ENDDO
   ENDIF
   RETU

// : FIM: FOD2.PRG

// + EOF: fod2.prg
// +
