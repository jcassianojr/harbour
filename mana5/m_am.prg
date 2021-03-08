*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_am.prg
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
*+    Function m_am()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_am

PARA nTIPO

ARQWORK1  := "MM01"
ARQWORK2  := "MM02"
ARQWORK4  := "MM06"
ARQWORK5  := "MN01"
cTRABALHO := "NOTAFISCAL"

IF nTIPO = 2
   cVAR     := MESANO()
   ARQWORK1 := "M1"+cVAR
   ARQWORK2 := "M2"+cVAR
   ARQWORK4 := "M6"+cVAR
   ARQWORK5 := "MN"+cVAR
ENDIF

IF nTIPO = 3
   ARQWORK1 := "MM91"
   ARQWORK2 := "MM92"
   ARQWORK4 := "MM96"
   ARQWORK5 := "MN99"
ENDIF


PRIV wMAM,wpMAM,wcMAM

wMAM  := 0
wcMAM := 0
wPMAM := 1



//Teclas Operacionais
//#INCLUDE "TECLAS.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI(" Ý ",,,ARQWORK1)

//Configura‡„o de Trabalho
PRIV lFIXA,nACHO,cVIDE,lPBUS,lPIND,mCBAR,mCBARM,cTIPG,aGETS,cCBAS,nIBUS
PRIV nIEXI,aIND,nREG
IF !CONFARQ(ARQWORK1,"Nota    Emiss„o F Fornecedor"+spac(9)+"S Ope P S Pag  Valor Total da NF")
   RETU .F.
ENDIF
IF !CONFIND(ARQWORK1)
   RETU .F.
ENDIF


//Pegando Cores de Trabalho
CORMAM := CORARR("MAM")

//Variaveis de Trabalho
PRIV PCK    := .F.
PRIV mCHAVE
ZESTADO := OBTER("MANEMP",ZNUMERO,"ESTADO")
mESTADO := ""
IF wMAM = 0
   CRIARVARS("MA01")
   CRIARVARS("MN01")
   CRIARVARS(ARQWORK1)
   CRIARVARS(ARQWORK2)
ENDIF
//CRIANDO MATRIZES
IF wcMAM = 0
   aMAM1 := {}  //Matriz com os dizeres do Achoice
   aMAM2 := {}  //Por N£mero da Nota Fiscal
ENDIF


//Telas de Trabalho
aMAMTEL := TELAPEG("MAM001")
aMAMGET := EDITPEG("MAM001")

//Incializando a ajuda on Line
PRIV HELPDBF := "MM01"

//Carregando Matriz
IF cVIDE = "S" .AND. wcMAM # 2
   nIND := IF(lPIND,NUMIND(ARQWORK1),nIEXI)
   IF !USEREDE(ARQWORK1,1,1)
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
      dbgotop()
      WHILE !EOF()
         IF !EMPTY(mCBAR)
            AADD(aMAM1,&mCBAR.)
         ELSE
            AADD(aMAM1,' '+STR(NUMERO,8)+' '+DTOC(DATA)+' '+TIPOCLI+' '+STR(FORNECEDO,5)+' '+COGNOME+' '+OPERACAO+' '+CONDPAG+' '+STR(TOTNF,18,2))
         ENDIF
         AADD(aMAM2,NUMERO)
         xPOS ++
         MARCAR1()
         DBSKIP()
      ENDDO
      DBCLOSEAREA()
      IF xPOS = 1
         IF !mdg('Nenhum Lan‡amento Neste Arquivo Deseja Incluir')
            RETU .F.
         ENDIF
         nSBAR := 0
         IF !fMAM(1,0)
            RETU .F.
         ENDIF
      ENDIF
   ENDIF
ENDIF

//Posi‡„o Inicial do Ponteiro
IF PCOUNT() = 1
   pMAM := 1
ELSE
   pMAM := ASCAN(aMAM2,wpMAM)
   pMAM := IF(pMAM = 0,1,pMAM)
ENDIF

