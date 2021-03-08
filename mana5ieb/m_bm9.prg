*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BM9.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function m_bm9
para cARQPRI
MDI( "Resumo Checagem de Cabec rios Itens")
if !CHECKIMP( 0 )
   retu .F.
endif

CTLIN    := 80

IF cARQPRI="MM01"
   aRETU   := PERFEC( {"MM01","MM02"}, {"M1", "M2" }, { "MM91", "MM92" } )
ELSE
   aRETU   := PERFEC( {"MK01","MK02"}, {"K1", "K2" }, { "MK91", "MK92" } )
ENDIF

nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cCAB    := aRETU[ 7 ]
ARQWORK1 :=aRETU[ 5, 1 ]
ARQWORK2 :=aRETU[ 5, 2 ]

IF ! USEMULT({{ARQWORK1, 1, 99 },{ARQWORK2, 1, 99 }})
   retu .F.
endif

mds("Valores")
IMPRESSORA()
dbselectar( ARQWORK2 )
nLASTREC:=LASTREC()
dbgotop()
while !eof()
   xNUMERO := if( cARQPRI = "MM01", NUMERO, NRNOTA )
   xFORNECEDO:=FORNECEDO
   nTOTMER := nTOTIPI := nTOTNF := 0
   while xNUMERO = if( cARQPRI = "MM01", NUMERO, NRNOTA ).AND.IF( cARQPRI = "MM01",.T.,xFORNECEDO=FORNECEDO) .and. !eof()
      nTOTMER += VALORMER
      nTOTIPI += VALORIPI
      nTOTNF  += VALORTOT
      VIDEO()
      ZEI_FORT(nLASTREC)
      IMPRESSORA()
      dbskip()
   enddo
   m_BM9CAB()
   dbselectar( ARQWORK1 )
   dbgotop()
   IF ! dbseek( IF(cARQPRI="MK01",STR(xNUMERO,8)+STR(xFORNECEDO,5),xNUMERO) )
      m_BM9CAB()
      @ CTLIN,  0 say "Nota Fiscal n„o Encontrada -> " + str( xNUMERO, 8 )
      CTLIN ++
      VIDEO()
      IF MDG("NF n„o Encontrada -> " + str( xNUMERO, 8 )+" Apagar")
         netrecdel()
      ENDIF
      IMPRESSORA()
   else
      if round( nTOTMER, 2 ) # round( TOTMER, 2 ) .or. ;
                round( nTOTIPI, 2 ) # round( TOTIPI, 2 ) .or. ;
                round( nTOTNF, 2 ) # round( TOTNF, 2 )
         m_BM9CAB()
         @ CTLIN,  0 say str( xNUMERO, 8 ) + " Cabecario"
         @ CTLIN, 20 say TOTMER                           pict "@E 999,999,999.99"
         @ CTLIN, 40 say TOTIPI                           pict "@E 999,999,999.99"
         @ CTLIN, 60 say TOTNF                            pict "@E 999,999,999.99"
         CTLIN ++
         @ CTLIN,  0 say str( xNUMERO, 8 ) + " Itens    "
         @ CTLIN, 20 say nTOTMER                          pict "@E 999,999,999.99"
         @ CTLIN, 40 say nTOTIPI                          pict "@E 999,999,999.99"
         @ CTLIN, 60 say nTOTNF                           pict "@E 999,999,999.99"
         CTLIN ++
      endif
   endif
   dbselectar( ARQWORK2 )
