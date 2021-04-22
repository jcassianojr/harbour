*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BY3.PRG
*+
*+    Functions: Function MBY301()
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

MDI( " Э Ficha do Produto" )
CTLIN   := 80
nGERITE := 0
nGERMED := 0
nGERQTD := 0
nCORTE  := 125
FILTRO  := ''
FILTRO  := RFILORD( "MY03TMP", .F. )
aLAY    := PEGLAY( "MEXPOR1", "MBY301" )
aRETU   := PERFEC( { "MY03" }, { "Y3" }, { "Y399" }, { "DATOPR" } )
cARQ    := aRETU[ 5, 1 ]
cCAB    := aRETU[ 7 ]
lANAL   := MDG( "Deseja Analitico" )
lPRO    := MDG( "Resumo do Produto" )
lGER    := MDG( "Resumo Geral" )
lGRA    := .F.
if aRETU[ 6 ] = 2   //Mes Fechado
   if MDG( "Gravar Apura‡„o" )
      lGRA := SENHAX( "MBY003" )
   endif
endif

//nHANDT:=FCREate("teste.txt")
 
dINI := dFIM := zDATA
MDS( "Confirme o Periodo %Corte" )
@ 24, 30 get dINI
@ 24, 40 get dFIM
@ 24, 50 get nCORTE pict "999.99"
if !READCUR()
   retu .F.
endif

if !CHECKIMP( 0 )
   retu .F.
endif
//cAE := IMP( "AE" )
//cAC := IMP( "AC" )
cAE := aCHR[2]
cAC := aCHR[1]


ZAPARQ( { { "MY03TMP", .F., .F. } } )

if !USEMULT( { { "MS01", 1, 1 }, { "MS06", 1, 1 }, { cARQ, 1, 1 } ,{"MB01",1,1}} )
   retu .F.
endif

if lGRA
   if !USEREDE( "RDT", 0, 99 )
      dbcloseall()
      retu .F.
   endif
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netrecdel()},{|| ANO = aRETU[ 2 ] .and. MES = aRETU[ 1 ]}, {|| zei_fort(nLASTREC,,,1)})
   pack
endif

IF MDG("Checar Codigos Internos")
   dbselectar("MS06")
   dbsetorder(6)
   dbselectar(carq)
   dbsetorder(5)
   dbgotop()
   while ! eof()
       cCODIGOINT:=CODIGOINT
       cCODIGO:=""
       nSEQ:=0
       nSSQ:=0
       dbselectar("MS06")
       dbgotop()
       if dbseek(cCODIGOINT)
          cCODIGO=CODIGO
          nSEQ:=SEQ
          nSSQ:=SSQ 
       endif
       dbselectar(carq)
       while cCODIGOINT=CODIGOINT.AND.! EOF()
          if Empty(codigo).and.! empty(cCODIGO).and. ! empty(CODIGOINT)
             netreclock()
             FIELD->CODIGO:=cCODIGO
             FIELD->SEQ:=nSEQ
             FIELD->SSQ:=nSSQ
             DBUNLOCK()
          endif 
          dbskip()
       enddo      
   enddo
   dbselectar("MS06")
   dbsetorder(1)
   dbselectar(carq)
   dbsetorder(1)
endif

dbselectar( cARQ )
dbgotop()
while !eof()
   if DATOPR >= dINI .and. DATOPR < dFIM
      MBY301( CODIGO )
      dbselectar( cARQ )
      MBY301( CODIG2 )
   endif
   dbselectar( cARQ )
   dbskip()
enddo
dbselectar( cARQ )
dbclosearea()