//Processando o M‚todo Escolhido
IF cVIDE = 'S'
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR := LEN(aMAM1)
   aSBAR := ScrollBarNew(03,79,23,SUBSTR(CORMAM[1],RAT(",",CORMAM[1])+1),pMAM)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMAM,nSBAR,.T.)
   WHILE .T.
      SETCOLOR(CORMAM[1])
      HB_DISPBOX(2,0,23,79,B_DOUBLE)
      @  3,1 SAY cCBAS                        
      @  4,0 SAY '+'+repl('-',78)+'Ý'         
      MDS('Busca: ')
      SETCOLOR(CORMAM[1])
      ScrollBarUpdate(aSBAR,pMAM,nSBAR,.T.)
      ScrollBarDisplay(aSBAR)
      pMAM2 := ACHOICE(05,01,22,78,aMAM1,,"ACHRETB",pMAM)
      pMAM  := IF(pMAM2 # 0,pMAM2,pMAM)
      pMAM2 := pMAM
      DO CASE
         CASE LASTKEY() = K_ESC
            IF mdg('Encerrar Consulta')
               EXIT
            ENDIF
            LOOP
         CASE LASTKEY() = K_ALT_F10 
            MDS('Imprimindo') 
            fMAM(7,pMAM)
         CASE LASTKEY() = K_INS
            MDS('Incluindo ') 
            fMAM(1,pMAM)
         CASE LASTKEY() = K_ENTER .AND. wMAM # 3 
            MDS('Alterando ') 
            fMAM(2,pMAM)
         CASE LASTKEY() = K_ENTER .AND. wMAM = 3 
            MDS('Escolhendo') 
            fMAM(6,pMAM) 
            RETU
         CASE LASTKEY() = K_DEL 
            MDS('Excluindo ') 
            fMAM(3,pMAM)
         CASE LASTKEY() = K_CTRL_ENTER
            nIBUS   := IF(lPBUS,NUMIND(ARQWORK1),nIBUS)
            mCHABUS := PEGBUS(ARQWORK1,nIBUS)
            IF nIBUS # 1
               nREG := REGBUS(ARQWORK1,nIBUS,mCHABUS)
            ENDIF
            pMAM := ASCAN(aMAM2,mCHAVE)
            IF pMAM = 0
               ALERTX('Nao localizei o Registro Correspondente ....')
               pMAM := pMAM2
               LOOP
            ENDIF
         OTHERWISE 
            LOOP
      ENDCASE
   ENDDO
ENDIF
IF cVIDE = 'N'
   METNVI(ARQWORK1,{|| fMAM(1,0)},{|| fMAM(3,0)},{|| fMAM(2,0)},;
    {|| fMAM(6,0)},{|| fMAM(2,- 1)},CORMAM[1],wMAM)
ENDIF
IF cVIDE = 'P'
   METPAG(ARQWORK1,CORMAM,"mNUMERO",wMAM,;
    {|| TELASAY(aMAMTEL)},{|| fMAM(1,0)},{|| fMAM(3,0)},{|| fMAM(2,0)},;
    {|| fMAM(6,0)})
ENDIF

IF cVIDE = 'I'
   METINT(ARQWORK1,,{|| fMAM(2,- 1)})
ENDIF

IF wMAM = 0
   //LIBERA VARIAVEIS
   RELEASE ALL LIKE m *
ENDIF

//EFETUA O PACK SE NECESSARIO
IF PCK .AND. lFIXA
   FIXAR(ARQWORK1)
   FIXAR(ARQWORK2)
ENDIF
RETU .T.

// ******************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fMAM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC fMAM(OPRMAM,POSMAM)  //INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ******************
//Pegar a Chave de Busca
INCLUI := .F.
IF OPRMAM # 1
   IF cVIDE = 'S'
      mCHAVE := aMAM2[POSMAM]   //STR(NUMERO,8)+STR(FORNECEDO,5)=aMAM2[POSMAM]
   ENDIF
   IF cVIDE = 'N' .AND. POSMAM # - 1
      PEGBUS(ARQWORK1,1)
   ENDIF
ENDIF


//Opera‡„o de Inclus„o
IF OPRMAM = 1
   CRIARVARS(ARQWORK1)
   mNUMERO := ULTIMOREG(ARQWORK1,"NUMERO")
   mNUMERO ++
   PEGBUS(ARQWORK1,1)
   //Salva Chave de Referencia
   xNUMERO := mNUMERO
   //Zera Variaveis
   CRIARVARS(ARQWORK1,.F.)
   //Volta Chave de Referencia
   mNUMERO := xNUMERO
   mCHAVE  := mNUMERO
   //Marca Valores Pre definidos
   mTIPOCLI  := 'C'
   mSETOR    := 'C'
   mOPERACAO := '511'
   mCFONEW   := "5101"
   mTIPOENT  := 'P'
   mSITUACAO := '1'
   mDATA     := ZDATA
   mTIPONF   := "S"
   mTIPOFR   := "1"
   IF !NOVOREG(ARQWORK1,mCHAVE)
      RETU .F.
   ENDIF
   INCLUI := .T.
ENDIF

//IGUALAR mVARS
IF !IGUALVARS(ARQWORK1,mCHAVE)
   RETU .F.
ENDIF
TIPCAD(mTIPOCLI,"ARQUSO")
MAMK01(5,23)


IF OPRMAM = 7
   yNOTA := mCHAVE
   IF mTIPOCLI = "F"
      xARQTEMP := "MB01"
   ELSE
      xARQTEMP := "MA01"
   ENDIF
   M_A7I()
   RETU .T.
ENDIF

//Ajusta em Branco
IF EMPTY(mTIPOCLI)
   mTIPOCLI := "C"
ENDIF
IF EMPTY(mESPECIE)
   mESPECIE := "NF   "
ENDIF
IF EMPTY(mSERIE)
   mSERIE := "UN   "
ENDIF
IF EMPTY(mMODELO)
   mMODELO := "01"
ENDIF
IF EMPTY(mAPURA)
   mAPURA := "S"
ENDIF


//Guarda Variaveis de Referencia arquivo MM02
xNUMERO    := mNUMERO
xDATA      := mDATA
xFORNECEDO := mFORNECEDO
xOPERACAO  := mOPERACAO
xORDEM     := mORDEM
ySUBOPER   := mSUBOPER


//Opera‡„o de Exclus„o
IF OPRMAM = 3
   mVENCIMENT := mDATA  //Jogar Data Emiss„o NF (MM01) em Data Vencimento (MN01)
   IF APAGAREG(ARQWORK1,mCHAVE)
      IF cVIDE = "S"
         aMAM1[POSMAM] = ' '+STR(mNUMERO,8)+' '+STR(mFORNECEDO,5)+' - Registro Excluido / Apagado / Deletado'
      ENDIF
      //Apagando os itens deste Pedido
      PADDEL(ARQWORK2,STR(mNUMERO,8),"mNUMERO","NUMERO")
      PCK    := .T.
      aDATAS := {mDAT01,mDAT02,mDAT03,mDAT04,mDAT05,;
       mDAT06,mDAT07,mDAT08,mDAT09,mDAT10}
      FOR W := 1 TO 10
         IF !EMPTY(aDATAS[W])
            mTIPFAT := CHR(64+W)
            APAGAREG(ARQWORK1,DTOS(aDATAS[W])+STR(mNUMERO,8)+mTIPFAT,.F.)
         ENDIF
      NEXT
   ENDIF
   RETU .T.
ENDIF

//Data Antiga
aDATOLD := {mDAT01,mDAT02,mDAT03,mDAT04,mDAT05,mDAT06,mDAT07,mDAT08,mDAT09,mDAT10}

//Metodo de Edi‡„o
IF cTIPG = "1"
   // Desenha a Tela
   TELASAY(aMAMTEL)
   // Get nas Menvars
   EDITSAY(aMAMGET)
ELSE
   EDITGET(.T.,CORMAM)
ENDIF

//Guarda Variaveis de Referencia arquivo MM02
yNUMERO    := mNUMERO
yDATA      := mDATA
yFORNECEDO := mFORNECEDO
yOPERACAO  := mOPERACAO
yAPURA     := mAPURA
yESPECIE   := mESPECIE


//Itens da Nota Fiscal
IF EMPTY(mESTADO)
   mESTADO := OBTER(ARQUSO,mFORNECEDO,"ESTADO")
ENDIF
M_AM2(1)


//Calculando Parcelas
IF EMPTY(mVAL01)
   MPAGAR(mCONDPAG,mTOTNF,mDATA,.T.)
ENDIF

//Checando Parcelas
CHECKPAR(,"2","mNUMERO")

IF ARQWORK1 = "MM01" .AND. MDG("Deseja Transferir Contas a Receber")
   // Transferˆncia de Dados para o Contas a Pagar (MM01).
   yNUMERO   := mNUMERO   //Salva vari veis NUMERO e DATA do MM01.
   yDATA     := mDATA
   yPEDIDO   := mPEDIDO
   ySITUACAO := mSITUACAO
   mSITUACAO := 0
   mPEDIDO   := 0
   aDATAS    := {mDAT01,mDAT02,mDAT03,mDAT04,mDAT05,;
       mDAT06,mDAT07,mDAT08,mDAT09,mDAT10}
   aVALOR := {mVAL01,mVAL02,mVAL03,mVAL04,mVAL05,;
    mVAL06,mVAL07,mVAL08,mVAL09,mVAL10}
   mNRNOTA  := mNUMERO
   mCLIENTE := mFORNECEDO
   mTOTFAT  := mTOTNF
   IF mTIPOCLI = "C"
      PEGACAMPO(ARQUSO,"mFORNECEDO",{"DDD","TELEFONE","CODCONC"},{"mDDD","mTELEFONE","mCODCONC"})
      mPREVATR := OBTER("MD02",PADR("CONCEITO",12)+PADR(mCODCONC,12),"VARIACAO")
   ELSE
      PEGACAMPO(ARQUSO,"mFORNECEDO",{"DDD","TELEFONE"},{"mDDD","mTELEFONE"})
   ENDIF
   MDS("Aguarde Transferencia Contas a Receber")
   WHILE !USEREDE("MN01",1,99)
   ENDDO
   FOR W := 1 TO 10
      mTIPFAT    := CHR(64+W)   //Tipo do Faturamento (A,B,C...)
      mVENCIMENT := aDATAS[W]
      mVALOR     := aVALOR[W]
      yDAT       := aDATOLD[W]
      DO CASE
            // Zerou valor ou data Apaga o Lan‡amento Buscando Pela Data Anterior
         CASE mVALOR = 0 .OR. EMPTY(mVENCIMENT)
            DELEREG(,DTOS(yDAT)+STR(mNUMERO,8)+mTIPFAT)
            //Lan‡amento Normal Cria ou Atualiza
         CASE yDAT = mVENCIMENT .AND. mVALOR > 0 .AND. !EMPTY(mVENCIMENT)
            IF !NOVOOPE(,DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT)
               //Altera Lan‡amentos
               netreclock()
               REPLVARS()
               DBUNLOCK()
            ENDIF
            //Mudou a data Apaga o anterior Grava o novo
         CASE yDAT <> mVENCIMENT .AND. mVALOR > 0
            DELEREG(,DTOS(yDAT)+STR(mNUMERO,8)+mTIPFAT)
            NOVOOPE(,DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT)
      ENDCASE
   NEXT
   DBCLOSEALL()
   mNUMERO   := yNUMERO   //Retorna as vari veis que foram salvadas.
   mDATA     := yDATA
   mSITUACAO := ySITUACAO
   mPEDIDO   := yPEDIDO
ENDIF
IF EMPTY(mTRANSP)
   mTRANSP := OBTER("MA01",mFORNECEDO,"TRANSPORTE")
ENDIF
HB_DISPBOX(9,0,23,79,B_DOUBLE)
@ 12,02 SAY 'Codigo da Transportadora:' GET mTRANSP        
READCUR()
WHILE !USEREDE("MG01",1,1)
ENDDO
DBGOTOP()
IF DBSEEK(mTRANSP)
   mCHAPA     := CHAPA
   mNOMETRANS := NOME
   mENDETRANS := TRIM(ENDERECO)+"-"+TRIM(BAIRRO)
   mBAIRTRANS := BAIRRO
   mCIDATRANS := CIDADE
   mESTATRANS := ESTADO
   mMOTORISTA := MOTORISTA
   mCGCTRANS  := CGC
   mIETRANS   := INSCR
ENDIF
DBCLOSEAREA()
@ 13,02 SAY 'Frete pago por: (1)-Emitente / (2)-Destinatario' GET mTIPOFRE          
@ 14,02 SAY 'Placa Caminhao -> '                              GET mCHAPA      valid validaplaca(mCHAPA)           
@ 15,02 SAY 'Motorista ....... '                              GET mMOTORISTA        
@ 17,03 SAY 'Tipo da Embalagem : '                                                  
//@ 18,03 SAY '-Marca -> '
//@ 18,14 SAY 'Numero'
@ 18,21 SAY ' Qtde '                  
@ 18,28 SAY '   Especie:    '         
@ 18,44 SAY 'Peso  Liq:'              
@ 18,55 SAY 'Peso  Bru:'              
//@ 19,03 GET mMARCAEMB
//@ 19,14 GET mNUMEROEMB
@ 19,21 GET mQUANTEMB                                          
@ 19,28 GET mEMBALAGEM                                         
@ 19,45 GET mTOTALPES  PICT '@E 99,999.99' VALID PESOB()       
@ 19,55 GET mTOTALPESB PICT '@E 99,999.99'                     
READCUR()

IF MDG("Deseja Rever Observa‡”es")
   HB_DISPBOX(3,3,20,76,B_DOUBLE)
   @  4,5 SAY "Linhas do Corpo da Nota Fiscal"         
   @ 14,5 SAY "Linhas de Observa‡„o"                   
   // Get nas Menvars
   @  5,5 GET mLIN01         
   @  6,5 GET mLIN02         
   @  7,5 GET mLIN03         
   @  8,5 GET mLIN04         
   @  9,5 GET mLIN05         
   @ 10,5 GET mLIN06         
   @ 11,5 GET mLIN07         
   @ 12,5 GET mLIN08         
   @ 15,5 GET mOBS1          
   @ 16,5 GET mOBS2          
   @ 17,5 GET mOBS3          
   @ 18,5 GET mOBS4          
   @ 19,5 GET mOBS5          
   READCUR()
ENDIF


//Atualiza as Matrizes se nao for inclusao
IF cVIDE = 'S' .AND. OPRMAM # 1
   aMAM1[POSMAM] = ' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+mTIPOCLI+' '+STR(mFORNECEDO,5)+' '+mCOGNOME+' '+mOPERACAO+' '+mCONDPAG+' '+STR(mTOTNF,18,2)
   aMAM2[POSMAM] = mNUMERO
ENDIF

//Posiciona o Novo Elemento na Matriz
IF cVIDE = 'S' .AND. OPRMAM = 1
   nSBAR ++
   AADD(aMAM1,NIL)
   AADD(aMAM2,NIL)
   POSMAM := LEN(aMAM1)
   POSW   := 1
   IF POSMAM > 1
      FOR X := 1 TO POSMAM - 1
         mDARE := aMAM2[X]
         IF mCHAVE <= mDARE   // IF STR(NUMERO,8)+STR(FORNECEDO,5)<=mDARE
            EXIT
         ENDIF
      NEXT
      POSW := X
   ENDIF
   AINS(aMAM1,POSW)
   AINS(aMAM2,POSW)
   aMAM1[POSW] = ' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+mTIPOCLI+' '+STR(mFORNECEDO,5)+' '+mCOGNOME+' '+mOPERACAO+' '+mCONDPAG+' '+STR(mTOTNF,18,2)
   aMAM2[POSW] = mNUMERO
   pMAM := POSW
ENDIF
REPORVARS(ARQWORK1,mNUMERO)

RETU .T.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAMK01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAMK01(nLIN,nCOL)

TIPCAD(mTIPOCLI,"ARQUSO",nLIN,nCOL)
// PARA O CALCULO DO ICM
IF !EMPTY(mFORNECEDO)
   PEGACAMPO(ARQUSO,"mFORNECEDO",{"COGNOME","ESTADO","DDD","TELEFONE"},{"mCOGNOME","mESTADO","mDDD","mTELEFONE"})
   mICM := OBTER("MD05",mESTADO,"ALIQUOTA")
   IF INCLUI
      IF mTIPOCLI = "C"
         PEGACAMPO(ARQUSO,"mFORNECEDO",{"CONDPAG","VENDEDOR","ZONA"},{"mCONDPAG","mVENDEDOR","mZONA"})
      ELSE
         mCONDPAG := OBTER(ARQUSO,mFORNECEDO,"CONDPAG")
      ENDIF
   ENDIF
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAMK02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAMK02()

IF mSITUACAO = "3" .OR. mSITUACAO = "4"
   @ 10,52 SAY "Nota   : " GET mNOTA_DEV1        
   @ 11,52 SAY "Emitida: " GET mDATA_DEV1        
   @ 12,52 SAY "Nota   : " GET mNOTA_DEV2        
   @ 13,52 SAY "Emitida: " GET mDATA_DEV2        
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PESOB()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC PESOB

IF mTOTALPESB = 0
   mTOTALPESB := mTOTALPES+mQUANTEMB
ENDIF
RETU .T.

// ** EOF ***
