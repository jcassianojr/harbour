LOCAL GetList := {}
cls
wTpInsfe="J"
wInsFede=SPACE(14)
//v_pic="999.999.999-99"
v_pic="@R 99.999.999/9999-99"
@ 10,10 SAY "PESSOA" GET wTpInsFe PICT "!"   
@ 12,10 SAY "Numero" GET wInsFede PICT (v_pic) WHEN { |oGet| TROCA_PIC(oGet,wTpInsFe,len(wInsFede)) }
READ 
RETURN

FUNC TROCA_PIC(oGet,v_Tipo,nLENGET)
DO CASE 
  CASE v_Tipo = "J" 
       oGet:picture :="@R 99.999.999/9999-99"
  CASE v_Tipo = "F"
      oGet:picture :="@R 999.999.999-99" 
  otherwise
      oGet:picture :=repl("X",nLENGET)
endcase
retu .T.
