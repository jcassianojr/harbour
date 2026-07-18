// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo1.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :        FO1.PRG: MENU PRINCIPAL COM PROMPT CADASTRO DA EMPRESA
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :  Procs & Fncts: FO1()
// :
// :*****************************************************************************

PRIV HELPDBF
HELPDBF := "FO1"
WHILE .T.
CABEX( "Menu Principal do Cadastro de Empresas." )
@  3, 2 SAY "Cadastro:" + SPAC( 30 ) + "Opera??es"
OPCAO( 5, 2, " 1 - Altera Empresa Atual        ", 49 )  // Passar Foltel folget
OPCAO( 6, 2, " 2 - Frotas                      ", 50 )
OPCAO( 7, 2, " 3 - VT - Operadoras             ", 51 )
OPCAO( 8, 2, " 4 - Listagem do Cadastro        ", 52 )
OPCAO( 9, 2, " 5 - Codigos CNAE Antigo         ", 53 )
OPCAO( 10, 2, " 6 - Codigos CNAE 2.0 novo       ", 54 )
OPCAO( 11, 2, " 7 - Codigos FPAS                ", 55 )
OPCAO( 12, 2, " 8 - Codigos SAT                 ", 56 )
OPCAO( 13, 2, " 9 - Tomadores de Servi?o        ", 57 )
OPCAO( 14, 2, " 0 - Codigos Cidades             ", 48 )
OPCAO( 5, 43, " A - Criar  Folha de Diretores    ", 65 )
OPCAO( 6, 43, " B - Apagar Folha de Diretores    ", 66 )
OPCAO( 8, 43, " C - Criar  Folha de Ponto        ", 67 )
OPCAO( 9, 43, " D - Apagar Folha de Ponto        ", 68 )
OPCAO( 11, 43, " E - Apagar Todos os Lan?amentos  ", 69 )
OPCAO( 12, 43, " F - Transferir Folha entre Firmas", 70 )
OPCAO( 14, 43, " G - Criar Folha Semanal          ", 71 )
OPCAO( 15, 43, " H - Apagar Folha Semanal         ", 72 )
OPCAO( 17, 43, " I - Criar Folha Vale Transporte  ", 73 )
OPCAO( 18, 43, " J - Apagar Folha Vale Transporte ", 74 )
OPCAO( 20, 43, " K - Criar Folha RPA              ", 75 )
OPCAO( 21, 43, " L - Apagar Folha RPA             ", 76 )
OPCAO( 22, 43, " M - Apagar/Temporarios/Indices   ", 77 )
KEY := MENU(, 0 )
DO CASE
CASE KEY = 1   // Cadastro Empresa foltel folget fo1t fo1g
CRIARVARS( "BCOFGTS" )
PADRAO( "FIRMA", "FIRMA", "' '+STR(mNRCLIEN,5)+' '+mRAZAO", "mNRCLIEN", "Cadastro de Empresas", "Codigo Nome", ;
            {|| ALERTX( "N’o Disponvivel neste modulo" ) }, {|| FO1T() }, {|| FO1G() }, {|| FO_FOR( "GRUPO='FIRMA'" ) },,,,, "E" )
CASE KEY = 2
PADRAO( "MG01", "MG01", "' '+STR(mNUMERO,8)+' '+mNOME+' '+mCOGNOME+' '+mDDD+' '+mTELEFONE", "mNUMERO", "Cadastro de Frotas", "N£mero  Nome" + spac( 38 ) + "Cognome" + spac( 6 ) + "DDD  Telefone", ;
            {|| PEGCHAVE( "mNUMERO", 0, "Numero Cadastramento" ) }, "MG0001", "MG0001", {|| FO_FOR( "GRUPO='MG01'" ) } )
CASE KEY = 3
PADRAO( "VTOPER", "VTOPER", "' '+STR(mNUMERO,5)+' '+mNOME", "mNUMERO", "Cadastro de Operadoras Transporte(VT)", "Codigo Nome", ;
            {|| PEGCHAVE( "mNUMERO", 0, "Codigo do Operador" ) }, "VTOPER", "VTOPER", {|| FO_FOR( "GRUPO='VTOPER'" ) } )

CASE KEY = 4   // Relatorios OK
FO_FOR( "GRUPO='FIRMA'" )
CASE KEY = 5
PADRAO( "FO_CNAE", "FO_CNAE", "' '+mCODIGO+' '+LEFT(mDESCRICAO,60)+' '+STR(mTAXA,3)", "mCODIGO", "Cadastro CNAE", "Codigo Nome", ;
            {|| PEGCHAVE( "mCODIGO", Space( 7 ), "Codigo CNAE" ) }, {|| MDS( "" ) }, "CNAE", {|| FO_FOR( "GRUPO='FO_CNAE'" ) } )
CASE KEY = 6
PADRAO( "FO_CNAE2", "FO_CNAE2", "' '+mCODIGO+' '+LEFT(mDESCRICAO,60)+' '+STR(mTAXA,3)", "mCODIGO", "Cadastro CNAE", "Codigo Nome", ;
            {|| PEGCHAVE( "mCODIGO", Space( 7 ), "Codigo CNAE" ) }, {|| MDS( "" ) }, "CNAE", {|| FO_FOR( "GRUPO='FO_CNAE'" ) } )
CASE KEY = 7   // Ok fpas
FO0G()
CASE KEY = 8   // sat foltel folget
FO1O()
CASE KEY = 9
PADRAO( "TOMADOR", "TOMADOR", "' '+STR(mNUMERO,5)+' '+mNOME", "mNUMERO", "Cadastro de Tomadores de Servico", "Codigo Nome", ;
            {|| PEGCHAVE( "mNUMERO", 0, "Codigo do Tomador" ) }, "TOMADO", "TOMADO", {|| FO_FOR( "GRUPO='TOMADOR'" ) } )
