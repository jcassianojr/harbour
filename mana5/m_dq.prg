*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_dq.prg
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

// : M_DQ : BOLETOS BANCARIOS
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

DXDIA := DATE()
MDI(" Ý Imprime Boleto Banc rio ")
@ 18,16 TO 20,64 DOUBLE
@ 19,17 SAY SPACE(30)                                               
@ 19,18 SAY 'Digite a data para operar o sistema:' GET DXDIA        
READCUR()
MDQ003 := COR("MDQ003")
SETCOLOR(SUBSTR(MDQ003,RAT(",",MDQ003)+1))
HB_DISPBOX(2,0,24,79,"         ")
SETCOLOR(MDQ003)
HB_DISPBOX(4,2,16,44,B_DOUBLE)
KEY := 1
OPCAO(6,4," &A - Bradesco ",65)
OPCAO(8,4," &B - Citibank ",66)
OPCAO(10,4," &C - Nacional ",67)
OPCAO(12,4," &D - Noroeste ",68)
OPCAO(14,4," &E - Itau     ",69)
KEY := MENU(,0)
IF KEY != 0
   nIND := NUMIND("MN01")
ENDIF
IF KEY > 0
   MDI(" Ý Imprime Boleto "+IF(KEY = 1,'Bradesco',IF(KEY = 2,'Citibank',IF(KEY = 4,'Noroeste','Nacional'))))
   MDF()
   M_DQ1(KEY)
ENDIF
RETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_DQ1()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC M_DQ1(P01)   // 1-BRADESCO/2-CITIBANK/3-NACIONAL

// **************************************************
// Modo de Trabalho no Video
// Variaveis de Trabalho
CRIARVARS("MD01")
CRIARVARS("MA01")
// Pegando Cores de Trabalho
MDQ001 := COR("MDQ001")
MDQ002 := COR("MDQ002")
MDQ005 := COR("MDQ005")
MDQ006 := COR("MDQ006")
ZOBS01 := SPAC(44)
ZOBS02 := SPAC(44)
ZOBS03 := SPAC(44)
@ 15,0 TO 20,47 DOUBLE
@ 16,2 SAY 'Observacoes:'         
@ 17,2 GET ZOBS01                 
@ 18,2 GET ZOBS02                 
@ 19,2 GET ZOBS03                 
READCUR()
zJUROS := 0.0000
@ 21,0 SAY 'Juros diario de:' GET zJUROS PICT '99.9999'       
READCUR()
FILTRO          := ''
FILTRO          := RFILORD("MN01",.F.)
CTLIN = NRCOPIA := 1
VEZES           := 0
IF !mdg("Prepare a impressora e tecle (S/N) para imprimir")
   RETURN .F.
ENDIF
CLSCOR()
@ 24,00
@ 24,00 SAY "N£mero de copias:" GET NRCOPIA PICT '99'       
READCUR()
WHILE VEZES < NRCOPIA
   VEZES ++
   CTLIN := 80
   IF !USEREDE("MN01",1,nIND)
      RETU
   ENDIF
   IF !EMPTY(FILTRO)
      SET FILTER TO &FILTRO
   ENDIF
   DBGOTOP()
   IF !EOF()
      SET PRINT ON
      IF P01 = 5
         ?? CHR(27)+'0'
         ?? CHR(27)+'C'+CHR(32)
      ELSE
         ?? CHR(27)+'C'+CHR(24)
      ENDIF
      SET PRINT OFF
      SET DEVICE TO PRINT
   ENDIF
   ZCT := 0
   WHILE !EOF()
      ZCT ++
      IF VALOR > 0
         mFORNECEDO := CLIENTE
         SET DEVICE TO SCREEN
         IF !IGUALVARS("MA01",mFORNECEDO)
            RETU .F.
         ENDIF
         SET DEVICE TO PRINT
         DBSELECTAR('MN01')
         IF P01 = 1
            BRADESCO()
         ELSEIF P01 = 2
            CITIBANK()
         ELSEIF P01 = 3
            NACIONAL()
         ELSEIF P01 = 4
            NOROESTE()
         ELSEIF P01 = 5
            ITAU()
         ENDIF
      ENDIF
      DBSELECTAR('MN01')
      DBSKIP()
   ENDDO
   IMPFOL()
   SET PRINT ON
   ?? CHR(27)+'@'
   SET PRINT OFF
   SET DEVICE TO SCREEN
ENDDO
DBCLOSEALL()
RETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function BRADESCO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION BRADESCO


