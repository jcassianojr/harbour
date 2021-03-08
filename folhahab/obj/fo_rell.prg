*:*****************************************************************************
*:
*:     FO_RELL.PRG: Impresso de Relatorios Configurados
*:       Linguagem: Harbour
*:        Sistema: FOLHA DE PAGAMENTO
*: 
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"


function fo_rell
PARA BUSCA

mTEMP=tmpfile(cRDDEXT)
IF ! netuse("DISKRELA")      &&PROCURAR A LISTA
   DBCLOSEALL()
   RETU
ENDIF
DBGOTOP()
IF ! DBSEEK(BUSCA)
   MDT('N„o Encontrei o Formul rio')
   DBCLOSEAREA()
   RETU .F.
ENDIF
MDS('Carregando a lista Aguarde')
LICA=LCAB                                                &&PARAMETROS DA LISTA
LICO=LCOT
LIRO=LROD
TOTL=LCAB+LCOT+LROD
ARQUSO=ALLTRIM(ARQUIVO)
FIL=FILTRO
SET=SETUP
LIS=LISTA
LISC=LISTAC
LISR=LISTAR
MEMORIZ1=MEMORIA1
MEMORIZ2=MEMORIA2
MEMORIZ3=MEMORIA3
ASSOCIZ1=ASSOCIA1
ASSOCIZ2=ASSOCIA2
ASSOCIZ3=ASSOCIA3
VARIAVZ1=VARIAVEL1
VARIAVZ2=VARIAVEL2
VARIAVZ3=VARIAVEL3
TOTAISZ1=TOTAIS1
TOTAISZ2=TOTAIS2
TOTAISZ3=TOTAIS3
TIP=TIPO
VEZES=REP
mGRAVAREM:=GRAVAREM
DBCLOSEAREA()

//Verifica se n„o existe macro de arquivo
IF LEFT(ARQUSO,1)="&"
   ARQUSO=SUBSTR(ARQUSO,2)
   ARQUSO=&ARQUSO.
ENDIF
PAG=CHR(12)                                    &&TIPOS ESPECIAIS DE IMPRESSAO
AQ=CHR(27)+CHR(71)    //Ativa Qualidade de Carta
DQ=CHR(27)+CHR(72)    //desativa Qualidade de Carta
AE=cIMPTIT            //Ativa linha expandida
AC=cIMPCOM              //Ativa o modo comprimido
DC=cIMPEXP              //Desativa Comprimido
AI=CHR(27)+CHR(52)         //Ativa it lico
DI=CHR(27)+CHR(53)           //  Desativa it lico
AN=cIMPNEG                 //Ativa negrito
DN=cIMPNER                 //Desativa Negrito 
AX=CHR(27)+CHR(83)+CHR(00)        //Ativa impress„o exponencial
AD=CHR(27)+CHR(83)+CHR(01)        //Ativa impress„o de ind¡ces
DXD=CHR(27)+CHR(84)              //Desativa exponencial e ou indice
AS=CHR(27)+CHR(45)+CHR(00)              //Ativa sublinhado
DS=CHR(27)+CHR(45)+CHR(01)                   //Desativa sublinhado
AEC=CHR(27)+CHR(87)+CHR(00)                     //Ativa expandido cont¡nuo
DEC=CHR(27)+CHR(87)+CHR(01)                      //Desativa expandido cont¡nuo
AIE=CHR(27)+CHR(52)+CHR(27)+CHR(87)+CHR(01)     //Ativa it lico expandido
DIE=CHR(27)+CHR(53)+CHR(27)+CHR(87)+CHR(00)     //Desativa It lico expandido
AIC=CHR(27)+CHR(91)+CHR(50)+CHR(27)+CHR(52)       //Ativa It lico condensado
DIC=CHR(27)+CHR(91)+CHR(48)+CHR(27)+CHR(53)   //Desativa It lico Condensado
ACA=CHR(27)+CHR(91)+CHR(50)            //Ativa Condensado 12cpp
ACB=CHR(27)+CHR(91)+CHR(51)            //Ativa Condensado 15cpp
ACC=CHR(27)+CHR(91)+CHR(52)            //Ativa Condensado 17cpp
ACD=CHR(27)+CHR(91)+CHR(53)            //Ativa Condensado 20cpp
DCE=CHR(27)+CHR(91)+CHR(48)            //Desativa os condensados ACA,ACB,ACC,ACD
ZMES=MMES(MONTH(ZDATA))
ZDIA=DTOC(ZDATA)
ZANO=STRZERO(YEAR(ZDATA),4)
ZDDI=STRZERO(DAY(ZDATA),2)
ZDEX=ZDDI+" de "+ZMES+" de "+ZANO
ZRSM=REPL("-",132)
ZRDM=REPL("=",132)
ZRSS=REPL("-",80)
ZRDS=REPL("=",80)

