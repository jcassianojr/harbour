// +--------------------------------------------------------------------
// +
// +
// +    Programa  : folis_d.prg Revisar Acumulo de Dados,Tabela de UFIR,Variaveis,Arquivos
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +

function folis_d()
WHILE .T.
CABE3( "  Revisar Acumulo de Dados, Tabela de UFIR, Vari veis, Arquivos  ", 24, 79 )
@ 06, 1 PROM " A - Alterar e Verificar Dados Acumulados para RAIS Empresa                   "
@ 07, 1 PROM " B - Alterar e Verificar Dados Acumulados para RAIS Funcion rios Cadastro     "
@ 08, 1 PROM " C - Alterar e Verificar Dados Acumulados para RAIS Funcion rios Valores      "
@ 09, 1 PROM " D - FUNCIONARIOS - Checar Cadastro e Ajustar codigos                         "
@ 10, 1 PROM " E - M‚dia Sal rio Vari vel 13§ Sal rio (H.Ext,AdcNot,Comis.,Etc)(MˆsAtual)   "
@ 11, 1 PROM " F - M‚dia Sal rio Vari vel 13§ Sal rio (H.Ext,AdcNot,Comis.,Etc)(MˆsAnterior)"
@ 12, 1 PROM " G - Indexar Arquivos                             (Criar Arquivos de Trabalho)"
@ 13, 1 PROM " H - Configurar Indexa‡„o                  (Seleciona Arquivos para Indexa‡„o)"
@ 14, 1 PROM " I - Converter Folha Mensal por UM INDICE -Divide todos os Valores pelo Indice"
@ 15, 1 PROM " J - Fazer Virado do Ano  - Encerramento de um ano  preparacao novo           "
@ 16, 1 PROM " K - Informe Avulsos Fisico                                                   "
@ 17, 1 PROM " L - Informe Avulsos Juridico                                                 "
@ 18, 1 PROM " M - Provis„o 13o. Salario                                                    "
@ 19, 1 PROM " N - Sincronizar Rais TXT Cadastro de Funcionarios                            "
MENU TO OPCAO2
DO CASE
CASE OPCAO2 = 1    // A
FOLIS_D2()
CASE OPCAO2 = 2    // B
FOLIS_D1( 0 )
CASE OPCAO2 = 3    // C
FOLIS_D1( 1 )
CASE OPCAO2 = 4  // D
IF mdg( "Checar Cadastro" )
FO7W()
ENDIF
IF mdg( "Checar codigos" )
FOLIS_D9()
ENDIF
CASE OPCAO2 = 5    // E
FOLIS_D3( 0 )
CASE OPCAO2 = 6    // F
FOLIS_D3( 1 )
CASE OPCAO2 = 7    // G
FOY2( 0, "FOLISNTX" )
CASE OPCAO2 = 8    // H
FOY2( 1, "FOLISNTX" )
CASE OPCAO2 = 9    // I
FOLIS_D6()
CASE OPCAO2 = 10   // J
FOLIS_D7()
CASE OPCAO2 = 11   // K
FOLIS_DA()
CASE OPCAO2 = 12   // L
FOLIS_DC()
CASE OPCAO2 = 13
PADRAO( "PROV13", "PROV13", "' '+STR(mNUMERO,8)+' '+STR(mMES,2)+' '+STR(mANO,4)+' '+STR(mDEPTO,4)+' '+STR(mSETOR,3)+' '+STR(mSECAO,3)+' '+STR(mAVOS,2)+' '+STR(mVALLIQ,12,2)", "STRZERO(mNUMERO,8)+STRZERO(mANO,4)+STRZERO(mMES,2)", "Provis„o 13o. Acumulada", "Numero   Mes/Ano Dep  Set Sec Av Liquido", ;
            {|| alltrue( mCHAVE := StrZero( mNUMERO, 8 ) + StrZero( mANO, 4 ) + StrZero( mMES, 2 ) ) }, "PROV13", "PROV13", {|| FO_FOR( "GRUPO='PROV13'" ) } )
MMES := MMES( OP )  // Volta Status
CASE OPCAO2 = 14   // N
IMPRAIS()
OTHERWISE
RETU
ENDCASE
ENDDO
return

// + EOF: folis_d.prg
// +
