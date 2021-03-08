*:*****************************************************************************
*:
*:   RECUAPO2.PRG: C lculo entre datas
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:16
*:
*:  Procs & Fncts: RECUAPO2()
*:               : FOLUTIL3
*:               : FOLUTIL4
*:               : FOLUTIL5
*:
*:          Chama: CABE2()            (fun‡„o    em RECUPROC.PRG)
*:               : FOLUTIL3           (processo  em RECUAPO2.PRG)
*:               : FOLUTIL4           (processo  em RECUAPO2.PRG)
*:               : FOLUTIL5           (processo  em RECUAPO2.PRG)
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************


SETCOLOR("W/N")
@ 08,00 CLEAR
WHILE .T.
   CABE2("Calculo entre datas")
   MD()
   @ 08,21 CLEA TO 13,59
   @ 08,21 TO 13,59 DOUB
   OPCAO( 09,23, ' &A - Dia da semana          ',65,'Mostra o dia da semana de uma data')
   OPCAO( 10,23, ' &B - Diferen‡a de datas     ',66,'Mostra numeros de dias entre datas')
   OPCAO( 11,23, ' &C - Data acrecida de dias  ',67,'Mostra uma data acrescida de dias')
   OPCAO( 12,23, ' &D - Data decrecida de dias ',68,'Mostra uma data decrescida de dias')
   OPMAN:=MENU(,24)
   DO CASE
   CASE OPMAN=1 ; FOLUTIL3()
   CASE OPMAN=2 ; FOLUTIL4()
   CASE OPMAN=3 ; FOLUTIL5(0)
   CASE OPMAN=4 ; FOLUTIL5(1)
   OTHERWISE    ; RETU
   ENDCASE
ENDDO


*!*****************************************************************************
*!
*!      Procedure: FOLUTIL3
*!
*!    Chamado por: RECUAPO2.PRG
*!
*!*****************************************************************************
PROC folutil3
D=DAY(DATE())
M=MONTH(DATE())
A=YEAR(DATE())
MD()
@ 24,3 SAY "Dia: " GET D PICT "99"
@ 24,30 SAY "Mˆs: " GET M PICT "99"
@ 24,57 SAY "Ano: " GET A PICT "9999"
READCUR()
IF M<3
   U=1
   V=13
ELSE
   U=0
   V=1
ENDIF
W=INT(365.25*(A-U))+INT(30.6*(M+V))+D-621049
D1=INT((W/7-INT(W/7))*7+.5)
U=SUBSTR("DOMSEGTERQUAQUISEXSAB",D1*3+1,3)+","+STR(D)+" DE "+SUBSTR("   JANFEVMARABRMAIJUNJULAGOSETOUTNOVDEZ",M*3+1,3)+" DE "+STR(A)
MDT(U)
RETU

*!*****************************************************************************
*!
*!      Procedure: FOLUTIL4
*!
*!    Chamado por: RECUAPO2.PRG
*!
*!*****************************************************************************
PROC folutil4
D1=DATE()
D2=DATE()
MD()
@ 24,03 SAY 'Digite a Data inicial: ' GET D1
READCUR()
MD()
@ 24,03 SAY 'Digite a Data Final  : ' GET D2
READCUR()
MS='Diferen‡a: '+STR(D1-D2)+' dia(s)'
MDT(MS)
RETU

*!*****************************************************************************
*!
*!      Procedure: FOLUTIL5
*!
*!    Chamado por: RECUAPO2.PRG
*!
*!*****************************************************************************
PROC folutil5
PARAMETER CC
D1=DATE()
N1=0
MD()
@ 24,03 SAY 'Digite a Data para calculo: ' GET D1
READCUR()
MD()
@ 24,03 SAY 'Digite o numeros de dias: ' GET N1 PICT "9999"
READCUR()
IF CC=0
   MS='Data resultante: '+DTOC(D1+N1)
ELSE
   MS='Data resultante: '+DTOC(D1-N1)
ENDIF
MDT(MS)
RETU
*: FIM: RECUAPO2.PRG
