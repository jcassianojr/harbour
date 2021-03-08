*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => DBULIB.PRG
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "BOX.CH"
#include "ads.ch"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MD()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function MD             //TELA PARA AS MENSAGENS
@ maxrow(), 00
retuRN ( .T. )


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MDT()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function MDT     
para MS
MDS( padc( MS, 80 ) )
inkey( 1 )
MD()
retuRN ( .t. )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function XEXT()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function  XEXT
local cEXT := ".CDX"
do case
case TIPODBF = 1 
   cEXT := ".NTX"
case TIPODBF = 2 .OR.TIPODBF = 5
   cEXT := ".CDX"
case TIPODBF = 3 
   cEXT := ".NDX"
case TIPODBF = 4 
   cEXT := ".MDX"
endcase
retuRN cEXT

FUNCtion tipodbfesc
TELA01 := savescreen( 06, 22, 15, 59 )
HB_dispbox( 6, 22, 15, 55, B_DOUBLE+" ")
OPCAO(  8, 24, "&NTX-DBFNTX Clipper ", 78 )
OPCAO(  9, 24, "&CDX-DBFCDX FoxPro", 67 )
OPCAO( 10, 24, "N&DX-DBFNDX FoxBase", 68 )
OPCAO( 11, 24, "&MDX-DBFMDX DBaseIV", 77 )
OPCAO( 12, 24, "&ADSCDX- DBFADCDX", 65 )
KEY := menu( 2, 0 )
if KEY > 0
   TIPODBF := KEY
else
   TIPODBF := 1
endif
USOVIA:=RDDNOME(TIPODBF)
restscreen( 06, 22, 15, 59, TELA01 )
return TIPODBF

FUNCTION RDDNOME(nTIPO)
LOCAL USOVIA
do case
case TIPODBF = 1
   USOVIA := "DBFNTX"
case TIPODBF = 2
   USOVIA := "DBFCDX"
   rddsetdefault( "DBFCDX" )
case TIPODBF = 3
   USOVIA := "DBFNDX"
case TIPODBF = 4
   USOVIA := "DBFMDX"
case TIPODBF = 5
   USOVIA := "ADSCDX"
   rddSetDefault( "ADSCDX" )
   AdsSetServerType(ADS_LOCAL_SERVER)
   AdsSetFileType(ADS_CDX)
//case TIPODBF = 6
//   USOVIA := "ADSNTX"   
otherwise
   USOVIA := "DBFCDX"
   rddsetdefault( "DBFCDX" )
endcase
RETURN USOVIA
      

FUNCTION formatacpf(xCPF)
XCPF:=AllTrim(TIRAOUT(xCPF))
IF VAL(xCPF)=0 .OR. LEN(xCPF)<>11
   return xCPF
ENDIf
xCPF:=StrZero(Val(XCPF),11)
RETUrn Transform(xCPF,"@R 999.999.999-99")  
      
*+ EOF: DBULIB.PRG
