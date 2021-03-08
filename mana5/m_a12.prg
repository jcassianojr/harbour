*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_a12.prg
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
#INCLUDE "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_a12()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
functio m_a12


//Recebendo Parametro de Trabalho
PARA wMA12,wpMA12,wcMA12

/* 3o. Paramentro
0 - Cria e Carrega as Matrizes
1 - N„o Cria e Carrega as Matrizes
2 - N„o Cria e N„o Carrega as Matrizes
*/
IF PCOUNT() < 3
   wcMA12 := 0
ENDIF

//Modo de Trabalho no Video
MDI(" Ý ",,,"M102")

//Configura‡„o de Trabalho
PRIV lFIXA,nACHO,cVIDE,lPBUS,lPIND,mCBAR,mCBARM,cTIPG,aGETS,cCBAS,nIBUS
PRIV nIEXI,aIND,nREG
IF !CONFARQ("M102","No.Cta   Cliente"+spac(12)+"Qtdde    Un Servi‡o"+spac(6)+"Tabela"+spac(7)+"Valor")
   RETU .F.
ENDIF
IF !CONFIND("M102")
   RETU .F.
ENDIF


//Pegando Cores de Trabalho
CORMA12 := CORARR("MA12")

aTELMA12 := TELAPEG("MA1201")
aGETMA12 := EDITPEG("MA1201")

//Variaveis de Trabalho
PRIV PCK    := .F.
PRIV mCHAVE
IF wMA12 = 0
   CRIARVARS("M102")
ENDIF
//CRIANDO MATRIZES
IF wcMA12 = 0
   aMA121 := {}   //Matriz com os dizeres do Achoice
   aMA122 := {}   //Itens do Contrato
   aMA124 := {}   //Valor Mercadoria
   aMA125 := {}   //Valor Total
   aMA126 := {}   //Valor Imposto
ENDIF

//Incializando a ajuda on Line
PRIV HELPDBF := "M102"

//Carregando Matriz
IF cVIDE = "S" .AND. wcMA12 # 2
   nIND := IF(lPIND,NUMIND("M102"),nIEXI)
   IF !USEREDE("M102",1,nIND)
      RETU
   ENDIF
   GRAF  := LASTREC()
   xGRAF := 0
   xPOS  := 1
   MARCAR()
   DBGOTOP()
   DBSEEK(STR(mNUMERO))
   WHILE NUMERO = mNUMERO .AND. !EOF()
      IF !EMPTY(mCBAR)
         AADD(aMA121,&mCBAR.)
      ELSE
         AADD(aMA121,' '+STR(NUMERO,8)+' '+STR(CLIENTE,5)+' '+COGNOME+' '+STR(QTDE_PED,8,2)+' '+UNID+' '+SERVICO+' '+STR(VALORTOT,12,2))
      ENDIF
      AADD(aMA122,STR(NUMERO)+SERVICO)
      AADD(aMA124,VALORMER)
      AADD(aMA125,VALORTOT)
      AADD(aMA126,VALORIMP)
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
      IF !fMA12(1,0)
         RETU .F.
      ENDIF
   ENDIF
ENDIF

//Posi‡„o Inicial do Ponteiro
IF PCOUNT() = 1
   pMA12 := 1
ELSE
   pMA12 := ASCAN(aMA122,wpMA12)
   pMA12 := IF(pMA12 = 0,1,pMA12)
ENDIF

