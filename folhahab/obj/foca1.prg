*:*****************************************************************************
*:
*:      FOCA1.PRG: Imprimir Relacao do Vale
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:37
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

function foca1
PARA CC,CD,CB,MSAA,CW
IF ! MDL(MSAA,0)
   RETU
ENDIF
POS1=SPAC(40)
MDS('Digite Cabe‡ario Complementar')
@ 24,35 GET POS1
READCUR()

if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
FILTRO='((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
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


IF ! netuse(fol) 
   DBCLOSEALL()
   RETU
ENDIF

IF CW>1
   IF ! netuse("DEPTO") 
      RETU
   ENDIF
   DO CASE
   CASE CW=2
      FILTRA='SETOR=0.AND.SECAO=0'
      COMPAR='DEP=DEPTO'
   CASE CW=3
      FILTRA='SETOR#0.AND.SECAO=0'
      COMPAR='DEP=DEPTO.AND.SET=SETOR'
   CASE CW=4
      FILTRA='SETOR#0.AND.SECAO#0'
      COMPAR='DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
   ENDCASE
   SET FILTER TO &FILTRA
ENDIF


IMPRESSORA()
IF CW=1
   NOMSETOR=""
   FOCAX(".T.")
ELSE
   DBSELECTAR("DEPTO")
   DBGOTOP()
   WHILE ! EOF()
      NOMSETOR=NOMEC
      DEP=DEPTO
      SET=SETOR
      SEC=SECAO
      FOCAX(COMPAR)
      DBSELECTAR("DEPTO")
      DBSKIP()
   ENDDO
ENDIF
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: FOCAX()
*!
*!    Chamado por: FOCA1.PRG
*!
*!          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
*!               : SALHM()            (fun‡„o    em FOLPROC.PRG)
*!
*!*****************************************************************************
FUNC FOCAX
PARA COMPARE
TOTALIZA=.F.
CTLIN=80
TOTCRE:=TOTDEB:=TOTBAS:=TOTLIQ:=TOTSAL:=FL:=0
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   IF &COMPARE
      TOTALIZA=.T.
      CTR=NUMERO
      IF CTLIN > 55
         IF CTLIN#80
            @ PROW()+1,0 SAY REPL('-',132)
         ENDIF
         FL++
         @ 1,  0 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
         @ 2, 20 SAY IMPCHR(cIMPTIT)+MSG2
         @ 3, 05 SAY IMPCHR(cIMPTIT)+'RELATORIO DE '+MSAA+' '+MMES+'/'+STRZERO(ANO,4)+' '+NOMSETOR
         @ 5,  0 SAY POS1
         @ 5,100 SAY TIME()
         @ 5,110 SAY DATE()
         @ 5,120 SAY 'FL. '+STRZERO(FL,4)
         @ 6,  0 SAY REPL('-',132)
         @ 7,  0 SAY "DEP  SET SEC Num.  Nome"+SPAC(28)+"Salario"+SPAC(7)+"T Base IRRF"
         @ 7, 84 SAY "Valor Vale"+SPAC(7)+"IRRF+PENSAO"+SPAC(7)+"Liquido"
         @ 8,  0 SAY REPL('-',132)
         CTLIN=9
      ENDIF
      DBSELECTAR(FOL)
      CRE=VALCTA(CTR,CC)
      DEB=VALCTA(CTR,CD)
      BAS=VALCTA(CTR,CB)
      IF CC=41
         CRE+=VALCTA(CTR,997)
         DEB+=VALCTA(CTR,442)
      ENDIF
      LIQ=CRE-DEB
      DBSELECTAR(PES)
      IF LIQ#0
         VAR1:=SALH:=SALM:=0
         SALHM()
         @ CTLIN,  0 SAY DEPTO
         @ CTLIN,  5 SAY SETOR
         @ CTLIN,  9 SAY SECAO
         @ CTLIN, 13 SAY NUMERO
         @ CTLIN, 19 SAY NOME
         @ CTLIN, 51 SAY SALM PICT "######,###.##"
         @ CTLIN, 65 SAY TIPO
         @ CTLIN, 67 SAY BAS  PICT "######,###.##"
         @ CTLIN, 84 SAY CRE PICT "######,###.##"
         @ CTLIN,101 SAY DEB PICT "######,###.##"
         @ CTLIN,119 SAY LIQ PICT "######,###.##"
         TOTBAS+=BAS
         TOTCRE+=CRE
         TOTDEB+=DEB
         TOTSAL+=SALM
         TOTLIQ+=LIQ
         CTLIN++
      ENDIF
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
IF TOTALIZA
   @ PROW()+1,  0 SAY REPL('-',132)
   @ PROW()+1, 48 SAY TOTSAL PICT "#,###,###,###.##"
   @ PROW()  , 64 SAY TOTBAS PICT "#,###,###,###.##"
   @ PROW()  , 81 SAY TOTCRE PICT "#,###,###,###.##"
   @ PROW()  , 98 SAY TOTDEB PICT "#,###,###,###.##"
   @ PROW()  ,116 SAY TOTLIQ PICT "#,###,###,###.##"
   @ PROW()+1,  0 SAY REPL('-',132)
ENDIF
RETU(.T.)
*: FIM: FOCA1.PRG
