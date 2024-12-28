*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_a4.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:26 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :  FOLIS_A4.PRG : Acumular Dados para informa de Rendimentos
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :
// :*****************************************************************************


#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

CABE2('Acumulando Dados Para Informe')
IF !MDG('Deseja Realmente Acumular')
   RETU .F.
ENDIF

nACU := IRRESC()


IF !NETUSE("CONFIGU",,,,,.F.,)
   RETU .F.
ENDIF
HB_DISPBOX(8,0,23,79,"________ ")
@  9,24 SAY "FATORES DE ATUALIZA__O/CONVERS_O"          
@ 10,0  SAY '_'+REPL('_',78)+'_'                        
@ 12,2  SAY "JAN"+SPAC(23)+"FEV"+SPAC(24)+"MAR"         
@ 15,2  SAY "ABR"+SPAC(23)+"MAI"+SPAC(24)+"JUN"         
@ 18,2  SAY "JUL"+SPAC(23)+"AGO"+SPAC(24)+"SET"         
@ 21,2  SAY "OUT"+SPAC(23)+"NOV"+SPAC(24)+"DEZ"         
// Get nas Menvars
@ 12,7  GET DIRF01         
@ 12,33 GET DIRF02         
@ 12,60 GET DIRF03         
@ 15,7  GET DIRF04         
@ 15,33 GET DIRF05         
@ 15,60 GET DIRF06         
@ 18,7  GET DIRF07         
@ 18,33 GET DIRF08         
@ 18,60 GET DIRF09         
@ 21,7  GET DIRF10         
@ 21,33 GET DIRF11         
@ 21,60 GET DIRF12         
IF !READCUR()
   RETU .T.
ENDIF
FAT := {DIRF01,DIRF02,DIRF03,DIRF04,DIRF05,DIRF06,;
 DIRF07,DIRF08,DIRF09,DIRF10,DIRF11,DIRF12}
DBCLOSEALL()


CLSCOR()
CLSROW(8)
MESINI := MESFIM := 0
aCPF   := {}
aNUM   := {}

@ 23,00 CLEA
@ 23,00 SAY 'Qual o mes inicial'                                 
@ 24,00 SAY 'Qual o mes final'                                   
@ 23,40 GET MESINI               PICT '##' RANGE 1,12            
@ 24,40 GET MESFIM               PICT '##' RANGE MESINI,12       
IF !READCUR()
   RETU .F.
ENDIF

CORTAR := MDG("Deseja Cortar os Centavos")
APAGA  := MDG("Deseja apagar todo o acumulado")

MDS("Carregando Configuracao do Plano de Contas")
//Preenchendo Matriz com as Contas que acumulam
aCTA01 := {}  //Numero da Conta
aCTA02 := {}  //Descricao da Conta
aCTA03 := {}  //Posicao Para Informe/Dirf

IF !ARQIRR(nACU,1,4)  //Contas ctarpa
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   IF IRENDIMEN = 0 .AND. NRENDIMEN # 0
      AADD(aCTA01,CODIGO)
      AADD(aCTA02,DESCR)
      AADD(aCTA03,NRENDIMEN)
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEALL()

//Verifica Configura+"o
nCTA := LEN(aCTA01)
IF nCTA = 0
   MDT("Nenhuma Conta esta sendo acumulada")
   RETU .F.
ENDIF

//Apaga acumula+"o Anterior
MDS("Checando CPF")

IF !ARQIRR(nACU,1,3)  //PES DIR MG01 RPA
   RETU .F.
ENDIF
cSELE1 := ALIAS()
DBGOTOP()
WHILE !EOF()
   PETELA(8)
   nPOS := ASCAN(aCPF,CPF)
   IF nPOS > 0
      ALERTX("CPF - Duplicado com o funcionario: "+STR(aNUM[nPOS]))
      IF !MDG("Continuar mesmo Assim")
         DBCLOSEALL()
         RETU .F.
      ENDIF
   ELSE
      AADD(aCPF,CPF)
      AADD(aNUM,NUMERO)
   ENDIF
   IF EMPTY(CPF) .OR. CPF = "000.000.000-00"
      ALERTX("Sem CPF")
      IF !MDG("Continuar Mesmo Assim")
         DBCLOSEALL()
         RETU
      ENDIF
   ENDIF
   DBSKIP()
ENDDO



FILTRO := ''
FI     := TRIM(FILTRO)
FILTRO := FILTRO(FI)
SET FILTER TO &FILTRO
IF !ARQIRR(nACU,0,2)  //exclusive  fo_irrf
   RETU .F.
