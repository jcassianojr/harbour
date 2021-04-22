*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
*+
*+    Source Module => J:\ITAESBRA\M_BO8.PRG
*+
*+    Functions: Function MBO802()
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊

//#INCLUDE "COMANDO.CH"
MDI( "Relatorio Resumo" )

if !CHECKIMP( 0 )
   retu .F.
endif
cAE := IMP( "AE" )

aCODC := {}
aCODD := {}
aQTDC := {}
aQTDD := {}

cTIPO := "S"
cDATA := "A"
nFIM  := ZDATA
@ 22, 00 say "(P)roduto (M)at.Prima (C)omponentes E-HE H-HH T-HT"         
@ 23, 00 say "Data Tipos A-Compra B-Producao C-Pedido"                    
MDS( "Digite o tipo e data Perido" )
@ 24, 40 get cTIPO valid cTIPO $ "PMCEHT" pict "!"       
@ 24, 42 get cDATA valid cDATA $ "ABC"    pict "!"       
@ 24, 60 get nFIM                                        
if !READCUR()
   retu .F.
endif

mARQ1 := ESTQARQ( cTIPO, 1 )

CTLIN  := 80
FILTRO := ''
FILTRO := RFILORD( mARQ1, .F. )
mARQ2  := TIPORR( cTIPO, 1 )
mARQ3  := TIPORR( cTIPO, 2 )

if !USEMULT( { { mARQ1, 1, 1 }, { mARQ2, 1, 1 }, { mARQ3, 1, 1 } } )
   retu .F.
endif

dbselectar( mARQ1 )
if !empty( FILTRO )
   set filter to &FILTRO
endif

IMPRESSORA()
dbselectar( mARQ1 )
dbgotop()
while !eof()
   xCODIGO := CODIGO
   nSALDO  := ESTQSAL
   nRES    := nNEC := 0
   if CTLIN > 50
      @  0,  0 say cAE + "Resumo Estoque/Reserva/Necessidades"         
      @  1, 00 say "M_BO8 "                                            
      @  1, 10 say "Ate " + dtoc( nFIM )                               
      do case
      case cDATA = "A" 
         @  1, 30 say " data de Compra"         
      case cDATA = "B" 
         @  1, 30 say " data de Limite Producao "         
      case cDATA = "C" 
         @  1, 30 say " data do Pedido "         
      endcase
      @  1, 60  say time()                   
      @  1, 70  say ZDATA                    
      @  2,  0  say "Codigo"                 
      @  2, 26  say "Nome"                   
      @  2, 66  say "     Estoque"           
      @  2, 90  say "     Reserva"           
      @  2, 102 say " Necessidade"           
      @  2, 114 say "       Saldo"           
      @  3, 00  say repl( "-", 132 )         
      CTLIN := 4
   endif
   @ CTLIN,  0 say CODIGO                                
   @ CTLIN, 26 say NOME                                  
   @ CTLIN, 66 say ESTQSAL pict "@E 9999,999.999"        
   dbselectar( mARQ2 )
   dbgotop()
   dbseek( alltrim( xCODIGO ) )
   while alltrim( xCODIGO ) = alltrim( CODIGO ) .and. !eof()
      do case
      case cDATA = "A" .and. DLIMITE <= nFIM 
         nRES += QTDDE
      case cDATA = "B" .and. DLIMP <= nFIM 
         nRES += QTDDE
      case cDATA = "C" .and. DPEDI <= nFIM 
         nRES += QTDDE
      endcase
      dbskip()
   enddo
   dbselectar( mARQ3 )
   dbgotop()
   dbseek( alltrim( xCODIGO ) )
   while alltrim( xCODIGO ) = alltrim( CODIGO ) .and. !eof()
      do case
      case cDATA = "A" .and. DLIMITE <= nFIM 
         nNEC += QTDDE
      case cDATA = "B" .and. DLIMP <= nFIM 
         nNEC += QTDDE
      case cDATA = "C" .and. DPEDI <= nFIM 
         nNEC += QTDDE
      endcase
      dbskip()
   enddo
   @ CTLIN, 90  say nRES pict "@E 9999,999.999"        
   @ CTLIN, 102 say nNEC pict "@E 9999,999.999"        
   do case
   case nNEC = 0
      @ CTLIN, 114 say nSALDO - nRES pict "@E 9999,999.999"        
      aadd( aCODC, XCODIGO )
      aadd( aQTDC, nSALDO - nRES )
   otherwise
      @ CTLIN, 114 say nNEC * - 1 pict "@E 9999,999.999"        
      aadd( aCODD, XCODIGO )
      aadd( aQTDD, nNEC )
   endcase
   CTLIN ++
   dbselectar( mARQ1 )
   dbskip()
