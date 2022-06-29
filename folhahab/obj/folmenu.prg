*:*****************************************************************************
*:
*:    FOLMENU.PRG:  MENU PRINCIPAL DA FOLHA DE PAGAMENTO
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:22
*:
*:*****************************************************************************


////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

SETCOLOR("+W/BR,N/W")
CLSROW(0)
@ 00,00 SAY "<<FOLHA - MODULO PRINCIPAL>> v.53b"
CLSCOR()
MENU=1
WHILE .T.
   SETCOLOR("+W/BR,N/W")
   CLSROW(1)
   @ 01,01 SAY STR(NREMP)+" - "+MSG2
   IF VALTYPE(mMES)#"C"
      MMES=MMES(OP)
   ENDIF
   @ 01,60 SAY MMES+"/"+STR(YEAR(DXDIA),4)
   CLSCOR()
   CLSROW(2)
   HB_DISPBOX(04,00,06,79,B_DOUBLE+" ")
   @ 05,21 SAY "Menu Principal da Folha de Pagamento"
   HB_DISPBOX(07,00,23,25,B_DOUBLE+" ")
   @ 07,02 SAY " Cadastros: "
   HB_DISPBOX(07,27,23,52,B_DOUBLE+" ")
   @ 07,29 SAY " Procedimentos: "
   HB_DISPBOX(07,54,23,79,B_DOUBLE+" ")
   @ 07,56 SAY " Auxilio: "
   @ 09,56 SAY "F 1 - Ajuda."
   @ 10,56 SAY "F 2 - Telememo"
   @ 11,56 SAY "F 3 - Anotacoes"
   @ 12,56 SAY "F 4 - Agenda"
   @ 13,56 SAY "F 5 - Teclas"
   @ 14,56 SAY "F 6 - Memoria"
   @ 15,56 SAY "F 7 - Calendario"
   @ 16,56 SAY "F 8 - Calculadora"
   @ 17,56 SAY "F 9 - Relogio "
   @ 18,56 SAY "F10 - Data Operacional"
   @ 20,56 SAY "F12 - Digitos Ano"
   @ 17,30 SAY REPL('-',21)
   OPCAO( 09,03 , " &1 - Departamentos  ",49)
   OPCAO( 11,03 , " &2 - Empresas       ",50)
   OPCAO( 13,03 , " &3 - Funcionarios   ",51)
   OPCAO( 15,03 , " &4 - Funcoes        ",52)
   OPCAO( 17,03 , " &5 - Plano de Contas",53)
   OPCAO( 19,03 , " &6 - Sindicatos     ",54)
   OPCAO( 21,03 , " &7 - Tabelas/Codigos",55)
   OPCAO( 09,30 , " &A - Entrada Dados    ",65)
   OPCAO( 11,30 , " &B - Imprimir Gerar   ",66)
   OPCAO( 13,30 , " &C - Calculos         ",67)
   OPCAO( 15,30 , " &D - Exibir Video     ",68)
   OPCAO( 19,30 , " &E - Configura Sistema",69)
   OPCAO( 21,30 , " &F - Manual           ",70)
   OP:=MENU(,0)
   ANO:=YEAR(DXDIA)
   DO CASE
   CASE OP = 1 ; FO5()
   CASE OP = 2 ; FO1(0)
   CASE OP = 3 ; MENU7()
   CASE OP = 4 ; FO3()
   CASE OP = 5 ; MENU6()
   CASE OP = 6 ; FO2()
   CASE OP = 7 ; FO0(0)
   CASE OP = 8 ; MENUA()
   CASE OP = 9 ; MENUC()
   CASE OP = 10; FOD()
   CASE OP = 11; FOE()
   CASE OP = 12; FOY()
   CASE OP = 13; FOX()
   OTHERWISE   ; CLEAR ; RETU
   ENDCASE
ENDDO

*!*****************************************************************************
*!
*!       MENU7
*!
*!*****************************************************************************
FUNCTION MENU7
PRIV HELPDBF
HELPDBF="FO7"
WHILE .T.
   CABEX ("Cadastro de Funcionarios")
   OPCAO(  5, 2 , " &1 - Funcionarios                ",49)
   OPCAO(  6, 2 , " &2 - Documentacao Admissao/Dem.  ",50)
   OPCAO(  7, 2 , " &3 - Planilhas Dados/Hor./Faltas ",51)
   OPCAO(  8, 2 , " &4 - Salario Reajuste/Proj/Evol. ",52)
   OPCAO(  9, 2 , " &5 - RPA                         ",53)
   OPCAO( 10, 2 , " &6 -                             ",54)
   OPCAO( 11, 2 , " &7 -                             ",55)
   OPCAO( 12, 2 , " &8 -                             ",56)
   OPCAO( 13, 2 , " &9 -                             ",57)
   OPCAO( 14, 2 , " &0 -                             ",48)
   OPCAO(  5,43 , " &A -                             ",65)
   OPCAO(  6,43 , " &B -                             ",66)
   OPCAO(  8,43 , " &C - Procurador/Preposto         ",67)
   OPCAO(  9,43 , " &D -                             ",68)
   OPCAO( 11,43 , " &E - Socios                      ",69)
   OPCAO( 12,43 , " &F -                             ",70)
   OPCAO( 14,43 , " &G -                             ",71)
   OPCAO( 15,43 , " &H -                             ",72)
   OPCAO( 17,43 , " &I -                             ",73)
   OPCAO( 18,43 , " &J -                             ",74)
   OPCAO( 20,43 , " &K -                             ",75)
   OPCAO( 21,43 , " &L -                             ",76)
   OPCAO( 22,43 , " &M -                             ",77)
   OPC:=MENU(,0)
   DO CASE
      CASE OPC=1  ; FO7()
      CASE OPC=2  ; FOU()
      CASE OPC=3  ; FOG()
      CASE OPC=4
           IF ZUSER<>"SUPERVISOR"  //So troca Senha
              ALERTX("Acesso Permitido Somente Para o Supervisor")
              LOOP
           ENDIF
           FO4()
      CASE OPC=5 ; FO7Z()
      CASE OPC=11
      CASE OPC=12 ; MAC("MC02")
      CASE OPC=13
      CASE OPC=14
      CASE OPC=15 ; MAC("MC05")
   OTHERWISE   ; RETU
   ENDCASE
