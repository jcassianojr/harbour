*+Ý*******************************************************************
*+
*+    Source Module => DBULIB.PRG
*+
*+********************************************************************

#INCLUDE "BOX.CH"
#include "ads.ch"
#include "dbinfo.ch"
#include "TRY.ch"


*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function LAYOUT() Informacoes do Driver em uso
*+
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function LAYOUT()
LOCAL n
clear
for n := 2 to len( func_title )
   @  0, ( 9 * n ) - 18 say padc( "F"+STR(N,1) , 8 )
   @  1, ( 9 * n ) - 18 say padc( func_title[ n ], 9 )
next
@  2,  0 say replicate( "-", 80 )
@ MAXROW()-3,  0 say "RDD("+zUSOVIA+") Extensao("+hb_rddInfo( RDDI_TABLEEXT)+") Memo("+hb_rddInfo( RDDI_MEMOEXT)+") Index("+hb_rddInfo( RDDI_ORDBAGEXT)+")"
@ MAXROW()-2,  0 say  "Exportar Para("+ZEXPOREXT+") Delimitador("+ZDELIMITE+")" 
@ MAXROW()-1,  0 say "Sepador Decimal("+ZDECSIM+") Oem Ansi("+ZCNVCHAR+") Separador Registro("+Zregsep+")"+" Ano("+ZANOFOR+ZANOSEP+ZANOTAM +") Logico("+zSEPLOGIC+")"

return .T.

*+********************************************************************
*+
*+    Function MD() limpa a linha de mensagens
*+
*+********************************************************************
*+
function MD             
@ maxrow(), 00
retuRN  .T. 


*+********************************************************************
*+
*+    Function MDT() exibe uma mensagem por um temp
*+
*+********************************************************************
*+
function MDT(cMSG)  
hb_Alert(cMSG, , , 2 ) 
retuRN .t. 

*+********************************************************************
*+
*+    Function XEXT() retorna a extensao do aquivo indice
*+
*+********************************************************************
*+
function  XEXT
return hb_rddInfo( RDDI_ORDBAGEXT)


*+********************************************************************
*+
*+    Function tipodbfesc escolhe o tipo de dbf indice e memo
*+
*+********************************************************************
*+
FUNCtion tipodbfesc
//TipoDBF,USOVIA e varivel public
local aAMBIENTE
LOCAL KEY

//KEY= TIPODBF //posiciona pela escolha anterior 
aAMBIENTE:=SALVAA()
HB_dispbox( 03, 10, 22, 60, B_DOUBLE+" ")
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
OPCAO( 19, 24, "B&MDBFCDX     CXD FPT     ", 77 ) //M 16 BMDBFCDX DBFCDX 
OPCAO( 20, 24, "BMDBFNSX      NSX FPT     ", 49 ) //1 17 BMDBFNSX DBFNSX
OPCAO( 21, 24, "BMDBFNTX      NTX FPT     ", 50 ) //2 18 BMDBFNTX DBFNTX


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

*+********************************************************************
*+
*+    Function RDDNOME(nTIPO) configura o tipo de dbf indice e memo
*+
*+********************************************************************
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
   	case nTIPODBF = 16
	  USOVIA := "BMDBFCDX"  
	  rddSetDefault( "BMDBFCDX" )  
    case nTIPODBF = 17
	  USOVIA := "BMDBFNSX"  
	  rddSetDefault( "BMDBFNSX" )  
    case nTIPODBF = 18
	  USOVIA := "BMDBFNTX"  
	  rddSetDefault( "BMDBFNTX" )    
	otherwise
	   USOVIA := "DBFCDX"
	   rddsetdefault( "DBFCDX" )
endcase
zusovia:=USOVIA
layout()
RETURN USOVIA


*+********************************************************************
*+
*+    Function pegTIPDOC escolher tipo para exportacao de dados
*+
*+********************************************************************
*+
Function pegtipodoc(lincdbf)
LOCAL tDOC
LOCAL aAMBIENTE
if valtype(lincdbf)<>"L"
   lincdbf:=.F.
ENDIF

