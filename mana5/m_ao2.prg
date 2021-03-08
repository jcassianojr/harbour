*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ao2.prg
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

// :*****************************************************************************
// :
// :   M_AO2  .PRG : Itens do Pedido
// :   Linguagem   : Clipper 5.x
// :        Sistema: Mana5 - ITAESBRA
// :      Copyright (c) 1998, Disk Soft S/C Ltda.
// :  DATA DA ATUALIZA€ŽO >>>>23/07/98
// :
// :*****************************************************************************

//Teclas Operacionais
//#INCLUDE "TECLAS.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_ao2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_ao2

//Recebendo Parametro de Trabalho
PARA wMAO2,wpMAO2,wcMAO2

IF PCOUNT() < 3
   wcMAO2 := 0
ENDIF



//Modo de Trabalho no Video
MDI(" Ý ",,,cAMO2)

//Configura‡„o de Trabalho
PRIV lFIXA,nACHO,cVIDE,lPBUS,lPIND,mCBAR,mCBARM,cTIPG,aGETS,cCBAS,nIBUS
PRIV nIEXI,aIND,nREG
IF !CONFARQ(cAMO2,"Pedido       O.S.     Cliente"+spac(14)+"  Total Pedido")
   RETU .F.
ENDIF
IF !CONFIND(cAMO2)
   RETU .F.
ENDIF

//Pegando Cores de Trabalho
CORMO2 := CORARR("MAO2")


//Variaveis de Trabalho
PRIV PCK           := .F.
PRIV mCHAVE
PUBLIC xyFORNECEDO
mESTOQUE := 0.00
mPESUNI  := 0.000
IF wMAO2 = 0
   CRIARVARS(cAMO2)
ENDIF
//CRIANDO MATRIZES
IF wcMAO2 = 0
   aMAO21 := {}   //Matriz com os dizeres do Achoice
   aMAO22 := {}   //
ENDIF

//Incializando a ajuda on Line
PRIV HELPDBF := cAMO2

//Carregando Matriz
IF cVIDE = "S" .AND. wcMAO2 # 2
   nIND := IF(lPIND,NUMIND(cAMO2),nIEXI)
   IF !USEREDE(cAMO2,1,nIND)
      RETU
   ENDIF
   GRAF  := LASTREC()
   xGRAF := 0
   xPOS  := 1
   MARCAR()
   DBGOTOP()
   DBSEEK(STR(mPEDIDO,8,2))
   WHILE PEDIDO = mPEDIDO .AND. !EOF()
      IF !EMPTY(mCBAR)
         AADD(aMAO21,&mCBAR.)
      ELSE
         AADD(aMAO21,' '+STR(ITEM,2)+' '+STR(QTDESAL,6)+' '+UNID+' '+CODIGO+' '+SUBSTR(NOME,1,16)+' '+STR(VALOR,17,4)+' '+STR(VALORTOT,17,2))
      ENDIF
      AADD(aMAO22,STR(PEDIDO,8,2)+STR(ITEM,2))
      xPOS ++
      MARCAR1()
      DBSKIP()
   ENDDO
   DBCLOSEAREA()
   IF xPOS = 1
      nSBAR := 0
      IF !fMAO2(11,0)
         RETU .F.
      ENDIF
   ENDIF
ENDIF

//Posi‡„o Inicial do Ponteiro
IF PCOUNT() = 1
   pMAO2 := 1
ELSE
   pMAO2 := ASCAN(aMAO22,wpMAO2)
   pMAO2 := IF(pMAO2 = 0,1,pMAO2)
ENDIF

