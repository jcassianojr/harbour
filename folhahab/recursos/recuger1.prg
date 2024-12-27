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

FUNCTION RECUGER1()
IMPHP()


memvar->AQ=CHR(27)+CHR(71)
memvar->DQ=CHR(27)+CHR(72)
memvar->AE=memvar->cIMPTIT
memvar->AC=memvar->cIMPCOM
memvar->DC=memvar->cIMPEXP
memvar->AI=CHR(27)+CHR(52)
memvar->DI=CHR(27)+CHR(53)
memvar->AN=memvar->cIMPNEG 
memvar->DN=memvar->cIMPNER
memvar->AX=CHR(27)+CHR(83)+CHR(00)
memvar->AD=CHR(27)+CHR(83)+CHR(01)
memvar->DXD=CHR(27)+CHR(84)
memvar->AS=CHR(27)+CHR(45)+CHR(00)
memvar->DS=CHR(27)+CHR(45)+CHR(01)
memvar->AEC=CHR(27)+CHR(87)+CHR(00)
memvar->DEC=CHR(27)+CHR(87)+CHR(01)
memvar->AIE=CHR(27)+CHR(52)+CHR(27)+CHR(87)+CHR(01)
memvar->DIE=CHR(27)+CHR(53)+CHR(27)+CHR(87)+CHR(00)
memvar->AIC=CHR(27)+CHR(91)+CHR(50)+CHR(27)+CHR(52)
memvar->DIC=CHR(27)+CHR(91)+CHR(48)+CHR(27)+CHR(53)
memvar->ACA=CHR(27)+CHR(91)+CHR(50)
memvar->ACB=CHR(27)+CHR(91)+CHR(51)
memvar->ACC=CHR(27)+CHR(91)+CHR(52)
memvar->ACD=CHR(27)+CHR(91)+CHR(53)
memvar->DCE=CHR(27)+CHR(91)+CHR(48)
memvar->ZMES=MMES(MONTH(memvar->ZDATA))
memvar->ZDIA=DTOC(memvar->ZDATA)
memvar->ZANO=STRZERO(YEAR(memvar->ZDATA),4)
memvar->ZRSM=REPL("-",132)
memvar->ZRDM=REPL("=",132)
memvar->ZRSS=REPL("-",80)
memvar->ZRDS=REPL("=",80)


DO WHILE .T.
   SETCOLOR("W/N")
   @ 08,00 CLEA
   cabe2('Gerador de Etiquetas')
   SETCOLOR("W/G")
   @ 08,30 CLEAR TO 11,49
   @ 08,30 TO 11,49 DOUB
   OPCAO(09,32,'    &Simples     ',83)
   OPCAO(10,32,'  &Configurada   ',67)
   memvar->OPCAO:=MENU(,0)
   SETCOLOR("W/N")
   DO CASE
   CASE memvar->OPCAO=1 ; RECUETI1()
   CASE memvar->OPCAO=2 ; RECUETI2()
   OTHERWISE    ; DBCLOSEALL() ; RETURN .T.
   ENDCASE
ENDDO
RETURN .T.

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
memvar->KEY=LASTKEY()
DO CASE
   CASE memvar->MODO<4
      RETU(1)
   CASE memvar->KEY=7
      memvar->COR=SETCOLOR()
      SETCOLOR("W/N")
      IF MDG('Deseja mesmo apagar?')
         NETRECDEL()
         memvar->PCK1=.T.
      ENDIF
      SETCOLOR(memvar->COR)
      RETU(2)
   CASE memvar->KEY=22
      memvar->nALTURA:=0
      memvar->nLARGURA:=0
      memvar->nCOLUNAS:=0
      @ ROW(),51      GET NALTURA  VALID memvar->NALTURA  < 9  .AND. ! EMPTY(memvar->NALTURA)
      @ ROW(),COL()+1 GET NLARGURA VALID memvar->NLARGURA > 4  .AND. ! EMPTY(memvar->NLARGURA)
      @ ROW(),COL()+1 GET NCOLUNAS VALID memvar->NCOLUNAS < 11 .AND. ! EMPTY(memvar->NCOLUNAS)
      READCUR()
      IF memvar->NALTURA=0 .OR. memvar->NLARGURA=0 .OR. memvar->NCOLUNAS=0
         RETU(2)
      ELSE
         NETRECapp()
          FIELD->ALTURA:=memvar->nALTURA
          FIELD->LARGURA:=memvar->nLARGURA
          FIELD->COLUNAS:=memvar->nCOLUNAS
      ENDIF
      RETU(1)
   CASE memvar->KEY=13
      memvar->ALT:=FIELD->ALTURA
      memvar->LAR:=FIELD->LARGURA
      memvar->COL:=FIELD->COLUNAS
      memvar->IMPRIME:=.T.
      RETU(0)
   CASE memvar->KEY=27
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
RETURN .T.
*: FIM: RECUGER1.PRG
