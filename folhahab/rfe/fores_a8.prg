*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_a8.prg
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
*+    Documentado em 27-Dez-2024 as  9:41 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :    FORES_A8 .PRG:
// :      Linguagem: Clipper 5.x
// :        Sistema:
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 05/02/94     17:15
// :
// :  Procs & Fncts: FORESA8
// :
// :*****************************************************************************

IF !MDG("Deseja Excluir Lan‡amentos de Demitidos do Ano Anterior")
   RETU .T.
ENDIF
FORESA8("FO_PFE","FO_PFE")
FORESA8("FO_RSS","FO_RSS")
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FORESA8()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC FORESA8(cARQ,cIND)

IF !NETUSE(PES)   //AREDE(PES,PES,0)
   RETU .T.
ENDIF
IF !NETUSE(cARQ)  //AREDE(cARQ,cIND,0)
   RETU .T.
ENDIF]
cSELE2 := ALIAS()
DBGOTOP()
WHILE !EOF()
   mNUMERO := NUMERO
   dbselectar(pes)
   DBGOTOP()
   DBSEEK(mNUMERO)
   ACHADO := FOUND()  //usa found softseek para loop
   DBSELECTAR(cSELE2)
   WHILE mNUMERO = NUMERO
      IF !ACHADO
         netrecdel()
      ENDIF
      DBSKIP()
   ENDDO
ENDDO
DBCLOSEALL()
RETU .T.




*+ EOF: fores_a8.prg
*+
