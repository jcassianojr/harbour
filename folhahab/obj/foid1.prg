*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foid1.prg
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
*+    Documentado em 27-Dez-2024 as  9:46 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :      FOID1.PRG: Apura‡„o Acumulada
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     12:17
// :
// :  Procs & Fncts: FOID1()
// :
// :          Chama: MDL()              (fun‡„o    em FOLPROC.PRG)
// :
// :     Arq. Dados: FO_APU
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function foid1()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function foid1

PARA CC
IF !MDL('Apura‡„o Acumulada',0)
   RETU
ENDIF


IF !netuse("FO_APU")  //AREDE("FO_APU","FO_APU",1)
   RETU
ENDIF

VENC  := DESC := FL := 0
CTLIN := 80


IMPRESSORA()
DBSELECTAR("FO_apu")
DBGOTOP()
WHILE !EOF()
   IF CTLIN > 60
      FL ++
      @  1,1   SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))                                         
      @  2,25  SAY IMPCHR(cIMPTIT)+MSG2                                                                  
      @  3,100 SAY TIME()                                                                                
      @  3,110 SAY DXDIA                                                                                 
      @  3,120 SAY 'FL. '+STRZERO(FL,4)                                                                  
      @  4,0   SAY REPL('-',132)                                                                         
      @  5,20  SAY IMPCHR(cIMPTIT)+'Apuracao Geral Consolidada '+Mmes+'/'+STRZERO(YEAR(DXDIA),4)         
      @  6,0   SAY REPL('-',132)                                                                         
      @  7,1   SAY 'CONTA'                                                                               
      @  7,7   SAY 'DESCRIMINACAO DA CONTA'                                                              
      @  7,53  SAY 'HORAS'                                                                               
      @  7,64  SAY 'VENCIMENTOS '                                                                        
      @  7,86  SAY 'DESCONTOS  '                                                                         
      @  7,108 SAY 'VALORES BASICOS'                                                                     
      @  8,0   SAY REPL('-',132)                                                                         
      CTLIN := 9
   ENDIF
   @ CTLIN,2 SAY CONTA PICT "###"        
   @ CTLIN,6 SAY NOME                    
   IF HORAS # 0
      @ CTLIN,46 SAY HORAS PICT '###,###,###.##'        
   ENDIF
   @ CTLIN,COL SAY VALOR PICT '###,###,###,###.##'        
   CTLIN ++
   IF CC # 6
      DO CASE
      CASE CONTA = 399 
         VENC := VALOR
      CASE CONTA = 999 
         DESC := VALOR
      ENDCASE
   ELSE
      VENC += VALOR
   ENDIF
   DBSELECTAR("FO_apu")
   DBSKIP()
ENDDO
@ PROW()+ 1,0 SAY REPL('-',132)                                                                 
@ PROW()+ 1,6 SAY '...........................LIQUIDO ..===> '                                  
@ PROW(),64   SAY VENC - DESC                                  PICT '###,###,###,###.##'        
@ PROW()+ 1,0 SAY REPL('-',132)                                                                 
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETU

// : FIM: FOID1.PRG

*+ EOF: foid1.prg
*+
