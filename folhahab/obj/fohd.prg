*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fohd.prg
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
*+    Documentado em 27-Dez-2024 as  9:45 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :       FOHF.PRG: IMPRIMIR RE FGTS PADRAO CAIXA
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Softec
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 02/10/97
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"

IF ARQ = 9 .OR. ARQ = 10
   MDT('Use a op‡„o Folha')
   RETU
ENDIF
IF ARQ = 6
   ALERTX("Nao Disponivel VT")
   RETU .F.
ENDIF
IF !MDL('IMPRIMIR RE FGTS PADRAO CAIXA',0)
   RETU
ENDIF

ATUALIZA := 1.000000
CONTATO  := PADR(OBTER("FIRMA",,NREMP,"RESPONSAV"),20)
TIPODEP  := "115"
aCTA01   := PEGRELCTA("FGTS01")
aCTA02   := PEGRELCTA("FGTS02")


set key K_F11 to TECLAF11
@ 18,00 SAY 'Qual o Fator de Atualiza‡„o:'                                                                                                                  
@ 20,00 SAY 'Confirme o C¢digo de Recolhimento'                                                                                                             
@ 18,40 GET ATUALIZA                            PICT "99999999999.999999"                                                                                   
@ 20,50 GET TIPODEP                             PICTURE "999"             VALID VERSEHA("CODFGTS",,TIPODEP,"NOME",'"C¢digo Deposito N„o Cadastrado"')       
IF !READCUR()
   set key K_F11
   RETU .F.
ENDIF
set key K_F11


nCONT   := 26
nTOT    := 0
nTOT13  := 0
nTOTG   := 0
nTOTG13 := 0
nFL     := 1

IF !netuse("bcofgts")
   DBCLOSEALL()
   RETU
ENDIF
DBGOTOP()
if !DBSEEK(NREMP)
   MDT('Falta cadastro do Banco Deposit rio')
   RETU
ELSE
   cCODFGTS := CODEMP+CODEMPDV+SEQUENCIA+SEQUENDV
ENDIF
DBCLOSEALL()

IF ZPESSOA = 'J'
   INSREP := SUBSTR(CGC1,1,2)+SUBSTR(CGC1,4,3)+SUBSTR(CGC1,8,3)+SUBSTR(CGC1,12,4)+SUBSTR(CGC1,17,2)
ELSE
   INSREP := "00"+ZCEI
ENDIF
cMESANO := STRZERO(MES,2)+'/'+SUBSTR(STRZERO(ANO,4),3)

IF !ARQPES(ARQ,1,0)
   DBCLOSEALL()
   RETU
ENDIF
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
INX    := ""
FILORD(.T.)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
if valtype(INX) = "N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF
set filter to &FILTRO
cSELE1 := ALIAS()

IF !ARQUSAR(ARQ)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2 := ALIAS()



