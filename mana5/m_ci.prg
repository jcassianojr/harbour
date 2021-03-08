*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ci.prg
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
*+    Function m_ci()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_ci

para nTIPO

MDI("Usu rios e Senhas de Acesso")

if nTIPO = 1
   while .T.
      MDS("Digite Nova Senha")
      mSENHA := PEGAPASS(24,20,8,,"Ý",.T.)
      MDS("Digite Novamente")
      mSENH2 := PEGAPASS(24,20,8,,"Ý",.T.)
      if mSENHA = mSENH2 .and. !empty(mSENHA) .and. len(alltrim(mSENHA)) >= 8
         exit
      else
         ALERTX("Senhas Diferentes, em Branco, Menos de 8 Caracter")
      endif
   enddo
   if USEREDE("MUSER",1,99)
      if dbseek(XENCODE(ZUSER))
         netreclock()
         field->SENHA   := XENCODE(mSENHA)
         field->DATATRO := ZDATA+90
         dbunlock()
      endif
      dbclosearea()
   endif
else
   IF ZSUPER
      PADRAX(0,,0,{"MUSER"},"Usuario Equivalencia","' '+XDECODE(mUSUARIO)+' '+XDECODE(mEQUIVALE)","MCI001","MCI001",,,;
       ,"MCIINS","MCI",{|| MCIIGU()},,{|| MCIANT()},{|| MCIINS()})
   ELSE
      ALERTX("Somente Administrador")
   ENDIF
endif


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MCIINS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MCIINS


mUSUARIO := XENCODE(mUSUARIO)
mCHAVE   := mUSUARIO
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MCIIGU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MCIIGU


mUSUARIO  := padr(XDECODE(mUSUARIO),10)
mEQUIVALE := padr(XDECODE(mEQUIVALE),8)
mSENHA    := padr(XDECODE(mSENHA),8)
mVALIDADE := XDECDAT(mVALIDADE)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MCIANT()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MCIANT


mUSUARIO  := XENCODE(mUSUARIO)
mEQUIVALE := XENCODE(mEQUIVALE)
mSENHA    := XENCODE(mSENHA)
mVALIDADE := XENCODE(strtran(dtoc(mVALIDADE),'/',''))
mCHAVE    := mUSUARIO
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function XDECODE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func XDECODE(cVAR)


retu if(empty(cVAR),cVAR,DECODE(cVAR))


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function XENCODE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func XENCODE(cVAR)


retu if(empty(cVAR),cVAR,ENCODE(cVAR))


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function XDECDAT()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func XDECDAT(cVAR)


cVAR := XDECODE(cVAR)
cVAR := ctod(left(cVAR,2)+'/'+substr(cVAR,3,2)+'/'+right(cVAR,2))
retu cVAR

