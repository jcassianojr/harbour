*:*****************************************************************************
*:
*:     FOIC1.PRG : LISTAR RESUMO GERENCIAL
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:14
*:
*:*****************************************************************************

function foic1
PARA CC
IF ! MDL('LISTAR RESUMO GERENCIAL')
   RETU
ENDIF
FILEcopy("AJUGER.DBF","AJUGERD.DBF")

DIV=1.00
MDS('Digite o divisor')
@ 24,35 GET DIV PICT '###,###.##'
READCUR()

POS1=SPAC(40)
MDS('DIGITE O NOME DO RESUMO')
@ 24,38 GET POS1
READCUR()

IF CC=1
   FILTRO='SETOR=0.AND.SECAO=0'
   TIPORES='Por Departamento'
ENDIF
IF CC=2
   FILTRO='SETOR<>0.AND.SECAO=0'
   TIPORES='Por Setor'
ENDIF
IF CC=3
   FILTRO='SETOR<>0.AND.SECAO<>0'
   TIPORES='Por Secao'
ENDIF

DECLARE TOTD[15],TOTS[15],TOTT[15]
AFILL(TOTD,0)
AFILL(TOTS,0)
AFILL(TOTT,0)

IF ! NETUSE("AJUGERD") 
   RETU
ENDIF

nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
DBEval( {|| netgrvcam("VL1",VL1/DIV) },, {|| zei_fort(nLASTREC,,,1)} )
zei_fort( nLASTREC,,,0)
DBEval( {|| netgrvcam("VL2",VL2/DIV) },, {|| zei_fort(nLASTREC,,,1)} )
zei_fort( nLASTREC,,,0)
DBEval( {|| netgrvcam("VL3",VL3/DIV) },, {|| zei_fort(nLASTREC,,,1)} )
zei_fort( nLASTREC,,,0)
DBEval( {|| netgrvcam("VL4",VL4/DIV) },, {|| zei_fort(nLASTREC,,,1)} )
zei_fort( nLASTREC,,,0)
DBEval( {|| netgrvcam("VL5",VL5/DIV) },, {|| zei_fort(nLASTREC,,,1)} )
zei_fort( nLASTREC,,,0)
DBEval( {|| netgrvcam("SALARIO",SALARIO/DIV) },, {|| zei_fort(nLASTREC,,,1)} )
zei_fort( nLASTREC,,,0)
DBEval( {|| netgrvcam("TURN",TURN/DIV) },, {|| zei_fort(nLASTREC,,,1)} )
zei_fort( nLASTREC,,,0)
ordDestroy("AJUGERD")
ordcreate(,"AJUGERD","CONTROLE ")
ordSetFocus("AJUGERD")


FI=TRIM(FILTRO)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO
DBGOTOP()
WHILE ! EOF()
   FOR Q=1 TO 5
      QTW='QT'+STR(Q,1)
      VLW='VL'+STR(Q,1)
      TOTT[Q]   +=&QTW.
      TOTT[Q+5] +=&VLW.
   NEXT X
   TOTT[11]+=ADM
   TOTT[12]+=DEM
   TOTT[13]+=ATI
   TOTT[14]+=SALARIO
   TOTT[15]+=TURN
   DBSKIP()
ENDDO

IF ! NETUSE("TILRESG",,,,,.F.,) 
   RETU
ENDIF

IF MDG('Deseja Gravar em Arquivo')
   //ARQUIVO='GERENCIAL.TXT'
   //MDS('Confirme o nome do Arquivo')
   //@ 24,40 GET ARQUIVO
   //READCUR()
   ARQUIVO:=WIN_GETSAVEFILENAME( , "Salvar Gerencial", HB_CWD(),"txt", "*.txt" , 1,, "gerencial.txt")
   USO=FCREATE(ARQUIVO)
   IF FERROR()#0
      ALERTX("Erro na Criacao do Arquivo")
      RETUrn .f.
   ENDIF
   FWRITE(USO,REPL('-',240)+CHR(13)+CHR(10))
   FWRITE(USO,'RESUMO GERENCIAL'+CHR(13)+CHR(10))
   FWRITE(USO,REPL('-',240)+CHR(13)+CHR(10))
   FWRITE(USO,"DEPT SET SEC NOME"+SPAC(12)+"ATI  ADM  DEM  ")
   FWRITE(USO,"SALARIO"+SPAC(14))
   DBSELECTAR("TILRESG")
   DBGOTOP()
   WHILE ! EOF()
      FWRITE(USO,TITULO+SPAC(17))
      DBSKIP()
   ENDDO
   FWRITE(USO,'TURNOVER'+CHR(13)+CHR(10))
   FWRITE(USO,SPAC(65))
   FOR X=1 TO 5
      FWRITE(USO,'HORAS      VALOR'+SPAC(13))
   NEXT X
   FWRITE(USO,CHR(13)+CHR(10))
   FWRITE(USO,REPL('-',240)+CHR(13)+CHR(10))
   DBSELECTAR("AJUGERD")
   DBGOTOP()
   WHILE ! EOF()
      MDS(NOME)
      FWRITE(USO,STR(DEPTO,4)+' ')
      FWRITE(USO,STR(SETOR,3)+' ')
      FWRITE(USO,STR(SECAO,3)+' ')
      FWRITE(USO,NOME+' ')
      FWRITE(USO,STR(ATI,4)+' ')
      FWRITE(USO,STR(ADM,4)+' ')
      FWRITE(USO,STR(DEM,4)+' ')
      FWRITE(USO,STR(SALARIO,18,2)+' ')
      FOR X=1 TO 5
         QTW='QT'+STR(X,1)
         VLW='VL'+STR(X,1)
         FWRITE(USO,STR(&QTW,9,2)+' ')
         FWRITE(USO,STR(&VLW,18,2)+' ')
      NEXT X
      FWRITE(USO,STR(TURN,18,2)+' '+CHR(13)+CHR(10))
      DBSKIP()
   ENDDO
   FWRITE(USO,REPL('-',240)+CHR(13)+CHR(10))
   FCLOSE(USO)
   DBCLOSEALL()
   RETU
ENDIF
IF MDG('Deseja em 132 colunas')
   FOIC1A()
ELSE
   FOIC1B()
ENDIF
RETU
*: FIM: FOIC1.PRG
