// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_1.prg menu relogios arquivos
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


function fopto_1()
HELPDBF := "FOPTO10"

WHILE .T.
CABE3( 'FOPTO_1 - Relogio', 23 )
OPCAO( 04, 01, "&A Copiar Arquivo          ", 65, " Faz copia do arquivo de Relogio/Ponto para a folha       " )   // 1
OPCAO( 05, 01, "&B Transferir Arquivo      ", 66, " Carrega dados do arquivo Relogio/Ponto/Migracao          " )   // 2    Utiliza arquivo de migracao append txt
OPCAO( 06, 01, "&C Transferir Ponto        ", 67, " Transfere os dados do Relogio/Ponto para o Folha/Ponto   " )   // 3
OPCAO( 07, 01, "&D Ver/Imp Arq Relogio     ", 68, " Permite visualizar e imprimir arquivo exportacao Relogio " )   // 4
OPCAO( 08, 01, "&E Ver Arquivo Migracao    ", 69, " Exibe arquivo do Ponto/Migracao                          " )   // 5
OPCAO( 09, 01, "&F Ver Arquivo Migrado     ", 70, " Exibe arquivo do Ponto/Migrado                           " )   // 6
OPCAO( 10, 01, "&G Imprimir Arq/Migracao   ", 71, " Imprimir arquivo do Ponto/Migracao                       " )   // 7
OPCAO( 11, 01, "&H Imprimir Arq/Migrado    ", 72, " Imprimir arquivo do Ponto/Migrado                        " )   // 8
OPCAO( 12, 01, "&I Copia Reserva Arq/Rel   ", 73, " Efetua Copia Reserva Arq/Relogio do mes                  " )   // 9
OPCAO( 13, 01, "&J Voltar Copia Reserva    ", 74, " Retorna Copia Reserva Arq/Relogio do mes                 " )   // 10
OPCAO( 14, 01, "&K Importacao Expressa     ", 75, " Importada os dados do relogio sem Perguntas              " )   // 11    Utiliza arquivo de migracao append txt
OPCAO( 15, 01, "&L Importar Direto Com Perg", 76, " Importa.txt e relogio junto                              " )   // 12
OPCAO( 16, 01, "&M Importar Direto Sem Perg", 77, " Importa.txt e relogio junto sem perguntas                " )   // 13
OPCAO( 17, 01, "&N TXT Gravar BKP Periodo  ", 78, " Faz uma copia do TXT do periodo Mes                      " )   // 14
OPCAO( 18, 01, "&O TXT Optimizar Periodo   ", 79, " Optimizar um periodo do TXT                              " )   // 15
OPCAO( 19, 01, "&P TXT Conversao Formatos  ", 80, " Conversao de formatos                                    " )   // 16
OPCAO( 04, 41, "&Q Modelos de Relogios     ", 81, " Cadastro de Modelos de relogios                          " )   // 17
OPCAO( 05, 41, "&R Configuracao Importacao ", 82, " Configurar Importacao                                    " )   // 18
OPCAO( 06, 41, "&S Equipamentos            ", 83, " Configurar Equipamentos                                  " )   // 19
OPCAO( 07, 41, "&T Motivos Passagens AFDT  ", 84, " Motivos Passagens AFDT                                   " )   // 20
OPCAO( 08, 41, "&U Imp.Catraca WREL Portari", 85, " Importar Catracas WREL Portaria/Acesso                   " )   // 21
OPCAO( 09, 41, "&V Imp.Catraca WREL Refeito", 86, " Importar Catracas WREL Refeicao                          " )   // 22
OPCAO( 10, 41, "&W Gerar carga.txt rep     ", 88, " Gerar carga.txt rep                                      " )   // 23
OPCAO( 11, 41, "&X Sincronizar Catraca     ", 88, " Sincronizar Catraca                                      " )   // 24
OPCAO( 12, 41, "&Y Gerar AFD               ", 88, " Gerar AFD                                                " )   // 25
OPCAO( 13, 41, "&Z Importar AFD REP        ", 88, " Importar AFD Relogio                                     " )   // 26
OPCAO := menu(, 24 )
IF ZUSER <> "SUPERVISOR" .AND. ZUSER <> "SOFTEC" .AND. OPCAO > 0
IF !VERSEHA( "MUSERM",, USERMCRI( ZUSER, "A", OPCAO ) )
ALERTX( "Voce nao tem acesso, Verifique com o Supervisor" )
LOOP
ENDIF
ENDIF
IF ZFECHADO = "S"
IF OPCAO = 1 .OR. OPCAO = 2 .OR. OPCAO = 3 .OR. OPCAO = 11 .OR. OPCAO = 12 .OR. OPCAO = 13
ALERTX( "Mes ja Fechado" )
LOOP
ENDIF
ENDIF
DO CASE
CASE OPCAO = 1
FOPTO_14( .T. )   // A
CASE OPCAO = 2
FOPTO_11( 0 )   // B
CASE OPCAO = 3
FOPTO_12()  // C
CASE OPCAO = 4
FOPTO_13()  // D
CASE OPCAO = 5
FOPTO_16()  // E
CASE OPCAO = 6
FOPTO_16( "D" )   // F
CASE OPCAO = 7   // G
FOPTO_3E()
CASE OPCAO = 8   // H
FOPTO_3E( "D" )
CASE OPCAO = 9   // i
FOPTO_17()
CASE OPCAO = 10  // j
FOPTO_18()
CASE OPCAO = 11  // k
FOPTO_14( .F. )
CASE OPCAO = 12  // l
FOPTO_19( .T. )
CASE OPCAO = 13  // m
FOPTO_19( .F. )
CASE OPCAO = 14  // n
FOPTO_19( .F., "B" )
CASE OPCAO = 15  // o
FOPTO_19( .F., "A" )
CASE OPCAO = 16  // p
FOPTO_19( .F., "C" )
CASE OPCAO = 17  // Q
PADRAO( "RELOGIOS", "RELOGIOS", "' '+STR(mNUMERO,8)+' '+mNOME", "mNUMERO", "Cadastro de Modelos Relogios", "Cod.  Nome", ;
            {|| PEGCHAVE( "mNUMERO", ULTIMOREG( "RELOGIOS", "NUMERO", .T. ), "Codigo:" ) }, "RELOGM", "RELOGM", {|| FO_FOR( "GRUPO='RELOG'" ) }, ;
            ,,,, "X" )
