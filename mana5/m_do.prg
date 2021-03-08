*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_do.prg
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
// :       Arquivo : M_DO.PRG  Manuten‡„o de Diret¢rios
// :
// :        Sistema: Manager Vers„o 5  Cl-52E,RATM
// :          Autor: Equipe Softec Sistemas
// :      Copyright (c) 1995, Softec Sistemas S/C Ltda.
// :  Atualizado em: 21/09/95     19:59
// :
// :  Procs & Fncts: GETDIRS()
// :               : FMDO()
// :
// :          Chama: MDI()              (fun‡„o em ?)
// :               : MDG()              (fun‡„o em ?)
// :               : COR()              (fun‡„o em ?)
// :               : DISKNAME()         (fun‡„o em CA-TOOLS)
// :               : MDS()              (fun‡„o em ?)
// :               : GETDIRS()          (fun‡„o em M_DO.PRG)
// :               : NOBREAK()          (fun‡„o em ?)
// :               : SCROLLBARNEW()     (fun‡„o em ?)
// :               : SCROLLBARDISPLAY() (fun‡„o em ?)
// :               : SCROLLBARUPDATE()  (fun‡„o em ?)
// :               : CABVID()           (fun‡„o em ?)
// :               : ACHMOU()           (fun‡„o em ?, chamado no Achoice())
// :               : MANLISTA()         (fun‡„o em ?)
// :               : FMDO()             (fun‡„o em M_DO.PRG)
// :               : READCUR()          (fun‡„o em ?)
// :               : HOTINKEY()         (fun‡„o em ?)
// :
// :     Documentado 21/09/95 at 20:02                SNAP!  vers„o 5.02
// :*****************************************************************************


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_do()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_do

PARA wcMDO

//Teclas Operacionais
//#INCLUDE "TECLASM.CH"
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI(" Ý Manuten‡„o de Diret¢rios ")

//Configura‡„o de Trabalho
cVIDE := IF(mdg("Deseja Ver no V¡deo"),'S','N')

//Pegando Cores de Trabalho
CORMDO := CORARR("MDO")


//CRIANDO MATRIZES E VARIAVEIS
IF wcMDO = 0
   aMDO1 := {}  //Matriz com os dizeres do Achoice
   aMDO2 := {}  //Matriz com os caminhos
ENDIF
mDRIVE   := DISKNAME()+':'
mCAMINHO := SPACE(80)


//Incializando a ajuda on Line
PRIV HELPDBF := "MDO"

