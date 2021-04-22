*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_BO9.PRG
*+
*+    Functions: Function MBO901()
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

//#INCLUDE "COMANDO.CH"

MDI( " þ Saldo de Horas Pelos Processos" )
if MDG( "Reprocessar Passos da Ordem de Fabrica‡?" )
   M_AOY()
endif

if !CHECKIMP( 0 )
   retu .F.
endif
cAE := IMP( "AE" )

aCODC := {}
aCODD := {}
aQTDC := {}
aQTDD := {}
CTLIN := 80
cTIPO := "M"
nFIM  := ZDATA
aMAO  := {}
aQTD  := {}
MDS( "Digite o tipo e data Perido" )
@ 23, 00 say "Horas->  E-Equipamantos H-omens T-Terceiros"                                    
@ 23, 30 get cTIPO                                         valid cTIPO $ "EHT" pict "!"       
@ 24, 60 get nFIM                                                                             
if !READCUR()
   retu .F.
endif

mARQ1 := ESTQARQ( cTIPO, 1 )

if !USEREDE( "OF03", 1, 3 )
   dbcloseall()
endif
dbgotop()
while DLIMP <= nFIM .and. !eof()
   nSTART := QTTIME * QTFAL
   if nSTART > 0.0001
      do case
      case cTIPO = "E" 
         MBO901( CODMP01 )
      case cTIPO = "H"
         MBO901( CODMP02 )
         MBO901( CODMP02B )
         MBO901( CODMP02C )
         MBO901( CODMP02D )
      case cTIPO = "T" 
         MBO901( CODMP03 )
      endcase
   endif
   dbskip()
enddo
dbclosearea()

if !USEREDE( mARQ1, 1, 1 )
   retu .F.
endif
IMPRESSORA()
dbgotop()
while !eof()
   if CTLIN > 50
      @  0,  0 say cAE + "Resumo Estoque/A Processar"         
      @  1, 00 say "M_BO9 "                                   
      @  1, 10 say "Ate " + dtoc( nFIM )                      
      @  1, 60 say time()                                     
      @  1, 70 say ZDATA                                      
      @  2,  0 say "Codigo"                                   
      @  2, 26 say "Nome"                                     
      @  2, 66 say "     Estoque"                             
      @  2, 78 say " A Processar"                             
      @  2, 90 say "       Saldo"                             
      @  3, 00 say repl( "-", 132 )                           
      CTLIN := 4
   endif
   @ CTLIN,  0 say CODIGO                                
   @ CTLIN, 26 say NOME                                  
   @ CTLIN, 66 say ESTQSAL pict "@E 9999,999.999"        
   nPOS := ascan( aMAO, CODIGO )
   if nPOS > 0
      @ CTLIN, 78 say aQTD[ nPOS ] pict "@E 9999,999.999"        
      if ESTQSAL > 0
         nSALDO := ESTQSAL - aQTD[ nPOS ]
         @ CTLIN, 90 say nSALDO pict "@E 9999,999.999"        
         if nSALDO > 0
            aadd( aCODC, CODIGO )
            aadd( aQTDC, nSALDO )
         else
            aadd( aCODD, CODIGO )
            aadd( aQTDD, abs( nSALDO ) )
         endif
      else
         @ CTLIN, 90 say - aQTD[ nPOS ] pict "@E 9999,999.999"        
         aadd( aCODD, CODIGO )
         aadd( aQTDD, aQTD[ nPOS ] )
      endif
   else
      @ CTLIN, 78 say 0       pict "@E 9999,999.999"        
      @ CTLIN, 90 say ESTQSAL pict "@E 9999,999.999"        
      aadd( aCODC, CODIGO )
      aadd( aQTDC, ESTQSAL )
   endif
   CTLIN ++
   dbskip()
enddo
dbclosearea()
IMPFOL()
if cTIPO $ "EHT"
   @  0,  0 say cAE + "Resumo Estoque/A Processar - Remanejamento"         
   @  1, 00 say "M_BO9-B "                                                 
   @  1, 10 say "Ate " + dtoc( nFIM )                                      
   MBO802()
endif
VIDEO()
IMPEND()

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MBO901()
*+
*+    Called from ( m_bo9.prg    )   6 - function mbo802()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
func MBO901( cCOD )

if empty( cCOD )
   retu
endif
nPOS := ascan( aMAO, cCOD )
if nPOS > 0
   aQTD[ nPOS ] += nSTART
else
   aadd( aMAO, cCOD )
   aadd( aQTD, nSTART )
endif
retu

*+ EOF: M_BO9.PRG
