*:*****************************************************************************
*:
*:   FOLIS_CC.PRG: Listar Rais Checagem Funcionarios
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"
IF ! MDL('Listar RAIS Checagem Empregados',0)
   RETU .F.
ENDIF
CTLIN:=80


if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
FILTRO=''
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

IF ! NETUSE("FORAIS") 
   DBCLOSEALL()
   RETU .F.
ENDIF

IMPRESSORA()
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   mNUMERO:=NUMERO
   mNOME:=NOME
   mDEMITIDO:=DEMITIDO
   FOLISCC01(PIS,"PIS")
   FOLISCC01( IF(left(TIRAOUT(CPF),7)=PROFIS,LEFT(TIRAOUT(CPF),7),PROFIS) ,"Numero Profissional" ) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
   FOLISCC01( IF(left(TIRAOUT(CPF),7)=PROFIS,SUBSTR(TIRAOUT(CPF),8),SERIE),"Serie Profissional")
   FOLISCC01(NASC,"Data Nascimento")
   FOLISCC01(ADMITIDO,"Data Admissao")   
   //FOLISCC01(CBONEW,"Numero CBO Novo")
   FOLISCC01(ESCRAIS,"Escolaridade")
   FOLISCC01(NASCPAIS,"Nacionalidade")
   IF NASCPAIS<>"1058"
      FOLISCC01(ANONASCI,"Ano Chegada")
   ENDIF
   FOLISCC01(RACS,"Codigo Etnia-Esocial")
   IF ! EMPTY(mDEMITIDO)
      cVAR:="RAIZ"+LEFT(CMES(mDEMITIDO),3)
      DBSELECTAR("FORAIS")
      DBGOTOP()
      IF DBSEEK(str(nanouso)+str(mNUMERO,8))
         IF ! foliscc01(&Cvar.,"Saldo Salario Rescisao")
            @ CTLIN,70 SAY mDEMITIDO
         ENDIF
         IF ! foliscc01(RAIZFER,"Ferias Indenizadas")
            @ CTLIN,70 SAY mDEMITIDO
         ENDIF
         IF ! foliscc01(RAIZMUL,"Multa FGTS")
            @ CTLIN,70 SAY mDEMITIDO
         ENDIF
         IF ! foliscc01(RAIZAVI,"Aviso Previo")
            @ CTLIN,70 SAY mDEMITIDO
         ENDIF
      ENDIF
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETU .T.

FUNC FOLISCC01(cVAR,cMES)
IF CTLIN>55
   @ 0,  1 say "RAIS - E M P R E G A D O S  - CHECAGEM" + Replicate("-",47)
   CTLIN:=2
ENDIF
IF EMPTY(cVAR)
   CTLIN++
   @ CTLIN,0 SAY mNUMERO
   @ CTLIN,9 SAY mNOME
   @ CTLIN,40 SAY cMES
   RETU .F.
ENDIF
RETU .T.

