// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_6.prg  Banco de Horas
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +




// Teclas Operacionais
#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"

FUNCTION fopto_6()

   IF ZFECHADO = "S"
      ALERTX( "Mes ja Fechado" )
   ENDIF

   WHILE .T.
      CABE3( ' FOPTO_6 - Banco de Horas' + if( lSeCBCO, "Anterior", "Atual" ), 23 )
      OPCAO( 04, 01, " &A - Consultar                   ", 65, " Consultar Banco de Horas                      " )
      OPCAO( 05, 01, " &B - Apagar   Competencia        ", 66, " Apaga Uma Competencia Banco de Horas          " )
      OPCAO( 06, 01, " &C - Arquivar Demitidos          ", 67, " Arquiva Banco Horas Demitidos                 " )
      OPCAO( 07, 01, " &D - Arquivar Um ano             ", 68, " Arquiva Um Ano Banco de Hora                  " )
      OPCAO( 08, 01, " &E - Arquivar Competencia MesAno ", 69, " Arquiva uma competencia mes/ano               " )
      OPCAO( 09, 01, " &F - Arquivar Um Funcionario     ", 70, " Arquiva Um Funcionario Banco de Hora          " )
      OPCAO( 10, 01, " &G - Consulta Banco Hrs Arquivado", 71, " Consultar Banco de Horas Arquivado            " )
      OPCAO( 11, 01, " &H - Retornar Demitidos          ", 72, " Retorna Banco Horas Demitidos                 " )
      OPCAO( 12, 01, " &I - Retornar Um ano             ", 73, " Retorna Um Ano Banco de Hora                  " )
      OPCAO( 13, 01, " &J - Retornar Competencia MesAno ", 74, " Retorna uma competencia mes/ano               " )
      OPCAO( 14, 01, " &K - Retornar Um Funcionario     ", 75, " Retorna Um Funcionario Banco de Hora          " )
      OPCAO( 15, 01, " &L - Importar Saldo Ponto/BcoHrs ", 76, " Transferei saldo horas Ponto para Banco Horas " )
      OPCAO( 16, 01, " &M - Zerar Saldo Horas Competenc ", 77, " Zera os Valores das Horas de uma Competencia  " )
      OPCAO( 17, 01, " &N - Zerar Saldo Dias  Competenc ", 78, " Zera os Valores de dia De  uma Competencia    " )
      OPCAO( 04, 41, " &1 - Requisicoes Banco Horas     ", 49, " Requisicoes Banco Horas                       " )
      OPCAO( 05, 41, " &2 - Multiplas Requisicao Bco Hrs", 50, " Multiplos Lancamentos Requisicoes Banco Horas " )
      OPCAO( 06, 41, " &3 - Exportar saldo arquivo txt  ", 51, "                                               " )
      OPCAO( 07, 41, " &4 - Exportar saldo folha        ", 52, "                                               " )
      OPCAO( 08, 41, " &5 - Troca Atual por Anterior    ", 53, "                                               " )
      OPCAO := menu( 1, 24 )
      IF ZUSER <> "SUPERVISOR" .AND. ZUSER <> "SOFTEC" .AND. OPCAO > 0
         IF !VERSEHA( "MUSERM",, USERMCRI( ZUSER, "F", OPCAO ) )
            ALERTX( "Voce nAo tem acesso, Verifique com o Supervisor" )
            LOOP
         ENDIF
      ENDIF
      IF ZFECHADO = "S"
         IF OPCAO = 16 .OR. OPCAO = 2 .OR. OPCAO = 12 .OR. OPCAO = 13 .OR. OPCAO = 14
            ALERTX( "Mes ja Fechado" )
            LOOP
         ENDIF
      ENDIF

      DO CASE
      CASE OPCAO = 1   // A Consulta Atual
         FOPTO_4R( 1 )
      CASE OPCAO = 2   // B Apaga Competencia
         FOPTO4Q02()
      CASE OPCAO = 3   // C Arquiva Demitido
         fopto4u( 1, 1 )
      CASE OPCAO = 4   // D Arquiva Ano
         fopto4u( 2, 1 )
      CASE OPCAO = 5   // E Arquiva Mes Ano
         fopto4u( 3, 1 )
      CASE OPCAO = 6   // F Arquiva Funcionario
         fopto4u( 4, 1 )
      CASE OPCAO = 7   // G Consulta Baixados
         FOPTO_4R( 2 )
      CASE OPCAO = 8   // H Retorna Demitidos
         fopto4u( 1, 2 )
      CASE OPCAO = 9   // I Retorna Ano
         fopto4u( 2, 2 )
      CASE OPCAO = 10  // J Retorna mes ano
         fopto4u( 3, 2 )
      CASE OPCAO = 11  // K Retorna funcionario
         fopto4u( 4, 2 )
      CASE OPCAO = 12  // L Importar Saldo Ponto/BcoHrs
         FOPTO_4S()
      CASE OPCAO = 13  // M zera horas
         fopto4u( 5, 1 )
      CASE OPCAO = 14  // N zera dias
         fopto4u( 6, 1 )
      CASE OPCAO = 15  // 1 requisicao banco de horas
         FOPTO_4Q()
      CASE OPCAO = 16  // 2 - Multiplos Banco Horas
         FOPTO_4K()
      CASE OPCAO = 17  // 3
         FOPTO_25( 5 )   // Saldo Banco Horas->arquivo.txt
      CASE OPCAO = 18  // 4
         FOPTO_25( 6 )   // Saldo Banco Horas->folha
      CASE opcao = 19  // 5
         IF !lSeCBCO
            lSECBCO := .T.   // Controle de Banco de Horas Anterior
            ALERTX( "Controle Banco Horas Anterior-Ativado" )
         ELSE
            lSECBCO := .F.
            ALERTX( "Controle Banco Horas Anterior-Desativado" )
         ENDIF
      OTHERWISE
         RETU
      ENDCASE
   ENDDO

   RETURN



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto4u()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto4u( nTIPO, nOPR )

   PCK := .T.
   IF nOPR = 3 .OR. nOPR = 4
      CABE3( ' í Manutencao Provisorios', 23 )
   ELSE
      CABE3( ' í Manutencao Banco de Horas', 23 )
   ENDIF
   IF nTIPO = 1
      IF !netuse( pes )
         RETU .F.
      ENDIF
   ENDIF
   IF nTIPO = 2 .OR. nTIPO = 3 .OR. nTIPO = 5 .OR. nTIPO = 6
      nANO := Year( Date() )
      nMES := Month( Date() )
      @ 24, 00 SAY "ANO"
      @ 24, 10 GET nANO
      IF nTIPO = 3 .OR. nTIPO = 5 .OR. nTIPO = 6
         @ 24, 20 SAY "Mes"
         @ 24, 30 GET nMES
      ENDIF
      IF !READCUR()
         RETU .F.
      ENDIF
   ENDIF
   IF nTIPO = 4
      nNUMERO := 0
      SET KEY K_F11 TO TECLAF11
      @ 24, 00 SAY "Numero Funcionario"
      @ 24, 30 GET nNUMERO
      IF !READCUR()
         SET KEY K_F11
         RETU .F.
      ENDIF
      SET KEY K_F11
   ENDIF

   cARQ   := "XXXX"
   cARQBX := "XXXX"
   IF nOPR = 1   // Atuais->Arquivados
      carq   := IF( lSECBCO, "BCOBAK", "BCOHRS" )
      carqbx := IF( lSECBCO, "BCODEK", "BCODEM" )
   ENDIF
   IF nOPR = 2   // Arquivados->Atuais
      carq   := IF( lSECBCO, "BCODEK", "BCODEM" )
      carqbx := IF( lSECBCO, "BCOBAK", "BCOHRS" )
   ENDIF
   IF nOPR = 3   // Provisorios //Atuais->Arquivados
      carq   := "FOPTOPRO"
      carqbx := "FOPTOPRD"
   ENDIF
   IF nOPR = 4   // Provisorios //Arquivados->Atuais
      carq   := "FOPTOPRD"
      carqbx := "FOPTOPRO"
   ENDIF



   IF !netuse( CArq )
      dbCloseAll()
      RETU .F.
   ENDIF
   INITVARS()
   CLRVARS()

   IF !netuse( carqbx )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF nTIPO = 1
      dbSelectAr( PES )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbGoTop()
      WHILE !Eof()
         PETELA( 8 )
         IF !Empty( DEMITIDO )
            PETELA( 14 )
            mNUMERO := NUMERO
            mDATA   := DEMITIDO
            mDATA++
            dbSelectAr( Carq )
            dbGoTop()
            dbSeek( Str( mNUMERO, 8 ) )
            WHILE mNUMERO = if( nopr < 3, NUMERO, DESTINO ) .AND. !Eof()
               fopto4ugrv()
               // zei_fort()
               dbSelectAr( Carq )
               dbSkip()
            ENDDO
         ENDIF
         dbSelectAr( PES )
         zei_fort( nLASTREC,,, 1 )
         dbSkip()
      ENDDO
      dbCloseAll()
      netpack( cARQ )
   ENDIF
   IF nTIPO = 2 .OR. nTIPO = 3 .OR. nTIPO = 5 .OR. nTIPO = 6
      dbSelectAr( Carq )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbGoTop()
      WHILE !Eof()
         IF nopr > 2
            ANO := Year( DATA )
            MES := Month( DATA )
         ENDIF
         IF ANO = nANO .AND. IF( nTIPO = 2, .T., MES = nMES )
            DO CASE
            CASE nTIPO = 5
               netreclock()
               FIELD->SALANT  := 0
               FIELD->CREDITO := 0
               FIELD->DEBITO  := 0
               FIELD->SALDO   := 0
               dbUnlock()
            CASE nTIPO = 6
               netreclock()
               FIELD->DIAANT := 0
               FIELD->DIACRE := 0
               FIELD->DIADEB := 0
               FIELD->DIASAL := 0
               dbUnlock()
            OTHERWISE
               fopto4ugrv()
            ENDCASE
         ENDIF
         dbSelectAr( Carq )  // sele 2
         dbSkip()
         zei_fort( nLASTREC,,, 1 )
         // zei_fort()
      ENDDO
      dbCloseAll()
      netpack( carq )
   ENDIF
   IF nTIPO = 4
      dbSelectAr( Carq )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbGoTop()
      WHILE !Eof()
         IF if( nopr < 3, NUMERO, DESTINO ) = nNUMERO
            fopto4ugrv()
         ENDIF
         dbSelectAr( Carq )
         dbSkip()
         zei_fort( nLASTREC,,, 1 )
         // zei_fort()
      ENDDO
      dbCloseAll()
      netpack( carq )
   ENDIF



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto4ugrv()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION fopto4ugrv

   EQUVARS()
   dbSelectAr( Carqbx )
   netrecapp()
   REPLVARS( .F. )
   dbSelectAr( Carq )
   netrecdel()

   RETURN .T.




// + EOF: fopto_6.prg
// +
