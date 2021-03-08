*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ak2.prg
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

#INCLUDE "BOX.CH"

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_ak2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_ak2

PARA wMAK2,wpMAK2,wcMAK2,wMAK3
wMAK3 := 0

/* 3o. Paramentro
0 - Cria e Carrega as Matrizes
1 - N„o Cria e Carrega as Matrizes
2 - N„o Cria e N„o Carrega as Matrizes
*/
IF VALTYPE(wCMAK2) # "N"
   wcMAK2 := 0
ENDIF


//Teclas Operacionais
//#INCLUDE "TECLAS.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI(" Ý ",,,ARQWORK2)

//Configura‡„o de Trabalho
PRIV lFIXA,nACHO,cVIDE,lPBUS,lPIND,mCBAR,mCBARM,cTIPG,aGETS,cCBAS,nIBUS
PRIV nIEXI,aIND,nREG
IF !CONFARQ(ARQWORK2," T     Qtde   C¢digo      Nome                    Pre‡o Un.     Total Mercad.")
   RETU .F.
ENDIF
IF !CONFIND(ARQWORK2)
   RETU .F.
ENDIF


//Pegando Cores de Trabalho
CORMK2 := CORARR("MAK2")

//Variaveis de Trabalho
PRIV PCK       := .F.
PRIV mCHAVE
PRIV mOLDQTDDE


//ESCOLHA:=0

IF wMAK2 = 0
   CRIARVARS(ARQWORK2)
ENDIF

//CRIANDO MATRIZES
IF wcMAK2 = 0
   aMAK21 := {}   //Matriz com os dizeres do Achoice
   aMAK22 := {}   //Por N£mero da Nota Fiscal e N£mero do Fornecedor
   aMAK25 := {}   // Valor Total da Mercadoria
   aMAK26 := {}   // Valor Total do IPI
   aMAK27 := {}   // Valor Total da Nota Fiscal
   aMAK28 := {}   // Valor Total do ICMS
   aMAK29 := {}   // Valor Total da Base de Calculo do IPI
   aMAK30 := {}   // Valor Total da Base de Calculo do ICM
   aMAK31 := {}
   aMAK32 := {}
   aMAK33 := {}
   aMAK34 := {}
ENDIF

//Incializando a ajuda on Line
PRIV HELPDBF := "MK02"

//Carregando Matriz
IF cVIDE = "S" .AND. wcMAK2 # 2
   nIND := IF(lPIND,NUMIND(ARQWORK2),nIEXI)
   IF !USEREDE(ARQWORK2,1,1,"2")
      RETU
   ENDIF
   GRAF := LASTREC()
   IF GRAF > nACHO
      DBCLOSEAREA()
      ALERTX("Muitos Arquivos para o Modo Video")
      cVIDE := "N"
   ELSE
      xGRAF := 0
      xPOS  := 1
      MARCAR()
      DBGOTOP()
      DBSEEK(STR(mNRNOTA,8)+STR(mFORNECEDO,5))
      WHILE mNRNOTA = NRNOTA .AND. mFORNECEDO = FORNECEDO .AND. !EOF()
         IF !EMPTY(mCBAR)
            AADD(aMAK21,&mCBAR.)
         ELSE
            AADD(aMAK21,' '+STR(ITEM,2)+' '+TIPOENT+' '+STR(QTDE,14,4)+' '+CODIGO+' '+LEFT(NOME,20)+' '+STR(PRECO,16,4)+' '+STR(VALORMER,16,2))
         ENDIF
         AADD(aMAK22,STR(NRNOTA,8)+STR(FORNECEDO,5)+CODIGO+STR(ITEM,2))
         AADD(aMAK25,VALORMER)
         AADD(aMAK26,VALORIPI)
         AADD(aMAK27,VALORTOT)
         AADD(aMAK28,VALORICM)
         AADD(aMAK29,BASEIPI)
         AADD(aMAK30,BASEICM)
         AADD(aMAK31,ISENTAICM)
         AADD(aMAK32,OUTRAICM)
         AADD(aMAK33,ISENTAIPI)
         AADD(aMAK34,OUTRAIPI)
         xPOS ++
         MARCAR1()
         DBSKIP()
      ENDDO
      DBCLOSEAREA()
      IF xPOS = 1
         nSBAR := 0
         IF !fMAK2(1,0)
            RETU .F.
         ENDIF
      ENDIF
   ENDIF
ENDIF

//Posi‡„o Inicial do Ponteiro
IF PCOUNT() = 1
   pMAK2 := 1