//Seta o Formulario
IMPRESSORA()
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE !EOF()
   IF nCONT = 26
      @ PROW(), 0   SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))+REPL("-",132)                                                                  
      @ PROW()+ 1,0 SAY ACENTO("CGC/CEI"+spac(8)+"C¢digo FGTS    Pessoa/Telefone para Contato    |  Competˆncia")                                    
      @ PROW()+ 1,0 SAY INSREP                                                                                                                       
      @ PROW(),15   SAY cCODFGTS                                                                                                                     
      @ PROW(),30   SAY CONTATO                                                                                                                      
      @ PROW(),51   SAY ZTELEFONE                                                                                                                    
      @ PROW(),62   SAY "|"                                                                                                                          
      @ PROW(),68   SAY cMESANO                                                                                                                      
      @ PROW()+ 1,0 SAY ACENTO("Raz„o Social"+spac(39)+"No Folha   |  C¢digo Rec.")                                                                  
      @ PROW()+ 1,0 SAY MSG2                                                                                                                         
      @ PROW(),51   SAY STRZERO(nFL,6)                                                                                                               
      @ PROW(),62   SAY "|"                                                                                                                          
      @ PROW(),69   SAY TIPODEP                                                                                                                      
      @ PROW()+ 1,0 SAY REPL("-",132)                                                                                                                
      @ PROW()+ 1,0 SAY ACENTO("NOME"+spac(27)+"PIS/PASEP   ADMISSŽO-Co CONTA FGTS     Base Calculo"+spac(7)+"Base 13o. Sal.  Movimenta‡„o")         
      @ PROW()+ 1,0 SAY REPL("-",132)                                                                                                                
      nFL ++
      nCONT  := 1
      nTOT   := 0
      nTOT13 := 0
   ENDIF
   NUM   := NUMERO
   REC   := 0
   REC13 := 0
   DBSELECTAR(cSELE2)
   DBGOTOP()
   DBSEEK(NUM * 10000)
   WHILE NUm = NUMERO .AND. !EOF()
      FOR X := 1 TO 15
         IF aCTA01[X] = CONTA
            REC += VALOR
         ENDIF
         IF aCTA02[X] = CONTA
            REC13 += VALOR
         ENDIF
      NEXT X
      DBSKIP()
   ENDDO
   REC   := IF(ATUALIZA # 1,ROUND(REC * ATUALIZA,2),REC)
   REC13 := IF(ATUALIZA # 1,ROUND(REC13 * ATUALIZA,2),REC13)
   DBSELECTAR(cSELE1)
   IF EMPTY(DEMITIDO) .OR. MONTH(DEMITIDO) >= MES
      @ PROW()+ 1,0 SAY NOME              
      @ PROW(),31   SAY PIS               
      @ PROW(),43   SAY ADMITIDO          
      @ PROW(),52   SAY TIPFGTS           
      @ PROW(),55   SAY CONTAFGTS         
      IF REC > 0  //.AND.MOTIVO#"02"
         @ PROW(),67 SAY REC PICTURE "@E 999,999,999,999.99"        
         nTOT  += REC
         nTOTG += REC
      ENDIF
      IF REC13 > 0  //.AND.MOTIVO#"02"
         @ PROW(),86 SAY REC13 PICTURE "@E 999,999,999,999.99"        
         nTOT13  += REC13
         nTOTG13 += REC13
      ENDIF
      IF MONTH(DEMITIDO) = MES
         @ PROW(),105 SAY DEMITIDO         
         @ PROW(),114 SAY FGTSMOT          
      ENDIF
   ENDIF
   DBSELECTAR(cSELE1)
   DBSKIP()
   nCONT ++
   IF nCONT = 26
      @ PROW()+ 1,0  SAY REPL("-",132)                                                                                                               
      @ PROW()+ 1,55 SAY "TOTAL"+spac(10)+"Base Calculo"+spac(7)+ACENTO("Base13o Sal rio    Base+Base 13O. ")                                        
      @ PROW()+ 1,55 SAY "A RECOLHER"                                                                                                                
      @ PROW(),67    SAY nTOT                                                                                 PICTURE "@E 999,999,999,999.99"        
      @ PROW(),86    SAY nTOT13                                                                               PICTURE "@E 999,999,999,999.99"        
      @ PROW(),105   SAY nTOT+nTOT13                                                                          PICTURE "@E 999,999,999,999.99"        
      @ PROW()+ 1,0  SAY REPL("-",132)                                                                                                               
      IMPFOL()
   ENDIF
ENDDO
IF nTOT+nTOT13 > 0
   @ PROW()+ 1,0  SAY REPL("-",132)                                                                                                                    
   @ PROW()+ 1,55 SAY "TOTAL"+spac(10)+"Base Calculo"+spac(7)+ACENTO("Base13o Sal rio    Base+Base 13O. ")                                             
   @ PROW()+ 1,55 SAY "A RECOLHER"                                                                                                                     
   @ PROW(),67    SAY nTOT                                                                                      PICTURE "@E 999,999,999,999.99"        
   @ PROW(),86    SAY nTOT13                                                                                    PICTURE "@E 999,999,999,999.99"        
   @ PROW(),105   SAY nTOT+nTOT13                                                                               PICTURE "@E 999,999,999,999.99"        
   @ PROW()+ 1,0  SAY REPL("-",132)                                                                                                                    
   @ PROW()+ 1,0  SAY REPL("-",132)                                                                                                                    
   @ PROW()+ 1,55 SAY "TOTAL GERAL"+spac(4)+"Base Calculo"+spac(7)+ACENTO("Base13o Sal rio    Base+Base 13O. ")                                        
   @ PROW()+ 1,55 SAY "A RECOLHER"                                                                                                                     
   @ PROW(),67    SAY nTOTG                                                                                     PICTURE "@E 999,999,999,999.99"        
   @ PROW(),86    SAY nTOTG13                                                                                   PICTURE "@E 999,999,999,999.99"        
   @ PROW(),105   SAY nTOTG+nTOTG13                                                                             PICTURE "@E 999,999,999,999.99"        
   @ PROW()+ 1,0  SAY REPL("-",132)                                                                                                                    
   IMPFOL()
ENDIF
DBCLOSEALL()
VIDEO()
IMPEND()
mTEMP := tmpfile(cRDDEXT)
RETU

// : FIM: FOHD.PRG

*+ EOF: fohd.prg
*+
