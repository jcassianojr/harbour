*:*****************************************************************************
*:
*:   RECUSER6.PRG: Criar Sequˆncia de C¢pias e Execut -la
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:41
*:
*:  Procs & Fncts: RECUSER6()
*:               : COPYTEL
*:               : COPYSAY
*:               : COPYGET
*:
*:          Chama: CABE2()            (fun‡„o    em RECUPROC.PRG)
*:               : COPYTEL            (processo  em RECUSER6.PRG)
*:               : COPYSAY            (processo  em RECUSER6.PRG)
*:               : COPYGET            (processo  em RECUSER6.PRG)
*:               : PESQ()             (fun‡„o    em RECUPROC.PRG)
*:               : RECUSER5()         (fun‡„o    em RECUSER5.PRG)
*:
*:     Arq. Dados: RECUCOPY - Backup configurado
*:
*:         Indice:  RECUCOPY   Nome do BACKUP
*:                             NOME
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************



#INCLUDE "BOX.CH"
PATWORK=HB_CWD() 
//DIRCHANGE(PATHX)
HB_CWD(PATHX)


PADRAO("RECUCOPY","RECUCOPY","mNOME+' '+mDIRETORIO","mNOME","Cadastro de Copia","Nome Copia",;
       {|| PEGCHAVE("mNOME",SPACE(6),"NOME")},{|| FOLCOPS() },{|| FOLCOPG()},{|nPOS| FOLCOPL(nPOS) },,4)
RETU .T.

FUNC FOLCOPL(nPOS)
mCHAVE:=aPAD2[nPOS]
IF ! IGUALVARS(cARQ,cIND,mCHAVE)
   RETU .F.
ENDIF
// DIRCHANGE(mDIRETORIO)
HB_CWD(mDIRETORIO)
RECUSER5(2)
// DIRCHANGE(PATWORK)
HB_CWD(PATWORK)
SETCOLOR("W/N")
RECUSER5(2)
RETU .T.


FUNC FOLCOPS
HB_dispbox( 8, 0, 21, 79,B_DOUBLE+" ")
@ 09,02 SAY "Nome:"+SPAC(10)+"Diretorio:"
@ 10,00 SAY 'Ç'+REPL('-',3)+"-"+REPL('-',74)+'¶'
@ 11,04 SAY "Ý  01 -"+SPAC(14)+"11 -"+SPAC(14)+"21 -"+SPAC(14)+"31 -"
@ 12,02 SAY "A Ý  02 -"+SPAC(14)+"12 -"+SPAC(14)+"22 -"+SPAC(14)+"32 -"
@ 13,02 SAY "R Ý  03 -"+SPAC(14)+"13 -"+SPAC(14)+"23 -"+SPAC(14)+"33 -"
@ 14,02 SAY "Q Ý  04 -"+SPAC(14)+"14 -"+SPAC(14)+"24 -"+SPAC(14)+"34 -"
@ 15,02 SAY "U Ý  05 -"+SPAC(14)+"15 -"+SPAC(14)+"25 -"+SPAC(14)+"35 -"
@ 16,02 SAY "I Ý  06 -"+SPAC(14)+"16 -"+SPAC(14)+"26 -"+SPAC(14)+"36 -"
@ 17,02 SAY "V Ý  07 -"+SPAC(14)+"17 -"+SPAC(14)+"27 -"+SPAC(14)+"37 -"
@ 18,02 SAY "O Ý  08 -"+SPAC(14)+"18 -"+SPAC(14)+"28 -"+SPAC(14)+"38 -"
@ 19,02 SAY "S Ý  09 -"+SPAC(14)+"19 -"+SPAC(14)+"29 -"+SPAC(14)+"39 -"
@ 20,04 SAY "Ý  10 -"+SPAC(14)+"20 -"+SPAC(14)+"30 -"+SPAC(14)+"40 -"
@ 21,04 SAY "-"
RETU .T.

FUNC FOLCOPG
@ 09,08 SAY mNOME
@ 09,28 GET mDIRETORIO VALID ! EMPTY(mDIRETORIO)
READCUR()
@ 11,12 GET mARQ01
@ 12,12 GET mARQ02
@ 13,12 GET mARQ03
@ 14,12 GET mARQ04
@ 15,12 GET mARQ05
@ 16,12 GET mARQ06
@ 17,12 GET mARQ07
@ 18,12 GET mARQ08
@ 19,12 GET mARQ09
@ 20,12 GET mARQ10
READCUR()
@ 11,30 GET mARQ11
@ 12,30 GET mARQ12
@ 13,30 GET mARQ13
@ 14,30 GET mARQ14
@ 15,30 GET mARQ15
@ 16,30 GET mARQ16
@ 17,30 GET mARQ17
@ 18,30 GET mARQ18
@ 19,30 GET mARQ19
@ 20,30 GET mARQ20
READCUR()
@ 11,48 GET mARQ21
@ 12,48 GET mARQ22
@ 13,48 GET mARQ23
@ 14,48 GET mARQ24
@ 15,48 GET mARQ25
@ 16,48 GET mARQ26
@ 17,48 GET mARQ27
@ 18,48 GET mARQ28
@ 19,48 GET mARQ29
@ 20,48 GET mARQ30
READCUR()
@ 11,66 GET mARQ31
@ 12,66 GET mARQ32
@ 13,66 GET mARQ33
@ 14,66 GET mARQ34
@ 15,66 GET mARQ35
@ 16,66 GET mARQ36
@ 17,66 GET mARQ37
@ 18,66 GET mARQ38
@ 19,66 GET mARQ39
@ 20,66 GET mARQ40
READCUR()
RETU .T.