enddo
dbcloseall()
if CTLIN # 80
   IMPFOL()
endif
if cTIPO $ "EHT"
   @  0,  0 say cAE + "Resumo Estoque/Reserva/Necessidades - Remanejamento"         
   @  1, 00 say "M_BO8-B "                                                          
   MBO802()
endif
VIDEO()
IMPEND()

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function MBO802()
*+
*+    Called from ( m_bo8.prg    )   1 - function truncar()
*+                ( m_bo9.prg    )   1 - function mbo802()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
func MBO802

@  1, 60 say time()         
@  1, 70 say ZDATA          
if type( "nFIM" ) = "D"
   @  1, 10 say "Ate " + dtoc( nFIM )         
endif
@  2,  0 say "Codigo"                 
@  2, 20 say "Remanejando"            
@  2, 46 say "Quantidade"             
@  3, 00 say repl( "-", 132 )         
CTLIN := 4

mARQ1 := ESTQARQ( cTIPO, 1 ) + "A"

VIDEO()
while !USEREDE( mARQ1, 1, 1 )
enddo
IMPRESSORA()
for W := 1 to len( aCODC )
   aOPCAO  := {}
   zCODIGO := aCODC[ W ]
   nSTART  := aQTDC[ W ]
   dbgotop()
   dbseek( zCODIGO )
   while zCODIGO = CODIGO .and. !eof()
      aadd( aOPCAO, CODMPSB )
      dbskip()
   enddo
   for Z := 1 to len( aOPCAO )
      nPOS := ascan( aCODD, aOPCAO[ Z ] )
      if nPOS > 0 .and. nSTART > 0.0001
         nDEB := aQTDD[ nPOS ]
         if nDEB > 0
            do case
            case nDEB = nSTART
               @ CTLIN, 00 say zCODIGO                                     
               @ CTLIN, 20 say aCODD[ nPOS ]                               
               @ CTLIN, 40 say nDEB          pict "@E 9999,999.999"        
               nSTART := 0
               CTLIN ++
            case nSTART > nDEB
               @ CTLIN, 00 say zCODIGO                                     
               @ CTLIN, 20 say aCODD[ nPOS ]                               
               @ CTLIN, 40 say nDEB          pict "@E 9999,999.999"        
               nSTART -= nDEB
               CTLIN ++
            case nDEB > nSTART
               @ CTLIN, 00 say zCODIGO                                     
               @ CTLIN, 20 say aCODD[ nPOS ]                               
               @ CTLIN, 40 say nSTART        pict "@E 9999,999.999"        
               aQTDD[ nPOS ] -= nSTART
               nSTART := 0
               CTLIN ++
            endcase
         endif
      endif
   next Z
next W
dbclosearea()
@ CTLIN,  0 say repl( "=", 132 )         
CTLIN ++
for W := 1 to len( aCODD )
   nDEB := aQTDD[ W ]
   if nDEB > 0
      @ CTLIN, 20 say aCODD[ W ]                               
      @ CTLIN, 40 say nDEB       pict "@E 9999,999.999"        
      CTLIN ++
   endif
next W
@ CTLIN,  0 say repl( "=", 132 )         
CTLIN ++
IMPFOL()
retu

*+ EOF: M_BO8.PRG
