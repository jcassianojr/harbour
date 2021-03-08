*:*****************************************************************************
*:
*:   M_A70.PRG   : Cancelamento de Notas Fiscais Faturadas
*:   Linguagem   : Clipper 5.x
*:        Sistema: ITAESBRA (Mana5)
*:      Copyright (c) 1994 by Disk Softwares S/C Ltda.
*:
*:*****************************************************************************

//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

function m_a70
PARA NFNumero,lRETORNO,aARQ
IF VALTYPE(aARQ)#"A"
   aARQ:={MM01,MM02,MM06,MN01,MO02}
ENDIF


//Modo de Trabalho no Video
MDI(" Ý Cancelamento de Notas Fiscal/Retorno Saldo OS ")
IF VALTYPE(NFNumero)#"N"
   NFNumero:=0
   MDS("Digite o Numero da Nota Fiscal")
   @ 24,40 GET NFNumero PICT "99999999"
   READCUR()
ENDIF
IF aARQ[1]<>"MM01"
   lRETORNO:=.F. //So Retorna Mes Corrente
ENDIF
IF VALTYPE(lRETORNO)#"L"
   lRETORNO:=MDG("Retornar Saldo de OS")
ENDIF
IF lRETORNO
   IF ! USEMULT({{"MM02",1,4},{"MO02",1,4}})
       RETU .F.
   ENDIF
   DBSELECTAR("MM02")
   DBGOTOP()
   DBSEEK(NFNumero)
   WHILE NFNumero=NUMERO.AND.! EOF()
      mOS  :=OS
      mQTDE:=QTDE
      mDEV :=DEV
      IF mOS>0
         DBSELECTAR("MO02")
         DBGOTOP()
         IF DBSEEK(mOS)
            netreclock()
            FIELD -> QTDEENT := QTDEENT-mQTDE
            FIELD -> QTDESAL := QTDEPED-QTDEENT
            FIELD -> VALORMER:= QTDESAL*VALOR
            IF TIPOSERV='3' .OR. TIPOSERV='4'
               FIELD->TOTSDEV:=TOTSDEV-mDEV
            ENDIF
            DBUNLOCK()
         ENDIF
      ENDIF
      DBSELECTAR("MM02")
      DBSKIP()
   ENDDO
   DBCLOSEALL()
ENDIF
PADDEL( aARQ[1], NFNUMERO       ,"NUMERO","NFNUMERO")   //Cab
PADDEL( aARQ[2], STR(NFNUMERO,8),"NUMERO","NFNUMERO")   //Itens
PADDEL( aARQ[3], STR(NFNUMERO,8),"ORDEM" ,"NFNUMERO")   //Dipi
PADDEL( aARQ[4], STR(NFNUMERO,8),"NUMERO","NFNUMERO",4) //Contas
RETU .T.
