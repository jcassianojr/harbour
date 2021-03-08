*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mana.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


static KEY := 1

////////
ARQUSO := ""  //Variavel de Controle func tipcad
////////

aMENU := array(33)
aMESS := array(33)
afill(aMENU,space(25))
afill(aMESS,space(75))
if USEREDE("MANOPT",1,1)
   dbgotop()
   dbseek("A")
   while ITEMENU = "A" .and. !eof()
      if POSICAO > 0 .and. POSICAO < 34
         aMENU[ POSICAO ] := padr(DESCP,25)
         aMESS[ POSICAO ] := DESCM
      endif
      dbskip()
   enddo
   dbclosearea()
endif
while .T.
   MDI(" þ Vocˆ est  escolhendo o Cadastro para Altera‡„o")
   setcolor(ZCOR008)
   for X := 1 to 11
      OPCAO(X * 2+2,1," &"+ltrim(aMENU[X]),asc(left(alltrim(aMENU[X]),1)),aMESS[X])
   next X
   for X := 12 to 22
      OPCAO((X - 11) * 2+2,27," &"+ltrim(aMENU[X]),asc(left(alltrim(aMENU[X]),1)),aMESS[X])
   next X
   for X := 23 to 33
      OPCAO((X - 22) * 2+2,53," &"+ltrim(aMENU[X]),asc(left(alltrim(aMENU[X]),1)),aMESS[X])
   next X
   KEY := menu(1,2)
   if KEY > 0
      if !ENTMNU("A",KEY)
         loop
      endif
      ZGRUPO := OBTER("MANREG",KEY,"GRUPO")
   endif
   do case
      case KEY = 1
         M_AA(0)
      case KEY = 2
         PADRAO(0,1,0,"MB01","No.   Nome"+spac(37)+"Telefone",;
          "' '+STR(mNUMERO,  5)+' '+mCOGNOME+' '+SUBSTR(mNOME,1,40)+' '+mDDD+' '+mTELEFONE",;
          "MAB","MAB001",{|| mabget()},{|| PADCGC("MB01",ZIMB)})

         //                para wPAD, wpPAD, wcPAD, wARQ, wCAB, wSRO, wACOR, wBTEL, wBGET,;
         ///     wBINS, wBMON, wBKEY, wBIGU,wBSAY, lPADCRI, bPOSREP,;
         //     ePAD3, bDEL, pPAD, lpINS,eFILTRO


      case KEY = 3
         AUTOMENU(" þ Vendedores/Compradores","MAC",24,"MANSUB")
      case KEY = 4
         M_AD("")
      case KEY = 5
         AUTOMENU(" þ Cadastro de Equipamentos","E",24)
      case KEY = 6
         AUTOMENU(" þ Cadastro de Bancos ","F",24)
      case KEY = 7
         AUTOMENU(" þ Cadastro de Transportadoras ","G",24)
      case KEY = 8
         AUTOMENU(" þ Cadastro de Zonas ","H",24)
      case KEY = 9
         AUTOMENU(" þ Planos de Contas ","I",24)
      case KEY = 10
         PADRAO(0,1,0,"MJ01","C¢digo - Descri‡„o","' '+mNUMERO+' '+mNOME","MAJ")
      case KEY = 11
         nREF := 1  //Nota Fiscal de Compras Nao Apagar  Linha
         AUTOMENU(" þ Notas Fiscal de Compras ","K",24)
         //       M_AK0()
      case KEY = 12
         AUTOMENU(" þ Contas a Pagar ","L",24)
      case KEY = 13
         nREF := 2  //Nota Fiscal Vendas Nao Apagar Linha
         AUTOMENU(" þ Notas Fiscal de Vendas ","M",24)
      case KEY = 14
         AUTOMENU(" þ Contas a Receber ","N",24)
      case KEY = 15
         AUTOMENU(" þ Pedidos ","O",24)
      case KEY = 16
         AUTOMENU(" þ Cadastro de Mao de Obra ","P",24)
      case KEY = 17
         M_AU0("MQ01","MQ02","MQ03","MQ03BX","Q3","MQ04","Q4","MQ99","MQ01I","MAQ","Q")
      case KEY = 18
         M_AU0("MR01","MR02","MR03","MR03BX","R3","MR04","R4","MR99","MR01I","MAR","R")
      case KEY = 19
         M_AS(0)
      case KEY = 20
         M_AU0("MT01","MT02","MT03","MT03BX","T3","MT04","T4","MT99","MT01I","MAT","T")
      case KEY = 21
         M_AU0("MU01","MU02","MU03","MU03BX","U3","MU04","U4","MU99","MU01I","MAU","U")
      case KEY = 22
         M_AV(0)
      case KEY = 23
         priv XESTQINI
         priv xDATABALAN
         AUTOMENU(" þ Compras  ","W",24)
      case KEY = 24
         M_AX(0)
      case KEY = 25
         AUTOMENU(" þ Requisicoes  ","Y",24)
      case KEY = 26
         MANEMP(0)
      case KEY = 27
         M_A1(0)
      case KEY = 28
         AUTOMENU(" þ Produtos PCP  ","2",24)
      case KEY = 29
         AUTOMENU(" þ Mail ","3",24)
      case KEY = 30
         M_A4(0)
      case KEY = 31
         AUTOMENU(" þ Cadastro Fiscais ","5",24)
      case KEY = 32
         AUTOMENU(" þ Cadastro Informe Rendimentos ","6",24)
      case KEY = 33
         AUTOMENU(" þ Faturamento ","7",24)
      otherwise
         retu
   endcase
enddo

// *****Chamadas Com Macro

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MACR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MACR()

PADRAO(0,1,0,"MC01R","No.   Nome"+spac(37)+"Telefone","' '+STR(mNUMERO,  5)+' '+mCOGNOME+' '+SUBSTR(mNOME,1,40)+' '+mDDD+' '+mTELEFONE","MAB",,,{|| PADCGC("MC01R",2)})
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function mabget()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func mabget()

LOCAL aERRO,xPOS,nTOTCAM,campo,mCAMPO
EDITSAY("MAB001")
IF cVIDE = "T"
   DBSELECTAR("MB01")
   nTOTCAM := fcount()
   for XPOS := 1 to nTOTCAM
      CAMPO  := field(XPOS)
      mCAMPO := "m"+CAMPO
      eMB01C := TRIM(StrVAL(&CAMPO.))
      eMB01V := TRIM(StRVAL(&mCAMPO.))
      IF !EMPTY(eMB01C) .AND. AT("PCP",CAMPO) = 0
         IF eMB01C <> eMB01V
            aERRO := {}
            AADD(aERRO,"Fornecedor: "+STrVAL(NUMERO))
            AADD(aERRO,"Campo     : "+Campo)
            AADD(aERRO,"Anterior  : "+eMB01C)
            AADD(aERRO,"Atual     : "+eMB01V)
            AADD(aERRO,"Usuario   : "+zUSER)
            EMAILINT("MAB00001",aERRO)
            //             ALERTX("Campo: "+Campo)
         ENDIF
      ENDIF
   next
ENDIF
