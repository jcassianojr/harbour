*:****************************************************************************
*:
*:      M_AM .PRG: Notas Fiscais de Vendas
*:      Linguagem: Clipper 5.x
*:        Sistema: ITAESBRA
*:      Copyright (c) 1999, Softec Sistemas
*:
*:*****************************************************************************


//Teclas Operacionais
//#INCLUDE "TECLAS.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

function m_am
PARA nTIPO

ARQWORK1 := "MM01"
ARQWORK2 := "MM02"
ARQWORK4 := "MM06"
ARQWORK5 := "MN01"
cTRABALHO:="NOTAFISCAL"
xPISEMP := OBTER( "MANEMP", ZNUMERO, "PERPIS" )
xFINEMP := OBTER( "MANEMP", ZNUMERO, "PERFIN" )


IF nTIPO=2
   cVAR     := MESANO()
   ARQWORK1 := "M1" + cVAR
   ARQWORK2 := "M2" + cVAR
   ARQWORK4 := "M6" + cVAR
   ARQWORK5 := "MN" + cVAR
ENDIF

IF nTIPO=3
   ARQWORK1 := "MM91"
   ARQWORK2 := "MM92"
   ARQWORK4 := "MM96"
   ARQWORK5 := "MN99"
ENDIF


PRIV wMAM, wpMAM, wcMAM

wMAM  := 0
wcMAM := 0
wPMAM := 1


//Modo de Trabalho no Video
MDI(" Ý ",,,ARQWORK1)

//Configura‡„o de Trabalho
PRIV lFIXA,nACHO,cVIDE,lPBUS,lPIND,mCBAR,mCBARM,cTIPG,aGETS,cCBAS,nIBUS
PRIV nIEXI,aIND,nREG
IF ! CONFARQ(ARQWORK1,"Nota    Emiss„o F Fornecedor"+spac(9)+"S Ope P S Pag  Valor Total da NF")
   RETU .F.
ENDIF
IF ! CONFIND(ARQWORK1)
   RETU .F.
ENDIF


//Pegando Cores de Trabalho
CORMAM:=CORARR("MAM")


//Telas de Trabalho
aMAMTEL:=TELAPEG("ITMM01")
aMAMGET:=EDITPEG("ITMM01")

aMDETEL:=TELAPEG("MMDE01")
aMDEGET:=EDITPEG("MMDE01")



//Variaveis de Trabalho
PUBLIC mTIPOSERV
//mTIPOSERV:=SPACE(1)
mESTADO:="  "
mIESTADUAL:=""
mLISTA:=0
ZESTADO:=OBTER("MANEMP",ZNUMERO,"ESTADO")

PRIV PCK:=.F.
PRIV mCHAVE

CRIARVARS("MA01")
CRIARVARS("MN01")
CRIARVARS(ARQWORK1)
CRIARVARS(ARQWORK4)
CRIARVARS("MM02")
CRIARVARS("MM04")

aMAM1={}    &&Matriz com os dizeres do Achoice
aMAM2={}    &&Por N£mero da Nota Fiscal


//Incializando a ajuda on Line
PRIV HELPDBF:="MM01"

//Carregando Matriz
IF cVIDE="S".AND.wcMAM#2
   nIND:=IF(lPIND,NUMIND(ARQWORK1),nIEXI)
   IF ! USEREDE(ARQWORK1,1,nIND)
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
      dbgotop()
      WHILE ! EOF()
         AADD(aMAM1,MAMSAY01())
         AADD(aMAM2,NUMERO)
         xPOS++
         MARCAR1()
         DBSKIP()
      ENDDO
      DBCLOSEAREA()
      IF xPOS=1
         IF ! MDG('Nenhum Lan‡amento Neste Arquivo Deseja Incluir')
            RETU .F.
         ENDIF
         nSBAR:=0
         IF ! fMAM(1,0)
            RETU .F.
         ENDIF
      ENDIF
   ENDIF
ENDIF

pMAM=1