IMPRESSORA()
dbselectar( "MY03TMP" )
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
while !eof()
   cCODIGO := CODIGO
   lCOD    := .T.
   mNOME   := ""
   nITEM   := 0
   nMEDIA  := 0
   nQTDP   := 0
   dbselectar( "MS01" )
   dbgotop()
   if dbseek( cCODIGO )
      mNOME := NOME
   endif
   VIDEO()
   IMPRESSORA()
   dbselectar( "MY03TMP" )
   while cCODIGO = CODIGO .and. !eof()
      mSEQ    := SEQ
      mSSQ    := SSQ
      lSEQ    := .T.
      nHORAS  := 0
      nQTDDE  := 0
      mDOPER  := ""
      mPCHORA := 0
      mPCHOR3 := 0
      mPCHOR4 := 0
      nDIA    := DATOPR
      dbselectar( "MS06" )
      dbgotop()
      if dbseek( cCODIGO + str( mSEQ, 3 ) + str( mSSQ, 3 ) )
         IF nDIA>=DATAINI
            mDOPER  := if( lANAL, left( DESCRI, 60 ), left( DESCRI, 40 ) )
            mPCHORA := PCHORA
            mPCHOR3 := PCHOR3
            mPCHOR4 := PCHOR4
         ENDIF
      endif
      dbselectar( "MY03TMP" )
      while cCODIGO = CODIGO .and. mSEQ = SEQ .and. mSSQ = SSQ .and. !eof()
         VIDEO()
         @ 24, 00 say cCODIGO
         @ 24, 30 say mSEQ
         @ 24, 35 say mSSQ
         IMPRESSORA()
         if CTLIN > 55
            @  0,  0 say cAE + "Ficha do Produto"
            @  1,  0 say cAC + "M_BY3"
            @  1, 10 say "Competencia: " + cCAB
            @  2, 10 say "Periodo: " + dtoc( dINI ) + " a " + dtoc( dFIM )
            @  2, 60 say time()
            @  2, 70 say ZDATA
            @  3, 00 say "Data"
            @  3, 10 say "Qtdde"
            @  3, 20 say "Horas"
            @  3, 30 say "Media"
            @  4,  0 say repl( "-", 80 )
            CTLIN := 5
            lSEQ  := .T.
            lCOD  := .T.
         endif
         if lCOD
            @ CTLIN,  0 say repl( "-", 80 )
            CTLIN ++
            @ CTLIN,  0 say "Produto: " + left( cCODIGO, 15 )
            @ CTLIN, 30 say mNOME
            CTLIN ++
            @ CTLIN,  0 say repl( "-", 80 )
            CTLIN ++
            lCOD := .F.
         endif
         if lSEQ .and. lANAL
            @ CTLIN,  0 say mSEQ
            @ CTLIN,  4 say mSSQ
            @ CTLIN,  9 say mDOPER
            CTLIN ++
            if mPCHOR3 > 0
               @ CTLIN,  0 say "Tempo Padrao Ajustado para Calculo (Pe‡a Simetrica): Real=" + str( mPCHOR3 )
               CTLIN ++
            endif
            lSEQ := .F.
         endif
         dbselectar( "MY03TMP" )
         if lANAL
            @ CTLIN, 00 say DATOPR
            @ CTLIN, 09 say QTDDE                     pict "999999999"
            @ CTLIN, 19 say HORAS                     pict "9999.99"
            @ CTLIN, 27 say round( QTDDE / HORAS, 2 ) pict "9999999.99"
            CTLIN ++
         endif
         nHORAS += HORAS
         nQTDDE += QTDDE
         dbskip()
      enddo
      nAPURA := 0
      if nQTDDE > 0 .and. nHORAS > 0
         nAPURA := round( nQTDDE / nHORAS, 2 )
      endif
      mMEDIA := 0
      mCORTE := 0
      mMEDI4 := 0
      mCORT4 := 0
      mMEDIA := PERC( nAPURA, mPCHORA )
      if mMEDIA > nCORTE
         mCORTE := mMEDIA
         mMEDIA := nCORTE
      endif
      mMEDI4 := PERC( nAPURA, mPCHOR4 )
      if mMEDI4 > nCORTE
         mCORT4 := mMEDI4
         mMEDI4 := nCORTE
      endif
      if lANAL
         @ CTLIN,  0 say "Total Dia"
      else
         @ CTLIN,  0 say mSEQ
         @ CTLIN,  4 say mSSQ
      endif
      @ CTLIN,  9 say nQTDDE  pict "999999999"
      @ CTLIN, 19 say nHORAS  pict "9999.99"
      @ CTLIN, 27 say nAPURA  pict "999999.99"
      @ CTLIN, 37 say mPCHORA pict "99999"
      @ CTLIN, 47 say mMEDIA  pict "9999.99"
      if mCORTE > 0
         @ CTLIN, 57 say mCORTE pict "9999.99"
      endif
      CTLIN ++
      if !lANAL
         @ CTLIN, 00 say left( mDOPER, 80 )
         CTLIN ++
         if mPCHOR3 > 0
            @ CTLIN,  0 say "Tempo Padrao Ajustado para Calculo (Pe‡a Simetrica): Real=" + str( mPCHOR3 )
            CTLIN ++
         endif
      endif
      if mSEQ > 0 .and. mSSQ > 0 .and. mMEDIA > 0
         if lGRA
            //'for xTMP=1 to len(aLAY)
            //''    FWRITE(nHANDT,ALAY[1][X],aLAY[2][X])                
            //''NEXT    
            GRAVALAY( aLAY  , "RDT",    ,     ,     , .T.,.T. )
            //GRAVALAY( aLAY, cARQ, nIND, lOPE, cBUS, lAPE,lLOG)
         endif
         nITEM ++
         nMEDIA += mMEDIA
      endif
      nQTDP += nQTDDE
   enddo
   if lPRO
      @ CTLIN, 00 say "Total:"
      @ CTLIN,  9 say nQTDP    pict "999999999"
      @ CTLIN, 27 say nMEDIA   pict "999999.99"
      @ CTLIN, 37 say nITEM    pict "99999"
   endif
   if nITEM > 0 .and. nMEDIA > 0
      if lPRO
         @ CTLIN, 47 say round( nMEDIA / nITEM, 2 ) pict "9999.99"
      endif
      nGERITE ++
      nGERMED += nMEDIA / nITEM
   endif
   if lPRO
      CTLIN ++
   endif
   nGERQTD += nQTDP
   dbselectar( "MY03TMP" )
