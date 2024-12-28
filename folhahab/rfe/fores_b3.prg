*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_b3.prg
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
// :  FORES_B3.PRG : PLANILHA ADMINISTRATIVA FERIAS
// :     Linguagem : Clipper 5.2e
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 08/08/97
// :
// :*****************************************************************************



////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"
IF !MDL('PLANILHA ADMINISTRATIVA FERIAS',0)
   RETU
ENDIF

SAISAL := IF(MDG('Deseja Com Sal rios'),.T.,.F.)
SAIPRI := IF(MDG('Deseja Apenas Primeiro Periodo aquisitivo'),.T.,.F.)


if !NETUSE(pes)
   dbcloseall()
   retu
endif
FILTRO := ''
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

IF !NETUSE("FO_FER")
   RETURN
ENDIF

LISTARUE({| X | B3X(X)})




// !*****************************************************************************
// !
// !         Fun‡„o: B3X()
// !
// !    Chamado por: FORES_B3.PRG
// !
// !          Chama: OBTER()            (fun‡„o    em FORESP.PRG)
// !               : SALHM()            (fun‡„o    em FORESP.PRG)
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function B3X()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC B3X

PARA COMPARE
TOTALIZA := .F.
CTLIN    := 80
QTFUN    := SALTOT := 0
DBSELECTAR(PES)
DBGOTOP()
WHILE !EOF()
   IF &COMPARE
      TOTALIZA := .T.
      CTR      := NUMERO
      DAT      := ADMITIDO
      IF CTLIN > 55
         FL ++
         @  1,1   SAY IMPSTR(cIMPEXP)                                                                                 
         @  2,10  SAY IMPCHR(cIMPTIT)+MSG2                                                                            
         @  3,10  SAY ACENTO(IMPCHR(cIMPTIT)+' PREVISŽO ADMINISTRATIVA DE FRIAS '+NOMSETOR)                          
         @  4,90  SAY 'FL. '+STRZERO(FL,4)                                                                            
         @  4,110 SAY 'DATA => '+DTOC(DXDIA)                                                                          
         @  5,1   SAY REPL('-',132)+IMPSTR(cIMPCOM)                                                                   
         @  6,0   SAY ACENTO("DEP  SET SEC CHA Nume. Nome"+SPAC(27)+"Admiss„o Fun‡„o")                                
         @  6,90  SAY ACENTO("Sal rio"+SPAC(13)+"Ao mˆs"+SPAC(14)+"—ltimo Gozo"+SPAC(6)+"Per¡odo Aquisitivo")         
         @  6,160 SAY ACENTO("Prazo Gozo Programa‡„o Gozo     SD Observa‡”es")                                        
         @  7,0   SAY IMPSTR(cIMPEXP)+REPL('-',132)+IMPSTR(cIMPCOM)                                                   
         CTLIN := 8
      ENDIF
      @ CTLIN,0  SAY DEPTO                                   
      @ CTLIN,5  SAY SETOR                                   
      @ CTLIN,9  SAY SECAO                                   
      @ CTLIN,13 SAY CHAPA                                   
      @ CTLIN,17 SAY NUMERO                                  
      @ CTLIN,23 SAY NOME                                    
      @ CTLIN,54 SAY ADMITIDO                                
      @ CTLIN,63 SAY FUNCAO                                  
      @ CTLIN,68 SAY OBTER("FUNCAO",,FUNCAO,"FNOME")         
      IF SAISAL
         VAR1 := SALH := SALM := 0
         SALHM(MES)
         @ CTLIN,80  SAY VAR1 PICT "@E 999,999,999,999.99"        
         @ CTLIN,100 SAY SALM PICT "@E 999,999,999,999.99"        
         SALTOT += SALM
      ENDIF
      INIULT := CTOD("  /  /  ")
      FIMULT := CTOD("  /  /  ")
      DBSELECTAR("FO_FER")
      DBGOTOP()
      DBSEEK(CTR * 100000000)
      IF NUMERO = CTR
         WHILE NUMERO = CTR .AND. BAIXADO = 'S' .AND. !EOF()
            INIULT := GOZOU1DE
            FIMULT := GOZOU1ATE
            DBSKIP()
         ENDDO
         IF NUMERO # CTR .OR. EOF()
            @ CTLIN,119 SAY ACENTO('Funcion rio com todos aquisitivos baixados')         
            CTLIN ++
         ENDIF
         WHILE NUMERO = CTR .AND. !EOF()
            IF BAIXADO # 'S'
               IF !EMPTY(INIULT)
                  @ CTLIN,120 SAY ACENTO(DTOC(INIULT)+"  ")         
               ENDIF
               IF !EMPTY(FIMULT)
                  @ CTLIN,131 SAY FIMULT         
               ENDIF
               @ CTLIN,141 SAY ACENTO(DTOC(DATFERIAS)+"  ")         
               @ CTLIN,152 SAY DATFERIASF                            
               @ CTLIN,161 SAY (DATFERIASF+336)                      
               @ CTLIN,171 SAY ACENTO(DTOC(PROGRAMA)+"  ")          
               @ CTLIN,182 SAY PROGRAMA1                             
               @ CTLIN,193 SAY DIASGOZA3                             
               @ CTLIN,196 SAY REPL("_",30)                          
               CTLIN ++
               IF SAIPRI
                  EXIT
               ENDIF
            ENDIF
            DBSKIP()
            INIULT := GOZOU1DE
            FIMULT := GOZOU1ATE
         ENDDO
         QTFUN ++
      ELSE
         @ CTLIN,119 SAY ACENTO('Funcion rio sem remanejamento')         
         CTLIN ++
      ENDIF
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
IF TOTALIZA
   @ PROW()+ 1,0  SAY IMPSTR(cIMPEXP)+REPL('-',132)+IMPSTR(cIMPCOM)                   
   @ PROW()+ 1,20 SAY ACENTO('Quantidade de Funcion rios --> ')                       
   @ PROW(),53    SAY QTFUN                                         PICT '###'        
   IF SAISAL
      @ PROW(),100 SAY SALTOT PICT "@E 999,999,999,999.99"        
   ENDIF
   @ PROW()+ 1,0 SAY IMPSTR(cIMPEXP)+REPL('-',132)         
   IMPFOL()
ENDIF
RETU .T.
// : FIM: FORES_B3.PRG

*+ EOF: fores_b3.prg
*+
