*:*****************************************************************************
*:
*:   M_AM2 .PRG  : Saidas de Notas Fiscais
*:   Linguagem   : Clipper 5.x
*:        Sistema: Mana5  - ITAESBRA
*:      Copyright (c) 1999
*
*:*****************************************************************************

#INCLUDE "BOX.CH"

function m_am2
//Recebendo Parametro de Trabalho
PARA wMAM2,wpMAM2,wcMAM2

/* 3o. Paramentro
0 - Cria e Carrega as Matrizes
1 - N„o Cria e Carrega as Matrizes
2 - N„o Cria e N„o Carrega as Matrizes
*/
IF PCOUNT()<3
   wcMAM2=0
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
IF ! CONFARQ(ARQWORK2,"  OS  Qtde   C¢digo"+spac(6)+"Nome"+spac(20)+"Pre‡o Un."+"     Total Mercad.")
   RETU .F.
ENDIF
IF ! CONFIND(ARQWORK2)
   RETU .F.
ENDIF

xPOS  := 1

//Pegando Cores de Trabalho
CORMM2:=CORARR("MAM2")

//Variaveis de Trabalho
PRIV PCK:=.F.
PRIV mCHAVE
PRIV mOLDQTDDE
IF wMAM2=0
   CRIARVARS(ARQWORK2)
ENDIF
//CRIANDO MATRIZES
IF wcMAM2=0
   aMAM21={}    &&Matriz com os dizeres do Achoice
   aMAM22={}    &&Por N£mero da Nota Fiscal e OS E Codigo do Produto
   aMAM25={}    && Valor Total da Mercadoria
   aMAM26={}    && Valor Total do IPI
   aMAM27={}    && Valor Total da Nota Fiscal
   aMAM28={}    && Valor Total do ICMS
   aMAM29={}    && Valor Total da Base de Calculo do IPI
   aMAM30={}    && Valor Total da Base de Calculo do ICM
   aMAM31={}    && Valor Peso liquido
   aMAM32={}    && Quantidade
   aMAM33={}    && Valor Peso Bruto
   aMAM34={}    && TipoentradaCODIGO
ENDIF

//Incializando a ajuda on Line
PRIV HELPDBF:="MM02"

//Carregando Matriz
nIND:=IF(lPIND,NUMIND(ARQWORK2),nIEXI)
IF ! USEREDE(ARQWORK2,1,1)
   RETU
ENDIF
DBGOTOP()
DBSEEK(STR(mNUMERO,8))
WHILE mNUMERO=NUMERO .AND.! EOF()
    IF ! EMPTY(mCBAR)
       AADD(aMAM21,&mCBAR.)
    ELSE
       AADD(aMAM21,' '+STR(OS,8,2)+' '+STR(QTDE,  10,3)+' '+LEFT(CODIGO,10)+' '+LEFT(NOME,10)+' '+STR(PRECO, 12, 5)+' '+STR(VALORMER, 10,2))
    ENDIF
    AADD(aMAM22,STR(NUMERO,8)+STR(SEQ,2))
    AADD(aMAM25,VALORMER)
    AADD(aMAM26,VALORIPI)
    AADD(aMAM27,VALORTOT)
    AADD(aMAM28,VALORICM)
    AADD(aMAM29,BASEIPI)
    AADD(aMAM30,BASEICM)
    AADD(aMAM31,MAM204(PESO,QTDE,UNID,PESTOT,TIPOENT,"L"))
    AADD(aMAM32,CONVUN(QTDE,UNID))
    AADD(aMAM33,MAM204(PESO,QTDE,UNID,PESTOT,TIPOENT,"B"))
    AADD(aMAM34,TIPOENT+ALLTRIM(CODIGO))
    xPOS++
    DBSKIP()
ENDDO
DBCLOSEAREA()
IF xPOS=1
   nSBAR:=0
   IF ! fMAM2(1,0)
      RETU .F.
   ENDIF
