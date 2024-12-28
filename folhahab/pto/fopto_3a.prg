*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_3a.prg
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
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


////#INCLUDE "COMANDO.CH"


IF !MDL('FOPTO_3A - Escala de Revezamento')
   RETU
ENDIF

PAG  := 1
DIAX := DATE()
cPE  := "PE"+ANOMESW



IF !NETUSE("FO_RELHR")
   DBCLOSEALL()
   RETU .F.
ENDIF


IF !NETUSE(cPE)
   DBCLOSEALL()
   RETU .F.
ENDIF

FILTRO := ''
FI     := trim(FILTRO)
FILTRO := FILTRO(FI)
set filter to &FILTRO



IMPRESSORA()
DBSELECTAR("FO_RELHR")
DBGOTOP()
WHILE !EOF()
   IF HFOL00 = "S" .AND. !EMPTY(GRUPO)
      xGRUPO := GRUPO
      CABEC('Escala de Revezamento','',,"Grupo Data       Horario Entrada Refeitorio  Saida")
      @ PROW()+ 1,0 SAY NUMERO               
      @ PROW(),10   SAY NOME                 
      @ PROW()+ 1,0 SAY REPL("=",80)         
      DBSELECTAR(cPE)
      DBGOTOP()
      DBSEEK(xGRUPO)
      WHILE xGRUPO = GRUPO .AND. !EOF()
         @ PROW()+ 1,0 SAY GRUPO                      
         @ PROW(),03   SAY DATA                       
         @ PROW(),12   SAY TIRACE(CDIA(DATA))         
         @ PROW(),20   SAY CODREV                     
         DO CASE
         CASE CODREV = "FO"
            @ PROW(),25 SAY "FOLGA"         
         CASE CODREV = "FE"
            @ PROW(),25 SAY "FERIADO"         
         CASE CODREV = "SA"
            @ PROW(),25 SAY "SABADO"         
         CASE CODREV = "DO"
            @ PROW(),25 SAY "DOMINGO"         
         OTHERWISE
            @ PROW(),23 SAY ENTREV         
            IF !EMPTY(ALIREV) .AND. !EMPTY(ALSREV)
               @ PROW(),30 SAY ALIREV         
               @ PROW(),37 SAY ALSREV         
            ENDIF
            @ PROW(),44 SAY SAIREV         
         ENDCASE
         DBSKIP()
      ENDDO
      IMPFOL()
   ENDIF
   DBSELECTAR("FO_RELHR")
   DBSKIP()
ENDDO
DBCLOSEALL()
IMPEND()


*+ EOF: fopto_3a.prg
*+