CASE OPCAO = 18  // R
PADRAO( "FOPTOREL", "FOPTOREL", "' '+STR(mNUMERO,8)+' '+mNOME", "mNUMERO", "Configuracao de Importacao", "Cod.  Nome", ;
            {|| PEGCHAVE( "mNUMERO", ULTIMOREG( "FOPTOREL", "NUMERO", .T. ), "Codigo:" ) }, "PTOREL", "PTOREL", {|| FO_FOR( "GRUPO='RELOG'" ) }, ;
            ,,,, "X" )
CASE OPCAO = 19  // S
PADRAO( "FOPTOEQP", "FOPTOEQP", "' '+STR(mNUMERO,8)+' '+mNOME", "mNUMERO", "Configuracao de Equipametos", "Cod.  Nome", ;
            {|| PEGCHAVE( "mNUMERO", ULTIMOREG( "FOPTOEQP", "NUMERO", .T. ), "Codigo:" ) }, "PTOEQP", "PTOEQP", {|| FO_FOR( "GRUPO='RELOG'" ) }, ;
            ,,,, "X" )
CASE OPCAO = 20  // T
PADRAO( "AFDTERR", "AFDTERR", "' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mHORA,5,2)+' '+mMOTOCO", "STR(mNUMERO,8)+DTOS(mDATA)+STR(mHORA,5,2)", "Motivos AFDT", "Numero Data Hora Motivo", ;
            {|| iAFDTERR() }, "AFDTER", "AFDTER", {|| FO_FOR( "GRUPO='AFD'" ) }, ;
            ,,,, "X" )
CASE OPCAO = 21  // U importar wrel portaria acesso
FOPTO_15( 1 )
CASE OPCAO = 22  // V importar wrel refeitorio
FOPTO_15( 2 )
CASE opcao = 23  // w gerar carga.txt
fopto_rep()
CASE opcao = 24  // X
lDEMITDOSEXP := MDG( "Exportar demitidos" )
cCAMPOEXP    := "CHAPA"
IF MDG( "Usar Campo Chapa" )
IF MDG( "Usar campo Numero" )
cCAMPOEXP := "NUMERO"
ENDIF
ENDIF
IF lDEMITDOSEXP
fopto_cat( cCAMPOEXP )
ELSE
fopto_cat( "if(empty(demitido)," + cCAMPOEXP + ",0)" )
ENDIF
IF MDG( "Gravar Data Demissao" )
fopto_cat( "0", cCAMPOEXP )
ENDIF
CASE opcao = 25  // Y
geraafd( .T. )
CASE opcao = 26  // z
fopto_19( .F., "R" )
OTHERWISE
RETU
ENDCASE
ENDDO
return


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iAFDTERR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION iAFDTERR

   @ 24, 00 SAY "Numero"
   @ 24, 20 SAY "Data"
   @ 24, 40 SAY "HORA"
   @ 24, 10 GET mNUMERO
   @ 24, 30 GET mDATA
   @ 24, 40 GET mHORA
   READCUR()
   mCHAVE := Str( mNUMero, 8 ) + DToS( mDATA ) + Str( mHORA, 5, 2 )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gAFDTERR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gAFDTERR

   IF Empty( mMOTOCO )
      RETU .T.
   ENDIF
   IF NETUSE( "PD" + ANOMESW )
      IF dbSeek( mCHAVE )
         netreclock()
         field->numero := mNUMERO
         field->DATA   := mDATA
         field->hora   := mHORA
         field->TIPOM  := "D"
      ENDIF
      dbCloseArea()
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto_rep()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fopto_rep()

   SET CENTURY ON
   IF !netuse( "fo_pes" )
      RETURN
   ENDIF
   IF !netuse( "funcao" )
      dbCloseAll()
      RETURN
   ENDIF
   Nuso := FCreate( 'carga' + StrZero( nremp, 3 ) + '.txt' )
   dbSelectAr( "fo_pes" )
   dbGoTop()
   WHILE !Eof()
      petela( 8 )
      mNUMERO := NUMERO
      mNOME   := NOME
      mFUNCAO := FUNCAO
      cFUNCAO := OBTER( "FUNCAO",, FUNCAO, "NOME" )
      dbSelectAr( "fo_pes" )
      IF Empty( demitido ) .AND. !Empty( pis )
         FWrite( nUSO, StrZero( mNUMERO, 20 ) )
         FWrite( nUSO, Left( pis, 11 ) )
         FWrite( nUSO, "000000" )
         FWrite( nUSO, StrTran( DToC( ADMITIDO ), "/", "" ) )
         FWrite( nUSO, PadR( mNOME, 52 ) )
         FWrite( nUSO, PadR( cfuncao, 30 ) )
         FWrite( nUSO, Chr( 13 ) + Chr( 10 ) )
      ENDIF
      dbSelectAr( "fo_pes" )
      dbSkip()
   ENDDO
   dbCloseAll()
   FClose( nUSO )

   RETURN .T.



// + EOF: fopto_1.prg
// +
