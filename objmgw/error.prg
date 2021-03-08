#include "error.ch"
#INCLUDE "COMMON.CH"
*------------------------------------------------------------------------------*
PROCEDURE ErrorSys
*------------------------------------------------------------------------------*

	ErrorBlock( { | oError | DefError( oError ) } )


RETURN

STATIC FUNCTION DefError( oError )
   LOCAL cMessage
   LOCAL cDOSError
   LOCAL nSEVERITY
   LOCAL n
   Local Ai

   //Html Arch to ErrorLog
   LOCAL HtmArch, xText

   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV
      RETURN 0
   ENDIF

   // Set NetErr() of there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
      (oError:osCode == 32 .or. oERROR:osCode == 5 ).AND. ; //jorge .or. e:osCode == 5
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   HtmArch := Html_ErrorLog()
   
    // start error message
   cMESSAGE:=""
   nSEVERITY:=oERROR:severity
   DO CASE       
       CASE nSEVERITY=ES_WHOCARES      //  0
            cMessage +="Erro   "
       CASE nSEVERITY=ES_WARNING         //1
            cMessage +="Atencao"
       CASE nSEVERITY=ES_ERROR          // 2 
            cMessage +="Erro   "
       CASE nSEVERITY=ES_CATASTROPHIC    //3
            cMessage +="Critico"
   ENDCASE
      

   // add subsystem name if available
   IF ISCHARACTER( oError:subsystem )
      cMessage += oError:subsystem()
   ELSE
      //cMessage += "???"
   ENDIF

   // add subsystem's error code if available
   IF ISNUMBER( oError:subCode )
      cMessage += "/" + LTrim( Str( oError:subCode ) )
   ELSE
      //cMessage += "/???"
   ENDIF

   // add error description if available
   IF ISCHARACTER( oError:description )
      cMessage += "  " + oError:description
   ENDIF

   //ALERTX(cMESSAGE)

   // add either filename or operation
   
   if ! Empty( oError:filename )
      cMessage += "Arquivo: " + oError:filename  + chr(13)+chr(10)
   endif   
   if !Empty( oError:operation )
      cMessage += "Operacao: " + oError:operation+ chr(13)+chr(10)
   endif      
   IF ISNUMBER( oError:gencode )
      cMessage += "Class/Desc" + LTrim( Str( oError:gencode ) )+ chr(13)+chr(10)
   ENDIF
   if ISARRAY( oERROR:args )
      cMessage += "Argumentos: " + strval( oERROR:args)+ chr(13)+chr(10)
   ENDIF

   
   
   IF ! Empty( oError:osCode )
      cMessage += " " +  "(DOS Error " + LTrim( Str( oError:osCode ) ) + ")" + " " + ;
              ps_os_err( oERROR:oscode() ) + chr(13)+chr(10)
   ENDIF

  if !empty( alias() )
     cMESSAGE += 'Alias           '+ strval( alias())   + chr(13)+chr(10)
     cMESSAGE += 'Area de Trabalho'+ strval( Select())  + chr(13)+chr(10)
     cMESSAGE += 'Registro Atual   '+strval( Recno(),8) + chr(13)+chr(10)
     IF ! EMPTY(DBFILTER())
        cMESSAGE += 'Filtro Atual'+DbFilter()+ chr(13)+chr(10)
     ENDIF
     IF ! EMPTY(DBRELATION())
        cMESSAGE += 'Relacionamento'+DbRelation()+ chr(13)+chr(10)
     ENDIF
     IF ! EMPTY(INDEXORD())
        cMESSAGE += 'Ordem do Indice'+strval(IndexOrd(),8)+ chr(13)+chr(10)
        cMESSAGE += 'Chave do Indice'+IndexKey(IndexOrd())+ chr(13)+chr(10)
     ENDIF
  endif
   
   
   

   // "Quit" selected
   Html_LineText(HtmArch, '<p class="updated">Date:' + Dtoc(Date()) + "  " + "Time: " + Time() )
   Html_LineText(HtmArch, cMessage + "</p>" )
   n := 2
   ai = cmessage + chr(13) + chr (10) + chr(13) + chr (10)
   WHILE ! Empty( ProcName( n ) )
      xText := "Chamado Por: " + ProcName( n ) + "(" + AllTrim( Str( ProcLine( n++ ) ) ) + ")" +CHR(13) +CHR(10)
      ai = ai + xText
      Html_LineText(HtmArch,xText)
   ENDDO
   Html_Line(HtmArch)

   ShowError(ai)       //chama sub-funcao evitar travar no ALERTX

   QUIT

   RETURN .F.


*******************************************
Function ShowError ( ErrorMesssage )
********************************************

	ALERTX ( ErrorMesssage , 'Programa Erro' )

Return Nil


*------------------------------------------------------------------------------
*-01-01-2003
*-AUTHOR: Antonio Novo
*-Create/Open the ErrorLog.Htm file
*-Note: Is used in: errorsys.prg and h_error.prg
*------------------------------------------------------------------------------
FUNCTION HTML_ERRORLOG
*---------------------
    Local HtmArch := 0
    If .Not. file(hb_cwd()+"ErrorLog.Htm")
        HtmArch := HtmL_Ini(hb_cwd()+"ErrorLog.Htm","Harbour Errorlog File")
        Html_Line(HtmArch)
    Else
        HtmArch := FOPEN(hb_cwd()+"ErrorLog.Htm",2)
        FSeek(HtmArch,0,2)    //End Of File
    EndIf
