*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_dc.prg
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
// :   M_DC   .PRG : Configura��o de etiquetas
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMDC()
// :
// :    Chamado por: MAND.PRG
// :
// :          Chama: fMDC  (fun��o em M_DC.PRG )
// :
// :  Arq. Dados   : METIQ      - Configura��o de etiquetas
// :
// :  Indices      : METIQ-1    - C�digo da Etiqueta
// :                 CODIGO
// :
// :  Documentado em: Junho 6, 1994 as 10:39:              DISK!  vers�o 5.01
// :*****************************************************************************

#INCLUDE "BOX.CH"

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_dc()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_dc

//Recebendo Parametro de Trabalho
PARA wMDC,wpMDC,wcMDC

/* 3o. Paramentro
0 - Cria e Carrega as Matrizes
1 - N�o Cria e Carrega as Matrizes
2 - N�o Cria e N�o Carrega as Matrizes
*/
IF PCOUNT() < 3
   wcMDC := 0
ENDIF

//Teclas Operacionais
//#INCLUDE "TECLAS.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
// #INCLUDE "FILEGET.CH"

//Modo de Trabalho no Video
MDI(" ■ ",,,"METIQ")

//Configura��o de Trabalho
PRIV lFIXA,nACHO,cVIDE,lPBUS,lPIND,mCBAR,mCBARM,cTIPG,aGETS,cCBAS,nIBUS
PRIV nIEXI,nREG,aIND
IF !CONFARQ("METIQ","Codigo Descricao"+spac(42)+"Arquivo",;
                   "' '+mCODIGO+' '+mNOME+' '+mARQUIVO")
   RETU .F.
ENDIF
IF !CONFIND("METIQ")
   RETU .F.
ENDIF

//Pegando Cores de Trabalho
CORMDC  := CORARR("MDC")
aMANTEL := TELAPEG("MDC001")



//Variaveis de Trabalho
PRIV PCK    := .F.
PRIV mCHAVE
IF wMDC = 0
   CRIARVARS("METIQ")
ENDIF
//CRIANDO MATRIZES
IF wcMDC = 0
   aMDC1 := {}  //Matriz com os dizeres do Achoice
   aMDC2 := {}  //C�digo da Etiqueta
ENDIF

//Incializando a ajuda on Line
PRIV HELPDBF := "METIQ"

//Carregando Matriz
IF cVIDE = "S" .AND. wcMDC # 2
   nIND := IF(lPIND,NUMIND("METIQ"),nIEXI)
   IF !USEREDE("METIQ",1,nIND)
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
      WHILE !EOF()
         IF !EMPTY(mCBAR)
            AADD(aMDC1,&mCBAR.)
         ELSE
            AADD(aMDC1,' '+CODIGO+' '+NOME+' '+ARQUIVO)
         ENDIF
         AADD(aMDC2,CODIGO)
         xPOS ++
         MARCAR1()
         DBSKIP()
      ENDDO
      DBCLOSEAREA()
      IF xPOS = 1
         IF !mdg('Nenhum Lan�amento Neste Arquivo Deseja Incluir')
            RETU .F.
         ENDIF
         nSBAR := 0
         IF !fMDC(1,0)
            RETU .F.
         ENDIF
      ENDIF
   ENDIF
ENDIF

//Posi��o Inicial do Ponteiro
IF PCOUNT() = 1
   pMDC := 1
ELSE
   pMDC := ASCAN(aMDC2,wpMDC)
   pMDC := IF(pMDC = 0,1,pMDC)
ENDIF

