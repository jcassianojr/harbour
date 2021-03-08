*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_3G.PRG
*+
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

////#INCLUDE "COMANDO.CH"

if !MDL( "FOPTO_3G - Total de Passagens Diaria por funcion rios" )
   retu
endif
CTLIN := 80
cPA   := PARQDIO()

if ! NETUSE("FIRMA") 
   retu
endif
dbgotop()
dbseek( NREMP )


if ! NETUSE(cPA) 
   dbcloseall()
   retu
endif
FILTRO := FILTRO( "" )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","DATA")
ordSetFocus("temp")
set filter to &FILTRO

IMPRESSORA()
dbselectar( cPA )
dbgotop()
while !eof()
   if CTLIN > 55
      if CTLIN # 80
         IMPFOL()
      endif
      dbselectar( "FIRMA" )
      @  0,  0 say repl( '=', 79 )                                                               
      @  1,  0 say "FOLHA DE PONTO - " + alltrim( RAZAO )                                        
      @  1, 56 say "CGC:" + CGC                                                                  
      @  2,  0 say "End: " + ENDERECO + " - " + BAIRRO + " - " + CIDADE + " - " + ESTADO         
      @  3,  0 say "Data"                                                                        
      @  3, 50 say ACENTO( "No. Passagens" )                                                     
      @  4,  0 say repl( '-', 79 )                                                               
      CTLIN := 5
   endif
   REF := 0
   dbselectar( cPA )
   mDATA := DATA
   while mDATA = DATA .and. !eof()
      REF ++
      dbskip()
   enddo
   if REF > 0
      @ CTLIN,  0 say mDATA              
      @ CTLIN, 50 say str( REF )         
      CTLIN ++
   endif
enddo
if CTLIN # 80
   IMPFOL()
endif
dbcloseall()
IMPEND()


*+ EOF: FOPTO_3G.PRG
