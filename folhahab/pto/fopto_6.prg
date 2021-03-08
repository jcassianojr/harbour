*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\FOLHA\PTO\FOPTO_6.PRG
*+
*+    Reformatted by Click! 2.03 on Jul-30-2001 at  1:38 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн



//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"

IF ZFECHADO="S"
   ALERTX("Mes ja Fechado")
ENDIF

while .T.
   CABE3( ' FOPTO_4U - Banco de Horas'+if(lSeCBCO,"Anterior","Atual"), 23 )
   OPCAO( 04, 01, " &A - Consultar                   ", 65, " Consultar Banco de Horas                      " )
   OPCAO( 05, 01, " &B - Apagar   Competencia        ", 66, " Apaga Uma Competencia Banco de Horas          " )
   OPCAO( 06, 01, " &C - Arquivar Demitidos          ", 67, " Arquiva Banco Horas Demitidos                 " )
   OPCAO( 07, 01, " &D - Arquivar Um ano             ", 68, " Arquiva Um Ano Banco de Hora                  " )
   OPCAO( 08, 01, " &E - Arquivar Competencia MesAno ", 69, " Arquiva uma competencia mes/ano               " )
   OPCAO( 09, 01, " &F - Arquivar Um Funcionario     ", 70, " Arquiva Um Funcionario Banco de Hora          " )
   OPCAO( 10, 01, " &G - Consulta Banco Hrs Arquivado", 71, " Consultar Banco de Horas Arquivado            " )
   OPCAO( 11, 01, " &H - Retornar Demitidos          ", 72, " Retorna Banco Horas Demitidos                 " )
   OPCAO( 12, 01, " &I - Retornar Um ano             ", 73, " Retorna Um Ano Banco de Hora                  " )
   OPCAO( 13, 01, " &J - Retornar Competencia MesAno ", 74, " Retorna uma competencia mes/ano               " )
   OPCAO( 14, 01, " &K - Retornar Um Funcionario     ", 75, " Retorna Um Funcionario Banco de Hora          " )
   OPCAO( 15, 01, " &L - Importar Saldo Ponto/BcoHrs ", 76, " Transferei saldo horas Ponto para Banco Horas " )
   OPCAO( 16, 01, " &M - Zerar Saldo Horas Competenc ", 77, " Zera os Valores das Horas de uma Competencia  " )
   OPCAO( 17, 01, " &N - Zerar Saldo Dias  Competenc ", 78, " Zera os Valores de dia De  uma Competencia    " )
   OPCAO( 04, 41, " &1 - Requisicoes Banco Horas     ", 49, " Requisicoes Banco Horas                       " )
   OPCAO( 05, 41, " &2 - Multiplas Requisicao Bco Hrs", 50, " Multiplos Lancamentos Requisicoes Banco Horas " )
   OPCAO( 06, 41, " &3 - Exportar saldo arquivo txt  ", 51, "                                               " )
   OPCAO( 07, 41, " &4 - Exportar saldo folha        ", 52, "                                               " )
   OPCAO( 08, 41, " &5 - Troca Atual por Anterior    ", 53, "                                               " )
   OPCAO := menu( 1, 24 )
   if ZUSER <> "SUPERVISOR" .and. ZUSER <> "SOFTEC" .and. OPCAO > 0
      if !VERSEHA( "MUSERM", , USERMCRI( ZUSER, "F", OPCAO ) )
         ALERTX( "Voce nAo tem acesso, Verifique com o Supervisor" )
         loop
      endif
   endif
   IF ZFECHADO="S"
      if OPCAO=16 .or. OPCAO=2 .OR. OPCAO=12 .OR. OPCAO=13 .OR. OPCAO=14
         ALERTX("Mes ja Fechado")
         loop
      endif
   ENDIF

   DO CASE
      CASE OPCAO=1 //A Consulta Atual
           FOPTO_4R(1)
      CASE OPCAO=2 //B Apaga Competencia
           FOPTO4Q02()
      CASE OPCAO=3 //C Arquiva Demitido
           fopto4u(1,1)
      CASE OPCAO=4 //D Arquiva Ano
           fopto4u(2,1)
      CASE OPCAO=5 //E Arquiva Mes Ano
           fopto4u(3,1)
      CASE OPCAO=6 //F Arquiva Funcionario
           fopto4u(4,1)
      CASE OPCAO=7 //G Consulta Baixados
           FOPTO_4R(2)
      CASE OPCAO=8 //H Retorna Demitidos
           fopto4u(1,2)
      CASE OPCAO=9 //I Retorna Ano
           fopto4u(2,2)
      CASE OPCAO=10 //J Retorna mes ano
           fopto4u(3,2)
      CASE OPCAO=11 //K Retorna funcionario
           fopto4u(4,2)
      case OPCAO = 12 //L Importar Saldo Ponto/BcoHrs
           FOPTO_4S()
      case OPCAO = 13 //M zera horas
           fopto4u(5,1)
      case OPCAO = 14 //N zera dias
           fopto4u(6,1)
      case OPCAO = 15 //1 requisicao banco de horas
           FOPTO_4Q()
      case OPCAO = 16  //2 - Multiplos Banco Horas
           FOPTO_4K()
     case OPCAO = 17  //3
           FOPTO_25(5)  // Saldo Banco Horas->arquivo.txt
     case OPCAO = 18  //4
           FOPTO_25(6)  // Saldo Banco Horas->folha
     case opcao = 19 //5
          IF ! lSeCBCO
             lSECBCO:=.T.  //Controle de Banco de Horas Anterior
             ALERTX("Controle Banco Horas Anterior-Ativado")
          ELSE
             lSECBCO:=.F.
             ALERTX("Controle Banco Horas Anterior-Desativado")
         ENDIF
    OTHERWISE
      retu
   endcase
