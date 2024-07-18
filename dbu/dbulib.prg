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
*+    Function MD() limpa a linha de mensagens
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function MD             
@ maxrow(), 00
retuRN ( .T. )


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MDT() exibe uma mensagem por um temp
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function MDT(cMSG)  
hb_Alert(cMSG, , , 2 ) 
retuRN .t. 

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function XEXT() retorna a extensao do aquivo indice
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function  XEXT
return hb_rddInfo( RDDI_ORDBAGEXT)


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function tipodbfesc escolhe o tipo de dbf indice e memo
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCtion tipodbfesc
//TipoDBF,USOVIA e varivel public
local aAMBIENTE
LOCAL KEY

//KEY= TIPODBF //posiciona pela escolha anterior 
aAMBIENTE:=SALVAA()
HB_dispbox( 3, 22, 22, 55, B_DOUBLE+" ")
@ 03,24 SAY     "DRIVER   ARQ IND MEMO"
OPCAO(  4, 24, "DBF&NTX   DBF NTX DBT     ", 78 ) //N 1 DBFNTX DBF/DBFFPT/DBFNTX
OPCAO(  5, 24, "DBF&CDX   DBF CDX FPT     ", 67 ) //C 2 DBFCDX DBF/DBFFPT/HB_CDXRDD 
OPCAO(  6, 24, "&ADSCDX   DBF CDX FPT     ", 65 ) //A 3 ADSCDX
OPCAO(  7, 24, "ADSNT&X   DBF NTX DBT     ", 88 ) //X 4 ADSNTX
OPCAO(  8, 24, "ADSVF&P   VFP CDX FPT     ", 80 ) //P 5 ADSVFP
OPCAO(  9, 24, "ADSAD&T   ADS ADI AD      ", 84 ) //T 6 ADSADT
OPCAO( 10, 24, "D&BTCDX   DBF CDX DBT     ", 66 ) //B 7 DBTCDX DBFCDX/DBFFPT/DBTCDX 
OPCAO( 11, 24, "&SMTCDX   DBF CDX SMT     ", 83 ) //S 8 DBFCDX/DBFFPT/SMTCDX
OPCAO( 12, 24, "&FPTCDX   DBF CDX FPT     ", 70 ) //F 9 FPTCDX DBFCDX/DBFFPT/FPTCDX 
OPCAO( 13, 24, "S&IXCDX   DBF CDX FPT     ", 73 ) //I 10 SIXCDX
OPCAO( 14, 24, "&DBFNSX   DBF NSX MST     ", 68 ) //D 11 DBFNSX DBF/DBFFPT/DBFNSX
OPCAO( 15, 24, "DBFB&LOB          DBV     ", 76 ) //L 12 DBFBLOB DBF/DBFFPT/DBFBLOB
OPCAO( 16, 24, "&HSCDX    HS  CDX FPT     ", 72 ) //H 13 HSCDX  DBFCDX/HSCDX
OPCAO( 17, 24, "&RLCDX    RL  CDX FPT     ", 82 ) //R 14 RLCDX  DBFCDX/RLCDX
OPCAO( 18, 24, "&VFPCDX   VFP CDX FPT     ", 86 ) //V 15 VFPCDX DBFCDX/DBFFPT/VFPCDX 

/* erro falta funcao implementacao futura
OPCAO( 19, 24, "B&MDBFCDX VFP CXD FPT     ", 48 ) //M 16 BMDBFCDX DBFCDX 
OPCAO( 20, 24, "BMDBFNTX  VFP NTX FPT     ", 49 ) //1 17 BMDBFNTX DBFNTX
OPCAO( 21, 24, "BMDBFCDX  VFP NSX FPT     ", 50 ) //2 18 BMDBFNSX DBFNSX
*/

KEY := menu( 2, 0 )
if KEY > 0
   TIPODBF := KEY
else
   TIPODBF := 2 //padrao dbfcdx
