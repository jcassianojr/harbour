*:*****************************************************************************
*:
*:   RECUGER1.PRG: ETIQUETA
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:27
*:
*:   & Fncts: RECUGER1()
*:               : CAD1()
*:               : TELATIP
*:
*:          Chama: CABE2()            (fun‡„o    em RECUPROC.PRG)
*:               : RECUETI1()         (fun‡„o    em RECUETI1.PRG)
*:               : RECUETI2()         (fun‡„o    em RECUETI2.PRG)
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************

IMPHP()


AQ=CHR(27)+CHR(71)
DQ=CHR(27)+CHR(72)
AE=cIMPTIT
AC=cIMPCOM
DC=cIMPEXP
AI=CHR(27)+CHR(52)
DI=CHR(27)+CHR(53)
AN=cIMPNEG 
DN=cIMPNER
AX=CHR(27)+CHR(83)+CHR(00)
AD=CHR(27)+CHR(83)+CHR(01)
DXD=CHR(27)+CHR(84)
AS=CHR(27)+CHR(45)+CHR(00)
DS=CHR(27)+CHR(45)+CHR(01)
AEC=CHR(27)+CHR(87)+CHR(00)
DEC=CHR(27)+CHR(87)+CHR(01)
AIE=CHR(27)+CHR(52)+CHR(27)+CHR(87)+CHR(01)
DIE=CHR(27)+CHR(53)+CHR(27)+CHR(87)+CHR(00)
AIC=CHR(27)+CHR(91)+CHR(50)+CHR(27)+CHR(52)
DIC=CHR(27)+CHR(91)+CHR(48)+CHR(27)+CHR(53)
ACA=CHR(27)+CHR(91)+CHR(50)
ACB=CHR(27)+CHR(91)+CHR(51)
ACC=CHR(27)+CHR(91)+CHR(52)
ACD=CHR(27)+CHR(91)+CHR(53)
DCE=CHR(27)+CHR(91)+CHR(48)
ZMES=MMES(MONTH(ZDATA))
ZDIA=DTOC(ZDATA)
ZANO=STRZERO(YEAR(ZDATA),4)
ZRSM=REPL("-",132)
ZRDM=REPL("=",132)
ZRSS=REPL("-",80)
ZRDS=REPL("=",80)


DO WHILE .T.
   SETCOLOR("W/N")
   @ 08,00 CLEA
   cabe2('Gerador de Etiquetas')
   SETCOLOR("W/G")
   @ 08,30 CLEAR TO 11,49
   @ 08,30 TO 11,49 DOUB
   OPCAO(09,32,'    &Simples     ',83)
   OPCAO(10,32,'  &Configurada   ',67)
   OPCAO:=MENU(,0)
   SETCOLOR("W/N")
   DO CASE
   CASE OPCAO=1 ; RECUETI1()
   CASE OPCAO=2 ; RECUETI2()
   OTHERWISE    ; DBCLOSEALL() ; RETU
   ENDCASE
ENDDO
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: CAD1()
*!
*!    Chamado por: CAD()              (fun‡„o    em RECUETI1.PRG, chamado  no Dbedit())
*!               : LISTA              ( em RECUETI2.PRG)
*!
*!*****************************************************************************
FUNC CAD1
PARA MODO
KEY=LASTKEY()
DO CASE
   CASE MODO<4
      RETU(1)
   CASE KEY=7
      COR=SETCOLOR()
      SETCOLOR("W/N")
      IF MDG('Deseja mesmo apagar?')
         NETRECDEL()
         PCK1=.T.
      ENDIF
      SETCOLOR(COR)
      RETU(2)
   CASE KEY=22
      NETRECapp()
      @ ROW(),51      GET ALTURA  VALID ALTURA  < 9  .AND. ! EMPTY(ALTURA)
      @ ROW(),COL()+1 GET LARGURA VALID LARGURA > 4  .AND. ! EMPTY(LARGURA)
      @ ROW(),COL()+1 GET COLUNAS VALID COLUNAS < 11 .AND. ! EMPTY(COLUNAS)
      READCUR()
      IF ALTURA=0 .OR. LARGURA=0 .OR. COLUNAS=0
         NETRECDEL()
         RETU(2)
      ENDIF
      RETU(1)
   CASE KEY=13
      ALT=ALTURA
      LAR=LARGURA
      COL=COLUNAS
      IMPRIME=.T.
      RETU(0)
   CASE KEY=27
      RETU(0)
   ENDCASE
RETU(1)


*!*****************************************************************************
*!
*!       TELATIP
*!
*!    Chamado por: CAD()              (fun‡„o    em RECUETI1.PRG, chamado  no Dbedit())
*!               : LISTA              (  em RECUETI2.PRG)
*!
*!*****************************************************************************
FUNCTION TELATIP
SETCOLOR("W/G")
@ 08,49 CLEAR TO 16,64
@ 08,49 TO 16,64 DOUB
@ 17,49 CLEA TO 21,72
@ 17,49 TO 21,72 DOUB
@ 18,50 SAY "Lin = No. de Linhas   "
@ 19,50 SAY "Col = No. de Colunas  "
@ 20,50 SAY "Car = No. de Carreiras"
@ 08,51 SAY 'Lin'
@ 08,55 SAY 'Col'
@ 08,59 SAY 'Car'
RETURN
*: FIM: RECUGER1.PRG