RETURN (HtmArch)

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTML Page Head
*------------------------------------------------------------------------------
FUNCTION HTML_INI(ARCH,TIT)
*-------------------------
    LOCAL HTMARCH
    LOCAL cStilo:= "<style> "                       +;
                     "body{ "                       +;
                       "font-family: sans-serif;"   +;
                       "background-color: #ffffff;" +;
                       "font-size: 75%;"            +;
                       "color: #000000;"            +;
                       "}"                          +;
                     "h1{"                          +;
                       "font-family: sans-serif;"   +;
                       "font-size: 150%;"           +;
                       "color: #0000cc;"            +;
                       "font-weight: bold;"         +;
                       "background-color: #f0f0f0;" +;
                       "}"                          +;
                     ".updated{"                    +;
                       "font-family: sans-serif;"   +;
                       "color: #cc0000;"            +;
                       "font-size: 110%;"           +;
                       "}"                          +;
                     ".normaltext{"                 +;
                      "font-family: sans-serif;"    +;
                      "font-size: 100%;"            +;
                      "color: #000000;"             +;
                      "font-weight: normal;"        +;
                      "text-transform: none;"       +;
                      "text-decoration: none;"      +;
                    "}"                             +;
                    "</style>"

    HTMARCH := FCREATE(ARCH)
    FWRITE(HTMARCH,"<HTML><HEAD><TITLE>"+TIT+"</TITLE></HEAD>" + cStilo +"<BODY>"+CHR(13)+CHR(10))
    FWRITE(HTMARCH,'<H1 Align=Center>'+TIT+'</H1><BR>'+CHR(13)+CHR(10))
RETURN (HTMARCH)

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTM Page Line
*------------------------------------------------------------------------------
FUNCTION HTML_LINETEXT(HTMARCH,LINEA)
*-----------------------------------
 //   LOCAL XLINEA
 //   XLINEA := RTRIM(LINEA)
    FWRITE(HTMARCH, RTRIM( LINEA ) + "<BR>"+CHR(13)+CHR(10))
RETURN (.T.)

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTM Line
*------------------------------------------------------------------------------
FUNCTION HTML_LINE(HTMARCH)
*-------------------------
    FWRITE(HTMARCH,"<HR>"+CHR(13)+CHR(10))
RETURN (.T.)


*+¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
*+
*+    Function PS_OS_ERR()
*+
*+    Called from ( errorsys.prg )   1 - static function deferror()
*+
*+¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
*+
function PS_OS_ERR( Arg1 )