tDOC:=0
aAMBIENTE:=SALVAA()

  HB_dispbox( 03, 10, 22, 60, B_DOUBLE+" ")
  OPCAO(  8, 14, "XML&A                               ", 65 ) //A 1
  OPCAO(  9, 14, "&TAM  STRU+TAM                      ", 74 ) //T 3
  OPCAO( 10, 14, "TE&C  STRU                          ", 67 ) //C 2
  OPCAO( 11, 14, "&DBE  STRU DDL                      ", 68 ) //D 4
  OPCAO( 12, 14, "DL&M  DELIM                         ", 77 ) //M 5
  OPCAO( 13, 14, "&SDF                                ", 83 ) //S 6
  OPCAO( 14, 14, "&XML                                ", 88 ) //X 7
  OPCAO( 15, 14, "&JSON                               ", 74 ) //J 8
  OPCAO( 16, 14, "SSV Semi Colon (;) &Ponto e Virgula ", 80 ) //P  9
  OPCAO( 17, 14, "CS&V Colon      (,) Virgula         ", 86 ) //V1 0
  OPCAO( 18, 14, "&UNL PSV        (|) Pipe            ", 85 ) //U 11
  OPCAO( 19, 14, "TSV            TA&B                 ", 66 ) //B 12
  OPCAO( 20, 14, "S&QL   insert into                  ", 81 ) //Q 13
  IF lincdbf
      OPCAO( 21, 14, "DB&F                                ", 70 ) //F 14 70
  ENDIF
  tdoc := menu( 2, 0 )
  RESTAA(aAMBIENTE)
  DO CASE
     CASE tDOC=1
          zEXPOREXT="XML"
     CASE tDOC=2
          zEXPOREXT="TAM"
     CASE tDOC=3
          zEXPOREXT="TEC"
     CASE tDOC=4
          zEXPOREXT="DBE"
     CASE tDOC=5
          zEXPOREXT="DLM"
     CASE tDOC=6
          zEXPOREXT="SDF"
     CASE tDOC=7
          zEXPOREXT="XML"
     CASE tDOC=8
          zEXPOREXT="JSON"
     CASE tDOC=9
          zEXPOREXT="SSV"
     CASE tDOC=10
          zEXPOREXT="CSV"
     CASE tDOC=11
          zEXPOREXT="UNL"
     CASE tDOC=12
          zEXPOREXT="TSV"
     CASE tDOC=13
          zEXPOREXT="SQL"
     CASE tDOC=14
          zEXPOREXT="DBF"          
  ENDCASE
  IF tDOC>=9 .AND. tDOC<=13
     checkextEXP() //pega o delimitador zDELIMITE:
     tDOC =5       //retorna para o tipo 5 DML a geracao SSV CSV UNL PSV TSV SQL usam as funcoes da DML
  ENDIF
  
return tDOC

*+********************************************************************
*+
*+    Function pegparexp parametross para exportacao de dados
*+
*+********************************************************************
*+
function pegparexp
local aAMBIENTE
aAMBIENTE:=SALVAA()
zEXPOREXT:=PADR(zEXPOREXT,4)

HB_dispbox( 03, 10, 22, 60, B_DOUBLE+" ")
  @ 03,12 say "TXT SDF DML    fornecer delimitador"
  @ 04,12 SAY "SSV Semi Colon (;) Ponto e Virgula "
  @ 05,12 say "CSV Colon      (,) Virgula         "
  @ 06,12 say "UNL PSV        (|) Pipe            "
  @ 07,12 say "TSV            TAB                 "
  @ 08,12 say "XLS XML SQL JSON                   "

@ 09,12 say "Formato"
@ 10,12 say "Delimitador ,;|#~ 9=(TAB)"
@ 11,12 say "Sep Reg "+chr(34)+chr(39)+"( ) "
@ 12,12 say "Separador Decimal ,. "

@ 13,12 say "(D)ia(M)es(A)no DMA AMD MDA SQL MYS DHZ"
@ 14,12 say "ASPAS ACESSS CRYSTAL DATE(, DATESERIAL"
@ 15,12 say "MYSQL/ MYSQL- ORACLE TO_DATE MSSQL SQLITE"

@ 16,12 say "Digitos Ano 2/4"
@ 17,12 say "Separador Data /-( )"

@ 18,12 say "Logico= TRUE .T. ON YES SIM 1 T Y S"
@ 19,12 say "Converter (N)ao oemto(A)nsi ansito(O)em"  

@ 09,53 get zEXPOREXT PICT "!!!!"         VALID checkextEXP()
@ 10,53 get zDELIMITE PICT "!"            VALID zDELIMITE $ " ,;|#~9"
@ 11,53 get zregSEP                       VALID zregsEP $ chr(34)+chr(39)+" "
@ 12,53 get zDECSIM                       VALID zDECSIM $ ",."       

@ 13,53 get zANOFOR   PICT "!!!!!!!!!!"   VALID checkanofor() 
@ 16,53 get zANOTAM   PICT "9"            VALID zANOTAM $ "24"
@ 17,53 get zANOSEP                       VALID zANOSEP $ "/- "

