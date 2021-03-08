***
*** DISK01.PRG   : Nome do Programa
*** Gerado em    : Mar‡o 31, 1994
*** Programador  : Softec Sistemas
*** Linguagem    : Clipper 5.x
***

#INCLUDE "BOX.CH"

********************
FUNC GRAPT(cTITULO) && Marca a evolucao da transferencia do arquivo
********************
TMARCAR=SAVESCREEN(18,15,21,70)
SETCOLOR("N/BG")
HB_DISPBOX(17,13,20,68,B_DOUBLE+" ")
SETCOLOR("+GR/BG")
HB_SCROLL(18,14,19,67)
@ 17,14 SAY " "+cTITULO+" "
@ 18,15 SAY SPAC(48)+"100%"
@ 19,16 SAY REPL('Ý',50)
MDS("Transferindo dados, Aguarde ...")
RETU TMARCAR

************
FUNC GRAPS && Marca a evolucao da transferencia do arquivo
************
PRIV X,Y
SETCOLOR("R")
X:=GRAPP/GRAPT*50
Y:=GRAPP/GRAPT*100
PORC=REPL('Ý',X)
@ 19,16 SAY PORC
SETCOLOR("+GR/BG")
IF X>2
   @ 18,16+X-3 SAY SPAC(3)
END
IF Y>99
   @ 18,16+X-2 SAY Y PICT '999'
   SETCOLOR("R")
   @ 19,16 SAY PORC+'Ý'
   SETCOLOR("+GR/BG")
ELSE
   @ 18,16+X-1 SAY Y PICT '99'
END    
@ 18,COL() SAY '%'
SETCOLOR("W/N,N/W")
GRAPP++
RETU