CASE KEY = 10    // Cidades Foltel Folget
FO1W()
CASE KEY = 11
FO1K()
CASE KEY = 12
FO1J()
CASE KEY = 13
FO1M()
CASE KEY = 14
FO1N()
CASE KEY = 15
FO1L()
CASE KEY = 16
FO1X()
CASE KEY = 17
FO1SC( "SS", "Semanal" )
CASE KEY = 18
FO1SA( "SS", "Semanal" )
CASE KEY = 19
FO1VC()
CASE KEY = 20
FO1VA()
CASE KEY = 21
IF FO1SC( "RP", "RPA" )
FO1SC( "RL", "RPA" )
// DIRCHANGE(ZDIRE)
hb_cwd( ZDIRE )
MAKEDBF( "..\AJUDIRA.DBE" )
MAKEDBF( "..\FO_IRA.DBE" )
MAKEDBF( "..\FO_RDA.DBE" )
hb_cwd( '..' )
// DIRCHANGE('..')
ENDIF
CASE KEY = 22
IF FO1SA( "RP", "RPA" )
FO1SA( "RL", "RPA" )
DELDBFNTX( "AJUDIRA" )
DELDBFNTX( "FO_IRA" )
DELDBFNTX( "FO_RDA" )
ENDIF
CASE KEY = 23
FO1P()
OTHERWISE
RETU
ENDCASE
ENDDO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO1SA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FO1SA( cSTR, cMES )

   CABEX( "Eliminar Folha: " + cMES )
   IF !MDG( 'Voc? tem certeza' )
      RETU .F.
   ENDIF
   IF !MDG( 'Voc? realmente tem certeza' )
      RETU .F.
   ENDIF
   FOR X := 1 TO 12
      DELDBFNTX( ZDIRE + cSTR + StrZero( X, 2 ) )
   NEXT X
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO1SC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO1SC( cSTR, cMES )

   CABEX( "Criar Folha: " + cMES )
   IF !MDG( 'Voc? tem certeza' )
      RETU .F.
   ENDIF
   DO CASE
   CASE cSTR = "SS"
      aSEMANA := { { "NUMERO", "N", 5, 0 }, { "CONTA", "N", 3, 0 }, { "SEMANA", "N", 1, 0 }, ;
         { "HORAS", "N", 7, 2 }, { "VALOR", "N", 12, 2 } }
   CASE cSTR = "RL"
      aSEMANA := { { "NUMERO", "N", 5, 0 }, { "CONTA", "N", 3, 0 }, { "LCTO", "N", 8, 0 }, ;
         { "HORAS", "N", 7, 2 }, { "VALOR", "N", 12, 2 }, { "SEMANA", "N", 1, 0 }, ;
         { "OBS", "C", 50, 2 }, { "DATA", "D", 8, 0 } }
   OTHERWISE
      aSEMANA := { { "NUMERO", "N", 5, 0 }, { "CONTA", "N", 3, 0 }, { "SEMANA", "N", 1, 0 }, ;
         { "HORAS", "N", 7, 2 }, { "VALOR", "N", 12, 2 } }
   ENDCASE
   FOR X := 1 TO 12
      dbCreate( ZDIRE + cSTR + StrZero( X, 2 ), aSEMANA )
   NEXT X
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO1VC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO1VC

   IF !MDG( 'Voce tem certeza' )
      RETU .F.
   ENDIF
   hb_cwd( ZDIRE )
// DIRCHANGE(ZDIRE)
   MAKEDBF( "..\VTFOLHA.DBE" )
   MAKEDBF( "..\VTFIXO.DBE" )
   MAKEDBF( "..\VTAVUL.DBE" )
   hb_cwd( '..' )
// DIRCHANGE('..')
   IF !hb_FileExists( "VTCOMP.DBF" )
      MAKEDBF( "VTCOMP" )
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO1VA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO1VA

   IF !MDG( 'Voc? tem certeza' )
      RETU
   ENDIF
   IF !MDG( 'Voc? realmente tem certeza' )
      RETU
   ENDIF
   FErase( ZDIRE + 'VTFOLHA.DBF' )
   FErase( ZDIRE + 'VTFIXO.DBF' )
   FErase( ZDIRE + 'VTAVUL.DBF' )
   RETU .F.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO1P()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO1P

   IF MDG( "Deseja Apagar Arquivos Temporarios" )
      hb_cwd( ZDIRE )
      // DIRCHANGE(ZDIRE)
      MATDIC := FILENAMES( "*.BAK" )
      nARQ   := Len( MATDIC )
      IF nARQ > 0
         FOR X := 1 TO nARQ
            ARQUIVO := AllTrim( MATDIC[ X ] )
            FErase( ARQUIVO )
         NEXT X
      ENDIF
      hb_cwd( '..' )
      // DIRCHANGE('..')
   ENDIF
   IF MDG( "Deseja Apagar Arquivos Indices" )
      hb_cwd( ZDIRE )
      // DIRCHANGE(ZDIRE)
      MATDIC := FILENAMES( "*." + cRDDEXT )
      nARQ   := Len( MATDIC )
      IF nARQ > 0
         FOR X := 1 TO nARQ
            ARQUIVO := AllTrim( MATDIC[ X ] )
            FErase( ARQUIVO )
         NEXT X
      ENDIF
      hb_cwd( '..' )
      // DIRCHANGE('..')
   ENDIF
   RETU .T.


// : FIM: FO1.PRG

// + EOF: fo1.prg
// +