ENDIF
cSELE2 := ALIAS()
FLOCK()
//Limpa o arquivo se for completa
IF MESINI = 1 .AND. MESFIM = 12 .AND. APAGA
   ZAP
ENDIF
//Acumulando o Periodo
MDS("Acumulando Dados")
FOR X := MESINI TO MESFIM
   //Apaga todos os lan+amentos do mes se acumula+"o for periodo
   IF APAGA .AND. (MESINI # 1 .OR. MESFIM # 12)
      nLASTREC := LASTREC()
      zei_fort(nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{|| MES = X},{|| zei_fort(nLASTREC,,,1)})
   ENDIF
   ARQTRAB := STRZERO(X,2)
   DO CASE
   CASE nACU = 1 
      FOT := 'FP'+EMP+ARQTRAB
      IND := "CONTROLE"
   CASE nACU = 2 
      FOT := 'SO'+EMP+ARQTRAB
      IND := "CONTROLE"
   CASE nACU = 3 
      FOT := 'RP'+ARQTRAB
      IND := "NUMERO*10000+SEMANA*1000+CONTA"
   ENDCASE
   INFOR(FOT,IND,ZDIRE+FOT,.T.)
   CLSROW(8)
   hb_dispbox(19,00,21,79,B_DOUBLE)
   @ 20,03 SAY 'MES: '+MMES(X)         
   IF !NETUSE(FOT)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   DBSELECTAR(cSELE1)
   DBGOTOP()
   WHILE !EOF()
      PETELA(8)
      mNUMERO := NUMERO
      mCPF    := CPF
      IF EMPTY(mCPF) .OR. mCPF = "000.000.000-00"
         ALERTX("Sem CPF")
         IF !MDG("Continuar Mesmo Assim")
            DBCLOSEALL()
            RETU
         ENDIF
      ENDIF
      //Apagar Todos os lan+amentos do mes do funcionario
      IF !APAGA
         DBSELECTAR(cSELE2)
         nLASTREC := LASTREC()
         zei_fort(nLASTREC,,,0)
         DBEVAL({|| netrecdel()},{|| NUMERO = mNUMERO .AND. MES = X},{|| zei_fort(nLASTREC,,,1)})
      ENDIF
      //Procurando Valores
      FOR W := 1 TO nCTA
         IF nACU = 1 .OR. nACU = 2  //Funcionario Diretor
            mCONTROLE := (mNUMERO * 10000)+aCTA01[W]
         ELSE
            mCONTROLE := NUMERO * 10000+0 * 1000+aCTA01[W]  //Considerando Semana=0
         ENDIF
         DBSELECTAR(FOT)
         DBGOTOP()
         IF DBSEEK(mCONTROLE)
            MDS(aCTA02[W])
            mVALOR   := VALOR
            mVALUFIR := IF(FAT[X] # 0,ROUND(mVALOR / FAT[X],2),mVALOR)
            mVALUFIR := IF(CORTAR,INT(mVALUFIR),mVALUFIR)
            mCTRLIRR := (mNUMERO * 100000)+(aCTA03[W] * 100)+X
            mCTRLCPF := mCPF+STR(aCTA03[W],3)+STR(X,2)
            DBSELECTAR(cSELE2)
            DBGOTOP()
            IF !DBSEEK(mCTRLCPF)
               NETRECAPP()
               FIELD->NUMERO   := mNUMERO
               FIELD->MES      := X
               FIELD->CODREN   := aCTA03[W]
               FIELD->CPF      := mCPF
               FIELD->CONTROLE := mCTRLIRR
               FIELD->CONTROL2 := mCTRLCPF
            ELSE
               NETRECLOCK()
            ENDIF
            FIELD->VALOR   := VALOR+mVALOR
            FIELD->VALUFIR := VALUFIR+mVALUFIR
            DBUNLOCK()
         ELSE
            MD()
         ENDIF
      NEXT W
      DBSELECTAR(cSELE1)
      DBSKIP()
   ENDDO
   DBSELECTAR(FOT)
   DBCLOSEAREA()
NEXT X
MDS("Aguarde Fechando Arquivos")
DBSELECTAR(cSELE2)  //flock() acima
PACK
DBCLOSEALL()
IF MDG("Gravar Resultados Informe")
   FOLIS_C6("G",nACU)
ENDIF


// : FIM: FOLIS_A4.PRG

*+ EOF: folis_a4.prg
*+
