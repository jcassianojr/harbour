#INCLUDE "INKEY.CH"

*!*****************************************************************************
*!
*!         Fun‡„o: CABE2()
*!
*!*****************************************************************************
FUNC CABE2(TITULO)                                   &&CABECARIO PARA OS MENUS
SETCOLOR("N/W")
@ 06,04 CLEA TO 06,74
@ 06,06 SAY TITULO
SETCOLOR("W/N,N/W")
RETU(.T.)

*!*****************************************************************************
*!
*!         Fun‡„o: CABE3()
*!
*!*****************************************************************************
FUNC CABE3(TITULO,QT)                                &&CABECARIO PARA OS MENUS
SETCOLOR("W/N")
@ 04,01 CLEA TO 04,78
@ 06,01 CLEA TO 06,78
@ 08,00 CLEA
SETCOLOR("N/W")
@ 04,04 CLEA TO 04,74
@ 04,04 SAY TITULO
SETCOLOR("+GR/BG")
@ 08,21 CLEA TO QT,58
@ 08,21 TO QT,58 DOUB
RETU(.T.)


*!*****************************************************************************
*!
*!      Procedure: NSHOW
*!
*!    Chamado por: NSHOW1()           (fun‡„o    em RECUPROC.PRG)
*!
*!*****************************************************************************
PROC NSHOW                                   &&AVISA QUE O ARQUIVO ESTA VAZIO
SETCOLOR("W/N")
@ 8,0 CLEAR
SETCOLOR("+W/BR")
@ 9,0 TO 11,79 DOUB
SETCOLOR("N/W")
@ 10,1 SAY SPAC(33)+'Arquivo vazio'+SPAC(32)
SETCOLOR("+W/BR")
INKEY(0)
RETU


*!*****************************************************************************
*!
*!         Fun‡„o: ARQ()
*!
*!    Chamado por: CA()               (fun‡„o    em RECUETI2.PRG, chamado  no Dbedit())
*!
*!*****************************************************************************
FUNC ARQ(NOMEARQ)                        &&VERIFICA A EXISTENCIA DE UM ARQUIVO
IF NOMEARQ = SPAC(25)
   MDT("NOME DO ARQUIVO NAO PODE SER VAZIO")
   RETU(.F.)
ENDIF
NOMEARX=ALLTRIM(NOMEARQ)+'.DBF'
IF ! file(NOMEARX)
   MDT("ESTE ARQUIVO NAO EXISTE - VERIFIQUE !")
   RETU(.F.)
ENDIF
RETU(.T.)



*!*****************************************************************************
*!
*!         Fun‡„o: NSHOW1()
*!
*!    Chamado por: EDITA2             (processo  em RECUETI1.PRG)
*!               : EDITA              (processo  em RECUETI2.PRG)
*!               : RECUSER3.PRG
*!
*!          Chama: NSHOW              (processo  em RECUPROC.PRG)
*!
*!*****************************************************************************
FUNC NSHOW1               &&VERIFICA SE O ARQUIVO ESTA VAZIO ANTES DO DBEDIT
IF EOF()
   //CLEAR TYPEAHEAD
   hb_keyClear()
   NSHOW()
   IF LASTKEY()=13
      NETRECAPP()
      KEYBOARD CHR(22)
   ELSE
      RETU(.F.)
   ENDIF
ENDIF
RETU(.T.)

FUNC MDI(cVAR)
CABE2(cVAR)
RETU .T.
FUNC COR
RETU .T.
FUNC CABEX(cVAR)
CABE2(cVAR)

*: FIM: RECUPROC.PRG

