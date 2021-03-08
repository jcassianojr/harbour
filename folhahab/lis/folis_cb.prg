*:*****************************************************************************
*:
*: FOLIS_CB.PRG  : Listar Resumo Rais Empresa Empregados
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"
IF ! MDL('Listar RAIS Resumo Empregados',0)
   RETU
ENDIF
CTLIN:=1
MESTADO:=""
MCIDADE:=""
MNESTADO:=""
MNCIDADE:=""
MPAIS   :=""


if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
FILTRO=''
INX    := ""
FILORD(.T.)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if valtype(INX)="N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF   
set filter to &FILTRO

IF ! NETUSE("FORAIS")
   DBCLOSEALL()
   RETU .F.
ENDIF

nVEZES=3
IMPRESSORA()
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   mNUMERO:=NUMERO
   ALLTRUE(CHECKCID(,,.F.,IBGE,{{"UF","mESTADO"},{"NOME","mCIDADE"}}))
   ALLTRUE(CheckBacen(NASCPAIS,mPAIS,.F.,{{"STRZERO(BACEN,4)","NACPAIS"},{"NOME","mPAIS"}}) )
   IF nVEZES=3
      CTLIN:=1
      @ CTLIN,  0 say Replicate("-", 80)
      nVEZES=1
   ELSE
      nVEZES=nVEZES+1
   ENDIF
   DBSELECTAR("FORAIS")
   DBGOTOP()
   IF ! DBSEEK(str(nanouso,4)+str(mNUMERO,8))
      netrecapp()
      field->numero:=mNUMERO
      field->ano   :=nanouso
   ENDIF
   
   CTLIN++
   @ CTLIN,  3 say "PIS/PASEP     : " + PIS
   @ CTLIN, 34 say "Nome: " + NOME
   CTLIN++
   @ CTLIN,  3 say "Cart.Profiss. : "+IF(left(TIRAOUT(CPF),7)=PROFIS,LEFT(TIRAOUT(CPF),7)+"/"+SUBSTR(TIRAOUT(CPF),8),PROFIS+"-"+SERIE+"/"+CTPSUF)    //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes 
   @ CTLIN, 35 say "CPF: " + CPF
   @ CTLIN, 54 say "Data Adm: "+DTOC(ADMITIDO)
   @ CTLIN, 73 say "Tipo: " + FORAIS->TIPOADM
   CTLIN++
   @ CTLIN,  3 say "Data Nascim.  : "+DTOC(NASC)
   @ CTLIN, 35 say "CBO:"+ OBTER("FUNCAO",,FO_PES->FUNCAO,"CBONEW") //CBONEW 
   @ CTLIN, 53 say "Vinculo: " + FORAIS->RAISVINC
   @ CTLIN, 68 say "Escolaridade: " + ESCRAIS
   CTLIN++
   IF EMPTY(DEMITIDO)
      tSAL="SALDEZ"
   ELSE
      MESDEM=MONTH(DEMITIDO)
      XSAL=MMES(MONTH(DEMITIDO))
      XSAL=SUBSTR(XSAL,1,3)
      tSAL='SAL'+XSAL
   ENDIF
   @ CTLIN,  3 say "Sal.Contrat. -> " + TRANS(&TSAL.,"@E 9999999999.99")
   @ CTLIN, 34 say "Tipo: " + TIPO + " HS sem: " + STR(HRSEM,5,2)
   @ CTLIN, 56 say "Dem-> " + FORAIS->RAISDEM + " Dia/Mes: " + substr(DTOC(DEMITIDO),1,5)
   CTLIN++
   @ CTLIN,  3 say "Opcao FGTS ---> " + IF(EMPTY(FGTS),"2","1") + "  Data: " + DTOC(FGTS)
   @ CTLIN, 42 say "Nacionalidade-> " + NASCPAIS + IF(NACPAIS<>"1058"," Ano Chegada: " + STR(ANONASCI,2)+' '+mPAIS,"")
   CTLIN++   
   DBSELECTAR("FORAIS")  
   
      @ CTLIN,  3 say "13.Sal.Adiant-> " + TRANS(SAL13_1,"@E 9999999.99")
      @ CTLIN, 33 say "Mes: " + STR(MES_1,2)
      @ CTLIN, 42 say "13 Parc.Final-> " + TRANS(SAL13_2,"@E 9999999.99")
      @ CTLIN, 72 say "Mes: " + STR(MES_2,2)
      CTLIN++
//      @ CTLIN, 30 say "Remuneracao em R$"
//      CTLIN++
      @ CTLIN,  3 say "Jan " + TRANSFORM(RAIZJAN,"@E 9999999.99")
      @ CTLIN, 20 say "Jul " + Transform(RAIZJUL,"@E 9999999.99")
      @ CTLIN, 40 say "Aviso  "+ Transform(RAIZAVI,"@E 9999999.99")
      CTLIN++
      @ CTLIN,  3 say "Fev " + Transform(RAIZFEV,"@E 9999999.99")
      @ CTLIN, 20 say "Ago " + Transform(RAIZAGO,"@E 9999999.99")
      @ CTLIN, 40 say "FerInd "+ Transform(RAIZFER,"@E 9999999.99")
      CTLIN++
      @ CTLIN,  3 say "Mar " + Transform(RAIZMAR,"@E 9999999.99")
      @ CTLIN, 20 say "Set " + Transform(RAIZSET,"@E 9999999.99")
      @ CTLIN, 40 say "Acresc "+ Transform(RAIZACR,"@E 9999999.99")
      @ CTLIN,  60 say MESACR
      CTLIN++
      @ CTLIN,  3 say "Abr " + Transform(RAIZABR,"@E 9999999.99")
      @ CTLIN, 20 say "Out " + Transform(RAIZOUT,"@E 9999999.99")
      @ CTLIN, 40 say "Gratif "+ Transform(RAIZGRA,"@E 9999999.99")
      @ CTLIN,  60 say MESGRA
      CTLIN++
      @ CTLIN,  3 say "Mai " + Transform(RAIZMAI,"@E 9999999.99")
      @ CTLIN, 20 say "Nov " + Transform(RAIZNOV,"@E 9999999.99")
      @ CTLIN, 40 say "MFgts  "+ Transform(RAIZMUL,"@E 9999999.99")
      CTLIN++
      @ CTLIN,  3 say "Jun " + Transform(RAIZJUN,"@E 9999999.99")
      @ CTLIN, 20 say "Dez " + Transform(RAIZDEZ,"@E 9999999.99")
      @ CTLIN, 40 say "BcoHrs "+ Transform(RAIZBCH,"@E 9999999.99")
      @ CTLIN,  60 say MESBCH
      CTLIN++
      @ CTLIN, 2 say "Confederativa CNPJ:"+CGCCON +" Valor:"+Transform(VALCON,"@E 9999999.99")
      CTLIN++
      @ CTLIN, 2 say "Associativa   CNPJ:"+CGCSOC1+" Valor:"+Transform(VALSOC1,"@E 9999999.99")
      CTLIN++
      @ CTLIN, 2 say "Assistencial  CNPJ:"+CGCASS +" Valor:"+Transform(VALASS,"@E 9999999.99")
      CTLIN++
      @ CTLIN, 2 SAY "Sindical      CNPJ:"+CGCSIN +" Valor:"+Transform(VALSIN,"@E 9999999.99")
      CTLIN++
   
   @ CTLIN,  0 say Replicate("-", 80)
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETU .T.
