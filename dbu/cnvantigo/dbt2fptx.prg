*+--------------------------------+
*Ý Autor: Anderson Cardoso Silva  Ý
*+--------------------------------+
* Exportar DBFNTX para DBFCDX
*
*

function dbt2fpt()

LOCAL RAIZ[ADIR("*.DBT")]
AR := {}
CLS

//REQUEST DBFCDX //ja ao carregar o programa
RDDSETDEFAULT("DBFCDX")

SETCURSOR(0)
SETCOLOR("W+/B")
CLS
@ 00,00 SAY REPLI(" ",79) COLOR "W+/BG"
@ 24,00 SAY REPLI(" ",79) COLOR "W+/BG"
//@ 00,02 SAY "-- DBT2FPT v1.0 --  Atualiza‡„o do sistema para bases CDX " COLOR "W+/BG"
//@ 24,02 SAY "Anderson Cardoso Silva - www.caclipper.cjb.net" COLOR "W+/BG"
@ 02,00 SAY PADC("Transforma‡„o DBFNTX -> DBFCDX",79) COLOR "BG+/B"
*------------

*** 1o. ESTAGIO
*** CHECAGEM DA FUNCAO 1x1 DE DBFxDBT ***
******
@ 05,00 SAY "Criando a lista de DBFs a serem alterados..."
ADIR("*.DBT", RAIZ) // LISTA DE DBFs
@ 05,00 SAY "                                            "
@ 05,00 SAY "Verificando fun‡„o 1x1 de DBFxDBT..."

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
             ? "DBF x DBT."
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


*** 2o. ESTAGIO - CRIANDO DBFCDX E IMPORTANDO REGISTROS
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

    USE (ARQ) ALIAS NTX SHARED NEW VIA "DBFNTX"

    @ 12,05 SAY "Exportando estrutura do arquivo... "
    COPY STRUCTURE TO (ARQ2)
    IF file(ARQ2+".DBF") .AND. file(ARQ2+".FPT")
       ?? "SUCESSO!"
    ENDIF

    USE (ARQ2) ALIAS CDX EXCLUSIVE NEW

    @ 13,05 SAY "Importando registros p/ CDX..."
    SELE CDX
    
    nLASTREC:=NetRegCount(arq)
    zei_fort( nLASTREC,,,0)
    
    APPEND FROM (ARQ) VIA "DBFNTX"  while zei_fort(nLASTREC,,,1)

    DBCLOSEALL()

    CNT++
    IF CNT >= FI
       PC += (CNT/FI)
       @ 07,16 SAY ALLTRIM(STR(PC))+"%   "
       CNT := 0
    ENDIF
    DBCLOSEALL()
NEXT


*** 3o. ESTAGIO -RENOMEANDO ARQUIVOS TEMPORARIOS P/ ARQUIVO ATUAL
*** AGORA  PRECISO ESTAREM FORA DA REDE!
******
@ 02,00 CLEA TO MAXROW()-1,79
@ 02,00 SAY "3o. ESTAGIO -RENOMEANDO ARQUIVOS TEMPORARIOS P/ ARQUIVO ATUAL"
@ 03,00 SAY "AGORA  PRECISO ESTAREM FORA DA REDE!" COLOR "GR+/B"

@ 05,00 CLEA TO 05,79

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
    *** APAGA VELHO DBFNTX
    D1 := FERASE(ARQ+".DBF")
    D2 := FERASE(ARQ+".DBT")
    tPE := SAVESCREEN(24,00,24,79)
    DO WHILE (D1+D2) # 0
       D1 := FERASE(ARQ+".DBF")
       D2 := FERASE(ARQ+".DBT")
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

    *** RENOMEIA P/ NOVO DBFCDX
    D1 := FRENAME(ARQ2+".DBF", ARQ+".DBF")
    D2 := FRENAME(ARQ2+".FPT", ARQ+".FPT")
    tPE := SAVESCREEN(24,00,24,79)
    DO WHILE (D1+D2) # 0
       D1 := FRENAME(ARQ2+".DBF", ARQ+".DBF")
       D2 := FRENAME(ARQ2+".FPT", ARQ+".FPT")
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
@ 20,10 SAY "PROCESSO DBFNTX -> DBFCDX TERMINADO!!!" COLOR "GR+/R*"
QUIT
RETU 


