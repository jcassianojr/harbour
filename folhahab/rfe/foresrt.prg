*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foresrt.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:41 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :   FORESRT.PRG : Tela Auxiliar.
// :     Linguagem : Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      8:55
// :
// :  Procs & Fncts: FORESRT()
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************
#INCLUDE "BOX.CH"

HB_dispbox(8,0,21,79,B_DOUBLE)
@  9,2  SAY "Depto:"+SPAC(7)+"Setor:"+SPAC(6)+"Se‡„o:"+SPAC(6)+"Chapa:"+SPAC(7)+"N£mero:"         
@ 10,2  SAY "Nome :"                                                                              
@ 11,2  SAY "Per.Aquisitivo :"+SPAC(10)+"…"+SPAC(16)+"Baixado    :"                               
@ 12,2  SAY "Sal. Variavel  :"+SPAC(27)+"Programa‡„o:"+SPAC(10)+"…"                               
@ 13,0  SAY 'Ã'+REPL('Ä',63)+"Â"+REPL('Ä',14)+'´'                                                 
@ 14,2  SAY "Faltas:"+SPAC(55)+"³ Total:"                                                         
@ 15,64 SAY "³ Dias Juz:"                                                                         
@ 16,0  SAY 'Ã'+REPL('Ä',63)+"Á"+REPL('Ä',14)+'´'                                                 
@ 17,2  SAY "1§ Periodo de Gozo :"+SPAC(10)+"…"+SPAC(11)+"Dias Pagos:     Dias … Gozar:"          
@ 18,2  SAY "Complemento FERIAS :"+SPAC(10)+"…"                                                   
@ 18,44 SAY "ABONO  :"+SPAC(10)+"…"                                                               
@ 19,2  SAY "Periodo do Abono   :"+SPAC(10)+"…"+SPAC(11)+"Dias Pagos:     Dias … Gozar:"          
@ 20,2  SAY "2§ Periodo de Gozo :"+SPAC(10)+"…"+SPAC(11)+"Dias Pagos:     Dias … Gozar:"          
RETU
// : FIM: FORESRT.PRG

*+ EOF: foresrt.prg
*+
