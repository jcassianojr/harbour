*+--------------------------------+
*Ý Autor: Anderson Cardoso Silva  Ý
*+--------------------------------+
* Exportar DBFCDX para DBFNTX

*
*
function fpt2dbt()
LOCAL RAIZ[ADIR("*.FPT")]
AR := {}
CLS

//REQUEST DBFCDX //ja ao carregar o programa

SETCURSOR(0)
SETCOLOR("W+/B")
CLS
@ 00,00 SAY REPLI(" ",79) COLOR "W+/BG"
@ 24,00 SAY REPLI(" ",79) COLOR "W+/BG"
//@ 00,02 SAY "-- FPT2DBT v1.0 --  CONVERSOR DE BASES DBFCDX PARA DBFNTX " COLOR "W+/BG"
//@ 24,02 SAY "Anderson Cardoso Silva - www.caclipper.cjb.net" COLOR "W+/BG"
@ 02,00 SAY PADC("Transforma‡„o DBFCDX -> DBFNTX",79) COLOR "BG+/B"
*------------

*** 1o. ESTAGIO
*** CHECAGEM DA FUNCAO 1x1 DE DBFxFPT ***
******
@ 05,00 SAY "Criando a lista de DBFs a serem alterados..."
ADIR("*.FPT", RAIZ) // LISTA DE DBFs
@ 05,00 SAY "                                            "
@ 05,00 SAY "Verificando fun‡„o 1x1 de DBFxFPT..."

@ 07,05 SAY "Progresso: 0%" //16
CNT := Y := AP := PC := 0

FIM := LEN(RAIZ)
FI  := FIM/100
lTODOS := .F.
nFOI := 0
X := 1
DO WHILE X <= FIM
    AD   := RAIZ[X]
    IF !EMPTY(AD)
       AD := ALLTRIM(AD)
       ARQ  := SUBSTR( AD, 1, LEN(AD)-4 )+".DBF"
    ENDIF
    IF !EMPTY(AD)
       IF ! file(ARQ)
          // EFETUA A REMOCAO DO DBT DA LISTA
          aDEL(RAIZ,X)
          nFOI++
          X--
          FIM--
          aSIZE(RAIZ,FIM)
          *PC -= (CNT/FI)
          //------
          IF !lTODOS
             nCUAL := ALERTX("OOOPS! Falha na fun‡„o... N„o existe o arquivo "+ARQ+"! CONTINUA?",{"NAO","SIM","SIM P/ TODOS"})
          ENDIF
          IF nCUAL = 1
             ? "Programa abortado devido a nao existencia de uma co-relacao"
             ? "DBF x FPT."
             QUIT
          ELSEIF nCUAL = 3
             lTODOS := .T.
          ENDIF
       ENDIF
    ENDIF

    CNT++
    IF CNT >= FI
       PC += (CNT/FI)
       @ 07,16 SAY ALLTRIM(STR(PC))+"%   "
       CNT := 0
    ENDIF
    X++
ENDDO
K := 0
aTEMP := {}
FOR T=1 TO FIM
    K2 := VAL( SUBSTR(TIME(),8,1) )
    cDBFTMP := CHR(65+K)+CHR(65+K2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)
    K++
    IF K>20
       K:= 0
    ENDIF
    aADD(aTEMP, cDBFTMP)
NEXT
//@ 15,05 SAY "PRONTO! TECLE ALGO P/ ENTRAR NO 2o. ESTAGIO" COLOR "GR+/R*"
//TONE(100,1)
//INKEY(0)


*** 2o. ESTAGIO - CRIANDO DBFNTX E IMPORTANDO REGISTROS
*** NAO  PRECISO ESTAREM FORA DA REDE AGORA!
*****
@ 02,00 CLEA TO MAXROW()-1,79
@ 07,05 SAY "Progresso: 0%" //16
CNT := Y := AP := PC := 0

FIM := LEN(RAIZ)
FI  := FIM/100
FOR X=1 TO FIM
    AD   := RAIZ[X]; AD := ALLTRIM(AD)
    ARQ  := SUBSTR( AD, 1, LEN(AD)-4 )

    ARQ2 := aTEMP[X]

    @ 10,05 SAY "Trabalhando o arquivo "+ARQ+".DBF             "

    USE (ARQ) ALIAS CDX SHARED NEW VIA "DBFCDX"

    @ 12,05 SAY "Exportando estrutura do arquivo...               "
    COPY STRUCTURE TO (ARQ2)
    IF file(ARQ2+".DBF") .AND. file(ARQ2+".DBT")
       @ 12,40 SAY "SUCESSO!"
    ENDIF

    USE (ARQ2) ALIAS NTX EXCLUSIVE NEW

    @ 13,05 SAY "Importando registros p/ NTX..."
    SELE NTX
    
    nLASTREC:=NetRegCount(arq)
    zei_fort( nLASTREC,,,0)
    APPEND FROM (ARQ) VIA "DBFCDX"  while zei_fort(nLASTREC,,,1)

    DBCLOSEALL()

    CNT++
    IF CNT >= FI
       PC += (CNT/FI)
       @ 07,16 SAY ALLTRIM(STR(PC))+"%   "
       CNT := 0
    ENDIF
    DBCLOSEALL()