ENDDO

*!*****************************************************************************
*!
*!       MENUC
*!
*!*****************************************************************************
FUNCTION MENUC
PRIV HELPDBF
HELPDBF="FOC"
WHILE .T.
   CABEX("Imprimir Relatorios")
   HB_DISPBOX(07,00,17,29,B_DOUBLE+" ")
   @ 09,01 PROM "  1 - Imprimir Lancamentos  "
   @ 10,01 PROM "  2 - Guias Recolhimento    "
   @ 11,01 PROM "  3 - Resumos Especiais     "
   @ 12,01 PROM "  4 - Hollerith             "
   @ 13,01 PROM "  5 - Cadastros             "
   @ 15,01 PROM "  6 - Formul rios           "
   MENU TO OPC
   DO CASE
      CASE OPC=1 ; FOC(0)
      CASE OPC=2 ; FOH(0)
      CASE OPC=3 ; FOI(0)
      CASE OPC=4 ; FOF(0)
      CASE OPC=5 ; MENUCC()
      CASE OPC=6 ; FO_FOR("EMPTY(GRUPO)")
   OTHERWISE  ; RETU
   ENDCASE
ENDDO
RETU

*!*****************************************************************************
*!
*!       MENUCC
*!
*!    Chamado por: MENUC              (  em FOLMENU.PRG)
*!
*!          Chama: CABEX()            (fun??o    em FOLPROC.PRG)
*!               : CLSCOR()           (fun??o    em COMANDO.CH)
*!               : FO7D()             (fun??o    em FO7D.PRG)
*!               : FO7C()             (fun??o    em FO7C.PRG)
*!               : FO6L()             (fun??o    em FO6.PRG)
*!
*!*****************************************************************************
FUNCTION MENUCC
WHILE .T.
   CABEX('Imprimir Cadastros')
   SETCOLOR("+N/BG")
   HB_DISPBOX(08,00,23,32,B_DOUBLE+" ")
   @ 09,2 PROM "  1 - Departamentos"+SPAC(10)
   @ 11,2 PROM "  2 - Cadastro Empresa"+SPAC(7)
   @ 14,2 PROM "  3 - Funcion rios Simples   "
   @ 15,2 PROM "  4 - Funcion rios Completo  "
   @ 17,2 PROM "  5 - Fun??es"+SPAC(16)
   @ 19,2 PROM "  6 - Plano de Contas"+SPAC(8)
   @ 20,2 PROM "  7 - Cadastro Sindicatos    "
   @ 21,2 PROM "  8 - Tabelas Diversas       "
   MENU TO KEY
   CLSCOR()
   DO CASE
   CASE KEY =1 ; FO_FOR("GRUPO='DEPTO'")
   CASE KEY =2 ; FO_FOR("GRUPO='FIRMA'")
   CASE KEY =3 ; FILTRO="EMPTY(DEMITIDO)" ; FO7D()
   CASE KEY =4 ; FILTRO="EMPTY(DEMITIDO)" ; FO7C()
   CASE KEY =5 ; FO_FOR("GRUPO='FUNCAO'")
   CASE KEY =6 ; FO6L()
   CASE KEY =7 ; FO_FOR("GRUPO='SINDIC'")
   CASE KEY =8 ; FO_FOR("GRUPO='TABELA'")
   OTHERWISE   ; RETU
   ENDCASE
ENDDO
RETU

*!*****************************************************************************
*!
*!       MENUA
*!
*!*****************************************************************************
FUNCTION MENUA
PRIV HELPDBF
HELPDBF="FOA"
WHILE .T.
   CABEX("Entrada de Dados")
   HB_DISPBOX(07,00,15,29,B_DOUBLE+" ")
   @ 09,01 PROM "  1 - Incluir Dados         "
   @ 11,01 PROM "  2 - Excluir Dados         "
   @ 13,01 PROM "  3 - Sequencia Programda.  "
   MENU TO OPC
   DO CASE
   CASE OPC=1  ; FOA(0)
   CASE OPC=2  ; FOA(1)
   CASE OPC=3  ; FOA(2)
   OTHER       ; RETU
   ENDCASE