do case
	case Arg1 == 1
	   return "Numero Invalido da Funcao"
	case Arg1 == 2
	   return "Arquivo nao Encontrado"
	case Arg1 == 3
	   return "Caminho nao Encontrado"
	case Arg1 == 4
	   return "Muitos Arquivos Abertos"
	case Arg1 == 5
	   return "Acesso Negado"
	case Arg1 == 6
	   return "Referencia Arquivo Invalido"
	case Arg1 == 7
	   return "Blocos Memorias Destruidos"
	case Arg1 == 8
	   return "Memoria Insuficiente"
	case Arg1 == 9
	   return "Erro de Memoria Invalido"
	case Arg1 == 10
	   return "Ambiente Invalido"
	case Arg1 == 11
	   return "Formato Invalido"
	case Arg1 == 12
	   return "Acesso de Codigo Invalido"
	case Arg1 == 13
	   return "Data Invalida"
	case Arg1 == 14
	   return "Reservado"
	case Arg1 == 15
	   return "Drive Invalido"
	case Arg1 == 16
	   return "Tentando Remover diretorio Atual"
	case Arg1 == 17
	   return "Nao e o mesmo Dispositivo"
	case Arg1 == 18
	   return "Sem mais Arquivos"
	case Arg1 == 19
	   return "Tentanod Escrever disquete-Travada"
	case Arg1 == 20
	   return "Unidade Desconhecido"
	case Arg1 == 21
	   return "Unidade nao Preparada"
	case Arg1 == 22
	   return "Comando Desconhecido"
	case Arg1 == 23
	   return "Data erro (CRC)"
	case Arg1 == 24
	   return "Erro no Tamanho Estrutura"
	case Arg1 == 25
	   return "Erro de Busca"
	case Arg1 == 26
	   return "Media Desconhecido"
	case Arg1 == 27
	   return "Setor nao Encontrado"
	case Arg1 == 28
	   return "Impressora sem Papel"
	case Arg1 == 29
	   return "Erro de Escrita"
	case Arg1 == 30
	   return "Erro de Leitura"
	case Arg1 == 31
	   return "Falha Geral"
	case Arg1 == 32
	   return "Violacao de Compartilhamento"
	case Arg1 == 33
	   return "Violacao de Travamento"
	case Arg1 == 34
	   return "Mudanca de Disco Errada"
	case Arg1 == 35
	   return "FCB nao disponivel"
	case Arg1 == 36
	   return "Estouro do buffer de compartilhamento"
	case Arg1 >= 37 .and. Arg1 <= 49
	   return "Reservado"
	case Arg1 == 50
	   return "Requisicao a Rede Nao Suportada"
	case Arg1 == 51
	   return "Computador Remoto nao respondendo"
	case Arg1 == 52
	   return "Nome Duplicado na Rede"
	case Arg1 == 53
	   return "Nao Encontrado nome na Rede"
	case Arg1 == 54
	   return "Rede Ocupada"
	case Arg1 == 55
	   return "Dispositivo da rede nao mais disponivel"
	case Arg1 == 56
	   return "Comando da Rede BIOS execedeu limite"
	case Arg1 == 57
	   return "Erro no Adaptador da Rede"
	case Arg1 == 58
	   return "Resposta Incorreta da Rede"
	case Arg1 == 59
	   return "Erro Inesperado na Rede"
	case Arg1 == 60
	   return "Adaptador Remotor Imcompativel"
	case Arg1 == 61
	   return "File Impressora Cheia"
	case Arg1 == 62
	   return "Sem espaco para imprimir o arquivo"
	case Arg1 == 63
	   return "Arquivo Impressora deletado (sem espaco suficiente)"
	case Arg1 == 64
	   return "Nome da Rede deletedo"
	case Arg1 == 65
	   return "Acesso Negado"
	case Arg1 == 66
	   return "Dispositivo da Rede Incorreto"
	case Arg1 == 67
	   return "Nao encontrado nome da Rede"
	case Arg1 == 68
	   return "Nome da Rede excede Limites"
	case Arg1 == 69
	   return "Sessao da rede BIOS excedeu"
	case Arg1 == 70
	   return "Pausa Temporaria"
	case Arg1 == 71
	   return "Requisicao a Rede nao aceita"
	case Arg1 == 72
	   return "Impressao ou Disco redirecao "
	case Arg1 >= 73 .and. Arg1 <= 79
	   return "Reservado"
	case Arg1 == 80
	   return "Arquivo ja Existente"
	case Arg1 == 81
	   return "Reservado"
	case Arg1 == 82
	   return "Nao pode ser criada entrada do diretorio"
	case Arg1 == 83
	   return "Falha na INT 24H"
	case Arg1 == 84
	   return "Muitas redicionamentos"
	case Arg1 == 85
	   return "Redicionamento"
	case Arg1 == 86
	   return "Senha Invalida"
	case Arg1 == 87
	   return "Parametro Invalido"
	case Arg1 == 88
	   return "Falha no Dispositivo da Rede" 
	case   arg1 == 89
		return"NENHUM ERRO OCORRIDO!"
	case  arg1 == 90
	   return "erro de sistema."
	case  arg1 == 91
		   return "Temporizador da tabela do serviço de transbordo."
	case  arg1 == 92 
		   return "Temporizador serviço tabela duplicar."
	case  arg1 == 93 
		   return "Nenhum item para trabalhar."
	case  arg1 == 95 
		   return "chamada de sistema interrompida."
	case  arg1 == 99
		   return "Dispositivo em uso."
	case  arg1 ==100
		   return "usuário / sistema de limite de abertura do semáforo atingido."
	case  arg1 ==101
		   return "Exclusivo semáforo já possuía."
	case  arg1 ==102
		   return "DosCloseSem encontrada conjunto de semáforos."
	case  arg1 ==103
		   return "Há muitas solicitações de semáforos exclusivos."
	case  arg1 ==104
		   return "Operação inválida em tempo de interrupção."
	case  arg1 ==105
		   return "proprietário do semáforo anterior encerrado sem libertar semáforo."
	case arg1 ==106 
		   return "limite de Semaphore excedido."
	case  arg1 ==107 
		   return "Insira o disco rígido B na unidade A."
	case arg1 ==108 
		   return "Unidade bloqueado por outro processo."
	case  arg1 ==109
		   return "Escreva no tubo com nenhum leitor."
	case  arg1 ==110
		   return "Open / Create falhou devido a ordem explícita falhar."
	case  arg1 ==111
		   return "Tampão passado para chamada de sistema muito pequeno para armazenar dados de retorno."
	case  arg1 ==112
		   return "Não há espaço suficiente no disco. Disco Cheio. Chame o Tecnico."
	case arg1 ==113
		   return "Não é possível alocar uma outra estrutura de pesquisa e manusear."
	case   arg1 ==114
		   return "Alvo punho em DosDupHandle inválido."
	case  arg1 ==115
		   return "Usuário inválido endereço virtual."
	case  arg1 ==116
		   return "Erro na gravação de exibição ou o teclado ler."
	case  arg1 ==117
		   return "Categoria de DevIOCtl não definido."
	case  arg1 ==118
		   return "valor inválido passado para verificar bandeira."
	case  arg1 ==119
		   return "Nível quatro motorista não foi encontrado."
	case  arg1 ==120
		   return "Função Chamada inválida."   
endcase
return "<Outros>"