ENDIF

//Posi‡„o Inicial do Ponteiro
IF PCOUNT()=1
   pMAM2=1
ELSE
   pMAM2=ASCAN(aMAM22,wpMAM2)
   pMAM2=IF(pMAM2=0,1,pMAM2)
ENDIF

//Processando o M‚todo Escolhido
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR=LEN(aMAM21)
   aSBAR:= ScrollBarNew(03,79,23,,pMAM2)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMAM2,nSBAR,.T.)
   WHILE .T.
      mTOTMER  := 0.00
      mTOTIPI  := 0.00
      mTOTNF   := 0.00
      mTOTICM  := 0.00
      mTOTBIPI := 0.00
      mTOTBICM := 0.00
      mTOTALPES:= 0.00
      mTOTALBRU:= 0.00
      mQUANTEMB:= 0.00
      mTOTFRETE:= 0.00
      FOR X=1 TO LEN(aMAM27)
          mTOTMER  +=aMAM25[X]
          mTOTIPI  +=aMAM26[X]
          mTOTNF   +=aMAM27[X]
          mTOTICM  +=aMAM28[X]
          mTOTBIPI +=aMAM29[X]
          mTOTBICM +=aMAM30[X]
          mTOTALPES+=aMAM31[X]
          mQUANTEMB+=aMAM32[X]
          mTOTALBRU+=aMAM33[X]
          IF aMAM34[X]="XFRETE"
             mTOTFRETE+=aMAM25[X]
          ENDIF
      NEXT X
      SETCOLOR(CORMM2[1])
      HB_DISPBOX(2,0,23,79,B_DOUBLE)
      @ 3, 1 SAY cCBAS
      @ 4, 0 SAY '+'+replicate('-',78)+'Ý'
      MDS('Busca: ')
      ScrollBarUpdate(aSBAR,pMAM2,nSBAR,.T.)
      ScrollBarDisplay(aSBAR)
      pMAM22=ACHOICE(05,01,22,78,aMAM21,,"ACHRETB",pMAM2)
      pMAM2=IF(pMAM22#0,pMAM22,pMAM2)
      pMAM22=pMAM2
      DO CASE
         CASE LASTKEY() = K_ESC ;  EXIT
         CASE LASTKEY() = K_ALT_F10 ;  MDS('Imprimindo') ;  MANLISTA()
         CASE LASTKEY() = K_INS ;  MDS('Incluindo ') ;  fMAM2(1,pMAM2)
         CASE LASTKEY() = K_ENTER .AND. wMAM2#3 ;  MDS('Alterando ') ;  fMAM2(2,pMAM2)
         CASE LASTKEY() = K_ENTER .AND. wMAM2=3 ;  MDS('Escolhendo') ;  fMAM2(6,pMAM2) ; RETU
         CASE LASTKEY() = K_DEL ;  MDS('Excluindo ') ;  fMAM2(3,pMAM2)
         CASE LASTKEY() = K_CTRL_ENTER
              nIBUS   := IF(lPBUS,NUMIND(ARQWORK2),nIBUS)
              mCHAVE  := PEGBUS(ARQWORK2,nIBUS)
              IF nIBUS#1
                 nREG    := REGBUS(ARQWORK2,nIBUS,mCHAVE)
              ENDIF
              pMAM2=ASCAN(aMAM22,mCHAVE)
              IF pMAM2=0
                 MDE("NLOCAL","","")
                 pMAM2=pMAM22
                 LOOP
              ENDIF
         OTHERWISE ; LOOP
      ENDCASE
   ENDDO

IF wMAM2=0
   //LIBERA VARIAVEIS
   RELEASE ALL LIKE m*    //LIMPAVARS(ARQWORK2)
ENDIF

//EFETUA O PACK SE NECESSARIO
IF PCK.AND.lFIXA
   FIXAR(ARQWORK2)
ENDIF
RETU .T.

*****************************************************************************
FUNC fMAM2(OPRMAM2,POSMAM2)   &&INC=1//MUD=2//EXC=3 // POSICAO MATRIZ
*****************************************************************************
INCLUI:=.F.
//Pegar a Chave de Busca
IF OPRMAM2#1
   mCHAVE:=aMAM22[POSMAM2]
ENDIF


//Opera‡„o de Inclus„o
IF OPRMAM2=1
   mSEQ:=1
   WHILE ASCAN(aMAM22,STR(mNUMERO,8)+STR(mSEQ,2))#0
      mSEQ++
   ENDDO
   mCHAVE:=PEGBUS()
   mNOME    := ""
   mQTDE    := 0
   mUNID    := "PC"
   mDEV     := 0
   mNOTADEV := 0
   mTOTDEV  := 0
   mDATADEV := CTOD("00/00/00")
   mTOTSDEV := 0
   mQTDEDEV := 0
   mSOMANF:="S"
   mCONSUMO:="N"
   mPRECO  := 0
   mPESO   := 0
   mCODIGO := SPACE(24)
   mTIPOENT:="P"
   IF LEFT(yOPERACAO,3)="593".AND.mTIPOCLI="F"
      mTIPOENT:="T"
   ENDIF
   IF LEFT(yOPERACAO,3)="599"
      mTIPOENT:="X"
   ENDIF
   IF yCFONEW="5920".OR.yCFONEW="6920".OR.yCFONEWB="5920".OR.yCFONEWB="6920"
      mTIPOSERV:="6"
   ENDIF
   PDIPI( mCFONEW,"mCODICM", "mDIPIPI", "mDIPICM",     ,    ,2)
   //Operacao,CodIcm,DIPIPI,DIPICM,DIPAM,open,Indice 2CfoNovo/3CfoVelho
   IF ! NOVOREG(ARQWORK2,mCHAVE)
      RETU .F.
   ENDIF
   INCLUI:=.T.
ENDIF



//IGUALAR mVARS
IF ! IGUALVARS(ARQWORK2,mCHAVE)
   RETU .F.
ENDIF
mNUMERO    := yNUMERO
mDATA      := yDATA
mFORNECEDO := yFORNECEDO
mOPERACAO  := yOPERACAO
mSUBOPER   := ySUBOPER
mAPURA     := yAPURA
mESPECIE   := yESPECIE
mCFONEW    := yCFONEW
mCFONEWB   := yCFONEWB
nLINADD    := 0
IF EMPTY(mTIPOENT)
   IF EMPTY(mOS)
      mTIPOENT:="X"
   ELSE
      mTIPOENT:="P"
   ENDIF
ENDIF
MAM201()

//Ajusta Sequencia se Estiver em Branco
IF EMPTY(mSEQ)
   mSEQ:=POSMAM2
ENDIF

//Vari veis de Referencias
xCODIGO   := mCODIGO
xCODIPI   := mCODIPI
yCODIGO   := mCODIGO
xVALORMER := mVALORMER
xBASEICM  := mBASEICM
xBASEIPI  := mBASEIPI
xIPI      := mIPI


//Opera‡„o de Exclus„o
IF OPRMAM2=3
   IF APAGAREG(ARQWORK2,mCHAVE)
      aMAM21[POSMAM2]=' '+STR(mSEQ,2)+mCODIGO+' - Registro Excluido / Apagado / Deletado'
      PCK=.T.
      aMAM25[POSMAM2]=0
      aMAM26[POSMAM2]=0
      aMAM27[POSMAM2]=0
      aMAM28[POSMAM2]=0
      aMAM29[POSMAM2]=0
      aMAM30[POSMAM2]=0
      aMAM31[POSMAM2]=0
      aMAM32[POSMAM2]=0
      aMAM33[POSMAM2]=0
      aMAM34[POSMAM2]=""
   ENDIF
   RETU .T.
ENDIF


   // Desenha a Tela
   tMAM2()
   // Get nas Menvars
   gMAM2()



//Atualiza as Matrizes se nao for inclusao
IF OPRMAM2#1
   aMAM21[POSMAM2]=' '+STR(mOS,8,2)+' '+STR(mQTDE, 10,3)+' '+LEFT(mCODIGO,10)+' '+LEFT(mNOME,10)+' '+STR(mPRECO, 12, 5)+' '+STR(mVALORMER, 10, 2)
   aMAM22[POSMAM2]=STR(mNUMERO,8)+STR(mSEQ,2)
   aMAM25[POSMAM2]=mVALORMER
   aMAM26[POSMAM2]=mVALORIPI
   aMAM27[POSMAM2]=mVALORTOT
   aMAM28[POSMAM2]=mVALORICM
   aMAM29[POSMAM2]=mBASEIPI
   aMAM30[POSMAM2]=mBASEICM
   aMAM31[POSMAM2]=MAM204(mPESO,mQTDE,mUNID,mPESTOT,mTIPOENT,"L")
   aMAM32[POSMAM2]=CONVUN(mQTDE,mUNID)
   aMAM33[POSMAM2]=MAM204(mPESO,mQTDE,mUNID,mPESTOT,mTIPOENT,"B")
   aMAM34[POSMAM2]=mTIPOENT+ALLTRIM(mCODIGO)
ENDIF

//Posiciona o Novo Elemento na Matriz
IF OPRMAM2=1
   nSBAR++
   AADD(aMAM21,NIL)
   AADD(aMAM22,NIL)
   AADD(aMAM25,NIL)
   AADD(aMAM26,NIL)
   AADD(aMAM27,NIL)
   AADD(aMAM28,NIL)
   AADD(aMAM29,NIL)
   AADD(aMAM30,NIL)
   AADD(aMAM31,NIL)
   AADD(aMAM32,NIL)
   AADD(aMAM33,NIL)
   AADD(AMAM34,NIL)
   POSMAM2=LEN(aMAM21)
   POSW=1
   IF POSMAM2>1
      FOR X = 1 TO POSMAM2-1
          mDARE=aMAM22[X]
          IF mCHAVE<=mDARE
             EXIT
          ENDIF
      NEXT
      POSW=X
   ENDIF
   AINS(aMAM21,POSW)
   AINS(aMAM22,POSW)
   AINS(aMAM25,POSW)
   AINS(aMAM26,POSW)
   AINS(aMAM27,POSW)
   AINS(aMAM28,POSW)
   AINS(aMAM29,POSW)
   AINS(aMAM30,POSW)
   AINS(aMAM31,POSW)
   AINS(aMAM32,POSW)
   AINS(aMAM33,POSW)
   AINS(AMAM34,POSW)
   aMAM21[POSW]=' '+STR(mOS,8,2)+' '+STR(mQTDE, 10,3)+' '+LEFT(mCODIGO,10)+' '+LEFT(mNOME,10)+' '+STR(mPRECO, 12, 5)+' '+STR(mVALORMER, 10, 2)
   aMAM22[POSW]=STR(mNUMERO,8)+STR(mSEQ,2)
   aMAM25[POSW]=mVALORMER
   aMAM26[POSW]=mVALORIPI
   aMAM27[POSW]=mVALORTOT
   aMAM28[POSW]=mVALORICM
   aMAM29[POSW]=mBASEIPI
   aMAM30[POSW]=mBASEICM
   aMAM31[POSW]=MAM204(mPESO,mQTDE,mUNID,mPESTOT,mTIPOENT,"L")
   aMAM32[POSW]=CONVUN(mQTDE,mUNID)
   aMAM33[POSW]=MAM204(mPESO,mQTDE,mUNID,mPESTOT,mTIPOENT,"B")
   aMAM34[POSW]=mTIPOENT+ALLTRIM(mCODIGO)
   pMAM2=POSW
ENDIF

//Ajusta Devolucoes
IF EMPTY(mDEV)
   mDEV:=mTOTSDEV
ENDIF

REPORVARS(ARQWORK2,mCHAVE)

RETU .T.


//Tela de Dados
FUNC tMAM2
SETCOLOR(CORMM2[5])
HB_DISPBOX( 2, 0,23,79,B_DOUBLE)
@  6,  1 SAY "OS :"+spac(10)+"Tipo Serv.:   SEQ:"+spac(7)+"Tipo:   "+"P.Ent"
@  7,  1 SAY"Rast."
@  8,  1 SAY "C¢digo:"+spac(28)+"Compra:      PedCli:"
@  9,  1 SAY "Nome  :"+spac(28)+"Qtde  :"+spac(12)+"Unidade:"
@ 10,  1 SAY "Uso/Consumo:     +IPI Total:    Peso Unit:"+spac(12)+"Peso Total:"
@ 11,  1 SAY "Considerar PIS/Confins:  "
@ 12,  1 SAY replicate('-',32)+"-"+replicate('-',45)
@ 13,  1 SAY "Pre‡o Unitar:"+spac(19)+"ÝLinhas Auxiliares : "
@ 14,  1 SAY "Total Mercad:"+spac(19)+"Ý"
@ 15,  9 SAY "IPI :    <IORTB>"+spac(8)+"Ý"
@ 16,  1 SAY "Base do IPI :"+spac(19)+"Ý"
@ 17,  1 SAY "IPI:"+spac(8)+"%"+spac(19)+"Ý"
@ 18,  1 SAY "Total Nota F:"+spac(19)+"Ý"
@ 19,  1 SAY "Classifica‡„o"+spac(19)+"Ý"
@ 20,  9 SAY "ICMS:    <IORTB>"+spac(8)+"ÝEmbalagem Avulsa"
@ 21,  1 SAY "Base do ICMS:"+spac(19)+"Ý"
@ 22,  1 SAY "ICM:"+spac(8)+"%"+spac(19)+"Ý"
SETCOLOR(CORMM2[3])
RETU .T.

//Get Nas Mvars
FUNC gMAM2
SETCOLOR(CORMM2[2])
NFBAS()
nLINADD:=0
SET KEY K_F11 TO TECLAF11
@  6,36 SAY mSEQ        PICT '99'
@  6, 6 GET mOS         WHEN INCLUI
@  6,55 SAY mENTREGA
@  6,27 GET mTIPOSERV   VALID CHECKTAB("TIPSERV","mTIPOSERV","TIPSER",,"LEFT(CODIGO1,1)")
@  6,46 GET mTIPOENT    VALID CHECKTAB("MW0503","mTIPOENT","MW0503",,"LEFT(CODIGO1,1)").AND.MMDEV()
@  7,08 GET mRASTRO   when alltrue(mRASTRO:=checkrastro(mRASTRO)) pict "@S25"
@  7,35 GET mRASTR2   when alltrue(mRASTR2:=checkrastro(mRASTR2)) pict "@S25"
@  8, 9 GET mCODIGO     VALID IF(mTIPOENT#"X".AND.mTIPOENT#"T",CHECKEXI(ESTQARQ(mTIPOENT,1),"mCODIGO","CODIGO+' '+NOME","CODIGO","CODIGO",.F.),.T.).AND.NFCOD(.T.).AND.MMTRA().AND.MMZFM()
@  8,44 GET mCOMPRA
@  8,54 GET mPEDIDOCLI  WHEN INCLUI
@  8,75 GET mPEDCLIITE  WHEN INCLUI
@ 09, 9 GET mNOME
@ 09,44 GET mQTDE       PICT "999999.999" VALID NFBAS().AND.ALLTRUE(MAM203())
@ 09,64 GET mUNID       VALID CHECKEXI("MD07","mUNID","UNIDADE+' '+UNIDDES","UNIDADE","UNIDADE").AND.ALLTRUE(MAM203())
@ 10,14 GET mCONSUMO    VALID mCONSUMO $ 'SN'.AND.NFBAS()
@ 10,30 GET mSOMANF     VALID mSOMANF  $ 'SN'.AND.NFBAS()
@ 10,44 GET mPESO       PICT '99999.999' VALID ALLTRUE(MAM203())
@ 10,67 GET mPESTOT     PICT '999999999.99'  WHEN MAM203()
@ 11,27 GET mPISCON    VALID mPISCON  $ 'SN '
@ 13,15 GET mPRECO      PICT "9,999,999,999.9999" VALID IF(mPRECO>0.OR.mOS=9000,.T.,ALLTRUE(ALERTX("Preco em Branco"))).AND.NFBAS()
@ 15,15 GET mDIPIPI     VALID mDIPIPI  $ 'IORTB '
@ 16,15 GET mBASEIPI    PICT '999,999,999,999.99' VALID NFBIPI()
@ 17, 5 GET mCODIPI     VALID ALLTRUE(CHECKCIPI(mCODIPI,"mIPI","mCLASSIPI","mICM",mCFONEW,2))
@ 17, 8 GET mIPI        PICT '99.9' VALID NFBAS().AND.NFIPI()
@ 17,15 GET mVALORIPI   PICT "999,999,999,999.99" VALID NFBAS().AND.NFVIPI()
@ 19,15 GET mCLASSIPI   WHEN EMPTY(mCODIPI) VALID CHECKIPI(mCLASSIPI)
@ 20,15 GET mDIPICM     VALID mDIPICM  $ 'IORTB '
@ 21,15 GET mBASEICM    PICT '999,999,999,999.99' VALID NFBICM()
@ 22, 5 GET mCODICM     VALID CHECKTAB("CODICM","mCODICM","CODICM",,"LEFT(CODIGO1,3)")
@ 22, 9 GET mICM        PICT "99" VALID NFBAS()
@ 22,15 GET mVALORICM   PICT "999,999,999,999.99" VALID NFVICM()
@ 13,54 GET nLINADD     VALID MAM202()
@ 14,34 GET mLINADD01
@ 15,34 GET mLINADD02
@ 16,34 GET mLINADD03
@ 17,34 GET mLINADD04
@ 18,34 GET mLINADD05
@ 19,34 GET mLINADD06
@ 21,34 GET mAVEMBQ
@ 21,46 GET mAVEMBC
READCUR()
SET KEY K_F11 TO
RETU .T.

FUNC MAM201
IF EMPTY(mSOMANF)
   mSOMANF:="S"
ENDIF
IF EMPTY(mCONSUMO)
   mCONSUMO:="N"
ENDIF
RETU .T.


FUNC MAM202
IF ! EMPTY(nLINADD)
   PEGACAMPO("MM02L","nLINADD",{"LIN01","LIN02","LIN03","LIN04","LIN05","LIN06","LIN07","LIN08"},;
                               {"mLINADD01","mLINADD02","mLINADD03","mLINADD04","mLINADD05","mLINADD06","mLINADD07","mLINADD08"})
   nLINADD:=0
ENDIF
RETU .T.

FUNC MAM203 //Pedira o Peso Total se Nao Fornecer o Individual (When)
IF EMPTY(mPESO).OR.EMPTY(mQTDE)
   RETU .T.
ENDIF
mPESTOT:=mPESO*CONVUN(mQTDE,mUNID)
RETU .F.

FUNC MAM204(ePES,eQTD,eUND,eTOT,eTIPOENT,cTIPO)
IF cTIPO="L".AND.eTIPOENT="B"
   RETU 0
ENDIF
IF EMPTY(ePES).OR.EMPTY(eQTD)
   RETU eTOT
ENDIF
RETU ePES*CONVUN(eQTD,eUND)



*****************************************************************************
FUNC MMDEV
*****************************************************************************
IF mTIPOSERV="3".OR. mTIPOSERV="4".OR. mTIPOSERV="6"
   IF yCFONEW="5920".OR.yCFONEWB="5920".AND.mTIPOENT="B"
      RETU .T.
   ENDIF
   IF yCFONEW="6920".OR.yCFONEWB="6920".AND.mTIPOENT="B"
      RETU .T.
   ENDIF
//   IF yCFONEW="6921".OR.yCFONEWB="6921".AND.mTIPOENT="B"
//      RETU .T.
//   ENDIF
   PRIV GETLIST:={}
   TELAOLD:=SAVESCREEN(08,07,20,71)
   TELASAY("MMDE01")
   EDITSAY("MMDE01")
   RESTSCREEN(08,07,20,71,TELAOLD)
   SETCURSOR(IF(READINSERT(),1,2))
ENDIF
RETU .T.


FUNC MMZFM()
IF mTIPOENT="X".AND.mCODIGO="DESCICM"
   mTMPICM:=OBTER("MD05",mESTADO,"ALIQUOTA")
   mNOME:="Desconto "+STR(mTMPICM,2)+"% DE ICMS"
   mPRECO:=ROUND(mTOTMER*-1*mTMPICM/100,2)
   mQTDE:=1
   mCODICM="000"
   mDIPICM="I"
   mDIPIPI="I"
   mCODIPI:="  "
ENDIF
RETU .T.

FUNC MMTRA(cVAR)
LOCAL lRETU:=.F.
LOCAL nERRO:=0
if ARQWORK1<>"MM01".AND.ARQWORK1<>"MOSB01"
   RETU .T.
endif
IF mTIPOENT#"T"
   RETU .T.
ENDIF
IF ! USEMULT({{"MW01",1,1},{"MW02",1,3}})
   RETU .F.
ENDIF
DBSELECTAR("MW02")
DBGOTOP()
DBSEEK(ALLTRIM(mCODIGO))
WHILE ALLTRIM(ITECOD)=ALLTRIM(mCODIGO).AND.! EOF()
   mCOMITE:=ITEM
   mCOMPED:=COMPED
   mCOMFOR:=0
   IF BLQITEM="S"
      nERRO=2
   ELSE
      DBSELECTAR("MW01")
      DBGOTOP()
      IF DBSEEK(mCOMPED)
         mCOMFOR:=COMFOR
         IF COMFOR=mFORNECEDO
            IF CONTRATO<> "S"
               nERRO=3
            ELSE
               lRETU:=.T.
               IF VALTYPE(cVAR)="C"
                 &cVAR.:=STR(mCOMPED)+"."+STR(mCOMITE)
               ENDIF
           ENDIF
         ELSE
           nERRO=4
         ENDIF
     ENDIF
   ENDIF
   DBSELECTAR("MW02")
   DBSKIP()
ENDDO
DBSELECTAR("MW01")
DBCLOSEAREA()
DBSELECTAR("MW02")
DBCLOSEAREA()
IF ! lRETU.AND.eMPTY(nERRO)
   nERRO=1
ENDIF
IF lRETU
   nERRO=0 //Achou Sem Erro Pois Pode ter mesmo produtos dois Fornecedores
ENDIF
IF nERRO>0
   DO CASE
   CASE nERRO=1
        ALERTX("Sem Pedido Compras")
   CASE nERRO=2
        ALERTX("Item Pedido Bloqueado:"+STR(mCOMPED)+"."+STR(mCOMITE))
   CASE nERRO=3
        ALERTX("Pedido Nao e Contrato:"+STR(mCOMPED)+"."+STR(mCOMITE))
   CASE nERRO=4
        ALERTX("Pedido Outro Fornecedor:"+STR(mCOMPED)+"."+STR(mCOMITE)+STR(mCOMFOR))
   ENDCASE
ENDIF
RETU .T.