ZFOL  :=ZREG:=0                    &&VARIAVEIS DE TOTALIZACAO
LINHAS:=ARRAY(TOTL)                &&MATRIZES DO LAYOUT
LN    :=ARRAY(TOTL)
CL    :=ARRAY(TOTL)
MEMO  :=ARRAY(30)                   &&MATRIZ MEMO/ASSOCIA
ASSO  :=ARRAY(30)
ASSV  :=ARRAY(30)
FV    :=ARRAY(30)                   &&MATRIZ VARIAVEL
VAR   :=ARRAY(30)
FT    :=ARRAY(30)                   &&MATRIZ TOTAIS
TOT   :=ARRAY(30)

//Variaveis de Posi‡„o
POSMID:=POSROD:=POSQUE:=.F.
POSTOP:=.T.


//Preenche a matrizes com vazios
AFILL(MEMO,"")
AFILL(ASSO,"")
AFILL(ASSV,0)
AFILL(FV,"")
AFILL(VAR,"")
AFILL(FT,"")
AFILL(TOT,0)



IF ! NETUSE("DISKREL1")   &&CARREGA CABECARIO
   RETU
ENDIF
LAYR(LISC,1          ,LICA)
LAYR(LIS ,LICA+1     ,LICA+LICO)                            &&CARREGA CONTEUDO
LAYR(LISR,LICA+LICO+1,LICA+LICO+LIRO)                       &&CARREGA RODAPE
DBCLOSEAREA()

IF ! NETUSE("DISKRELM")    &&CARREGA MEMORIA
   RETU
ENDIF
MEMOX(MEMORIZ1, 0,1)
MEMOX(MEMORIZ2,10,1)
MEMOX(MEMORIZ2,20,1)
MEMOX(VARIAVZ1, 0,3)                                      &&CARREGA VARIAVEL
MEMOX(VARIAVZ2,10,3)
MEMOX(VARIAVZ3,20,3)
MEMOX(TOTAISZ1, 0,4)                                       &&CARREGA TOTAIS
MEMOX(TOTAISZ2,10,4)
MEMOX(TOTAISZ3,20,4)
DBCLOSEAREA()

IF ! NETUSE("DISKRELS")    &&CARREGA ASSOCIAR
   RETU
ENDIF
MEMOX(ASSOCIZ1, 0,2)
MEMOX(ASSOCIZ2,10,2)
MEMOX(ASSOCIZ3,20,2)
DBCLOSEAREA()


COPIAS=1                    && NUMERO DE COPIAS RELATORIOS SEM ARQUIVOS
MDS('Quantas Copias')
@ 24,30 GET copias PICT '###' RANGE 1,999
READCUR()

IF ! CHECKIMP(0,.T.)
   RETU .F.
ENDIF

IMPRESSORA()                 && INICIA SETUP DA IMPRESSORA
IF ! EMPTY(SET)
   @ PROW(),0 SAY &SET
ENDIF

//Se o tipo ‚ AB ou AA apenas uma repiti‡„o do conteudo e realizada
IF TIP='AB'.OR.TIP='AA'
   VEZES=1
ENDIF

//IMPRESSAO TIPO AB E AD Sem Arquivos
IF TIP='AB'.OR.TIP='AD'
   FOR Z=1 TO COPIAS
      ZFOL++
      IMPCAB()
      FOR Y=1 TO VEZES
         IMPCOT()
      NEXT Y
      IMPROD()
   NEXT Z