CTLIN := 1
@ CTLIN,0  SAY impchr(Cimpexp)                                      
@ CTLIN,0  SAY "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO"         
@ CTLIN,53 SAY VENCIMENT                                            
CTLIN += 3
@ CTLIN,1  SAY impchr(Cimpcom)+DTOC(DATA)+impchr(Cimpexp)                          
@ CTLIN,15 SAY NRNOTA                                      PICT '@E 999999'        
@ CTLIN,22 SAY TIPFAT                                                              
@ CTLIN,41 SAY impchr(Cimpcom)+DTOC(ZDATA)+impchr(Cimpexp)                         
CTLIN += 1
@ CTLIN,48 SAY VALOR PICT '@E 999,999,999.99'        
CTLIN += 2
@ CTLIN,30 SAY VALOR * zJUROS PICT "@E 999,999.99"        
CTLIN += 1
@ CTLIN,0 SAY impchr(Cimpexp)                  
@ CTLIN,5 SAY 'VALOR EXPRESSO EM REAL'         
CTLIN += 2
// IF zJUROS>0
//   @ CTLIN,0 SAY impchr(Cimpexp)
//   @ CTLIN,5 SAY 'JUROS DIARIO DE: '+LTRIM(STR(zJUROS,7,2))+' %'
// ENDIF
IF !EMPTY(ZOBS01)
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS01                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS02                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS03                  
   CTLIN ++
ELSE
   CTLIN += 4
ENDIF
@ CTLIN,00 SAY impchr(Cimpexp)         
@ CTLIN,04 SAY mNOME                   
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpexp)                           
@ CTLIN,04 SAY TRIM(mENDERECO)+' '+TRIM(mBAIRRO)         
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpcom)                                                    
@ CTLIN,14 SAY TRIM(mCIDADE)+' - '+mESTADO+' Cep: '+mCEP+' '+'CGC: '+mCGC         
CTLIN ++
RETURN

// ************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CITIBANK()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC CITIBANK

// ************
CTLIN := 2
@ CTLIN,00 SAY impchr(Cimpexp)         
// @ CTLIN,00 SAY mCIDADE2
@ CTLIN,53 SAY VENCIMENT         
CTLIN += 3
@ CTLIN,00 SAY impchr(Cimpexp)                                                     
@ CTLIN,00 SAY DATA                                                                
@ CTLIN,09 SAY NRNOTA                                      PICT '@E 999999'        
@ CTLIN,15 SAY TIPFAT                                                              
@ CTLIN,41 SAY impchr(Cimpcom)+DTOC(DXDIA)+impchr(Cimpexp)                         
CTLIN += 1
@ CTLIN,49 SAY VALOR PICT '@E 999,999,999.99'        
CTLIN += 4
@ CTLIN,00 SAY impchr(Cimpexp)         
CTLIN += 1
IF zJUROS > 0
   @ CTLIN,00 SAY impchr(Cimpexp)                                         
   @ CTLIN,05 SAY 'JUROS DIARIO DE: '+LTRIM(STR(zJUROS,5,2))+' %'         
ENDIF
IF !EMPTY(ZOBS01)
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS01                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS02                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS03                  
   CTLIN ++
ELSE
   CTLIN += 4
ENDIF
@ CTLIN,00 SAY impchr(Cimpexp)         
@ CTLIN,04 SAY mNOME                   
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpexp)                           
@ CTLIN,04 SAY TRIM(mENDERECO)+' '+TRIM(mBAIRRO)         
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpcom)                                                    
@ CTLIN,14 SAY TRIM(mCIDADE)+' - '+mESTADO+' Cep: '+mCEP+' '+'CGC: '+mCGC         
CTLIN ++
RETU

// ************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NACIONAL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC NACIONAL

// ************
CTLIN := 2
@ CTLIN,00 SAY impchr(Cimpexp)         
// @ CTLIN,00 SAY mCIDADE2
@ CTLIN,53 SAY VENCIMENT         
CTLIN += 3
@ CTLIN,00 SAY impchr(Cimpexp)                                                     
@ CTLIN,03 SAY DATA                                                                
@ CTLIN,14 SAY NRNOTA                                      PICT '@E 99,999'        
@ CTLIN,21 SAY TIPFAT                                                              
@ CTLIN,39 SAY impchr(Cimpcom)+DTOC(DXDIA)+impchr(Cimpexp)                         
CTLIN += 1
@ CTLIN,50 SAY VALOR PICT '@E 999,999,999.99'        
CTLIN += 4
@ CTLIN,00 SAY impchr(Cimpexp)         
CTLIN += 1
IF zJUROS > 0
   @ CTLIN,00 SAY impchr(Cimpexp)                                         
   @ CTLIN,05 SAY 'JUROS DIARIO DE: '+LTRIM(STR(zJUROS,5,2))+' %'         