NEXT
//@ 15,05 SAY "PRONTO! TECLE ALGO P/ ENTRAR NO 3o. ESTAGIO" COLOR "GR+/R*"
//TONE(100,1)
//INKEY(0)


*** 3o. ESTAGIO -RENOMEANDO ARQUIVOS TEMPORARIOS P/ ARQUIVO ATUAL
*** AGORA  PRECISO ESTAREM FORA DA REDE!
******
@ 02,00 CLEA TO MAXROW()-1,79
@ 02,00 SAY "3o. ESTAGIO -RENOMEANDO ARQUIVOS TEMPORARIOS P/ ARQUIVO ATUAL"
@ 03,00 SAY "AGORA  PRECISO ESTAREM FORA DA REDE!" COLOR "GR+/B"

//@ 05,00 SAY "TECLE ALGO QUANDO PRONTO..." COLOR "GR+/R*"
//INKEY(0)
//@ 05,00 CLEA TO 05,79

CNT := Y := AP := PC := 0
@ 07,05 SAY "Progresso: 0%" //16
FIM := LEN(RAIZ)
FI  := FIM/100
FOR X=1 TO FIM
    AD   := RAIZ[X]
    AD := ALLTRIM(AD)
    ARQ  := SUBSTR( AD, 1, LEN(AD)-4 ) // nome sem extensao

    ARQ2 := aTEMP[X]

    @ 10,05 SAY "Trabalhando o arquivo "+ARQ+".DBF             "
    *** APAGA VELHO DBFCDX
    D1 := FERASE(ARQ+".DBF")
    D2 := FERASE(ARQ+".FPT")
    tPE := SAVESCREEN(24,00,24,79)
    DO WHILE (D1+D2) # 0
       D1 := FERASE(ARQ+".DBF")
       D2 := FERASE(ARQ+".FPT")
       nE := FERROR()
       IF nE # 0
          @ 24,00 SAY SPACE(80) COLOR "GR+/BG"
          @ 24,00 SAY "ERRO! "+ERRO(nE)
       ENDIF
       A := INKEY()
       IF A = 27
          IF ALERTX("Tentando apagar "+ARQ+". Continua?", {"Sim","Nao"}) = 2
             EXIT
          ENDIF
       ENDIF
    ENDDO
    RESTSCREEN(24,00,24,79, tPE)

    *** RENOMEIA P/ NOVO DBFNTX
    D1 := FRENAME(ARQ2+".DBF", ARQ+".DBF")
    D2 := FRENAME(ARQ2+".DBT", ARQ+".DBT")
    tPE := SAVESCREEN(24,00,24,79)
    DO WHILE (D1+D2) # 0
       D1 := FRENAME(ARQ2+".DBF", ARQ+".DBF")
       D2 := FRENAME(ARQ2+".DBT", ARQ+".DBT")
       nE := FERROR()
       IF nE # 0
          @ 24,00 SAY SPACE(80) COLOR "GR+/BG"
          @ 24,00 SAY "ERRO! "+ERRO(nE)
       ENDIF
       A := INKEY()
       IF A = 27
          IF ALERTX("Tentando renomear "+ARQ2+" p/ "+ARQ+". Continua?", {"Sim","Nao"}) = 2
             EXIT
          ENDIF
       ENDIF
    ENDDO
    RESTSCREEN(24,00,24,79, tPE)

    CNT++
    IF CNT >= FI
       PC += (CNT/FI)
       @ 07,16 SAY ALLTRIM(STR(PC))+"%   "
       CNT := 0
    ENDIF
    DBCLOSEALL()
NEXT
TONE(100,1)
@ 20,10 SAY "PROCESSO DBFCDX -> DBFNTX TERMINADO!!!" COLOR "GR+/R*"
QUIT
retu .t.



FUNCTION ERRO(nERRO)
aERRO := {}
aADD(aERRO,{0,"SUCESSO"})
aADD(aERRO,{2,"ARQUIVO NAO ENCONTRADO"})
aADD(aERRO,{3,"CAMINHO NAO ENCONTRADO"})
aADD(aERRO,{4,"MUITOS ARQUIVOS ABERTOS"})
aADD(aERRO,{5,"ACESSO NEGADO"})
aADD(aERRO,{6,"HANDLE INVALIDO"})
aADD(aERRO,{8,"MEMORIA INSUFICIENTE"})
aADD(aERRO,{15,"ESPECIFICADO UM DRIVE INVALIDO"})
aADD(aERRO,{19,"TENTATIVA DE GRAVAR EM DISCO PROTEGIDO"})
aADD(aERRO,{21,"DISCO NAO PRONTO"})
aADD(aERRO,{23,"ERRO DE CRC"})
aADD(aERRO,{29,"ERRO DE GRAVACAO"})
aADD(aERRO,{30,"ERRO DE LEITURA"})
aADD(aERRO,{32,"VIOLACAO DE COMPARTILHAMENTO"})
aADD(aERRO,{33,"VIOLACAO DE TRAVAMENTO"})

nPOS  := aSCAN(aERRO, {|aVAL| aVAL[1] == nERRO })
cERRO := aERRO[nPOS][2]

RETURN (cERRO)