ENDIF

//IMPRESSAO TIPO AA OU AC Com Arquivos
IF TIP='AC'.OR.TIP='AA'
   VIDEO()
   IF ! NETUSE(ARQUSO) 
      RETU
   ENDIF
   cSELE5:=ALIAS()
   FILTRO=FIL
   INX    := ""
   FILORD(.T.)
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   if valtype(INX)="N"
      dbsetorder(INX)
   ELSE
      ordDestroy("temp")
      ordcreate(,"temp",inx)
      ordSetFocus("temp")
   ENDIF   
   set filter to &FILTRO
   
   IMPRESSORA()
   FOR Z=1 TO COPIAS
      // Zera as Variaveis totalizadoras
      ZFOL  :=ZREG:=0                     &&VARIAVEIS DE TOTALIZACAO
      AFILL(TOT,0)                        &&ZERA OS TOTALIS
      DBGOTOP()
      WHILE ! EOF()
         ZFOL++
         IMPCAB()
         FOR Y=1 TO VEZES
            CALCVAR()
            CALCTOT()
            IMPCOT()
            ZREG++
            DBSELECTAR(cSELE5)
            DBSKIP()
            IF EOF()
               EXIT
            ENDIF
         NEXT Y
         IMPROD()
      ENDDO
   NEXT Z
   DBSELECTAR(cSELE5)
   DBCLOSEAREA()
ENDIF

/* IMPRESSAO TIPO AE Com Arquivos
Utiliza‡„o B sica Resumo de Situa‡”es
2a. Processamento todos os registros do arquivo
1a. Imprime o Cabe‡ario
3a. N„o Imprime o Conteudo
4a. Imprime o Rodap‚
*/
IF TIP='AE'
   //Processa o arquivo Calculando Variaveis e Totais
   VIDEO()
   IF ! NETUSE(ARQUSO) 
      RETU
   ENDIF
   
   FILTRO=FIL
   INX    := ""
   FILORD(.T.)
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   if valtype(INX)="N"
      dbsetorder(INX)
   ELSE
      ordDestroy("temp")
      ordcreate(,"temp",inx)
      ordSetFocus("temp")
   ENDIF   
   set filter to &FILTRO
   
   
   DBGOTOP()
   WHILE ! EOF()
      CALCVAR()
      CALCTOT()
      ZREG++
      DBSKIP()
   ENDDO
   DBCLOSEAREA()

   //Inicia Impress„o
   IMPRESSORA()
   FOR Z=1 TO COPIAS
      //Imprime o Cabe‡ario
      IMPCAB()
      //Imprime o Rodap‚
      IMPROD()
   NEXT Z
   //Defalt Finalizacao de pagina
   IMPFOL()
ENDIF
VIDEO()
IMPEND()
RETU



*!*****************************************************************************
*!
*!         Fun‡„o: IMPLIN()
*!
*!    Chamado por: IMPCAB()           (fun‡„o    em FO_RELL.PRG)
*!               : IMPCOT()           (fun‡„o    em FO_RELL.PRG)
*!               : IMPROD()           (fun‡„o    em FO_RELL.PRG)
*!
*!*****************************************************************************
FUNC IMPLIN                                      &&IMPRIME UMA LINHA DE EDICAO
DIZERES=ALLTRIM(LINHAS[X])
PUL=LN[X]
COL=CL[X]
DIGA:=&DIZERES
IF VALTYPE(DIGA)="C"
   IF DIGA="PAG".OR.DIGA="CHR(12)"
      IMPFOL()
   ELSE
      @ PROW()+PUL,COL SAY ACENTO(DIGA)
   ENDIF   
ELSE
   @ PROW()+PUL,COL SAY DIGA
ENDIF
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: IMPCAB()
*!
*!    Chamado por: FO_RELL.PRG
*!
*!          Chama: IMPLIN()           (fun‡„o    em FO_RELL.PRG)
*!
*!*****************************************************************************
FUNC IMPCAB                                              &&IMPRIME O CABECARIO
IF ! EMPTY(LISC)
   FOR X=1 TO LICA
      IMPLIN()
   NEXT X