@ 18,53 get zSEPLOGIC                     valid zSEPLOGIC="TRUE" .OR. zSEPLOGIC=".T. " .OR. zSEPLOGIC="YES " .OR. zSEPLOGIC="ON  " .OR. zSEPLOGIC="SIM " .OR. zSEPLOGIC="1   " .OR. zSEPLOGIC="T   " .OR. zSEPLOGIC="Y   " .OR. zSEPLOGIC="S   "
@ 19,53 get zCNVCHAR  PICT "!"            VALID zCNVCHAR $ "NAO"  
readcur() 

zEXPOREXT=ALLTRIM(ZEXPOREXT)
IF zEXPOREXT="XLS" .AND. zDELIMITE<>"9"
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
RESTAA(aAMBIENTE)
layout()
return nil


*+********************************************************************
*+
*+    Function checkanofor 
*+
*+********************************************************************
*+
function checkanofor()  
LOCAL lRETU
LOCAL cANOFOR
lRETU := .F.
cANOFOR=ALLTRIM(zANOFOR)
IF cANOFOR="DMA" .OR. cANOFOR="AMD" .OR. cANOFOR="MDA" .OR. cANOFOR="SQL" .OR. cANOFOR="MYS" .OR. cANOFOR="DHZ" ;
                 .OR. cANOFOR="ASPAS" .OR. cANOFOR="ACESSS" .OR. cANOFOR="CRYSTAL" .OR. cANOFOR="DATE(," .OR. cANOFOR="DATESERIAL" ;
                 .OR. cANOFOR="MYSQL/" .OR. cANOFOR="MYSQL-" .OR. cANOFOR="ORACLE" .OR. cANOFOR="TO_DATE" .OR. cANOFOR="MSSQL" .OR. cANOFOR="SQLITE"
   lRETU = .T.
ENDIF
DO CASE
   CASE cANOFOR="SQLITE"
        zSEPLOGIC="1   "
        zANOTAM:="4"
        zANOSEP:="-"
ENDCASE
RETURN lRETU


*+********************************************************************
*+
*+    Function checkexp configura o delimitador conforme o tipo de exportacao
*+
*+********************************************************************
*+
function checkextEXP()  //",;|#~9" zEXPOREXT="DLM" .OR. zEXPOREXT="CVS" .OR. zEXPOREXT="UNL" .OR. zEXPOREXT="XLS" .OR. zEXPOREXT="XML" .OR. zEXPOREXT="SQL" .OR. zEXPOREXT="JSON"
LOCAL lRETU
zDELIMITE:=" "
zregSEP  :=" "
lRETU := .T.
DO CASE
   CASE zEXPOREXT="TXT" 
   CASE zEXPOREXT="TEC"
   CASE zEXPOREXT="DBE"
   CASE zEXPOREXT="TAM"
   CASE zEXPOREXT="DBF" 
   CASE zEXPOREXT="SDF" 
   CASE zEXPOREXT="DLM"
   CASE zEXPOREXT="SSV"
        zDELIMITE:=";" 
   CASE zEXPOREXT="CSV"
        zDELIMITE:=","
   CASE zEXPOREXT="UNL" .OR. zEXPOREXT="PSV"
        zDELIMITE:="|"
   CASE zEXPOREXT="TSV" .OR. zEXPOREXT="XLS"
        zDELIMITE:="9"
   CASE zEXPOREXT="XML"
   CASE zEXPOREXT="SQL"
        zDELIMITE:=","
   CASE zEXPOREXT="JSON"
   OTHERWISE
       lRETU := .F.
ENDCASE
RETURN lRETU


*************************
function copiardbfpara()
LOCAL aAMBIENTE
LOCAL nOLDTIPO
LOCAL nORITIPO
LOCAL cORIDRIVER
LOCAL cARQORI
LOCAL nTIPDOC

aAMBIENTE:=SALVAA()
nOLDTIPO=TIPODBF

alertX("escolha origem")
tipodbfesc()
nORITIPO:=TIPODBF
cORIDRIVER:=RDDNOME(TIPODBF)
cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )

LCOPIANAT:=MDG("Copia Nativa(SIM) Interna(NAO)")

//nao mostrar tipo 14 dbf na escolha nao spbrepor na copia passando falso aqui
tDOC:=   pegtipodoc(.F.)
pegparexp()


//
// formatos nao disponiveis no copy to (nativa)
//
IF tDOC=1 //XML 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=2 //TAM 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=3 //TEC 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=4 //DBE 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=7 //XML
   lCOPIANAT:=.F.
ENDIF
IF tDOC=8 //JSON 
   lCOPIANAT:=.F.
ENDIF
IF tDOC=13 //SQL
   lCOPIANAT:=.F.
ENDIF

IF .NOT.  lCOPIANAT
   PegcsUB(tDOC)  //pegar o subtipo conforme tipo
ENDIF

