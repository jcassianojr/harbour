*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_au4.prg
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



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_au4()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_au4

para ARQBASE,cSTR

aRETU := PEGMES({""},.F.,{""})
cVAR  := aRETU[4]+aRETU[3]

CHECKARQ(ARQBASE,cSTR+cVAR,,,ZDIRP+"E"+strzero(znumero,3)+strzero(aRETU[2],4)+"\",aRETU[2],aRETU[1])

PADRAO(1,1,0,cSTR+cVAR,"C¢digo"+spac(7)+"Seq   Data     Hist¢rico"+spac(22)+"T Quantidade",;
 "' '+mCODIGO+' '+STR(mSEQ,  5)+' '+DTOC(mDATA)+' '+mHISTORICO+' '+mTIPOENT+' '+STR(mQTDDE, 12, 2)",;
 "MAU4",,{|| gMAU4()},;
 {|| mCODIGO := xCODIGO},{|| PADARR(ARQWORK,xCODIGO,"CODIGO","XCODIGO")})

MDS("Aguarde Calculando")
while !USEREDE(ARQWORK,1,99)
enddo
dbgotop()
dbseek(xCODIGO)
while xCODIGO = CODIGO .and. !eof()
   mESTOQUE  := TOTQTDDE
   mVALORANT := TOTPRECO
   mMEDIO    := round(mVALORANT / mESTOQUE,3)
   dbskip()
   if xCODIGO = CODIGO .and. !eof()
      netreclock()
      field->TOTQTDDE := mESTOQUE+if(TIPOENT = "E",QTDDE,- QTDDE)
      if TIPOENT = "S" .or. TIPOENT = "F"
         field->PRECO := mMEDIO
      endif
      if TIPOENT # "F"
         field->TOTITEM := round(PRECO * QTDDE,2)
      endif
      do case
         case TIPOENT = "S"
            field->TOTPRECO := mVALORANT - TOTITEM
         case TIPOENT = "E"
            field->TOTPRECO := mVALORANT+TOTITEM
         case TIPOENT = "F"
            field->TOTPRECO := mVALORANT+TOTITEM
      endcase
      field->MEDIO := round(TOTPRECO / TOTQTDDE,3)
      dbunlock()
   endif
enddo
dbcloseall()
retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMAU4()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func gMAU4


setcolor(PAD002)
@  4,20 get mDATA                                                        
@  4,29 get mHISTORICO                                                   
@  4,60 get mTIPOENT   valid mTIPOENT $ "ESF "                           
@  4,62 get mQTDDE     picture '999999999.99'  when mTIPOENT # "F"       
READCUR()
if mTIPOENT = "E"
   @  6,20 say "Pre‡o"         
   @  7,20 get mPRECO          
endif
if mTIPOENT = "F"
   @  6,20 say "Valor Frete"         
   @  7,20 get mTOTITEM              
endif
if mSEQ = 1
   @  6,1  say "Estoque"+spac(12)+"     "+spac(8)+"Acumulado"         
   @  7,1  get mTOTQTDDE                                              
   @  7,33 get mTOTPRECO                                              
endif
READCUR()
if mSEQ = 1
   mMEDIO := round(mTOTPRECO / mTOTQTDDE,3)
endif
retu .T.

