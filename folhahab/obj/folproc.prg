*:*****************************************************************************
*:
*:    FOLPROC.PRG: PROCS FOLHA
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 21/07/98
*:
*:*****************************************************************************

#INCLUDE "INKEY.CH"
//#INCLUDE "TECLAS.CH"

*!*****************************************************************************
*!
*!         Funcao: CABEX()
*!
*!*****************************************************************************
function CABEX(TITULO)
@ 2,0 CLEAR
@ 2,0 SAY " н "+TITULO
RETURN .T.

*!*****************************************************************************
*!
*!       INCIDE
*!
*!    Chamado por: GRAVA2()           (funcao    em FOLPROC.PRG)
*!
*!*****************************************************************************
FUNCTION INCIDE
XA:=FATOR
XB:=TIPO
XC:=TRIBUTINPS
XD:=TRIBUTIRR
XE:=TRIB_FGTS
XF:=VALOR
RETURN

*!*****************************************************************************
*!
*!       GRAVA1
*!
*!    Chamado por: GRAVA2()           (funcao    em FOLPROC.PRG)
*!
*!*****************************************************************************
FUNCTION GRAVA1(nVALOR,nHORAS)
IF VALTYPE(nVALOR)#"N"
   nVALOR:=VALE //Grava Indicado ou publica vale
ENDIF
FIELD->VALOR:=nVALOR
IF VALTYPE(nHORAS)="N".AND.nVALOR>0 //nao referencia se valor for zero
   FIELD->HORAS:=nHORAS
ENDIF
FIELD -> VALOR      := VALE
FIELD -> FATOR      := XA
FIELD -> TIPO       := XB
FIELD -> TRIBUTINPS := XC
FIELD -> TRIBUTIRR  := XD
FIELD -> TRIB_FGTS  := XE
FIELD -> VALORBASE  := XF
RETURN

*!*****************************************************************************
*!
*!      GRAVA
*!
*!    Chamado por: GRAVA2()           (funcao    em FOLPROC.PRG)
*!
*!*****************************************************************************
FUNCTION GRAVA
REPL NUMERO WITH CTR,CONTA WITH CTR1
REPL CONTROLE WITH CTA
RETURN

*!*****************************************************************************
*!
*!         Funcao: GRAVA2()
*!
*!  CRT    Numero Funcionario (!Publica)
*!  VALOR  Gravar em Valor(!Publica)
*!
*!          Chama: INCIDE             (  em FOLPROC.PRG)
*!               : GRAVA              (  em FOLPROC.PRG)
*!               : GRAVA1             (  em FOLPROC.PRG)
*!
*!*****************************************************************************

*!*****************************************************************************
*!
*!         Fun+"o: GRAVA2()
*!
*!*****************************************************************************
FUNCTION GRAVA2                                         &&USO GRAVACAO DADOS FOLHA
PARA CTR1,nVALOR,nHORAS
LOCAL cALIAS
cALIAS:=ALIAS()
DBSELECTAR("CONTAS")
DBGOTOP()
IF DBSEEK(CTR1)
    XA=FATOR
    XB=TIPO
    XC=TRIBUTINPS
    XD=TRIBUTIRR
    XE=TRIB_FGTS
    XF=VALOR
ENDIF
CTA=(CTR*10000)+CTR1
DBSELECTAR(cALIAS)
DBGOTOP()
IF ! DBSEEK(CTA)
    NETRECAPP()
    FIELD -> NUMERO   := CTR
    FIELD -> CONTA    := CTR1
    FIELD -> CONTROLE := CTA
ELSE 
    NETRECLOCK()    
ENDIF
IF VALTYPE(nVALOR)="N"
   GRAVA1(nVALOR,nHORAS)
ELSE
   GRAVA1(,nHORAS)
ENDIF
DBUNLOCK()
RETURN .T.

*!*****************************************************************************
*!
*!         Funcao: SALMES()
*!
*!*****************************************************************************
FUNCTION SALMES(nMES)
IF VALTYPE(nMES)#"N"
   nMES:=MES
ENDIF
XSAL:="SAL"+SUBSTR(MMES(nMES),1,3)
XSAL:=&XSAL
RETURN XSAL

