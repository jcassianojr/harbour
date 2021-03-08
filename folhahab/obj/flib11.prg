////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

FUNC ARQUSAR(nARQ,nSHA,nUSO)
LOCAL cARQVT,lINDEX
PRIV cTIPOVT:="F"
IF VALTYPE(nSHA)#"N"
   nSHA:=0
ENDIF
IF VALTYPE(nARQ)#"N"
   cTELA:=SAVESCREEN( 6,26,16,58)
   CLSBOX(6,26,16,58)
   WHILE .T.
      HB_DISPBOX( 6,26,16,58,B_DOUBLE+" ")
      oPCAO(  8,28 , " &A - Pagamento       ",65)
      oPCAO(  9,28 , " &B - Ferias          ",66)
      oPCAO( 10,28 , " &C - Rescis„o        ",67)
      oPCAO( 11,28 , " &D - 13o.Salario     ",68)
      oPCAO( 12,28 , " &E - Complemento     ",69)
      oPCAO( 13,28 , " &F - Vale Transporte ",70)
      oPCAO( 14,28 , " &G - Folha Semanal   ",71)
      oPCAO( 15,28 , " &H - Folha RPA       ",72)
      nARQ:=MENU(,0)
      IF nARQ>0.AND.nARQ<9
         EXIT
      ENDIF
   ENDDO
   RESTSCREEN( 6,26,16,58,cTELA)
ENDIF
IF nARQ=7.OR.nARQ=8
   mSEMANA:=PEGSEMANA()
   IF mSEMANA=99
      RETU .F.
   ENDIF
ENDIF
IF nARQ=6
   MDS("(P)rograma‡„o (F)olha (A)vulso")
   @ 24,40 GET cTIPOVT PICT "!" VALID cTIPOVT $ "PFA"
   IF ! READCUR()
      RETU .F.
   ENDIF
   DO CASE
      CASE cTIPOVT="F"
           cARQVT:="VTFOLHA"
      CASE cTIPOVT="P"
           cARQVT:="VTFIXO"
      CASE cTIPOVT="A"
           cARQVT:="VTAVUL"
   ENDCASE    
ENDIF
IF VALTYPE(nUSO)#"N"    
   lINDEX=.T.
ELSE
   lINDEX=.F.
ENDIF   
   DO CASE
      CASE nARQ=1
           IF ! NETUSE(FOL,,,,,lINDEX,)  
              RETU .F.
           ENDIF
      CASE nARQ=2
           IF ! NETUSE("FO_PFE",,,,,lINDEX,) 
              RETU .F.
           ENDIF
      CASE nARQ=3
           IF ! NETUSE("FO_RSS",,,,,lINDEX,) 
              RETU .F.
           ENDIF
      CASE nARQ=4
           c13:=PEG13()
           IF ! NETUSE(c13,,,,,lINDEX,) 
              RETU .F.
           ENDIF
      CASE nARQ=5
           IF ! NETUSE("FO_COMP",,,,,lINDEX,) 
              RETU .F.
           ENDIF
      CASE nARQ=6
           IF ! NETUSE(cARQVT,,,,,lINDEX,) 
              RETU .F.
           ENDIF
      CASE nARQ=7
           IF ! NETUSE(SEM,,,,,lINDEX,)
              RETU .F.
           ENDIF
           SET FILTER TO SEMANA=mSEMANA
      CASE nARQ=8
           IF ! NETUSE(RPA,,,,,lINDEX,)
              RETU .F.
           ENDIF
           SET FILTER TO SEMANA=mSEMANA
   ENDCASE
RETU .T.



FUNC ARQCTA(nARQ)
DO CASE
   CASE nARQ=6 //VT
       IF ! NETUSE("VTCONTA") 
          DBCLOSEALL()
          RETU .F.
       ENDIF
   CASE nARQ=8 //RPA
       IF ! NETUSE("CTARPA") 
          DBCLOSEALL()
          RETU .F.
       ENDIF
  OTHERWISE
      IF ! NETUSE("CONTAS") 
         DBCLOSEALL()
         RETU .F.
      ENDIF
ENDCASE
RETU .T.

FUNC ARQPES(nARQ,nSHA,nTIP)
IF VALTYPE(nSHA)#"N"
   nSHA:=1
ENDIF
IF VALTYPE(nTIP)#"N"
   nTIP:=1
ENDIF
DO CASE
   CASE nARQ=8 //RPA
        IF ! NETUSE("MG01",,,,,IF(nTIP=1,.T.,.F.),)   
           DBCLOSEALL()
           RETU .F.
        ENDIF
   OTHERWISE
        IF ! NETUSE(PES,,,,,IF(nTIP=1,.T.,.F.))  
           DBCLOSEALL()
           RETU .F.
        ENDIF
ENDCASE
RETU .T.


FUNC PEGSEMANA
mSEMANA:=0
MDS("Qual Semana/Quinzena Deseja ")
@ 24,40 GET mSEMANA
IF ! READCUR()
   RETU 99
ENDIF
RETU mSEMANA
