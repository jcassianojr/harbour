*:*****************************************************************************
*:
*:   RECUARQ1.PRG: Gerenciar Arquivos
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 05/12/94     12:13
*:
*:   & Fncts: RECUARQ1()
*:               : ARQTEL
*:               : MDG2()
*:
*:               : ARQTEL             (  em RECUARQ1.PRG)
*:               : MDG2()             (fun‡„o    em RECUARQ1.PRG)
*:               : RECULER()          (fun‡„o    em RECULER.PRG)
*:               : EDITARQ()          (fun‡„o    em ?)
*:               : IMPARQ()          (fun‡„o    em IMPARQ.PRG)
*:               : RECUSER3()         (fun‡„o    em RECUSER3.PRG)
*:
*: Outros Arquivos: DBF
*:               : &DIR
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "BOX.CH"
function recuarq1
PARA CC
VEDIR:=ASORT(FILENAME2(FILTRO))
IF LEN(VEDIR)=0
   MDT('Sem arquivos para este filtro')
ENDIF
CONTR:=ARRAY(LEN(VEDIR))
AFILL(CONTR,.T.)

IF CC=1
   DO WHILE .T.
      ARQTEL()
      AESC=ACHOICE(11,02,22,45,VEDIR,CONTR)
      IF AESC=0
         RETU
      ELSE
         ARQ=SUBSTR(VEDIR[AESC],1,12)
         MDS('Arquivo Selecionado: '+arq)
      ENDIF
      HB_dispbox( 8,48, 24, 79,B_DOUBLE+" ")      
      OPCAO( 10,51 , " &Renomear",82)
      OPCAO( 12,51 , " &Copia",67)
      OPCAO( 14,51 , " &Deletar",68)
      OPCAO( 16,51 , " &Ver",86)
      OPCAO( 18,51 , " &Fazer",70)
      OPCAO( 20,51 , " &Editar",69)
      OPCAO( 22,51 , " &Imprimir",73)
      OP:=MENU(,0)
      DO CASE
      CASE OP=1
         DIR=SPAC(12)
         @ 11,49 GET DIR
         READCUR()
         DIR=ALLTRIM(DIR)
         IF ! EMPTY(DIR)
            FRENAME(ARQ,DIR)
         ENDIF
         VEDIR[AESC]=PADR(DIR,12)+SUBSTR(VEDIR[AESC],13)
      CASE OP=2
         DIR=SPAC(12)
         @ 13,49 GET DIR
         READCUR()
         DIR=ALLTRIM(DIR)
         IF ! EMPTY(DIR)
            FILECOPY(ARQ,DIR)
         ENDIF
         AADD(VEDIR,PADR(DIR,12)+SUBSTR(VEDIR[AESC],13))
         AADD(CONTR,.T.)
      CASE OP=3
         IF ! MDG2(15)
            LOOP
         ENDIF
         FERASE(ARQ)
         VEDIR[AESC]=SUBSTR(VEDIR[AESC],1,13)+" - Deletado "
         CONTR[AESC]=.F.
      CASE OP=4
         DADO=ARQ
         VERTXT(DADO)
      CASE OP=5
         TELA=SAVESCREEN(00,00,24,79)
         hb_run(ARQUIVO)
         RESTSCREEN(00,00,24,79,TELA)
      CASE OP=6 ; EDITARQ(ARQ)
      CASE OP=7
         mMARESQ=8
         mMARDIR=7
         mMARSUP=3
         mMARINF=8
         mMARCOL=80
         mMARLIN=66
         mSETUP=""
         IMPARQ(ARQ)
      OTHERWISE
         RETU
      ENDCASE
   ENDDO
ENDIF

IF CC=2
   DO WHILE .T.
      ARQTEL()
      AESC=ACHOICE(11,02,23,45,VEDIR,.T.)
      IF AESC=0
         RETU
      ENDIF
      ARQUIVO=SUBSTR(VEDIR[AESC],1,12)
      HB_dispbox( 8,48, 24, 79,B_DOUBLE+" ")      
      @ 09,51 SAY 'Arquivo Selecionado:'
      @ 10,51 SAY arquivo
      OPCAO( 12,51 , " &Verificar",86)
      OPCAO( 14,51 , " &Alterar  ",65)
      OPCAO( 16,51 , " &Zerar    ",90)
      OPCAO( 18,51 , " &Documento",68)
      OPCAO( 20,51 , " &Imprimir ",73)
      OP:=MENU(,0)
      DO CASE
      CASE OP=1 ; RECUSER3(1)
      CASE OP=2 ; RECUSER3(2)
      CASE OP=3 ; RECUSER3(3)
      CASE OP=4 ; RECUSER3(4)
      CASE OP=5 ; RECUSER3(5)
      OTHERWISE ; RETU
      ENDCASE
   ENDDO
ENDIF


*!*****************************************************************************
*!
*!         Fun‡„o: MDG2()
*!
*!    Chamado por: RECUARQ1.PRG
*!
*!*****************************************************************************
FUNC MDG2
PARA LIN
@ LIN,51 SAY 'Confirma'
OPCAO(LIN,70,'SIM',83)
OPCAO(LIN,75,'NAO',78)
OPC:=MENU(,0)
IF OPC=1
   RETU(.T.)
ENDIF
RETU(.F.)
********


*!*****************************************************************************
*!
*!      ARQTEL
*!
*!    Chamado por: RECUARQ1.PRG
*!
*!*****************************************************************************
FUNCTION ARQTEL
HB_dispbox( 8, 0, 24, 47,B_DOUBLE+" ")
@ 09,02 SAY "Arquivo"+SPAC(6)+"Tamanho   Data"+SPAC(7)+"Hora"
@ 10,00 SAY 'Ç'+REPL('-',46)+'¶'
HB_dispbox( 8,48, 23, 79,B_DOUBLE+" ")
RETU


*!*****************************************************************************
*!
*!         Fun‡„o: FILENAME2()
*!
*!    Chamado por: RECUARQ1.PRG
*!
*!*****************************************************************************
FUNC FILENAME2
LOCAL DIR,RET_ARRAY,X
RET_ARRAY:=ARRAY(LEN(DIR:=DIRECTORY(ALLTRIM(FILTRO))))
FOR X=1 TO LEN(DIR)
   RET_ARRAY[X]:=PADR(DIR[X][1],14)+" "+PADL(DIR[X][2],10)+" "+DTOC(DIR[X][3])+" "+DIR[X][4]
NEXT X
RETU RET_ARRAY
*: FIM: RECUARQ1.PRG