//Processando o M�todo Escolhido
IF cVIDE = 'S'
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR := LEN(aMDC1)
   aSBAR := ScrollBarNew(04,79,23,SUBSTR(CORMDC[1],RAT(",",CORMDC[1])+1),pMDC)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMDC,nSBAR,.T.)
   WHILE .T.
      SETCOLOR(CORMDC[1])
      HB_DISPBOX(2,0,23,79,B_DOUBLE)
      @  3,1 SAY cCBAS                             
      @  4,0 SAY '+'+replicate('-',78)+'�'         
      MDS('Busca: CTRL+ENTER=CODIGO ALT+F10=Config')
      SETCOLOR(CORMDC[1])
      ScrollBarUpdate(aSBAR,pMDC,nSBAR,.T.)
      ScrollBarDisplay(aSBAR)
      pMDC2 := ACHOICE(05,01,22,78,aMDC1,,"ACHRETB",pMDC)
      pMDC  := IF(pMDC2 # 0,pMDC2,pMDC)
      pMDC2 := pMDC
      DO CASE
         CASE LASTKEY() = K_ESC
            IF mdg('Encerrar Consulta')
               EXIT
            ENDIF
            LOOP
         CASE LASTKEY() = K_ALT_F10
            MDS('Alterando ') 
            fMDC(2,pMDC)
         CASE LASTKEY() = K_INS 
            MDS('Incluindo ') 
            fMDC(1,pMDC)
         CASE LASTKEY() = K_ENTER .AND. wMDC # 3 
            MDS('Imprimindo') 
            fMDC(7,pMDC)
         CASE LASTKEY() = K_ENTER .AND. wMDC = 3 
            MDS('Escolhendo') 
            fMDC(6,pMDC) 
            RETU
         CASE LASTKEY() = K_DEL 
            MDS('Excluindo ') 
            fMDC(3,pMDC)
         CASE LASTKEY() = K_CTRL_ENTER
            nIBUS   := IF(lPBUS,NUMIND("METIQ"),nIBUS)
            mCHABUS := PEGBUS("METIQ",nIBUS)
            IF nIBUS # 1
               nREG := REGBUS("METIQ",nIBUS,mCHABUS)
            ENDIF
            pMDC := ASCAN(aMDC2,mCHAVE)
            IF pMDC = 0
               ALERTX('Nao localizei o Registro Correspondente ....')
               pMDC := pMDC2
               LOOP
            ENDIF
         OTHERWISE 
            LOOP
      ENDCASE
   ENDDO
ENDIF
IF cVIDE = 'N'
   METNVI("METIQ",{|| fMDC(1,0)},{|| fMDC(3,0)},{|| fMDC(2,0)},;
    {|| fMDC(6,0)},{|| fMDC(2,- 1)},CORMDC[1],wMDC,{|| fMDC(7,0)})
ENDIF
IF cVIDE = 'P'
   METPAG("METIQ",CORMDC,"mCODIGO",wMDC,;
    {|| TELASAY(aMANTEL)},{|| fMDC(1,0)},{|| fMDC(3,0)},{|| fMDC(2,0)},;
    {|| fMDC(6,0)})
ENDIF
IF cVIDE = 'I'
   METINT("METIQ",,{|| fMDC(2,- 1)})
ENDIF

IF wMDC = 0
   //LIBERA VARIAVEIS
   RELEASE ALL LIKE m *   //LIMPAVARS("METIQ")
ENDIF

//EFETUA O PACK SE NECESSARIO
IF PCK .AND. lFIXA
   FIXAR("METIQ")
ENDIF
RETU .T.

// ******************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fMDC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC fMDC(OPRMDC,POSMDC)  //INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ******************
//Pegar a Chave de Busca
IF OPRMDC # 1
   IF cVIDE = 'S'
      mCHAVE := aMDC2[POSMDC]   //mCODIGO=aMDC2[POSMDC]
   ENDIF
   IF cVIDE = 'N' .AND. POSMDC # - 1
      PEGBUS("METIQ",1)
   ENDIF
ENDIF

//Opera��o de Exclus�o
IF OPRMDC = 3
   IF APAGAREG("METIQ",mCHAVE)
      IF cVIDE = "S"
         aMDC1[POSMDC] = ' '+mCHAVE+' - Registro Excluido / Apagado / Deletado'
      ENDIF
      PCK := .T.
   ENDIF
   RETU .T.
ENDIF

//Opera��o de Inclus�o
IF OPRMDC = 1
   PEGBUS("METIQ",1)
   IF !NOVOREG("METIQ",mCODIGO,"CODIGO","mCODIGO")
      RETU .F.
   ENDIF
ENDIF



//IGUALAR mVARS
IF !IGUALVARS("METIQ",mCHAVE)   //IF ! IGUALVARS("METIQ",mCODIGO)
   RETU .F.
ENDIF

//Imprimindo Etiquetas
IF OPRMDC = 7
   mARQUSO := ""
   IF !EMPTY(mARQGRA)
      IF mdg("Deseja Gravar em Arquivo")
         mARQUSO := ZDIRP+"TXT\"+ALLTRIM(mARQGRA)+".TXT"
         IF file(mARQUSO)
            IF mdg("J� existe o arquivo, sobrepor?")
               SET PRINT TO &mARQUSO.
            ELSE
               RETU .F.
            ENDIF
         ELSE
            SET PRINT TO &mARQUSO.
         ENDIF
      ELSE
         IF !CHECKIMP()
            RETU .F.
         ENDIF
      ENDIF
   ELSE
      IF !CHECKIMP()
         RETU .F.
      ENDIF
   ENDIF
   aLIN := {mLINHA1,mLINHA2,mLINHA3,mLINHA4,mLINHA5,mLINHA6,mLINHA7,mLINHA8,;
    "","","","","","","","","","","","","","","","","","",""}
   IF EMPTY(mARQUIVO)
      mQUANT := 0
      MDS("Quantas Etiquetas")
      @ 24,40 GET mQUANT         
      READCUR()
      mQUANT := INT((mQUANT+mNCAR) / mNCAR)
   ELSE
   ENDIF
   IF !EMPTY(mSETUP) .AND. EMPTY(mARQUSO)
      SET DEVI TO PRINT
      @ PROW(), 0 SAY &mSETUP.         
      SET DEVI TO SCREEN
   ENDIF
   IF EMPTY(mARQUIVO)
      SET DEVI TO PRINT
      aDIZ := ARRAY(8)
      FOR X := 1 TO mNLIN   // 8
         mLIN      := aLIN[X]
         aDIZ[ X ] := &mLIN.
      NEXT X
      FOR X := 1 TO mQUANT
         //Loop das Linhas
         FOR LIN := 1 TO mNLIN
            //Loop das Carreiras
            FOR CAR := 1 TO mNCAR
               @ PROW(),(CAR - 1) * mNCOL+CAR - 1 SAY aDIZ[LIN]         
            NEXT CAR
            @ PROW()+ 1,0 SAY ""         
         NEXT LIN
         @ PROW()+ 1,0 SAY ""         
      NEXT X
   ELSE
      aDIZ    := ARRAY(mNLIN,mNCAR)
      mINDICE := IF(EMPTY(mINDICE),1,mINDICE)
      mTIPFIL := IF(EMPTY(mTIPFIL),1,mTIPFIL)
      mINDICE := IF(mPIND = "S",NUMIND(mARQUIVO,mINDICE),mINDICE)
      mTIPFIL := IF(mPFIL = "S",NUMFIL(mTIPFIL),mTIPFIL)
      //Filtro tipo Padr�o
      IF mTIPFIL = "1"
         mFILTRO := RFILORD(mARQUIVO,.F.,mFILTRO)
         IF !USEREDE(mARQUIVO,1,mINDICE)
            SET PRINT TO
            RETU .F.
         ENDIF
         IF !EMPTY(mFILTRO)
            SET FILTER TO &mFILTRO
         ENDIF
         SET DEVI TO PRINT
         DBGOTOP()
         WHILE !EOF()
            //Loop das Carreiras
            FOR CAR := 1 TO mNCAR
               //Loop das Linhas
               FOR LIN := 1 TO mNLIN  // 8
                  mLIN := aLIN[LIN]
                  IF !EMPTY(mLIN)
                     aDIZ[LIN ,  CAR] = &mLIN.
                  ELSE
                     aDIZ[LIN ,  CAR] = ""
                  ENDIF
               NEXT LIN
               DBSKIP()
               IF EOF()
                  EXIT
               ENDIF
            NEXT LIN
            //Imprimindo o Vetor
            FOR LIN := 1 TO mNLIN
               //Loop das Carreiras
               FOR CAR := 1 TO mNCAR
                  IF !EMPTY(aDIZ[LIN ,  CAR])
                     @ PROW(),(CAR - 1) * mNCOL+CAR - 1 SAY aDIZ[LIN,CAR]         
                  ENDIF
               NEXT CAR
               @ PROW()+ 1,0 SAY ""         
            NEXT LIN
            @ PROW()+ 1,0 SAY ""         
         ENDDO
         DBCLOSEAREA()
      ENDIF
      //Filtro tipo Condicional
      IF mTIPFIL = "2"
         IF EMPTY(mCONFIL)
            ALERTX("Falta Configura�ao de Filtro")
         ENDIF
         IF !USEREDE(mARQUIVO,1,mINDICE)
            SET PRINT TO
            RETU .F.
         ENDIF
         SET DEVI TO PRINT
         DBGOTOP()
         WHILE !EOF()
            //Loop das Carreiras
            FOR CAR := 1 TO mNCAR
               WHILE !&mCONFIL. .AND. !EOF()
                  DBSKIP()
               ENDDO
               IF !EOF()
                  //Loop das Linhas
                  FOR LIN := 1 TO mNLIN   // 8
                     mLIN := aLIN[LIN]
                     IF !EMPTY(mLIN)
                        aDIZ[LIN ,  CAR] = &mLIN.
                     ELSE
                        aDIZ[LIN ,  CAR] = ""
                     ENDIF
                  NEXT LIN
               ENDIF
               DBSKIP()
               IF EOF()
                  EXIT
               ENDIF
            NEXT LIN
            //Imprimindo o Vetor
            FOR LIN := 1 TO mNLIN
               //Loop das Carreiras
               FOR CAR := 1 TO mNCAR
                  IF !EMPTY(aDIZ[LIN ,  CAR])
                     @ PROW(),(CAR - 1) * mNCOL+CAR - 1 SAY aDIZ[LIN,CAR]         
                  ENDIF
               NEXT CAR
               @ PROW()+ 1,0 SAY ""         
            NEXT LIN
            @ PROW()+ 1,0 SAY ""         
         ENDDO
         DBCLOSEAREA()
      ENDIF
      //Filtro tipo Faixa
      IF mTIPFIL = "3"
         PRIV aIND
         CRIARVARS(mARQUIVO)
         CONFIND(mARQUIVO)
         FAIXAINI := PEGBUS(mARQUIVO,mINDICE,"Digite o Valor Inicial")
         FAIXAFIM := PEGBUS(mARQUIVO,mINDICE,"Digite o Valor Final")
         FORMULA  := OBTER(zARQ1,PADR(mARQUIVO,8)+STR(mINDICE,2),"FORMULA")
         IF EMPTY(FORMULA)
            FORMULA := OBTER(zARQ1,PADR(mARQUIVO,8)+STR(mINDICE,2),"VAR1")
         ENDIF
         FORMULA := STRTRAN(FORMULA,"m","")
         IF !USEREDE(mARQUIVO,1,mINDICE)
            SET PRINT TO
            RETU .F.
         ENDIF
         SET DEVI TO PRINT
         DBGOTOP()
         DBSEEK(FAIXAINI)
         WHILE !EOF()
            //Loop das Carreiras
            FOR CAR := 1 TO mNCAR
               IF &FORMULA. > FAIXAFIM
                  DBGOBOTTOM()
                  DBSKIP()
               ENDIF
               IF !EOF()
                  //Loop das Linhas
                  FOR LIN := 1 TO mNLIN   // 8
                     mLIN := aLIN[LIN]
                     IF !EMPTY(mLIN)
                        aDIZ[LIN ,  CAR] = &mLIN.
                     ELSE
                        aDIZ[LIN ,  CAR] = ""
                     ENDIF
                  NEXT LIN
               ENDIF
               DBSKIP()
               IF EOF()
                  EXIT
               ENDIF
            NEXT LIN
            //Imprimindo o Vetor
            FOR LIN := 1 TO mNLIN
               //Loop das Carreiras
               FOR CAR := 1 TO mNCAR
                  IF !EMPTY(aDIZ[LIN ,  CAR])
                     @ PROW(),(CAR - 1) * mNCOL+CAR - 1 SAY aDIZ[LIN,CAR]         
                  ENDIF
               NEXT CAR
               @ PROW()+ 1,0 SAY ""         
            NEXT LIN
            @ PROW()+ 1,0 SAY ""         
         ENDDO
         DBCLOSEAREA()
      ENDIF
      //Filtro tipo Filtro Condi��o
      IF mTIPFIL = "4"
         mFILTRO := RFILORD(mARQUIVO,.F.,mFILTRO)
         IF !USEREDE(mARQUIVO,1,mINDICE)
            SET PRINT TO
            RETU .F.
         ENDIF
         IF EMPTY(mFILTRO)
            mFILTRO := ".T."
         ENDIF
         SET DEVI TO PRINT
         DBGOTOP()
         WHILE !EOF()
            //Loop das Carreiras
            FOR CAR := 1 TO mNCAR
               WHILE !&mFILTRO. .AND. !EOF()
                  DBSKIP()
               ENDDO
               IF !EOF()
                  //Loop das Linhas
                  FOR LIN := 1 TO mNLIN   // 8
                     mLIN := aLIN[LIN]
                     IF !EMPTY(mLIN)
                        aDIZ[LIN ,  CAR] = &mLIN.
                     ELSE
                        aDIZ[LIN ,  CAR] = ""
                     ENDIF
                  NEXT LIN
               ENDIF
               DBSKIP()
               IF EOF()
                  EXIT
               ENDIF
            NEXT LIN
            //Imprimindo o Vetor
            FOR LIN := 1 TO mNLIN
               //Loop das Carreiras
               FOR CAR := 1 TO mNCAR
                  IF !EMPTY(aDIZ[LIN ,  CAR])
                     @ PROW(),(CAR - 1) * mNCOL+CAR - 1 SAY aDIZ[LIN,CAR]         
                  ENDIF
               NEXT CAR
               @ PROW()+ 1,0 SAY ""         
            NEXT LIN
            @ PROW()+ 1,0 SAY ""         
         ENDDO
         DBCLOSEAREA()
      ENDIF
      //Filtro tipo Filtro LOCATE
      IF mTIPFIL = "5"
         IF !USEREDE(mARQUIVO,1,mINDICE)
            SET PRINT TO
            RETU .F.
         ENDIF
         IF EMPTY(mCONFIL)
            ALERTX("Falta Condi��o para o Filtro")
            RETU .F.
         ENDIF
         SET DEVI TO PRINT
         DBGOTOP()
         LOCATE FOR &mCONFIL.
         WHILE !EOF()
            //Loop das Carreiras
            FOR CAR := 1 TO mNCAR
               IF !&mCONFIL.
                  DBGOBOTTOM()
                  DBSKIP()
               ENDIF
               IF !EOF()
                  //Loop das Linhas
                  FOR LIN := 1 TO mNLIN   // 8
                     mLIN := aLIN[LIN]
                     IF !EMPTY(mLIN)
                        aDIZ[LIN ,  CAR] = &mLIN.
                     ELSE
                        aDIZ[LIN ,  CAR] = ""
                     ENDIF
                  NEXT LIN
               ENDIF
               DBSKIP()
               IF EOF()
                  EXIT
               ENDIF
            NEXT LIN
            //Imprimindo o Vetor
            FOR LIN := 1 TO mNLIN
               //Loop das Carreiras
               FOR CAR := 1 TO mNCAR
                  IF !EMPTY(aDIZ[LIN ,  CAR])
                     @ PROW(),(CAR - 1) * mNCOL+CAR - 1 SAY aDIZ[LIN,CAR]         
                  ENDIF
               NEXT CAR
               @ PROW()+ 1,0 SAY ""         
            NEXT LIN
            @ PROW()+ 1,0 SAY ""         
         ENDDO
         DBCLOSEAREA()
      ENDIF
   ENDIF
   //C�digo Final de Impress�o
   IF !EMPTY(mSETUPFIM) .AND. EMPTY(mARQUSO)
      @ PROW(), 0 SAY &mSETUPFIM.         
   ENDIF
   SET PRINT TO
   SET DEVI TO SCREEN
   RETU .F.
ENDIF


//Metodo de Edi��o
IF cTIPG = "1"
   // Desenha a Tela
   TELASAY(aMANTEL)
   // Get nas Menvars
   gMDC()
ELSE
   EDITGET(.T.,CORMDC)
ENDIF

//Atualiza as Matrizes se nao for inclusao
IF cVIDE = 'S' .AND. OPRMDC # 1
   IF !EMPTY(mCBARM)
      aMDC1[POSMDC] = &mCBARM.
   ELSE
      aMDC1[POSMDC] = ' '+mCODIGO+' '+mNOME+' '+mARQUIVO
   ENDIF
   aMDC2[POSMDC] = mCODIGO
ENDIF

//Posiciona o Novo Elemento na Matriz
IF cVIDE = 'S' .AND. OPRMDC = 1
   nSBAR ++
   AADD(aMDC1,NIL)
   AADD(aMDC2,NIL)
   POSMDC := LEN(aMDC1)
   POSW   := 1
   IF POSMDC > 1
      FOR X := 1 TO POSMDC - 1
         mDARE := aMDC2[X]
         IF mCHAVE <= mDARE   // IF mCODIGO<=mDARE
            EXIT
         ENDIF
      NEXT
      POSW := X
   ENDIF
   AINS(aMDC1,POSW)
   AINS(aMDC2,POSW)
   IF !EMPTY(mCBARM)
      aMDC1[POSW] = &mCBARM.
   ELSE
      aMDC1[POSW] = ' '+mCODIGO+' '+mNOME+' '+mARQUIVO
   ENDIF
   aMDC2[POSW] = mCODIGO
   pMDC := POSW
ENDIF

REPORVARS("METIQ",mCHAVE)

RETU .T.



//Get Nas Mvars

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMDC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gMDC

SETCOLOR(CORMDC[2])
@  3,8  GET mCODIGO                                                                                                                                                                                    
@  3,25 GET mNOME                                                                                                                                                                                      
@  4,8  GET mARQUIVO                                                                                                                                                                                   
@  4,33 GET mPIND                                                                                                   PICT "!"              VALID MDCK01() .AND. mPIND $ 'SN' WHEN !EMPTY(mARQUIVO)      
@  4,62 GET mPFIL                                                                                                   PICT "!"              VALID MDCK02() .AND. mPFIL $ 'SN' WHEN !EMPTY(mARQUIVO)      
@  5,22 GET mFILTRO                                                                                                 WHEN !EMPTY(mARQUIVO)                                                              
@  6,22 GET mCONFIL                                                                                                 WHEN !EMPTY(mARQUIVO)                                                              
@  8,4  GET mLINHA1                                                                                                 PICT "@S74"                                                                        
@  9,4  GET mLINHA2                                                                                                 PICT "@S74"                                                                        
@ 10,4  GET mLINHA3                                                                                                 PICT "@S74"                                                                        
@ 11,4  GET mLINHA4                                                                                                 PICT "@S74"                                                                        
@ 12,4  GET mLINHA5                                                                                                 PICT "@S74"                                                                        
@ 13,4  GET mLINHA6                                                                                                 PICT "@S74"                                                                        
@ 14,4  GET mLINHA7                                                                                                 PICT "@S74"                                                                        
@ 15,4  GET mLINHA8                                                                                                 PICT "@S74"                                                                        
@ 17,43 GET mNCOL                                                                                                   PICT '99'                                                                          
@ 19,43 GET mNLIN                                                                                                   PICT '99'                                                                          
@ 21,43 GET mNCAR                                                                                                   PICT '99'                                                                          
// @ 18,54 GET mARQGRA FILE CAMINHO ZDIRP+"TXT\" EXTENSAO "TXT" IMPSETUP {mSETUP,66,0,0,0,0,(mNCOL+1) * mNCAR - 1,.F.}                                                                                    
@ 21,54 GET mSETUP                                                                                                                                                                                     
@ 22,54 GET mSETUPFIM                                                                                                                                                                                  
READCUR()
RETU .T.

// **********

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDCK01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MDCK01

mINDICE := IF(mPIND = "S",1,NUMIND(mARQUIVO,mINDICE))
@  4,42 SAY mINDICE PICT "9"        
RETU .T.

// **********

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDCK02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MDCK02

mTIPFIL := IF(mPFIL = "S","1",STR(NUMFIL(mTIPFIL),1))
@  4,71 SAY mTIPFIL         
RETU .T.


