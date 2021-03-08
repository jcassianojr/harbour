*:*****************************************************************************
*:
*:       FOA8.PRG: Transferir fixos di rios para mensal
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 21/12/98     11:30
*:
*:*****************************************************************************

CABEX('Transferir fixos di rios para mensal')
IF ! MDG ('Deseja continuar)')
   RETU .F.
ENDIF
IF ! MDG("Este procedimento apaga folha Mensal Continuar")
   RETU .F.
ENDIF
lAVUL:=MDG("Importar Folha Avulsa")

netzap("VTFOLHA")

IF ! NETUSE(PES) 
   RETU
ENDIF

IF ! NETUSE("VTFIXO") 
   dbcloseall()
   RETU
ENDIF
IF ! NETUSE("VTFOLHA")
   dbcloseall() 
   RETU
ENDIF

IF ! NETUSE("VTCONTA")
   dbcloseall()  
   RETU
ENDIF

IF ! NETUSE("VTCOMP")
   dbcloseall() 
   RETU
ENDIF

IF ! NETUSE("VTAVUL")
   dbcloseall() 
   RETU
ENDIF

//IF ! AREDEM({{"VTFOLHA","VTFOLHA",0},{"VTFIXO","VTFIXO",1},{"VTCONTA","VTCONTA",1},{"VTCOMP","VTCOMP",1},{PES,PES,1},{"VTAVUL","VTAVUL",1}})
//   RETU .F.
//ENDIF


IF lAVUL
   DBSELECTAR("VTAVUL")
   INITVARS()
   CLRVARS()
   DBGOTOP()
   WHILE ! EOF()
       EQUVARS()
       DBSELECTAR("VTFOLHA")
       netrecapp()
       REPLVARS()
       dbunlock()
       DBSELECTAR("VTAVUL")
       DBSKIP()
   ENDDO
ENDIF

DBSELECTAR(PES)
SET FILTER TO EMPTY(DEMITIDO)

DBSELECTAR("VTFIXO")
DBGOTOP()
WHILE ! EOF()
   mNUMERO:=NUMERO
   PASS:=0
   DBSELECTAR(PES)
   DBGOTOP()
   IF DBSEEK(mNUMERO)
      PASS:=VTDIAS
   ENDIF
   DBSELECTAR("VTFIXO")
   IF PASS>0
      mCONTA :=CONTA
      mCTACOM:=CTACOM
      mQTDE  :=HORAS
      aCONTAS:={}
      aLANCAR:={}
      IF ! EMPTY(mCONTA)
         AADD(aCONTAS,{mCONTA,mQTDE*PASS})
      ENDIF
      IF ! EMPTY(mCTACOM)
         DBSELECTAR("VTCOMP")
         DBGOTOP()
         IF DBSEEK(mCTACOM)
            FOR X=1 TO 10
                cCONTA:="COD"+STRZERO(X,2)
                cQTDE :="QTD"+STRZERO(X,2)
                IF ! EMPTY(&cCONTA)
                   AADD(aCONTAS,{&cCONTA,&cQTDE*mQTDE*PASS})
                ENDIF
            NEXT X
         ENDIF
      ENDIF
      FOR X=1 TO LEN(aCONTAS)
          mCONTA:=aCONTAS[X][1]
          DBSELECTAR("VTCONTA")
          DBGOTOP()
          IF DBSEEK(mCONTA)
             AADD(aLANCAR,{aCONTAS[X][1],aCONTAS[X][2],VALOR})
          ENDIF
      NEXT X
      FOR X=1 TO LEN(aLANCAR)
          DBSELECTAR("VTFOLHA")
          DBGOTOP()
          IF ! DBSEEK(mNUMERO*10000+aLANCAR[X][1])
             netrecapp()
             FIELD->NUMERO:=mNUMERO
             FIELD->CONTA :=aLANCAR[X][1]
             FIELD->CONTROLE:=mNUMERO*10000+aLANCAR[X][1]
          else
             netreclock()   
          ENDIF
          FIELD->HORAS:=HORAS+aLANCAR[X][2] //sOMA pois pode haver composicao
          FIELD->VALOR:=HORAS*aLANCAR[X][3] //de tipos iguais de vt
          dbunlock()
      NEXT X
   ENDIF
   DBSELECTAR("VTFIXO")
   DBSKIP()
ENDDO
DBSELECTAR("VTFOLHA")
FODZER()
DBCLOSEALL()
RETU

FUNC FOA8A
CABEX('Programar Dias')
PASS=0
MDS('Quantos dias de passagens')
@ 24,35 GET PASS PICT '####'
IF ! READCUR()
   RETU .F.
ENDIF
IF EMPTY(PASS)
   ALERTX("Especifique os dias de passagem")
   RETU .F.
ENDIF
IF ! netuse(pes) //AREDE(PES,PES,1)
   RETU
ENDIF
SET FILTER TO EMPTY(DEMITIDO)
DBGOTOP()
WHILE ! EOF()
   netreclock()
   FIELD->VTDIAS:=PASS
   DBUNLOCK()
   DBSKIP()
ENDDO
dbcloseall()
RETU .T.


FUNC FOA8B
CABEX('Ajustar Dias')
PADRAO(PES,PES,"' '+STR(mNUMERO,8)+' '+mNOME+' '+STR(mVTDIAS,3)","mNUMERO","Checagem VT","Codigo Nome"+spac(37)+"Dias",;
       {|| ALLTRUE()},{|| ALLTRUE()},{||gFOA8B()},{|| FO_FOR("GRUPO='VT'")})
RETU .T.

FUNC gFOA8B
MDS("Quantos Dias")
@ 24,40 GET mVTDIAS
READCUR()
RETU .T.

FUNC FOA8C(cARQ,cIND)
CABEX('Folha Mensal VT')
mNUMERO:=0
mCONTA:=0
WHILE .T.
   @ 23,00 SAY "ESC - Funcionario ou Conta em Branco Encerra"
   MDS("Funcionario/Conta")
   @ 24,30 GET mNUMERO PICT "9999999"
   @ 24,40 GET mCONTA  PICT "999"
   IF ! READCUR()
      EXIT
   ENDIF
   IF EMPTY(mNUMERO).OR.EMPTY(mCONTA)
      EXIT
   ENDIF
   mVALOR:=OBTER("VTCONTA",,mCONTA,"VALOR")
   mHORAS:=OBTER(cARQ,,mNUMERO*10000+mCONTA,"HORAS")
   @ 24,50 GET mHORAS PICT "999"
   READCUR()
   WHILE  ! netuse(carq) 
   ENDDO
   DBGOTOP()
   IF ! DBSEEK(mNUMERO*10000+mCONTA)
      netrecapp()
      FIELD->NUMERO:=mNUMERO
      FIELD->CONTA :=mCONTA
      FIELD->CONTROLE:=mNUMERO*10000+mCONTA
   else
      netreclock()   
   ENDIF
   FIELD->HORAS:=mHORAS
   FIELD->VALOR:=HORAS*mVALOR
   dbunlock()
   DBCLOSEALL()
ENDDO
IF ! netuse(carq) //AREDE(cARQ,cIND,0)
   DBCLOSEALL()
   RETU
ENDIF
FODZER()
DBCLOSEAREA()
RETU .T.

*: FIM: FOA8.PRG