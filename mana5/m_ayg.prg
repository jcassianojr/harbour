*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ayg.prg
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

MDI(" Ý Requisi‡”es Conforme NF")
CRIARVARS("MY01")
mFORNECEDO := 0
dDATA      := DATE()
MDS("Confirme a Data")
@ 24,40 GET dDATA         
IF !READCUR()
   RETU .F.
ENDIF

aBAI := {}
aDES := {}
IF !USEREDE("MSBAI",1,0)
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   AADD(aBAI,ORIGEM+STR(PLANTA,8))
   AADD(aDES,DESTINO)
   DBSKIP()
ENDDO
DBCLOSEAREA()


aRETU  := PEGMES({"M2","M1"},.T.,{"MM02","MM01"})
cARQ   := aRETU[5,1]
cARQNF := aRETU[5,2]

MDS("Aguarde Transferencia")
IF !USEMULT({{cARQ,1,0},{cARQNF,1,1},{"MY01",1,99}})
   DBCLOSEALL()
   RETU .F.
ENDIF
INITVARS()
CLRVARS()
DBSELECTAR(cARQ)
DBGOTOP()
WHILE !EOF()
   IF TIPOENT = "P" .AND. DATA = dDATA .AND. !EMPTY(OS) .and. ;
              ! EMPTY(CODIGO) .AND. FATBX <> "S" .AND. !IMPMY   //Aind Nao Importada
      mNUMERO  := NUMERO
      lCANCELA := .F.
      DBSELECTAR(cARQNF)
      DBGOTOP()
      IF DBSEEK(mNUMERO)
         IF CANCELADA = "S"
            lCANCELA := .T.
         ENDIF
      ENDIF
      DBSELECTAR(cARQ)
      IF !lCANCELA
         wNOTA := NUMERO
         wSEQ  := SEQ
         wOS   := OS
         @ 24,00 SAY NUMERO         
         @ 24,10 SAY CODIGO         
         @ 24,40 SAY OS             
         EQUVARS()
         mQTDE    := CONVUN(mQTDE,mUNID)
         mTIPOENT := "P"  //Produto
         mTIPO1   := "S"  //Saida
         mTIPO2   := "P"  //Produto
         mTIPO3   := "NFS"
         mCODIGO  := CODIGO
         mNUMMB01 := FORNECEDO
         nPOS     := ASCAN(aBAI,mCODIGO+STR(mFORNECEDO,8))
         IF nPOS > 0
            mCODIGO := aDES[nPOS]
         ENDIF
         yCODIGO   := mCODIGO
         mOLDQTDDE := 0
         //mNUMERO:=(mNUMERO*100)+SEQ
         mOS := wNOTA+(SEQ / 100)
         DBSELECTAR("MY01")
         DBGOBOTTOM()
         mNUMERO  := NUMERO+1
         wREQUISI := mNUMERO
         NOVOOPA("MY01")
         MAM2K05("I","MY01S")
         DBSELECTAR(cARQ)
         GRAVACAMPO("IMPMY",".T.")
      ENDIF
   ENDIF
   DBSELECTAR(cARQ)
   DBSKIP()
ENDDO
RELEASE ALL LIKE M *
DBCLOSEALL()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AYG2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC M_AYG2

MDI(" Ý Requisi‡”es Conforme RIF")
CRIARVARS("MY01")
mFORNECEDO := 0
dDATA      := DATE()
MDS("Confirme a Data")
@ 24,40 GET dDATA         
IF !READCUR()
   RETU .F.
ENDIF
cARQ := "RIF"
@ 23,00 SAY "Esc Encerra"         
IF !USEMULT({{cARQ,1,3},{"MY01",1,99}})
   DBCLOSEALL()
   RETU .F.
