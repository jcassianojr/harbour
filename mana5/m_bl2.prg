*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_bl2.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :   M_BL2.PRG   : Imprimir Duplicata em formulario continuo
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Documentado em: Julho 28, 1994 as 17:39:37               DISK!  vers„o 5.01
// :*****************************************************************************
//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI(" þ Imprimir Contas a Receber Data de Vencimento ")
nIND   := NUMIND("ML01PG")
FILTRO := ''
FILTRO := RFILORD("ML01PG",.F.)

cARQ := "ML01PG"
IF MDG("Mes Fechado")
   cARQ := "ML"+MESANO()
ENDIF

CTLIN := NRCOPIA := 1
VEZES := 0
IF !CHECKIMP(0)
   RETU .F.
ENDIF
@ 24,00
@ 24,00 SAY "N£mero de copias:" GET NRCOPIA PICT '99'       
READCUR()
WHILE VEZES < NRCOPIA
   VEZES ++
   CTLIN := 80
   IF !USEREDE(cARQ,1,nIND)
      RETU
   ENDIF
   IF !EMPTY(FILTRO)
      SET FILTER TO &FILTRO
   ENDIF
   DBGOTOP()
   ZPAGINA := 0
   IF !EOF()
      SET DEVICE TO PRINT
   ENDIF
   TOT1 := TOT2 := 0.00
   DAT  := VENCIMENT
   WHILE !EOF()
      IF CTLIN > 55
         ZPAGINA ++
         @  0,0  SAY IMP("RESET")+impchr(Cimpexp)                                  
         @  0,0  SAY IMP("ZEMP")                                                   
         @  1,59 SAY ACENTO('    P gina: ')+STR(ZPAGINA,2)                         
         @  2,01 SAY 'M_BL2'                                                       
         @  2,35 SAY TIME()                                                        
         @  2,59 SAY 'Emitida em: '+DTOC(ZDATA)                                    
         @  3,00 SAY impchr(Cimptit)+'Contas Pagas por Data de Vencimento'         
         @  4,0  SAY '*'+REPL('-',78)+'*'+impchr(Cimpcom)                          
         @ 05,88 SAY 'DIAS'                                                        
         @ 06,01 SAY ' NUMERO'                                                     
         @ 06,12 SAY 'CLIENTE'                                                     
         @ 06,31 SAY 'TELEFONE'                                                    
         @ 06,45 SAY 'VEND.'                                                       
         @ 06,51 SAY ' PAGA EM'                                                    
         @ 06,70 SAY ' VALOR TITULO '                                              
         @ 06,85 SAY 'SI'                                                          
         @ 06,88 SAY 'BANCO'                                                       
         @ 06,95 SAY 'OBSERVACAO:'                                                 
         @ 07,0  SAY impchr(Cimpexp)+'*'+REPL('-',78)+'*'+impchr(Cimpcom)          
         CTLIN := 8
      ENDIF
      @ CTLIN,01 SAY NRNOTA PICT '99999999'        
      IF !EMPTY(TIPFAT)
         @ CTLIN,09 SAY '-'+TIPFAT         
      ENDIF
      @ CTLIN,12 SAY STRZERO(CLIENTE,5)                              
      @ CTLIN,18 SAY COGNOME                                         
      @ CTLIN,31 SAY DDD                                             
      @ CTLIN,36 SAY TELEFONE                                        
      @ CTLIN,45 SAY VENDEDOR                                        
      @ CTLIN,51 SAY DATAPG                                          
      @ CTLIN,70 SAY VALORPG            PICT '999,999,999.99'        
      @ CTLIN,85 SAY SITUACAO           PICT '99'                    
      @ CTLIN,90 SAY BANCO                                           
      @ CTLIN,95 SAY LEFT(OBS1,34)                                   
      TOT1 += VALORPG
      TOT2 += VALORPG
      CTLIN ++
      DBSKIP()
      IF DAT <> VENCIMENT
         @ CTLIN,70 SAY '--------------'         
         CTLIN ++
         @ CTLIN,70 SAY TOT1           PICT '999,999,999.99'        
         @ CTLIN,86 SAY 'Total do Dia'                              
         CTLIN ++
         @ CTLIN,70 SAY '--------------'         
         CTLIN ++
         DAT  := VENCIMENT
         TOT1 := 0.00
      ENDIF
   ENDDO
   @ CTLIN,70 SAY '--------------'         
   CTLIN ++
   @ CTLIN,70 SAY TOT2           PICT '999,999,999.99'        
   @ CTLIN,86 SAY 'Total Geral '                              
   CTLIN ++
   IF ZPAGINA > 0
      @ CTLIN,0 SAY '*'+REPL('-',131)+'*'+chr(13)+impchr(Cimpexp)         
      CTLIN ++
   ENDIF
ENDDO
IF ZPAGINA > 0
   IMPFOL()
ENDIF
SET DEVICE TO SCREEN
DBCLOSEAREA()
IMPEND()
RETU
// ** EOF ***