ENDDO
RETU


*!*****************************************************************************
*!
*!       MENU6
*!
*!*****************************************************************************
FUNCTION MENU6
PRIV HELPDBF
HELPDBF="FOG"
WHILE .T.
   CABEX("Entrada de Dados")
   HB_DISPBOX(07,00,17,29,B_DOUBLE+" ")
   OPCAO(09,01,"  &1 - Vencimentos/Descontos ",49)
   OPCAO(10,01,"  &2 - Contabil              ",50)
   OPCAO(11,01,"  &3 - Historico Padrao      ",51)
   OPCAO(12,01,"  &4 - Centro de Custos      ",52)
   OPCAO(13,01,"  &5 - Contas Indv. Empresas ",53)
   OPCAO(14,01,"  &6 - Contas Acumulativas   ",54)
   OPCAO(15,01,"  &7 - Contas RPA            ",55)
   OPC:=MENU(,0)
   DO CASE
      CASE OPC=1  ; FO6()
      CASE OPC=2
          cARQMI01:=PEGCAMINI("MI01")+"MI01"
          PADRAO(cARQMI01,cARQMI01,"' '+mCONTA+' '+mTIPO+' '+STR(mNIVEL,1)+' '+mIDENTIFICA+' '+STR(mNUMERO,6)","mCONTA","Plano de Contas Contabil","C½digo"+spac(6)+"Discrimina??o da Conta"+spac(9)+"T N I Reduzido",;
                  {|| PEGCHAVE("mCODIGO",SPACE(11),"Conta:")},"MI0100","MI0100",{|| FO_FOR("GRUPO='MI01'")})
      CASE OPC=3
          cARQMI02:=PEGCAMINI("MI02")+"MI02"
          PADRAO(cARQMI02,cARQMI02,"' '+STR(mCODIGO,  3)+' '+mDESCRICOA+' '+mTIPO","mCODIGO","Historico Padrao","Cod Nome"+spac(67)+"T",;
                {|| PEGCHAVE("mCODIGO",SPACE(3),"Codigo:")},"MI0200","MI0200",{|| FO_FOR("GRUPO='MI02'")})
      CASE OPC=4
            cARQMI03:=PEGCAMINI("MI03")+"MI03"
            PADRAO(cARQMI03,cARQMI03,"' '+mCENTRO+' '+mUE+' '+mATIVIDADE+' '+mGASTO+' '+STR(mCFOLHA,3)","mCENTRO","Unidade da Empresa","UE"+spac(6)+"Atividade"+spac(37)+"Gasto/Centro Folha",;
                {|| PEGCHAVE("mCENTRO",SPACE(4),"Centro de Custo:")},"MI0300","MI0300",{|| FO_FOR("GRUPO='MI03'")})
      CASE OPC=5
            PADRAO("CCCOR","CCCOR","' '+STR(mCODIGO,  4)+' '+STR(mNUMEMP,  5)","STR(mCODIGO,4)+STR(mNUMEMP,5)","Contas Individuais Por Empresa","Conta Empresa",;
                {||iFO6D()},"CCCOR0","CCCOR0",{|| FO_FOR("GRUPO='CCCOR'")})
      CASE OPC=6
            PADRAO("CCESP","CCESP","' '+STR(mCODIGO,  4)+' '+STR(mNUMEMP,  5)","STR(mCODIGO,4)+STR(mNUMEMP,5)","Contas Individuais Por Empresa","Conta Empresa",;
             {||iFO6D()},"CCESP0","CCESP0",{|| FO_FOR("GRUPO='CCESP'")})
      CASE OPC=7
            PADRAO("CTARPA","CTARPA","STR(mCODIGO,3)+' '+mDESCR","mCODIGO","Contas RPA","Conta Nome",;
                  {|| PEGCHAVE("mCONTA",ULTIMOREG("CTARPA","CONTA",.T.),"Numero")},"CTARPA","CTARPA",{|| FO_FOR("GRUPO='CTARPA'")})
      OTHERWISE
            RETURN
   ENDCASE
ENDDO
RETURN


FUNCTION iFO6D
MDS('Digite Conta Empresa')
@ 24,40 get mCODIGO
@ 24,50 GET mNUMEMP
READCUR()
mCHAVE:=STR(mCODIGO,4)+STR(mNUMEMP,5)
RETU .T.


FUNCTION MAC(cARQ)
cARQ=PEGCAMINI(cARQ)+cARQ
PADRAO(cARQ,cARQ,"' '+STRVAL(mNUMERO,5)+' '+mNOME","mNUMERO","Cadastro","Codigo Nome",;
       {|| PEGCHAVE("mNUMERO",SPACE(5),"Codigo")},"MAC001","MAC001",{|| FO_FOR("GRUPO='MAC'")})
RETU .T.


*: FIM: FOLMENU.PRG
