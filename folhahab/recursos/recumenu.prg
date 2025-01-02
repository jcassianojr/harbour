// +--------------------------------------------------------------------
// +
// +    Programa  : recumenu.prg Menu Principal Recurso
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 2-Jan-2025 as  7:33 pm
// +
// +--------------------------------------------------------------------
// +


#include "BOX.CH"

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RECUMENU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION RECUMENU()

   PUBLIC DADO
   memvar->DXDIA := Date()

   Set( _SET_MESSAGE, 6, .T. )
   WHILE .T.
      SetColor( "+W/BR, N/W" )
      @ 00, 00 CLEA
      hb_DispBox( 0, 0, 07, 79, B_DOUBLE + " " )
      SetColor( "W/R" )
      hb_DispBox( 8, 21, 10, 58, B_DOUBLE + " " )
      SetColor( "W/N" )
      @ 13, 01 CLEA TO 19, 77
      @ 09, 27 SAY "M E N U   P R I N C I P A L"
      hb_DispBox( 12, 1, 20, 78, B_DOUBLE + " " )
      @ 13, 05 SAY StrTran( "######   #######    #####  ##  ##   ######    ####     #####    ####", "#", Chr( 254 ) )
      @ 14, 05 SAY StrTran( " ##  ##   ##   #   ##  ##  ##  ##    ##  ##  ##  ##   ##   ##  ##  ##", "#", Chr( 254 ) )
      @ 15, 05 SAY StrTran( " ##  ##   ##      ##       ##  ##    ##  ##  ##       ##   ##  ##", "#", Chr( 254 ) )
      @ 16, 05 SAY StrTran( " #####    ####    ##       ##  ##    #####    ####    ##   ##   ####", "#", Chr( 254 ) )
      @ 17, 05 SAY StrTran( " ####     ##      ##       ##  ##    ####        ##   ##   ##      ##", "#", Chr( 254 ) )
      @ 18, 05 SAY StrTran( " ##  ##   ##   #   ##  ##  ##  ##    ##  ##  ##  ##   ##   ##  ##  ##", "#", Chr( 254 ) )
      @ 19, 05 SAY StrTran( "###  ##  #######    ####    ####    ###  ##   ####     #####    #### ", "#", Chr( 254 ) )
      SetColor( "+W/BR, N/W" )
      OPCAO( 02, 04, " Gerador de &Etiquetas  ", 69, "  Etiquetas simples e configuradas.   " )
      OPCAO( 03, 04, " Editor  de &Cartas     ", 67, "  Cria, Altera, Imprime Cartas.       " )
      OPCAO( 04, 04, " Calculos de &Datas     ", 68, "  Cria, Altera, Imprime Cartas.       " )
      OPCAO( 02, 30, " &Indexar os arquivos    ", 73, "  Organiza os arquivos de trabalho   " )
      OPCAO( 03, 30, " Con&Figuracao Indexacao ", 70, "  Altera configuracao de organizacao " )
      // OPCAO( 04,04 , "   &Geradores  "    ,71,"  Etiquetas, Cartas, Dbf editor, Formul rios                      ")
      // OPCAO( 04,21 , "     &Apoio    "    ,65,"  Arquivos, Utilit rios, Telememo, Agenda, Bloco de Anota‡”es     ")
      // OPCAO( 04,37 , " &Servicos gerais  ",83, "              Diversos - Apuracoes - Configuracoes                ")
      // OPCAO( 04,58 , " &Encerrar "        ,69, "                Encerra as atividades no sistema                  ")
      memvar->OPCAO := MENU(, 6 )
      SetColor( "+W/BR" )
      DO CASE
      CASE memvar->OPCAO = 1   // RECUGER()
         rECUGER1()
      CASE memvar->OPCAO = 2   // RECUAPO()
         rECUGER2()
      CASE memvar->OPCAO = 3   // RECUSER()
         recuapo2()
      CASE memvar->OPCAO = 4
         FOY2( 0, "RECURNTX" )
      CASE memvar->OPCAO = 5
         FOY2( 1, "RECURNTX" )
      OTHERWISE
         IF MDG( 'Deseja Realmente Sair do Programa' )
            FIM( '' )
         ENDIF
      ENDCASE
   ENDDO

   RETURN .T.


// + EOF: recumenu.prg
// +
