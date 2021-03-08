*:*****************************************************************************
*:
*:   RECUSER3.PRG: Programa para Zerar Arquivos
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:40
*:
*:  Procs & Fncts: RECUSER3()
*:               : WORK1()
*:
*:          Chama: RECURELL()         (fun‡„o    em RECURELL.PRG)
*:               : NSHOW1()           (fun‡„o    em RECUPROC.PRG)
*:               : WORK1()            (fun‡„o    em RECUSER3.PRG, chamado  no Dbedit())
*:
*:            Usa: WORK.DBF
*:               : WORK2.DBF
*:               : &ARQUIVO
*:
*: Outros Arquivos: DOC
*:               : DBF
*:               : &BAK
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************
#INCLUDE "BOX.CH"
function recuser3
PARA CY
PCK=.F.
IF CY=3
   IF MDG('Vocˆ Deseja Zerar este arquivo')
      NETZAP(ARQUSO)
   ENDIF
   RETU
ENDIF
IF ! NETUSE(ARQUSO,,,,,.F.,) // BREDE(ARQUIVO,0)
   RETU
ENDIF
COPY STRUCTURE EXTENDED TO WORK
DBCLOSEAREA()
IF ! NETUSE("WORK",,,,,.F.,) //BREDE("WORK",0)
   RETU
ENDIF
DBGOTOP()
IF CY=4
   DOC=TIRAEXT(ARQUIVO,'TEC')
   MDS('Aguarde Criando Documenta‡„o')
   USO=FCREATE(DOC)
   IF FERROR()#0
      ALERTX("Erro na Cria‡„o do Arquivo")
      RETU
   ENDIF
   FWRITE(USO,REPL('-',70)+CHR(13)+CHR(10))
   FWRITE(USO,'Estrutura Arquivo: '+ARQUIVO+CHR(13)+CHR(10))
   FWRITE(USO,REPL('-',70)+CHR(13)+CHR(10))
   FWRITE(USO,"Campo"+SPAC(7)+"T  Tam  Dec"+CHR(13)+CHR(10))
   FWRITE(USO,REPL('-',70)+CHR(13)+CHR(10))
   DO WHILE ! EOF()
      FWRITE(USO,FIELD_NAME+'  '+FIELD_TYPE+'  '+STR(FIELD_LEN,3)+'  '+STR(FIELD_DEC,3)+CHR(13)+CHR(10))
      DBSKIP()
   ENDDO
   FWRITE(USO,REPL('-',70)+CHR(13)+CHR(10))
   FCLOSE(USO)
   DBCLOSEALL()
   RETU
ENDIF
IF CY=5
   DBCLOSEALL()
   FO_RELL("ESTRUTURA")
   DBCLOSEALL()
   RETU
ENDIF
DECLARE CAMPOS[1]
CAMPOS[1]="FIELD_NAME+'  '+FIELD_TYPE+'  '+STR(FIELD_LEN,3)+'  '+STR(FIELD_DEC,4)"
IF ! NSHOW1()
   RETU
ENDIF
@ 08,00 CLEA
HB_dispbox( 8, 0, 21, 27,B_DOUBLE+" ")
@ 09,02 SAY "Campo"+SPAC(7)+"T  Tam  Dec"
@ 10,00 SAY 'Ý'+REPL('-',26)+'Ý'
HB_dispbox( 8,28, 21, 79,B_DOUBLE+" ")
@ 09,30 SAY "Arquivo Selecionado: "+arqUIVO
@ 10,28 SAY 'Ý'+REPL('-',50)+'Ý'
@ 11,30 SAY "Campo: Nome Dado ao Campo."
@ 13,30 SAY "T: Tipo do Campo Pode ser:"
@ 14,33 SAY "N "+REPL('-',2)+CHR(16)+" Numerico    D "+REPL('-',2)+CHR(16)+" Data"
@ 15,33 SAY "C "+REPL('-',2)+CHR(16)+" Caracter    M "+REPL('-',2)+CHR(16)+" Memoria"
@ 16,33 SAY "L "+REPL('-',2)+CHR(16)+" Logico"
@ 18,30 SAY "Tam: Tamanho do Campo."
@ 20,30 SAY "Dec: Numero de Casas Decimais do Campo."
//CLEAR TYPEAHEAD
hb_keyClear()
DBEDIT(11,2,20,26,CAMPOS,"WORK1",.T.,"","","","","")
DBCLOSEAREA()
CREATE WORK2 FROM WORK
IF CY=2
   IF MDG('Deseja Gravar as Altera‡”es')
      MDS('Aguarde Alterando o arquivo')
      BAK=TIRACE(arquivo,'bak')
      FILECOPY(ARQUIVO,BAK)
      nLASTREC:=NetRegCount(arquivo)
      IF ! NETUSE("WORK2",,,,,.F.,) //BREDE("WORK2",0)
         RETU
      ENDIF
      zei_fort( nLASTREC,,,0)
      APPEND FROM &ARQUIVO  while zei_fort(nLASTREC,,,1)
      COPY TO &ARQUIVO while zei_fort(nLASTREC,,,1)
   ENDIF
ENDIF
DBCLOSEALL()
FERASE("WORK.DBF")
FERASE("WORK2.DBF")
RETU


*!*****************************************************************************
*!
*!         Fun‡„o: WORK1()
*!
*!    Chamado por: RECUSER3.PRG
*!
*!          Chama: DELEREC.PRG
*!
*!*****************************************************************************
FUNC WORK1
PARAMETERS MODO
KEY=LASTKEY()
DO CASE
CASE KEY = 27
   RETU(0)
CASE KEY = 13.AND.CY=2
   SETCURSOR(1)
   POS=ROW()
   @ ROW(),02 GET FIELD_NAME
   @ ROW(),14 GET FIELD_TYPE PICT '!' VALID FIELD_TYPE $'CNDTM'
   READCUR()
   IF FIELD_TYPE#'D'
      @ POS,17 GET FIELD_LEN
      READCUR()
   ELSE
      REPL FIELD_LEN WITH 8
   ENDIF
   IF FIELD_TYPE='N'
      @ POS,23 GET FIELD_DEC
      READCUR()
   ENDIF
   SETCURSOR(0)
   RETU(1)
CASE (KEY = 22.OR.MODO=3).AND.CY=2
   SETCURSOR(1)
   MD()
   NETRECAPP()
   @ 23,02 GET FIELD_NAME
   @ 23,14 GET FIELD_TYPE  PICT '!' VALID FIELD_TYPE $'CNDTM'
   READCUR()
   IF FIELD_TYPE#'D'
      @ 23,17 GET FIELD_LEN
      READCUR()
   ELSE
      REPL FIELD_LEN WITH 8
   ENDIF
   IF FIELD_TYPE="N"
      @ 23,23 GET FIELD_DEC
      READCUR()
   ENDIF
   SETCURSOR(0)
   @ 22,00 CLEAR
   RETU(2)
CASE KEY = 7.AND.CY=2
   SETCURSOR(1)
   DELEREC()
   SETCURSOR(0)
   RETU(2)
OTHERWISE
   RETU(1)
ENDCASE
RETU(1)
*: FIM: RECUSER3.PRG