ENDIF
IF !EMPTY(ZOBS01)
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS01                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS02                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS03                  
   CTLIN ++
ELSE
   CTLIN += 4
ENDIF
@ CTLIN,00 SAY impchr(Cimpexp)         
@ CTLIN,05 SAY mNOME                   
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpexp)                           
@ CTLIN,05 SAY TRIM(mENDERECO)+' '+TRIM(mBAIRRO)         
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpcom)                                                    
@ CTLIN,14 SAY TRIM(mCIDADE)+' - '+mESTADO+' Cep: '+mCEP+' '+'CGC: '+mCGC         
CTLIN ++
RETU

// ************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NOROESTE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC NOROESTE

// ************
CTLIN := 2
@ CTLIN,00 SAY impchr(Cimpexp)         
// @ CTLIN,00 SAY mCIDADE2
@ CTLIN,53 SAY VENCIMENT         
CTLIN += 3
@ CTLIN,00 SAY impchr(Cimpexp)                         
@ CTLIN,00 SAY DATA                                    
@ CTLIN,11 SAY NRNOTA          PICT '@E 999999'        
@ CTLIN,18 SAY TIPFAT                                  
// @ CTLIN,41 SAY impchr(Cimpcom)+DTOC(DXDIA)+impchr(Cimpexp)
CTLIN += 1
@ CTLIN,49 SAY VALOR PICT '@E 999,999,999.99'        
CTLIN += 4
@ CTLIN,00 SAY impchr(Cimpexp)         
CTLIN += 1
IF zJUROS > 0
   @ CTLIN,00 SAY impchr(Cimpexp)                                         
   @ CTLIN,05 SAY 'JUROS DIARIO DE: '+LTRIM(STR(zJUROS,5,2))+' %'         
ENDIF
IF !EMPTY(ZOBS01)
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS01                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS02                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS03                  
   CTLIN ++
ELSE
   CTLIN += 4
ENDIF
@ CTLIN,00 SAY impchr(Cimpexp)         
@ CTLIN,04 SAY mNOME                   
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpexp)                           
@ CTLIN,04 SAY TRIM(mENDERECO)+' '+TRIM(mBAIRRO)         
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpcom)                                                    
@ CTLIN,14 SAY TRIM(mCIDADE)+' - '+mESTADO+' Cep: '+mCEP+' '+'CGC: '+mCGC         
CTLIN ++
RETU

// ********

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ITAU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC ITAU

// ********
SET MARGIN TO 0   // 4
CTLIN := 2
@ CTLIN,0  SAY impchr(Cimpexp)                                      
@ CTLIN,0  SAY "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO"         
@ CTLIN,53 SAY VENCIMENT                                            
CTLIN += 4
@ CTLIN,1      SAY impchr(Cimpcom)+DTOC(DATA)+impchr(Cimpexp)                          
@ CTLIN,20     SAY NRNOTA                                      PICT '@E 999999'        
@ CTLIN,PCOL() SAY TIPFAT                                                              
@ CTLIN,35     SAY 'DUP'                                                               
@ CTLIN,41     SAY 'N'                                                                 
@ CTLIN,46     SAY impchr(Cimpcom)+DTOC(ZDATA)+impchr(Cimpexp)                         
CTLIN += 3
@ CTLIN,48 SAY VALOR PICT '@E 999,999,999.99'        
CTLIN += 3
@ CTLIN,0 SAY impchr(Cimpexp)         
CTLIN += 3
IF zJUROS > 0
   @ CTLIN,0 SAY impchr(Cimpexp)                                                                               
   @ CTLIN,5 SAY 'Cobrar R$ '+LTRIM(TRAN(VALOR * (zJUROS / 100),'@E 999,999.99'))+' por dia de atraso'         
ENDIF
IF !EMPTY(ZOBS01)
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS01                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS02                  
   CTLIN ++
   @ CTLIN,00 SAY impchr(Cimpexp)         
   @ CTLIN,00 SAY ZOBS03                  
   CTLIN += 2
ELSE
   CTLIN += 5
ENDIF
@ CTLIN,00 SAY impchr(Cimpexp)         
@ CTLIN,04 SAY mNOME                   
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpexp)                           
@ CTLIN,04 SAY TRIM(mENDERECO)+' '+TRIM(mBAIRRO)         
CTLIN ++
@ CTLIN,00 SAY impchr(Cimpcom)                                                    
@ CTLIN,14 SAY TRIM(mCIDADE)+' - '+mESTADO+' Cep: '+mCEP+' '+'CGC: '+mCGC         
CTLIN ++
SET MARGIN TO 0
RETU

// ** EOF ***
