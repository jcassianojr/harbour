*:*****************************************************************************
*:
*:   RECUETI2.PRG: CONFIGURADA
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em:
*:
*:*****************************************************************************
////#INCLUDE "COMANDO.CH"

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
   SAVE SCREEN TO TELA_2
   EDITA()
   REST SCREEN FROM TELA_2
ENDDO
RETU

*!*****************************************************************************
*!
*!       EDITA
*!
*!*****************************************************************************
FUNCTION EDITA
IMPRIME=.F.
@ 08,00 CLEAR
PES1=SPAC(12)
IF ! netuse("ETIQ2") //BREDE("ETIQ2",0)
   RETU
ENDIF
IF ! NETUSE("ETIQ3") //AREDE("ETIQ3","ETIQ3",0)
   dbselectar("ETIQ2")
   dbclosearea()
   RETU
ENDIF
DBGOTOP()
IF ! NSHOW1()
   RETU
ENDIF

DECLARE _CAMPO[1]
_CAMPO[1]="' '+CODIGO+' '+DESCRICAO+' '"
@ 08,00 CLEAR TO 21,79
SETCOLOR("W/G")
@ 08,00 CLEAR TO 21,48
@ 08,00 TO 21,48 DOUB
@ 08,03 SAY 'C¢digo'
@ 08,16 SAY 'Descri‡ao'
PCK = .F.
DBEDIT(09,02,20,47,_CAMPO,"CA",.T.,"","","","","")
SETCOLOR("W/N")
SETCURSOR(1)

RETU

*!*****************************************************************************
*!
*!         Fun‡„o: CA()
*!
*!*****************************************************************************
FUNC CA
PARA MODO
KEY=LASTKEY()
DO CASE
CASE MODO<4
   RETU(1)
CASE KEY=7
   SETCURSOR(1)
   DELEREC()
   SETCURSOR(0)
   RETU(2)
CASE KEY=10
   MDS('Digite o c¢digo:')
   @ 23,40 GET PES1
   READCUR()
   @ 22,00
   IF LASTKEY()<>27
      REC=RECNO()
      DBGOTOP()
      if ! DBSEEK(PES1)
         MDT('Nao encontrado')
         DBGOTO(REC)
      ENDIF
   ENDIF
   RETU(1)
