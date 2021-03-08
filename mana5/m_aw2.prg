*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aw2.prg
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


PADRAO(1,1,0,cMW02,"Pedido   Ite Requisi  Codigo"+spac(25)+"Quantidade",;
 "' '+STR(mCOMPED,8)+' '+STR(mITEM,3)+' '+STR(mITEREC,8)+' '+mITENOM+' '+STR(mITEQTD,12,3)",;
 "MAW2",,,{|| MAW2INC()},{|| PADARR(cMW02,str(xCOMPED,8),"COMPED","xCOMPED")},,,,,;
 {|| MAW2REP()},,{|| MAW2DEL()},,.F.)





*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW2INC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW2INC


mCOMPED := xCOMPED
ULTIMOITEM(cMW02,str(xCOMPED,8),"COMPED","XCOMPED","ITEM","mITEM",.T.)
MDS("Digite o ITEM")
@ 24,20 GET mITEM VALID mITEM > 0 .AND. mITEM < 999        
READCUR()
mCHAVE := STR(mCOMPED,8)+STR(mITEM,3)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW2REP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW2REP


local cNORMA
if INCLUI .and. !empty(mITEREC)
   GRAVAMVAR("MW04",mITEREC,{"RELQTDP","RELQTDS"},{"RELQTDP+mITEQTD","RELQTDI-RELQTDP"})
   if IGUALVARS("MW04",mITEREC)
      if mRELQTDS <= 0
         APAGAREG("MW04",mITEREC,.F.,.F.)
      endif
      mRECPED  := mCOMPED
      mRECPI   := mITEM
      mRECPD   := ZDATA
      mRELQTDI := mRELQTDS+mITEQTD
      mRELQTDP := mITEQTD
      NOVOREG("MW04PG",str(mITEREC,8)+str(mCOMPED,8)+str(mITEM,3))
   endif
endif
//MW08CHK01() //Checar Precos
//movido posrep m_aw.prg funcao MAW01
IF MDG("Rever Programacao de Entrega")
   xITEM   := mITEM
   xITECOD := mITECOD
   PADRAO(0,1,0,cMW03,"Pedido   Itp Ite Entregar Fornecedor"+spac(12)+"Codigo"+spac(7)+"Saldo",;
    "' '+STR(mCOMPED,  8)+' '+STR(mITEM,  3)+' '+STR(mITEENT,  3)+' '+DTOC(mDATENT)+' '+STR(mCOMFOR,  8)+' '+mCOMCOG+' '+mITECOD+' '+STR(mQTDSAL, 12, 3)",;
    "MAW3",,,{|| MAW301()},{|| PADARR(cMW03,str(xCOMPED,8)+str(xITEM,3),"STR(COMPED,8)+STR(ITEM,3)","STR(xCOMPED,8)+STR(xITEM,3)")},,,,,{|| MAW3REP()})
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW301()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW301


mCOMPED := xCOMPED
mITEM   := xITEM
mITECOD := xITECOD
mCOMFOR := xCOMFOR
mCOMCOG := xCOMCOG
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW3REP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW3REP  //Nao Apagar Uso Especial


retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW201()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW201


do case
   case mITETIP = "M"
      PEGACAMPO("MU01","mITECOD",{"PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)","CTACONTB","UNIDADE","CODMW"},{"mITENOM","mITECTA","mITEUNI","mCODMW"})
   case mITETIP = "C"
      PEGACAMPO("MT01","mITECOD",{"PADR(ALLTRIM(NOME)+' '+ALLTRIM(NOM2),200)","CTACONTB","UNIDADE"},{"mITENOM","mITECTA","mITEUNI"})
   case mITETIP = "O"
      PEGACAMPO("MW05","mITECOD",{"PADR(NOME,200)","CTACONTB","UNIDADE"},{"mITENOM","mITECTA","mITEUNI"})
   case mITETIP = "R"
      PEGACAMPO("MW07","mITECOD",{"PADR(NOME,200)","CTACONTB","UNIDADE"},{"mITENOM","mITECTA","mITEUNI"})
   case mITETIP = "I"
      PEGACAMPO("ME04","mITECOD",{"PADR(TRIM(TIPO)+' '+TRIM(MARCA)+' Cap.: '+TRIM(CAPACI)+' Div.: '+TRIM(DIVI),200)"},{"mITENOM"})
   case mITETIP = "T"
      PEGACAMPO("MP03","mITECOD",{"PADR(NOM2,200)","APLICACAO"},{"mITENOM","mITEO01"})
endcase
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW202()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAW202


priv cVAR1 := cVAR2 := "X"
if !empty(mITEREC)
   PEGACAMPO("MW04","mITEREC",{"LIRER","LICER"},{"cVAR1","cVAR2"})
   if cVAR1 = "X"
      ALERTX("Requisi‡„o N„o Cadastrada")
      retu .T.
   endif
   if cVAR1 # "S"
      ALERTX("Requisi‡„o N„o Liberada")
      retu .F.
   endif
   if cVAR2 # "S"
      ALERTX("Requisi‡„o N„o Checada Compras")
      retu .F.
   endif
endif
if INCLUI
   PEGACAMPO("MW04","mITEREC",{"RECTIP","RECCOD","RECNOM","RECNO2","RECDAT","RECUE","RECSOL","RECCTA","RELQTDS","RECUND","RECO01","RECO02","RECO03"},;
    {"mITETIP","mITECOD","mITENOM","mITENO2","mRECDAT","mITEUE","mITESOL","mCODDEP","mITEQTD","mITEUNI","mRECO01","mRECO02","mRECO03"})

endif
@ 14,1 SAY mRECO01         
@ 15,1 SAY mRECO02         
@ 16,1 SAY mRECO03         
if !INCLUI .and. !empty(mITEREC)
   if PEGACAMPO("MW04","mITEREC",{"RECCTR"},{"cVAR1"})
      cVAR2 := mITEREC
      if cVAR1 = "A"
         if MDG("Contrato Anual - Baixar Requisi‡„o")
            if IGUALVARS("MW04",cVAR2)
               if NOVOREG("MW04PG",cVAR2)
                  APAGAREG("MW04",cVAR2)
               endif
            endif
         endif
      endif
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAW2DEL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAW2DEL()

LOCAL aVAL
//ALERTX("Bloco Del")
//Apaga a Ultimo Preco Cadastro
GRAVAMVAR(ESTQARQ(mITETIP,1),mITECOD,{"ULTPRC","ULTUND","ULTDATA"},{"0","SPACE(2)","CTOD(SPACE(8))"})
//Apaga o Ultimo Preco MW08
IF USEREDE("MW08",1,99)
   DBSETORDER(4)  //Pedido
   DBGOTOP()
   DBSEEK(mCOMPED)
   WHILE mCOMPED = COMPED .AND. !EOF()
      IF mITEM = ITEM
         netrecdel()
      ENDIF
      DBSKIP()
   ENDDO
   aVAL := {0,"",ctod(space(8))}
   dbsetorder(2)  //Ultimo Preco Codigo
   dbselectar("MW08")
   dbgotop()
   dbseek(mITETIP+mITECOD)
   if ITETIP = mITETIP .and. alltrim(ITECOD) == ALLTRIM(mITECOD)
      aVAL := {ITEPRC,ITEUNI,DATA}
   ENDIF
   DBCLOSEAREA()
   IF aVAL[1] > 0
      MAWULTPRC(ESTQARQ(mITETIP,1),mITECOD,aVAL)
   ENDIF
ENDIF
RETU .T.

