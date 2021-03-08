*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aoy.prg
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

MDI(" Ý Reprocessar Passos da Ordem de Fabricacao")
IF !USEREDE("OF03",0,99)
   RETU .F.
ENDIF
MDS("Apagando Reprocesso Anterior")
ZAP
INITVARS()
CLRVARS()
IF !USEREDE("OF01",1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
IF !USEREDE("MS06",1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF

MDS("Gerando Processos")
DBSELECTAR("OF01")
WHILE !EOF()
   IF QFABRICAR > 0
      @ 24,30 SAY OF PICT "999.99"        
      mOF      := OF
      mITEM    := ITEM
      mCODIGO  := CODIGO
      mDLIMP   := DLIMP
      mDLIMITE := DLIMITE
      mDPEDI   := DPEDI
      mQTFAB   := CONVUN(QFABRICAR,UNID)
      mQTFAL   := mQTFAB
      DBSELECTAR("MS06")
      DBGOTOP()
      DBSEEK(mCODIGO)
      WHILE mCODIGO = CODIGO .AND. !EOF()
         IF SEQ = 99  //Encerrou Sequencia
            EXIT
         ENDIF
         @ 24,40 SAY SEQ PICT "999"        
         @ 24,44 SAY SSQ PICT "999"        
         mSEQ      := SEQ
         mSSQ      := SSQ
         mCODMP01  := CODMP01
         mCODMP02  := CODMP02
         mCODMP02B := CODMP02B
         mCODMP02C := CODMP02C
         mCODMP02D := CODMP02D
         mCODMP03  := CODMP03
         mQTTIME   := IF(PCHORA > 0,1 / PCHORA,0)
         IF FATOR # 0
            mQTTIME := mQTTIME * FATOR
         ENDIF
         DBSELECTAR("OF03")
         netrecapp()
         REPLVARS()
         DBSELECTAR("MS06")
         DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR("OF01")
   DBSKIP()
ENDDO
DBSELECTAR("OF01")
DBCLOSEAREA()

DBSELECTAR("OF03")
DBSETORDER(2)
MDS("Distribuindo Saldos")
DBSELECTAR("MS06")
DBGOTOP()
WHILE !EOF()
   @ 24,30 SAY SEQ    PICT "999"        
   @ 24,34 SAY SSQ    PICT "999"        
   @ 24,40 SAY CODIGO                   
   nREG    := RECNO()
   cCODIGO := CODIGO
   cSEQ    := SEQ
   nSALDO  := 0
   DBSKIP()   //O Processo e calculado com o saldo posterior
   WHILE cCODIGO = CODIGO .AND. !EOF()  //Pois o saldo deste processo ainda n„o foi finalizado
      IF ESTQSAL > 0 .AND. EMPTY(SSQ)   //Nao soma sub processos
         nSALDO += ESTQSAL
      ENDIF
      DBSKIP()
   ENDDO
   IF nSALDO > 0
      DBSELECTAR("OF03")
      DBGOTOP()
      DBSEEK(cCODIGO+STR(cSEQ,3))
      WHILE cCODIGO = CODIGO .AND. cSEQ = SEQ .AND. !EOF() .AND. nSALDO > 0.0001
         mFAZER := QTFAB
         DO CASE
            CASE mFAZER = nSALDO
               FIELD->QTRES := QTRES+mFAZER
               nSALDO       := 0
            CASE mFAZER > nSALDO
               FIELD->QTRES := QTRES+nSALDO
               nSALDO       := 0
            CASE nSALDO > mFAZER
               FIELD->QTRES := QTRES+mFAZER
               nSALDO       -= mFAZER
         ENDCASE
         FIELD->QTFAL := QTFAB - QTRES
         DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR("MS06")
   DBGOTO(nREG)
   DBSKIP()
ENDDO
DBCLOSEALL()
