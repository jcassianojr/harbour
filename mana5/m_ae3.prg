*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ae3.prg
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

MDI("Gerar Escala de Maquina")
IF MDG("Reprocessar Passos da Ordem de Fabrica‡Æo")
   M_AOY()
ENDIF
nINI := nFIM := ZDATA
cZER := cINI := cAPA := cSAL := cGER := cAPG := "N"
@ 20,00 CLEA
@ 20,00 SAY "Digite o Periodo"                                                       
@ 21,00 SAY "Apaga Escala Anterior"                                                  
@ 21,40 SAY "Apagar os Saldos"                                                       
@ 22,00 SAY "Atualizar Inicial"                                                      
@ 22,40 SAY "Apagar Tudo"                                                            
@ 23,00 SAY "Gera Programa‡ao Produ‡„o"                                              
@ 23,40 SAY "Apaga Programa‡ao Anterior"                                             
@ 20,30 GET nINI                         VALID !EMPTY(nINI)                          
@ 20,40 GET nFIM                                                                     
@ 21,30 GET cAPA                         PICT "!"           VALID cAPA $ "SN "       
@ 21,70 GET cSAL                         PICT "!"           VALID cSAL $ "SN "       
@ 22,30 GET cINI                         PICT "!"           VALID cINI $ "SN "       
@ 22,70 GET cZER                         PICT "!"           VALID cZER $ "SN "       
@ 23,30 GET cGER                         PICT "!"           VALID cGER $ "SN "       
@ 23,70 GET cAPG                         PICT "!"           VALID cAPG $ "SN "       
IF !READCUR()
   RETU .F.
ENDIF

aRETU  := PEGMES({"E3","EA"},.T.,{"ME03","ME03A"})
nMES   := aRETU[1]
nANO   := aRETU[2]
cME03  := aRETU[5,1]
cME03A := aRETU[5,2]

IF !USEMULT({{cME03,0,99},{"ME01",1,1}})
   RETU .F.
ENDIF
DBSELECTAR("ME01")
SET FILTER TO CHT = "S"
DBSELECTAR(cME03)
DBSETORDER(1)
IF cZER = "S"
   ZAP
   PACK
ELSE
   IF cAPA = "S"
      nLASTREC := LASTREC()
      zei_fort(nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{|| DATA < nINI},{|| zei_fort(nLASTREC,,,1)})
      zei_fort(nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{|| DATA > nFIM},{|| zei_fort(nLASTREC,,,1)})
      IF cSAL = "S"
         zei_fort(nLASTREC,,,0)
         DBEVAL({|| netgrvcam("ESTQSAI",0)},,{|| zei_fort(nLASTREC,,,1)})
         zei_fort(nLASTREC,,,0)
         DBEVAL({|| netgrvcam("ESTQSAL",ESTQINI)},,{|| zei_fort(nLASTREC,,,1)})
      ENDIF
      PACK
   ENDIF
ENDIF
MDS("Gerando Escala")
DBSELECTAR("ME01")
DBGOTOP()
WHILE !EOF()
   @ 24,20 SAY NUMERO         
   aHORAS  := {CH1,CH2,CH3,CH4,CH5,CH6,CH7}
   xNUMERO := NUMERO
   DBSELECTAR(cME03)
   FOR W := nINI TO nFIM
      @ 24,30 SAY W         
      DBGOTOP()
      IF !DBSEEK(xNUMERO+DTOS(W))
         netrecapp()
         FIELD->NUMERO  := xNUMERO
         FIELD->DATA    := W
         FIELD->ESTQINI := aHORAS[DOW(W)]
      ELSE
         IF cINI = "S"
            FIELD->ESTQINI := aHORAS[DOW(W)]
         ENDIF
      ENDIF
      FIELD->ESTQSAL := ESTQINI - ESTQSAI
   NEXT W
   DBSELECTAR("ME01")
   DBSKIP()
