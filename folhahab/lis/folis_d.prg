*:*****************************************************************************
*:
*:    FOLIS_D.PRG: Revisar Acumulo de Dados,Tabela de UFIR,Vari veis,Arquivos
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************

WHILE .T.
   CABE3("  Revisar Acumulo de Dados, Tabela de UFIR, Vari veis, Arquivos  ",24,79)
   @ 06,1 PROM " A - Alterar e Verificar Dados Acumulados para RAIS Empresa                   "
   @ 07,1 PROM " B - Alterar e Verificar Dados Acumulados para RAIS Funcion rios Cadastro     "
   @ 08,1 PROM " C - Alterar e Verificar Dados Acumulados para RAIS Funcion rios Valores      "
   @ 09,1 PROM " D - FUNCIONARIOS - Checar Cadastro e Ajustar codigos                         "
   @ 10,1 PROM " E - M‚dia Sal rio Vari vel 13§ Sal rio (H.Ext,AdcNot,Comis.,Etc)(MˆsAtual)   "
   @ 11,1 PROM " F - M‚dia Sal rio Vari vel 13§ Sal rio (H.Ext,AdcNot,Comis.,Etc)(MˆsAnterior)"
   @ 12,1 PROM " G - Indexar Arquivos                             (Criar Arquivos de Trabalho)"
   @ 13,1 PROM " H - Configurar Indexa‡„o                  (Seleciona Arquivos para Indexa‡„o)"
   @ 14,1 PROM " I - Converter Folha Mensal por UM INDICE -Divide todos os Valores pelo Indice"
   @ 15,1 PROM " J - Fazer Virado do Ano  - Encerramento de um ano  preparacao novo           "
   @ 16,1 PROM " K - Informe Avulsos Fisico                                                   "
   @ 17,1 PROM " L - Informe Avulsos Juridico                                                 "
   @ 18,1 PROM " M - Provis„o 13o. Salario                                                    "
   @ 19,1 PROM " N - Sincronizar Rais TXT Cadastro de Funcionarios                            "
   MENU TO OPCAO2
   DO CASE
      CASE OPCAO2=1  ; FOLIS_D2() //A
      CASE OPCAO2=2  ; FOLIS_D1(0) //B
      CASE OPCAO2=3  ; FOLIS_D1(1) //C
      CASE OPCAO2=4  //D
          if mdg("Checar Cadastro")
             FO7W()
          endif
          IF mdg("Checar codigos")  
             FOLIS_D9()
          endif    
      CASE OPCAO2=5  ; FOLIS_D3(0) //E
      CASE OPCAO2=6  ; FOLIS_D3(1) //F
      CASE OPCAO2=7  ; FOY2(0,"FOLISNTX") //G
      CASE OPCAO2=8  ; FOY2(1,"FOLISNTX") //H
      CASE OPCAO2=9  ; FOLIS_D6() //I
      CASE OPCAO2=10 ; FOLIS_D7() //J
      CASE OPCAO2=11 ; FOLIS_DA() //K
      CASE OPCAO2=12 ; FOLIS_DC() //L
      CASE OPCAO2=13
           PADRAO("PROV13","PROV13","' '+STR(mNUMERO,8)+' '+STR(mMES,2)+' '+STR(mANO,4)+' '+STR(mDEPTO,4)+' '+STR(mSETOR,3)+' '+STR(mSECAO,3)+' '+STR(mAVOS,2)+' '+STR(mVALLIQ,12,2)","STRZERO(mNUMERO,8)+STRZERO(mANO,4)+STRZERO(mMES,2)","Provis„o 13o. Acumulada","Numero   Mes/Ano Dep  Set Sec Av Liquido",;
              {|| alltrue(mCHAVE:=STRZERO(mNUMERO,8)+STRZERO(mANO,4)+STRZERO(mMES,2))},"PROV13","PROV13",{|| FO_FOR("GRUPO='PROV13'")})
               MMES=MMES(OP) //Volta Status 
      CASE OPCAO2=14 ; IMPRAIS() //N
   OTHERWISE     ; RETU
   ENDCASE
ENDDO
*: FIM: FOLIS_D.PRG
