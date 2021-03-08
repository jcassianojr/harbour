*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_3B.PRG
*+
*+    Functions: Function FOPTO3B()
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

////#INCLUDE "COMANDO.CH"
if !MDL( "FOPTO_3B -Listagem de Ocorrencias" )
   retu .F.
endif

PAG  := 1
DIAX := date()
cPN  := "PN" + ANOMESW 

if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
INX    := ""
FILORD(.T.)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if valtype(INX)="N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF   
set filter to &FILTRO

if ! NETUSE(cPN)
   dbcloseall()
   retu .F.
endif

if ! NETUSE("TABFALTA") 
   dbcloseall()
   retu .F.
endif

lSINT := MDG( "Deseja Resumo Sintetico" )
lFUNC := MDG( "Deseja Resumo Por Funcionario" )

LISTARUE( { | X | FOPTO3B( X ) } )

retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO3B()
*+
*+    Called from ( fopto_3b.prg )   1 - function fopto39()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FOPTO3B

para COMPARE

aCOD := {}
aQTE := {}
aNOM := {}
dbselectar( PES )
dbgotop()
while !eof()
   if &COMPARE
      VIDEO()
      PETELA( 4 )
      IMPRESSORA()
      mNUMERO := NUMERO
      mNOME   := NOME
      aCODF   := {}
      aQTEF   := {}
      aNOMF   := {}
      dbselectar( cPN )
      dbgotop()
      dbseek( str( mNUMERO, 8 ) )
      while mNUMERO = NUMERO .and. !eof()
         if !empty( COD )
            //Checagem Geral
            nPOS := ascan( aCOD, COD )
            if nPOS = 0
               aadd( aCOD, COD )
               aadd( aQTE, { 1, 0 } )
               cCOD := COD
               dbselectar( "TABFALTA" )
               dbgotop()
               dbseek( cCOD )
               aadd( aNOM, if( found(), { NOME, APURA, FORMULA }, { "", "N", "" } ) )
               nPOS := len( aNOM )
            else
               aQTE[ nPOS, 1 ] ++
            endif
            dbselectar( cPN )
            if aNOM[ nPOS, 2 ] # "N" .and. !empty( aNOM[ nPOS, 3 ] )
               eFORMULA := aNOM[ nPOS, 3 ]
               aQTE[ nPOS, 2 ] += &eFORMULA.
            endif
            //Checagem Total Funcionario
            nPOS := ascan( aCODF, COD )
            if nPOS = 0
               aadd( aCODF, COD )
               aadd( aQTEF, { 1, 0 } )
               cCOD := COD
               dbselectar( "TABFALTA" )
               dbgotop()
               dbseek( cCOD )
               aadd( aNOMF, if( found(), { NOME, APURA, FORMULA }, { "", "N", "" } ) )
               nPOS := len( aNOMF )
            else
               aQTEF[ nPOS, 1 ] ++
            endif
            dbselectar( cPN )
            if aNOMF[ nPOS, 2 ] # "N" .and. !empty( aNOMF[ nPOS, 3 ] )
               eFORMULA := aNOMF[ nPOS, 3 ]
               aQTEF[ nPOS, 2 ] += &eFORMULA.
            endif
         endif
         dbselectar( cPN )
         dbskip()
      enddo
      if lFUNC
         IMPRESSORA()
         if len( aCODF ) > 0
            if prow() + len( aCODF ) > 50 .or. PAG = 1
               if PAG # 1
                  IMPFOL()
               endif
               CABEC( "Resumo de Ocorrencias", "Ocorreu/Quantidade", 60, "Codigo", NOMSETOR )
               @ prow() + 1, 0 say mNUMERO                 
               @ prow(), 10    say mNOME                   
               @ prow() + 1, 0 say repl( "-", 80 )         
            else
               @ prow() + 1, 0 say repl( "=", 80 )         
               @ prow() + 1, 0 say mNUMERO                 
               @ prow(), 10    say mNOME                   
               @ prow() + 1, 0 say repl( "-", 80 )         
            endif
            for X := 1 to len( aCODF )
               @ prow() + 1, 0 say aCODF[ X ]                           
               @ prow(), 3     say aNOMF[ X, 1 ]                        
               @ prow(), 54    say aQTEF[ X, 1 ] pict "99999999"        
               if !empty( aQTEF[ X, 2 ] )
                  @ prow(), 62 say aQTEF[ X, 2 ] pict "@E 999,999,999.99"        
               endif
            next X
         endif
         VIDEO()
      endif
   endif
   dbselectar( PES )
   dbskip()
enddo

if lSINT
   IMPRESSORA()
   if lFUNC
      IMPFOL()
      CABEC( "Resumo de Ocorrencias", "Ocorreu/Quantidade", 60, "Codigo", NOMSETOR )
   endif
   for X := 1 to len( aCOD )
      if prow() > 50 .or. PAG = 1
         IMPFOL()
         CABEC( "Resumo de Ocorrencias", "Ocorreu/Quantidade", 60, "Codigo", NOMSETOR )
      endif
      @ prow() + 1, 0 say aCOD[ X ]                           
      @ prow(), 3     say aNOM[ X, 1 ]                        
      @ prow(), 54    say aQTE[ X, 1 ] pict "99999999"        
      if !empty( aQTE[ X, 2 ] )
         @ prow(), 62 say aQTE[ X, 2 ] pict "@E 999,999,999.99"        
      endif
   next X
   if len( aCOD ) > 0
      IMPFOL()
   endif
   VIDEO()
endif
IMPEND()

*+ EOF: FOPTO_3B.PRG