//Processando o M‚todo Escolhido
IF cVIDE='S'
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR=LEN(aMAM1)
   aSBAR:= ScrollBarNew(03,79,23,,pMAM)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMAM,nSBAR,.T.)
   WHILE .T.
      SETCOLOR(CORMAM[1])
      HB_DISPBOX(2,0,23,79,B_DOUBLE)
      @ 3, 1 SAY cCBAS
      @ 4, 0 SAY '+'+replicate('-',78)+'Ý'
      MDS('Busca: CTRL+ENTER=BUSCA ALT+F10=LISTAR')
      ScrollBarUpdate(aSBAR,pMAM,nSBAR,.T.)
      ScrollBarDisplay(aSBAR)
      pMAM2=ACHOICE(05,01,22,78,aMAM1,,"ACHRETB",pMAM)
      pMAM=IF(pMAM2#0,pMAM2,pMAM)
      pMAM2=pMAM
      DO CASE
         CASE LASTKEY() = K_ESC
              IF MDG('Encerrar Consulta')
                 EXIT
              ENDIF
              LOOP
         CASE LASTKEY() = K_ALT_F10 ;  MDS('Imprimindo') ;  mCHAVE:=aMAM2[pMAM] ; M_A7I(mCHAVE,.T.,.T.)
         CASE LASTKEY() = K_INS ;  MDS('Incluindo ') ;  fMAM(1,pMAM)
         CASE LASTKEY() = K_ENTER .AND. wMAM#3 ;  MDS('Alterando ') ;  fMAM(2,pMAM)
         CASE LASTKEY() = K_ENTER .AND. wMAM=3 ;  MDS('Escolhendo') ;  fMAM(6,pMAM) ; RETU
         CASE LASTKEY() = K_DEL ;  MDS('Excluindo ') ;  fMAM(3,pMAM)
         case LASTKEY() = K_CTRL_ENTER
             nIBUS   := if( lPBUS, NUMIND( ARQWORK1 ), nIBUS )
             mCHABUS := PEGBUS( ARQWORK1, nIBUS )
             if nIBUS # 1
                nREG := REGBUS( ARQWORK1, nIBUS, mCHABUS )
             endif
             pMAM := ascan( aMAM2, mCHAVE )
             if pMAM = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMAM := pMAM2
              loop
             endif
         OTHERWISE ; LOOP
      ENDCASE
   ENDDO
ENDIF


//LIBERA VARIAVEIS
RELEASE ALL LIKE m*    //LIMPAVARS(ARQWORK1)


//EFETUA O PACK SE NECESSARIO
IF PCK.AND.lFIXA
   FIXAR(ARQWORK1)
   FIXAR(ARQWORK2)
   FIXAR(ARQWORK4)
ENDIF
RETU .T.

*******************
FUNC fMAM(OPRMAM,POSMAM,lINC,lPAGAR)   &&INC=1//MUD=2//EXC=3 // POSICAO MATRIZ
*******************
//Pegar a Chave de Busca
INCLUI:=.F.
IF VALTYPE(lPAGAR)#"L"
   Lpagar:=.f.
ENDIF
lMES:=.F.
IF VALTYPE(lINC)="L"
   INCLUI:=.T.
   lpagar:=.t.
   lMES:=.T.
ENDIF
IF OPRMAM#1
   IF cVIDE='S'
      mCHAVE:=aMAM2[POSMAM]
   ENDIF
   IF cVIDE='N'.AND.POSMAM#-1
      pegbus()
   ENDIF
ENDIF


//Opera‡„o de Inclus„o
IF OPRMAM=1
   CRIARVARS("MM01")
   CRIARVARS("MM02")
   pegbus()
   mTIPOCLI :='C'
   mOPERACAO:='511'
   mCFONEW :="5101"
   mDATA    :=ZDATA
   mTIPONF   :="S"
   mTIPOFR   :=" "
   mEMBALAGEM:="GRANEL"
   IF ! NOVOREG(ARQWORK1,mCHAVE)
      RETU .F.
   ENDIF
   INCLUI:=.T.
   lpagar:=.t.
ENDIF

//IGUALAR mVARS
IF ! IGUALVARS(ARQWORK1,mCHAVE)
   RETU .F.
ENDIF
xORDEM:=mORDEM

//Opera‡„o de Exclus„o
IF OPRMAM=3
   IF ! MDG("Deseja Realmente Apagar a NF")
      RETU .F.
   ENDIF
   IF ! EMPTY(mCOPIA)
      IF ! MDG("Esta nota e copia da: "+STR(mCOPIA)+"Apagar")
         RETU .F.
      ENDIF
   ENDIF
   lAPAOS:=.F.
   IF ARQWORK1="MM01"
      lAPAOS := MDG("Deseja Retornar as quantidades as OS")
   ENDIF
   M_A70(mNUMERO,lAPAOS,{ARQWORK1,ARQWORK2,ARQWORK4,ARQWORK5,"MO02"})
   IF cVIDE="S"
      aMAM1[POSMAM]=' '+STR(mNUMERO,8)+' '+STR(mFORNECEDO,5)+' - Registro Excluido / Apagado / Deletado'
   ENDIF
   RETU .T.
ENDIF


//  Data Antiga...
aDATOLD:={mDAT01,mDAT02,mDAT03,mDAT04,mDAT05,mDAT06,mDAT07,mDAT08,mDAT09,mDAT10}



// Desenha a Tela
TELASAY(aMAMTEL)
// Get nas Menvars
EDITSAY(aMAMGET)

IF lMES
   cTELA:=SAVESCREEN(00,00,24,79)
   ARQWORK="MM04" ; M_AM4(3) // Pega a Mensagem
   RESTSCREEN(00,00,24,79,cTELA)
   lMES:=.F.
ENDIF


yNUMERO    := mNUMERO
yDATA      := mDATA
yFORNECEDO := mFORNECEDO
yOPERACAO  := mOPERACAO
yCFONEW    := mCFONEW
yCFONEWB   := mCFONEWB
ySUBOPER   := mSUBOPER
yAPURA     := mAPURA
yESPECIE   := mESPECIE

xTOTALPES  := mTOTALPES
IF INCLUI
   xTOTALPES:=0
ENDIF



IF INCLUI
   PADRAX(3,mTRANSPORT,0,{"MG01","MG02"},"N£mero  Nome"+spac(38)+"Cognome"+spac(6)+"DDD  Telefone",;
            "' '+mNUMERO+' '+mNOME+' '+mCOGNOME+' '+mDDD+' '+mTELEFONE","MAG001","MAG001",;
            {|| MAGEN2() },,{|| MAGREP()})
ENDIF


//Itens da Nota Fiscal
IF EMPTY(mESTADO)
   mESTADO:=OBTER(ARQUSO,mFORNECEDO,"ESTADO")
ENDIF
M_AM2(1)



//DIPI
IF ALLTRIM(mESPECIE)#"NFE".AND.MDG("Alterar Dados DIPI")
   xNUMERO   :=mNUMERO
   xDATAREF  :=mDATA
   mDATAREF  :=mDATA
   xDATA     :=mDATA
   xTIPOFOR  :=mTIPOCLI
   xFORNECEDO:=mFORNECEDO
   xCOGNOME  :=mCOGNOME
   IF EMPTY(mORDEM).AND.ARQWORK1="MM01" //Primeiro Movimento
      M_ADIC(2)
      WHILE ! USEREDE("MD04",1,1)
      ENDDO
      WHILE ! USEREDE(ARQWORK2,1,99)
      ENDDO
      DBSETORDER(1)
      WHILE ! USEREDE(ARQWORK4,1,99)
      ENDDO
      DBSETORDER(1)
      MDT01()
      DBCLOSEALL()
   ENDIF
   M_ADI2(1)
ENDIF


//Calculando Parcelas
IF EMPTY(mVAL01)
   MPAGAR(mCONDPAG,mTOTNF,mDATA,.T.)
ENDIF
//Calculando pis/confins
IF mTIPOCLI="C".AND.OBTER("MA01",yFORNECEDO,"TEMPISFIN")="S"
   mVALPIS:=ROUND(mTOTNF*XPISEMP/100,2)
   mVALFIN:=ROUND(mTOTNF*XFINEMP/100,2)
ENDIF

//Checando Parcelas
CHECKPAR(,"2","mNUMERO")


IF MDG("Deseja Rever Observa‡”es")
   HB_DISPBOX( 3, 0,18,79,B_DOUBLE)
   @  4,  5 SAY "Linhas do Corpo da Nota Fiscal"
   @ 14,  5 SAY "Linhas de Observa‡„o"
   // Get nas Menvars
   @  5, 1 GET mLIN01
   @  6, 1 GET mLIN02
   @  7, 1 GET mLIN03
   @  8, 1 GET mLIN04
   @  9, 1 GET mLIN05
   @ 10, 1 GET mLIN06
   @ 11, 1 GET mLIN07
   @ 12, 1 GET mLIN08
   @ 15, 1 GET mOBS1
   @ 16, 1 GET mOBS2
   @ 17, 1 GET mOBS3
   READCUR()
ENDIF



CRECE:="N"
IF ARQWORK1="MM01"
   CRECE := if( Lpagar, OBTER( "MD04", mCFONEW, "CONTAS",2,,,,,"S" ), "N" )
   @ 24, 00 clea
   @ 24, 05 say "Transfere Dados para o Contas a Receber <S/N> ?  " get CRECE pict '@!' valid CRECE $ 'SN'
   READCUR()
ENDIF

IF CRECE="S"
   @ 24,00 CLEA
   @ 24,05 SAY "Transferindo Dados para o Contas a Receber . . ."
   // Transferˆncia de Dados para o Contas a Receber (MN01).
   xNUMERO  := mNUMERO       //Salva vari veis NUMERO e DATA do MM01.
   xDATA    := mDATA
   xPEDIDO  := mPEDIDO
   xSITUACAO:= mSITUACAO
   mSITUACAO:= 0
   mPEDIDO  :=0
   aDATAS:={mDAT01,mDAT02,mDAT03,mDAT04,mDAT05,;
   mDAT06,mDAT07,mDAT08,mDAT09,mDAT10}
   aVALOR:={mVAL01,mVAL02,mVAL03,mVAL04,mVAL05,;
   mVAL06,mVAL07,mVAL08,mVAL09,mVAL10}
//   ALERTX(mTIPOCLI)
   IF mTIPOCLI="C"
      mBANCO:=OBTER("MA01",yFORNECEDO,"BCOCOB")
   ENDIF
//   ALERTX(STR(mBANCO))
   FOR W=1 TO 10
       mTIPFAT   := CHR(64+W)      //Tipo do Faturamento (A,B,C...)
       IF W=1.AND.EMPTY(aDATAS[2]) //Somente um vencimento
          mTIPFAT:=" "
       ENDIF
       mVENCIMENT:=aDATAS[W]
       mVALOR    :=aVALOR[W]
       yDAT      :=aDATOLD[W]
       DO CASE
          CASE yDAT=mVENCIMENT .AND. mVALOR > 0    //Caso Data Antiga for igual Data Atual
               IF ! VERSEHA("MN01",DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT)
                  //Cadastra novo lan‡amento
                  NOVOREG("MN01",DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT)
               ELSE
                  //Altera lan‡amentos
                  REPORVARS("MN01",DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT)
               ENDIF
          CASE yDAT=mVENCIMENT .AND. mVALOR = 0
               IF ! VERSEHA("MN01",DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT)
                  APAGAREG("MN01",DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT,.F.)
               ENDIF
          CASE yDAT=mVENCIMENT .AND. EMPTY(mVENCIMENT)
               IF ! VERSEHA("MN01",DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT)
                  APAGAREG("MN01",DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT,.F.)
               ENDIF
          CASE yDAT<>mVENCIMENT .AND. mVALOR > 0
               IF VERSEHA("MN01",DTOS(yDAT)+STR(mNUMERO,8)+mTIPFAT)
                  APAGAREG("MN01",DTOS(yDAT)+STR(mNUMERO,8)+mTIPFAT,.F.)
               ENDIF
               NOVOREG("MN01",DTOS(mVENCIMENT)+STR(mNUMERO,8)+mTIPFAT,.F.)
          CASE yDAT<>mVENCIMENT .AND. mVALOR = 0
               IF VERSEHA("MN01",DTOS(yDAT)+STR(mNUMERO,8)+mTIPFAT)
                  APAGAREG("MN01",DTOS(yDAT)+STR(mNUMERO,8)+mTIPFAT,.F.)
               ENDIF
          CASE yDAT<>mVENCIMENT .AND. EMPTY(mVENCIMENT)
               IF VERSEHA("MN01",DTOS(yDAT)+STR(mNUMERO,8)+mTIPFAT)
                  APAGAREG("MN01",DTOS(yDAT)+STR(mNUMERO,8)+mTIPFAT,.F.)
               ENDIF
       ENDCASE
   NEXT
   mNUMERO  := xNUMERO     //Retorna as vari veis que foram salvadas.
   mDATA    := xDATA
   mSITUACAO:= xSITUACAO
   mPEDIDO  := xPEDIDO
   @ 24,00 CLEA
ENDIF
IF (EMPTY(mTOTALBRU).OR.xTOTALPES#mTOTALPES).AND.mTOTALPES>0
   mTOTALBRU:=mTOTALPES
ENDIF


HB_DISPBOX(9,0,23,79,B_DOUBLE)
@ 14,02 SAY 'Placa Caminhao -> ' GET mTRANSP  VALID validaPlaca(mTRANSP)
@ 15,02 SAY 'Motorista ....... ' GET mMOTORISTA
@ 16,02 SAY 'Frete Por Conta   ' GET mTIPOFR VALID mTIPOFR $ "12 "
@ 16,25 SAY "1-Emitente 2-Destinatario"
@ 17,03 SAY 'Embalagem: '
@ 18,03 SAY 'Marca'
@ 18,09 SAY 'Numero'
@ 18,15 SAY 'Qtde '
@ 18,22 SAY 'Especie:    '
@ 18,38 SAY 'Peso  Liq:'
@ 18,54 SAY 'Peso  Bru:'
@ 21,03 SAY 'Valor Remessa:'
@ 19,03 GET mMARCAEMB
@ 19,09 GET mNUMEROEMB
@ 19,15 GET mQUANTEMB  pict "999999"
@ 19,22 GET mEMBALAGEM
@ 19,38 GET mTOTALPES  PICT '@E 99,999.99'
@ 19,54 GET mTOTALBRU  PICT '@E 99,999.99'
@ 21,23 GET mVALREM
READCUR()


//Atualiza as Matrizes se nao for inclusao
IF cVIDE='S'.AND.OPRMAM#1
   aMAM1[POSMAM]=MAMSAY02()
ENDIF

//Posiciona o Novo Elemento na Matriz
IF cVIDE='S'.AND.OPRMAM=1
   nSBAR++
   AADD(aMAM1,NIL)
   AADD(aMAM2,NIL)
   POSMAM=LEN(aMAM1)
   POSW=1
   IF POSMAM>1
      FOR X = 1 TO POSMAM-1
          mDARE=aMAM2[X]
          IF mCHAVE<=mDARE             // IF STR(NUMERO,8)+STR(FORNECEDO,5)<=mDARE
             EXIT
          ENDIF
      NEXT
      POSW=X
   ENDIF
   AINS(aMAM1,POSW)
   AINS(aMAM2,POSW)
   aMAM1[POSW]=MAMSAY02()
   aMAM2[POSW]=mNUMERO
   pMAM=POSW
ENDIF
REPORVARS(ARQWORK1,mNUMERO)
RETU .T.




FUNC MAMK01
PEGACAMPO(ARQUSO,"mFORNECEDO",{"COGNOME" ,"DDD" ,"ESTADO" ,"TELEFONE"},;
{"mCOGNOME","mDDD","mESTADO","mTELEFONE" })
mICM := OBTER("MD05",mESTADO,"ALIQUOTA")
IF INCLUI
   mCONDPAG  := OBTER(ARQUSO,mFORNECEDO,"CONDPAG")
   IF mTIPOCLI="C"
      PEGACAMPO(ARQUSO,"mFORNECEDO",{"VENDEDOR" ,"ZONA"},;
      {"mVENDEDOR","mZONA"})
   ENDIF
ENDIF
@ 10,11 SAY mVENDEDOR
@ 11,11 SAY mZONA
RETU .T.



FUNC MAMSAY02
LOCAL cRETU:=""
IF EMPTY(mCFONEW)
   cRETU:=' '+STR(mNUMERO,  8)+' '+DTOC(mDATA)+' '+mTIPOCLI+' '+STR(mFORNECEDO,  5)+' '+mCOGNOME+' '+mOPERACAO+'.'+mSUBOPER+' '+mCONDPAG+' '+STR(mTOTNF, 18, 2)
ELSE
   cRETU:=' '+STR(mNUMERO,  8)+' '+DTOC(mDATA)+' '+mTIPOCLI+' '+STR(mFORNECEDO,  5)+' '+mCOGNOME+' '+TRANSFORM(mCFONEW,"@R 9.999")+IF(EMPTY(mCFONEWB),"      ","/"+TRANSFORM(mCFONEWB,"@R 9.999"))+' '+mCONDPAG+' '+STR(mTOTNF, 18, 2)
ENDIF
RETU cRETU


FUNC MAMSAY01
IF EMPTY(CFONEW)
   cRETU:=' '+STR(NUMERO,8)+' '+DTOC(DATA)+' '+TIPOCLI+' '+STR(FORNECEDO,5)+' '+COGNOME+' '+OPERACAO+'.'+SUBOPER+' '+CONDPAG+' '+STR(TOTNF, 18, 2)
ELSE
   cRETU:=' '+STR(NUMERO,8)+' '+DTOC(DATA)+' '+TIPOCLI+' '+STR(FORNECEDO,5)+' '+COGNOME+' '+TRANSFORM(CFONEW,"@R 9.999")+IF(EMPTY(CFONEWB),"      ","/"+TRANSFORM(CFONEWB,"@R 9.999"))+' '+CONDPAG+' '+STR(TOTNF,18,2)
ENDIF
RETU cRETU