//Processando o M‚todo Escolhido
IF cVIDE = 'S'
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR := LEN(aMAO21)
   aSBAR := ScrollBarNew(07,79,23,,pMAO2)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMAO2,nSBAR,.T.)
   WHILE .T.
      SETCOLOR(CORMO2[1])
      HB_DISPBOX(2,0,23,79,B_DOUBLE)
      @  3,2  SAY "Pedido       O.S.     Cliente"+spac(14)+"  Total Pedido"                                                                                              
      @  4,2  SAY mPEDIDO                                                                                                                                                
      @  4,11 SAY mOS                                                                                                                                                    
      @  4,20 SAY mFORNECEDO                                                                                                                                             
      @  4,26 SAY "-"                                                                                                                                                    
      @  4,28 SAY mCOGNOME                                                                                                                                               
      @  4,41 SAY mTOTNF                                                                                                                 PICT '@E 999,999,999.99'        
      @  5,2  SAY "I  Scs    Qtde C¢digo   Descri‡„o"+spac(13)+"Valor Unit"+spac(04)+"Valor Total Merc." //+spac(05)+"Valor Total Merc."                                 
      @  6,0  SAY 'Æ'+replicate('-',78)+'µ'                                                                                                                              
      MDS('Busca: ')
      ScrollBarUpdate(aSBAR,pMAO2,nSBAR,.T.)
      ScrollBarDisplay(aSBAR)
      pMAO22 := ACHOICE(07,01,22,78,aMAO21,,"ACHRETB",pMAO2)
      pMAO2  := IF(pMAO22 # 0,pMAO22,pMAO2)
      pMAO22 := pMAO2
      DO CASE
         CASE LASTKEY() = K_ESC 
            MDS('Retornando') 
            EXIT
         CASE LASTKEY() = K_ALT_F10 
            MDS('Imprimindo') 
            MANLISTA()
         CASE LASTKEY() = K_INS 
            MDS('Incluindo ') 
            fMAO2(1,pMAO2)
         CASE LASTKEY() = K_ENTER .AND. wMAO2 # 3 
            MDS('Alterando ') 
            fMAO2(2,pMAO2)
         CASE LASTKEY() = K_ENTER .AND. wMAO2 = 3 
            MDS('Escolhendo') 
            fMAO2(6,pMAO2) 
            RETU
         CASE LASTKEY() = K_DEL 
            MDS('Excluindo ') 
            fMAO2(3,pMAO2)
         CASE LASTKEY() = K_CTRL_ENTER .OR.  LASTKEY() = K_CTRL_F2  // CTRL+ENTER USO O aMAO21
            IF LASTKEY() = K_CTRL_ENTER
               PEGBUS()
            ELSE
               nIBUS   := IF(lPBUS,NUMIND(cAMO2),nIBUS)
               mCHABUS := PEGBUS(cAMO2,nIBUS)
               nREG    := REGBUS(cAMO2,nIBUS,mCHABUS)
            ENDIF
            pMAO2 := ASCAN(aMAO22,STR(mPEDIDO,8,2)+STR(mITEM,2))
            IF pMAO2 = 0
               MDE("NLOCAL","","")
               pMAO2 := pMAO22
               LOOP
            ENDIF
         OTHERWISE 
            LOOP
      ENDCASE
   ENDDO
ENDIF

RETU .T.

// ***************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fMAO2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC fMAO2(OPRMAO2,POSMAO2)   //INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ***************************************************************************
//Pegar a Chave de Busca
INCLUI := .F.
IF OPRMAO2 # 1 .AND. OPRMAO2 # 11
   IF cVIDE = 'S'
      mCHAVE := aMAO22[POSMAO2]
   ENDIF
   IF cVIDE = "N"
      PEGBUS()
   ENDIF
ENDIF


//Opera‡„o de Inclus„o
IF OPRMAO2 = 1 .or. OPRMAO2 = 11
   if OPRMAO2 = 11
      OPRMAO2 := 1
   else
      CRIARVARS(cAMO2)
   endif
   mPEDIDO := xPEDIDO
   mITEM   := 1
   WHILE ASCAN(aMAO22,STR(mPEDIDO,8,2)+STR(mITEM,2)) # 0
      mITEM ++
   ENDDO
   mCHAVE    := STR(mPEDIDO,8,2)+STR(mITEM,2)
   mTIPOSERV := "1"
   mPESOUNI  := 0
   mCONSUMO  := "N"
   mGERAOF   := "N"
   IF USEREDE("OSCRT",1,1)
      DBGOTOP()
      IF DBSEEK(INT(mPEDIDO))
         mCODIGO := CODIGO
      ENDIF
      DBCLOSEAREA()
   ENDIF
   IF !NOVOREG(cAMO2,mCHAVE)
      RETU .F.
   ENDIF
   INCLUI := .T.
ENDIF



//IGUALAR mVARS
IF !IGUALVARS(cAMO2,mCHAVE)
   RETU .F.
ENDIF
IF mFATURA = "S"
   ALERTX("OS Sendo Faturada - Altera‡Æo Bloqueada")
   RETU
ENDIF
mFORNECEDO := xFORNECEDO
mCOGNOME   := xCOGNOME
mPEDIDO    := xPEDIDO
mOS        := xOS
mVENDEDOR  := xVENDEDOR
mCOMISSAO  := xCOMISSAO
mZONA      := xZONA
mDATA      := xDATA
mICM       := xICM


//Guarda Variaveis de Referencia
xCODIGO  := mCODIGO
yCODIGO  := mCODIGO
wQTDEPED := mQTDEPED
xQTDESAL := mQTDESAL
MAOPED()


//Opera‡„o de Exclus„o
IF OPRMAO2 = 3
   mOF    := mOS
   xCHAVE := STR(mOS,8,2)+STR(mITEM,2)
   IF APAGAREG(cAMO2,mCHAVE)
      IF mGERAOF = "S"
         APAGAREG("OF01",STR(mOS,8,2)+STR(mITEM,3),.F.,.F.,,.F.)
         MAOFDEL()
      ENDIF
      IF cVIDE = "S"
         aMAO21[POSMAO2] = ' '+STR(mITEM,2)+' - Registro Exclu¡do / Apagado / Deletado'
      ENDIF
      PCK := .T.
   ENDIF
   RETU .T.
ENDIF

//Metodo de Edi‡„o
IF cTIPG = "1"
   // Desenha a Tela
   tMAO2()
   // Get nas Menvars
   gMAO2()
ELSE
   EDITGET(.T.,CORMO2)
ENDIF

ALLTRUE(PEGACAMPO("MRMS","mCODIGO+STR(mFORNECEDO,8)",{"CODMR01","PCEMB"},{"mCODMR01","mPCEMB"}) ;
 .or. PEGACAMPO("MRMS","mCODIGO+STR(0,8)",{"CODMR01","PCEMB"},{"mCODMR01","mPCEMB"}))

CALCVAR("mPCEMBQ",CEILING((CONVUN(mQTDEPRE,mUNID) - 1) / mPCEMB),24,0,"9999999999")

//Atualiza as Matrizes se nao for inclusao
IF cVIDE = 'S' .AND. OPRMAO2 # 1
   aMAO21[POSMAO2] = ' '+STR(mITEM,2)+' '+STR(mQTDESAL,6)+' '+mUNID+' '+mCODIGO+' '+SUBSTR(mNOME,1,16)+' '+STR(mVALOR,17,4)+' '+STR(mVALORTOT,17,2)
   aMAO22[POSMAO2] = STR(mPEDIDO,8,2)+STR(mITEM,2)
ENDIF

//Posiciona o Novo Elemento na Matriz
IF cVIDE = 'S' .AND. OPRMAO2 = 1
   nSBAR ++
   AADD(aMAO21,NIL)
   AADD(aMAO22,NIL)
   POSMAO2 := LEN(aMAO21)
   POSW    := 1
   IF POSMAO2 > 1
      FOR X := 1 TO POSMAO2 - 1
         mDARE := aMAO22[X]
         IF mCHAVE <= mDARE
            EXIT
         ENDIF
      NEXT
      POSW := X
   ENDIF
   AINS(aMAO21,POSW)
   AINS(aMAO22,POSW)
   aMAO21[POSW] = ' '+STR(mITEM,2)+' '+STR(mQTDESAL,6)+' '+mUNID+' '+mCODIGO+' '+SUBSTR(mNOME,1,16)+' '+STR(mVALOR,17,4)+' '+STR(mVALORTOT,17,2)
   aMAO22[POSW] = STR(mPEDIDO,8,2)+STR(mITEM,2)
   pMAO2 := POSW
ENDIF

REPORVARS(cAMO2,mCHAVE)

IF INCLUI
   mOF   := mOS
   cUNID := mUNID
   IF mGERAOF = "S"
      IF cVIDE = "T"
         MAOF03(,.F.,.F.)
      ELSE
         MAOF03(,.T.,.F.)
      ENDIF
      mCLIENTE := xFORNECEDO
      mCOGNOME := xCOGNOME
      NOVOREG("OF01",STR(mOF,8,2)+STR(mITEM,3))
   ENDIF
ENDIF

IF wQTDEPED # mQTDEPED .AND. mGERAOF = "S"
   MDS("Aguarde Reprocessando ordem de Fabricacao")
   mOF := mOS
   APAGAREG("OF01",STR(mOS,8,2)+STR(mITEM,3),.F.,.F.,,.F.)
   MAOFDEL()
   cUNID := mUNID
   MAOF03(,.T.,.F.)
   mCLIENTE := xFORNECEDO
   mCOGNOME := xCOGNOME
   NOVOREG("OF01",STR(mOF,8,2)+STR(mITEM,3))
ENDIF
RETU .T.

// ***************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tMAO2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC tMAO2  //Tela de Dados

// ***************************************************************************
SETCOLOR(CORMO2[5])
HB_DISPBOX(2,0,23,79,B_DOUBLE)
@  5,0  SAY '+'                                                                                       
@  5,79 SAY 'Ý'                                                                                       
@  3,2  SAY "Pedido   Cliente"+spac(12)+"Item C¢digo"+spac(19)+"Entregar Pt"                          
@  5,1  SAY replicate('-',78)                                                                         
@  6,2  SAY "Tipo   1-Prod  3-MO.Prod Un Comprador L.Pre‡o DataBase Indice"+spac(7)+"Consumo"         
@  7,9  SAY "2-Ferr  4-MO.Ferr"+spac(46)+"(S/N)"                                                      
@  8,2  SAY "Nome"+spac(37)+"Peso"+spac(6)+"IPI"                                                      
@ 11,16 SAY "Qtde"+spac(36)+"Horas:"                                                                  
@ 12,7  SAY "Pedido:"+spac(33)+"Pedido:"                                                              
@ 13,5  SAY "Entregue:"+spac(31)+"Entregue:"                                                          
@ 14,8  SAY "Saldo:"+spac(34)+"Saldo:"                                                                
@ 15,5  SAY "Fabricar:"                                                                               
@ 17,2  SAY "Pre‡o Unit.:"+spac(30)+"Gera OF:"                                                        
@ 18,2  SAY "Total Merc.:"+spac(30)+"Pedido Mensal:"                                                  
@ 19,2  SAY "Valor IPI  :"+spac(30)+"Data Import  :"                                                  
@ 20,2  SAY "Total Item :"                                                                            
@ 22,2  SAY "Obs:"                                                                                    
RETU .T.

// ***************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMAO2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gMAO2  // Get nas Menvars

// ***************************************************************************
SETCOLOR(CORMO2[2])
@  4,2  SAY mPEDIDO                                                                                                                                                                                        
@  4,11 SAY mFORNECEDO                                                                                                                                                                                     
@  4,17 SAY mCOGNOME                                                                                                                                                                                       
@  4,30 SAY mITEM                                                                                                                                                                                          
@  4,35 GET mCODIGO    VALID MO02K()                                                                                                                                                                       
@  4,60 GET mENTREGA                                                                                                                                                                                       
@  4,69 GET mPLANTA                                                                                                                                                                                        
@  6,7  GET mTIPOSERV  VALID CHECKTAB("TIPSERV","mTIPOSERV","TIPSER",,"LEFT(CODIGO1,1)") .AND. MMDEV()                                                                                                     
@  7,27 GET mUNID      PICT '@!'                                                                       VALID CHECKEXI("MD07","mUNID","UNIDADE+' '+UNIDDES","UNIDADE","UNIDADE")                            
@  7,30 GET mCOMPRA                                                                                                                                                                                        
@  7,40 GET mLISTA     VALID MO02K()                                                                   WHEN ALLTRUE(IF(EMPTY(mLISTA),mLISTA := OBTER("MA01",mFORNECEDO,"MO02LISTA"),.T.)) PICT "9999"      
@  7,48 GET mDATABASE                                                                                                                                                                                      
@  7,57 GET mINDICE    PICT "@!"                                                                       VALID EMPTY(mINDICE) .OR. VERSEHA("MD01",mINDICE,"mNOME","'XTABIND'",.T.,1,24,00)                   
@  7,70 GET mCONSUMO   PICT "!"                                                                        VALID mCONSUMO $ 'SN' .AND. MO02K()                                                                 
@  9,2  GET mNOME                                                                                                                                                                                          
@  9,43 GET mPESOUNI                                                                                                                                                                                       
@  9,53 GET mCODIPI    VALID CKEMPTY(mCODIPI) .OR. CHECKCIPI(mCODIPI,"mIPI","mCLASSIPI","mICM")        WHEN MAO204()                                                                                       
@  9,56 GET mIPI       WHEN EMPTY(mCODIPI)                                                             VALID CKEMPTY(mIPI)                                                                                 
@  9,59 GET mCLASSIPI  WHEN EMPTY(mCODIPI)                                                             VALID CHECKIPI(mCLASSIPI)                                                                           
READCUR()
DO CASE
   CASE mUNID = 'CT'
      @ 12,14 GET mQTDEPED  PICT "99999.99" VALID MAOPED() .AND. MAO203()       
      @ 13,14 GET mQTDEENT  PICT "99999.99" VALID MAOPED()                      
      @ 14,25 GET mFABRICAR PICT "99999.99"                                     
   CASE mUNID = 'ML'
      @ 12,14 GET mQTDEPED  PICT "99999.999" VALID MAOPED() .AND. MAO203()       
      @ 13,14 GET mQTDEENT  PICT "99999.999" VALID MAOPED()                      
      @ 14,25 GET mFABRICAR PICT "99999.999"                                     
   CASE mUNID = 'HR'
      @ 12,54 GET mHORAPED PICT "99999.999" VALID MAOHOR()        
      @ 13,54 GET mHORAENT PICT "99999.999" VALID MAOHOR2()       
      @ 14,54 GET mHORASAL PICT "99999.999" VALID MAOHOR3()       
   otherwise
      @ 12,14 GET mQTDEPED  PICT "999999" VALID MAOPED() .AND. MAO203()       
      @ 13,14 GET mQTDEENT  PICT "999999" VALID MAOPED()                      
      @ 14,25 GET mFABRICAR PICT "999999"                                     
ENDCASE
IF sMAO201
   IF EMPTY(mINDICE)
      @ 17,15 GET mVALOR PICT "999,999.9999" VALID LISTAP()       
   ELSE
      @ 17,15 GET mVALIND PICT "999,999.9999" VALID PREIND(mINDICE,ZDATA,,{| nTEMPVAL | mVALOR := ROUND(mVALIND * nTEMPVAL,4)}) .AND. LISTAP()       
   ENDIF
ENDIF
@ 17,53 GET mGERAOF    PICT "!" VALID mGERAOF $ "SN " WHEN ALLTRUE(IF(EMPTY(mGERAOF),mGERAOF := "N",)) .AND. INCLUI      
@ 18,59 GET mPEDMEN    PICT "!" VALID mPEDMEN $ "SN"                                                                     
@ 19,59 SAY mDATAIMP                                                                                                     
@ 22,7  GET mOBSERVACA                                                                                                   
READCUR()
IF mCOGNOME = "AUTOLATINA"
   HB_DISPBOX(7,0,23,79,B_DOUBLE)
   @  8,3  SAY "Dados Complementares para a AUTOLATINA"         
   @ 10,3  SAY "Numero da OS     :"                             
   @ 12,3  SAY "Setor"+spac(12)+":"                             
   @ 14,3  SAY "Tipo de Material :"                             
   @ 16,3  SAY "Detalhe"+spac(10)+":"                           
   @ 10,23 GET mALOS                                            
   @ 12,23 GET mALSE                                            
   @ 14,23 GET mALMA                                            
   @ 16,23 GET mALDE                                            
   READCUR()
ENDIF
IF mCOGNOME = "MERCEDES"
   HB_DISPBOX(6,15,15,57,B_DOUBLE)
   @  7,18 SAY "Mercedes Bens:"         
   @  9,18 SAY "N£mero    :"            
   @ 11,18 SAY "Protocolo :"            
   @  9,30 SAY mMBBN                    
   @ 11,30 SAY mMBBP                    
   READCUR()
ENDIF
RETU .T.

// ****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MO02K()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MO02K

// ****************************************************************************
IF EMPTY(mCODIGO)
   ALERTX("Codigo Produto em Branco")
   RETU .F.
ENDIF
IF !PEGACAMPO("MS01","mCODIGO",{"NOME","CODIPI","UNID","PESOUNI","PLT"},;
                    {"mNOME","mCODIPI","mUNID","mPESOUNI","mPLANTA"},2)
   ALERTX("Produto NÆo Encontrado")
   RETU .F.
ENDIF
IF EMPTY(mLISTA)
   mLISTA := OBTER("MA01",mFORNECEDO,"MO02LISTA")
ENDIF
aPRC      := MS02PRC(mCODIGO,mLISTA,.T.,"mUNID","mCODIPI")
mVALOR    := aPRC[1]
mDATABASE := aPRC[3]
CHECKCIPI(mCODIPI,"mIPI","mCLASSIPI")
IF mUNID = "HR"
   mVALORMER := mHORASAL * mVALOR
ELSE
   mVALORMER := mQTDESAL * mVALOR
ENDIF
mVALORIPI := PER2(mVALORMER,mIPI)
mVALORTOT := mVALORMER+mVALORIPI
IF mCONSUMO = 'S'
   mVALORICM := PER2(mVALORTOT,mICM)
   mBASEICM  := mVALORTOT
ELSE
   mVALORICM := PER2(mVALORMER,mICM)
   mBASEICM  := mVALORMER
ENDIF
MAOPED()
mBASEIPI := mVALORMER
IF EMPTY(mPLANTA)
   PEGACAMPO("MA01","mFORNECEDO",{"PLANTA"},{"mPLANTA"})
ENDIF
RETU .T.


// ****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function LISTAP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC LISTAP   //Pega peso, valor... da Lista Preco pela DataBase

// ****************************************************************************
xyDATABASE := xBASE   //VARIAVEIS DO M_AO1.PRG
IF xCODIGO # mCODIGO .OR. EMPTY(xCODIGO) .OR. EMPTY(mNOME)
   cUNIDE := mUNID
   lRETU  := .F.
   WHILE !USEREDE("MS01",1,2)
   ENDDO
   DBGOTOP()
   xyFORNECEDO := mFORNECEDO  // Salvando variaveis
   mFORNECEDO  := mLISTA
   xCHAVE      := mCODIGO
   IF !DBSEEK(xCHAVE)
      DBCLOSEAREA()
      MDE("PRODU","","")
      mFORNECEDO := xyFORNECEDO
      IF mUNID = "HR"
         mVALORMER := mHORASAL * mVALOR
      ELSE
         mVALORMER := mQTDESAL * mVALOR
      ENDIF
      mVALORIPI := PER2(mVALORMER,mIPI)
      mVALORTOT := mVALORMER+mVALORIPI
      IF mCONSUMO = 'S'
         mVALORICM := PER2(mVALORTOT,mICM)
         mBASEICM  := mVALORTOT
      ELSE
         mVALORICM := PER2(mVALORMER,mICM)
         mBASEICM  := mVALORMER
      ENDIF
      MAOPED()
      mBASEIPI := mVALORMER
      RETU .T.
   ENDIF
   mNOME    := NOME
   mUNID    := UNID
   mCODIPI  := ALLTRIM(CODIPI)
   mPESOUNI := PESOUNI
   mPLANTA  := PLT
   cUNIDE   := mUNID
   DBCLOSEAREA()
   WHILE !USEREDE("MS02",1,5)   //cODIGO LISTA DATA
   ENDDO
   DBGOTOP()
   IF DBSEEK(mCODIGO+STR(mFORNECEDO)+DTOS(xyDATABASE))
      lRETU := .T.
      IF EMPTY(mINDICE)
         mVALOR := VALOR
      ELSE
         mVALIND := VALOR
      ENDIF
      mDATABASE := DATA
      cUNIDE    := UNIDE
   ENDIF
   mFORNECEDO := xyFORNECEDO  // Voltando variaveis salvas acima
   DBCLOSEAREA()
   IF !EMPTY(cUNIDE)
      mUNID := cUNIDE
   ENDIF
   CHECKCIPI(mCODIPI,"mIPI","mCLASSIPI")
ENDIF
IF mUNID = "HR"
   mVALORMER := mHORASAL * mVALOR
ELSE
   mVALORMER := mQTDESAL * mVALOR
ENDIF
mVALORIPI := PER2(mVALORMER,mIPI)
mVALORTOT := mVALORMER+mVALORIPI
IF mCONSUMO = 'S'
   mVALORICM := PER2(mVALORTOT,mICM)
   mBASEICM  := mVALORTOT
ELSE
   mVALORICM := PER2(mVALORMER,mICM)
   mBASEICM  := mVALORMER
ENDIF
IF EMPTY(mPLANTA)
   PEGACAMPO("MS01","mCODIGO",{"PLT"},{"mPLANTA"},2)
ENDIF
IF EMPTY(mPLANTA)
   PEGACAMPO("MA01","mFORNECEDO",{"PLANTA"},{"mPLANTA"})
ENDIF
MAOPED()
mBASEIPI := mVALORMER
RETU .T.

// ****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOPED()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAOPED

// ****************************************************************************
mQTDESAL := mQTDEPED - mQTDEENT
DO CASE
   CASE mUNID = 'CT'
      @ 14,14 SAY mQTDESAL PICT "99999.99"        
   CASE mUNID = 'ML'
      @ 14,14 SAY mQTDESAL PICT "99999.999"        
   CASE mUNID = 'HR'
      @ 14,54 SAY mHORASAL PICT "99999.999"        
   otherwise
      @ 14,14 SAY mQTDESAL PICT "999999"        
ENDCASE
IF sMAO201
   @ 18,15 SAY mVALORMER PICT "999,999.99"        
   @ 19,15 SAY mVALORIPI PICT "999,999.99"        
   @ 20,15 SAY mVALORTOT PICT "999,999.99"        
   IF EMPTY(mINDICE)
      @ 17,15 SAY mVALOR PICT "999,999.9999"        
   ELSE
      @ 17,15 SAY mVALIND PICT "999,999.9999"        
   ENDIF
ENDIF
RETU .T.

// ****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOHOR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAOHOR   //Se Saldo em Horas for vazio Joga pedidos hora nele.

// ****************************************************************************
IF EMPTY(mHORASAL) .AND. EMPTY(mHORAENT)
   mHORASAL := mHORAPED
ENDIF
@ 14,54 SAY mHORASAL PICT "99999.999"        
RETU .T.

// ****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOHOR2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAOHOR2  //ACHA SALDO

// ****************************************************************************
mHORASAL := mHORAPED - mHORAENT
RETU .T.

// ****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOHOR3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAOHOR3  //Calcula o Saldo atrav‚s da Qtde.em Horas do Pedido.

// ****************************************************************************
IF !EMPTY(mHORAPED) .AND. !EMPTY(mHORASAL)
   mHORAENT := mHORAPED - mHORASAL
ENDIF
@ 12,54 SAY mHORAPED PICT "99999.999"        
@ 13,54 SAY mHORAENT PICT "99999.999"        
@ 14,54 SAY mHORASAL PICT "99999.999"        
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAO203()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAO203

LOCAL nMINIMO := 0
mMINIMO := CONVUN(mQTDEPED,mUNID)
IF OBTER("MS01",mCODIGO,"LMINIMO",2) < nMINIMO
   IF !MDG("Pedido Inferior ao Lote Minimo Aceitar")
      RETU .F.
   ENDIF
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAO204()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAO204

IF EMPTY(mCODIPI)
   PEGACAMPO("MS01","mCODIGO",{"CODIPI"},{"mCODIPI"},2)
ENDIF
RETU .T.
