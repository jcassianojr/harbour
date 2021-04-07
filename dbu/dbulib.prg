*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => DBULIB.PRG
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "BOX.CH"
#include "ads.ch"
#include "dbinfo.ch"
#include "TRY.ch"


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
function MDT(cMSG)   
stat_msg(cMSG ) 
inkey( 1 )
stat_msg(space(80)) 
retuRN .t. 

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function XEXT()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function  XEXT
//local cEXT := ".CDX"
//do case
//case TIPODBF = 1 
//   cEXT := ".NTX"
//case TIPODBF = 2 .OR.TIPODBF = 5
//   cEXT := ".CDX"
//case TIPODBF = 3 
//   cEXT := ".NDX"
//case TIPODBF = 4 
//   cEXT := ".MDX"
//endcase
return hb_rddInfo( RDDI_ORDBAGEXT)



FUNCtion tipodbfesc
aAMBIENTE:=SALVAA()
HB_dispbox( 6, 22, 21, 55, B_DOUBLE+" ")
OPCAO(  8, 24, "DBF&NTX DBF INDEX=NTX   ", 78 ) //N 1
OPCAO(  9, 24, "DBF&CDX DBF INDEX=CDX   ", 67 ) //C 2
OPCAO( 10, 24, "&ADSCDX DBF INDEX=CDX   ", 65 ) //A 3
OPCAO( 11, 24, "ADSNT&X DBF INDEX=NTX   ", 88 ) //X 4
OPCAO( 12, 24, "ADSVF&P TABLE=VFP       ", 80 ) //P 5
OPCAO( 13, 24, "ADSAD&T TABLE=ADS       ", 84 ) //T 6
OPCAO( 14, 24, "D&BTCDX DBF CDX MEMO=DBT", 66 ) //B 7
OPCAO( 15, 24, "&SMTCDX DBF CDX MEMO=SMT", 83 ) //S 8
OPCAO( 16, 24, "&FPTCDX DBF CDX MEMO=FPT", 70 ) //F 9
OPCAO( 17, 24, "S&IXCDX DBF CDX         ", 73 ) //I 10
OPCAO( 18, 24, "&DBFNSX DBF NSX         ", 68 ) //D 11
OPCAO( 19, 24, "DBFBLOB MEMO=DB&V       ", 86 ) //V 12
KEY := menu( 2, 0 )
if KEY > 0
   TIPODBF := KEY
else
   TIPODBF := 1
endif
USOVIA:=RDDNOME(TIPODBF)
RESTAA(aAMBIENTE)
layout()
return TIPODBF

FUNCTION RDDNOME(nTIPO)
LOCAL USOVIA
do case
	case TIPODBF = 1
	   USOVIA := "DBFNTX"
	   rddSetDefault( "DBFNTX" )
	case TIPODBF = 2
	   USOVIA := "DBFCDX"
	   rddsetdefault( "DBFCDX" )
	case TIPODBF = 3
	   USOVIA := "ADSCDX"
	   rddSetDefault( "ADSCDX" )
	   AdsSetServerType(ADS_LOCAL_SERVER)
	   AdsSetFileType(ADS_CDX)
	case TIPODBF = 4
	   USOVIA := "ADSNTX"
	   rddSetDefault( "ADSNTX" )
	   AdsSetServerType(ADS_LOCAL_SERVER)
	   AdsSetFileType(ADS_NTX)
	case TIPODBF = 5
	   USOVIA := "ADSVFP"
	   rddSetDefault( "ADSVFP" )
	   AdsSetServerType(ADS_LOCAL_SERVER)
	   AdsSetFileType(ADS_VFP)
	case TIPODBF = 6
	   USOVIA := "ADSADT"
	   rddSetDefault( "ADSADT" )
	   AdsSetServerType(ADS_LOCAL_SERVER)
	   AdsSetFileType(ADS_ADT)
	case TIPODBF = 7
	  USOVIA := "DBTCDX"  
	  rddSetDefault( "DBTCDX" )
	case TIPODBF = 8
	  USOVIA := "SMTCDX" 
	  rddSetDefault( "SMTCDX" )
	case TIPODBF = 9 
	  USOVIA := "FPTCDX"  
	  rddSetDefault( "FPTCDX" )
	case TIPODBF = 10
	  USOVIA := "SIXCDX"  
	  rddSetDefault( "SIXCDX" )
	case TIPODBF = 11
	  USOVIA := "DBFNSX"  
	  rddSetDefault( "DBFNSX" )	  
	case TIPODBF = 12
	  USOVIA := "DBFBLOB"  
	  rddSetDefault( "DBFBLOB" )	  
	otherwise
	   USOVIA := "DBFCDX"
	   rddsetdefault( "DBFCDX" )
endcase
/*
TRY
	ALERT("MEMO: "+hb_rddInfo( RDDI_MEMOEXT))
END
TRY
	ALERT("INDEX BAG: "+hb_rddInfo( RDDI_ORDBAGEXT))
END	
TRY
  ALERT("INDEX SINGLE: "+hb_rddInfo( RDDI_ORDEREXT))
END  
*/
zusovia:=USOVIA
layout()
RETURN USOVIA
      
//esta aqui pois as vezes e usada em replaces
FUNCTION formatacpf(xCPF)
XCPF:=AllTrim(TIRAOUT(xCPF))
IF VAL(xCPF)=0 .OR. LEN(xCPF)<>11
   return xCPF
ENDIf
xCPF:=StrZero(Val(XCPF),11)
RETUrn Transform(xCPF,"@R 999.999.999-99")  
      
*+ EOF: DBULIB.PRG