endif
USOVIA:=RDDNOME(TIPODBF)
RESTAA(aAMBIENTE)
layout()
return TIPODBF



/*
rddregister hb_rddRegister
rdd    super       fonte        memo

-nondbf
FCOMMA             fcomma.prg
ARRAYRDD           arrayrdd.prg
LOGRDD             logrdd.prg
SDF                sdf1.prg
DELIM              delim1.prg

-sql
ADORDD

-ssd


*/

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function RDDNOME(nTIPO) configura o tipo de dbf indice e memo
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION RDDNOME(nTIPODBF)
LOCAL USOVIA
IF VALTYPE(nTIPODBF)<>"N"
   nTIPODBF= TIPODBF      //Atribui a publica se nao for passado
ENDIF
do case
	case nTIPODBF = 1
	   USOVIA := "DBFNTX"
	   rddSetDefault( "DBFNTX" )
	case nTIPODBF = 2
	   USOVIA := "DBFCDX"
	   rddsetdefault( "DBFCDX" )
	case nTIPODBF = 3
	   USOVIA := "ADSCDX"
	   rddSetDefault( "ADSCDX" )
	   AdsSetServerType(ADS_LOCAL_SERVER)
	   AdsSetFileType(ADS_CDX)
	case nTIPODBF = 4
	   USOVIA := "ADSNTX"
	   rddSetDefault( "ADSNTX" )
	   AdsSetServerType(ADS_LOCAL_SERVER)
	   AdsSetFileType(ADS_NTX)
	case nTIPODBF = 5
	   USOVIA := "ADSVFP"
	   rddSetDefault( "ADSVFP" )
	   AdsSetServerType(ADS_LOCAL_SERVER)
	   AdsSetFileType(ADS_VFP)
	case nTIPODBF = 6
	   USOVIA := "ADSADT"
	   rddSetDefault( "ADSADT" )
	   AdsSetServerType(ADS_LOCAL_SERVER)
	   AdsSetFileType(ADS_ADT)
	case nTIPODBF = 7
	  USOVIA := "DBTCDX"  
	  rddSetDefault( "DBTCDX" )
	case nTIPODBF = 8
	  USOVIA := "SMTCDX" 
	  rddSetDefault( "SMTCDX" )
	case nTIPODBF = 9 
	  USOVIA := "FPTCDX"  
	  rddSetDefault( "FPTCDX" )
	case nTIPODBF = 10
	  USOVIA := "SIXCDX"  
	  rddSetDefault( "SIXCDX" )
	case nTIPODBF = 11
	  USOVIA := "DBFNSX"  
	  rddSetDefault( "DBFNSX" )	  
	case nTIPODBF = 12
	  USOVIA := "DBFBLOB"  
	  rddSetDefault( "DBFBLOB" )
  	case nTIPODBF = 13
	  USOVIA := "HSCDX"  
	  rddSetDefault( "HSCDX" )
    case nTIPODBF = 14
	  USOVIA := "RLCDX"  
	  rddSetDefault( "RLCDX" )
	case nTIPODBF = 15
	  USOVIA := "VFPCDX"  
	  rddSetDefault( "VFPCDX" )    
      
      /* erro falta funcao implementacao futura
   	case nTIPODBF = 16
	  USOVIA := "BMDBFCDX"  
	  rddSetDefault( "BMDBFCDX" )   
    case nTIPODBF = 17
	  USOVIA := "BMDBFNTX"  
	  rddSetDefault( "BMDBFNTX" )    
    case nTIPODBF = 18
	  USOVIA := "BMDBFNSX"  
	  rddSetDefault( "BMDBFNSX" )  
      */
      
	otherwise
	   USOVIA := "DBFCDX"
	   rddsetdefault( "DBFCDX" )
