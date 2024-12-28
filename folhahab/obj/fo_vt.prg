*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo_vt.prg
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


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function vtatutk()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION vtatutk(nTIPO)

IF nTIPO = 1
   cARQUIVO := "STTWTT.TXT"+SPACE(70)
ELSE
   cARQUIVO := "INSUMOS.CSV"+SPACE(70)
ENDIF
@ MAXROW(),MAXCOL() GET cARQUIVO         
READCUR()



if !netuse("VTCONTA")
   return .f.
ENDIF
dbgobottom()
mCODIGO := CODIGO
DBSETORDER(2)


cLINHA      := ""
nLINES      := FLineCount(cARQUIVO)
nFileHandle := hb_FOpen(cARQUIVO)

zei_fort(nLines,,,0)

IF nTIPO = 2  //Pula 1a linha
   HB_FReadLine(nFileHandle,@cLinha)
ENDIF

DO WHILE HB_FReadLine(nFileHandle,@cLinha) == 0
   IF nTIPO = 1
      mTKCODBIL := SUBSTR(cLINHA,7,12)
      mTKCODOPE := SUBSTR(cLINHA,1,6)
      mCOMPL    := SUBSTR(cLINHA,19,4)
      mFACIAL   := SUBSTR(cLINHA,69,1)
      mESTADO   := SUBSTR(cLINHA,78,2)
      cDATA     := SUBSTR(cLINHA,44,8)
      cDATA     := SUBSTR(cDATA,7,2)+"/"+SUBSTR(cDATA,5,2)+"/"+SUBSTR(cDATA,1,4)
      dDATAATU  := CTOD(cDATA)
      nvalor    := val(substr(cLINHA,23,9))
   ELSE
      aCAMPOS := HB_ATokens(LINHA,";")
      IF LEN(aCAMPOS) > 0
         mTKCODBIL      := aCAMPOS[1]
         mNOME          := aCAMPOS[2]
         mCODIGO_REGIAO := aCAMPOS[3]
         mTIPO_VT       := aCAMPOS[4]
         mQT_MINIMO     := VAL(aCAMPOS[5])
         mQT_MAXIMO     := VAL(aCAMPOS[6])
         mVL_MINIMO     := VAL(aCAMPOS[7]) / 100
         mVL_MAXIMO     := VAL(aCAMPOS[8]) / 100
         cDATA          := aCAMPOS[9]
         cDATA          := SUBSTR(cDATA,1,2)+"/"+SUBSTR(cDATA,3,2)+"/"+SUBSTR(cDATA,5,4)
         dDATAATU       := CTOD(cDATA)
         mPRECO         := aCAMPOS[10]
         nVALOR         := VAL(mPRECO) / 100
      ENDIF
   ENDIF
   IF !EMPTY(mTKCODBIL)
      dbgotop()
      if !dbseek(mTKCODBIL)
         netrecapp()
         //dbappend()
         mCODIGO ++
         field->CODIGO := mCODIGO
         IF nTIPO = 1
            field->TKCODBIL := mTKCODBIL
            field->DESCR    := mTKCODBIL
            field->TKCODOPE := mTKCODOPE
            field->COMPL    := mCOMPL
            field->FACIAL   := mFACIAL
            field->ESTADO   := mESTADO
         ELSE
            field->VBCODBIL := mTKCODBIL
            field->DESCR    := mNOME
            field->VBREGIAO := mCODIGO_REGIAO
            field->VBTIPO   := mTIPO_VT
            field->QTDEMIN  := mQT_MINIMO
            field->QTDEMAX  := mQT_MAXIMO
            field->VALMIN   := mVL_MINIMO
            field->VALMAX   := mVL_MAXIMO
         ENDIF
      else
         netreclock()
      ENDIF
      field->DATAATU := dDATAATU
      field->valor   := nVALOR
   ENDIF
   zei_fort(nLINES,,,1)
