*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : cnab400r.prg
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

MDI(" LER Arquivo CNAB Retorno")
cARQUIVO := "p:\novell\ITAESBRA\RETCOB\"+SPACE(50)
@ 23,00 SAY "Arquivo"         
@ 24,00 GET cARQUIVO          
IF !READCUR()
   RETU .F.
ENDIF
cARQUIVO := ALLTRIM(cARQUIVO)
cBANCO   := "   "
IF ! file(cARQUIVO)
   ALERTX("Arquivo Inexistente "+Carquivo)
   RETU .F.
ENDIF
IF !USEREDE("CNAB400R",0,99)
   RETU .F.
ENDIF
INITVARS()
CLRVARS()
ZAP
nHANDLE := hb_FOPEN(cARQUIVO)
IF nHANDLE <= 0
   DBCLOSEALL()
   ALERTX("Erro Abrindo "+Carquivo)
   RETU .F.
ENDIF
lPRI     := .F.
cLINHA01 := ""
nLINHA   := 0
WHILE .T.
   cVAR := FREADLINE(nHANDLE)
   if empty(cLINHA01)
      cLINHA01 := cVAR
   else
      lPRI := .T.
   endif
   nLINHA ++
   @ 23,00 say "Linha "+str(nLINHA,8)         
   @ 24,00 say left(cVAR,3)                   
   do case
      case cLINHA01 = cVAR .and. lPRI
         ALERTX("Retornou ao primeiro Registro")
         if MDG("Encerrar Importacao-Recomendavel")
            exit
         endif
      case left(cVAR,3) = "   "
         ALERTX("Linha em Branco")
         if MDG("Encerrar Importacao-Recomendavel")
            exit
         endif
      CASE LEFT(cVAR,1) = "0"
         mCODBCO := SUBSTR(cVAR,77,3)
      CASE LEFT(cVAR,1) = "1"
         mTITEMP := SUBSTR(cVAR,38,25)
         DO CASE
            CASE mCODBCO = "074"  //Safra
               mTITBAN := SUBSTR(cVAR,127,20)
            OTHERWISE   //104 Caixa 021 banestes 479 boston
               mTITBAN := SUBSTR(cVAR,63,11)
               mINDOPE := SUBSTR(cVAR,83,24)
         ENDCASE
         mCODREG := SUBSTR(cVAR,80,3)
         DO CASE
            CASE mCODBCO = "104"  //CAIXA
               mCODCAR := SUBSTR(cVAR,107,2)
            OTHERWISE
               mCODCAR := SUBSTR(cVAR,108,1)  //1-simples 2-direto 3-escritural
         ENDCASE
         mCODOCO  := SUBSTR(cVAR,109,2)
         mDATAOCO := CTOD(SUBSTR(cVAR,111,2)+"/"+SUBSTR(cVAR,113,2)+"/"+SUBSTR(cVAR,115,2))
         mSEUNUM  := SUBSTR(cVAR,117,10)
         cDATA    := SUBSTR(cVAR,147,2)+"/"+SUBSTR(cVAR,149,2)+"/"+SUBSTR(cVAR,151,2)
         //         ALERTX(cDATA)
         mDATAVEN := CTOD(cDATA)
         DO CASE
            CASE mCODBCO = "021"  //Banestes
               mVALTIT := VAL(SUBSTR(cVAR,156,10)) / 100
            OTHERWISE
               mVALTIT := VAL(SUBSTR(cVAR,153,13)) / 100
         ENDCASE
         mAGCBCO := SUBSTR(cVAR,169,5)
         mESPTIT := SUBSTR(cVAR,174,2)
         //dm dupmercantil ds-dupservico ns-nota seguro
         //re recibo escola rs-rescibo associacao rc recibo concodminio
         //nd nota  debito ot outros
         mVALDEP    := VAL(SUBSTR(cVAR,176,13)) / 100
         mVALDEPOUT := VAL(SUBSTR(cVAR,189,13)) / 100
         mVALJURATR := VAL(SUBSTR(cVAR,202,13)) / 100
         mVALIOF    := VAL(SUBSTR(cVAR,215,13)) / 100
         mVALABT    := VAL(SUBSTR(cVAR,228,13)) / 100
         mVALDES    := VAL(SUBSTR(cVAR,241,13)) / 100
         mVALPAG    := VAL(SUBSTR(cVAR,254,13)) / 100
         mVALJUR    := VAL(SUBSTR(cVAR,267,13)) / 100
         DO CASE
            CASE mCODBCO = "479"
            OTHERWISE
               mVALMUL := VAL(SUBSTR(cVAR,280,13)) / 100  //Outros Creditos
         ENDCASE
         DO CASE
            CASE mCODBCO = "104"  //CAIXA
               mCODMOD := SUBSTR(cVAR,293,1)
            CASE mCODBCO = "021"  //bANESTES
               mCODMOD := SUBSTR(cVAR,394,1)
         ENDCASE
         DO CASE
            CASE mCODBCO = "021"  //bANESTES
               mMOTPRO := SUBSTR(cVAR,295,1)
         ENDCASE
         IF mMOTPRO = "0"
            mMOTPRO := "N"
         ENDIF
         IF mMOTPRO = "1"
            mMOTPRO := "S"
         ENDIF
         IF mMOTPRO = "D"   //Despresado
            mMOTPRO := "N"
         ENDIF
         IF mMOTPRO = "A"   //aCEITO
            mMOTPRO := "S"
         ENDIF
         mMOTREG01 := SUBSTR(cVAR,319,10)   //5 Motivos 2 digitos
         mMOTREG02 := SUBSTR(cVAR,321,10)   //5 Motivos 2 digitos
         mMOTREG03 := SUBSTR(cVAR,323,10)   //5 Motivos 2 digitos
         mMOTREG04 := SUBSTR(cVAR,325,10)   //5 Motivos 2 digitos
         mMOTREG05 := SUBSTR(cVAR,327,10)   //5 Motivos 2 digitos
         DO CASE
            CASE mCODBCO = "479"  //Boston
               mLIQDATA := CTOD(SUBSTR(cVAR,280,2)+"/"+SUBSTR(cVAR,282,2)+"/"+SUBSTR(cVAR,284,2))
         ENDCASE
         DO CASE
            CASE mCODBCO = "479"  //Boston
               mCREDATA := CTOD(SUBSTR(cVAR,286,2)+"/"+SUBSTR(cVAR,288,2)+"/"+SUBSTR(cVAR,290,2))
            CASE mCODBCO = "104"  //Caixa
               mCREDATA := CTOD(SUBSTR(cVAR,294,2)+"/"+SUBSTR(cVAR,296,2)+"/"+SUBSTR(cVAR,298,2))
            CASE mCODBCO = "074"  //Safra
               mCREDATA := CTOD(SUBSTR(cVAR,296,2)+"/"+SUBSTR(cVAR,298,2)+"/"+SUBSTR(cVAR,300,2))
         ENDCASE
         mSEQARQ := VAL(SUBSTR(cVAR,395))
         netrecapp()
         replvars()
   ENDCASE
ENDDO
fclose(nHANDLE)

PADRAO(0,1,0,"CNAB400R","Titulo Empresa            SeuNumero  Vcto     Valor        Seq","' '+mTITEMP+' '+mSEUNUM+' '+DTOC(mDATAVEN)+' '+STR(mVALTIT, 12, 2)+' '+STR(mSEQARQ,  6)","CNABR1")