CASE KEY=13 .OR. KEY=22
   TELA=SAVESCREEN(08,00,22,79)
   IF OPCAO1=2
      IF KEY = 22
         NETRECAPP()
         @ ROW()+1,3 GET CODIGO
      ELSEIF KEY = 13
         @ ROW(),3 GET CODIGO
      ENDIF
      @ ROW(),COL()+1 GET DESCRICAO
      READCUR()
      IF LASTKEY()=27
         IF KEY=22
            NETRECDEL()
            ANT=SETCOLOR()
            SETCOLOR("W/G")
            @ 08,00 CLEAR TO 20,48
            @ 08,00 TO 20,48 DOUB
            @ 08,03 SAY 'C¢digo'
            @ 08,16 SAY 'Descri‡ao'
            SETCOLOR(ANT)
            RELEASE ANT
         ENDIF
         ** ALTERADO EM 5/8/92
         RETU(27)
      ENDIF
      PRIV DBTELA, COR_ANT
      COR_ANT=SETCOLOR()
      DBTELA=SAVESCREEN(00,00,24,79)
      SETCOLOR("+W/BR")
      @ 08,00 CLEAR TO 22,79
      @ 08,00 TO 22,79 DOUB
      SET DELI TO "[]"
      SET DELI ON
      @ 09,02 SAY 'Arq.1:'
      @ 10,02 SAY 'Chv.1:'
      @ 11,02 SAY 'Campo:'
      @ 12,02 SAY 'Arq.2:'
      @ 13,02 SAY 'Chv.2:'
      @ 14,02 SAY 'Lin.1:'
      @ 15,02 SAY 'Lin.2:'
      @ 16,02 SAY 'Lin.3:'
      @ 17,02 SAY 'Lin.4:'
      @ 18,02 SAY 'Lin.5:'
      @ 19,02 SAY 'Lin.6:'
      @ 20,02 SAY 'Lin.7:'
      @ 21,02 SAY 'Lin.8:'
      SETCURSOR(1)
      CONTINUA=.F.
      IF EMPTY(ARQUIVO)
         CONTINUA=.T.
      ELSE
         @ 09,09 SAY ARQUIVO
         @ 10,09 SAY CHAVE
         @ 11,09 SAY CAMPO
         @ 11,COL()+1 SAY '(Relacionado)'
         @ 12,09 SAY ARQUIVO2
         @ 13,09 SAY CHAVE2
         IF MDG('Revisa os Arquivos')
            CONTINUA=.T.
         ENDIF
      ENDIF
      IF CONTINUA
         @ 09,02 SAY 'Arq.1:' GET ARQUIVO VALID ARQ(ARQUIVO)
         READCUR()
         IF LASTKEY()=27
            SETCOLOR(COR_ANT)
            SETCURSOR(0)
            SET DELI OFF
            RESTSCREEN(00,00,24,79,DBTELA)
            RETU(2)
         ENDIF
         XARQUIVO=ALLTRIM(ARQUIVO)
         PRIVA ANT_SEL
         ANT_SEL=SELECT()
         *********
         IF ! netuse(XARQUIVO) //BREDE(XARQUIVO,0)
            RETU
         ENDIF
         cSELE10:=ALIAS()
         *********
         SAVE SCREEN
         MDS('Escolha a ordem da listagem')
         aESTRU := dbstruct()
         pESTRU := len( aESTRU )
         dESTRU := array( pESTRU )
         for Z := 1 to pESTRU
             dESTRU[ Z ] = padr( aESTRU[ Z, 1 ], 10 )
         next Z
         DEFA=1
         DEFA=RCAMPO(DEFA)
         IF DEFA=0
            DEFA=1
         ENDIF
         CHAVEARQ1=FIELDNAME(DEFA)
         SELECT(ANT_SEL)
         REPL CHAVE WITH CHAVEARQ1
         REST SCREEN
         @ 10,09 SAY CHAVE
         IF MDG('Relacionar Arquivos?')
            DBSELECTAR(cSELE10)
            SAVE SCREEN
            MDS('Escolha a campo relacionado')
            aESTRU := dbstruct()
            pESTRU := len( aESTRU )
            dESTRU := array( pESTRU )
            for Z := 1 to pESTRU
               dESTRU[ Z ] = padr( aESTRU[ Z, 1 ], 10 )
            next Z
            DEFA=1
            DEFA=RCAMPO(DEFA)
            IF DEFA=0
               DEFA=1
            ENDIF
            CAMPOREL=FIELDNAME(DEFA)
            SELECT(ANT_SEL)
            REPL CAMPO WITH CAMPOREL
            REST SCREEN
            @ 11,09 SAY CAMPO
            @ 11,COL()+1 SAY '(Relacionado)'
            @ 12,09 GET ARQUIVO2 VALID ARQ(ARQUIVO2)
            READCUR()
            XARQUIVO2=ALLTRIM(ARQUIVO2)
            IF ! netuse(xarquivo2) //BREDE(XARQUIVO2,0)
               RETU
            ENDIF
            SAVE SCREEN
            MDS('Escolha a ordem de relacao')
            aESTRU := dbstruct()
            pESTRU := len( aESTRU )
            dESTRU := array( pESTRU )
            for Z := 1 to pESTRU
                dESTRU[ Z ] = padr( aESTRU[ Z, 1 ], 10 )
            next Z
            DEFA=1
            DEFA=RCAMPO(DEFA)
            IF DEFA=0
               DEFA=1
            ENDIF
            REST SCREEN
            CHAVEARQ2=FIELDNAME(DEFA)
            SELECT(ANT_SEL)
            REPL CHAVE2 WITH CHAVEARQ2
            @ 23,00 CLEAR TO 24,79
            @ 13,09 SAY CHAVE2
            DBCLOSEARE()
         ELSE
            SELECT(ANT_SEL)
            REPL CAMPO    WITH ""
            REPL ARQUIVO2 WITH ""
            REPL CHAVE2   WITH ""
         ENDIF
         DBSELECTAR(cSELE10)
         DBCLOSEAREA()
         SELECT(ANT_SEL)
      ENDIF
      SET DELI OFF
      SETCURSOR(1)
      @ 14,09 GET LINHA1 PICT "@S70"
      @ 15,09 GET LINHA2 PICT "@S70"
      @ 16,09 GET LINHA3 PICT "@S70"
      @ 17,09 GET LINHA4 PICT "@S70"
      @ 18,09 GET LINHA5 PICT "@S70"
      @ 19,09 GET LINHA6 PICT "@S70"
      @ 20,09 GET LINHA7 PICT "@S70"
      @ 21,09 GET LINHA8 PICT "@S70"
      READCUR()
      IF LASTKEY()=27
         SETCOLOR("W/G")
         RESTSCREEN(08,00,21,79,TELA)
         RETU(1)
      ENDIF
      TELA1=SAVESCREEN(18,03,21,79)
      SETCOLOR("W/G")
      @ 18,03 CLEAR TO 20,76
      @ 18,03 TO 20,76 DOUB
      @ 18,34 SAY 'Filtro:'
      @ 19,05 GET FILTRO
      READCUR()
      IF LASTKEY()=27
         RESTSCREEN(08,00,21,79,TELA)
         SETCOLOR("W/G")
         RETU(1)
      ENDIF
      SETCOLOR("+W/BR")
      @ 19,06 CLEAR TO 20,79
      @ 19,06 TO 21,79 DOUB
      @ 19,30 SAY 'Setup de Impressao:'
      @ 20,08 GET SETUP
      READCUR()
      IF LASTKEY()=27
         SETCOLOR("W/G")
         RESTSCREEN(08,00,21,79,TELA)
         RETU(1)
      ENDIF
      SETCOLOR("W/N")
      RESTSCREEN(18,03,21,79,TELA1)
      ARQ=TRIM(ARQUIVO)
      KEY=TRIM(CHAVE)
      ARQ2=TRIM(ARQUIVO2)
      KEY2=TRIM(CHAVE2)
   ELSEIF KEY=13
      LISTA()
   ENDIF
   RESTSCREEN(08,00,22,79,TELA)
   SETCOLOR("W/G")
   RETU(1)
