*:*****************************************************************************
*:
*:    RECUETI1.PRG: Programa de Edi‡„o e Emiss„o de Etiquetas Simples
*:       Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:26
*:
*:   & Fncts: RECUETI1()
*:               : EDITA2
*:               : CAD()
*:
*:          Chama: EDITA2             (  em RECUETI1.PRG)
*:
*:     Arq. Dados: ETIQ1 - ETIQUETA SIMPLES
*:               : ETIQ2 - LAYOUT DE TAMANHO DE ETIQUETA
*:
*:         Indice:  ETIQ1      CODIGO DA ETIQUETA
*:                             CODIGO
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************

FUNCTION RECUETI1()
DO WHILE .T.
   @ 13,00 CLEAR
   SETCOLOR("W/G")
   @ 13,27 CLEAR TO 15,51
   @ 13,27 TO 15,51 DOUB
   OPCAO(14,29,' &Imprimir ',73)
   OPCAO(14,39,' &Editar   ',69)
   OPCAO1:=MENU(,0)
   SETCOLOR("W/N")
   IF OPCAO1=0
      EXIT
   ENDIF
   TIPOOPER='E'
   IF OPCAO1=1
      TIPOOPER='I'
   ENDIF
   SAVE SCREEN TO TELA_1
   EDITA2()
   REST SCREEN FROM TELA_1
ENDDO
RETURN

*!*****************************************************************************
*!
*!       EDITA2
*!
*!    Chamado por: RECUETI1.PRG
*!
*!          Chama: NSHOW1()           (fun‡„o    em RECUPROC.PRG)
*!               : CAD()              (fun‡„o    em RECUETI1.PRG, chamado  no Dbedit())
*!
*!*****************************************************************************
FUNCTION EDITA2
@ 08,00 CLEAR
IMPRIME=.F.
PES1=SPAC(12)
IF ! netuse("ETIQ2") //BREDE("ETIQ2",0)
   RETU
ENDIF
IF ! netuse("ETIQ1") //AREDE ("ETIQ1","ETIQ1",0)
   dbselectar("ETIQ2")
   dbclosearea() 
   RETU
ENDIF
DECLARE CAMPO[1]
CAMPO[1]="' '+CODIGO+' '+DESCRICAO+' '+SELECAO+' '"
DBGOTOP()
IF ! NSHOW1()
   RETU
ENDIF
@ 08,00 CLEA
SETCOLOR("W/G")
@ 08,00 CLEAR
@ 08,00 TO 21,45 DOUB
@ 08,03 SAY 'C¢digo   '
@ 08,12 SAY 'Descri‡ao'
PCK = .F.
DBEDIT(09,02,20,43,CAMPO,"CAD",.T.,"","","","","")
SETCOLOR("W/N")
SETCURSOR(1)
RETU

*!*****************************************************************************
*!
*!         Fun‡„o: CAD()
*!
*!    Chamado por: EDITA2             (  em RECUETI1.PRG)
*!
*!          Chama: TELATIP            (  em RECUGER1.PRG)
*!               : CAD1()             (fun‡„o    em RECUGER1.PRG, chamado  no Dbedit())
*!
*!*****************************************************************************
FUNC CAD
************
PARA MODO
PRIV COR
KEY=LASTKEY()
DO CASE
CASE MODO<4
   RETU(1)
CASE KEY=7.AND.TIPOOPER='E'
   SETCURSOR(1)
   DELEREC()
   SETCURSOR(0)
   RETU(2)
CASE KEY=10
   MDS('Digite o c¢digo:')
   @ 23,40 GET PES1
   READCUR()
   IF LASTKEY()<>27
      REC=RECNO()
      DBGOTOP()
      DBSEEK(PES1)
      IF ! FOUND()
         MDT('Nao encontrado')
         GO REC
      ENDIF
   ENDIF
   RETU(1)
CASE (KEY=13 .OR. KEY=22).AND.TIPOOPER='E'
   IF KEY=22
      NETRECAPP()
      @ ROW()+1,3 GET CODIGO
   ENDIF
   IF KEY=13
      @ ROW(),3 GET CODIGO
   ENDIF
   @ ROW(),COL()+1 GET DESCRICAO
   READCUR()
   ** ALTERADO EM 6/8/92
   IF LASTKEY() = 27 .AND. KEY = 13
      CLEA GETS
      RETU(2)
   ENDIF
   IF LASTKEY() = 27 .AND. KEY = 22
      IF CODIGO=SPAC(8) .OR. DESCRICAO=SPAC(30)
         NETRECDEL()
         RETU(2)
      ENDIF
   ENDIF
   KEYBOARD CHR(84)