//Processando o M‚todo Escolhido
IF cVIDE = 'S'
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR := LEN(aMA121)
   aSBAR := ScrollBarNew(04,79,23,SUBSTR(CORMA12[1],RAT(",",CORMA12[1])+1),pMA12)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMA12,nSBAR,.T.)
   WHILE .T.
      mTOTMER := 0.00
      mTOTIMP := 0.00
      mTOTNF  := 0.00
      FOR X := 1 TO LEN(aMA124)
         mTOTMER += aMA124[X]
         mTOTNF  += aMA125[X]
         mTOTIMP += aMA126[X]
      NEXT X
      SETCOLOR(CORMA12[1])
      HB_DISPBOX(2,0,23,79,B_DOUBLE)
      @  3,1 SAY cCBAS                             
      @  4,0 SAY '+'+replicate('-',78)+'Ý'         
      MDS('Busca: ')
      SETCOLOR(CORMA12[1])
      ScrollBarUpdate(aSBAR,pMA12,nSBAR,.T.)
      ScrollBarDisplay(aSBAR)
      pMA122 := ACHOICE(05,01,22,78,aMA121,,"ACHRETB",pMA12)
      pMA12  := IF(pMA122 # 0,pMA122,pMA12)
      pMA122 := pMA12
      DO CASE
         CASE LASTKEY() = K_ESC
            EXIT
         CASE  LASTKEY() = K_ALT_F10
            MDS('Imprimindo') 
            MANLISTA()
         CASE LASTKEY() = K_INS
            MDS('Incluindo ') 
            fMA12(1,pMA12)
         CASE LASTKEY() = K_ENTER .AND. wMA12 # 3 
            MDS('Alterando ') 
            fMA12(2,pMA12)
         CASE LASTKEY() = K_ENTER .AND. wMA12 = 3 
            MDS('Escolhendo') 
            fMA12(6,pMA12) 
            RETU
         CASE LASTKEY() = K_DEL
            MDS('Excluindo ') 
            fMA12(3,pMA12)
         CASE LASTKEY() = K_CTRL_ENTER
            nIBUS   := IF(lPBUS,NUMIND("M102"),nIBUS)
            mCHABUS := PEGBUS("M102",nIBUS)
            IF nIBUS # 1
               nREG := REGBUS("M102",nIBUS,mCHABUS)
            ENDIF
            pMA12 := ASCAN(aMA122,STR(mNUMERO)+mSERVICO)
            IF pMA12 = 0
               ALERTX('Nao localizei o Registro Correspondente ....')
               pMA12 := pMA122
               LOOP
            ENDIF
         OTHERWISE 
            LOOP
      ENDCASE
   ENDDO
ENDIF

IF wMA12 = 0
   //LIBERA VARIAVEIS
   RELEASE ALL LIKE m *   //LIMPAVARS("M102")
ENDIF

//EFETUA O PACK SE NECESSARIO
IF PCK .AND. lFIXA
   FIXAR("M102")
ENDIF
RETU .T.

// ******************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fMA12()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC fMA12(OPRMA12,POSMA12)   //INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ******************
//Pegar a Chave de Busca
IF OPRMA12 # 1
   IF cVIDE = 'S'
      mCHAVE := aMA122[POSMA12]
   ENDIF
   IF cVIDE = 'N' .AND. POSMA12 # - 1
      PEGBUS("M102",1)
   ENDIF
ENDIF

//Opera‡„o de Exclus„o
IF OPRMA12 = 3
   IF APAGAREG("M102",mCHAVE)
      IF cVIDE = "S"
         aMA121[POSMA12] = ' '+STR(mNUMERO)+' '+mSERVICO+' - Registro Excluido / Apagado / Deletado'
      ENDIF
      PCK := .T.
   ENDIF
   RETU .T.
ENDIF

//Opera‡„o de Inclus„o
IF OPRMA12 = 1
   PEGBUS("M102",1)
   IF !NOVOREG("M102",mCHAVE)
      RETU .F.
   ENDIF
ENDIF

//IGUALAR mVARS
IF !IGUALVARS("M102",mCHAVE)
   RETU .F.
ENDIF

//Fixa Variaveis Arquivo Principal
mNUMERO    := xNUMERO
mDATA      := xDATA
mCLIENTE   := xCLIENTE
mDIA_VENC  := xDIA_VENC
mVENCIMENT := xVENCIMENT
mREAJ      := xREAJ


xSERVICO  := mSERVICO
xIMPOSTO  := mIMPOSTO
xDATABASE := mDATABASE
xTIPBASE  := mTIPBASE

//Metodo de Edi‡„o
IF cTIPG = "1"
   // Desenha a Tela
   TELASAY(aTELMA12)
   // Get nas Menvars
   EDITSAY(aGETMA12)
ELSE
   EDITGET(.T.,CORMA12)
ENDIF



//Atualiza as Matrizes se nao for inclusao
IF cVIDE = 'S' .AND. OPRMA12 # 1
   IF !EMPTY(mCBARM)
      aMA121[POSMA12] = &mCBARM.
   ELSE
      aMA121[POSMA12] = ' '+STR(mNUMERO,8)+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mQTDE_PED,8,2)+' '+mUNID+' '+mSERVICO+' '+STR(mVALORTOT,12,2)
   ENDIF
   aMA122[POSMA12] = STR(mNUMERO)+mSERVICO
   aMA124[POSMA12] = mVALORMER
   aMA125[POSMA12] = mVALORTOT
   aMA126[POSMA12] = mVALORIMP