enddo
dbcloseall()
if lGRA
   if nGERITE > 0 .and. nGERMED > 0
      GRAVAMVAR( "RD", str( aRETU[ 2 ], 4 ) + str( aRETU[ 1 ], 2 ), "PRPE", "round(nGERMED/nGERITE,2)", 2 )
   endif
endif

if lGER
   @ CTLIN, 00 say "Total:"
   @ CTLIN,  9 say nGERQTD  pict "999999999"
   @ CTLIN, 27 say nGERMED  pict "999999.99"
   @ CTLIN, 37 say nGERITE  pict "99999"
   if nGERITE > 0 .and. nGERMED > 0
      @ CTLIN, 47 say round( nGERMED / nGERITE, 2 ) pict "9999.99"
   endif
endif
CTLIN ++
@ CTLIN,  0 say "" //Ajusta Ultima Linha Video
IMPFOL()
IMPEND()
//FCLOSE(nHANDT)

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBY301()
*+
*+    Called from ( m_by3.prg    )   2 - function mby202()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBY301( cCODIGO )
if empty( cCODIGO )
   retu .F.
endif
//IF CODMAQ="TER" //Pular Terceiros
//   retu .F.
//ENDIF
if BXMY03 = "N"
   retu .F.
endif
@ 24, 00 say NUMERO
mCHAVE  := cCODIGO
mSEQ    := SEQ
mSSQ    := SSQ
mHORAS  := CHOR( FIMOPR + if( VIRADA = "S", 24, 0 ) ) - CHOR( INIOPR ) - PARADA - ( CHOR( ALMFIM ) - CHOR( ALMINI ) )
mQTDDE  := QTDDE
mDATOPR := DATOPR
mHORAS  := round( mHORAS, 2 )
if mHORAS <= 0
   IF PARADA=0.AND.(INIOPR<>FIMOPR)
      ALERTX( "Cheque Horas Requisi‡„o" + str( numero ) )
   ENDIF   
   nHORAS := 0
   retu .f.
endif
if mQTDDE <= 0
   IF PARADA=0
      ALERTX( "Cheque Quantidade Requisi‡„o" + str( numero ) )
   ENDIF   
   nQTDDE := 0
   retu .f.
endif
dbselectar( "MY03TMP" )
dbgotop()
if !dbseek( cCODIGO + str( mSEQ, 3 ) + str( mSSQ, 3 ) + dtos( mDATOPR ) )
   netrecapp()
   field->CODIGO := cCODIGO
   field->SEQ    := mSEQ
   field->SSQ    := mSSQ
   field->DATOPR := mDATOPR
endif
field->QTDDE := QTDDE + mQTDDE
field->HORAS := HORAS + mHORAS
retu .T.

*+ EOF: M_BY3.PRG
