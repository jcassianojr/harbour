*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


HELPDBF := "FOPTO40"

while .T.
   CABE3('FOPTO_4 - Cadastros',23)
   OPCAO(04,01," &A - Indexar Arquivos            ",65," Criar Arquivos de Trabalho                    ")
   OPCAO(05,01," &B - Configurar Indexacao        ",66," Seleciona Arquivos para Indexacao             ")
   OPCAO(06,01," &C - Tolerancia/Exportacao       ",67," Configurar Tolerancia Exporta??o              ")
   OPCAO(07,01," &D - Motivos                     ",68," Motivos                                       ")
   OPCAO(08,01," &E - Preparacao arquivos Portaria",69," Preparacao arquivos Portaria                  ")
   OPCAO(09,01," &F - Parametros/Calculo/Arquivos ",70," Parametros Para Calculo                       ")
   OPCAO(10,01," &G - Ajustar Codigos Foto/Depto  ",71," Ajustar Codigos Fotos                         ")
   OPCAO(11,01," &H - Creditos/Avulsos            ",72," Creditos Avulsos                              ")
   OPCAO(12,01," &I - Codigos de Eventos/Feriados ",73," Cadastro de Eventos para Pr? Lan?amento       ")
   OPCAO(13,01," &J - Codigos de Faltas/Atrasos   ",74," Cadastro de Faltas e Atrasos                  ")
   OPCAO(14,01," &K - Cadastro Checagem Pis       ",75,"                                               ")
   OPCAO(15,01," &L - Tabela de Refeicao          ",76," Tabela de Refeicao                            ")
   OPCAO(16,01," &M - CBO                         ",77," Cadastro CBO                                  ")
   OPCAO(17,01," &N - Cadastro de Funcionarios    ",78," Cadastro de Funcionarios                      ")
   OPCAO(18,01," &O -                             ",79,"                                               ")
   OPCAO(19,01," &P -                             ",80,"                                               ")
   OPCAO(20,01," &Q - Recompor Estruturas         ",81," Recomp?em as estruturas dos Arquivos de Dados ")
   OPCAO(21,01," &R - Cadastro Empresas           ",82," Cadastro empresa                              ")
   OPCAO(04,41," &S - Cadastro Contas Descricao   ",83," Cadastro de Contas do Sistema                 ")
   OPCAO(05,41," &T - Cadastro Provis¢rios        ",84," Cadastro de Provis®rios                       ")
   OPCAO(06,41," &U -                             ",85,"                                               ")
   OPCAO(07,41," &V - Cadastro Ocorrencia Mes     ",86," Cadastro de Ocorrencias Mes                   ")
   OPCAO(08,41," &W - Ajuste Passagens            ",87," Ajuste de Passagens                           ")
   OPCAO(09,41," &X - Importar Ferias Folha       ",88," Importa Funcionarios em Ferias Folha Softec   ")
   OPCAO(10,41," &Y - Usuarios/Planos de Acesso   ",89," Configurar Planos de Acesso                   ")
   OPCAO(11,41," &Z -                             ",90,"                                               ")
   OPCAO(12,41," &1 -                             ",49,"                                               ")
   OPCAO(13,41," &2 -                             ",50,"                                               ")
   OPCAO(14,41," &3 - Multiplos Creditos Avulsos  ",51," Multiplos Creditos Avulsos                    ")
   OPCAO(15,41," &4 -                             ",52,"                                               ")
   OPCAO(16,41," &5 - Multiplos Ajustes Passagens ",53," Multiplos Ajustes de Passagens                ")
   OPCAO(17,41," &6 - Funcoes                     ",54," Cadastro de Funcoes                           ")
   OPCAO(18,41," &7 - Departamentos               ",55," Departamentos                                 ")
   OPCAO(19,41," &8 - Unidades Funcionais         ",56," Unidades Funcionais                           ")
   OPCAO(20,41," &9 - Checar Cadastro Funcionarios",57," Checar Cadastro Funcionarios                  ")
   OPCAO(21,41," &0 - Cidades                     ",48," Cadastro de Cidades                           ")
   OPCAO := menu(2,24)
   if ZUSER <> "SUPERVISOR" .and. ZUSER <> "SOFTEC" .and. OPCAO > 0
      if !VERSEHA("MUSERM",,USERMCRI(ZUSER,"D",OPCAO))
         ALERTX("Voce n?o tem acesso, Verifique com o Supervisor")
         loop
      endif
   endif
   IF ZFECHADO = "S"
      if OPCAO = 31 .or. OPCAO = 29 .or. OPCAO = 24 .OR. OPCAO = 13
         ALERTX("Mes ja Fechado")
         loop
      endif
   ENDIF


   do case
   case OPCAO = 1   //A - Indexar Arquivos
      FOY2(0,"FOPTONTX")
   case OPCAO = 2   //B - Configurar Indexacao
      FOY2(1,"FOPTONTX")
   case OPCAO = 3   //C tolerancia exportacao
      PADRAO("FOPTOCON","FOPTOCON","' '+STR(mEMPRESA,8)","mEMPRESA","Tolerancia/Exportacao","Empresa",;
       {|| PEGCHAVE("mEMPRESA",ULTIMOREG("FOPTOCON","EMPRESA",.T.),"Empresa:")},"PTOCGF","PTOCGF",{|| FO_FOR("GRUPO='PTOCFG'")},;
       ,,,,"X")
   case OPCAO = 4   //D  motivos
      PADRAO("FOPTOMOT","FOPTOMOT","' '+STR(mNUMERO,8)+' '+mNOME","mNUMERO","Motivos ausencias/faltas   ","Cod.  Nome",;
       {|| PEGCHAVE("mNUMERO",ULTIMOREG("FOPTOMOT","NUMERO",.T.),"Codigo:")},"PTOMOT","PTOMOT",{|| FO_FOR("GRUPO='PTOMO'")},;
       ,,,,"X")
   case OPCAO = 5   //E preparacao arquivos portaria
      fopto_4x()
   case OPCAO = 6
      FOPTO_45()
   case OPCAO = 7   //G - Ajustar Codigos Fotos
      FOYD()
   case OPCAO = 8   //H - Creditos/Avulsos
      FOPTO_48()
   case OPCAO = 9   //I - C®digos de Eventos
      FOPTO_49()
   case OPCAO = 10  //J - C®digos de Faltas/Atrasos
      FOPTO_4A()
   case OPCAO = 11  //K

      PADRAO("PISINDEV","PISINDEV","' '+mCODIGO+' '+mNOME","mCODIGO","Cadastro de Pis/Checagem","Pis  Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(11),"Codigo:")},"PISIND","PISIND",{|| FO_FOR("GRUPO='PISIND'")})

   case OPCAO = 12  //L - Tabela de Refei??o
      FOPTO_4C("FOPTOALM","PONTOCAD05")
   case OPCAO = 13  //M
      PADRAO("FO_CBON","FO_CBON","' '+mCODIGO+' '+STRZERO(mCAGEDESCO,2)+' '+mNOME","mCODIGO","Codigos","Codigo Escol Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(5),"Codigo:")},{|| mds("")},{|| mds("")},{|| FO_FOR("GRUPO='CBO'")})
   case OPCAO = 14  //N - Cadastro de Funcionarios
      FOPTO_4E()
   case OPCAO = 15  //O
   case OPCAO = 16  //P
   case OPCAO = 17  //Q - Recompor Estruturas
      FOY8()
   case OPCAO = 18  //R - Cadastro Empresas
      FOPTO_4H()
   case OPCAO = 19  //S - Cadastro Contas Descri??o
      FOPTO_4I()
   case OPCAO = 20  //T - Cadastro Provis®rios
      FOPTO_4J()
   case OPCAO = 21  //U
   case OPCAO = 22  //V - Cadastro Ocorrencia Mes
      FOPTO_4T()
   case OPCAO = 23  //W - Ajuste Passagens
      FOPTO_4M()
   case OPCAO = 24  //X - Importar Ferias Folha
      FOPTO_4N()
   case OPCAO = 25  //Y - Usuarios/Planos de Acesso
      if MDG("Alterar Usuarios")
         FOPTO_4P()
      endif
      if MDG("Alterar Plano de Acessos")
         FOPTO_4O()
      endif
   case OPCAO = 26  //Z -

   case OPCAO = 27  //1 -

   case OPCAO = 28  //2 -

   case OPCAO = 29  //3 - Multiplos Creditos Avulsos
      FOPTO_482()
   case OPCAO = 30  //4
   case OPCAO = 31  //5 - Multiplos Ajustes Horarios
      FOPTO_4M2()
   case OPCAO = 32  //6 - Funcoes
      PADRAO("FUNCAO","FUNCAO","' '+STR(mCODIGO,  4)+' '+mNOME+' '+mFAIXA+' '+STR(mVALOR, 11, 2)+' '+mCBONEW","mCODIGO","Cadastro de Funcoees","Cod.  Nome"+spac(37)+"Ni Valor"+spac(7)+"CBO",;
       {|| PEGCHAVE("mCODIGO",ULTIMOREG("FUNCAO","CODIGO",.T.),"Codigo:")},"FUNC01","FUNC01",{|| FO_FOR("GRUPO='FUNCAO'")})
   case opcao = 33  //7  Departamentos
      PADRAO("DEPTO","DEPTO","STR(mDEPTO,4)+' '+STR(mSETOR,4)+' '+STR(mSECAO,4)+' '+mNOME","mDEPTO*1000000+mSETOR*1000+mSECAO","DEPTO - Cadastro de Depto/Setor/secao","Depto Setor Secao Nome",;
       {|| iDEPTO()},{|| tDEPTO()},{|| gDEPTO()},{|| FO_FOR("GRUPO='DEPTO'")},,2)
   case opcao = 34  //8 Unidade Funcionais
      fo_unid()
   case opcao = 35  //9 Checar Cadastro Funcionarios
      fo7w()
   case opcao = 36  //0 Cidades
      fo1w()
   other
      retu
   endcase
enddo




*+ EOF: fopto_4.prg
*+
