////#INCLUDE "COMANDO.CH"
function focb
PARA CC
MDL("Listar Checagem Tributos",0)
IF CC=9.OR.CC=10.OR.CC=6
   ALERTX("N„o disponivel")
   RETU
ENDIF

CTLIN:=80
aCONTA:={}
aTRIB:={}
MDS("Checando Configura‡„o da Conta")
IF ! ARQCTA(CC,1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
WHILE ! EOF()
   AADD(aCONTA,CODIGO)
   AADD(aTRIB ,{TRIBUTIRR,TRIBUTINPS,TRIB_FGTS,GUIA_IAPAS})
   DBSKIP()
ENDDO
DBCLOSEAREA()

IF ! ARQUSAR(CC,1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
IMPRESSORA()
DBSELECTAR(FOL)
DBGOTOP()
WHILE ! EOF()
   mNUMERO:=NUMERO
   aVAL:={0,0,0,0}
   lFUN:=.T.
   WHILE mNUMERO=NUMERO.AND.! EOF()
      IF CTLIN>50
         @ 0,0 SAY "Checagem de Tributa‡„o"
         @ 1,0 SAY "Cod."
         @ 1,5 SAY "Valor"
         @ 1,20 SAY "IRRF"
         @ 1,35 SAY "INSS"
         @ 1,50 SAY "FGTS"
         @ 1,65 SAY "G.INSS"
         @ 2,00 SAY REPL("=",80)
         CTLIN:=4
      ENDIF
      IF lFUN
         @ CTLIN,0 SAY "Numero: "+STR(NUMERO,8)
         CTLIN++
         @ CTLIN,0 SAY REPL("-",80)
         CTLIN++
         lFUN:=.F.
      ENDIF
      @ CTLIN,0 SAY CONTA
      @ CTLIN,5 SAY VALOR
      nINSS:=nFGTS:=nIRRF:=nGUIA:=99
      nPOS:=ASCAN(aCONTA,CONTA)
      IF nPOS>0
         nIRRF:=aTRIB[nPOS][1]
         nINSS:=aTRIB[nPOS][2]
         nFGTS:=aTRIB[nPOS][3]
         nGUIA:=aTRIB[nPOS][4]
      ENDIF
      DO CASE
         CASE TRIBUTIRR=0 ;  @ CTLIN,20 SAY "Sim"    ; aVAL[1]+=VALOR
         CASE TRIBUTIRR=1 ;  @ CTLIN,20 SAY "N„o"
         CASE TRIBUTIRR=2 ;  @ CTLIN,20 SAY "Deduz"  ; aVAL[1]-=VALOR
         OTHERWISE        ;  @ CTLIN,20 SAY "Erro"
      ENDCASE
      DO CASE
         CASE nIRRF=0 ;  @ CTLIN,25 SAY "/Sim"
         CASE nIRRF=1 ;  @ CTLIN,25 SAY "/N„o"
         CASE nIRRF=2 ;  @ CTLIN,25 SAY "/Deduz"
         OTHERWISE    ;  @ CTLIN,25 SAY "/Erro"
      ENDCASE
      DO CASE
         CASE TRIBUTINPS=0 ;  @ CTLIN,35 SAY "Sim"    ; aVAL[2]+=VALOR
         CASE TRIBUTINPS=1 ;  @ CTLIN,35 SAY "N„o"
         CASE TRIBUTINPS=2 ;  @ CTLIN,35 SAY "Deduz"  ; aVAL[2]-=VALOR
         OTHERWISE         ;  @ CTLIN,35 SAY "Erro"
      ENDCASE
      DO CASE
         CASE nINSS=0 ;  @ CTLIN,40 SAY "/Sim"
         CASE nINSS=1 ;  @ CTLIN,40 SAY "/N„o"
         CASE nINSS=2 ;  @ CTLIN,40 SAY "/Deduz"
         OTHERWISE    ;  @ CTLIN,40 SAY "/Erro"
      ENDCASE
      DO CASE
         CASE TRIB_FGTS=0 ;  @ CTLIN,50 SAY "Sim"   ; aVAL[3]+=VALOR
         CASE TRIB_FGTS=1 ;  @ CTLIN,50 SAY "N„o"
         CASE TRIB_FGTS=2 ;  @ CTLIN,50 SAY "Deduz" ; aVAL[3]-=VALOR
         OTHERWISE        ;  @ CTLIN,50 SAY "Erro"
      ENDCASE
      DO CASE
         CASE nFGTS=0 ;  @ CTLIN,55 SAY "/Sim"
         CASE nFGTS=1 ;  @ CTLIN,55 SAY "/N„o"
         CASE nFGTS=2 ;  @ CTLIN,55 SAY "/Deduz"
         OTHERWISE    ;  @ CTLIN,55 SAY "/Erro"
      ENDCASE
      DO CASE
         CASE nGUIA=0 ;  @ CTLIN,65 SAY "Sim"              ; aVAL[4]+=VALOR
         CASE nGUIA=1 ;  @ CTLIN,65 SAY "N„o"
         CASE nGUIA=2 ;  @ CTLIN,65 SAY "Deduz Base"       ; aVAL[4]-=VALOR
         CASE nGUIA=3 ;  @ CTLIN,65 SAY "Segurados"
         CASE nGUIA=4 ;  @ CTLIN,65 SAY "Abatimento"
         CASE nGUIA=5 ;  @ CTLIN,65 SAY "Sim/Abatimento"   ; aVAL[4]+=VALOR
         OTHERWISE    ;  @ CTLIN,65 SAY "/Erro"
      ENDCASE
      CTLIN++
      DBSKIP()
   ENDDO
   @ CTLIN,20 SAY aVAL[1]  PICT "@E 9,999,999.99"
   @ CTLIN,35 SAY aVAL[2]  PICT "@E 9,999,999.99"
   @ CTLIN,50 SAY aVAL[3]  PICT "@E 9,999,999.99"
   @ CTLIN,65 SAY aVAL[4]  PICT "@E 9,999,999.99"
   CTLIN++
   @ CTLIN,0 SAY REPL("-",80)
   CTLIN++
ENDDO
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()