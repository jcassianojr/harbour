*:*****************************************************************************
*:
*:       FO1X.PRG: Transfere Folha Entre Firma com Convers„o
*:      Linguagem: ClipSr 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/07/94     14:46
*:
*:  Procs & Fncts: FO1X()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:               : OBTER()            (fun‡„o    em FOLPROC.PRG)
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "BOX.CH"

// Variaveis de Trabalho
nFIRORI=NREMP
nFIRDES=NREMP+1
nCONV=0.000000
tCONV="D"

// Desenha a Tela
CABEX("Transferir Folha entre Firmas")
HB_DISPBOX(7,0,23,79,B_DOUBLE+" ")
@ 10, 6 SAY "Firma de Origem"+SPAC(6)+":"
@ 12, 6 SAY "Firma Destino"+SPAC(8)+":"
@ 14, 6 SAY "Fator de Convers„o   :"
@ 16, 6 SAY "Multiplicar Dividir  :"

// Get nas Menvars
@ 10, 31 GET nFIRORI PICT "9999"
@ 12, 31 GET nFIRDES PICT "9999"
@ 14, 31 GET nCONV   PICT "999,999,999.999999"
@ 16, 31 GET tCONV   PICT "!" VALID tCONV $ "MD"
IF ! READCUR()
   RETU
ENDIF
nCONV=IF(nCONV=0,1,nCONV)

// Confirma‡„o de continua‡„o
@ 17,31 SAY OBTER("FIRMA",,nFIRORI,"COGNOME")
@ 19,31 SAY OBTER("FIRMA",,nFIRDES,"COGNOME")
IF ! MDG("Tudo OK pode-se Continuar")
   RETU
ENDIF
IF ! MDG("Deseja iniciar a convers„o")
   RETU
ENDIF

cPATHORI=HB_CWD()+'EMP'+STRZERO(nFIRORI,5)+"\"
cPATHDES=HB_CWD()+'EMP'+STRZERO(nFIRDES,5)+"\"


IF NRSEN <> 'DiReT'
   FOLORI = 'FP'+STRZERO(nFIRORI,4)+ARQMES
   FOLDES = 'FP'+STRZERO(nFIRDES,4)+ARQMES
ELSE
   FOLORI = 'SO'+STRZERO(nFIRORI,4)+ARQMES
   FOLDES = 'SO'+STRZERO(nFIRDES,4)+ARQMES
ENDIF

IF MDG("Deseja transferir Arquivos da Folha")
   INFOR(cPATHDES+FOLDES,"CONTROLE",cPATHDES+FOLDES,.T.)
   IF MDG("Deseja Apagar Arquivo da Folha Antes de Transferir")
      MDS("Apagando a Folha de Destino")
      netzap(cPATHDES+FOLDES)
   ENDIF

   MDS("Atualizando folha de destino")
   ATUALIZA(cPATHORI+FOLORI,"CONTROLE",cPATHDES+FOLDES)

   MDS("Convertendo Folha de Destino")
   IF ! netuse(cPATHDES+FOLDES) //AREDE(cPATHDES+FOLDES,cPATHDES+FOLDES,0)
      RETU
   ENDIF
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   IF tCONV="D"
      DBEVAL({ || netgrvcam("VALOR",VALOR/nCONV) } ,, {|| zei_fort(nLASTREC,,,1)})
   ELSE
      DBEVAL({ || netgrvcam("VALOR",VALOR*nCONV) } ,, {|| zei_fort(nLASTREC,,,1)})
   ENDIF
   DBCLOSEALL()
ENDIF

IF MDG("Deseja Transferir Cadastro de Funcionarios")
   IF MDG("Deseja Apagar Arquivo Funcionarios Antes de Transferir")
      MDS("Apagando Cadastro de Funcionarios")
      netzap(cPATHDES+PES)
   ENDIF
   MDS("Atualizando Cadastro de Funcion rios")
   ATUALIZA(cPATHORI+PES,"NUMERO",cPATHDES+PES,cPATHDES+PES)
   MDS("Convertendo Salario de Destino")
   if ! netuse(cPATHDES+PES)
      RETU
   ENDIF
   xSAL="SAL"+SUBSTR(MMES,1,3)
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   IF tCONV="D"
      DBEVAL({ || netgrvcam(xSAL,&xSAL./nCONV) } ,, {|| zei_fort(nLASTREC,,,1)})
   ELSE
      DBEVAL({ || netgrvcam(xSAL,&xSAL.*nCONV) } ,, {|| zei_fort(nLASTREC,,,1)})
   ENDIF
   DBCLOSEALL()
ENDIF
RETU .T.
*: FIM: FO1X.PRG
