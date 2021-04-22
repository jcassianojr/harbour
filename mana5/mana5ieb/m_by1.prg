*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BY1.PRG
*+
*+    Functions: Function MBY1FIL()
*+               Function MBY101()
*+               Function CABMBY1()
*+
*+
*+    Reformatted by Click! 2.03 on Feb-10-2005 at  1:30 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

MDI( " Э Ficha do Operador" )
nSEQ  := 0
CTLIN := 80
aGER  := {}

lANA := MDG( "Deseja Analitico" )
lDIA := MDG( "Deseja Resumo Dia" )
lMES := MDG( "Deseja Resumo Mensal" )
lGER := MDG( "Deseja Resumo Geral" )

FILTRO  := ''
FILTRO  := RFILORD( "MY03", .F. )

aRETU   := PERFEC( { "MY03", "MY03A" }, { "Y3", "YA" }, { "Y399", "YA99" }, { "DATOPR", "PADRAO" } )
nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQ    := aRETU[ 5, 1 ]
cARQ2   := aRETU[ 5, 2 ]
cCAB    := aRETU[ 7 ]

lGRA := .F.
if aRETU[ 6 ] = 2   //Mes Fechado
   lGRA := MDG( "Gravar Apura‡„o" )
   if lGRA
      lGRA := SENHAX( "MBY001" )
   endif
endif

if !CHECKIMP( 0 )
   retu .F.
endif
//cAE := IMP( "AE" )
//cAC := IMP( "AC" )
cAE := aCHR[ 2 ]
cAC := aCHR[ 1 ]

if !USEMULT( { { CARQ, 1, 1 }, { cARQ2, 1, 1 }, { "MS06", 1, 1 }, { "MP04", 1, 1 } } )
   retu .F.
endif

if lGRA
   if !USEMULT( { { "RD", 1, 99 }, { "RDF", 0, 99 } } )
      retu .F.
   endif
   dbselectar( "RD" )
   dbsetorder( 2 )
   dbgotop()
   if dbseek( str( nANOUSO, 4 ) + str( nMESUSO, 2 ) )
      nSEQ := SEQ
   endif
   if nSEQ > 0
      dbselectar( "RDF" )
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{||SEQ = nSEQ }, {|| zei_fort(nLASTREC,,,1)})
      pack
   endif
endif

dbselectar( cARQ )
if !empty( FILTRO )
   set filter to &FILTRO
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","str( CODOPE, 8 ) + dtos( DATOPR ) + str( INIOPR, 5, 2 )")
ordSetFocus("temp")


IMPRESSORA()
dbselectar( cARQ )
dbgotop()
while empty( codope ) .and. !eof()      //Pula Operador 0 Geralmente Terceiros/Tratamento
   dbskip()
