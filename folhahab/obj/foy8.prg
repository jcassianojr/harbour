*:*****************************************************************************
*:
*:       FOY8.PRG: Atualizando Estruturas de Arquivos
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:27
*:
*:  Procs & Fncts: FOY8()
*:               : MUDADBF()
*:
*:          Chama: CLSCOR()           (fun‡„o    em ?)
*:               : CABEX()            (fun‡„o    em FOLPROC.PRG)
*:               : MUDADBF()          (fun‡„o    em FOY8.PRG)
*:               : RFILORD()          (fun‡„o    em FOLPROC.PRG)
*:
*:     Arq. Dados: FIRMA
*:
*:         Indice: FIRNR      N£mero de Cadastramento
*:                            NRCLIEN
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************


////#INCLUDE "COMANDO.CH"

function foy8
para cSISTEMA
IF VALTYPE(cSISTEMA)#"C"
   cSISTEMA:="FOLHA"
ENDIF

SCR_FOY8=SAVESCREEN(00,00,03,79)
CLSCOR()
CABEX("Atualizando Estruturas de Arquivos")
//Guarda o Diretorio principal
PATWORK=HB_CWD()
IF cSISTEMA="SETOR".OR.MDG("Deseja alterar estrutura do Diretorio Principal")
   CLSCOR()
   MDT('Atualizando dbf no diretorio principal')
   MUDADBF()
ENDIF
IF cSISTEMA="SETOR"
   RETU
ENDIF
aNUMEMP={}
aCOGEMP={}
FILTRO=""
aRETU:=RFILORD("FIRMA",.F.)
INX:=aRETU[1]
FILTRO:=aRETU[2]

IF ! NETUSE("FIRMA") 
   RETU .F.
ENDIF
SET FILTER TO &FILTRO
DBGOTOP()
WHILE ! EOF()
   IF cSISTEMA<>"FISCAL"
      AADD(aNUMEMP,NRCLIEN)
   ELSE
      AADD(aNUMEMP,NUMERO)
   ENDIF
   AADD(aCOGEMP,COGNOME)
   DBSKIP()
ENDDO
DBCLOSEALL()

pNUMEMP=LEN(aNUMEMP)
FOR W=1 TO pNUMEMP
   MDT('Atualizando dbf no diretorio da empresa : '+aCOGEMP[W])
   CLSCOR()
   // Mudar para diretorio da empresa
   // DIRCHANGE(PATWORK+'\EMP'+ANOWORK+STRZERO(aNUMEMP[W],3))
   HB_CWD(PATWORK+'\EMP'+ANOWORK+STRZERO(aNUMEMP[W],3))
   MUDADBF()
NEXT X
// Voltar diretorio Principal
// DIRCHANGE(PATWORK)
HB_CWD(PATWORK)

//CRIAR DBF NAO EXISTENTES
RESTSCREEN(00,00,03,79,SCR_FOY8)
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: MUDADBF()
*!
*!    Chamado por: FOY8.PRG
*!
*!               : CLSCOR()           (fun‡„o    em ?)
*!
*!*****************************************************************************
FUNC MUDADBF
MATDBF=FILENAMES("*.DBF")
nARQ=LEN(MATDBF)
IF nARQ>0
   FOR X=1 TO nARQ
      cARQDIC=PATWORK+"\"+TIRAEXT(MATDBF[X],'DBE')
      IF file(cARQDIC)
         MDT("Atualizando arquivo "+MATDBF[X])
         CLSCOR()
         MAKEDBF(cARQDIC)
      ENDIF
   NEXT X
ENDIF
RETU .T.