//Carregando Matriz
IF cVIDE = "S" .AND. LEN(aMDO1) = 0
   MDS('Aguarde lendo arvore de diret¢rio')
   aMDO1 := {}
   AADD(aMDO1,"\")
   COUNTER := 0
   WHILE ++ COUNTER <= LEN(aMDO1)
      LOOK := GETDIRS(aMDO1[COUNTER])
      IF !EMPTY(LEN(LOOK))
         AEVAL(LOOK,{| X | AADD(aMDO1,X)})
      ENDIF
   ENDDO
   ASORT(aMDO1)
   aMDO2 := ACLONE(aMDO1)
   nFIM  := LEN(aMDO1)
   FOR X := 1 TO nFIM
      aMDO1[ X ] := mDRIVE+aMDO1[X]
   NEXT
ENDIF


//Posi‡„o Inicial do Ponteiro
pMDO := ASCAN(aMDO2,HB_CWD())
pMDO := IF(pMDO = 0,1,pMDO)

//Processando o M‚todo Escolhido
IF cVIDE = 'S'
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR := LEN(aMDO1)
   aSBAR := ScrollBarNew(04,79,23,SUBSTR(CORMDO[1],RAT(",",CORMDO[1])+1),pMDO)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pMDO,nSBAR,.T.)
   WHILE .T.
      cCBAS := PADC("Diret¢rio: "+HB_CWD(),78)
      CABVID(CORMDO[1],pMDO)
      nKEY := 0
      KEYBOARD CHR(255)
      bELE  := {| X | aMDO1[X]}
      cCOR  := CORMDO[1]
      pMDO2 := ACHOICE(05,01,22,78,aMDO1,,"ACHMOU",pMDO)
      pMDO  := IF(pMDO2 # 0,pMDO2,pMDO)
      pMDO2 := pMDO
      DO CASE
         CASE LASTKEY() = K_ESC
            IF mdg('Encerrar Consulta')
               EXIT
            ENDIF
            LOOP
         CASE LASTKEY() = K_ALT_F10 
            MDS('Imprimindo') 
            MANLISTA()
         CASE LASTKEY() = K_INS
            MDS('Incluindo ') 
            fMDO(1,pMDO)
         CASE LASTKEY() = K_ENTER
            MDS('Alterando ') 
            fMDO(2,pMDO)
         CASE LASTKEY() = K_DEL 
            MDS('Excluindo ') 
            fMDO(3,pMDO)
         CASE LASTKEY() = K_CTRL_ENTER  // CTRL+ENTER USO O aMDO1
            MDS('Digite Caminho : ')
            @ 24,40 GET mCAMINHO PICT "@S35"        
            READCUR()
            @ 24,00
            pMDO := ASCAN(aMDO2,TRIM(mCAMINHO))
            IF pMDO = 0
               ALERTX('Nao localizei o Diretorio Correspondente ....')
               pMDO := pMDO2
               LOOP
            ENDIF
         OTHERWISE 
            LOOP
      ENDCASE
   ENDDO
ENDIF
IF cVIDE = 'N'
   // * ENTRADA SEM VER O BROWSE DOS REGISTROS
   WHILE .T.
      SETCOLOR(CORMDO[1])
      @ 23,00 SAY PADC(HB_CWD(),80)                                 
      @ 24,0  SAY "INS=Novo DEL=Apag ENT=Muda CTR+ENT=Busca ALT+F10=Lista"         
      KEY := HOTINKEY(0)
      DO CASE
         CASE KEY = K_INS 
            fMDO(1,0)
         CASE KEY = K_ENTER 
            fMDO(2,0)
         CASE KEY = K_DEL 
            fMDO(3,0)
         CASE KEY = K_ALT_F10 
            MANLISTA()
         CASE KEY = K_ESC 
            EXIT
         OTHERWISE 
            LOOP
      ENDCASE
   ENDDO
ENDIF
RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: FMDO()
// !
// !    Chamado por: M_DO.PRG
// !
// !          Chama: MDS()              (function  in ?)
// !               : READCUR()          (function  in ?)
// !               : DIRCHANGE()        (function  in CA-TOOLS)
// !               : DIRREMOVE()        (function  in CA-TOOLS)
// !               : DIRMAKE()          (function  in CA-TOOLS)
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fMDO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC fMDO(OPRMDO,POSMDO)  //INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

SETCOLOR(CORMDO[2])
//Pegar a Chave de Busca
IF OPRMDO # 1
   IF cVIDE = 'S'
      mCAMINHO := aMDO2[POSMDO]
   ENDIF
   IF cVIDE = 'N'
      MDS('Digite Caminho ?')
      @ 24,40 get mCAMINHO PICT "@S35"        
      READCUR()
   ENDIF
ENDIF


//Mudando Diretorio
IF OPRMDO = 2
   mCHAVE := TRIM(mCAMINHO)
   mCHAVE := SUBSTR(mCHAVE,1,LEN(mCHAVE) - 1)
   HB_CWD(mCHAVE)
   // DIRCHANGE(mCHAVE)
   RETU .T.
ENDIF

//Opera‡„o de Exclus„o
IF OPRMDO = 3
   IF cVIDE = "S"
      aMDO1[POSMDO] = ALLTRIM(aMDO1[POSMDO])+' - Registro Excluido / Apagado / Deletado'
   ENDIF
   DIRREMOVE(TRIM(mCAMINHO))
   RETU .T.
ENDIF

//Opera‡„o de Inclus„o
IF OPRMDO = 1
   MDS('Digite Caminho: ')
   @ 24,40 GET mCAMINHO PICT "@S35"        
   READCUR()
   DIRMAKE(ALLTRIM(mCAMINHO))
ENDIF



//Posiciona o Novo Elemento na Matriz
IF cVIDE = 'S' .AND. OPRMDO = 1
   nSBAR ++
   AADD(aMDO1,NIL)
   AADD(aMDO2,NIL)
   POSMDO := LEN(aMDO1)
   POSW   := 1
   IF POSMDO > 1
      FOR X := 1 TO POSMDO - 1
         mDARE := aMDO2[X]
         IF mCAMINHO <= mDARE
            EXIT
         ENDIF
      NEXT
      POSW := X
   ENDIF
   AINS(aMDO1,POSW)
   AINS(aMDO2,POSW)
   aMDO1[POSW] = mDRIVE+mCAMINHO
   aMDO2[POSW] = mCAMINHO
   pMDO := POSW
ENDIF
RETU .T.


// !*****************************************************************************
// !
// !         Fun‡„o: GETDIRS()
// !
// !    Chamado por: M_DO.PRG
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GETDIRS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC GETDIRS(pattern)

LOCAL ARRAY := {}
AEVAL(DIRECTORY(PATTERN+"*.","D"),{| X | IF(X[5] = "D" .AND. !("." $ X[1]),AADD(ARRAY,PATTERN+X[1]+"\"),"")})
RETU (ARRAY)