enddo
fclose(nFileHandle)
dbcloseall()
FERASE("VTCONTA.CDX")
INFOR("VTCONTA","CODIGO","VTCONTA",.T.)

IF nTIPO <> 1
   RETURN
ENDIF

if !NETUSE("VTOPER")
   retu
endif
dbgobottom()
mNUMERO := NUMERO
dbsetorder(2)

cLINHA      := ""
nLINES      := FLineCount("STTWOP.TXT")
nFileHandle := hb_FOpen("STTWOP.TXT")



zei_fort(nLines,,,0)

DO WHILE HB_FReadLine(nFileHandle,@cLinha) == 0
   mCODOPE := SUBSTR(cLINHA,1,6)
   dbgotop()
   if !dbseek(mCODOPE)
      netrecapp()
      mNUMERO ++
      field->NUMERO   := mNUMERO
      field->TKCODOPE := mCODOPE
      field->NOME     := SUBSTR(cLINHA,19,40)
      field->COGNOME  := SUBSTR(cLINHA,7,12)
      field->ESTADO   := SUBSTR(cLINHA,60,2)
   else
      netreclock()
   ENDIF
   zei_fort(nLINES,,,1)
enddo
fclose(nFileHandle)
dbcloseall()
FERASE("VTOPER.CDX")
INFOR("VTOPER","NUMERO","VTOPER",.T.)




//tipo=1 ticket
//http://www.ticketseg.com.br/comunidade/Empresas/TicketTransporte/TarifasdeConducao.aspx
//Nome do campo 	                        In°cio 	Fim 	Tam. 	Tipo 	Descriá∆o
//C¢digo da operadora 	                     001 	006 	006 	X 	Identificaá∆o da operadora
//Nome fantasia da operadora 	               007 	018 	012 	X 	Nome fantasia
//Raz∆o social da operadora 	               019 	058 	040 	X 	Raz∆o social
//Flag identificador da origem do registro 	059 	059 	001 	X 	"T" (fixo)
//Estado 	060 	061 	002 	X 	Estado

//ARQUIVO: STTWTT.TXT
//Nome do campo 	                In°cio 	Fim 	Tam. 	Tipo 	Descriá∆o
//C¢digo da operadora 	             001 	006 	006 	X 	Identificaá∆o da operadora
//C¢digo do bilhete 	                007 	018 	012 	X 	Identificaá∆o do bilhete
//Complemento do bilhete 	          019 	022 	004 	X 	Complemento do bilhete
//Tarifa atual da conduá∆o 	       023 	031 	009 	N 	"999999.99"
//Flag para uso interno Ticket 	    032 	032 	001 	X 	"T" (fixo)
//Flag para uso interno Ticket 	    033 	033 	001 	X 	"F" (fixo)
//Campo de uso interno Ticket 	    034 	042 	009 	N 	"999999.99"
//Flag para uso interno Ticket 	    043 	043 	001 	X 	" ";"S";"N"
//Data de vigància da tarifa 	       044 	051 	008 	D 	"AAAAMMDD"
//Data para uso interno Ticket 	    052 	059 	008 	D 	"AAAAMMDD"
//Campo de uso interno Ticket 	    060 	068 	009 	N 	"999999.99"
//Flag identificador dos bilhetes 	 069 	069 	001 	X 	S = Bilhete tem valor facial de valores faciais N = Bilhete n∆o tem valor facial.
//Data para uso interno Ticket 	    070 	077 	008 	D 	"AAAAMMDD"
//Estado 	                         078 	079 	002 	X 	Estado


//tipo=2 vbonline
//CODIGO;NOME;CODIGO_REGIAO;TIPO_VT;QT_MINIMO;QT_MAXIMO;VL_MINIMO;VL_MAXIMO;DT_PRAZOI_PRE;PRECO
//1514;INTERSUL - JUQUIA / SAO PAULO                ;1;P;     ;     ;             ;             ;28022008;2450

*+ EOF: fo_vt.prg
*+
