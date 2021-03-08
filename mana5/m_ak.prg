*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ak.prg
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
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_ak()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_ak

para nTIPO

ARQWORK1 := "MK01"
ARQWORK2 := "MK02"
ARQWORK4 := "MK06"

if nTIPO = 2
   cVAR     := MESANO()
   ARQWORK1 := "K1"+cVAR
   ARQWORK2 := "K2"+cVAR
   ARQWORK4 := "K6"+cVAR
endif

IF nTIPO = 3
   ARQWORK1 := "MK91"
   ARQWORK2 := "MK92"
   ARQWORK4 := "MK96"
ENDIF

PRIV wMAk,wpMAk,wcMAk

wMAk  := 0
wcMAk := 0
wPMAk := 1

aMK2TEL := TELAPEG("ITK201")
aMK2GET := EDITPEG("ITK201")



//Modo de Trabalho no Video
MDI(" Ý ",,,ARQWORK1)

//Configura‡„o de Trabalho
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
if !CONFARQ(ARQWORK1,"Nota    Emiss„o F Fornecedor"+spac(9)+"S Ope P S Pag  Valor Total da NF",;
                    "' '+STR(mNRNOTA,8)+' '+DTOC(mDATA)+' '+mTIPOCLI+' '+STR(mFORNECEDO,  5)+' '+mCOGNOME+' '+mSETOR+' '+mOPERACAO+' '+mTIPOENT+' '+mSITUACAO+' '+mCONDPAG+' '+STR(mTOTNF, 18, 2)")
   retu .F.
endif
if !CONFIND(ARQWORK1)
   retu .F.
endif

//Pegando Cores de Trabalho
CORMAK := CORARR("MAK")

//Variaveis de Trabalho
priv PCK    := .F.
priv mCHAVE
ZESTADO := OBTER("MANEMP",ZNUMERO,"ESTADO")
mESTADO := ""
mICM    := 0
if wMAK = 0
   CRIARVARS("ML01")
   CRIARVARS(ARQWORK1)
   CRIARVARS(ARQWORK2)
   //   CRIARVARS( "MK03" )
endif
//CRIANDO MATRIZES
if wcMAK = 0
   aMAK1 := {}  // Matriz com os dizeres do Achoice
   aMAK2 := {}  // Por N£mero da Nota Fiscal e N£mero do Fornecedor
endif

//Incializando a ajuda on Line
priv HELPDBF := "MK01"

//Carregando Matriz
if cVIDE = "S" .and. wcMAK # 2
   nIND := if(lPIND,NUMIND(ARQWORK1),nIEXI)
   if !USEREDE(ARQWORK1,1,1)
      retu
   endif
   GRAF := lastrec()
   if GRAF > nACHO
      dbclosearea()
      ALERTX("Muitos Arquivos para o Modo Video")
      cVIDE := "N"
   else
      xGRAF := 0
      xPOS  := 1
      MARCAR()
      dbgotop()
      while !eof()
         if !empty(mCBAR)
            aadd(aMAK1,&mCBAR.)
         else
            aadd(aMAK1,' '+str(NRNOTA,8)+' '+dtoc(DATA)+' '+TIPOCLI+' '+str(FORNECEDO,5)+' '+COGNOME+' '+SETOR+' '+OPERACAO+' '+TIPOENT+' '+SITUACAO+' '+CONDPAG+' '+str(TOTNF,18,2))
         endif
         aadd(aMAK2,str(NRNOTA,8)+str(FORNECEDO,5)+dtos(DATA))
         xPOS ++
         MARCAR1()
         dbskip()
      enddo
      dbclosearea()
      if xPOS = 1
         if !mdg('Nenhum Lan‡amento Neste Arquivo Deseja Incluir')
            retu .F.
         endif
         nSBAR := 0
         if !fMAK(1,0)
            retu .F.
         endif
      endif
   endif
endif

//Posi‡„o Inicial do Ponteiro
if pcount() = 1
   pMAK := 1
