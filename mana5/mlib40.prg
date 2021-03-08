*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib40.prg
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


//Teclas Operacionais
//#INCLUDE "TECLASM.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
// #INCLUDE "MEMOGET.CH"



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PADRAX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PADRAX

//Recebendo Parametro de Trabalho
para wPAX,wpPAX,wcPAX,aWARQ,PAXCAB,PAXDIZ,bPAXTEL,bPAXGET,bPAXEN2,bDELSEC,;
 bPOSREP,bPAXINS,PAXCOR,bPOSIGU,bPAXTEC,bANTREP,bPOSINS,bPOSEDI,eFILTRO

if VALTYPE(wcPAX) # "N"
   wcPAX := 0
endif

//Modo de Trabalho no Video
MDI(" � ",,,aWARQ[1])

//Configura��o de Trabalho
priv lFIXA
priv nACHO
priv cVIDE
priv lPBUS
priv lPIND
priv mCBAR
priv mCBARM
priv cTIPG
priv aGETS
priv cCBAS
priv nIBUS
priv nIEXI
priv aIND
priv nREG
priv nROW
if !CONFARQ(aWARQ[1],PAXCAB,PAXDIZ)
   retu .F.
endif
if !CONFIND(aWARQ[1])
   retu .F.
endif

//Chaves de Trabalho
priv wMFOR := aIND[1,4]
priv wMVAR := aIND[1,1,3]
priv wMCHA := if(empty(wMFOR),wMVAR,wMFOR)
priv wCHA  := strtran(wMCHA,"m","")
priv nROW  := 24

//Pegando Cores de Trabalho
CORPAX := CORARR(if(valtype(PAXCOR) = "C",PAXCOR,"PAX"))

//Verificando Tela
priv aPAXTEL := {}
if valtype(bPAXTEL) = "C"
   aPAXTEL := TELAPEG(bPAXTEL)
   bPAXTEL := {|| TELASAY(aPAXTEL)}
endif

//Verificando a Edi�ao
priv aPAXGET := {}
if valtype(bPAXGET) = "C"
   aPAXGET := EDITPEG(bPAXGET)
   bPAXGET := {|| EDITSAY(aPAXGET)}
endif

//Variaveis de Trabalho
priv PCK    := .F.
priv mCHAVE
priv xCHAVE

if wPAX = 0
   for X := 1 to len(aWARQ)
      xmCBAR  := mCBAR
      xmCBARM := mCBARM
      CRIARVARS(aWARQ[X])
      mCBAR  := xmCBAR
      mCBARM := xmCBARM
   next X
endif

//CRIANDO MATRIZES
if wcPAX = 0
   priv aPAX1
   priv aPAX2
   aPAX1 := {}  //Matriz com os dizeres do Achoice
   aPAX2 := {}  //Numero de Cadastramento
endif

//Incializando a ajuda on Line
priv HELPDBF := aWARQ[1]


if valtype(eFILTRO) = "U"
   eFILTRO := .F.
endif
IF VALTYPE(eFILTRO) = "L"
   IF eFILTRO
      eFILTRO := ''
      eFILTRO := RFILORD(aWARQ[1],.F.)
   ENDIF
ENDIF



//Carregando Matriz
if cVIDE = "S" .and. wcPAX # 2
   nIND := if(lPIND,NUMIND(aWARQ[1]),nIEXI)
   if !USEREDE(aWARQ[1],1,nIND)
      retu
   endif
   GRAF := lastrec()
   if GRAF > nACHO
      dbclosearea()
      ALERTX("Muitos Arquivos para o Modo Video")
      cVIDE := "T"
   else
      xGRAF := 0
      xPOS  := 1
      MARCAR()
      if valtype(eFILTRO) = "C" .AND. !empty(eFILTRO)
         set filter to &eFILTRO
      endif
      dbgotop()
      while !eof()
         aadd(aPAX1,&mCBAR.)
         aadd(aPAX2,&wCHA.)
         xPOS ++
         MARCAR1()
         dbskip()
      enddo
      dbclosearea()
      if xPOS = 1
         if !mdg('Nenhum Lan�amento Neste Arquivo Deseja Incluir')
            retu .F.
         endif
         nSBAR := 0
         if !fPAX(1,0)
            retu .F.
         endif
      endif
   endif
endif

