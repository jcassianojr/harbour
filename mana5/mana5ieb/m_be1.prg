*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_BE.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

//#INCLUDE "COMANDO.CH"
MDI( " þ Imprimir Equipamentos por Grupo" )

//Checa a Impressora
if !CHECKIMP( 0 )
   return .F.
endif
cRESET := IMP( "RESET" )
cEMP   := IMP( "ZEMP" )

//N?ero de C?ias
NRCOPIA := 1
@ 24, 00
@ 24, 00 say "N?ero de copias:" get NRCOPIA pict '99'       
if !READCUR()
   retu .F.
endif

//Filtro da Listagem
FILTRO := ''
FILTRO := RFILORD( "ME01", .F. )

//Abertura do Arquivo Nome + Modelo
if !USEREDE( "ME01", 1, 2 )
   retu
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
if eof()
   dbcloseall()
   retu .F.
endif
IMPRESSORA()
for X := 1 to NRCOPIA
   CTLIN   := 80
   ZPAGINA := 0
   dbgotop()
   while !eof()
      xMODELO := MODELO
      xNOME   := NOME
      nMODELO := 0
      while NOME = xNOME .and. MODELO = xMODELO .and. !eof()
         nMODELO ++
         dbskip()
      enddo
      if CTLIN > 56
         ZPAGINA ++
         @  0,  0 say cRESET                                                                          
         @  0,  0 say cEMP                                                                            
         @  1, 60 say ACENTO( 'P gina: ' ) + str( ZPAGINA, 2 )                                        
         @  2, 60 say 'Emitida em: ' + dtoc( ZDATA )                                                  
         @  3, 01 say 'M_BE'                                                                          
         @  3, 70 say time()                                                                          
         @  5, 00 say impchr(cIMPTIT) + ACENTO( 'Resumo de M quinas e Equipamentos por Modelo' )         
         @  7,  0 say repl( '-', 80 )                                                                 
         @  8,  0 say "Nome" + spac( 37 ) + "Modelo" + spac( 15 ) + "Quantidade"                      
         @ 09,  0 say repl( '-', 80 )                                                                 
         CTLIN := 10
      endif
      @ CTLIN,  0 say ACENTO( xNOME )           
      @ CTLIN, 41 say ACENTO( xMODELO )         
      @ CTLIN, 62 say nMODELO                   
      CTLIN ++
   enddo
next X
IMPFOL()
VIDEO()
dbcloseall()
IMPEND()

*+ EOF: M_BE.PRG
