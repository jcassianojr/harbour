*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib27.prg
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
*+    Function PADRAO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PADRAO


// * wPAD   -> Cria Variaveis
// * wpPAD  -> Posi��o no Achoice
// * wcPAD  -> Cria Matriz
// * wARQ   -> Arquivo de Trabalho
// * wCAB   -> String de Cabe�ario do Achoice
// * wSRO   -> String de Rolagem
// * wACOR  -> Matriz de Referencia de Cor ou String Inicial
// * wBTEL  -> Bloco de Tela de Apreseta��o dos Dados
// * wBGET  -> Bloco de Tela de Edi��o dos Dados
// * wBINS  -> Bloco Auxiliar de Novo Registro
// * wBMON  -> Bloco Montagem Matriz
// * wBKEY  -> Bloco de Teclas Auxiliares
// * wBIGU  -> Bloco para Processar Ap�s Igualvars
// * wBSAY  -> Bloco de Exibi��o de Teclas
// * lPADCRI -> Criarvars na inclusao .T. OU .F. padrao e .t.
// * bPOSREP -> Bloco Executar Apos o Reporvars
// * ePAD3   -> Expressao de Controle da Matriz de Totais
// * bDEL ->Bloco apos dele�ao
// * ppad ->Posi�ao cursor
// * Lpins ->Se pergunta Campos da Chave


para wPAD,wpPAD,wcPAD,wARQ,wCAB,wSRO,wACOR,wBTEL,wBGET,;
 wBINS,wBMON,wBKEY,wBIGU,wBSAY,lPADCRI,bPOSREP,;
 ePAD3,bDEL,pPAD,lpINS,eFILTRO

if valtype(lPADCRI) # "L"
   lPADCRI := .T.
endif

if valtype(lPINS) # "L"
   lPINS := .T.
endif

if valtype(eFILTRO) = "U"
   eFILTRO := .F.
endif

//ALERTX(strval(efiltro))

if pcount() < 3
   wcPAD := 0
endif

//Modo de Trabalho no Video
MDI(" � ",,,wARQ)

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
if !CONFARQ(wARQ,wCAB,wSRO)
   retu .F.
endif
if !CONFIND(wARQ)
   retu .F.
endif

priv wMFOR := aIND[1,4]
priv wMVAR := aIND[1,1,3]
priv wMCHA := if(empty(wMFOR),wMVAR,wMFOR)
priv wCHA  := strtran(wMCHA,"m","")

//Pegando Cores de Trabalho
priv CORPAD := CORARR(wACOR)
priv PAD001 := CORPAD[1]
priv PAD002 := CORPAD[2]
priv PAD005 := CORPAD[3]
priv PAD006 := CORPAD[4]
priv PAD007 := CORPAD[5]

//Verificando Tela
if valtype(wBTEL) = "U" .and. valtype(wACOR) = "C"
   wBTEL := LEFT(wACOR+strzero(1,6 - len(wACOR)),6)
endif
priv aPADTEL := {}
if valtype(wBTEL) = "C"
   aPADTEL := TELAPEG(wBTEL)
   wBTEL   := {|| TELASAY(aPADTEL)}
endif

//Verificando a Edi�ao
if valtype(wBGET) = "U" .and. valtype(wACOR) = "C"
   wBGET := LEFT(wACOR+strzero(1,6 - len(wACOR)),6)
endif
priv aPADGET := {}
if valtype(wBGET) = "C"
   aPADGET := EDITPEG(wBGET)
   wBGET   := {|| EDITSAY(aPADGET)}
endif

//Variaveis de Trabalho
priv PCK    := .F.
priv mCHAVE
if wPAD = 0
   CRIARVARS(wARQ)
endif
//CRIANDO MATRIZES
if wcPAD = 0
   priv aPAD1 := {}  //Matriz com os dizeres do Achoice
   priv aPAD2 := {}  //Numero de Cadastramento
   priv aPAD3 := {}  //Matriz de Controle de Totais
endif

//Incializando a ajuda on Line
priv HELPDBF := wARQ

IF VALTYPE(eFILTRO) = "L"
   IF eFILTRO
      eFILTRO := ''
      eFILTRO := RFILORD(wARQ,.F.)
   ENDIF
ENDIF