ENDDO
DBSELECTAR("ME01")
DBCLOSEAREA()

IF cGER <> "S"
   DBCLOSEALL()
   RETU
ENDIF

IF !USEMULT({{"OF03",1,3},{cME03A,0,99},{"ME02",1,2}})
   RETU .F.
ENDIF
DBSELECTAR(cME03A)
DBSETORDER(1)
IF cAPG = "S"
   ZAP
ENDIF
MDS("Programando")
DBSELECTAR("OF03")
DBGOTOP()
WHILE DLIMP <= nFIM .AND. !EOF()
   xOF      := OF
   xSEQ     := SEQ
   xSSQ     := SSQ
   xCODCOMP := CODMP01
   xDLIMP   := DLIMP
   xQTTIME  := QTTIME
   xQTFAL   := QTFAL
   nSTART   := QTTIME * QTFAL
   aMAQ     := {}
   IF nSTART < 0.0001 .OR. EMPTY(xCODCOMP)
      DBSELECTAR("OF03")
      DBSKIP()
      LOOP
   ENDIF
   @ 24,20 SAY xOF              
   @ 24,30 SAY xCODCOMP         
   DBSELECTAR("ME02")
   DBGOTOP()
   DBSEEK(xCODCOMP)   //1a Opcao
   WHILE ALLTRIM(xCODCOMP) = ALLTRIM(CODMP01) .AND. !EOF()
      AADD(aMAQ,NUMERO)
      DBSKIP()
   ENDDO
   IF LEN(aMAQ) = 0
      DBSELECTAR("OF03")
      DBSKIP()
      LOOP
   ENDIF
   DBSELECTAR(cME03)
   FOR W := 1 TO LEN(aMAQ)
      FOR Q := nINI TO nFIM
         DBGOTOP()
         IF DBSEEK(aMAQ[W]+DTOS(Q)) .AND. ESTQSAL > 0
            mSALDO := ESTQSAL
            nUSO   := 0
            DO CASE
               CASE mSALDO = nSTART
                  FIELD->ESTQSAI := ESTQSAI+mSALDO
                  nUSO           := mSALDO
                  nSTART         := 0
               CASE mSALDO >= nSTART
                  FIELD->ESTQSAI := ESTQSAI+nSTART
                  nUSO           := nSTART
                  nSTART         := 0
               CASE mSALDO <= nSTART
                  FIELD->ESTQSAI := ESTQSAI+mSALDO
                  nUSO           := mSALDO
                  nSTART         -= mSALDO
            ENDCASE
            FIELD->ESTQSAL := ESTQINI - ESTQSAI
            DBSELECTAR(cME03A)
            netrecapp()
            FIELD->NUMERO  := aMAQ[W]
            FIELD->OF      := xOF
            FIELD->SEQ     := xSEQ
            FIELD->SSQ     := xSSQ
            FIELD->DATA    := Q
            FIELD->QTDDE   := nUSO
            FIELD->QTDPEC  := INT((nUSO / xQTTIME)+0.0001)
            FIELD->CODMP01 := xCODCOMP
            FIELD->CODRES  := IF(xDLIMP <= Q,"A","")
            DBSELECTAR(cME03)
         ENDIF
         IF nSTART <= 0.0001
            EXIT
         ENDIF
      NEXT Q
      IF nSTART <= 0.0001
         EXIT
      ENDIF
   NEXT W
   IF nSTART > 0
      DBSELECTAR(cME03A)
      netrecapp()
      FIELD->NUMERO  := "ZZZZ"
      FIELD->OF      := xOF
      FIELD->SEQ     := xSEQ
      FIELD->SSQ     := xSSQ
      FIELD->DATA    := xDLIMP
      FIELD->QTDDE   := nSTART
      FIELD->CODMP01 := xCODCOMP
      FIELD->CODRES  := "S"
   ENDIF
   DBSELECTAR("OF03")
   DBSKIP()
ENDDO
DBCLOSEALL()