ENDIF

//Posiciona o Novo Elemento na Matriz
IF cVIDE = 'S' .AND. OPRMA12 = 1
   nSBAR ++
   AADD(aMA121,NIL)
   AADD(aMA122,NIL)
   AADD(aMA124,NIL)
   AADD(aMA125,NIL)
   AADD(aMA126,NIL)
   POSMA12 := LEN(aMA121)
   POSW    := 1
   IF POSMA12 > 1
      FOR X := 1 TO POSMA12 - 1
         mDARE := aMA122[X]
         IF mCHAVE <= mDARE   // IF mSTR(NUMERO)+SERVICO<=mDARE
            EXIT
         ENDIF
      NEXT
      POSW := X
   ENDIF
   AINS(aMA121,POSW)
   AINS(aMA122,POSW)
   AINS(aMA124,POSW)
   AINS(aMA125,POSW)
   AINS(aMA126,POSW)
   IF !EMPTY(mCBARM)
      aMA121[POSW] = &mCBARM.
   ELSE
      aMA121[POSW] = ' '+STR(mNUMERO,8)+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mQTDE_PED,8,2)+' '+mUNID+' '+mSERVICO+' '+STR(mVALORTOT,12,2)
   ENDIF
   aMA122[POSW] = STR(mNUMERO)+mSERVICO
   aMA124[POSW] = mVALORMER
   aMA125[POSW] = mVALORTOT
   aMA126[POSW] = mVALORIMP
   pMA12 := POSW
ENDIF

REPORVARS("M102",mCHAVE)

RETU .T.






*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MA1202()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MA1202(nROW,nCOL1,nCOL2)

IF xIMPOSTO # mIMPOSTO
   mDESC_IMP := OBTER("MD02",PADR("IMPOSTO",12)+PADR(mIMPOSTO,12),"DESCRICAO")
   mALIQUOTA := OBTER("MD02",PADR("IMPOSTO",12)+PADR(mIMPOSTO,12),"VARIACAO")
   xIMPOSTO  := mIMPOSTO
   @ nROW,nCOL1 SAY mALIQUOTA PICT "99.99"        
   @ nROW,nCOL2 SAY mDESC_IMP                     
ENDIF
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MA1203()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MA1203

mVALORMER := mQTDE_PED * mPRECO
mVALORIMP := ROUND(mALIQUOTA * mVALORMER / 100,2)
mVALORTOT := mVALORMER - mVALORIMP
@ 10,24 SAY mVALORMER PICT "9,999,999.99"        
@ 10,37 SAY mVALORIMP PICT "9,999,999.99"        
@ 10,50 SAY mVALORTOT PICT "9,999,999.99"        
RETU .T.