//Carregando Matriz
if valtype(wBMON) # "B"
   if cVIDE = "S" .and. wcPAD # 2
      nIND := if(lPIND,NUMIND(wARQ),nIEXI)
      if !USEREDE(wARQ,1,nIND)
         retu
      endif
      IF VALTYPE(eFILTRO) = "C" .AND. !empty(eFILTRO)
         SET FILTER TO &eFILTRO.
      ENDIF
      GRAF := lastrec()
      if GRAF > nACHO
         dbclosearea()
         ALERTX("Muitos Arquivos para o Modo Video")
         cVIDE := "T"
      else
         xGRAF := 0
         xPOS  := 1
         MARCAR()
         dbgotop()
         while !eof()
            aadd(aPAD1,&mCBAR.)
            aadd(aPAD2,&wCHA.)
            aadd(aPAD3,PAD3MONT(.T.))
            xPOS ++
            MARCAR1()
            dbskip()
         enddo
         dbclosearea()
         if xPOS = 1
            if !mdg('Nenhum Lancamento Neste Arquivo Deseja Incluir')
               retu .F.
            endif
            nSBAR := 0
            if !fPAD(1,0)
               retu .F.
            endif
         endif
      endif
   endif
else
   eRETU := eval(wBMON)
   if valtype(eRETU) = "L"
      if !eRETU
         retu .F.
      endif
   endif
endif

//Posi��o Inicial do Ponteiro
if valtype(wpPAD) # "U"
   pPAD := ascan(aPAD2,wpPAD)
   pPAD := if(pPAD = 0,1,pPAD)
else
   pPAD := 1
endif

