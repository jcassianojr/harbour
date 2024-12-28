// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3.prg
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// imphp()

HELPDBF := "FOPTO30"

WHILE .T.
// set century off
__SetCentury( .F. )  // para os relatorios nao cortarem a data ou exibir * volta para true no return
CABE3( 'FOPTO_3 - Relatorios', 23 )
OPCAO( 04, 01, " &A - Ponto Escrito  ENT/SAI     ", 65, " Emite Cart„o de Ponto Escrito, Apenas Entrada e Sa¡da " )
OPCAO( 05, 01, " &B - Ponto Escrito  Passagens   ", 66, " Emite Cart„o de Ponto Escrito, Todas Passagens do dia " )
OPCAO( 06, 01, " &C - Movimento Diario ENT/SAI   ", 67, " Emite o Movimento Di rio do Ponto Entrada e Saida     " )
OPCAO( 07, 01, " &D - Movimento Diario Passagens ", 68, " Emite o Movimento Di rio do Ponto Passagens do Dia    " )
OPCAO( 08, 01, " &E - Movimento Qtde Dias        ", 69, " Lista o Movimento Mensal do Ponto, Qtde Dias          " )
OPCAO( 09, 01, " &F - Ponto e Totais             ", 70, " Lista os Apontamentos e Totais                        " )
OPCAO( 10, 01, " &G - Ponto Escrito Corre‡äes    ", 71, " Emite Cart„o de Ponto Escrito, Corre‡äes              " )
OPCAO( 11, 01, " &H - Movimento Qtde Dias Passa  ", 72, " Movimento Quantidade de Dias conforme Passagem        " )
OPCAO( 12, 01, " &I - Analise de Ponto           ", 73, " Analise entradas e saidas e horarios                  " )
OPCAO( 13, 01, " &J - Escala Revezamento         ", 74, " Escala de Revezamento                                 " )
OPCAO( 14, 01, " &K - Resumo Ocorrˆncias         ", 75, " Resumos de Ocorrˆncias                                " )
OPCAO( 15, 01, " &L - Modelos de Cartas          ", 76, " Modelos de Cartas                                     " )
OPCAO( 16, 01, " &M - Passagens Orf„s Rel¢gio    ", 77, " Passagens de Funcion rios n„o Encontrados Rel¢gio     " )
OPCAO( 17, 01, " &N - Ficha de Frequencia        ", 78, " Ficha de Frequencia                                   " )
OPCAO( 04, 41, " &O - Totais Apurados            ", 79, " Lista os Totais Apurados                              " )
OPCAO( 05, 41, " &P - Relatorios dos Cadastros   ", 80, " Imprimir Relatorios dos Cadastros                     " )
OPCAO( 06, 41, " &Q - No. Passagens por Dia      ", 81, " Numero de passagens efetuados dia a dia               " )
OPCAO( 07, 41, " &R - Passagem func/Hora por dia ", 82, " Passagens com hora e funcionario dia a  dia           " )
OPCAO( 08, 41, " &S - Arquivo Exportado Relogio  ", 83, " Imprime o Ultimo Arquivo Exportado Relogio            " )
OPCAO( 09, 41, " &T - ArquivoExportado Refeitorio", 84, " Imprime o Ultimo Arquivo Exportado Refeitorio         " )
OPCAO( 10, 41, " &U - Ponto e Totais Banco Horas ", 85, " Banco de Horas                                        " )
OPCAO( 11, 41, " &V - Saldo Banco Horas          ", 86, " Saldo Banco de Horas                                  " )
OPCAO( 12, 41, " &W - Saldo Banco Horas Arquivado", 87, " Saldo Banco de Horas Arquivado                        " )
OPCAO( 13, 41, " &1 - WRPT FOLHA                  ", 49, " WRPT FOLHA                                            " )
OPCAO( 14, 41, " &2 - WRPT MODULO RH              ", 50, " WRPT MODULO RH                                        " )
OPCAO( 15, 41, " &3 - WRPT INTEGRADO RH           ", 50, " WRPT INTEGRADO RH                                     " )
OPCAO( 16, 41, " &4 - Configurar Impressoras      ", 51, " Configurar Impressora                                 " )
OPCAO( 17, 41, " &5 - Tipo de    Impressoras      ", 51, " Configurar Tipo Impressora                            " )
OPCAO( 18, 41, " &6 - Pesquisa Funcionarios       ", 52, " Pesquisa funcionarios                                 " )
OPCAO := menu( 1, 24 )
IF ZUSER <> "SUPERVISOR" .AND. ZUSER <> "SOFTEC" .AND. OPCAO > 0
IF !VERSEHA( "MUSERM",, USERMCRI( ZUSER, "C", OPCAO ) )
ALERTX( "Voce n„o tem acesso, Verifique com o Supervisor" )
LOOP
ENDIF
ENDIF
DO CASE
CASE OPCAO = 1   // A   ponto escrito ent/sai
FOPTO_31( 1 )
CASE OPCAO = 2   // B   ponto escrito passagens
FOPTO_31( 2 )
CASE OPCAO = 3   // C  movto diario ent/sai
FOPTO_33( 1 )
CASE OPCAO = 4   // D  movto diario passagens
FOPTO_33( 2 )
CASE OPCAO = 5   // E movto qtde dias
FOPTO_33( 3 )
CASE OPCAO = 6   // F pontos e totais
FOPTO_36()
CASE OPCAO = 7   // g Ponto escrito correcoes
FOPTO_31( 3 )
CASE OPCAO = 8   // h qtde de dias conforme passagem
FOPTO_33( 4 )
CASE OPCAO = 9   // i  analise do ponto
FOPTO_37()
CASE OPCAO = 10  // j escala de revezamento
FOPTO_3A()
CASE OPCAO = 11  // k    resumo ocorrencias
FOPTO_3B()
CASE OPCAO = 12  // L
recuger2()
CASE OPCAO = 13  // M   passagens orfas
FOPTO_3D()
CASE OPCAO = 14  // N    ficha de frequencia
FOPTO_3I()
CASE OPCAO = 15  // O resumo de totais atual/semanal/mes
FOPTO_3F()
CASE OPCAO = 16  // p relatorio de cadastros
FO_FOR( "GRUPO='PONTO'" )
CASE OPCAO = 17  // q no. passagens por dia
FOPTO_3G()
CASE OPCAO = 18  // r funcionario passagem hora dias
FOPTO_3H()
CASE OPCAO = 19  // s exportado (P)onto relogio
FOPTO_25( 7 )
CASE OPCAO = 20  // t exportado refeicao (A)lmoco
FOPTO_25( 8 )
CASE OPCAO = 21  // u ponto e totais banco de horas
FOPTO_3J()
CASE OPCAO = 22  // v    saldo banco de horas
FOPTO_3k( 1 )
CASE OPCAO = 23  // w    saldo banco de horas fechados
FOPTO_3k( 2 )
CASE OPCAO = 24  // 1 wrpt folha
cCAM := ProfileString( "FOLHA.INI", "WRPT", "CAMINHO", "" )
// cCAM+="WRPTF.EXE $"+ALLTRIM(zUSER)+"%#"
// "$"+ALLTRIM(zUSER)+"%#"
// hb_run(cCAM)
WAPI_ShellExecute( NIL, "Open", cCAM + "WRPT.EXE", "F$" + AllTrim( zUSER ) + "%#", cCAM, 1 )
// hwnd,   lpOperation,  lpFile,   lpParameters,   lpDirectory,    nShowCmd
// essSW_SHOWNORMAL = 1

CASE OPCAO = 25  // 2 wrtp rh
cCAM := ProfileString( "FOLHA.INI", "WRPT", "CAMINHO", "" )
// cCAM+="WRPTX.EXE $"+ALLTRIM(zUSER)+"%RH#"
// hb_run(cCAM)
WAPI_ShellExecute( NIL, "Open", cCAM + "WRPT.EXE", "X$" + AllTrim( zUSER ) + "%#", cCAM, 1 )
CASE OPCAO = 26  // 3 wrtp integrado
cCAM := ProfileString( "FOLHA.INI", "WRPT", "CAMINHO", "" )
// cCAM+="WRPTI.EXE $"+ALLTRIM(zUSER)+"%RH#"
WAPI_ShellExecute( NIL, "Open", cCAM + "WRPT.EXE", "I$" + AllTrim( zUSER ) + "%#", cCAM, 1 )
CASE Opcao = 27
WIN_PRINTDLGDC()
CASE Opcao = 28
imphp()
CASE opcao = 29
fopto_32()
// Win_PrintDlgDC()
OTHERWISE
__SetCentury( .T. )
RETU
ENDCASE
ENDDO


// + EOF: fopto_3.prg
// +