CASE (KEY=13).AND.TIPOOPER='I'
   DECLARE CAMPO1[1]
   DBSELECTAR("ETIQ2")
   CAMPO1[1]="' '+STR(ALTURA)+' '+STR(LARGURA)+' '+STR(COLUNAS)+' '"
   DBGOTOP()
   IF EOF()
      KEYB CHR(22)
   ENDIF
   TELA=SAVESCREEN(08,49,21,64)
   TELATIP()
   ALT=0 && numero de linhas / Lin
   LAR=0 && numero de colunas / Col
   COL=0 && numero de carreiras / Car
   PCK1:=IMPRIME:=.F.
   DBEDIT(09,50,15,63,CAMPO1,"CAD1",.T.,"","","","","")
   SETCOLOR("W/N")
   IF PCK1
      PACK
   ENDIF
   RESTSCREEN(08,49,21,64,TELA)
   DBSELECTAR("ETIQ1")
   IF IMPRIME
      LY=MLCOUNT(TEXTO,LAR)
      IF LY > 8
         LY = 8
      ENDIF
      IF LY=0
         MDT("IMPOSSIVEL DE IMPRIMIR ETIQUETAS NAO EDITADA / VAZIA")
         RETU .T.
      ENDIF
      IF LY<ALT
         MDT("CAMPO ALTURA MENOR QUE O TAMANHO DE LINHAS DE SUA ETIQUETA !")
         INKEY(0)
         RETU.T.
      ENDIF
      L=ARRAY(8)
      L[1]=LEFT(DESCRICAO+SPAC(30),LAR)
      L[2]=LEFT(MEMOLINE(TEXTO,31,1)+SPAC(30),LAR)
      L[3]=LEFT(MEMOLINE(TEXTO,31,2)+SPAC(30),LAR)
      L[4]=LEFT(MEMOLINE(TEXTO,31,3)+SPAC(30),LAR)
      L[5]=LEFT(MEMOLINE(TEXTO,31,4)+SPAC(30),LAR)
      L[6]=LEFT(MEMOLINE(TEXTO,31,5)+SPAC(30),LAR)
      L[7]=LEFT(MEMOLINE(TEXTO,31,6)+SPAC(30),LAR)
      L[8]=LEFT(MEMOLINE(TEXTO,31,7)+SPAC(30),LAR)
      LX=SPAC(LAR)
      CONTADOR=1
      MDS('Quantas Etiquetas?')
      @ 23,40 GET CONTADOR PICT '999999'
      READCUR()
      CONTADOR = (CONTADOR+(COL-1))/COL
      IF MDG('Impressora pronta?')
         IF ISPRINTER()
            SET DEVI TO PRINT
            SET PRINT ON
            ?? CHR(27)+'C'+CHR(ALT+1)
            SET PRINT OFF
            FOR WC= 1 TO CONTADOR
               CTLIN = -1
               FOR CU=1 TO ALT
                  CTLIN=CTLIN+1
                  FOR CT=1 TO COL
                     CTCOL=0
                     IF CT>1
                        CTCOL=(LAR*(CT-1))+(CT-1)
                     ENDIF
                     @ CTLIN,CTCOL SAY ACENTO(L[CU])
                  NEXT
               NEXT
            NEXT
            EJEC
            SET DEVI TO SCREEN
         ELSE
            MDT('Impressora n„o dispon¡vel')
         ENDIF
      ENDIF
   ENDIF
   @ 08,46 CLEAR TO 21,79
   SETCOLOR("W/G")
   *******************************
   * ALTERACOES FEITAS EM 5/8/92 *
   *******************************
   RELEASE ALL LIKE L*
   RELEASE ALL LIKE CT*
   RELEASE CONTADOR, ALT, LAR, COL
   RETU(2)
CASE KEY=84 && "T"
   SETCOLOR("+W/BR")
   @ 08,46 TO 18,79 DOUB
   @ 19,46 CLEA TO 21,79
   @ 19,46 TO 21,79 DOUB
   @ 20,48 SAY 'CTRL+W [^W] PARA GRAVAR'
   @ 08,48 SAY 'Texto'
   SETCURSOR(1)
   REPL TEXTO WITH MEMOEDIT(TEXTO,09,47,17,78,.T.)
   SETCOLOR("W/N")
   @ 08,46 CLEAR TO 24,79
   SETCURSOR(0)
   SETCOLOR("W/G")
   RETU(1)
CASE KEY=27
   RETU(0)
ENDCASE
RETU(1)
*: FIM: RECUETI1.PRG

