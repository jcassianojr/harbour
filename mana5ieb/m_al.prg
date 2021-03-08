*:*****************************************************************************
*:
*:   M_AL1 .PRG  : Contas a Pagar
*:   Linguagem   : Clipper 5.x
*:        Sistema: MANA5
*:      Copyright (c) 1994, Disk Soft S/C Ltda.
*:
*****************************************************************************

//Teclas Operacionais
//#INCLUDE "TECLAS.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

function M_al
PARA ARQWORK

SET CENTURY ON

//Recebendo Parametro de Trabalho
wMAL:=0
wpMAL:=1
wcMAL:=0

MDS("Carregando Historico")
aCODHIS:={}
IF !USEREDE(IF(EMPTY(zARQHIS),"MI02",zARQHIS),1,1)
   RETU .T.
ENDIF
DBGOTOP()
WHILE !EOF()
    AADD(aCODHIS,' '+CODIGO+' '+DESCRICAO+' '+TIPO+' ')
    DBSKIP()
ENDDO
DBCLOSEAREA()



//Modo de Trabalho no Video
MDI(" Ý ",,,ARQWORK)

//Configura‡„o de Trabalho
PRIV lFIXA,nACHO,cVIDE,lPBUS,lPIND,mCBAR,mCBARM,cTIPG,aGETS,cCBAS,nIBUS
PRIV nIEXI,aIND,nREG
IF ! CONFARQ(ARQWORK,"Fatura       Vencera    Fornecedor"+spac(07)+"     Valor Pagar"+spac(2)+"DDD+Telefone   COD.")
   RETU .F.
ENDIF
IF ! CONFIND(ARQWORK)
   RETU .F.
ENDIF
//Pegando Cores de Trabalho
CORMAL:=CORARR("MAL")

//Variaveis de Trabalho
PRIV PCK:=.F.
PRIV mCHAVE

CRIARVARS(ARQWORK)

aMAL1={}    &&Matriz com os dizeres do Achoice
aMAL2={}    &&N£mero da Nota + Data de Vencimento


//Incializando a ajuda on Line
PRIV HELPDBF:=ARQWORK

//Carregando Matriz
IF cVIDE="S".AND.wcMAL#2
   nIND:=IF(lPIND,NUMIND(ARQWORK),nIEXI)
   IF ! USEREDE(ARQWORK,1,nIND)
      RETU
   ENDIF
   GRAF=LASTREC()
   IF GRAF>nACHO
      DBCLOSEAREA()
      ALERTX("Muitos Arquivos para o Modo Video")
      cVIDE:="N"
   ELSE
      xGRAF=0
      xPOS=1
      MARCAR()
      DBGOTOP()
      WHILE ! EOF()
         EQUVARS()
         MAL01(.F.)
         NETRECLOCK()
         FIELD-> JUROS     := mJUROS
         FIELD-> DIAS      := mDIAS
         FIELD-> DIFERENCA := mDIFERENCA
         FIELD-> VALATUAL  := mVALATUAL
         FIELD-> PREVATR   := mPREVATR
         DBUNLOCK()
         IF ! EMPTY(mCBAR)
            AADD(aMAL1,&mCBAR.)
         ELSE
            AADD(aMAL1,' '+STR(NRNOTA,  8)+' '+TIPFAT+' '+DTOC(VENCIMENT)+' '+STR(FORNECEDO,  5)+' '+COGNOME+' '+STR(VALATUAL, 18, 2)+' '+DDD+' '+TELEFONE+' '+COD)
         ENDIF
         AADD(aMAL2,DTOS(VENCIMENT)+STR(NRNOTA,8)+TIPFAT)
         xPOS++
         MARCAR1()
         DBSKIP()
      ENDDO
      DBCLOSEAREA()
      IF xPOS=1
         IF ! MDG('Nenhum Lan‡amento Neste Arquivo. Deseja Incluir ?')
            RETU .F.
         ENDIF
         nSBAR:=0
         IF ! fMAL(1,0)
            RETU .F.
         ENDIF
      ENDIF
   ENDIF
ENDIF

//Posi‡„o Inicial do Ponteiro

pMAL=1

