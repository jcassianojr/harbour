*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_b6.prg
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

//#INCLUDE "COMANDO.CH"
//Relatorio.

MDI(" › Imprimir Informe de Rendimento")
dDATA := DATE()

if !USEREDE("MANEMP",1,1)
   retu .F.
endif
dbgotop()
if !dbseek(ZNUMERO)
   dbcloseall()
   ALERTX("Falta Cadastro Empresa")
   retu
else
   cCGC  := CGC
   cNOME := NOME
   cRESP := RESPF
endif
dbcloseall()


IF !CHECKIMP(0)
   RETU .F.
ENDIF
FILTRO := ''
FILTRO := RFILORD("IRRF01",.F.)
IF !USEREDE("IRRF01",1,1)
   RETU .F.
ENDIF
IF !USEREDE("IRRF02",1,3)
   DBCLOSEALL()
   RETU .F.
ENDIF
DBSELECTAR("IRRF01")
IF !EMPTY(FILTRO)
   SET FILTER TO &FILTRO
ENDIF

IMPRESSORA()
DBSELECTAR("IRRF01")
DBGOTOP()
WHILE !EOF()
   mNUMERO := NUMERO
   xCONTA  := 1
   nTOTREN := 0
   nTOTIMP := 0
   @  0,0  SAY REPL("-",80)                                                                                         
   @  1,0  SAY "|         MINISTERIO DA FAZENDA"                                                                    
   @  1,40 SAY "| COMPROVANTE RENDIMENTOS PAGOS E DE"                                                               
   @  1,79 SAY "|"                                                                                                  
   @  2,00 SAY "|"                                                                                                  
   @  2,40 SAY "| RETENCAO DE IMPOSTO DE RENDA NA FONTE"                                                            
   @  2,79 SAY "|"                                                                                                  
   @  3,00 SAY "|         SECRETARIA DA RECEITA FEDERAL"                                                            
   @  3,40 SAY "|"                                                                                                  
   @  3,79 SAY "|"                                                                                                  
   @  4,00 SAY "|"                                                                                                  
   @  4,40 SAY "| Ano Calendario "+STR(ANO,4)                                                                       
   @  4,79 SAY "|"                                                                                                  
   @  5,0  SAY REPL("-",80)                                                                                         
   @  6,0  SAY "1.FONTE PAGADORA"                                                                                   
   @  7,0  SAY REPL("-",80)                                                                                         
   @  8,00 SAY "| NOME: "+cNOME                                                                                     
   @  8,50 SAY "| CNPJ: "+cCGC                                                                                      
   @  8,79 SAY "|"                                                                                                  
   @ 09,0  SAY REPL("-",80)                                                                                         
   @ 10,0  SAY "2.PESSOA JURIDICA FORNECEDORA DO SERVICO"                                                           
   @ 11,0  SAY REPL("-",80)                                                                                         
   @ 12,00 SAY "| NOME: "+NOME                                                                                      
   @ 12,50 SAY "| CNPJ: "+CGC                                                                                       
   @ 12,79 SAY "|"                                                                                                  
   @ 13,0  SAY REPL("-",80)                                                                                         
   @ 14,0  SAY ACENTO("3.RELAÄAO DE PAGAMENTOS E RETENÄôES")                                                        
   @ 15,00 SAY "|-----|"+REPL("-",9)+"|"+REPL("-",24)+"|"+REPL("-",13)+"|"+REPL("-",9)+"|"+REPL("-",13)+"|"         

   @ 16,0  SAY "| MES"                            
   @ 16,6  SAY "|CODIGO DE"                       
   @ 16,16 SAY "| NATUREZA DO RENDIMENTO"         
   @ 16,41 SAY "|VALOR"                           
   @ 16,55 SAY "|ALIQUOTA"                        
   @ 16,65 SAY "|VALOR"                           
   @ 16,79 SAY "|"                                

   @ 17,0  SAY "|PGTO"             
   @ 17,6  SAY "|RETENCAO"         
   @ 17,16 SAY "|"                 
   @ 17,41 SAY "|PAGO"             
   @ 17,55 SAY "|"                 
   @ 17,65 SAY "|RETIDO"           
   @ 17,79 SAY "|"                 

   @ 18,00 SAY "|-----|"+REPL("-",9)+"|"+REPL("-",24)+"|"+REPL("-",13)+"|"+REPL("-",9)+"|"+REPL("-",13)+"|"         
   CTLIN := 19
   DBSELECTAR("IRRF02")
   DBGOTOP()
   DBSEEK(STR(mNUMERO,8))
   WHILE mNUMERO = NUMERO .AND. !EOF()
      mRENDA    := 0
      mIRRF     := 0
      mALIQUOTA := ALIQUOTA
      mDARF     := DARF
      mNATUREZA := NATUREZA
      mMES      := MES
      WHILE mNUMERO = NUMERO .AND. MES = mMES .AND. DARF = mDARF .AND. mALIQUOTA = ALIQUOTA .AND. !EOF()
         mRENDA  += RENDA
         mIRRF   += IRRF
         nTOTREN += RENDA
         nTOTIMP += IRRF
         DBSKIP()
      ENDDO
      xCONTA ++
      @ CTLIN,00 SAY "|"+STR(mMES,4)                                      
      @ CTLIN,6  SAY "|  "+mDARF                                          
      @ CTLIN,16 SAY "| "+LEFT(mNATUREZA,20)                              
      @ CTLIN,41 SAY "|"                                                  
      @ CTLIN,42 SAY mRENDA                  PICT "@E 9999,999.99"        
      @ CTLIN,55 SAY "|"                                                  
      @ CTLIN,56 SAY mALIQUOTA                                            
      @ CTLIN,65 SAY "|"                                                  
      @ CTLIN,66 SAY mIRRF                   PICT "@E 9999,999.99"        
      @ CTLIN,79 SAY "|"                                                  
      CTLIN ++
      @ CTLIN,00 SAY "|-----|"+REPL("-",9)+"|"+REPL("-",24)+"|"+REPL("-",13)+"|"+REPL("-",9)+"|"+REPL("-",13)+"|"         
      CTLIN ++
   ENDDO
   FOR X := xCONTA TO 12
      @ CTLIN,00 SAY "|     |"+REPL(" ",9)+"|"+REPL(" ",24)+"|"+REPL(" ",13)+"|"+REPL(" ",9)+"|"+REPL(" ",13)+"|"         
      CTLIN ++
      @ CTLIN,00 SAY "|-----|"+REPL("-",9)+"|"+REPL("-",24)+"|"+REPL("-",13)+"|"+REPL("-",9)+"|"+REPL("-",13)+"|"         
      CTLIN ++
   NEXT X
   DBSELECTAR("IRRF01")
   @ CTLIN,00 SAY "|  "+"TOTAL"                              
   @ CTLIN,41 SAY "|"                                        
   @ CTLIN,42 SAY nTOTREN       PICT "@E 9999,999.99"        
   @ CTLIN,55 SAY "|"                                        
   @ CTLIN,65 SAY "|"                                        
   @ CTLIN,66 SAY nTOTIMP       PICT "@E 9999,999.99"        
   @ CTLIN,79 SAY "|"                                        
   CTLIN ++
   @ CTLIN,0 SAY REPL("-",80)         
   CTLIN ++
   @ CTLIN,0 SAY ACENTO("4. INFORMAÄôES COMPLEMENTARES")         
   CTLIN ++
   @ CTLIN,0 SAY REPL("-",80)         
   CTLIN ++
   @ CTLIN,0 SAY ACENTO("5 RESPONSèVEL PELAS INFORMAÄôES")         
   CTLIN ++
   @ CTLIN,0 SAY REPL("-",80)         
   CTLIN ++
   @ CTLIN,0  SAY "| NOME: "+LEFT(cRESP,25)         
   @ CTLIN,36 SAY "| DATA "+DTOC(ZDATA)             
   @ CTLIN,52 SAY "|  ASSINATURA"                   
   @ CTLIN,79 SAY "|"                               
   CTLIN ++
   @ CTLIN,0 SAY REPL("-",80)         
   CTLIN ++
   @ CTLIN,0 SAY "Aprovado pela IN/SRF nß 120/2000, com as alteraá‰es da IN/SRF nß 288/2003"         
   DBSKIP()
   IMPFOL()
ENDDO
DBCLOSEALL()
VIDEO()
IMPEND()
