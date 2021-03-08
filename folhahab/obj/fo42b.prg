*:*****************************************************************************
*:
*:      FO42B.PRG: Dados Planilha Salarial
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/07/94     14:50
*:
*:  Procs & Fncts: FO42B()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:
*:     Arq. Dados: FO_PSL - Proje‡„o Salarial
*:                 FUNCAO - Arquivo de Fun‡”es
*:
*:        Indices: FUNCOD   Codigo da Funcao
*:                          CODIGO
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************



** FO4M * DADOS PLANILHA.SALARIAL
CABEX('LANCANDO DADOS DE PROJECAO')
STORE 0 TO NSALAT,NSALAP,NTAXA1,NTAXA2,NUME

IF ! NETUSE(PES) //AREDE(PES,PES,0)
   RETU
ENDIF
FILTRO='EMPTY(DEMITIDO)'
SET FILTER TO &FILTRO

IF ! NETUSE("FO_PSL") //AREDE("FO_PSL","FO_PSL",0)
   RETU
ENDIF

IF ! NETUSE("FUNCAO") //AREDE("FUNCAO","FUNCAO",0)
   RETU
ENDIF
@ 07,00 SAY "+-----------------------Ñ------------------------------------------------------+"
@ 08,00 SAY "Ý                       Ý  Nome:"+SPAC(47)+"Ý"
@ 09,00 SAY "Ý  C¢digo:              +------------------------------------------------------¶"
@ 10,00 SAY "Ý                       Ý  Admitido:           Fun‡„o:                         Ý"
@ 11,00 SAY "Ý-----------------------Ï------------------------------------------------------Ý"
@ 12,00 SAY "Ý"+SPAC(78)+"Ý"
@ 13,00 SAY "Ý"+SPAC(35)+"Sal rio Anterior  :                        Ý"
@ 14,00 SAY "Ý"+SPAC(78)+"Ý"
@ 15,00 SAY "Ý  Taxa Proje‡„o 1:          ---"+CHR(16)+"   Sal rio Proje‡„o 1:                        Ý"
@ 16,00 SAY "Ý"+SPAC(78)+"Ý"
@ 17,00 SAY "Ý  Taxa Proje‡„o 2:          ---"+CHR(16)+"   Sal rio Proje‡„o 2:                        Ý"
@ 18,00 SAY "Ý"+SPAC(78)+"Ý"
@ 19,00 SAY "+------------------------------------------------------------------------------+"
@ 09,12 GET NUME PICT '######'
READCUR()

DBSELECTAR("FO_PSL")
DBGOTOP()
IF ! DBSEEK( NUME)
   dbselectar(pes)
   DBGOTOP()
   IF DBSEEK(NUME)
      xMES='JAN'
      MDS('DIGITE O MES REFERENCIA EM 3 LETRAS EX: JAN')
      @ 24,60 GET XMES
      READCUR()
      XMES=UPPER(XMES)
      SALMES='SAL'+XMES
      GRVPSL()
   ELSE
      MDT('Funcion rio n„o encontrado')
      DBCLOSEALL()
      RETU
   ENDIF
ENDIF
DBSELECTAR("FO_PSL")
NETRECLOCK()
@ 08,33 SAY NOME
@ 10,37 SAY ADMITIDO
@ 10,55 SAY FUNCAO
@ 13,57 SAY SALANT PICTURE '###,###,###.##'
@ 15,57 SAY SALATU PICTURE '###,###,###.##'
@ 17,57 SAY SALPRO PICTURE '###,###,###.##'
@ 15,20 GET TAXA1 PICTURE '###.##'
@ 17,20 GET TAXA2 PICTURE '###.##'
READCUR()
FIELD->SALATU:=SALANT+(SALANT*TAXA1*.01)
FIELD->SALPRO:=SALATU+(SALATU*TAXA2*.01)
@ 15,57 GET SALATU PICTURE '###,###,###.##'
@ 17,57 GET SALPRO PICTURE '###,###,###.##'
READCUR()
dbunlock()
DBCLOSEALL()
RETU
*: FIM: FO42B.PRG
