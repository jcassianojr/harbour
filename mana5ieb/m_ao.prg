*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\ITAESBRA\M_AO.PRG
*+
*+    Functions: Function fMAO()
*+               Function tMAO()
*+               Function gMAO()
*+               Function MAO1K01()
*+
*+    Reformatted by Click! 2.03 on May-23-2000 at  2:19 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

function m_ao
para nTIPO

lPACKMAO:=.F.
wMAO:=0
wpMAO:=1
wcMAO := 0

cAMO1:="MO01"
cAMO2:="MO02"

IF nTIPO=2
   cAMO1:="MO01BX"
   cAMO2:="MO02BX"
ENDIF
IF nTIPO=3
   cVAR  := MESANO()
   cAMO1 := "O1" + cVAR
   cAMO2 := "O2" + cVAR
ENDIF

mESTADO := "SP"
yCFONEW=""
yCFONEWB=""
mTIPOENT:=""
sMAO201 := SENHAX( "MAO201" )

//Tela Devolucao
aMDETEL:=TELAPEG("MMDE01")
aMDEGET:=EDITPEG("MMDE01")

//Itens Pedidos
aMO2TEL:=TELAPEG("ITMO21")
aMO2GET:=EDITPEG("ITMO21")


CRIARVARS( "OF01" )
CRIARVARS( "OF02" )
CRIARVARS( "OR01" )
CRIARVARS( "MO02" )


PADRAX(0,,0,{cAMO1,cAMO2},"Pedido   Data     NЃmeroOS Cliente           Data Base Entrega",;
     "' '+str(mPEDIDO,8,2)+' '+dtoc(mDATA)+' '+str(mOS,8,2)+' '+str(mFORNECEDO,5)+' '+mCOGNOME+' '+dtoc(mDATABASE)+' '+dtoc(mENTREGA)+' '+mPEDIDOCLI+' '+STR(mPEDCLIITE,3)",;
     "ITMO01","ITMO01",,{|| MAODEL()},;
     {|| MAOPOSREP()},{|| MAOPREINS()},"MAO",,,,{|| MAOPOSINS()},,)

//Ajuste
IF lPACKMAO
   MAOFIXAR()
ENDIF

FUNC MAODEL()
lPACKMAO:=.T.
lAPAGAITE:=.T.
IF cVIDE="T"
   //Tbrowse ja fez o equvars()
//   mPEDIDO :=PEDIDO
ELSE
   mPEDIDO := mCHAVE
ENDIF
while !USEREDE( "MO02", 1, 99 )
enddo
dbseek( str( mPEDIDO, 8, 2 ) + " 1" )
while PEDIDO = mPEDIDO .and. !eof()
   mOF    := mOS
   gCHAVE := str( mOS, 8, 2 ) + str( mITEM, 3 )
   //IF QTDEENT>0 
   //   lAPAGAITE:=MDG("OS ja com entregas Apagar Mesmo Assim")
   //ENDIF  
   if lAPAGAITE
      DELEREG(,,,.F.)
      IF GERAOF="S"
         APAGAREG( "OF01", gCHAVE, .F., .F.,,.F.)
         MAOFDEL()
      ENDIF
   ENDIF   
   dbselectar( "MO02" )
   dbskip()
enddo
dbclosearea()
RETU lAPAGAITE

FUNC MAOPREINS()
  CRIARVARS("MO02")
  @ 24,00 
  @ 24,00 SAY "OS Entrega Hora"  
  @ 24,20 GET mPEDIDO
  @ 24,30 GET mENTREGA
  @ 24,40 GET mHORAPRG
  READCUR()
  mOS   := mPEDIDO
  PEGACAMPO("OSCRT","INT(mOS)",{"CLIENTE","DATA","PEDIDOCLI","PEDCLIITE","CODIGO"},;
                             {"mFORNECEDO","mDATABASE","mPEDIDOCLI","mPEDCLIITE","mCODIGO"})
  mBUSTMP:=str(Mfornecedo,5)+padr( mCODIGO, 24 ) + dtos( mENTREGA ) +str(mHORAPRG,5,2) 
  //ALERTX(Mbustmp)
  IF VERSEHA( "MO02", mBUSTMP,,, .F., 5)
      RETU MDG("Ja existe outra OS para "+dtoc(mENTREGA)+" Gravar Nova")
  ENDIF   
  MAO1K01()      
RETU .T.

FUNC MAOPOSINS()
//mOS   := mPEDIDO
mDATA := ZDATA
mGERAOF:="N"
// movido preins
//PEGACAMPO("OSCRT","INT(mOS)",{"CLIENTE","DATA","PEDIDOCLI","PEDCLIITE","DATAENT"},;
//                             {"mFORNECEDO","mDATABASE","mPEDIDOCLI","mPEDCLIITE","mENTREGA"})
RETU .T.


FUNC MAOPOSREP()
xFORNECEDO := mFORNECEDO
xCOGNOME   := mCOGNOME
xPEDIDO    := mPEDIDO
mOS        := mPEDIDO
xOS        := mOS
xVENDEDOR  := mVENDEDOR
xCOMISSAO  := mCOMISSAO
xZONA      := mZONA
xDATA      := mDATA
xICM       := mICM
xBASE      := mDATABASE
M_AO2( 1 )
IF cVIDE#"T"
   GRAVAMVAR("MO01",mPEDIDO,"ENTREGA","mENTREGA")
ELSE
   DBSELECTAR(cAMO1)
   GRAVACAMPO({"ENTREGA"},{"mENTREGA"})
ENDIF
RETU .T.




*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAO1K01()
*+
*+    Called from ( m_ao.prg     )   1 - function gmao()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MAO1K01()
// PARA O CALCULO DO ICM
if INCLUI
   PEGACAMPO( "MA01", "mFORNECEDO", { "COGNOME", "ESTADO", "CONDPAG", "VENDEDOR", "ZONA" }, { "mCOGNOME", "mESTADO", "mCONDPAG", "mVENDEDOR", "mZONA" } )
else
   PEGACAMPO( "MA01", "mFORNECEDO", { "COGNOME", "ESTADO" }, { "mCOGNOME", "mESTADO" } )
endif
mICM := OBTER( "MD05", mESTADO, "ALIQUOTA" )
if !INCLUI
   if empty( mCONDPAG )
      mCONDPAG := OBTER( "MA01", mFORNECEDO, "CONDPAG" )
   endif
   if empty( mVENDEDOR )
      mVENDEDOR := OBTER( "MA01", mFORNECEDO, "VENDEDOR" )
   endif
   if empty( mZONA )
      mZONA := OBTER( "MA01", mFORNECEDO, "ZONA" )
   endif
endif
retu .T.

*+ EOF: M_AO.PRG