else
   pMAK := ascan(aMAK2,wpMAK)
   pMAK := if(pMAK = 0,1,pMAK)
endif

//Processando o M‚todo Escolhido
if cVIDE = 'S'
   NOBREAK()
   priv nSBAR
   priv aSBAR
   nSBAR := len(aMAK1)
   aSBAR := ScrollBarNew(04,79,23,substr(CORMAK[1],rat(",",CORMAK[1])+1),pMAK)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMAK,nSBAR,.T.)
   while .T.
      CABVID(CORMAK[1],pMAK)
      nKEY := 0
      keyboard chr(255)
      bELE  := {| X | aMAK1[X]}
      cCOR  := CORMAK[1]
      pMAK2 := achoice(05,01,22,78,aMAK1,,"ACHMOU",pMAK)
      pMAK  := if(pMAK2 # 0,pMAK2,pMAK)
      pMAK2 := pMAK
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
            fMAK(1,pMAK)
         case LASTKEY() = K_ENTER .and. wMAK # 3
            MDS('Alterando ')
            fMAK(2,pMAK)
         case LASTKEY() = K_ENTER .and. wMAK = 3
            MDS('Escolhendo')
            fMAK(6,pMAK)
            retu
         case LASTKEY() = K_DEL
            MDS('Excluindo ')
            fMAK(3,pMAK)
         case LASTKEY() = K_CTRL_ENTER
            nIBUS   := if(lPBUS,NUMIND(ARQWORK1),nIBUS)
            mCHABUS := PEGBUS(ARQWORK1,nIBUS)
            if nIBUS # 1
               nREG := REGBUS(ARQWORK1,nIBUS,mCHABUS)
            endif
            pMAK := ascan(aMAK2,mCHAVE)
            if pMAK = 0
               ALERTX('Nao localizei o Registro Correspondente ....')
               pMAK := pMAK2
               loop
            endif
         otherwise
            loop
      endcase
   enddo
endif
if cVIDE = 'N'
   METNVI(ARQWORK1,{|| fMAK(1,0)},{|| fMAK(3,0)},{|| fMAK(2,0)},;
    {|| fMAK(6,0)},{|| fMAK(2,- 1)},CORMAK[1],wMAK)
endif
if cVIDE = 'P'
   METPAG(ARQWORK1,CORMAK,"STR(mNRNOTA,8)+STR(mFORNECEDO,5)+DTOS(mDATA)",wMAK,;
    {|| tMAK()},{|| fMAK(1,0)},{|| fMAK(3,0)},{|| fMAK(2,0)},;
    {|| fMAK(6,0)})
endif
if cVIDE = 'I'
   METINT(ARQWORK1,,{|| fMAK(2,- 1)})
endif

if wMAK = 0
   //LIBERA VARIAVEIS
   release all like m *
endif

//EFETUA O PACK SE NECESSARIO
if PCK .and. lFIXA
   FIXAR(ARQWORK1)
   FIXAR(ARQWORK2)
endif
retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fMAK()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func fMAK(OPRMAK,POSMAK)  // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ


// ***********************
//Pegar a Chave de Busca
if OPRMAK # 1
   if cVIDE = 'S'
      mCHAVE := aMAK2[POSMAK]
   endif
   if cVIDE = 'N' .and. POSMAK # - 1
      PEGBUS(ARQWORK1,1)
   endif
endif

//Opera‡„o de Inclus„o
if OPRMAK = 1
   //Zera Variaveis
   CRIARVARS(ARQWORK1)
   PEGBUS(ARQWORK1,1)
   //Marca Valores Pre definidos
   mTIPOCLI  := 'F'
   mSETOR    := 'C'
   mOPERACAO := '111'
   mTIPOENT  := 'D'
   mSITUACAO := '1'
   if !NOVOREG(ARQWORK1,mCHAVE)
      retu .F.
   endif
endif

//IGUALAR mVARS
if !IGUALVARS(ARQWORK1,mCHAVE)
   retu .F.
endif
if empty(mDATAREF)
   mDATAREF := mDATA
endif
if empty(mTIPOCLI)
   mTIPOCLI := "C"
endif

//Guarda Variaveis de Referencia arquivo MK02
xNRNOTA    := mNRNOTA
mNUMERO    := mNRNOTA
xDATA      := mDATA
xFORNECEDO := mFORNECEDO
xOPERACAO  := mOPERACAO
yCFONEW    := mCFONEW
yCFONEWB   := mCFONEWB
ySUBOPER   := mSUBOPER
yAPURA     := mAPURA



//Opera‡„o de Exclus„o
if OPRMAK = 3
   if APAGAREG(ARQWORK1,mCHAVE)
      if cVIDE = "S"
         aMAK1[POSMAK] = ' '+str(mNRNOTA,8)+' '+str(mFORNECEDO,5)+' '+dtoc(mDATA)+' - Registro Excluido / Apagado / Deletado'
      endif
      //Apagando os itens deste Pedido
      while !USEREDE(ARQWORK2,0,99)
      enddo
      dbseek(str(mNRNOTA,8)+str(mFORNECEDO,5)+dtos(mDATA))
      while str(mNRNOTA,8)+str(mFORNECEDO,5)+dtos(mDATA) = str(NRNOTA,8)+str(FORNECEDO,5)+dtos(DATA) .and. !eof()
         EQUVARS()
         if TIPOENT = "M" .or. TIPOENT = "C"
            yCODIGO   := mCODIGO
            mOLDQTDDE := MAK2K06()
            MAK2K05("E")
         endif
         DELEREG(ARQWORK2,,.T.,.F.)
      enddo
      dbclosearea()
      PCK    := .T.
      aDATAS := {mDAT01,mDAT02,mDAT03,mDAT04,mDAT05,;
       mDAT06,mDAT07,mDAT08,mDAT09,mDAT10}
      for W := 1 to 10
         if !empty(aDATAS[W])
            mTIPFAT := chr(64+W)
            APAGAREG("ML01",dtos(aDATAS[W])+str(mNRNOTA,8)+mTIPFAT,.F.)
         endif
      next
   endif
   retu .T.
endif

aDATOLD := {mDAT01,mDAT02,mDAT03,mDAT04,mDAT05,;
 mDAT06,mDAT07,mDAT08,mDAT09,mDAT10}


TIPCAD(mTIPOCLI,"ARQUSO")

//Metodo de Edi‡„o
if cTIPG = "1"
   // Desenha a Tela
   tMAK()
   // Get nas Menvars
   gMAK()
else
   EDITGET(.T.,CORMAK)
endif

//Guarda Variaveis de Referencia arquivo MK02
xNRNOTA    := mNRNOTA
mNUMERO    := mNRNOTA
xDATA      := mDATA
xFORNECEDO := mFORNECEDO
xOPERACAO  := mOPERACAO
yICM       := mICM  //Fixa ICM

//Itens da Nota Fiscal
M_AK2(1)

//Calculando Parcelas
if empty(mVAL01)
   MPAGAR(mCONDPAG,mTOTNF,mDATA,.T.)
endif

//Checando os Parcelas
CHECKPAR(,"2","mNRNOTA")

// Transferˆncia de Dados para o Contas a Pagar (ML01).
yNRNOTA   := mNRNOTA  //Salva vari veis NRNOTA e DATA do MK01.
yDATA     := mDATA
ySITUACAO := mSITUACAO

mSITUACAO := 0
aDATAS    := {mDAT01,mDAT02,mDAT03,mDAT04,mDAT05,;
    mDAT06,mDAT07,mDAT08,mDAT09,mDAT10}
aVALOR := {mVAL01,mVAL02,mVAL03,mVAL04,mVAL05,;
 mVAL06,mVAL07,mVAL08,mVAL09,mVAL10}
mNOME     := OBTER(ARQUSO,mFORNECEDO,"NOME")  //Puxa o Nome, DDD e Telefone
mDDD      := OBTER(ARQUSO,mFORNECEDO,"DDD")   //do Cadastro de Clientes p/
mTELEFONE := OBTER(ARQUSO,mFORNECEDO,"TELEFONE")
mCLIENTE  := mFORNECEDO
mTOTFAT   := mTOTNF

if ARQWORK1 == "MK01" .and. MDG("Transferir Contas a Pagar")
   MDS("Aguarde Transferencia Contas a Pagar")
   while !USEREDE("ML01",1,99)
   enddo
   for W := 1 to 10
      mTIPFAT := chr(64+W)  //Tipo do Faturamento (A,B,C...)
      if W = 1 .and. empty(aDATAS[2])   //Somente um vencimento
         mTIPFAT := " "
      endif
      mVENCIMENT := aDATAS[W]
      mVALOR     := aVALOR[W]
      yDATAV     := aDATOLD[W]
      do case
            // Zerou o valor ou a data
            // Apaga o Lan‡amento Buscando Pela Data Anterior
         case mVALOR = 0 .or. empty(mVENCIMENT)
            DELEREG(,dtos(yDATAV)+str(mNRNOTA,8)+mTIPFAT)
            //Lan‡amento Normal Cria ou Atualiza
         case yDATAV = mVENCIMENT .and. mVALOR > 0 .and. !empty(mVENCIMENT)
            if !NOVOOPE(,dtos(mVENCIMENT)+str(mNRNOTA,8)+mTIPFAT)
               //Altera Lan‡amentos
               netreclock()
               REPLVARS()
               dbunlock()
            endif
            //Mudou a data Apaga o anterior Grava o novo
         case yDATAV <> mVENCIMENT .and. mVALOR > 0
            //Apagando o Anterior
            DELEREG(,dtos(yDATAV)+str(mNRNOTA,8)+mTIPFAT)
            NOVOOPE(,dtos(mVENCIMENT)+str(mNRNOTA,8)+mTIPFAT)
      endcase
   next
   dbcloseall()
endif

mNRNOTA   := yNRNOTA  //Retorna as vari veis que foram salvadas.
mDATA     := yDATA
mSITUACAO := ySITUACAO

//Atualiza as Matrizes se nao for inclusao
if cVIDE = 'S' .and. OPRMAK # 1
   aMAK1[POSMAK] = ' '+str(mNRNOTA,8)+' '+dtoc(mDATA)+' '+mTIPOCLI+' '+str(mFORNECEDO,5)+' '+mCOGNOME+' '+mSETOR+' '+mOPERACAO+' '+mTIPOENT+' '+mSITUACAO+' '+mCONDPAG+' '+str(mTOTNF,18,2)
   aMAK2[POSMAK] = str(mNRNOTA,8)+str(mFORNECEDO,5)+dtos(mDATA)
endif

//Posiciona o Novo Elemento na Matriz
if cVIDE = 'S' .and. OPRMAK = 1
   nSBAR ++
   aadd(aMAK1,NIL)
   aadd(aMAK2,NIL)
   POSMAK := len(aMAK1)
   POSW   := 1
   if POSMAK > 1
      for X := 1 to POSMAK - 1
         mDARE := aMAK2[X]
         if mCHAVE <= mDARE
            exit
         endif
      next
      POSW := X
   endif
   ains(aMAK1,POSW)
   ains(aMAK2,POSW)
   aMAK1[POSW] = ' '+str(mNRNOTA,8)+' '+dtoc(mDATA)+' '+mTIPOCLI+' '+str(mFORNECEDO,5)+' '+mCOGNOME+' '+mSETOR+' '+mOPERACAO+' '+mTIPOENT+' '+mSITUACAO+' '+mCONDPAG+' '+str(mTOTNF,18,2)
   aMAK2[POSW] = str(mNRNOTA,8)+str(mFORNECEDO,5)+dtos(mDATA)
   pMAK := POSW
endif

REPORVARS(ARQWORK1,mCHAVE)

retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tMAK()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func tMAK


setcolor(CORMAK[5])
HB_dispbox(2,0,23,79,B_DOUBLE)
@  3,3  say "Nota    Emiss„o   Competencia"                                                          
@  4,0  say '+'+repl('-',78)+'Ý'                                                                     
@  6,43 say "Setor"+spac(12)+"Nat.Opera‡„o"                                                          
@  7,1  say "Tipo: F=Fornecedor"+spac(24)+"F :C=NF.Fornec"                                           
@  8,7  say "C=Cliente"+spac(30)+"S=NF.Interna"                                                      
@ 10,1  say "Entrada ser  de:    P=Pe‡as"+spac(9)+"Situa‡„o:1=Compra"                                
@ 11,21 say "D=Despesas"+spac(15)+"2=Consigna‡„o    Nota     Data"                                   
@ 12,21 say "V=Veiculos"+spac(15)+"3=Devolu‡„o"                                                      
@ 13,21 say "O=Outras"+spac(17)+"4=Demonstra‡„o"                                                     
@ 14,46 say "O=Outras"                                                                               
@ 15,1  say "Condi‡„o de Pagamento:    -"                                                            
@ 17,2  say "Conta Contabil :"                                                                       
@ 20,0  say '+'+repl('-',14)+"-"+repl('-',14)+"-"+repl('-',15)+"-"+repl('-',32)+'Ý'                  
@ 21,1  say "F:F=FornecedorÝS:C=NF Fornec.ÝP:P=Pe‡a D=DespÝS:1=Compra"+spac(6)+"3=Devolu‡„o"         
@ 22,3  say "C=Cliente   Ý  S=NF InternaÝ  V=Veiculo    Ý  2=Consigna‡„o 4=Demonstra‡„o"             
@ 23,15 say "Ï"+repl('-',14)+"Ï"+repl('-',15)+"Ï"                                                    
setcolor(CORMAK[3])
TIPCAD(mTIPOCLI,"ARQUSO")
@  5,1  say mNRNOTA            
@  5,10 say mDATA              
@  5,21 say mDATAREF           
@  8,3  say mTIPOCLI           
@  7,23 say mFORNECEDO         
@  7,29 say mCOGNOME           
@  8,43 say mSETOR             
@  7,60 say mOPERACAO          
@ 10,18 say mTIPOENT           
@ 11,40 say mSITUACAO          
@ 15,24 say mCONDPAG           
@ 17,19 say mCTACONTB          
retu .T.

//Get Nas Mvars


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMAK()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func gMAK


setcolor(CORMAK[2])
TIPCAD(mTIPOCLI,"ARQUSO")
// Get nas Menvars
@  5,1  say mNRNOTA    pict '99999999'                                                                                                                   
@  5,10 get mDATA                                                                                                                                        
@  5,21 get mDATAREF                                                                                                                                     
@  8,3  get mTIPOCLI   pict "!"                                                                               valid TIPCAD(mTIPOCLI,"ARQUSO",6,23)       
@  7,23 get mFORNECEDO pict '99999'                                                                           valid MAKK01()                             
@  7,29 get mCOGNOME                                                                                                                                     
@  8,43 get mSETOR                                                                                                                                       
@  7,60 get mOPERACAO  valid CHECKCFO(mOPERACAO,1,mESTADO,zESTADO,7,66,"LEFT(DESCRICAO,13)")                                                             
@ 10,18 get mTIPOENT                                                                                                                                     
@ 11,40 get mSITUACAO                                                                                                                                    
@ 15,24 get mCONDPAG   valid VERSEHA("MJ01",mCONDPAG,"LEFT(NOME,14)","'Condi‡„o n„o Cadastrada'",.T.,1,15,29)                                            
if ZLANC = 0
   @ 17,19 get mCTACONTB pict ZPICCC valid CHECKCC()       
else
   @ 17,19 get mCTACONTB valid CHECKCC()        
endif
READCUR()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAKK01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAKK01()


PEGACAMPO(ARQUSO,"mFORNECEDO",{"COGNOME","ESTADO"},{"mCOGNOME","mESTADO"})
mICM := OBTER("MD05",mESTADO,"ALIQUOTA")
retu .T.