//Processando o M‚todo Escolhido
IF cVIDE='S'
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR=LEN(aMAL1)
   aSBAR:= ScrollBarNew(03,79,23,,pMAL)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMAL,nSBAR,.T.)
   WHILE .T.
      SETCOLOR(CORMAL[1])
      HB_DISPBOX(2,0,23,79,B_DOUBLE)
      @ 3, 1 SAY cCBAS
      @ 4, 0 SAY '+'+replicate('-',78)+'Ý'
      MDS('Busca: ')
      ScrollBarUpdate(aSBAR,pMAL,nSBAR,.T.)
      ScrollBarDisplay(aSBAR)
      pMAL2=ACHOICE(05,01,22,78,aMAL1,,"ACHRETB",pMAL)
      pMAL=IF(pMAL2#0,pMAL2,pMAL)
      pMAL2=pMAL
      DO CASE
         CASE LASTKEY() = K_ESC
              IF MDG('Encerrar Consulta')
                 EXIT
              ENDIF
              LOOP
         CASE LASTKEY() = K_ALT_F10 ;  MDS('Imprimindo') ;  MANLISTA()
         CASE LASTKEY() = K_INS ;  MDS('Incluindo ') ;  fMAL(1,pMAL)
         CASE LASTKEY() = K_ENTER .AND. wMAL#3 ;  MDS('Alterando ') ;  fMAL(2,pMAL)
         CASE LASTKEY() = K_ENTER .AND. wMAL=3 ;  MDS('Escolhendo') ;  fMAL(6,pMAL) ; RETU
         CASE LASTKEY() = K_DEL ;  MDS('Excluindo ') ;  fMAL(3,pMAL)
         CASE LASTKEY() = K_CTRL_ENTER
              nIBUS   := IF(lPBUS,NUMIND(ARQWORK),nIBUS)
              mCHABUS := PEGBUS(ARQWORK,nIBUS)
              IF nIBUS#1
                 nREG    := REGBUS(ARQWORK,nIBUS,mCHABUS)
              ENDIF
              pMAL=ASCAN(aMAL2,mCHAVE)
              IF pMAL=0
                 ALERTX( 'Nao localizei o Registro Correspondente ....')
                 pMAL=pMAL2
                 LOOP
              ENDIF
         OTHERWISE ; LOOP
      ENDCASE
   ENDDO
ENDIF
IF cVIDE='N'
   METNVI(ARQWORK,{|| fMAL(1,0)},{|| fMAL(3,0)},{|| fMAL(2,0)},;
                 {|| fMAL(6,0)},{|| fMAL(2,-1)},CORMAL[1],wMAL)
ENDIF
IF cVIDE='P'
   METPAG(ARQWORK,CORMAL,"DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT",wMAL,;
          {||tMAL()},{||fMAL(1,0)},{||fMAL(3,0)},{||fMAL(2,0)},;
          {||fMAL(6,0)})
ENDIF

IF cVIDE='I'
   METINT(ARQWORK,,{||fMAL(2,-1)})
ENDIF


RELEASE ALL LIKE m*    //LIMPAVARS(ARQWORK)

//EFETUA O PACK SE NECESSARIO
IF PCK.AND.lFIXA
   FIXAR(ARQWORK)
ENDIF
RETU .T.

*****************************************************************************
FUNC fMAL(OPRMAL,POSMAL)   &&INC=1//MUD=2//EXC=3 // POSICAO MATRIZ
*****************************************************************************
//Pegar a Chave de Busca
IF OPRMAL#1
   IF cVIDE='S'
      mCHAVE:=aMAL2[POSMAL]
   ENDIF
   IF cVIDE='N'.AND.POSMAL#-1
      PEGBUS()
   ENDIF
ENDIF

//Opera‡„o de Exclus„o
IF OPRMAL=3
   IF APAGAREG(ARQWORK,mCHAVE)
      IF cVIDE="S"
         aMAL1[POSMAL]=' '+STR(mNRNOTA,8)+' '+DTOC(mVENCIMENT)+' '+mTIPFAT+' - Registro Excluido / Apagado / Deletado'
      ENDIF
      PCK=.T.
   ENDIF
   RETU .T.
ENDIF

//Opera‡„o de Inclus„o
IF OPRMAL=1
   CRIARVARS(ARQWORK)
   PEGBUS()
   mTIPOCLI:="F"
   IF ! NOVOREG(ARQWORK,mCHAVE)
      RETU .F.
   ENDIF
ENDIF



//IGUALAR mVARS
IF ! IGUALVARS(ARQWORK,mCHAVE)
   RETU .F.
ENDIF
yDATAPG  := mDATAPG
yVALORPG := mVALORPG


   // Desenha a Tela
   tMAL()
   // Get nas Menvars
   gMAL()



//Atualiza as Matrizes se nao for inclusao
IF cVIDE='S'.AND.OPRMAL#1
   IF !EMPTY(mCBARM)
      aMAL1[POSMAL]=&mCBARM.
   ELSE
      aMAL1[POSMAL]=' '+STR(mNRNOTA,  8)+' '+mTIPFAT+' '+DTOC(mVENCIMENT)+' '+STR(mFORNECEDO,  5)+' '+mCOGNOME+' '+STR(mVALATUAL, 18, 2)+' '+mDDD+' '+mTELEFONE+' '+mCOD
   ENDIF
   aMAL2[POSMAL]=DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT
ENDIF

//Posiciona o Novo Elemento na Matriz
IF cVIDE='S'.AND.OPRMAL=1
   MAL03()
ENDIF


IF ARQWORK=="ML01PG".AND.EMPTY(mDATAPG).AND.EMPTY(mVALORPG)
   IF MDG("Retornar ao Contas a Pagar")
      NOVOREG("ML01",mCHAVE)
      APAGAREG("ML01PG",mCHAVE,.F.)
      IF cVIDE="S"
         aMAL1[POSMAL]=' '+STR(mNRNOTA,8)+' '+mTIPFAT+' '+DTOC(mVENCIMENT)+' - Transferido Contas a Pagar'
      ENDIF
      RETU .T.
   ENDIF
ENDIF


IF ! EMPTY(mDATAPG).AND.! EMPTY(mVALORPG).AND."ML01"=ARQWORK
   mOBS:="Baixa Manual"
   NOVOREG("ML01PG",mCHAVE)
   APAGAREG(ARQWORK,mCHAVE,.F.)
   IF cVIDE="S"
      aMAL1[POSMAL]=' '+STR(mNRNOTA,8)+' '+mTIPFAT+' '+DTOC(mVENCIMENT)+' '+mTIPFAT+' - Transferido Contas Pagas'
   ENDIF
   IF ROUND(mDIFERENCA,2)>ROUND(0,2)
      mVALOR  := mDIFERENCA
      mVALORPG:= 0
      mDATAPG := CTOD("  /  /  ")
      mAVISO  := "S"
      IF cVIDE="S"
         I:=0
         mTIPFAT:=CHR(64+I)
         WHILE ASCAN(aMAL2,DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT)#0
            I++
            mTIPFAT:=CHR(64+I)
         ENDDO
         MAL03()
      ELSE
         WHILE .T.
            MDS("Digite o tipo da Fatura")
            @ 24,40 GET mTIPFAT VALID ! VERSEHA("ML01",DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT)
            IF READCUR()
               EXIT
            ENDIF
         ENDDO
      ENDIF
      NOVOREG("ML01",DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT)
   ENDIF
   PCK=.T.
ELSE
   REPORVARS(ARQWORK,mCHAVE)
ENDIF

RETU .T.


//Tela de Dados
*****************************************************************************
FUNC tMAL
*****************************************************************************
SETCOLOR(CORMAL[5])
HB_DISPBOX( 2, 0,23,79,B_DOUBLE)
//@  2,  0 SAY "+"+replicate('-',78)+"+"
@  3,  1 SAY "NotaFiscalÝ Emiss„o  ÝCliente"+spac(13)+"ÝDDD  Telefone  ÝVendedor ÝPedido"
@  4,  1 SAY "          Ý          Ý"+spac(20)+"Ý"+spac(15)+"Ý         Ý"
@  5,  0 SAY '+'+replicate('-',10)+"-"+replicate('-',10)+"-"+replicate('-',20)+"---"+replicate('-',13)+"-"+replicate('-',9)+"-"+replicate('-',9)+'Ý'
@  6,  2 SAY "Valor Total Negociado"+spac(22)+"ÝVencer  em            C¢dDep"
@  7, 45 SAY "Ý"
@  7,  2 SAY "Abater:              Documento:            ÝValor T¡tulo"
@  8,  2 SAY "Desconto PIS:            CONFINS:          ÝOutros/Encar"
@  9,  2 SAY "        CSLL:            IRRF:             Ý"
@ 10,  2 SAY "        ISS :            INSS:             Ý"
@ 10, 45 SAY "ÝValor Juros"
@ 11,  1 SAY "Bco:"+STR(mBCODEP)+"  Agc: "+mAGCDEP+" Cta: "+mCTADEP
@ 11, 45 SAY "Ý"
@ 12,  2 SAY "T¡tulo Colocado Banco :                    ÝValor Atual"
@ 13,  2 SAY "00=Cobran‡a SimplesÝAgencia"+spac(16)+"+"+replicate('-',33)+ 'Ý'
@ 14,  2 SAY "98=Vinculada       ÝDocBol:"+spac(16)+"Ý"
@ 15,  2 SAY "99-Descontada      ÝDocDup:"+spac(16)+"ÝAtraso:     dias. Taxa Dia:"
@ 16,  0 SAY '+'+replicate('-',20)+"-"+replicate('-',23)+"+"+replicate('-',33)+'Ý'
@ 17,  3 SAY "Observa‡”es Gerais de Cobran‡a :"+spac(10)+"Ý T¡tulo Pago em:"
@ 18, 45 SAY "Ý Valor Pago"
@ 19, 45 SAY "Ý Contabil"
@ 20, 45 SAY "Ý Diferen‡a"
@ 21, 45 SAY "Ý Cheque/Caixa OBS:"
@ 22, 45 SAY "Ý"
@ 23, 45 SAY "-"
SETCOLOR(CORMAL[3])
@  4, 1 SAY mNRNOTA
@  4,10 SAY mTIPFAT
@  4,12 SAY mDATA
@  4,23 SAY mTIPOCLI
@  4,25 SAY mFORNECEDO
@  4,31 SAY mCOGNOME
@  4, 44 SAY mDDD
@  4, 49 SAY mTELEFONE
@  4, 62 SAY mVENDEDOR
@  4, 70 SAY mPEDIDO
@  6, 25 SAY mTOTFAT
@  6, 57 SAY mVENCIMENT
@  6, 75 SAY mCOD          ///NOVO
@  7, 60 SAY mVALOR   pict '9999,999.99'
@  8, 60 SAY mENCARGOS
@  7, 10 SAY mABATER
@  7, 35 SAY mDOCABATE
@  8, 15 SAY mVALPIS
@  8, 34 SAY mVALFIN
@  9, 15 SAY mVALCSLL
@  9, 34 SAY mVALIRRF
@ 10, 15 SAY mVALISS
@ 10, 34 SAY mVALINSS
@ 10, 60 SAY mJUROS
@ 12, 30 SAY mBANCO
@ 13, 30 SAY mNOMEBCO
@ 14, 30 SAY mDOCBOL
@ 15, 30 SAY mDOCDUP
@ 15, 54 SAY mDIAS
@ 15, 74 SAY mTAXA       PICT "99.99"
@ 17, 64 SAY mDATAPG
@ 18,  3 SAY LEFT(mOBS1,40)
@ 19,  3 SAY LEFT(mOBS2,40)
@ 19, 59 SAY mVALORPG
@ 20,  3 SAY LEFT(mOBS3,40)
@ 21,  3 SAY LEFT(mOBS4,40)
@ 20, 59 SAY mDIFERENCA  PICT '@E 9999,999.99'
@ 22, 46 SAY mOBSPG
@ 24, 00 say LEFT(mOBS,30)
MAL01()
RETU .T.

//Get Nas Mvars
*****************************************************************************
FUNC gMAL
*****************************************************************************
TIPCAD(mTIPOCLI,"ARQUSO")
WHILE .T.
   SETCOLOR(CORMAL[2])
   @  4, 1 GET mNRNOTA     PICT '99999999'
   @  4,10 GET mTIPFAT
   READCUR()
   IF LASTKEY()<>3
      @  4,12 GET mDATA
      @  4,23 GET mTIPOCLI    VALID TIPCAD(mTIPOCLI,"ARQUSO",3,23)
      @  4,25 GET mFORNECEDO  VALID PEGACAMPO(ARQUSO,"mFORNECEDO",{"COGNOME","DDD","TELEFONE"},{"mCOGNOME","mDDD","mTELEFONE"}).AND.MAL01DEP()
      @  4,31 GET mCOGNOME    PICT "@S12"
      @  4,44 GET mDDD
      @  4,49 GET mTELEFONE
      @  4,70 GET mPEDIDO     PICT '99999999'
      @  6,25 GET mTOTFAT     PICT '9999,999.99'
      @  7,10 GET mABATER     PICT '999,999.99' VALID MAL01()
      @  7,35 GET mDOCABATE   PICT '99999999'
      @  8,15 GET mVALPIS    PICT '999,999.99' VALID MAL01()
      @  8,34 GET mVALFIN    PICT '999,999.99' VALID MAL01()
      @  9,15 GET mVALCSLL    PICT '999,999.99' VALID MAL01()
      @  9,34 GET mVALIRRF   PICT '999,999.99' VALID MAL01()
      @ 10,15 GET mVALISS     PICT '999,999.99' VALID MAL01()
      @ 10,34 GET mVALINSS   PICT '999,999.99' VALID MAL01()
      @ 11, 6 GET mBCODEP
      @ 11,14 GET mAGCDEP
      @ 11,25 GET mCTADEP
      READCUR()
   ENDIF
   @ 12,30 GET mBANCO      PICT '999' VALID CHECKEXI("MF01","STRZERO(mBANCO,3)","STRVAL(NUMERO)+' '+NOME","NUMERO","BANCO",.T.)
   READCUR()
   IF LASTKEY()<>3
      @ 13,30 GET mNOMEBCO    WHEN ALLTRUE(IF(EMPTY(mNOMEBCO),mNOMEBCO:=OBTER("MF01",STRZERO(mBANCO,3),"COGNOME"),.T.))
      @ 14,30 GET mDOCBOL     PICT '999999999999999'
      @ 15,30 GET mDOCDUP     PICT '999999999999999'
      READCUR()
   ENDIF
   @ 18, 3 GET mOBS1       PICT "@S40"
   @ 19, 3 GET mOBS2       PICT "@S40"  WHEN ! EMPTY(mOBS1)
   @ 20, 3 GET mOBS3       PICT "@S40"  WHEN ! EMPTY(mOBS2)
   @ 21, 3 GET mOBS4       PICT "@S40"  WHEN ! EMPTY(mOBS3)
   READCUR()
   @  6,57 GET mVENCIMENT                               VALID MAL01()
   READCUR()
   IF LASTKEY()<>3
      @  6,75 GET mCOD     valid CHECKEXI( "MI04", "mCOD", "Conta+' '+Nome", "LEFT(CONTA,3)", "MI04", .F. )
      @  7,60 GET mVALOR      PICT '9999,999.99' VALID MAL01()
      @  8,60 GET mENCARGOS   PICT '9999,999.99' VALID MAL01()
      @ 15,74 GET mTAXA    PICT "99.99"
      READCUR()
   ENDIF
   IF LASTKEY()<>3
      @ 17,64 GET mDATAPG
      @ 18,59 GET mVALORPG    PICT '9999,999.99' VALID MAL01() WHEN ALLTRUE(IF(! EMPTY(mDATAPG).AND.EMPTY(mVALORPG),mVALORPG:=mVALATUAL,""))
      @ 19,59 GET mCONTA VALID CHECKEXI("MF06","mCONTA","Conta+' '+Nome","CONTA","MF06",.T.)
      @ 22,46 GET mOBSPG
      READCUR()
   ENDIF
   IF ! MAL02()
      NOBREAK()
      KEYBOARD REPL(CHR(13),23)
      LOOP
   ELSE
      EXIT
   ENDIF
ENDDO

RETU .T.

****************
FUNC MAL01(pDIS)
IF valtype(pDIS)#"L"
   pDIS=.T.
ENDIF
DIAS:=0
mJUROS:=0
IF zDATA>mVENCIMENT.AND.EMPTY(mVALORPG).AND.! EMPTY(mVENCIMENT)
   mDIAS :=zDATA-mVENCIMENT
   mJUROS:=ROUND((((mVALOR*mTAXA)*mDIAS)/100),2)
ENDIF
IF ! EMPTY(mDATAPG).AND.! EMPTY(mVENCIMENT)
   mDIAS :=mDATAPG-mVENCIMENT
   mJUROS:=ROUND((((mVALOR*mTAXA)*mDIAS)/100),2)
ENDIF
mVALATUAL:=mVALOR+mJUROS-mABATER-mVALPIS-mVALFIN-mVALCSLL-mVALIRRF-mVALISS-mVALINSS+mENCARGOS
IF ! EMPTY(mVALORPG)
   mDIFERENCA:=mVALATUAL-mVALORPG
ENDIF
IF mDIAS>999.OR.mDIAS<0
   ALERTX("Cheque data Vencimento: "+STR(mNRNOTA)+" "+mTIPFAT+" "+DTOC(mVENCIMENT))
   mDIAS:=0
ENDIF
IF mDIAS>0
   IF mPREVATR<mDIAS
      mPREVATR=mDIAS
   ENDIF
ENDIF
IF pDIS
   @ 10,60 SAY mJUROS      PICT '@E 9999,999.99'
   @ 15,54 SAY mDIAS       PICT '999'
   @ 20,59 SAY mDIFERENCA  PICT '@E 9999,999.99'
   @ 12,60 SAY mVALATUAL   PICT '@E 9999,999.99'
   @ 22,46 SAY LEFT(mOBSPG,30)
   @ 24,00 SAY LEFT(mOBS,30)
ENDIF
RETU .T.


*****************************************************************************
FUNC MAL02
*****************************************************************************
IF ! EMPTY(mDATAPG)
   IF EMPTY(mVALORPG)
      MDE("VALPG","","")
      //ALERTX("Vocˆ n„o digitou o Valor do Pagamento")
      RETU .F.
   ENDIF
ENDIF
IF ! EMPTY(mVALORPG)
   IF EMPTY(mDATAPG)
      MDE("DATPG","","")
      //ALERTX("Vocˆ n„o digitou a Data de Pagamento")
      RETU .F.
   ENDIF
ENDIF
RETU .T.

*****************************************************************************
FUNC MAL03
*****************************************************************************
nSBAR++
AADD(aMAL1,NIL)
AADD(aMAL2,NIL)
POSMAL=LEN(aMAL1)
POSW=1
IF POSMAL>1
   FOR X = 1 TO POSMAL-1
       mDARE=aMAL2[X]
       IF mCHAVE<=mDARE
          EXIT
       ENDIF
   NEXT
   POSW=X
ENDIF
AINS(aMAL1,POSW)
AINS(aMAL2,POSW)
IF !EMPTY(mCBARM)
   aMAL1[POSW]=&mCBARM.
ELSE
   aMAL1[POSW]=' '+STR(mNRNOTA,  8)+' '+mTIPFAT+' '+DTOC(mVENCIMENT)+' '+STR(mFORNECEDO,  5)+' '+mCOGNOME+' '+STR(mVALATUAL,18,2)+' '+mDDD+' '+mTELEFONE+' '+mCOD
ENDIF
aMAL2[POSW]=DTOS(mVENCIMENT)+STR(mNRNOTA,8)+mTIPFAT
pMAL=POSW
RETU .T.


FUNC CHECKCOD(cCODIGO)
LOCAL nPOS,cCOD:=' '+cCODIGO+' '
IF LASTKEY()=K_UP.OR.LASTKEY()=K_DOWN
   RETU .T.
ENDIF
nPOS:=ASCAN(aCODHIS,cCOD)
nPOS:=IF(nPOS>1,nPOS,1)
nPOS:=ESCARR(aCODHIS,7,7,21,78,aCODHIS,nPOS,"Cod Descri‡„o")
nPOS:=IF(nPOS>1,nPOS,1)
cCOD:=aCODHIS[nPOS]
mHISTORICO:=SUBSTR(cCOD,2,3)
RETU .T.


FUNC MAL01DEP
IF ARQUSO=="MB01"
   IF EMPTY(mCTADEP)
      PEGACAMPO(ARQUSO,"mFORNECEDO",{"BANCO","AGENCIA","CONTA"},{"mBCODEP","mAGCDEP","mCTADEP"})
      @ 11,  1 SAY "Bco:"+STR(mBCODEP)+"  Agc: "+mAGCDEP+" Cta: "+mCTADEP
   ENDIF
ENDIF
RETU .T.