ELSE
   pMAK2 := ASCAN(aMAK22,wpMAK2)
   pMAK2 := IF(pMAK2 = 0,1,pMAK2)
ENDIF

//Processando o M‚todo Escolhido
IF cVIDE = 'S'
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR := LEN(aMAK21)
   aSBAR := ScrollBarNew(03,79,23,,pMAK2)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMAK2,nSBAR,.T.)
   WHILE .T.
      mTOTMER    := 0.00
      mTOTIPI    := 0.00
      mTOTNF     := 0.00
      mTOTICM    := 0.00
      mTOTBIPI   := 0.00
      mTOTBICM   := 0.00
      mTOTISEICM := 0.00
      mTOTOUTICM := 0.00
      mTOTISEIPI := 0.00
      mTOTOUTIPI := 0.00
      FOR X := 1 TO LEN(aMAK27)
         mTOTMER    += aMAK25[X]
         mTOTIPI    += aMAK26[X]
         mTOTNF     += aMAK27[X]
         mTOTICM    += aMAK28[X]
         mTOTBIPI   += aMAK29[X]
         mTOTBICM   += aMAK30[X]
         mTOTISEICM += aMAK31[X]
         mTOTOUTICM += aMAK32[X]
         mTOTISEIPI += aMAK33[X]
         mTOTOUTIPI += aMAK34[X]
      NEXT X
      SETCOLOR(CORMK2[1])
      HB_DISPBOX(2,0,23,79,B_DOUBLE)
      @  3,1 SAY cCBAS                             
      @  4,0 SAY '+'+replicate('-',78)+'Ý'         
      MDS('Busca: ')
      ScrollBarUpdate(aSBAR,pMAK2,nSBAR,.T.)
      ScrollBarDisplay(aSBAR)
      pMAK22 := ACHOICE(05,01,22,78,aMAK21,,"ACHRETB",pMAK2)
      pMAK2  := IF(pMAK22 # 0,pMAK22,pMAK2)
      pMAK22 := pMAK2
      DO CASE
         CASE LASTKEY() = K_ESC
            EXIT
         CASE LASTKEY() = K_ALT_F10
            MDS('Imprimindo') 
            MANLISTA()
         CASE LASTKEY() = K_INS 
            MDS('Incluindo ') 
            fMAK2(1,pMAK2)
         CASE LASTKEY() = K_ENTER .AND. wMAK2 # 3 
            MDS('Alterando ') 
            fMAK2(2,pMAK2)
         CASE LASTKEY() = K_ENTER .AND. wMAK2 = 3 
            MDS('Escolhendo') 
            fMAK2(6,pMAK2) 
            RETU
         CASE LASTKEY() = K_DEL
            MDS('Excluindo ') 
            fMAK2(3,pMAK2)
         CASE LASTKEY() = K_CTRL_ENTER .OR. LASTKEY() = K_CTRL_F2  // CTRL+ENTER USO O aMAK21
            IF LASTKEY() = K_CTRL_ENTER
               PEGBUS()
            ELSE
               nIBUS   := IF(lPBUS,NUMIND(ARQWORK2),nIBUS)
               mCHABUS := PEGBUS(ARQWORK2,nIBUS)
               nREG    := REGBUS(ARQWORK2,nIBUS,mCHABUS)
            ENDIF
            pMAK2 := ASCAN(aMAK22,STR(mNRNOTA,8)+STR(mFORNECEDO,5)+mCODIGO+STR(mITEM,2))
            IF pMAK2 = 0
               ALERTX('Nao localizei o Registro Correspondente ....')
               pMAK2 := pMAK22
               LOOP
            ENDIF
         OTHERWISE 
            LOOP
      ENDCASE
   ENDDO
ENDIF


RETU .T.

// ****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fMAK2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC fMAK2(OPRMAK2,POSMAK2)   //INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ****************************************************************************
INCLUI := .F.
//Pegar a Chave de Busca
IF OPRMAK2 # 1
   IF cVIDE = 'S'
      mCHAVE := aMAK22[POSMAK2]
   ENDIF
   IF cVIDE = 'N'
      PEGBUS()
   ENDIF
ENDIF


//Opera‡„o de Exclus„o
IF OPRMAK2 = 3
   IF APAGAREG(ARQWORK2,mCHAVE)
      IF cVIDE = "S"
         aMAK21[POSMAK2] = ' '+STR(mNRNOTA,8)+STR(mFORNECEDO,5)+mCODIGO+STR(mITEM,2)+' - Registro Excluido / Apagado / Deletado'
      ENDIF
      PCK := .T.
      //      mOLDQTDDE := MAK2K06()
      //      MAK2K05("E")
      aMAK25[POSMAK2] = 0
      aMAK26[POSMAK2] = 0
      aMAK27[POSMAK2] = 0
      aMAK28[POSMAK2] = 0
      aMAK29[POSMAK2] = 0
      aMAK30[POSMAK2] = 0
      aMAK31[POSMAK2] = 0
      aMAK32[POSMAK2] = 0
      aMAK33[POSMAK2] = 0
      aMAK34[POSMAK2] = 0
   ENDIF
   RETU .T.
ENDIF

//Opera‡„o de Inclus„o
IF OPRMAK2 = 1
   mNRNOTA    := xNRNOTA
   mFORNECEDO := xFORNECEDO
   mTIPOSERV  := "1"
   mVALFRE    := 0
   mIPI       := 0
   mCODIPI    := ""
   mCLASSIPI  := ""
   //   mICM        := OBTER("MD05",mESTADO,"ALIQUOTA")
   mICM     := 0
   mCOMPRAS := 0
   mCOMITEM := 0
   mPRECO   := 0
   mITEM    := LEN(aMAK22)
   mITEM ++
   mSOMANF  := "S"
   mCONSUMO := "N"
   PDIPI(yCFONEW,"mCODICM","mDIPIPI","mDIPICM",,,2)
   PEGBUS()
   IF !NOVOREG(ARQWORK2,mCHAVE)
      RETU .F.
   ENDIF
   INCLUI := .T.
ENDIF



//IGUALAR mVARS
IF !IGUALVARS(ARQWORK2,mCHAVE)
   RETU .F.
ENDIF
xCODIPI    := mCODIPI
mNUMERO    := xNRNOTA
mDATA      := xDATA
mFORNECEDO := xFORNECEDO
mOPERACAO  := xOPERACAO
mCFONEW    := yCFONEW
mCFONEWB   := yCFONEWB
mSUBOPER   := ySUBOPER
mAPURA     := yAPURA
xVALORMER  := mVALORMER
xBASEICM   := mBASEICM
xBASEIPI   := mBASEIPI
xIPI       := mIPI
mCOGFOR    := mCOGNOME

//Vari veis de Referencias
xCODIGO := mCODIGO
yCODIGO := mCODIGO

//Funcoes de Ajustes
NFBAS(mVALFRE,mREDICM)
MAM201()
IF EMPTY(mCODDEP)   //Codigo Despesas Tenta Pedidos
   if !empty(mCOMPRAS)
      if !PEGACAMPO("MW02","STR(mCOMPRAS,8)+STR(mCOMITEM,3)",{"CODDEP"},{"mCODDEP"})
         PEGACAMPO("MW02BX","STR(mCOMPRAS,8)+STR(mCOMITEM,3)",{"CODDEP"},{"mCODDEP"})
      endif
   endif
ENDIF
IF EMPTY(mCODDEP)   //Codigo Despesas Pega Cabecario
   mCODDEP := mCOD
ENDIF
IF EMPTY(mCODPGMW)  //Condicao Pagamento Pedido
   if !empty(mCOMPRAS)
      if !PEGACAMPO("MW01","mCOMPRAS",{"COMCPAG"},{"mCODPGMW"})
         PEGACAMPO("MW01BX","mCOMPRAS",{"COMCPAG"},{"mCODPGMW"})
      endif
   endif
ENDIF



// Desenha a Tela
TELASAY(aMK2TEL)
// Get nas Menvars
EDITSAY(aMK2GET)



//Atualiza as Matrizes se nao for inclusao
IF cVIDE = 'S' .AND. OPRMAK2 # 1
   aMAK21[POSMAK2] = ' '+STR(mITEM,2)+' '+mTIPOENT+' '+STR(mQTDE,14,4)+' '+mCODIGO+' '+LEFT(mNOME,20)+' '+STR(mPRECO,16,4)+' '+STR(mVALORMER,16,2)
   aMAK22[POSMAK2] = STR(mNRNOTA,8)+STR(mFORNECEDO,5)+mCODIGO+STR(mITEM,2)
   aMAK25[POSMAK2] = mVALORMER
   aMAK26[POSMAK2] = mVALORIPI
   aMAK27[POSMAK2] = mVALORTOT
   aMAK28[POSMAK2] = mVALORICM
   aMAK29[POSMAK2] = mBASEIPI
   aMAK30[POSMAK2] = mBASEICM
   aMAK31[POSMAK2] = mISENTAIPI
   aMAK32[POSMAK2] = mOUTRAICM
   aMAK33[POSMAK2] = mISENTAIPI
   aMAK34[POSMAK2] = mOUTRAIPI
ENDIF

//Posiciona o Novo Elemento na Matriz
IF cVIDE = 'S' .AND. OPRMAK2 = 1
   nSBAR ++
   AADD(aMAK21,NIL)
   AADD(aMAK22,NIL)
   AADD(aMAK25,NIL)
   AADD(aMAK26,NIL)
   AADD(aMAK27,NIL)
   AADD(aMAK28,NIL)
   AADD(aMAK29,NIL)
   AADD(aMAK30,NIL)
   AADD(aMAK31,NIL)
   AADD(aMAK32,NIL)
   AADD(aMAK33,NIL)
   AADD(aMAK34,NIL)
   POSMAK2 := LEN(aMAK21)
   POSW    := 1
   IF POSMAK2 > 1
      FOR X := 1 TO POSMAK2 - 1
         mDARE := aMAK22[X]
         IF mCHAVE <= mDARE
            EXIT
         ENDIF
      NEXT
      POSW := X
   ENDIF
   AINS(aMAK21,POSW)
   AINS(aMAK22,POSW)
   AINS(aMAK25,POSW)
   AINS(aMAK26,POSW)
   AINS(aMAK27,POSW)
   AINS(aMAK28,POSW)
   AINS(aMAK29,POSW)
   AINS(aMAK30,POSW)
   AINS(aMAK31,POSW)
   AINS(aMAK32,POSW)
   AINS(aMAK33,POSW)
   AINS(aMAK34,POSW)
   aMAK21[POSW] = ' '+mTIPOENT+' '+STR(mQTDE,14,4)+' '+mCODIGO+' '+LEFT(mNOME,20)+' '+STR(mPRECO,16,4)+' '+STR(mVALORMER,16,2)
   aMAK22[POSW] = STR(mNRNOTA,8)+STR(mFORNECEDO,5)+mCODIGO+STR(mITEM,2)
   aMAK25[POSW] = mVALORMER
   aMAK26[POSW] = mVALORIPI
   aMAK27[POSW] = mVALORTOT
   aMAK28[POSW] = mVALORICM
   aMAK29[POSW] = mBASEIPI
   aMAK30[POSW] = mBASEICM
   aMAK31[POSW] = mISENTAICM
   aMAK32[POSW] = mOUTRAICM
   aMAK33[POSW] = mISENTAIPI
   aMAK34[POSW] = mOUTRAIPI
   pMAK2 := POSW
ENDIF

REPORVARS(ARQWORK2,mCHAVE)


//////////////////Grava Precos CRM e Requisicao
if mCRM > 0
   GRAVAMVAR("CRM",mCRM,"PRECONF","mPRECO")
ENDIF
//if mNUMMY04>0
//   GRAVAMVAR( "MY04", mNUMMY04, "PRCMK02", "mPRECO" )
//ENDIF
//////////////////

RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAK2A()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAK2A

IF mTIPOSERV = "3" .OR. mTIPOSERV = "4" .OR. mTIPOSERV = "6"
   PRIV GETLIST := {}
   TELAOLD := SAVESCREEN(06,12,11,66)
   HB_DISPBOX(6,12,11,66,B_DOUBLE)
   @  7,31 SAY "Devolu‡”es"                                           
   @  8,18 SAY "Nota"+spac(6)+"Data"+spac(6)+"Qtdde    Valor"         
   @  9,14 SAY "1¦"                                                   
   @ 10,14 SAY "2¦"                                                   
   @  9,18 GET mNOTA_DEV                                              
   @  9,28 GET mDATA_DEV                                              
   @  9,38 GET mQTDE_DEV                                              
   @  9,47 GET mVALD_DEV                                              
   @ 10,18 GET mNOTA_DEV2                                             
   @ 10,28 GET mDATA_DEV2                                             
   @ 10,38 GET mQTDE_DEV2                                             
   @ 10,47 GET mVALD_DEV2                                             
   READCUR()
   RESTSCREEN(06,12,11,66,TELAOLD)
   SETCURSOR(IF(READINSERT(),1,2))
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAK299()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAK299

lOCAL cOPER := LEFT(mOPERACAO,3)
IF (cOPER = "111" .OR. cOPER = "131" .OR. cOPER = "231" .OR. cOPER = "211") .AND. EMPTY(mCLASSIPI)
   ALERTX("Classificacao Fiscal em Branco")
ENDIF
RETU .T.