ENDIF
//Ajusta Variaveis de Posi‡„o
POSTOP:=.F.
POSMID:=.T.
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: IMPCOT()
*!
*!    Chamado por: FO_RELL.PRG
*!
*!          Chama: IMPLIN()           (fun‡„o    em FO_RELL.PRG)
*!
*!*****************************************************************************
FUNC IMPCOT                                               &&IMPRIME O CONTEUDO
FOR X=LICA+1 TO LICA+LICO
   IMPLIN()
NEXT X
//Ajusta Variaveis de Posi‡„o
POSMID:=.F.
POSROD:=.T.
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: IMPROD()
*!
*!    Chamado por: FO_RELL.PRG
*!
*!          Chama: IMPLIN()           (fun‡„o    em FO_RELL.PRG)
*!
*!*****************************************************************************
FUNC IMPROD                                                 &&IMPRIME O RODAPE
IF ! EMPTY(LISR)
   FOR X=LICA+LICO+1 TO LICA+LICO+LIRO
      IMPLIN()
   NEXT X
ENDIF
//Ajusta Variaveis de Posi‡„o
POSROD:=.F.
POSTOP:=.T.
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: ASS()
*!
*!*****************************************************************************
FUNC ASS(xASSVAL)                                &&ASSOCIA VALORES A PALAVRAS
LOCAL PAL:=""
LOCAL POSICAO
POSICAO:=ASCAN(ASSV,xASSVAL)
IF POSICAO#0
   PAL=ASSO[POSICAO]
ENDIF
RETU PAL


*!*****************************************************************************
*!
*!         Fun‡„o: MEMOX()
*!
*!    Chamado por: FO_RELL.PRG
*!
*!*****************************************************************************
FUNC MEMOX
PARA MEMORIZA,SOME,AMAT                 &&BUSCAR,POSICAO MATRIZ,MATRIZ DESTINO
IF MEMORIZA#SPAC(6)
   DBGOTOP()
   IF DBSEEK(MEMORIZA)
      FOR X=1 TO 10
         MM='M'+STRZERO(X,2)
         DO CASE
         CASE AMAT=1
            MEMO[X+SOME]=RTRIM(&MM)
         CASE AMAT=2
            VV='V'+STRZERO(X,2)
            ASSO[X+SOME]=RTRIM(&MM)
            ASSV[X+SOME]=&VV
         CASE AMAT=3
            FV[X+SOME]=RTRIM(&MM)
         CASE AMAT=4
            FT[X+SOME]=RTRIM(&MM)
         ENDCASE
      NEXT X
   ENDIF
ENDIF
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: LAYR()
*!
*!    Chamado por: FO_RELL.PRG
*!
*!*****************************************************************************
FUNC LAYR
PARA BUSCA,xINI,xFIM                                  &&BUSCAR,INICIO,FIM LOOP
IF BUSCA#SPAC(6)
   BUSCA=BUSCA+"    1"
   DBGOTOP()
   DBSEEK(BUSCA)
   FOR X=xINI TO xFIM
      LINHAS[X]=IF(EMPTY(DIZ),"",DIZ)
      LN[X]    =LIN
      CL[X]    =COL
      DBSKIP()
   NEXT
ENDIF
RETU .T.


*!*****************************************************************************
*!
*!         Fun‡„o: CALCVAR()
*!
*!    Chamado por: FO_RELL.PRG
*!
*!*****************************************************************************
FUNC CALCVAR                                            &&CALCULA AS VARIAVEIS
FOR W=1 TO 30
   TEMP=FV[W]
   VAR[W]=IF(EMPTY(TEMP),"",&TEMP)
NEXT W
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: CALCTOT()
*!
*!    Chamado por: FO_RELL.PRG
*!
*!*****************************************************************************
FUNC CALCTOT                                               &&CALCULA OS TOTAIS
FOR W=1 TO 30
   TEMP=FT[W]
   TOT[W]=IF(EMPTY(TEMP),"",&TEMP)
NEXT W
RETU .T.
*: FIM: FO_RELL.PRG
