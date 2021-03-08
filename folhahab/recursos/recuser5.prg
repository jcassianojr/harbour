*:*****************************************************************************
*:
*:   RECUSER5.PRG: Faz Copia de Reserva
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:41
*:
*:  Procs & Fncts: RECUSER5()
*:
*:          Chama: CABE2()            (fun‡„o    em RECUPROC.PRG)
*:               : CERTEZA()          (fun‡„o    em RECUPROC.PRG)
*:               : ESPERA()           (fun‡„o    em RECUPROC.PRG)
*:
*: Outros Arquivos: DESTINO
*:               : DBF
*:               : &DESTINO
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************

#INCLUDE "BOX.CH"
function recuser5
PARA CC
CABE2('Fazendo Copia de Reserva')
SETCOLOR("+R/W")
HB_dispbox( 8, 0, 21, 79,B_DOUBLE+" ")
@ 09,02 SAY "Copia de Reserva :"
@ 10,00 SAY '+'+REPL('-',78)+'Ý'
@ 12,04 SAY "Esta opc„o serve para fazer copia de reserva de seus arquivos de dados,"
@ 13,04 SAY "ou seja, seus arquivos serao copiados do disco rigido  para  disquetes."
@ 15,06 SAY "Para  fazer  a  copia  basta indicar em qual drive ser„o gravados"
@ 16,06 SAY "TECLE [A:] OU [B:] e depois digite o grupo de arquivos que deseja"
@ 17,06 SAY "uma copia de reserva."
@ 19,10 SAY "Depois basta seguir as orienta‡”es que aparecem no rodap‚."
SETCOLOR("W/N")
IF ! MDG('Voce tˆm certeza')
   RETU
ENDIF
DRIVE=' :'
MAS='*.DBF       '
Mds('QUAL O DRIVE DESEJADO: ')
@ 23,25 GET DRIVE VALID DRIVE $'A:B:'
READCUR()
spacotot = DISKSPACE (ASC(SUBSTR(DRIVE,1))-64)
IF spacotot < 360000 .OR. spacotot > 362496 .AND. spacotot <= 1200000
   IF ! MDG('Disquete j  cont‚m informa‡”es, Deseja continuar')
      RETU
   ENDIF
ENDIF
IF CC=1
   Mds('Qual o grupo de arquivos ')
   @ 23,35 GET mas
   READCUR()
   mas=ALLTRIM(mas)
   NARQ=ADIR(MAS)
ENDIF
IF CC=2
   NARQ=0
   DECLARE NTEMP[1]
   DECLARE TTEMP[1]
   DECLARE NOMEARQ[40]
   DECLARE TAMARQ[40]
   FOR X=1 TO 40
      TESTA='mARQ'+STRZERO(X,2)
      TESTE=&TESTA
      IF file(TESTE)
         NARQ=NARQ+1
         ADIR(TESTE,NTEMP,TTEMP)
         NOMEARQ[NARQ]=NTEMP[1]
         TAMARQ[NARQ]=TTEMP[1]
      ENDIF
   NEXT X
ENDIF
IF NARQ=0
   MDT('N„o existem arquivos para copiar')
   RETU
ENDIF
SETCOLOR("W/R")
@ 09,00 CLEA TO 24,79
SETCOLOR("N/W")
@ 08,00 CLEA TO 08,79
@ 08,00 SAY 'COPIADOR -   SOFTEC '
IF CC=1
   DECLARE NOMEARQ[NARQ]
   DECLARE TAMARQ[NARQ]
   ADIR(MAS,NOMEARQ,TAMARQ)
ENDIF
DECLARE NTMP[1]
DECLARE TTMP[1]
TESTADOS=1
TOTDISK=0
FOR A=1 TO NARQ
   TOTDISK=TAMARQ[A]+TOTDISK
NEXT A
TOTDISK=ROUND(TOTDISK/273224,0)
IF TOTDISK=0
   TOTDISK=1
ENDIF
Mdt('Vocˆ precisa ter '+STR(totdisk,4)+' disco(s) para armazenar '+STR(narq,4)+' arquivo(s)')
copia=1
disco=0
newdisk=1
testados=narq
DO WHILE copia<=narq
   flag=0
   IF testados=narq
      IF newdisk=1
         disco=disco+1
      ENDIF
	  hb_keyClear()
      //CLEAR TYPEAHEAD
      newdisk=0
      ALERTX('Coloque o '+STR(disco,4)+' disquete no drive '+drive)
      testados=copia-1
   ENDIF
   origem=nomearq[copia]
   destino=drive+origem
   DO WHILE .T.
      HANDLE=FCREATE(DESTINO)
      IF FERROR()>0
         MDT('Erro de acesso a unidade '+drive)
         MDS('SAI T>emporariamente D>efinitivamente ou I>gnora erro ?')
         DO WHILE .T.
            KEY=INKEY(0)
            IF LOWER (CHR(KEY))='t'.OR.LOWER(CHR(KEY))='d'.OR.LOWER(CHR(KEY))='i'
               EXIT
            ENDIF
         ENDDO
         IF LOWER(CHR(KEY))='t'
            IF ! HB_FILEEXISTS('COMMAND.COM')
               MDT('N„o existe o COMMAND.COM, sa¡da negada.')
               LOOP
            ENDIF
            MDT('Digite exit para retornar ao programa')
            swpruncmd("C:\COMMAND.COM")
         ELSEIF LOWER(CHR(KEY))='d'
            QUIT
         ENDIF
      ELSE
         EXIT
      ENDIF
   ENDDO
   FCLOSE(HANDLE)
   FILEDELETE(DESTINO)
   MDS(ORIGEM+', verificando tamanho')
   IF TAMARQ[COPIA]>362496
      MDT('S¢ pode ser copiado com o comando BACKUP')
   ELSEIF DISKSPACE(DRIVE)<TAMARQ[COPIA]
      MDS('Atualmente n„o h  espaco')
      FLAG=1
   ELSE
      MDS('Copiando: '+ORIGEM)
      FLAG=2
   ENDIF
   IF FLAG=1
      ACOPY(NOMEARQ,NTMP,COPIA,1,1)
      ACOPY(TAMARQ,TTMP,COPIA,1,1)
      ADEL(NOMEARQ,COPIA)
      ADEL(TAMARQ,COPIA)
      ACOPY(NTMP,NOMEARQ,1,1,NARQ)
      ACOPY(TTMP,TAMARQ,1,1,NARQ)
   ELSEIF FLAG=2
      FILECOPY(ORIGEM,DESTINO)
      COPIA=COPIA+1
      NEWDISK=1
   ELSE
      COPIA=COPIA+1
   ENDIF
   TESTADOS=TESTADOS+1
ENDDO
COPIA=COPIA-1
MDT(STR(COPIA,4)+' Arquivo(s) Copiado(s)')
RETU
*: FIM: RECUSER5.PRG