endcase
zusovia:=USOVIA
layout()
RETURN USOVIA

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function pegparexp parametross para exportacao de dados
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function pegparexp
local aAMBIENTE
aAMBIENTE:=SALVAA()
zEXPOREXT:=PADR(zEXPOREXT,4)

HB_dispbox( 10, 10, 21, 60, B_DOUBLE+" ")
       
@ 11,12  say "Delimitador ,;|#~ 9=(TAB)"
@ 12,12 say "Extensao DLM,CVS,UNL,XLS,XML,SQL,JSON" 
@ 13,12 say "Separador Decimal ,. "
@ 14,12 say "Digitos Ano 2/4"
@ 15,12 say "Separador Data /-( )"
@ 16,12 say "Sep Reg "+chr(34)+chr(39)+"( ) "
@ 17,12 say "(D)ia(M)es(A)no DMA AMD MDA SQL MYS DHZ"
@ 18,12 say "Logico= TRUE .T. ON YES SIM 1 T Y S"
@ 19,12 say "Converter (N)ao oemto(A)nsi ansito(O)em"  

@ 11,53 get zDELIMITE PICT "!"     VALID zDELIMITE $ ",;|#~9"       
@ 12,53 get zEXPOREXT PICT "!!!!"  VALID zEXPOREXT="DLM" .OR. zEXPOREXT="CVS" .OR. zEXPOREXT="UNL" .OR. zEXPOREXT="XLS" .OR. zEXPOREXT="XML" .OR. zEXPOREXT="SQL" .OR. zEXPOREXT="JSON"
@ 13,53 get zDECSIM                VALID zDECSIM $ ",."       
@ 14,53 get zANOTAM   PICT "9"     VALID zANOTAM $ "24"
@ 15,53 get zANOSEP                VALID zANOSEP $ "/- "
@ 16,53 get zregSEP                VALID zregsEP $ chr(34)+chr(39)+" "
@ 17,53 get zANOFOR   PICT "!!!"   VALID zANOFOR="DMA" .OR. zANOFOR="AMD" .OR. zANOFOR="MDA" .OR. zANOFOR="SQL" .OR. zANOFOR="MYS" .OR. zANOFOR="DHZ"
@ 18,53 get zSEPLOGIC              valid zSEPLOGIC="TRUE" .OR. zSEPLOGIC=".T. " .OR. zSEPLOGIC="YES " .OR. zSEPLOGIC="ON  " .OR. zSEPLOGIC="SIM " .OR. zSEPLOGIC="1   " .OR. zSEPLOGIC="T   " .OR. zSEPLOGIC="Y   " .OR. zSEPLOGIC="S   "
@ 19,53 get zCNVCHAR  PICT "!"     VALID zCNVCHAR $ "NAO"  
readcur() 

zEXPOREXT=ALLTRIM(ZEXPOREXT)
IF zEXPOREXT="XLS".AND.zDELIMITE<>"9"
  error_msg( "XLS requer requerer 9=(TAB)" )
  zDELIMITE="9"
ENDIF
IF zDELIMITE="9"
  zDELIMITE=CHR(9)
ENDIF
IF zEXPOREXT="SQL"
  zDELIMITE:=","
ENDIF
IF zEXPOREXT="JSON"
  zDELIMITE:=""
ENDIF


// criar_m[5]:=ZEXPOREXT agora usa geradoc 0 que pergunta o tipo  de exportacao
// util_m[7]:=ZEXPOREXT agora usa multidocs 0 que pegunta o tipo de exportacao
RESTAA(aAMBIENTE)
layout()
return 
      
//esta aqui pois as vezes e usada em replaces
FUNCTION formatacpf(xCPF)
XCPF:=AllTrim(TIRAOUT(xCPF))
IF VAL(xCPF)=0 .OR. LEN(xCPF)<>11
   return xCPF
ENDIf
xCPF:=StrZero(Val(XCPF),11)
RETUrn Transform(xCPF,"@R 999.999.999-99")  
      
*+ EOF: DBULIB.PRG