enddo
while !eof()
   nCODOPE := CODOPE
   mNOME   := ""
   dDATOPR:=DATOPR
   aMES    := {}
   dbselectar( "MP04" )
   dbgotop()
   if dbseek( nCODOPE )
      if empty(demitido).or.(dDATOPR<=demitido)
         mNOME := NOMTEC
      endif   
   endif
   VIDEO()
   @ 24, 00 say "Operador: " + str( nCODOPE ) + " " + mNOME         
   IMPRESSORA()
   if CTLIN # 80
      @ CTLIN,  0 say "Operador: " + str( nCODOPE )         
      @ CTLIN, 20 say mNOME                                 
      CTLIN ++
      @ CTLIN,  0 say repl( "-", 132 )         
      CTLIN ++
   endif
   dbselectar( cARQ )
   while nCODOPE = CODOPE .and. !eof()
      nDIA := DATOPR
      aDIA := { 0, 0, 0, 0 }
      while nCODOPE = CODOPE .and. nDIA = DATOPR .and. !eof()
         mCHAVE  := padr( CODIGO, 24 ) + str( SEQ, 3 ) + str( SSQ, 3 )
         nPCHORA := 0
         dbselectar( "MS06" )
         dbgotop()
         if dbseek( mCHAVE )
            if nDIA >= DATAINI
               nPCHORA := PCHORA
            endif
         endif
         dbselectar( cARQ )
         nHORAS := CHOR( FIMOPR + if( VIRADA = "S", 24, 0 ) ) - CHOR( INIOPR ) - PARADA - ( CHOR( ALMFIM ) - CHOR( ALMINI ) )
         nHORAS := round( nHORAS, 2 )
         nQTDDE := QTDDE
         //         if ! empty( CODIG2 )
         //            nQTDDE := QTDDE * 2
         //         endif
         if nHORAS < 0
            ALERTX( "Cheque Horas Requisi‡„o" + str( NUMERO ) )
            nHORAS := 0
         endif
         if nQTDDE < 0
            ALERTX( "Cheque Quantidade Requisi‡„o" + str( NUMERO ) )
         endif
         nFEITO := 0
         if nQTDDE > 0 .and. nHORAS > 0.001
            nFEITO := round( nQTDDE / nHORAS, 2 )
         endif
         nHREF := 0
         if nPCHORA > 0 .and. nFEITO > 0
            nHREF := round( if( nPCHORA > 0, nFEITO / nPCHORA, 0 ), 2 )
         endif
         nHRE2 := 0
         if nQTDDE > 0 .and. nPCHORA > 0
            nHRE2 := round( if( nPCHORA > 0, nQTDDE / nPCHORA, 0 ), 2 )
         endif
         if TPMY03 = "S"
            nHREF   := 1
            nHRE2   := nHORAS
            nPCHORA := nFEITO
         endif
         nPARADA := 0
         //Calculos passiveis de implanta‡„o
         nPER01 := nHREF * 100
         nPER02 := nHREF * 100
         nPER03 := 100
         aDIA[ 1 ] += nHORAS
         aDIA[ 3 ] += nHRE2
         aDIA[ 4 ] += nQTDDE
         if lANA
            CABMBY1( .T. )
            @ CTLIN,  0  say NUMERO                                   
            @ CTLIN,  9  say DATOPR                                   
            @ CTLIN, 18  say left( CODIGO, 15 )                       
            @ CTLIN, 34  say SEQ                                      
            @ CTLIN, 38  say SSQ                                      
            @ CTLIN, 42  say CODMAQ                                   
            @ CTLIN, 51  say INIOPR             pict "99.99"          
            @ CTLIN, 57  say FIMOPR             pict "99.99"          
            @ CTLIN, 63  say nHORAS             pict "99.99"          
            @ CTLIN, 69  say nPARADA            pict "99.99"          
            @ CTLIN, 75  say nQTDDE             pict "999999"         
            @ CTLIN, 82  say nFEITO             pict "9999.99"        
            @ CTLIN, 90  say nPCHORA            pict "9999"           
            @ CTLIN, 95  say nHRE2              pict "99.99"          
            @ CTLIN, 101 say nPER01             pict "999.99"         
            CTLIN ++
            if !empty( OBSLAN )
               @ CTLIN,  0 say "Obs: " + OBSLAN         
               CTLIN ++
            endif
         endif
         mCHAVE := NUMERO
         dbselectar( cARQ2 )
         dbgotop()
         dbseek( str( mCHAVE, 8 ) )
         while mCHAVE = NUMERO .and. !eof()
            aDIA[ 2 ] += TEMPO
            if lANA
               @ CTLIN, 30 say "CHP"                               
               @ CTLIN, 35 say CODPAR                              
               @ CTLIN, 38 say CODPARD                             
               @ CTLIN, 51 say PINI            pict "99.99"        
               @ CTLIN, 57 say PFIM            pict "99.99"        
               @ CTLIN, 69 say TEMPO           pict "99.99"        
               @ CTLIN, 75 say left( OBS, 55 )                     
               CTLIN ++
            endif
            dbskip()
         enddo
         dbselectar( cARQ )
         dbskip()
      enddo
      nTOT   := aDIA[ 1 ] + aDIA[ 2 ]
      nPER01 := PERC( aDIA[ 3 ], aDIA[ 1 ] )                //eFC
      nPER02 := PERC( aDIA[ 3 ], nTOT )                     //pro
      nPER03 := PERC( aDIA[ 1 ], nTOT )                     //utl
      if lDIA
         @ CTLIN,  0 say repl( "-", 132 )         
         CTLIN ++
         @ CTLIN, 63  say "HRs"            
         @ CTLIN, 69  say "Par"            
         @ CTLIN, 75  say "Qtdde"          
         @ CTLIN, 95  say "Hr.Pr."         
         @ CTLIN, 101 say "Efi"            
         @ CTLIN, 108 say "Pro"            
         @ CTLIN, 115 say "Utl"            
         CTLIN ++
         MBY101( { "Data", nDIA, aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ], nPER01, nPER02, nPER03 } )
         CTLIN ++
         @ CTLIN,  0 say repl( "-", 132 )         
         CTLIN ++
      endif
      aadd( aMES, { aDIA[ 1 ], aDIA[ 2 ], aDIA[ 3 ], nPER01, nPER02, nPER03, nDIA, aDIA[ 4 ] } )
      dbselectar( cARQ )
   enddo
   aDIA := { 0, 0, 0, 0 }
   for X := 1 to len( aMES )
      aDIA[ 1 ] += aMES[ X, 1 ]
      aDIA[ 2 ] += aMES[ X, 2 ]
      aDIA[ 3 ] += aMES[ X, 3 ]
      aDIA[ 4 ] += aMES[ X, 8 ]         //Qtde
      if lMES
         CABMBY1( .T. )
         MBY101( { "", aMES[ X, 7 ], aMES[ X, 1 ], aMES[ X, 2 ], aMES[ X, 8 ], aMES[ X, 3 ], ;
                   aMES[ X, 4 ], aMES[ X, 5 ], aMES[ X, 6 ] } )
         CTLIN ++
      endif
   next X
   nPER01 := PERC( aDIA[ 3 ], aDIA[ 1 ] )                   //efc
   nPER02 := PERC( aDIA[ 3 ], aDIA[ 1 ] + aDIA[ 2 ] )       //pro
   nPER03 := PERC( aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )       //utl
   if lMES
      MBY101( { "Mes", mNOME, aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ], nPER01, nPER02, nPER03 } )
      CTLIN ++
      @ CTLIN,  0 say repl( "=", 132 )         
      CTLIN ++
   endif
   aadd( aGER, { aDIA[ 1 ], aDIA[ 2 ], aDIA[ 3 ], nPER01, nPER02, nPER03, nCODOPE, mNOME, aDIA[ 4 ] } )
   dbselectar( cARQ )