CASE KEY=27
   RETU(0)
ENDCASE
RETU(1)

*!*****************************************************************************
*!
*!      LISTA
*!
*!*****************************************************************************
FUNCTION LISTA
dbselectar("etiq2")
DBGOTOP()
IF EOF()
   MDT('N„o h  etiquetas cadastradas')
   RETU
ENDIF
CAMPOX:=ARRAY(1)
CAMPOX[1]="' '+STR(ALTURA)+' '+STR(LARGURA)+' '+STR(COLUNAS)+' '"
TELA5=SAVESCREEN(08,49,21,64)
TELATIP()
ALT=0
LAR=0
COL=0
PCK1:=IMPRIME:=.F.
DBEDIT(09,50,15,63,CAMPOX,"CAD1",.T.,"","","","","")
RESTSCREEN(08,49,21,64,TELA5)
SETCOLOR("W/N")
dbselectar("etiq3")
IF ! IMPRIME
   RETU
ENDIF
dbselectar("etiq3")
ARQ=TRIM(ARQUIVO)
KEY=TRIM(CHAVE)
ARQ2=TRIM(ARQUIVO2)
KEY2=TRIM(CHAVE2)
CPO=TRIM(CAMPO)
IF file("&ARQ..DBF")
   MDT('A g u a r d e ! ! ! Indexando...')
   IF ! NETUSE(ARQ,,,,,.F.,) //BREDE(ARQ,0)
      RETU
   ENDIF
   cSELE3:=ALIAS()
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)   
   ordDestroy("temp")
   ordcreate(,"temp",KEY)
   ordSetFocus("temp")
   
   IF file("&ARQ2..DBF")
      IF ! NETUSE(ARQ2,,,,,.F.,) //BREDE(ARQ2,0)
         RETU
      ENDIF
      cALIAS4:=ALIAS()
      
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      ordDestroy("temp")
      ordcreate(,"temp",KEY2)
      ordSetFocus("temp")
 
      
      IF ! EMPTY(CPO)
         dbselectar(cSELE3)
         SET RELATION TO &CPO INTO &cALIAS3
      ENDIF
   ENDIF
   dbselectar("etiq3")
   @ 23,0
ELSE
   MDT('Arquivo nao encontrado')
   dbselectar("etiq3")
   RETU
ENDIF
LINHAX={LINHA1,LINHA2,LINHA3,LINHA4,LINHA5,LINHA6,LINHA7,LINHA8}
CONFIG=TRIM(SETUP)
FI=TRIM(FILTRO)
dbselectar(cSELE3)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO
COPIAS=1
IF ! CHECKIMP(0)
   dbselectar("etiq3")
   RETU
ENDIF
IMPRESSORA()
SET PRINT ON
?? CHR(27)+'C'+CHR(ALT+1)
IF ! EMPTY(CONFIG)
   ?? &CONFIG
ENDIF
SET PRINT OFF
DBGOTOP()
WHILE ! EOF()
   RRR=RECNO()
   CTLIN = -1
   FOR CU=1 TO ALT
      CTLIN++
      DIZERES=LINHAX[CU]
      FOR CT=1 TO COL
         CTCOL=0
         IF CT>1
            CTCOL=(LAR*(CT-1))+(CT-1)
         ENDIF
         DBGOTO(RRR)
         IF CT>1
            DBSKIP(CT-1)
         ENDIF
         @ CTLIN,CTCOL SAY &DIZERES
      NEXT
   NEXT
   DBSKIP()
ENDDO
IMPFOL()
SET PRINT ON
?? CHR(27)+'@'
SET PRINT OFF
dbselectar(cSELE4)
DBCLOSEAREA()
dbselectar(cSELE3)
DBCLOSEAREA()
VIDEO()
IMPEND()
dbselectar("etiq3")
RETU
*: FIM: RECUETI2.PRG