//Posi��o Inicial do Ponteiro
if pcount() = 1
   pPAX := 1
else
   pPAX := ascan(aPAX2,wpPAX)
   pPAX := if(pPAX = 0,1,pPAX)
endif

//Processando o M�todo Escolhido
if cVIDE = 'S'
   NOBREAK()
   priv nSBAR
   priv aSBAR
   nSBAR := len(aPAX1)
   aSBAR := ScrollBarNew(04,79,24 - 1,substr(CORPAX[1],rat(",",CORPAX[1])+1),pPAX)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pPAX,nSBAR,.T.)
   while .T.
      CABVID(CORPAX[1],pPAX)
      nKEY := 0
      keyboard chr(255)
      bELE  := {| X | aPAX1[X]}
      cCOR  := CORPAX[1]
      pPAX2 := achoice(05,01,24 - 2,78,aPAX1,,"ACHMOU",pPAX)
      pPAX  := if(pPAX2 # 0,pPAX2,pPAX)
      pPAX2 := pPAX
      nROW  := row()
      do case
         case LASTKEY() = K_ESC
            if mdg('Encerrar Consulta')
               exit
            endif
            loop
         case LASTKEY() = K_ALT_F10
            MDS('Imprimindo')
            MANLISTA()
         case LASTKEY() = K_INS
            MDS('Incluindo ')
            fPAX(1,pPAX)
         case LASTKEY() = K_ENTER .and. wPAX # 3
            MDS('Alterando ')
            fPAX(2,pPAX)
         case LASTKEY() = K_ENTER .and. wPAX = 3
            MDS('Escolhendo')
            fPAX(6,pPAX)
            retu
         case LASTKEY() = K_DEL
            MDS('Excluindo ')
            fPAX(3,pPAX)
         case LASTKEY() = K_CTRL_ENTER
            nIBUS   := if(lPBUS,NUMIND(aWARQ[1]),nIBUS)
            mCHABUS := PEGBUS(aWARQ[1],nIBUS)
            if nIBUS # 1
               nREG := REGBUS(aWARQ[1],nIBUS,mCHABUS)
            else
               pPAD := ascan(aPAX2,mCHAVE)
               IF pPAD = 0 .AND. VALTYPE(mCHABUS) = "N"   //Simular Softec Seek
                  nREG := REGBUS(aWARQ[1],nIBUS,mCHABUS)
               ENDIF
            endif
            pPAX := ascan(aPAX2,mCHAVE)
            if pPAX = 0
               ALERTX('Nao localizei o Registro Correspondente ....')
               pPAX := pPAX2
               loop
            endif
         case valtype(BPAXTEC) = "B"
            eval(bPAXTEC,nKEY,pPAX)
         otherwise
            loop
      endcase
   enddo
endif
if cVIDE = 'N'
   METNVI(aWARQ[1],{|| fPAX(1,0)},{|| fPAX(3,0)},{|| fPAX(2,0)},;
    {|| fPAX(6,0)},{|| fPAX(2,- 1)},CORPAX[1],wPAX)
endif
if cVIDE = 'P'
   METPAG(aWARQ[1],CORPAX,wMCHA,wPAX,;
    bPAXTEL,{|| fPAX(1,0)},{|| fPAX(3,0)},{|| fPAX(2,0)},;
    {|| fPAX(6,0)})
endif
if cVIDE = 'T'
   IF VALTYPE(bPOSINS) = "B"
      aREP := bPOSINS
   ELSE
      aREP := {}
      for X := 1 to 3
         if !empty(aIND[1,X,3])
            cVARGET := aIND[1,X,3]
            aadd(aREP,{strtran(cVARGET,"m",""),cVARGET})
         endif
      next X
   ENDIF
   METBRO(aWARQ[1],aREP,CORPAX,{|| &mCBAR.},bPAXTEL,bPAXGET,,,wPAX,,,,,bPAXINS,bPOSREP,bPOSIGU,bDELSEC,eFILTRO)
endif

if cVIDE = 'I'
   METINT(aWARQ[1],,{|| fPAX(2,- 1)})
endif

if wPAX = 0
   release all like m *
endif

//EFETUA O PACK SE NECESSARIO
if PCK .and. lFIXA
   for X := 1 to len(aWARQ)
      FIXAR(aWARQ[X])
   next X
endif

retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fPAX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func fPAX


// *********
para OPRPAX,POSPAX
//Fixa Inclus�o Como Falsa
INCLUI := .F.

//Pegar a Chave de Busca
if OPRPAX # 1
   if cVIDE = 'S'
      mCHAVE := aPAX2[POSPAX]
   endif
   if cVIDE = 'N' .and. POSPAX # - 1
      PEGBUS(aWARQ[1],1)
   endif
endif

if OPRPAX = 6 .and. valtype(bPAXEN2) = "B"
   eval(bPAXEN2)
   retu .T.
endif

//Opera��o de Inclus�o
if OPRPAX = 1
   IF !padraolib("I","Inclusao n�o Liberado",aWARQ[1])
      RETU .F.
   ENDIF
   CRIARVARS(aWARQ[1])
   if valtype(bPAXINS) = "B"
      //      ALERTX("bloco pre")
      lTMPRETU := eval(bPAXINS)
      //      ALERTX(strval(Ltmpretu))
      IF VALTYPE(lTMPRETU) = "L"
         //         ALERTX(" logico")
         IF !lTMPRETU
            //            ALERTX("retornando")
            RETU .F.
         ENDIF
      ENDIF
   endif
   PEGBUS()
   if valtype(bPOSINS) = "B"
      //      ("bloco pos")
      eval(bPOSINS)
   endif
   if !NOVOREG(aWARQ[1],mCHAVE)
      retu .F.
   endif
   INCLUI := .T.
   nROW   := 24
endif

//IGUALAR mVARS
if !IGUALVARS(aWARQ[1],mCHAVE)
   retu .F.
endif
xCHAVE := mCHAVE

//Opera��o de Exclus�o
if OPRPAX = 3
   IF !padraolib("E","Exclusao n�o Liberado",aWARQ[1])
      RETU .F.
   ENDIF
   if MDG("Apagar Registro")
      if APAGAREG(aWARQ[1],mCHAVE,.F.)
         if valtype(bDELSEC) = "B"
            eRETU := eval(bDELSEC)
            if valtype(eRETU) = "L"
               if !eRETU
                  retu .F.
               endif
            endif
         endif
         if cVIDE = "S"
            aPAX1[POSPAX] = ' Registro Excluido / Apagado / Deletado '
         endif
         PCK := .T.
      endif
   endif
   retu .T.
endif

//Blocao Apos o Igualvars
if valtype(bPOSIGU) = "B"
   eval(bPOSIGU)
endif

set key K_F11 to TECLAF11
//Metodo de Edi��o
if cTIPG = "1"
   // Desenha a Tela
   eval(bPAXTEL)
   // Get nas Menvars
   eval(bPAXGET)
else
   EDITGET(.T.,CORPAX[5])
endif
set key K_F11

if valtype(bPOSEDI) = "B"
   eval(bPOSEDI)
endif

//abaixo
//Atualiza as Matrizes se nao for inclusao
//if cVIDE = 'S' .and. OPRPAX # 1
//   aPAX1[ POSPAX ] = &mCBARM.
//   aPAX2[ POSPAX ] = &wMCHA.
//endif

//Posiciona o Novo Elemento na Matriz
if cVIDE = 'S' .and. OPRPAX = 1
   nSBAR ++
   aadd(aPAX1,NIL)
   aadd(aPAX2,NIL)
   POSPAX := len(aPAX1)
   POSW   := 1
   if POSPAX > 1
      for X := 1 to POSPAX - 1
         mDARE := aPAX2[X]
         if mCHAVE <= mDARE   // IF mNUMERO<=mDARE
            exit
         endif
      next
      POSW := X
   endif
   ains(aPAX1,POSW)
   ains(aPAX2,POSW)
   aPAX1[POSW] = &mCBARM.
   aPAX2[POSW] = &wMCHA.
   pPAX := POSW
endif

if valtype(bANTREP) = "B"
   eval(bANTREP)
endif

REPORVARS(aWARQ[1],mCHAVE)

if valtype(bPOSREP) = "B"
   eval(bPOSREP)
endif

//Atualiza as Matrizes se nao for inclusao
if cVIDE = 'S' .and. OPRPAX # 1
   aPAX1[POSPAX] = &mCBARM.
   aPAX2[POSPAX] = &wMCHA.
endif


retu .T.

