*:*****************************************************************************
*:
*:       FO7F.PRG: Exibir Via Video
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/07/94     15:21
*:
*:    Chamado por: FO77               (processo  em FO7.PRG)
*:
*:          Chama: SALHM()            (fun‡„o    em FOLPROC.PRG)
*:
*:
*:     Documentado 05/13/94 em 14:53                DISK!  vers„o 5.01
*:*****************************************************************************



STORE 0 TO QTFUN,SALTOT
CTLIN = 9

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

DBGOTOP()
@ 04,00 SAY "+------------------------------------------------------------------------------+"
@ 05,00 SAY "Ý Cadastro de Funcion rios."+SPAC(52)+"Ý"
@ 06,00 SAY "Ý------------------------------------------------------------------------------Ý"
@ 07,00 SAY "Ý Reg.  Ý Nome."+SPAC(26)+"Ý Admiss„o  Ý  Sal rio ao mˆs:        Ý"
@ 08,00 SAY "Ý-------+--------------------------------+-----------+-------------------------Ý"
FOR X=9 TO 21
   @ X,00 SAY "Ý       Ý"+SPAC(32)+"Ý           Ý                         Ý"
NEXT X
@ 22,00 SAY "Ý----------------------------------------+-------------------------------------Ý"
@ 23,00 SAY "Ý        --"+CHR(16)+" Cadastros Ý                 Ý Total --"+CHR(16)+""+SPAC(27)+"Ý"
@ 24,00 SAY "+------------------------------------------------------------------------------+"
WHILE ! EOF()
   IF CTLIN > 21
      @ 23,03 SAY QTFUN PICT '####'
      @ 23,56 SAY SALTOT PICTURE '###,###,###.##'
      INKEY(0)
      IF LASTKEY()=27
         DBCLOSEALL()
         RETU
      ENDIF
      @ 9,0 CLEAR TO 21,79
      CTLIN = 9
      FOR X=9 TO 21
         @ X,00 SAY "Ý       Ý"+SPAC(32)+"Ý           Ý                         Ý"
      NEXT
   ENDIF
   @ CTLIN,2 SAY NUMERO
   @ CTLIN,10 SAY NOME
   @ CTLIN,43 SAY ADMITIDO
   STORE 0 TO SALM,SALH,VAR1
   SALHM()
   @ CTLIN,56 SAY SALM PICT '###,###,###,###.##'
   SALTOT=SALTOT+SALM
   QTFUN++
   CTLIN++
   DBSKIP()
ENDDO
@ 23,03 SAY QTFUN PICT '####'
@ 23,56 SAY SALTOT PICT '###,###,###,###.##'
INKEY(0)
DBCLOSEALL()
RETU
*: FIM: FO7F.PRG