*!*****************************************************************************
*!
*!       FODZER
*!
*!*****************************************************************************
FUNCTION FODZER
GRAPP=1
GRAPT=LASTREC()
GRAPT('Aguarde Zerando Contas sem Valor e Horas')
PCK=.F.
DBGOTOP()
WHILE ! EOF()
   IF ALLTRIM(ALIAS())="FO_COMP"
      IF HORAS = 0.00 .AND. VALOR = 0.00 .AND. VALORMES1=0 .AND. VALORMES2=0
         netrecdel()
         PCK=.T.
      ENDIF
   ELSE
      IF HORAS = 0.00 .AND. VALOR = 0.00
         netrecdel()
         PCK=.T.
      ENDIF
   ENDIF
   GRAPS()
   DBSKIP()
ENDDO
IF PCK
   PACK
ENDIF
RETURN

*!*****************************************************************************
*!
*!         Funcao: MDL()
*!
*!
*!*****************************************************************************
function MDL(TITULO,nTIP)
IF VALTYPE(nTIP)#"N"
   nTIP:=1
ENDIF
CABEX(TITULO)
@ 18,00 TO 21,79 DOUB
@ 19,03 SAY 'LIGUE A IMPRESSORA !! ,Ajuste o papel'
@ 20,25 SAY 'IMPRESSORA DEFINIDA PARA FORMULARIO => '
@ 20,64 SAY IF(IM1='A','80','132')+' Colunas '
RETURN CHECKIMP(nTIP)

*!*****************************************************************************
*!
*!         Funcao: VALCTA()
*!
*!
*!*****************************************************************************
function VALCTA(NFUNC,NCONT)
BUSCA=(NFUNC*10000)+NCONT
DBGOTOP()
DBSEEK(BUSCA)
IF ! FOUND()
   RETURN 0
ENDIF
RETURN VALOR


*!*****************************************************************************
*!
*!         Funcao: NSHOW1()
*!
*!*****************************************************************************
function NSHOW1
IF EOF()
   hb_keyClear()
   //CLEAR TYPEAHEAD
   NSHOW()
   IF LASTKEY()=13      
	  netrecapp()
      KEYBOARD CHR(13)
   ELSE
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.



*!*****************************************************************************
*!
*!       NSHOW
*!
*!    Chamado por: NSHOW1()           (funcao    em FOLPROC.PRG)
*!
*!*****************************************************************************
FUNCTION NSHOW
SET COLOR TO
@ 8,0 CLEAR
SET COLOR TO +W/BR
@ 9,0 TO 11,79 DOUB
SET COLOR TO N/W
@ 10,1 SAY SPAC(33)+'Arquivo vazio'+SPAC(32)
SET COLOR TO+W/BR
INKEY(0)
SET COLO TO
RETURN


*!*****************************************************************************
*!
*!         Funcao: ACHRET()
*!
*!    Chamado por: FO6.PRG
*!               : FO6E()             (funcao    em FO6.PRG)
*!
*!*****************************************************************************
function ACHRET(nStatus,nElement,nRelative)  && criado apenas para retornar o ponteiro do vetor
**************************************
LOCAL nKEY
IF nStatus==0
   SCROLLBARUPDATE(aSBAR,nElement,Graf)
ENDIF
nKEY:=LASTKEY()
DO CASE
    CASE nkey = K_ENTER ; RETU 1
    CASE nkey = K_ESC  ; RETU 0
    CASE nkey = K_ALT_F10 ; RETU 0
    CASE nkey = K_INS ; RETU 0
    CASE nkey = K_DEL ; RETU 1
    CASE nkey = K_CTRL_ENTER ; RETU 0
    CASE nkey = K_CTRL_F2 ; RETU 0
    CASE nkey = K_CTRL_F3 ; RETU 0
    CASE nkey = K_CTRL_F4 ; RETU 0
    CASE nKEY = K_ALT_F1 ; RETU 1
    CASE nKEY = K_ALT_F2 ; RETU 1
    CASE nKEY = K_ALT_F3 ; RETU 1
    CASE nKEY = K_ALT_F4 ; RETU 1
    CASE nKEY = K_ALT_F5 ; RETU 1
    CASE nKEY = K_ALT_F9 ; RETU 1
    CASE nKEY = K_HOME   ; KEYBOARD CHR(K_CTRL_PGUP) &&HOME VIRA CTRL_PGUP
    CASE nKEY = K_END    ; KEYBOARD CHR(K_CTRL_PGDN) &&END  VIRA CTRL_PGDN
    OTHERWISE               ; RETU 2
ENDCASE
RETU 2


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CABE2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function CABE2( TITULO )                  
setcolor( "N/W" )
@ 02, 25 clear to 02, 80
@ 02, 25 say " н " + TITULO
setcolor( "W/N,N/W" )
@ 03, 00 clear
return .T. 

*: FIM: FOLPROC.PRG