enddo
VIDEO()
MDS( "Fixando Apura‡„o" )
IMPRESSORA()
dbselectar( ARQWORK1 )
nLASTREC:=LASTREC()
dbgotop()
while !eof()
   yAPURA  := APURA
   mCOD:="" //Vazio Padrao para apura N
   xNUMERO := if( cARQPRI = "MM01", NUMERO, NRNOTA )
   xFORNECEDO=FORNECEDO
   yESPECIE := ESPECIE
   nTOTNF   := 0
   IF cARQPRI="MK01"
       IF yAPURA="S"
          IF EMPTY(COD) //Tenta Itens NF
             mCOD:=LEFT(OBTER("MK02",xNUMERO,"CODDEP",4),3)
              IF ! EMPTY(mCOD)
                 GRAVACAMPO("COD","mCOD",,,.F. )
              ENDIF
              IF EMPTY(COD) //Tenta Cadastro Fornecedor
                 mCOD:=LEFT(OBTER("MB01",FORNECEDO,"CTACONTB"),3)
                 IF ! EMPTY(mCOD)
                    GRAVACAMPO("COD","mCOD",,,.F. )
                 ENDIF
              ENDIF
           ELSE
              mCOD:=COD           //Pega o Codigo Gravado
          ENDIF
       ELSE
          GRAVACAMPO("COD","SPACE(3)",,,.F.)
       ENDIF
   ENDIF

   dbselectar( ARQWORK2 )
   dbgotop()
   IF cARQPRI="MM01"
      dbseek( str( xNUMERO, 8 ) )
   ELSE
      dbseek( str( xNUMERO, 8 )+STR(xFORNECEDO,5) )
   ENDIF
   while if( cARQPRI = "MM01", NUMERO, NRNOTA ) = xNUMERO.AND.IF( cARQPRI = "MM01",.T.,xFORNECEDO=FORNECEDO) .and. ! eof()
      if APURA # yAPURA
         gravacampo("APURA","yAPURA",,,.F. )
         m_bm9cab()
         @ CTLIN,  0 say "Nota Fiscal " + str( xNUMERO, 8 ) + " Sequencia " + str( IF(CARQPRI="MK01",ITEM,SEQ), 3 ) + " Erro apura Fixado"
         CTLIN ++
      endif
      if FORNECEDO # xFORNECEDO
         gravacampo("FORNECEDO","xFORNECEDO",,,.F. )
         m_bm9cab()
         @ CTLIN,  0 say "Nota Fiscal " + str( xNUMERO, 8 ) + " Sequencia " + str( IF(CARQPRI="MK01",ITEM,SEQ), 3 ) + " Erro No.Cli/Fornecedo Fixado"
         CTLIN ++
      endif
      IF cARQPRI<>"MK01"
         IF ESPECIE # yESPECIE
            gravacampo("ESPECIE","yESPECIE",,,.F. )
            m_bm9cab()
            @ CTLIN,  0 say "Nota Fiscal " + str( xNUMERO, 8 ) + " Sequencia " + str( IF(CARQPRI="MK01",ITEM,SEQ), 3 ) + " Erro especie Fixado"
            CTLIN ++
         ENDIF
      ENDIF
      IF cARQPRI="MK01"
          IF yAPURA="S".AND.EMPTY(CODDEP)
             IF ! EMPTY(mCOD)
                GRAVACAMPO("CODDEP","mCOD",,,.F. )
             ELSE
                IF TIPOENT $ 'MCORPS'
                   mCODDEP:=LEFT(OBTER(ESTQARQ(TIPOENT,1),CODIGO,"CTACONTB"),3)
                   IF ! EMPTY(mCODDEP)
                      GRAVACAMPO("CODDEP","mCODDEP",,,.F.)
                   ENDIF
                ENDIF
             ENDIF
          ENDIF
          IF yAPURA="N"
             GRAVACAMPO("CODDEP","SPACE(3)",,,.F. )
          ENDIF
      ENDIF
      IF CFONEW="5101".OR.CFONEW="6101".or.CFONEW="5102".OR.CFONEW="6102"
         IF TIPOSERV<>"1"
            m_bm9cab()
            @ CTLIN,  0 say "Nota Fiscal " + str( xNUMERO, 8 ) + " Sequencia " + str( IF(CARQPRI="MK01",ITEM,SEQ), 3 ) +" "+CFONEW+" Servico "+TIPOSERV
            CTLIN++
         ENDIF
      ENDIF
      IF CFONEW="5124".OR.CFONEW="6124"
         IF TIPOSERV<>"3"
            m_BM9CAB()
            @ CTLIN,  0 say "Nota Fiscal " + str( xNUMERO, 8 ) + " Sequencia " + str( IF(CARQPRI="MK01",ITEM,SEQ), 3 ) +" "+CFONEW+" Servico "+TIPOSERV
            CTLIN++
         ENDIF
      ENDIF
      dbskip()
   enddo
   dbselectar( ARQWORK1 )
   dbskip()
   VIDEO()
   ZEI_FORT(nLASTREC)
   IMPRESSORA()
enddo
IMPFOL()
VIDEO()
dbcloseall()
IMPEND()

FUNC m_BM9CAB()
if CTLIN > 50
   @  0,  0 say "Checagem itens Cabecarios Nota Fiscal"
   @  1,  0 say repl( "=", 80 )
   CTLIN := 2
endif

*+ EOF: M_BM9.PRG
