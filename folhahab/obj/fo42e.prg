*:*****************************************************************************
*:
*:      FO42E.PRG: Cadastro de Funcon rios (Modulo Calcula - Refaz Calculos de Salarios
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/07/94     15:03
*:
*:*****************************************************************************


function fo42e
PARA CC
IF ! netuse("FO_PSL") //AREDE("FO_PSL","FO_PSL",0)
   RETU
ENDIF
FILTRO=FILTRO('')
SET FILTER TO &FILTRO
DBGOTOP()

IF CC=0
   CABEX('MODULO REFAZ CALCULOS DOS SALARIOS DO CADASTRO')
   IF MDG('TEM CERTEZA QUE QUER CONTINUAR ? (S/N):')   
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      MDS('AGUARDE UM INSTANTE RECALCULANDO. . .')
      DBEVAL({ || netgrvcam("SALATU",SALANT+(SALANT*TAXA1*0.01)) },, {|| zei_fort(nLASTREC,,,1)})
      zei_fort( nLASTREC,,,0)
      DBEVAL({ || netgrvcam("SALPRO",SALATU+(SALATU*TAXA2*0.01)) },, {|| zei_fort(nLASTREC,,,1)})
   ENDIF
ENDIF

IF CC=1
   TAREDE=0
   MDS('QUAL A TAXA DE REAJUSTE DESEJADA :')
   @ 23,40 GET TAREDE PICTURE '999.99%'
   READCUR()
   MDS('EFETUANDO MUDANCAS . . .')
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netgrvcam("TAXA1",tAREDE) },, {|| zei_fort(nLASTREC,,,1)})
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netgrvcam("SALATU",SALANT+(SALANT*TAXA1*.01)) },, {|| zei_fort(nLASTREC,,,1)})
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netgrvcam("SALPRO",SALATU+(SALATU*TAXA2*.01)) },, {|| zei_fort(nLASTREC,,,1)})
ENDIF

IF CC=2
   TAPRODE=0
   MDS('QUAL A TAXA DE PROJECAO DESEJADA :')
   @ 23,40 GET TAPRODE PICTURE '999.99%'
   READCUR()
   MDS('EFETUANDO MUDANCAS . . .')
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netgrvcam("TAXA2",TAPRODE) },, {|| zei_fort(nLASTREC,,,1)})
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netgrvcam("SALPRO",SALATU+(SALATU*TAXA2*.01)) },, {|| zei_fort(nLASTREC,,,1)})
ENDIF
DBCLOSEALL()
RETU

*: FIM: FO42E.PRG
