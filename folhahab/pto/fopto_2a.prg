*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOPTO_2A.PRG
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

FUNCTION FOPTO_2A
PARA cFILTRO
cPN := "PN" + ANOMESW 

CABE2( 'FOPTO_2A - Zerando entradas/Saidas Grupo de Funcionarios' )
IF VALTYpe(cFILTRO)#"C"
   if !MDG( "Zerar Entradas/Saidas" )
      retu .F.
   endif
endif   
MDS( "Aguarde Zerando Dados" )
if ! Netuse(cPN) 
   retu
endif
IF VALTYpe(cFILTRO)#"C"
   FILTRO := ''
   FI     := trim( FILTRO )
   FILTRO := FILTRO( FI )
ELSE
   FILTRO=cFILTRO
ENDIF   
set filter to &FILTRO
dbgotop()
while !eof()
   netreclock()
   field->ENT := 0
   field->SAI := 0
   field->ALE := 0
   field->ALS := 0
   dbunlock()
   dbskip()
enddo
dbcloseall()
retu

*+ EOF: FOPTO_2A.PRG
