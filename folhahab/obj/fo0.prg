*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo0.prg
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
*+    Documentado em 27-Dez-2024 as  9:44 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :
// :        FO0.PRG: Destinado ao Cadastramento de Tabelas
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/07/94     14:09
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fo0()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fo0

PARA CCWORK
PRIV HELPDBF


WHILE .T.
   HELPDBF := "FO0"
   CABEX("Menu de Tabelas/Codigos")
   HB_dispbox(5,0,24,80,B_DOUBLE+" ")
   OPCAO(06,01," A - Ass. Medica             ",49)  //1
   OPCAO(07,01," B - Ass. Odonto.            ",50)  //2
   OPCAO(08,01," C - Arredondamento          ",51)  //3
   OPCAO(09,01," D - Notas Troco             ",52)  //4
   OPCAO(10,01," E - Tabela INSS             ",53)  //5
   OPCAO(11,01," F - Tabela IRRF             ",54)  //6
   OPCAO(12,01," G - Tipos de Reajuste       ",65)  //7
   OPCAO(13,01," H - Tipos de Turnos         ",66)  //8
   OPCAO(15,01," I - Ocorrencias             ",67)  //9
   OPCAO(16,01," J - Cod.Pagamentos INSS     ",69)  //10
   OPCAO(17,01," K - Codigos DARF IRRF       ",69)  //11
   OPCAO(18,01," L - Codigo GR FGTS          ",70)  //12
   OPCAO(19,01," M - Tabelas Diversas        ",71)  //13
   OPCAO(20,01," N - Alimentacao             ",72)  //14
   OPCAO(21,01," O - Codigos VT              ",73)  //15
   OPCAO(22,01," P - Orgao Emssissores Docum ",74)  //16
   OPCAO(23,01," Q - Cartorios/Serventias    ",75)  //17
   OPCAO(06,41," R - Cid Grupos                 ",76)   //18
   OPCAO(07,41," S - Cid                        ",77)   //19
   OPCAO(08,41," T - Medicamentos tipos/grupo   ",78)   //20
   OPCAO(09,41," U - Medicamentos               ",79)   //21
   OPCAO(10,41," V - esocial tab13 Parte corpo atingida         ",80)   //22
   OPCAO(11,41," W - esocial tab14  Agente causador             ",81)   //23
   OPCAO(11,41," X - esocial tab16 Situação Geradora            ",82)   //24
   OPCAO(12,41," Y - agentes doenca profissional                 ",83)  //25 MedAgDP.dbf agentes doenca profissional
   OPCAO(13,41," Z - monitoramento biologico angentes quimicos ",84)  //26 MEDmaq.dbf monitoramento biologico angentes quimicos
   OPCAO(14,41," 0 - monitoramento biologico biologico          ",48)   //27 medmmb.dbf monitoramento biologico biologico
   OPCAO(15,41," 1 - monitoramento biologico resultados         ",49)   //esocial_tab07  monitoramento biologico resultados
   OPCAO(16,41," 2 - natureza da lesao                            ",50)   //29 MedNatLesao.dbf natureza da lesao
   OPCAO(17,41," 3 - risco ocupacionais                           ",51)   //30 MeDRisOcu.dbf risco ocupacionais


   ARQ     := MENU(,0)
   HELPDBF := "FO0"+STRZERO(ARQ,2)
   IF ARQ = 0
      RETU
   ENDIF
   DO CASE
   CASE ARQ = 1   //a
      FOPTO_4C("ASSMED","TABMED")
   CASE ARQ = 2   //b
      FOPTO_4C("ASSODO","TABODO")
   CASE ARQ = 3   //c
      FOPTO_4C("TABARRE","TABRRE")
   CASE ARQ = 4   //d
      HELPDBF := "FO07"
      FOPTO_4C("TABTROCO","TABTRO")
   CASE ARQ = 5   //e
      PADRAO("TABINSS","TABINSS","' '+STR(mNMES,2)+' '+mEMES","mNMES","Tabelas Inss","Mes",;
       {|| ALERTX("Sem Inclusao")},"TBINSS","TBINSS",{|| FO_FOR("GRUPO='TABELAS'")})
   CASE ARQ = 6   //f
      FO0J()
   CASE ARQ = 7   //g
      PADRAO("TABREAJ","TABREAJ","' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(2),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='TABREAJ'")})
   CASE ARQ = 8   //h
      FOPTO_4F()
   CASE ARQ = 9   //i
      FOPTO_4A()
   CASE ARQ = 10  //j
      PADRAO('TBCODPG','TBCODPG',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(4),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='TBCODPG'")})
   CASE ARQ = 11  //k
      PADRAO("CODIRRF","CODIRRF","' '+mCODIGO+' '+LEFT(mNOME,60)+' '","mCODIGO","Codigos DARF IRRF","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(4),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='CODIRRF'")})
   case ARQ = 12  //l
      PADRAO("CODFGTS","CODFGTS","' '+mCODIGO+' '+LEFT(mNOME,60)+' '","mCODIGO","Codigos GR FGTS","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(3),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='CODFGTS'")})
   CASE ARQ = 13  //m
      PADRAO("FO_TAB","FO_TAB","' '+mTABELA+' '+mCODIGO+' '+LEFT(mDESCRI,60)","mTABELA+mCODIGO","Tabelas Auxiliares","Codigo Nome"+spac(37)+"Telefone",;
       {|| iFO0N()},"FO_TAB","FO_TAB",{|| FO_FOR("GRUPO='FO_TAB'")})
   CASE ARQ = 14  //n
      FOPTO_4C("FOPTOALM","PONTOCAD05")
   CASE ARQ = 15  //o
      PADRAO("VTCONTA","VTCONTA","' '+STR(mCODIGO)+' '+mDESCR+' '+DTOC(mDATAATU)+' '+STR(mVALOR, 10, 2)","mCODIGO","Codigos Vale Transporte","Cod  Descricacao"+spac(20)+"Atualiz. Valor",;
       {|| PEGCHAVE("mCODIGO",ULTIMOREG("VTCONTA","CODIGO",.T.),"Numero")},"VTCTA","VTCTA",{|| FO_RELL("TABTRANS")})
   CASE ARQ = 16  //p
      PADRAO('ORGEMISS','ORGEMISS',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(4),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='ORGEMISS'")})
   CASE ARQ = 17  //q
      MESTADO := ""
      MCIDADE := ""
      PADRAO('CARTORIO','CARTORIO',"' '+mCODIGO+' '+mIBGE+' '+mNOME+' '","mCODIGO","Codigos","Codigo CidIbge Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(4),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='CARTORIO'")})

   CASE ARQ = 18  //R
      PADRAO('CIDGRUPO','CIDGRUPO',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(4),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='CIDGRUPO'")})

   CASE ARQ = 19  //S
      PADRAO('CID','CID',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(4),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='CID'")})
   CASE ARQ = 20  //T
      PADRAO('medicgrp','medicgrp',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(4),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='medicgrp'")})
   CASE ARQ = 21  //U
      ALERTX("medicamentos em implantação")
   CASE ARQ = 22  //V
      PADRAO('ESOCIAL_TAB13','ESOCIAL_TAB13',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(10),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='ESOCIAL_TAB13'")})
   CASE ARQ = 23  //W
      PADRAO('MEDTAB14','MEDTAB14',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(10),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='MEDTAB14'")})
   CASE ARQ = 24  //X
      PADRAO('ESOCIAL_TAB16','ESOCIAL_TAB16',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(10),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='ESOCIAL_TAB16'")})
   CASE ARQ = 25  // y
      PADRAO('ESOCIAL_TAB15','ESOCIAL_TAB15',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(9),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='ESOCIAL_TAB15'")})
   CASE ARQ = 26  // z
      PADRAO('MEDmaq','MEDmaq',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(2),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='MEDmaq'")})
   CASE ARQ = 27  // 0
      PADRAO('medmmb','medmmb',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(1),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='medmmb'")})
   CASE ARQ = 28  // 1
      PADRAO('esocial_tab07','esocial_tab07',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(4),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='esocial_tab07'")})
   CASE ARQ = 29  // 2
      PADRAO('MedNatLesao','MedNatLe',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(9),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='MedNatLe'")})
   CASE ARQ = 30  // 3
      PADRAO('Mesocial_tab21','esocial_tab21',"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
       {|| PEGCHAVE("mCODIGO",SPACE(6),"Codigo:")},{|| tFO0I()},{|| gFO0I()},{|| FO_FOR("GRUPO='esocial_tab21'")})



   ENDCASE
ENDDO






*+--------------------------------------------------------------------
*+
*+
*+
*+    Function iFO0N()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION iFO0N

MDS('Digite Tabela Itens da Tabela ?')
@ 24,30 get mTABELA         
@ 24,40 get mCODIGO         
READCUR()
mCHAVE := mTABELA+mCODIGO
RETU .T.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFO0I()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION gFO0I()

@ 24,01      SAY "Codigo"                    
@ 24,COL()+1 SAY mCODIGO                     
@ 24,COL()+1 SAY "NOME"                      
@ 24,COL()+1 GET mNOME    PICT "@S40"        
IF ARQ = 12
   @ 24,COL()+1 GET mVALPESSOA         
ENDIF
IF ARQ = 17
   ALLTRUE(CHECKCID(,,.F.,mIBGE,{{"UF","mESTADO"},{"NOME","mCIDADE"}}))
   @ 24,COL()+1 GET mIBGE   valid ALLTRUE(CHECKCID(,,.F.,mIBGE,{{"UF","mESTADO"},{"NOME","mCIDADE"}}))                                                                                                                                           
   @ 24,COL()+1 GET mESTADO WHEN EMPTY(mIBGE)                                                          PICT "!!"                                                  VALID CHECKTAB(PADR("UF",4)+PADR(mESTADO,5),24,0,"Estado Nao Cadastrado")      
   @ 24,COL()+1 GET mCIDADE WHEN EMPTY(mIBGE)                                                          VALID CHECKCID(mESTADO,mCIDADE,.T.,,{{"CODIBGE","mIBGE"}})                                                                                
ENDIF
IF ARQ = 19
   @ 24,COL()+1 GET mGRUPO         
ENDIF
READCUR()
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFO0I()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION tFO0I()

@ 24,01      SAY "Codigo"               
@ 24,COL()+1 SAY mCODIGO                
@ 24,COL()+1 SAY "NOME"                 
@ 24,COL()+1 SAY LEFT(mNOME,40)         
RETU .T.


// : FIM: FO0.PRG

*+ EOF: fo0.prg
*+
