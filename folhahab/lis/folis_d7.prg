*:*****************************************************************************
*:
*:   FOLIS_D7.PRG: Virado do Ano
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:          Autor: Equipe Softec
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 23/02/99
*:
*:*****************************************************************************



////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

INFOR("FIRMA","NRCLIEN","FIRMA",.T.)
CABE2('INICIAR ANO')

SETCOLOR("+GR/R")
HB_dispbox( 8, 0, 20, 79,B_DOUBLE)
@ 11,03 SAY "ATEN€AO !!!!!"
@ 13,09 SAY "Antes de iniciar o ano fa‡a uma copia de reserva de todos os seus"
@ 14,03 SAY "arquivos."
@ 15,09 SAY "Tal resguardo se deve ao fato que  haver   manipula‡„o  de v rios"
@ 16,03 SAY "arquivos durante o processo de inicializa‡„o."
@ 17,09 SAY "S¢ continue ap¢s ter feito a copia de reserva."
@ 18,03 SAY "Aconselhamos estar com apenas um usuario na rede"
SETCOLOR("W/N,N/W")
IF ! MDG('Deseja continuar')
   RETU .F.
ENDIF
CLSROW(8)
IF ! NETUSE("FIRMA")
   RETU .F.
ENDIF
FI='INIANO#"N"'
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO

nANOANT:=YEAR(ZDATA)-1
nANONOV:=YEAR(ZDATA)
nANOREF:=YEAR(ZDATA)-1
@ 22,00 SAY 'DIGITE O ANO PARA ARQUIVAR'
@ 23,00 SAY 'DIGITE O ANO PARA INICIAR'
@ 24,00 SAY 'DIGITE O ANO REFERENCIA'
@ 22,50 GET nANOANT PICT "9999"
@ 23,50 GET nANONOV PICT "9999"
@ 24,50 GET nANOREF PICT "9999"
IF ! READCUR()
   RETU .F.
ENDIF

ANOANT:=SUBSTR(STRZERO(nANOANT,4),3,2)
ANONOV:=SUBSTR(STRZERO(nANONOV,4),3,2)
ANOREF:=SUBSTR(STRZERO(nANOREF,4),3,2)




IF ! MDG("Fazer Virada do ano de "+ANOANT+" para "+ANONOV)
   RETU .F.
ENDIF
IF ! MDG("Voce ja vez a copia de Reserva")
   RETU .F.
ENDIF
IF ! MDG("Voce tem Certeza")
   RETU .F.
ENDIF