IF LCOPIANAT
   cDESTINO:=TROCAEXT(cARQORI,zEXPOREXT)
   MDT("abrindo arquivo de origem: "+cARQORI)
   USE (cARQORI) ALIAS ORIGEM EXCLUSIVE NEW VIA  (cORIDRIVER) 
   COPYTO(cDESTINO)
   dbcloseall()
ELSE
   multidocs(nTIPDOC,cARQORI)
ENDIF   

RESTAA(aAMBIENTE)
TIPODBF:=nOLDTIPO
RDDNOME(nOLDTIPO) //retorna tipo anterio

*+********************************************************************
*+
*+    Function copy to conforme o zEXPORTEXT e ZDELIMITE
*+
*+********************************************************************
*+
FUNCTION COPYTO(cDESTINO)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
DO CASE
   //
   // DML CSV UNL PSV TSV
   //
   CASE zREGSEP=chr(34) .OR. zREGSEP=chr(39) //delimitador + aspas duplas aspas (") (')
        COPY to &cDESTINO.  while zei_fort(nLASTREC,,,1) DELIMITED  WITH ( { zDELIMITE, zREGSE } )  
  
   //
   //tDOC=14
   //
  CASE zEXPOREXT="DBF" 
        COPY to &cDESTINO. while zei_fort(nLASTREC,,,1) 

   //
   //tDOC=6
   //
   CASE zEXPOREXT="SDF"                                                                            
        COPY to &cDESTINO. while zei_fort(nLASTREC,,,1)  SDF

   //
   //tDOC=10
   //
   CASE zEXPOREXT="DLM" .OR. zEXPOREXT="CSV"
        COPY to &cDESTINO. whILE zei_fort(nLASTREC,,,1)  DELIMITED
  
   //
   //tDOC=11
   //
   CASE zEXPOREXT="UNL" .OR. zEXPOREXT="PSV"
        COPY to &cDESTINO. whILE zei_fort(nLASTREC,,,1)  DELIMITED   WITH PIPE
   
   //
   // tDOC=12
   //
   CASE zEXPOREXT="TSV" 
        COPY to &cDESTINO. whILE zei_fort(nLASTREC,,,1)  DELIMITED   WITH TAB
    
   //
   // SSV  zdelimite= ; e outro delimitador tDOC=9
   //
   OTHERWISE 
       COPY to &cDESTINO.  while zei_fort(nLASTREC,,,1)  DELIMITED   WITH WITH &zDELIMITE
ENDCASE   
RETURN NIL

*+********************************************************************
*+
*+    Function append from conforme o zEXPORTEXT e ZDELIMITE
*+
*+********************************************************************
*+
FUNCTION APPENDFROM(cDESTINO)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
DO CASE
   CASE zREGSEP=chr(34) .OR. zREGSEP=chr(39) //delimitador + aspas duplas aspas (") (')
        APPEND FROM &cDESTINO.  while zei_fort(nLASTREC,,,1) DELIMITED  WITH ( { zDELIMITE, zREGSE } )  
  CASE zEXPOREXT="DBF" 
        APPEND FROM &cDESTINO. while zei_fort(nLASTREC,,,1)              
   CASE zEXPOREXT="SDF" 
        APPEND FROM  &cDESTINO. while zei_fort(nLASTREC,,,1)  SDF
   CASE zEXPOREXT="DLM" .OR. zEXPOREXT="CSV"
        APPEND FROM  &cDESTINO. whILE zei_fort(nLASTREC,,,1)  DELIMITED
   CASE zEXPOREXT="UNL" .OR. zEXPOREXT="PSV"
        APPEND FROM  &cDESTINO. whILE zei_fort(nLASTREC,,,1)  DELIMITED   WITH PIPE
   CASE zEXPOREXT="TSV" 
        APPEND FROM  &cDESTINO. whILE zei_fort(nLASTREC,,,1)  DELIMITED   WITH TAB
   OTHERWISE //SSV  zdelimite= ; e outro delimitador
       APPEND FROM  &cDESTINO.  while zei_fort(nLASTREC,,,1)  DELIMITED   WITH WITH &zDELIMITE
ENDCASE   
RETURN NIL

*+********************************************************************
*+
*+    Function formatacpf(xCPF)
*+    esta aqui pois as vezes e usada em replaces
*+
*+********************************************************************
*+
FUNCTION formatacpf(xCPF)
XCPF:=AllTrim(TIRAOUT(xCPF))
IF VAL(xCPF)=0 .OR. LEN(xCPF)<>11
   return xCPF
ENDIf
xCPF:=StrZero(Val(XCPF),11)
RETUrn Transform(xCPF,"@R 999.999.999-99")  
      
*+ EOF: DBULIB.PRG
