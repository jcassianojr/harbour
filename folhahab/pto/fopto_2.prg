// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_2.prg menu pongo
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


function fopto_2()
HELPDBF := "FOPTO20"

WHILE .T.
CABE3( 'FOPTO_2 - Ponto', 24 )
OPCAO( 04, 01, " &A - Iniciar o Mes          ", 65, "Inicia o Ponto mensal, e Inclui Admitidos no Ponto" )   // 1
OPCAO( 05, 01, " &B - Alterar dados          ", 66, "Altera dados do Ponto" )  // 2
OPCAO( 06, 01, " &C - Totalizar Ponto        ", 67, "Totaliza os lan?amentos do Ponto" )   // 3
OPCAO( 07, 01, " &D - Totais do Mes          ", 68, "Altera a Totaliza??o do Ponto Mensal" )   // 4
OPCAO( 08, 01, " &E - Transferir Ponto->Folha", 69, "Transfere Totais Ponto para Folha" )  // 5
OPCAO( 09, 01, " &F - Calcular o Ponto       ", 70, "C lculo o Ponto" )  // 6
OPCAO( 10, 01, " &G - Marcar uma data        ", 71, "Marcar uma data com um c«digo" )  // 7
OPCAO( 11, 01, " &H - Creditos/Avulsos       ", 72, "Creditos Avulsos" )   // 8
OPCAO( 12, 01, " &I - Apagar Movimento       ", 73, "Apaga Arquivos de movimento determinado m?s" )  // 9
OPCAO( 13, 01, " &J - Zerar ENT/SAI          ", 74, "Zerar Entradas e Saidas grupo Funcionarios " )  // 10
OPCAO( 14, 01, " &K - Excluir Movimentacao   ", 75, "Elimina Movimento Ponto grupo Funcionarios " )  // 11
OPCAO( 15, 01, " &L - Transferir Refei->Folha", 76, "Transfere Refeicao Ponto para Folha" )  // 12
OPCAO( 16, 01, " &M - Ajuste SA/DO           ", 77, "Funcionarios normal-->Turno             " )   // 13
OPCAO( 17, 01, " &N - Exportar Totais        ", 78, "Exporta Totais         para Arquivo TXT " )   // 14
OPCAO( 18, 01, " &O - Exportar Refeicao      ", 79, "Exporta Qtde->Refeicao para arquivo TXT " )   // 15
OPCAO( 19, 01, " &P - Importar Ocorrencias   ", 80, "Importa Arquivo de Ocorrencias" )   // 16
OPCAO( 20, 01, " &Q - Lancar Complementos    ", 81, "Efetua o Lan?amentos Complementares " )   // 17
OPCAO( 21, 01, " &R - Totais da Semana       ", 82, "Altera a Totaliza??o do Ponto Semanal" )  // 18
OPCAO( 22, 01, " &S - Totais Acumulados      ", 83, "Altera a Totaliza??o do Ponto Mensal Acumulado" )   // 19
OPCAO( 04, 41, " &T - Lancar Valores         ", 84, "Lanca um valor em determinada conta" )  // 20
OPCAO( 05, 41, " &U - Correcao Horarios/Turno", 85, " Correcao de Horarios/Turno                    " )  // 21
OPCAO( 06, 41, " &V - Cadastro Ocorrencia Mes", 86, " Cadastro de Ocorrencias Mes                   " )  // 22
OPCAO( 07, 41, " &W - Ajuste Passagens       ", 87, " Ajuste de Passagens                           " )  // 23
OPCAO( 08, 41, " &X - Ajustar Demitidos      ", 88, " Excluir Competencia Demitidos                 " )  // 24
OPCAO( 09, 41, " &Y - Gerar AFDT             ", 89, " Gerar AFDT                                    " )  // 25
OPCAO( 10, 41, " &Z - Reabrir Competencia    ", 90, " Reabrir competencia                           " )  // 26
OPCAO( 11, 41, " &1 - Fechar Competencia     ", 49, " Fechar competencia                            " )  // 27
OPCAO := menu( 2, 24 )
IF ZUSER <> "SUPERVISOR" .AND. ZUSER <> "SOFTEC" .AND. OPCAO > 0
IF !VERSEHA( "MUSERM",, USERMCRI( ZUSER, "B", OPCAO ) )
ALERTX( "Voce nAo tem acesso, Verifique com o Supervisor" )
LOOP
ENDIF
ENDIF
IF ZFECHADO = "S"
DO CASE
CASE opcao = 0
RETURN
CASE OPCAO = 2 .OR. OPCAO = 4 .OR. OPCAO = 18 .OR. OPCAO = 19 .OR. OPCAO = 22 .OR. ;
               OPCAO = 8 .OR. OPCAO = 21 .OR. OPCAO = 23
ALERTX( "Mes ja fechado somente consulta" )
CASE OPCAO = 25 .OR. OPCAO = 26
OTHERWISE
ALERTX( "Mes ja Fechado - Bloqueado Execucao" )
LOOP
ENDCASE
ENDIF
DO CASE
CASE OPCAO = 1   // A
FOPTO_21()
CASE OPCAO = 2   // B
FOPTO_22()
CASE OPCAO = 3   // C
FOPTO_23()
CASE OPCAO = 4   // D
FOPTO_24( 1 )
CASE OPCAO = 5   // E
FOPTO_25( 1 )
CASE OPCAO = 6   // F
IF MDG( "Lancar Complementos" )
pegcompete()
FOPTO_2I()   // horarios avulsos     FOPTO_4M cPM FO_PMAN
FOPTO_2J()   // correcao de horarios FOPTO_4L cPH FO_PHOR
FOPTO_2H()   // ocorrencia           FOPTO_4T cPO FO_POCO
ENDIF
FOPTO_26()
CASE OPCAO = 7   // G
FOPTO_27()
CASE OPCAO = 8   // H
FOPTO_48()
CASE OPCAO = 9   // I
FOPTO_29()
CASE OPCAO = 10  // J
FOPTO_2A()
CASE OPCAO = 11  // K
FOPTO_2B()
CASE OPCAO = 12  // L
FOPTO_25( 4 )   // Refeicoes-->Folha
CASE OPCAO = 13  // M
FOPTO_2M()
CASE OPCAO = 14  // N
fopto_25( 2 )   // Exportar totais
pegcompete( .T. )
CASE OPCAO = 15  // O
FOPTO_25( 3 )   // Exportar Refeicoes
CASE OPCAO = 16  // P
FOPTO_2G()
CASE OPCAO = 17  // Q lancar ocorrencias
pegcompete()
FOPTO_2I()  // horarios avulsos
FOPTO_2J()  // correcao de horarios
FOPTO_2H()  // ocorrencia
CASE OPCAO = 18  // R
FOPTO_24( 2 )
CASE OPCAO = 19  // S
FOPTO_24( 3 )
CASE OPCAO = 20  // T
FOPTO_28()
CASE OPCAO = 21  // U - Correcao de Hor rios
FOPTO_4L()
CASE OPCAO = 22  // V - Cadastro Ocorrencia Mes
FOPTO_4T()
CASE OPCAO = 23  // W - Ajuste Horario Avulsos
FOPTO_4M()
CASE OPCAO = 24  // x ajustar demitidos
FOPTO_2Y()
CASE OPCAO = 25  // Y gerar afdt
FOPTO_3L()
CASE OPCAO = 26  // Z reabrir competencia
pegcompete( .F. )
CASE OPCAO = 27  // 1 Fechar competencia
pegcompete( .T. )
OTHERWISE
RETU
ENDCASE
ENDDO
return

// + EOF: fopto_2.prg
// +