INIPATH=HB_CWD()
CLSROW(8)
SETCOLOR("+GR/R")
HB_dispbox( 8, 0, 14, 79,B_DOUBLE)
@ 10,08 SAY "ATEN€AO !!!!!"
@ 12,08 SAY "NŽO INTERROMPA ESTOU INICIANDO O ANO."
DBSELECTAR("FIRMA")
DBGOTOP()
WHILE ! EOF()
   NREMP=NRCLIEN
   EMP=STRZERO(NREMP,4)
   SETCOLOR("+GR/R")
   HB_dispbox(15, 0, 19, 79,B_DOUBLE)   
   @ 17,08 SAY "FIRMA  :  "+EMP+' - '+RAZAO
   SETCOLOR("W/N,N/W")
   MDS('Preparando area de trabalho e arquivos')
   NEWPATH=INIPATH+'\EMP'+ANONOV+STRZERO(NREMP,3)
   OLDPATH=INIPATH+'\EMP'+ANOANT+STRZERO(NREMP,3)
   REFPATH=INIPATH+'\EMP'+ANOREF+STRZERO(NREMP,3)
   //Se n„o existir arquivos DBFs pula proxima empresa
   MATDBF=FILENAMES(REFPATH+'\*.DBF')
   nARQ=LEN(MATDBF)
   IF nARQ=0
      MDT("Falta Arquivos desta empresa")
      DBSELECTAR("FIRMA")
      DBSKIP()
      LOOP
   ENDIF
   lTEM:=file(NEWPATH+"\FO_PES.DBF")
   IF lTEM
      ALERTX("Vocˆ ja iniciou o ano para esta Empresa")
      IF ! MDG("Deseja Reescrever")
         DBSELECTAR("FIRMA")
         DBSKIP()
         LOOP
      ENDIF
   ENDIF
   DIRMAKE(NEWPATH)
   IF ANOREF#ANOANT
      DIRMAKE(OLDPATH)
   ENDIF
   HB_CWD(REFPATH)
   // DIRCHANGE(REFPATH)
   FOR X=1 TO nARQ
      ARQO=MATDBF[X]
      ARQD=NEWPATH+"\"+ARQO
      MDS('Copiando '+ARQO+' para '+ARQD)
      FILEcopy(ARQO,ARQD)
      IF ANOREF#ANOANT
         ARQO=MATDBF[X]
         ARQD=OLDPATH+"\"+ARQO
         MDS('Copiando '+ARQO+' para '+ARQD)
         FILEcopy(ARQO,ARQD)
      ENDIF
   NEXT X
   HB_CWD(NEWPATH)
   // DIRCHANGE(NEWPATH)
   ********* COPIA O ARQUIVO DE DEZEMBRO PARA 00 PARA PODER INICIAR O MES
   ARQFOL='FP'+EMP+'12.DBF'
   FOA='FP'+EMP+'00.DBF'
   FILEcopy(ARQFOL,FOA)


   MDS('Apagando as Folhas de Pagamento')
   ********* APAGA OS ARQUIVOS DA FOLHA E DIRETORIA
   FOR X=1 TO 12
      ARQFOL='FP'+EMP+STRZERO(X,2)
      if ! netzap(arqfol)
         RETU .F.
      ENDIF
      dbclosearea()
      ARQFOL='SO'+EMP+STRZERO(X,2)
      IF file(ARQFOL+".DBF")
         IF ! netzap(ARQFOL) 
            return .F.
         ENDIF
      ENDIF
   NEXT X

   
   //nao e necessario pois fica agora na fo_sal
   FOR X=1 TO 2
      IF X=1 
         ARQPES='FO_PES.DBF'
         MDS('Excluindo Funcionarios demitidos,Zerando Salarios')   
      ELSE
         ARQPES='FO_DIR.DBF'
         MDS('Excluindo diretores demitidos,Zerando Salarios')
      ENDIF
      IF file(ARQPES)
         if ! netuse("fo_sal")
            dbcloseall()
            retu .f.
         endif
         IF ! netuse(ARQPES,,.F.,,,.F.,)  
            DBCLOSEALL()
            RETU .F.
         ENDIF
         DBGOTOP()
         WHILE ! EOF()
            IF ! EMPTY(DEMITIDO)
               NETRECDEL()
            ELSE
               netreclock()
               /* nao e mais necessario pois fica na fol_sal
               REPL SALJAN WITH SALDEZ,SALFEV WITH 0.00,SALMAR WITH 0.00
               REPL SALABR WITH 0.00,SALMAI WITH 0.00,SALJUN WITH 0.00
               REPL SALJUL WITH 0.00,SALAGO WITH 0.00,SALSET WITH 0.00
               REPL SALOUT WITH 0.00,SALNOV WITH 0.00,SALDEZ WITH 0.00
               REPL MOT1 WITH " ",MOT2 WITH " ",MOT3 WITH " ",MOT4 WITH " "
               REPL MOT5 WITH " ",MOT6 WITH " ",MOT7 WITH " ",MOT8 WITH " "
               REPL MOT9 WITH " ",MOT10 WITH " ",MOT11 WITH " ",MOT12 WITH " "
               */
               REPL DATCONTSIN WITH CTOD("00/00/00")
               dbunlock()
            ENDIF
            xNUMERO:=NUMERO
            nSALANT:=0
            dbselectar("fo_sal")
            if dbseek(str(xnumero,8)+STR(nANOANT,4))
               nSALANT:=SALDEZ            
            endif
            if dbseek(str(xnumero,8)+STR(nANONOV,4))
               netreclock()
            else
               netrecapp()
               field->numero:=xNUMERO
               field->ano   :=nANONOV
            endif
            FIELD->SALJAN:=nSALANT
            dbunlock() 
            dbselectar(arqpes)
            DBSKIP()
         ENDDO
         pack
         dbselectar(arqpes)
         dbclosearea()
         dbselectar("fo_sal")
         dbclosearea()
      endif   
   NEXT X
   
   
   //Apagando Indices
   MATNTX=FILENAMES('*.'+cRDDEXT)
   nARQ=LEN(MATNTX)
   IF nARQ>0
      FOR X=1 TO nARQ
         FERASE(MATNTX[X])
      NEXT X
   ENDIF

   DBSELECTAR("FIRMA")
   DBSKIP()
ENDDO
HB_CWD(INIPATH)
// DIRCHANGE(INIPATH)
DBCLOSEALL()
NOBREAK()
@ 24,00 SAY "  Ok.- O novo ano ja  esta  inicializado.  "
INKEY(0)
RETU .T.




*: FIM: FOLIS_D7.PRG