ENDIF
INITVARS()
CLRVARS()
DBSELECTAR(cARQ)
DBGOTOP()
DBSEEK(dDATA)
WHILE !EOF()
   @ 24,70 SAY RECNO()         
   WHILE DATA = dDATA .AND. !EOF()
      IF !IMPORTADO
         cIMP := "S"
         @ 24,00 SAY RIF                 
         @ 24,10 SAY CODIGO              
         @ 24,35 SAY OS                  
         @ 24,45 SAY QTDE                
         @ 24,55 SAY "Importar "         
         @ 24,65 GET cIMP                
         IF !READCUR()
            EXIT
         ENDIF
         IF cIMP = "S"
            yCODIGO   := CODIGO
            wCODIGO   := CODIGO
            wQTDE     := QTDE
            mOLDQTDDE := 0
            mNRNOTA   := RIF
            //           mNUMERO:=RIF
            mQTDE    := QTDE
            mTIPOENT := "P"   //Produto
            mTIPO1   := "E"   //Entrada
            mTIPO2   := "P"   //Produto
            mTIPO3   := "RIF"
            mCODIGO  := CODIGO
            mDATA    := DATA
            mUNID    := "PC"
            //           mOS:=INT(OS)
            //           mITEM:=OS-INT(OS)
            mOS        := RIF
            mDISTRI    := "N"
            mRASTRO    := RASTRO
            mTECNICO   := INSNUM
            mREQINT    := RIF
            mNUMMB01   := CLIENTE
            mFORNECEDO := CLIENTE
            DBSELECTAR("MY01")
            DBGOBOTTOM()
            mNUMERO := NUMERO+1
            NOVOOPA("MY01")
            MAK2K05("I","MY01E")
            MAY05("ESTQENT+wQTDE")
            DBSELECTAR(cARQ)
            GRAVACAMPO("IMPORTADO",".T.")
         ENDIF
      ENDIF
      DBSELECTAR(cARQ)
      DBSKIP()
   ENDDO
ENDDO
RELEASE ALL LIKE M *
DBCLOSEALL()



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAYG01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAYG01(nQTDDE,cARQ,cTIP,dDATLIM)

IF nQTDDE < 0.0001
   RETU .T.
ENDIF
IF VALTYPE(cTIP) # "C"
   cTIP := "S"
ENDIF
DBSELECTAR(cARQ)
netrecapp()
FIELD->CODIGO  := yCODIGO
FIELD->OS      := wOS
FIELD->OF      := 0
FIELD->QTDDE   := nQTDDE
FIELD->REQUISI := wREQUISI
FIELD->NRNOTA  := wNOTA
FIELD->SEQ     := wSEQ
FIELD->BAIXA   := dDATA
FIELD->TIPO    := cTIP
FIELD->DLIMITE := dDATLIM
IF TYPE("wDPEDI") = "D"
   FIELD->DPEDI := wDPEDI
ENDIF
IF TYPE("wDLIMP") = "D"
   FIELD->DLIMP := wDLIMP
ENDIF
DBUNLOCK()
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAYG02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAYG02(nQTDDE,cARQ,cARQ2,nOS)

IF VALTYPE(nOS) = "N"
   mOS := nOS
ENDIF
WHILE !USEREDE(cARQ,1,99)
ENDDO
DBSETORDER(1)
WHILE !USEREDE(cARQ2,1,99)
ENDDO
DBSETORDER(1)
mQTDEINI := nQTDDE
DBSELECTAR(cARQ)
DBGOTOP()
DBSEEK(PADR(yCODIGO,24)+STR(mOS,8,2))
WHILE ALLTRIM(yCODIGO) = ALLTRIM(CODIGO) .AND. mOS = OS .AND. mQTDEINI > 0 .AND. !EOF()
   mRESERVA := QTDDE
   DO CASE
      CASE mRESERVA = mQTDEINI
         DELEREG(,,.F.,.F.)
         MAYG01(mRESERVA,cARQ2,,DLIMITE)
         mQTDEINI := 0
      CASE mRESERVA > mQTDEINI
         netgrvcam("QTDDE",QTDDE - mQTDEINI)
         MAYG01(mQTDEINI,cARQ2,,DLIMITE)
         mQTDEINI := 0
      CASE mRESERVA < mQTDEINI
         DELEREG(,,.F.,.F.)
         MAYG01(mRESERVA,cARQ2,,DLIMITE)
         mQTDEINI -= mRESERVA
   ENDCASE
   DBSELECTAR(cARQ)
   DBSKIP()
ENDDO
DBSELECTAR(cARQ)
DBCLOSEAREA()
DBSELECTAR(cARQ2)
DBCLOSEAREA()
RETU .T.