enddo
if lGER
   CTLIN := 80      //For‡ar Iniciar Uma FOLHA
endif
aDIA := { 0, 0, 0, 0 }
for X := 1 to len( aGER )
   aDIA[ 1 ] += aGER[ X, 1 ]
   aDIA[ 2 ] += aGER[ X, 2 ]
   aDIA[ 3 ] += aGER[ X, 3 ]
   aDIA[ 4 ] += aGER[ X, 9 ]
   if lGER
      CABMBY1( .F. )
      MBY101( { aGER[ X, 7 ], aGER[ X, 8 ], aGER[ X, 1 ], aGER[ X, 2 ], aGER[ X, 9 ], aGER[ X, 3 ], ;
                aGER[ X, 4 ], aGER[ X, 5 ], aGER[ X, 6 ] } )
      CTLIN ++
   endif
   if nSEQ > 0 .and. lGRA
      dbselectar( "RDF" )
      netrecapp()
      field->SEQ    := nSEQ
      field->HD     := aGER[ X, 1 ] + aGER[ X, 2 ]          //Horas Disponiveis
      field->HP     := aGER[ X, 2 ]     //Horas Paradas
      field->HT     := aGER[ X, 1 ]     //Horas Trabalhadas
      field->PE     := aGER[ X, 4 ]
      field->PP     := aGER[ X, 5 ]
      field->PU     := aGER[ X, 6 ]
      field->NUMERO := aGER[ X, 7 ]
      field->NOME   := aGER[ X, 8 ]
      field->QP     := aGER[ X, 9 ]
   endif
next X
nPER01 := PERC( aDIA[ 3 ], aDIA[ 1 ] )  //efc
nPER02 := PERC( aDIA[ 3 ], aDIA[ 1 ] + aDIA[ 2 ] )          //prod
nPER03 := PERC( aDIA[ 1 ], aDIA[ 1 ] + aDIA[ 2 ] )          //utliz
if lGER
   MBY101( { "", "", aDIA[ 1 ], aDIA[ 2 ], aDIA[ 4 ], aDIA[ 3 ], nPER01, nPER02, nPER03 } )
   CTLIN ++
