*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fodins.prg
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
*+    Documentado em 27-Dez-2024 as  9:45 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :     FODINS.PRG: Aguarde atualizando as incidˆncias tribut rias ok !!!!!!
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:52
// :
// :  Procs & Fncts: FODINS()
// :
// :          Chama: INCIDE             (processo  em FOLPROC.PRG)
// :
// :     Arq. Dados: FO_PFE
// :               : FO_RSS
// :               : FO_COMP
// :               : CONTAS
// :
// :         Indice:  CONTA      Por ordem de c¢digo
// :                             CODIGO
// :               :  RSS        CODIGO DE TRABALHO
// :                             CONTROLE
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fodins()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fodins

PARA CC
MDS('Aguarde atualizando as incidˆncias tribut rias ok !!!!!! ')

DO CASE
CASE CC = 1
   IF !NETUSE(FOL)  //AREDE(FOL,FOL,0)
      RETU
   ENDIF
CASE CC = 2
   IF !NETUSE("FO_PFE")   //AREDE("FO_PFE","FO_PFE",0)
      RETU
   ENDIF
CASE CC = 3
   IF !NETUSE("FO_RSS")   //AREDE("FO_RSS","FO_RSS",0)
      RETU
   ENDIF
CASE CC = 4
   c13 := PEG13()
   IF !NETUSE(c13)  //AREDE(c13,c13,0)
      RETU
   ENDIF
CASE CC = 5
   IF !NETUSE("FO_COMP")  //AREDE("FO_COMP","FO_COMP",0)
      RETU
   ENDIF
ENDCASE
cSELE1 := ALIAS()


IF !NETUSE("CONTAS")  //AREDE("CONTAS","CONTAS",0)
   RETU
ENDIF
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE !EOF()
   CTA := CONTA
   XA  := XB := XF := XC := XD := XE := 1   //nao incide para todos
   DBSELECTAR("CONTAS")
   DBGOTOP()
   IF DBSEEK(CTA)
      INCIDE()
   ENDIF
   DBSELECTAR(cSELE1)
   NETRECLOCK()
   REPL FATOR WITH XA,TIPO WITH XB,TRIBUTINPS WITH XC
   REPL TRIBUTIRR WITH XD,TRIB_FGTS WITH XE,VALORBASE WITH XF
   DBUNLOCK()
   DBSKIP()
ENDDO
DBCLOSEALL()
RETU
// : FIM: FODINS.PRG

*+ EOF: fodins.prg
*+
