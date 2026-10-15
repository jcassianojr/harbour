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
*+    Documentado em 15-Out-2026 as 10:57 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

#include "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fores_b3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fores_b3()


IF !MDL('PLANILHA ADMINISTRATIVA FERIAS',0)
   RETU
ENDIF

SAISAL := IF(MDG('Deseja Com Sal rios'),.T.,.F.)
SAIPRI := IF(MDG('Deseja Apenas Primeiro Periodo aquisitivo'),.T.,.F.)


IF !NETUSE(pes)
   dbCloseAll()
   RETU
ENDIF
FILTRO := ''
INX    := ""
FILORD(.T.)
nLASTREC := LastRec()
zei_fort(nLASTREC,,,0)
IF ValType(INX) = "N"
   dbSetOrder(INX)
ELSE
   ordDestroy("temp")
   ordCreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF
SET FILTER TO &FILTRO

IF !NETUSE("FO_FER")
   RETURN
ENDIF

LISTARUE({| X | B3X(X)})

RETURN



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

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function B3X()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC B3X


PARA COMPARE

TOTALIZA := .F.
CTLIN    := 80
QTFUN    := SALTOT := 0
dbSelectAr(PES)
dbGoTop()
WHILE !Eof()
   IF &COMPARE
      TOTALIZA := .T.
      CTR      := NUMERO
      DAT      := ADMITIDO
      IF CTLIN > 55
         FL ++
         @  1,1   SAY IMPSTR(cIMPEXP)                                                                                 
         @  2,10  SAY IMPCHR(cIMPTIT)+MSG2                                                                            
         @  3,10  SAY ACENTO(IMPCHR(cIMPTIT)+' PREVISŽO ADMINISTRATIVA DE FRIAS '+NOMSETOR)                          
         @  4,90  SAY 'FL. '+StrZero(FL,4)                                                                            
         @  4,110 SAY 'DATA => '+DToC(DXDIA)                                                                          
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
      INIULT := CToD("  /  /  ")
      FIMULT := CToD("  /  /  ")
      dbSelectAr("FO_FER")
      dbGoTop()
      dbSeek(CTR * 100000000)
      IF NUMERO = CTR
         WHILE NUMERO = CTR .AND. BAIXADO = 'S' .AND. !Eof()
            INIULT := GOZOU1DE
            FIMULT := GOZOU1ATE
            dbSkip()
         ENDDO
         IF NUMERO # CTR .OR. Eof()
            @ CTLIN,119 SAY ACENTO('Funcion rio com todos aquisitivos baixados')         
            CTLIN ++
         ENDIF
         WHILE NUMERO = CTR .AND. !Eof()
            IF BAIXADO # 'S'
               IF !Empty(INIULT)
                  @ CTLIN,120 SAY ACENTO(DToC(INIULT)+"  ")         
               ENDIF
               IF !Empty(FIMULT)
                  @ CTLIN,131 SAY FIMULT         
               ENDIF
               @ CTLIN,141 SAY ACENTO(DToC(DATFERIAS)+"  ")         
               @ CTLIN,152 SAY DATFERIASF                            
               @ CTLIN,161 SAY (DATFERIASF+336)                      
               @ CTLIN,171 SAY ACENTO(DToC(PROGRAMA)+"  ")          
               @ CTLIN,182 SAY PROGRAMA1                             
               @ CTLIN,193 SAY DIASGOZA3                             
               @ CTLIN,196 SAY REPL("_",30)                          
               CTLIN ++
               IF SAIPRI
                  EXIT
               ENDIF
            ENDIF
            dbSkip()
            INIULT := GOZOU1DE
            FIMULT := GOZOU1ATE
         ENDDO
         QTFUN ++
      ELSE
         @ CTLIN,119 SAY ACENTO('Funcion rio sem remanejamento')         
         CTLIN ++
      ENDIF
   ENDIF
   dbSelectAr(PES)
   dbSkip()
ENDDO
IF TOTALIZA
   @ PRow()+ 1,0  SAY IMPSTR(cIMPEXP)+REPL('-',132)+IMPSTR(cIMPCOM)                   
   @ PRow()+ 1,20 SAY ACENTO('Quantidade de Funcion rios --> ')                       
   @ PRow(),53    SAY QTFUN                                         PICT '###'        
   IF SAISAL
      @ PRow(),100 SAY SALTOT PICT "@E 999,999,999,999.99"        
   ENDIF
   @ PRow()+ 1,0 SAY IMPSTR(cIMPEXP)+REPL('-',132)         
   IMPFOL()
ENDIF
RETU .T.
// : FIM: FORES_B3.PRG


*+ EOF: fores_b3.prg
*+