enddo



function fopto4u(nTIPO,nOPR)
PCK:=.T.
IF nOPR=3.OR.nOPR=4
  CABE3( ' н Manutencao Provisorios', 23 )
ELSE
  CABE3( ' н Manutencao Banco de Horas', 23 )
ENDIF
if nTIPO = 1
   if ! netuse(pes)
      retu .F.
   endif
endif
if nTIPO = 2.or.nTIPO=3.or.nTIPO=5.or.nTIPO=6
   nANO := year( date())
   nMES := month(date())
   @ 24, 00 say "ANO"
   @ 24, 10 get nANO
   IF nTIPO=3.or.nTIPO=5.or.nTIPO=6
      @ 24, 20 say "Mes"
      @ 24, 30 get nMES
   ENDIF
   if !READCUR()
      retu .F.
   endif
endif
IF nTIPO=4
   nNUMERO:=0
   set key K_F11 to TECLAF11
   @ 24,00 SAY "Numero Funcionario"
   @ 24,30 GET nNUMERO
   if !READCUR()
       set key K_F11
       retu .F.
   endif
   set key K_F11
ENDIF

cARQ:="XXXX"
cARQBX:="XXXX"
IF nOPR=1 //Atuais->Arquivados
   carq:=IF(lSECBCO,"BCOBAK","BCOHRS")
   carqbx:=IF(lSECBCO,"BCODEK","BCODEM")
ENDIF
IF nOPR=2 //Arquivados->Atuais
   carq:=IF(lSECBCO,"BCODEK","BCODEM")
   carqbx:=IF(lSECBCO,"BCOBAK","BCOHRS")
ENDIF
IF nOPR=3 //Provisorios //Atuais->Arquivados
   carq:= "FOPTOPRO"
   carqbx:="FOPTOPRD"
ENDIF
IF nOPR=4 //Provisorios //Arquivados->Atuais
   carq:= "FOPTOPRD"
   carqbx:="FOPTOPRO"
ENDIF



if ! netuse(CArq)
   dbcloseall()
   retu .F.
endif
INITVARS()
CLRVARS()

if ! netuse(carqbx)
   dbcloseall()
   retu .F.
endif

if nTIPO = 1
   dbselectar( PES )
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   dbgotop()
   while !eof()
      PETELA( 8 )
      if !empty( DEMITIDO )
         PETELA( 14 )
         mNUMERO := NUMERO
         mDATA   := DEMITIDO
         mDATA ++
         dbselectar(Carq)
         dbgotop()
         dbseek( str( mNUMERO, 8 ) )
         while mNUMERO = if(nopr<3,NUMERO,DESTINO) .and. !eof()
            fopto4ugrv()
            //zei_fort()
            dbselectar(Carq)
            dbskip()
         enddo
      endif
      dbselectar( PES )
      zei_fort(nLASTREC,,,1)
      dbskip()
   enddo
   dbcloseall()
   netpack(cARQ)
endif
IF nTIPO=2.or.nTIPO=3.or.nTIPO=5.or.nTIPO=6
   dbselectar(Carq)
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   dbgotop()
   while !eof()
      IF nopr>2
         ANO=YEAR(DATA)
         MES=MONTH(DATA)
      ENDIF
      IF ANO=nANO.AND.IF(nTIPO=2,.T.,MES=nMES)
         DO CASE
            CASE nTIPO=5
                 netreclock()
                 FIELD->SALANT:=0
                 FIELD->CREDITO:=0
                 FIELD->DEBITO:=0
                 FIELD->SALDO:=0
                 DBUNLOCK()
            CASE nTIPO=6
                 netreclock()
                 FIELD->DIAANT:=0
                 FIELD->DIACRE:=0
                 FIELD->DIADEB:=0
                 FIELD->DIASAL:=0
                 DBUNLOCK()
            OTHERWISE
                 fopto4ugrv()
         ENDCASE
      endif
      dbselectar(Carq) //sele 2
      dbskip()
      zei_fort(nLASTREC,,,1)
      //zei_fort()
   enddo
   dbcloseall()
   netpack(carq)
ENDIF
IF nTIPO=4
   dbselectar(Carq)
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   dbgotop()
   while !eof()
      IF if(nopr<3,NUMERO,DESTINO)=nNUMERO
         fopto4ugrv()
      endif
      dbselectar(Carq) 
      dbskip()
      zei_fort(nLASTREC,,,1)
      //zei_fort()
   enddo
   dbcloseall()
   netpack(carq)
ENDIF


function fopto4ugrv
EQUVARS()
dbselectar(Carqbx)
netrecapp()
REPLVARS(.F.)
dbselectar(Carq)
netrecdel()
return .t.