//Processando o M�todo Escolhido
if cVIDE = 'S'
   NOBREAK()
   priv nSBAR
   priv aSBAR
   nSBAR := len(aPAD1)
   aSBAR := ScrollBarNew(04,79,24 - 1,substr(PAD001,rat(",",PAD001)+1),pPAD)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pPAD,nSBAR,.T.)
   while .T.
      CABVID(PAD001,pPAD)
      nKEY := 0
      keyboard chr(255)
      bELE := {| X | aPAD1[X]}
      cCOR := PAD001
      if valtype(wBSAY) = "B"
         eval(wBSAY)
      endif
      pPAD2 := achoice(05,01,24 - 2,78,aPAD1,,"ACHMOU",pPAD)
      pPAD  := if(pPAD2 # 0,pPAD2,pPAD)
      pPAD2 := pPAD
      nROW  := row()
      do case
         case LASTKEY() = K_ESC
            if mdg('Encerrar Consulta')
               PAD3TOT()
               exit
            endif
            loop
         case LASTKEY() = K_ALT_F10
            MANLISTA()
         case LASTKEY() = K_INS
            fPAD(1,pPAD)
         case LASTKEY() = K_ENTER .and. wPAD # 3
            fPAD(2,pPAD)
         case LASTKEY() = K_ENTER .and. wPAD = 3
            fPAD(6,pPAD)
            retu
         case LASTKEY() = K_DEL
            fPAD(3,pPAD)
         case LASTKEY() = K_CTRL_ENTER
            nIBUS   := if(lPBUS,NUMIND(wARQ),nIBUS)
            mCHABUS := PEGBUS(wARQ,nIBUS)
            if nIBUS # 1
               nREG := REGBUS(wARQ,nIBUS,mCHABUS)
            else
               pPAD := ascan(aPAD2,mCHAVE)
               IF pPAD = 0 .AND. VALTYPE(mCHABUS) = "N"   //Simular Softec Seek
                  nREG := REGBUS(wARQ,nIBUS,mCHABUS)
               ENDIF
            endif
            pPAD := ascan(aPAD2,mCHAVE)
            if pPAD = 0
               ALERTX('Nao localizei o Registro Correspondente ....')
               pPAD := pPAD2
               loop
            endif
         case valtype(wBKEY) = "B"
            eval(wBKEY,nKEY,pPAD)
         otherwise
            loop
      endcase
   enddo
endif
if cVIDE = "N"
   METNVI(wARQ,{|| fPAD(1,0)},{|| fPAD(3,0)},{|| fPAD(2,0)},;
    {|| fPAD(6,0)},{|| fPAD(2,- 1)},PAD001,wPAD)
endif
if cVIDE = 'P'
   METPAG(wARQ,{PAD001,PAD002,PAD005,PAD006,PAD007},wMCHA,wPAD,;
    wBTEL,{|| fPAD(1,0)},{|| fPAD(3,0)},{|| fPAD(2,0)},;
    {|| fPAD(6,0)})
endif
if cVIDE = 'T'
   aREP := {}
   for X := 1 to 3
      if !empty(aIND[1,X,3])
         cVARGET := aIND[1,X,3]
         aadd(aREP,{strtran(cVARGET,"m",""),cVARGET})
      endif
   next X
   METBRO(wARQ,aREP,{PAD001,PAD002,PAD005,PAD006,PAD007},;
    {|| &mCBAR.},wBTEL,wBGET,,,wPAD,,,,,wBINS,bPOSREP,wBIGU,Bdel,eFILTRO)
endif
if cVIDE = 'I'
   METINT(wARQ,,{|| fPAD(2,- 1)})
endif

if wPAD = 0
   //LIBERA VARIAVEIS
   release all like m *   //LIMPAVARS(wARQ)
endif

//EFETUA O PACK SE NECESSARIO
if PCK .and. lFIXA
   FIXAR(wARQ)
endif
retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fPAD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func fPAD(OPRPAD,POSPAD)  //INC=1//MUD=2//EXC=3 // POSICAO MATRIZ



//Variavel Flag de Inclus�o
INCLUI := .F.
//Pegar a Chave de Busca
if OPRPAD # 1
   if cVIDE = 'S'
      mCHAVE := aPAD2[POSPAD]
   endif
   if cVIDE = "N" .and. POSPAD # - 1
      PEGBUS()
   endif
endif

//Opera��o de Exclus�o
if OPRPAD = 3
   IF !padraolib("E"," Exclus�o n�o Liberado",WARQ)
      RETU .F.
   ENDIF
   if MDG("Apagar Registro")
      if APAGAREG(wARQ,mCHAVE,.F.)
         if valtype(bDEL) = "B"
            eRETU := eval(bDEL)
            if valtype(eRETU) = "L"
               if !eRETU
                  retu .F.
               endif
            endif
         endif
         if cVIDE = "S"
            aPAD1[POSPAD] = ' Registro Excluido / Apagado / Deletado '
         endif
         PCK := .T.
      endif
   endif
   retu .T.
endif

//Opera��o de Inclus�o
if OPRPAD = 1
   IF !padraolib("I"," Inclus�o n�o Liberado",WARQ)
      RETU .F.
   ENDIF
   if lPADCRI
      CRIARVARS(wARQ)
   endif
   if valtype(wBINS) = "B"
      eRETU := eval(wBINS)
      if valtype(eRETU) = "L"
         if !eRETU
            retu .F.
         endif
      endif
   endif
   if lPINS
      PEGBUS()
   endif
   if !NOVOREG(wARQ,mCHAVE)
      retu .F.
   endif
   INCLUI := .T.
   nROW   := 24
endif

//IGUALAR mVARS
if !IGUALVARS(wARQ,mCHAVE)
   retu .F.
endif

if valtype(wBIGU) = "B"
   if eval(wBIGU,OPRPAD)
      retu .T.
   endif
endif

//Metodo de Edi��o
set key K_F11 to TECLAF11
setcolor(PAD002)
if cTIPG = "1"
   // Desenha a Tela
   eval(wBTEL)
   // Get nas Menvars
   eval(wBGET)
else
   EDITGET(.T.,CORPAD)
endif
set key K_F11 to

//Atualiza as Matrizes se nao for inclusao
if cVIDE = 'S' .and. OPRPAD # 1
   aPAD1[POSPAD] = &mCBARM.
   aPAD2[POSPAD] = &wMCHA.
   aPAD3[POSPAD] = PAD3MONT()
endif

//Posiciona o Novo Elemento na Matriz
if cVIDE = 'S' .and. OPRPAD = 1
   nSBAR ++
   aadd(aPAD1,NIL)
   aadd(aPAD2,NIL)
   aadd(aPAD3,NIL)
   POSPAD := len(aPAD1)
   POSW   := 1
   if POSPAD > 1
      for X := 1 to POSPAD - 1
         mDARE := aPAD2[X]
         if mCHAVE <= mDARE
            exit
         endif
      next
      POSW := X
   endif
   ains(aPAD1,POSW)
   ains(aPAD2,POSW)
   ains(aPAD3,POSW)
   aPAD1[POSW] = &mCBARM.
   aPAD2[POSW] = &wMCHA.
   aPAD3[POSW] = PAD3MONT()
   pPAD := POSW
endif

REPORVARS(wARQ,mCHAVE)

if valtype(bPOSREP) = "B"
   retu eval(bPOSREP)
endif

retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PADARR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PADARR(cARQ,eKEY,mCOMP1,mCOMP2,nIND)


if cVIDE = "S" .and. wcPAD # 2
   if valtype(nIND) # "N"
      nIND := if(lPIND,NUMIND(cARQ),nIEXI)
   endif
   if !USEREDE(cARQ,1,nIND)
      retu .F.
   endif
   GRAF  := lastrec()
   xGRAF := 0
   xPOS  := 1
   MARCAR()
   dbgotop()
   dbseek(eKEY)
   while &mCOMP1. == &mCOMP2. .and. !eof()
      aadd(aPAD1,&mCBAR.)
      aadd(aPAD2,&wCHA.)
      aadd(aPAD3,PAD3MONT(.T.))
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
      if !fPAD(1,0)
         retu .F.
      endif
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PAD3MONT()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PAD3MONT(lTIP)


local cVAR := 0
if valtype(lTIP) # "L"
   lTIP := .F.
endif
if valtype(ePAD3) = "C"
   if lTIP
      cVAR := strtran(ePAD3,"m","")
      cVAR := &cVAR.
   else
      cVAR := &ePAD3.
   endif
endif
retu cVAR


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PAD3TOT()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PAD3TOT


local W
if valtype(ePAD3) = "C"
   mTOTAL := 0
   for W := 1 to len(aPAD3)
      mTOTAL += aPAD3[W]
   next W
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PADCGC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
funcTION PADCGC(cARQ,nIND,lULT)
local lOPEN := .F.
PRIVate v_pic:="@S18"
PRIVate GETLIST
MDS("Pessoa (F)isica (J)uridica (C)EI_CNO (O)utras Numero: ")
@ 24,60 get mPESSOA pict "!" valid mPESSOA $ "FJCO "       
@ 24,62 GET mCGC    PICT (v_pic) WHEN { |oGet| CNPJCPFPICT(oGet,mPESSOA,24,52) }  VALID CNPJCPFVAL(mCGC,mPESSOA)
if ! READCUR()
   return .F.
endif
if type("cVIDE") = "C"
   if cVIDE = "T"
      lOPEN := .T.
   endif
endif
if lOPEN
   dbsetorder(nIND)
   if dbseek(mCGC)
      mNUMERO := NUMERO
      ALERTX("CGC/CPF Ja cadastrado : "+STRVAL(mNUMERO))
      retu .F.
   endif
   dbsetorder(1)
else
   if PEGACAMPO(cARQ,"mCGC","NUMERO","mNUMERO",nIND)
      ALERTX("CGC/CPF Ja cadastrado : "+STRVAL(mNUMERO))
      retu .F.
   endif
endif
mNUMERO := ULTIMOREG(cARQ,"NUMERO","mNUMERO")
retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function padraolib()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func padraolib(cOPER,cTITULO,cARQ)

IF LEN(cARQ) = 6
   IF LEFT(cARQ,2) = "CD"   //Lancamento Contabil
      cARQ := "CD01"
   ENDIF
   IF LEFT(cARQ,2) = "MY"
      cARQ := "MY01"
   ENDIF
   IF LEFT(cARQ,2) = "MM"
      cARQ := "MM01"
   ENDIF
   IF LEFT(cARQ,2) = "MK"
      cARQ := "MK01"
   ENDIF
   IF LEFT(cARQ,2) = "K9"
      cARQ := "MK09"
   ENDIF
   IF LEFT(cARQ,2) = "M9"
      cARQ := "MM09"
   ENDIF
   IF LEFT(cARQ,2) = "YA"
      cARQ := "MY03A"
   ENDIF
   IF LEFT(cARQ,2) = "Y3"
      cARQ := "MY03"
   ENDIF
ENDIF
RETU PEGACS("O",cOPER+cARQ+ZUSER,.T.,CARQ+" "+cTITULO)