endif
IMPFOL()
if lGRA
   dbselectar( "RD" )
   dbsetorder( 1 )
   dbgotop()
   if dbseek( nSEQ )
      netgrvcam()
      field->FUHD := aDIA[ 1 ] + aDIA[ 2 ]
      field->FUHP := aDIA[ 2 ]
      field->FUHT := aDIA[ 1 ]
      field->FUQP := aDIA[ 4 ]
      field->FUPE := nPER01
      field->FUPP := nPER02
      field->FUPU := nPER03
      dbunlock()
   endif
endif
dbcloseall()
IMPEND()
MBY1FIl()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBY1FIL()
*+
*+    Called from ( m_by1.prg    )   1 - 
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBY1FIL()

for X := 1 to 4
   IF X<4 
      Y=X
   ELSE
      Y=99
   ENDIF   
   MDS( "Aguarde Checando Nomes Empresa " + str( Y, 2 ) )
   if ! USECHK( "p:\novell\itaesbra\emp000" + strZERO( Y, 2 ) + "\mp04.dbf", ;
               "p:\novell\itaesbra\emp000" + strZERO( Y, 2 ) + "\mp04.cdx", .T., "DBFCDX", .T. )
      LOOP
   endif
   if !USEREDE( "RDF", 1, 99 )
      dbcloseall()
      retu .F.
   endif
   dbselectar( "RDF" )
   nLASTREC := lastrec()
   nPOSREC  := 1
   dbgotop()
   while !eof()
      if empty( nome )
         mNUMERO := NUMERO
         mNOME   := ""
         dbselectar( "MP04" )
         dbgotop()
         if dbseek( mNUMERO )
            if empty(demitido)
               mNOME := NOMTEC
            endif   
         endif
         dbselectar( "RDF" )
         netgrvcam("NOME",mNOME)
      endif
      dbselectar( "RDF" )
      dbskip()
      ZEI_FORT( nLASTREC, .T., nPOSREC )
      nPOSREC ++
   enddo
   dbcloseall()
next X

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBY101()
*+
*+    Called from ( m_by1.prg    )   5 - 
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBY101( aDAD )

@ CTLIN,  0  say aDAD[ 1 ]                        
@ CTLIN,  9  say aDAD[ 2 ]                        
@ CTLIN, 58  say aDAD[ 3 ] pict "99999.99"        
@ CTLIN, 69  say aDAD[ 4 ] pict "99999.99"        
@ CTLIN, 78  say aDAD[ 5 ] pict "9999999"         
@ CTLIN, 92  say aDAD[ 6 ] pict "99999.99"        
@ CTLIN, 101 say aDAD[ 7 ] pict "999.99"          
@ CTLIN, 108 say aDAD[ 8 ] pict "999.99"          
@ CTLIN, 115 say aDAD[ 9 ] pict "999.99"          
retu

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function CABMBY1()
*+
*+    Called from ( m_by1.prg    )   3 - 
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func CABMBY1( lSAYF )

if CTLIN > 55
   @  0,  0  say cAE + "Ficha do Operador"         
   @  1,  0  say cAC + "M_BY1"                     
   @  1, 60  say time()                            
   @  1, 70  say ZDATA                             
   @  2,  0  say "Req."                            
   @  2,  9  say "Data"                            
   @  2, 18  say "Peca No."                        
   @  2, 34  say "OP"                              
   @  2, 42  say "Maquina"                         
   @  2, 51  say "Ini"                             
   @  2, 57  say "Fim"                             
   @  2, 63  say "HRs"                             
   @  2, 69  say "Par"                             
   @  2, 75  say "Qtdde"                           
   @  2, 82  say "Real"                            
   @  2, 90  say "Pad"                             
   @  2, 95  say "Hr.Pr."                          
   @  2, 101 say "Efi"                             
   @  2, 108 say "Pro"                             
   @  2, 115 say "Utl"                             
   CTLIN := 3
   if lSAYF
      @ CTLIN,  0 say "Operador: " + str( nCODOPE )         
      @ CTLIN, 20 say mNOME                                 
      CTLIN ++
      @ CTLIN,  0 say repl( "-", 132 )         
      CTLIN ++
   endif
endif
retu .T.

*+ EOF: M_BY1.PRG
