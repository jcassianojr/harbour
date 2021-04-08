*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    FLIB08.PRG
*+
*+    Functions: Function CHECKIMP(nTIP,lIMPHP)
*+               Function IMPEND()
*+               Function IMPSTR(cVAR)
*+               Function IMPCHR(cVAR)
*+               Function IMPFOL(cVAR)
*+               Function IMPHP()
*+               Function fazspcchr(cTEXTO)
*+               Function filetohtml(cFILE)
*+               Function filetoRTF(cFILE)
*+               Function filetoTXTWin(cFILE)
*+               Function filezebrapdf(cFILE)
*+               Function fileconvert(cFILE,cTIPO)
*+               Function impext(cARQ)
*+               Function filetoemail(cARQ,cASSUNTO,cCORPOMSG)
*+               Printerror() ctools retorna ultimo codigo Erro Impressora
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+    1 - &Video
*+    2 - LPT&1
*+    3 - LPT&2
*+    4 - LPT&3
*+    5 - Impressora Windows W&INPRN PRINTUSB()
*+    6 - &TXT DOS    (OEM)
*+    7 - TXT WindowS (&ANSI)
*+    8 - &HTML
*+    9 - &RTF
*+   10 - &PDF
*+   11 - Programa E&xterno
*+   12 - Impressora &Windows RAW    PRINTFILERAW()
*+   13 - C&OM1
*+   14 - CO&M2
*+   15 - &EMAIL
*+   16 - Re&direcinal Porta
*+   17 - preview zebra
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°


////#INCLUDE "COMANDO.CH"
#INCLUDE "TRY.CH"
#INCLUDE "BOX.CH"


*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function CHECKIMP()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function CHECKIMP( nTIP, lIMPHP,lZEBRA )

local RETORNO     := .F.
local cTELA
local nPORTA
LOCAL QuePrinter
local nERRO
local cERRO
local cCAMINHO
local aRETU
lIMPEMAIL:=.F.
   


priv aMENUPROMPTS := {}
if valtype( lIMPHP ) # "L"
   lIMPHP := .F.
endif
if valtype( lZEBRA ) # "L"
   lZEBRA := .F.
endif
set print to
if valtype( nTIP ) # "N"
   nTIPSPO := 2     //LPT1
else
   nTIPSPO := nTIP
endif
if nTIPSPO = 0
   cTELA := savescreen( 6, 0, 17, 80 )
   CLSBOX( 6, 0, 17, 80 )
   HB_dispbox( 6, 0, 17, 79, B_DOUBLE+" ")
   while .T.
      oPCAO( 07, 01, " &Video                           ", 86 ) //1 
      oPCAO( 08, 01, " LPT&1 Impressora                 ", 49 ) //2
      oPCAO( 09, 01, " LPT&2 Impressora                 ", 50 ) //3
      oPCAO( 10, 01, " LPT&3 Impressora                 ", 51 ) //4
      oPCAO( 11, 01, " Impressora Windows &WINPRN       ", 84 ) //5
      oPCAO( 12, 01, " &TXT Arquivo Texto Dos(OEM)      ", 84 ) //6
      oPCAO( 13, 01, " TXT Arquivo Texto Windows(&Ansi) ", 65 ) //7
      OPCAO( 14, 01, " &HTML                            ", 72 ) //8
      oPCAO( 07, 41, " &RTF(Rith Text Format)           ", 82 ) //9
      oPCAO( 08, 41, " &PDF(Portable Document Format)   ", 80 ) //10
      oPCAO( 09, 41, "                                  ", 87 ) //11 oPCAO( 09, 41, " Programa E&xterno                ", 87 ) //11
      oPCAO( 10, 41, " Impressora w&Indows RAW          ", 73 ) //12
      oPCAO( 11, 41, " C&OM1                            ", 79 ) //13
      oPCAO( 12, 41, " CO&M2                            ", 77 ) //14
      oPCAO( 13, 41, "                                  ",    )  //15 //oPCAO( 13, 41, " &Email                           ", 69 )  //15   
      oPCAO( 14, 41, " Re&dicionar Portas               ", 68 ) //16
	  IF lZEBRA
		 oPCAO( 15, 41, " Preview &Zebra pdf                ", 90) //17
	 ENDIF
      nTIPSPO := menu(, 0 )
      IF nTIPSPO = 11
         ALERTX("Opcao Desativada")
         loop
      ENDIF
      if nTIPSPO = 15
	     ALERTX("Opcao Desativada")
         loop
	     /* Pergunta no final se quer email
         lIMPEMAIL:=.T.
         nTIPSPO:=6
         CLSBOX( 6, 0, 17, 80 )
         HB_dispbox( 6, 0, 17, 79, B_DOUBLE+" ")
         oPCAO( 09, 01, " &TXT Arquivo Texto Dos(OEM)      ", 84 )
         oPCAO( 10, 01, " TXT Arquivo Texto Windows(&Ansi) ", 65 )
         OPCAO( 11, 01, " &HTML                            ", 72 )
         oPCAO( 12, 01, " &RTF(Rith Text Format)           ", 82 )
         oPCAO( 13, 01, " &PDF(Portable Document Format)   ", 80 )
		 IF lZEBRA
		    oPCAO( 14, 41, " Preview &Zebra pdf                ", 90) 
	     ENDIF
         nTIPEMAIL := menu(, 0 )
         do case
            case nTIPEMAIL=1
                 nTIPSPO:=6
            case nTIPEMAIL=2
                 nTIPSPO:=7
            case nTIPEMAIL=3
                 nTIPSPO:=8
            case nTIPEMAIL=4
                 nTIPSPO:=9
            case nTIPEMAIL=5
                 nTIPSPO:=10
				 
         endcase
		 */
      endif
      if nTIPSPO = 16
         nPORTA   := 1
         cCAMINHO := "\\server\printer" + space( 30 )
         MDS( "Porta LPT(123) Caminho \\server\printer" )
         @ 24, 45 get nPORTA   pict "9"    valid nPORTA > 0 .and. nPORTA < 4
         @ 24, 48 get cCAMINHO pict "@S30"
         if READCUR()
            if NETREDIR( "LPT" + strzero( nPORTA, 1 ) + ":", cCAMINHO )
               ALERTX( "Redericionamento OK" )
            else
               ALERTX( "Erro ao Direcionar" )
            endif
         endif
         MDS( "" )
      else
         exit
      endif
   enddo
   restscreen( 6, 0, 17, 80, cTELA )
endif
if nTIPSPO < 1 .or. nTIPSPO > if(zebra,17,16)
   retu .F.
endif
nPORTA     := 0
QuePrinter := ""
if nTIPSPO = 2
   set print to LPT1
   nPORTA := 1
   QuePrinter := "LPT1:"
endif
if nTIPSPO = 3
   set print to LPT2
   nPORTA := 2
   QuePrinter := "LPT2:"
endif
if nTIPSPO = 4
   set print to LPT3
   QuePrinter := "LPT3:"
   nPORTA := 3
endif
if nTIPSPO = 13
   set print to COM1
   QuePrinter := "COM1:"
endif
if nTIPSPO = 14
   set print to COM2
   QuePrinter := "COM2:"
endif
if nTIPSPO = 2 .or. nTIPSPO = 3 .or. nTIPSPO = 4
   if lIMPHP
      aRETU := IMPHP()
   endif
   while .T.
      if mdg( "Impressora Esta Pronta" )
         //         IF IF(nPORTA=1,ISPRINTER(),PRINTREADY(nPORTA))
         if PRINTREADY( nPORTA )
            RETORNO := .T.
            exit
         else
            cERRO := "Impressora Ligada, Cabo Desconectado, Verifique"
            nERRO := PRINTSTAT( nPORTA )
            do case
               case nERRO = 1
                  cERRO := "Erro Tempo de Coneccao"
               case nERRO = 4
                  cERRO := "Erro de Transmissao"
               case nERRO = 5
                  cERRO := "Nao Esta Online(Em Linha)"
               case nERRO = 6
                  cERRO := "Sem Papel"
               case nERRO = 8
                  cERRO := "Nao Disponivel"
            endcase 
            
            
            //IsImpressora( QuePrinter )
            //prnstatus( QuePrinter)
            ALERTX( cERRO )
            if !MDG( "Continuar Assim Mesmo" )
               loop
            else
               RETORNO := .T.
               exit
            endif
         endif
      else
         set print to
         exit
      endif
   enddo
endif
if (nTIPSPO > 5 .and. nTIPSPO < 11) .OR. nTIPSPO=17  //TXT OEM TXT ANSI HTML RTF PDF ZEBRA_17
   //cARQSPO := "c:\temp\nome000" + space( 20 )
   cARQSPO :=STRTRAN(TMPFILE( "TXT" ),".TXT","")+SPACE(30) //"c:\temp\nome000" + space( 20 )
   MDS( "Digite o Nome do Arquivo " )
   @ 24, 30 get cARQSPO     valid ! empty(cARQSPO)
   RETORNO := READCUR()
   cARQSPO := strtran( cARQSPO, " ", "" )
   if empty( cARQSPO )
      RETORNO := .F.
   else
      if nTIPSPO = 7
         cARQSPO += ".TXW"              //A Funcoes trocam a extencao para txt
         //Evita criar com o mesmo nome
      else
         cARQSPO += ".TXT"              //A Funcoes trocam a extencao para pdf/htm/rtf
      endif
      FERASE(cARQSPO)
      set print to &cARQSPO
   endif
endif
if nTIPSPO = 11
   ALERTX("Opcao Programa Externo Desativada")
   returno = .F.
ENDIF
if nTIPSPO = 1  .or. nTIPSPO = 12 .or. nTIPSPO = 5   //Video //externo  nTIPSPO = 11 (desativado) //winraw //win32prn
   cARQSPO := tmpfile( "TXT" )
   RETORNO := .T.
   FERASE(cARQSPO)
   set print to &cARQSPO
endif
return RETORNO

*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function IMPEND()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function IMPEND(lAPAGA)
LOCAL cTELA
LOCAL nOPCAO
IF VALTYPE(lAPAGA)#"L"
   lAPAGA:=.T.
ENDIF
VIDEO()
set print to
if nTIPSPO = 1      //Video
   VERTXT( cARQSPO )
endif
if nTIPSPO = 6     //txt oem 
   cFILE:= cARQSPO
endif
if nTIPSPO = 7      //txt Win
   cFILE:=FILETOtxtwin( cARQSPO )
endif
if nTIPSPO = 8      //html
   cFILE:=FILETOHTML( cARQSPO )
endif
if nTIPSPO = 9      //rtf
   cFILE:=FILETOrtf( cARQSPO )
endif
if nTIPSPO = 10     //pdf
   if mdg("PDF Interno (SIM) PdfCreator (NAO) " )      
      cFILE:=filetopdf( cARQSPO )
   else
      PrintUSB(cARQSPO,"PDFCreator")
      nTIPSPO=-1 //-1 para nao processar mais nada
      //FILEtoprwin( cARQSPO,3 )
   endif   
endif
/*
if nTIPSPO = 11     //imprime usuando externo desativada
   IMPEXT( cARQSPO )
endif
*/
if nTIPSPO = 12      //print raw
   FILEtoprwin( cARQSPO,1 )
endif
if nTIPSPO = 5      //win32prn
   FILEtoprwin( cARQSPO,2 )
endif
if lAPAGA.AND.(nTIPSPO = 1 .or. nTIPSPO =7 .or. nTIPSPO = 8 .or. nTIPSPO = 9 .or. nTIPSPO = 10 ; 
                      .or. nTIPSPO=12 .or. nTIPSPO=5)
                         //6 txt nao muda extensao nao apagar
   ferase( cARQSPO )     //11 nao pode apagar pois e externo
                         //demais direto na porta
endif
if nTIPSPO = 17
   cFILE:=filezebrapdf(cARQSPO)
endif

*+    6 - &TXT DOS    (OEM)
*+    7 - TXT WindowS (&ANSI)
*+    8 - &HTML
*+    9 - &RTF
*+   10 - &PDF
*+   17 - preview zebra
if nTIPSPO = 6 .or. nTIPSPO =7  .or. nTIPSPO = 8 .or. nTIPSPO = 9 .or. nTIPSPO = 10 .or. nTIPSPO = 17
   cTELA := savescreen( 6, 0, 17, 80 )
   CLSBOX( 6, 0, 17, 80 )
   HB_dispbox( 6, 0, 17, 79, B_DOUBLE+" ")
   oPCAO( 07, 01, " &Imprimir  ", 73 ) //1 
   oPCAO( 08, 01, " &Abrir     ", 65 ) //2
   oPCAO( 09, 01, " &Email     ", 69 ) //3
   oPCAO( 10, 01, " &Retornar  ", 82 ) //4
   nOPCAO := menu(, 0 )
   restscreen( 6, 0, 17, 80, cTELA )
   DO CASE
      CASE nOPCAO=1
	       shellexecprint(cFILE)
	  CASE nOPCAO=2
			wapi_ShellExecute( 0, "open", cFILE,"", 0, 1 )
	  CASE nOPCAO=3
	        filetoemail(cFILE)
   ENDCASE
endif
cIMPORI:=""
lIMPEMAIL:=.F.
return .T.

*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function IMPSTR()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function IMPSTR( cVAR )       //Passada String
if type( "nTIPSPO" )="U" .OR. nTIPSPO = 2 .or. nTIPSPO=3 ; 
                .or. nTIPSPO=4 .OR. nTIPSPO=13 .OR. nTIPSPO=14 .OR. nTIPSPO=5 //lpt123 com12 winprn
else
   return ""
endif
retu cVAR

*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function IMPCHR()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function IMPCHR( cCAR )     //Passada codigo ascii
if type( "nTIPSPO" ) = "U" .OR. nTIPSPO = 2 .or. nTIPSPO=3 ;
                           .or. nTIPSPO= 4  .OR. nTIPSPO=13 ; 
                           .OR. nTIPSPO=14  .OR. nTIPSPO=5  //lpt123 com12 winusb/troca tamanho letra
else
   retu ""
endif
if valtype( cCAR ) # "N"
   retu IMPSTR( cCAR )      //Caso Chamada string inves do codigo ascii
endif
return chr( cCAR )

*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function IMPFOL()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function IMPFOL( cCAR )
DO CASE
   CASE type( "nTIPSPO" ) = "U" //nao faz nada
   case nTIPSPO = 2 .or. nTIPSPO=3 .or. nTIPSPO=4 .OR. nTIPSPO=13 .or. nTIPSPO=14 //lpt123 com12
        eject        
   case nTIPSPO =9 //rtf
        @ prow(), pcol() say " \sect\sectd"
   case nTIPSPO =10 //pdf
        @ prow(), pcol() say "##page##"
   case nTIPSPO =5 //WINPRN
        @ prow(), pcol() say "\\page\\"
   otherwise
       @ prow(), pcol() say chr( 13 ) + chr( 10 )
endcase
retu

*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function IMPHP()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function IMPHP()

local nHP
local aRETU
aRETU := { chr( 15 ), chr( 18 ), chr( 14 ),CHR(27)+CHR(69),CHR(27)+CHR(70) }
        //1-normal 2-comprimido 3-expandido 4-negrito 5-sem negrito
cTELA := savescreen( 6, 26, 16, 58 )
CLSBOX( 6, 26, 16, 58 )
HB_dispbox( 6, 26, 16, 58, B_DOUBLE+" ")
oPCAO( 8, 28,  " &Matricial/Epson  ", 77 )
oPCAO( 9, 28,  " &HP Deskjet       ", 72 )
oPCAO( 10, 28, " &Laser            ", 76 )
opcao( 11, 28, " Le&Xmark          ", 88 )
opcao( 12, 28, " Escolher Lista  &1", 49 )
opcao( 13, 28, " Escolher Lista  &2", 50 )
opcao( 14, 28, " Escolher Lista  &3", 51 )
oPCAO( 15, 28, " &Nenhum Codigo    ", 78 )
nHP := menu(3, 0 )
restscreen( 6, 26, 16, 58, cTELA )


if nHP = 2    //HP
   aRETU := { chr(27)+chr(40)+chr(115)+"16"+chr(72), ;
              chr(27)+chr(40)+chr(115)+"12"+chr(72), ;
              chr(27)+chr(40)+chr(115)+"23"+chr(72), ;
              chr(27)+chr(40)+chr(115)+CHR(51)+chr(66), ;
              chr(27)+chr(40)+chr(115)+CHR(45)+CHR(51)+chr(66)}
endif
if nHP = 3     //LASER
   aRETU := { chr( 27 ) + chr( 38 ) + chr( 107 ) + chr( 50 ) + chr( 83 ), ;
              chr( 27 ) + chr( 38 ) + chr( 107 ) + chr( 48 ) + chr( 83 ), "" , ;
              chr( 27 ) + chr( 40 ) + chr( 115 ) + CHR(51) + chr( 66 ), ;
              chr( 27 ) + chr( 40 ) + chr( 115 ) + CHR(48) + chr( 66 ) }
endif
if nHP = 4    //LEXMARK
   aRETU := { chr( 27 ) + chr( 38 ) + chr( 107 ) + chr( 50 ) + chr( 83 ) + chr( 27 ) + chr( 38 ) + ;
              chr( 108 ) + "8" + chr( 68 ) + chr( 27 ) + chr( 38 ) + chr( 108 ) + "90" + chr( 80 ), ;
              chr( 27 ) + chr( 38 ) + chr( 107 ) + chr( 52 ) + chr( 83 ) + chr( 27 ) + chr( 38 ) + ;
              chr( 108 ) + "5" + chr( 68 ) + chr( 27 ) + chr( 38 ) + chr( 108 ) + "66" + chr( 80 ), ;
              chr( 27 ) + chr( 40 ) + chr( 115 ) + "23" + chr( 72 ) + chr( 27 ) + chr( 38 ) + chr( 108 ) + ;
              "10" + chr( 68 ) + chr( 27 ) + chr( 38 ) + chr( 108 ) + "90" + chr( 80 ) }
endif
IF nHP = 5
   cTMPCAM := PROFILESTRING( "PRINTER.INI", "PATH", "DOSPRNDBF", "" )
   netuse(cTMPCAM+"DOSPRN1","DBFCDX",.T.,.T.,.T.,.T. )
   DBFVIEW("' '+PR_NAME+' '+GRAPH_DRIV",10,10,20,50)
   cIMPCOM :=FAZSPCCHR(ALLTRIM(COND_ON))
   cIMPEXP :=FAZSPCCHR(ALLTRIM(COND_OFF))
   cIMPNEG :=FAZSPCCHR(ALLTRIM(BOLD_ON))
   cIMPNER :=FAZSPCCHR(ALLTRIM(BOLD_OFF))
   if ! empty(cIMPCOM)
      aRETU[1]:=&cIMPCOM.
   ENDIF
   IF ! EMPTY(cIMPEXP)
      aRETU[2]:=&cIMPEXP.
   ENDIF
   aRETU[3]:=""
   IF ! EMPTY(cIMPNEG)
      aRETU[4]:=&cIMPNEG.
   ENDIF
   IF ! EMPTY(cIMPNEG)
      aRETU[5]:=&cIMPNEG.
   ENDIF
   DBCLOSEALL()
endif
IF nHP = 6
   cTMPCAM := PROFILESTRING( "PRINTER.INI", "PATH", "DOSPRNDBF", "" )
   netuse(cTMPCAM+"DOSPRN2","DBFCDX",.T.,.T.,.T.,.T. )
   DBFVIEW("' '+EMPRESA+' '+IMPRESS",10,10,20,50)
   aRETU[1]:=ALLTRIM(CONDON)
   aRETU[2]:=ALLTRIM(CONDOFF)
   aRETU[3]:=""
   aRETU[4]:=ALLTRIM(NEGRON)
   aRETU[5]:=ALLTRIM(NEGROFF)
   DBCLOSEALL()
endif
IF nHP = 7
   aRETU := { "", "", "" }
   cTMPCAM := PROFILESTRING( "PRINTER.INI", "PATH", "DOSPRNDBF", "" )
   netuse(cTMPCAM+"DOSPRN3","DBFCDX",.T.,.T.,.T.,.T. )
   DBFVIEW("NOME",10,10,20,50)
   if ! empty(C_10CPI)
      aRETU[1]:=&C_10CPI.
   ENDIF
   IF ! EMPTY(C_17CPI)
      aRETU[2]:=&C_17CPI.
   ENDIF
   //DOSPRN3 So tem comprimido expandido
   aRETU[3]:=""
   aRETU[4]:=""
   aRETU[5]:=""
   DBCLOSEALL()
endif
if nHP = 8
   aRETU := { "", "", "" ,"",""}
endif
//Variaveis Publicas de Impressao
cIMPCOM := aRETU[ 1 ]
cIMPEXP := aRETU[ 2 ]
cIMPTIT := aRETU[ 3 ]
IF LEN(aRETU)>3 //temporariamente ate pegar codigos posicoes 4,5 impressoras
   cIMPNEG := aRETU[ 4 ]
   ciMPNER := aRETU[ 5 ]
ELSE
   cIMPNEG := ""
   ciMPNER := ""
ENDIF
retu aRETU

FUNC FAZSPCCHR(cTEXTO)
LOCAL aUSO
LOCAL cUSO
aUSO:=HB_ATokens(cTEXTO," ")
cUSO:=""
FOR X=1 TO LEN(aUSO)
    IF ! EMPTY(cUSO)
       cUSO=cUSO+"+"
    ENDIF
    IF ! EMPTY(aUSO[X])
       cUSO="CHR("+aUSO[X]+")"
    ENDIF
NEXT X
RETU cUSO

*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function filetohtml()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function filetohtml( cFILE )
RETURN fileconvert( cFILE, "HTML" )


*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function filetoRTF()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function filetoRTF( cFILE )
RETURN fileconvert( cFILE, "RTF" )


*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function filetoTXTWin()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function filetoTXTWin( cFILE )
RETURN fileconvert( cFILE, "TXTWIN" )


*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function fileconvert()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function fileconvert( cFILE, cTIPO )
local x
nHANDLE := hb_fopen( cFILE )
if nHANDLE = 0
   ALERTX( "Arquivo nao Pode ser Aberto" )
endif
cFILE := substr( cFILE, 1, at( ".", cFILE ) - 1 )
if cTIPO = "HTML"
   cFILE += ".HTM"
endif
if cTIPO = "RTF"
   cFILE += ".RTF"
endif
if cTIPO = "TXTWIN"
   cFILE += ".TXT"
endif
nHANWRI := fcreate( cFILE, 0 )
if nHANWRI = - 1
   ALERTX( "Arquivo nao Pode ser Criado" + cFILE )
   return "erro.txt"
endif
if cTIPO = "HTML"
   fwrite( nHANWRI, "<html>" + chr( 13 ) + chr( 10 ) )
   fwrite( nHANWRI, "<head>" + chr( 13 ) + chr( 10 ) )
   fwrite( nHANWRI, '<meta http-equiv="Content-Type"' + chr( 13 ) + chr( 10 ) )
   fwrite( nHANWRI, 'content="text/html; charset=iso-8859-1">' + chr( 13 ) + chr( 10 ) )
   fwrite( nHANWRI, '<meta name="GENERATOR" content="Sistemas">' + chr( 13 ) + chr( 10 ) )
   fwrite( nHANWRI, "<title>Titulo</title>" + chr( 13 ) + chr( 10 ) )
   fwrite( nHANWRI, "</head>" + chr( 13 ) + chr( 10 ) )
   fwrite( nHANWRI, "<body>" + chr( 13 ) + chr( 10 ) )
endif
if cTIPO = "RTF"
   fwrite( nHANWRI,"{\rtf1\ansi\ansicpg850\deff5{\fonttbl{\f0\fmodern\fprq1  Courier New;}{\f1\fnil\fcharset254 Times New Roman;}{\f2\fswiss\fprq2\fcharset254 Verdana;}{\f3\fnil\fcharset2 Symbol;}{\f4\fmodern\fprq1\fcharset254 Draft 10cpi;}{\f5\fmodern\fprq1\fcharset254 Draft 12cpi;}{\f6\fnil\fprq1\fcharset0 ProFontWindows;}{\f7\fmodern\fprq1\fcharset0 FixedDB ThaiText;} }")
   fwrite( nHANWRI,"{\colortbl ;\red0\green0\blue255;\red255\green0\blue0;\red0\green255\blue0;\red0\green0\blue0;\red128\green128\blue128;\red192\green192\blue192;\red255\green255\blue0;}")
   fwrite( nHANWRI,"\viewkind1\viewscale100\uc1\pard\lang1046")
   fwrite( nHANWRI,"\fafixed")
   fwrite( nHANWRI,"\margl283\margr283\margt1134\margb567")   //margens
   fwrite( nHANWRI,"\f0\fs20") //inicia com fonte 0(Courier New) Tabmanho 20 20
endif
cVAR := FREADLINE( nHANDLE )
while cVAR <> "__FINAL__"
    if CTIPO = "RTF"  //trata caraceter antes converter ansi
      aacentos:= {{"†", "\'e1"}, {"µ", "\'c1"} , {"µ", "\'e1"}, {"Ç","\'e9"}, {"ê", "\'c9"}, {"°", "\'ed"}, {"÷", "\'cd"}, {"¢","\'f3"}, ;
                  {"‡", "\'d3"}, {"£", "\'fa"} , {"È", "\'da"}, {"á","\'e7"}, {"Ä", "\'c7"}, {"Ö", "\'e0"}, {"∑", "\'c0"}, {"É","\'e2"}, ;
                  {"ì", "\'f4"}, {"‚", "\'d4"} , {"∆", "\'e3"}, {"«","\'c3"}, {"‰", "\'f5"}, {"Â", "\'d5"}, {"“", "\'ca"}, {"à","\'ea"}, ;
                  {"‘", "\'c8"}, {"•", "\'d1"} , {"§", "\'f1"}, {"¶","\'aa"}, {"ß", "\'ba"}, {"ﬁ", "\'cc"}, {"◊", "\'ce"}, {"„","\'d2"}, ;
                  {"Î", "\'d9"}, {"~", Chr(13)}, {"˝","\super 2 \nosupersub"}, {"¸", "\super 3 \nosupersub"}, ;
                  {"Í", "\'db"}, {"+b","\b "}  , { "+bu" , "\ul\b " } ,{ "+bi" , "\b\i "} ,{ "+bui", "\ul\b\i "} ,{ "+i"  , "\i "} , ;
                  { "+il" , "\ul\i "} ,{ "+u"  , "\ul "} ,{ "-b"  , "\b0 "} ,{ "-bu" , "\b0\ulnone "} ,{ "-bi" , "\b0\i0 "} ,{ "-bui", "\b0\i0\ulnone "} , ;
                  { "-i"  , "\i0 "} , { "-il" , "\ulnone\i0 "} , { "-u"  , "\ulnone "} }
       AADD(aacentos,{cIMPNEG,"\b "})          //negrito
       AADD(aacentos,{cIMPNER,"\b0 "})         //negrito off

       AADD(aacentos,{cIMPNEG,"\b "})
       AADD(aacentos,{cIMPNER,"\b0 "})
       AADD(aacentos,{CHR(12)," \sect\sectd"}) //Salto folha
       AADD(aacentos,{CHR(27)+CHR(45)+CHR(00),"\ul "})           //underline
       AADD(aacentos,{CHR(27)+CHR(45)+CHR(01),"\ulnone " })
       AADD(aacentos,{CHR(27)+CHR(52),"\i "})
       AADD(aacentos,{CHR(27)+CHR(53),"\i0 "})
       for x=1 to len(aacentos)
           cVAR:=STRTRAN(cVAR,aacentos[x,1],aacentos[x,2])
       next x
   endif
   cVAR := Convansi( cVAR )             //Converte Window
   //Remove caracteres inferioes a espaco chr32() mantendo line feed
   cVAR := RANGEREM( chr( 0 ), chr( 09 ), cVAR )            // CHR(13)+CHR(10) Line Feed Manter
   cVAR := RANGEREM( chr( 11 ), chr( 12 ), cVAR )
   cVAR := RANGEREM( chr( 14 ), chr( 31 ), cVAR )
   if cTIPO = "HTML"
      cVAR := str2html( cVAR )
      cVAR += chr( 13 ) + chr( 10 ) + "<BR>"
   endif
   if CTIPO = "RTF"
      cVAR += "\par" + chr( 13 )
   endif
   if cTIPO = "TXTWIN"
      cVAR += chr( 13 ) + chr( 10 )
   endif
   fwrite( nHANWRI, cvAR )
   mds( cVAR )
   cVAR := FREADLINE( nHANDLE )
enddo
if cTIPO = "HTML"
   fwrite( nHANWRI, "</body>" + chr( 13 ) + chr( 10 ) + "</html>" + chr( 13 ) + chr( 10 ) )
endif
if cTIPO = "RTF"
   fwrite( nHANWRI, "\par}" )
endif
fclose( cFILE )
fclose( nHANWRI )
return cFILE


/*
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
*+    Function impext()
*+
*+°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
*+
function impext( cARQ )
local X
local nRUN
local nTECLA
local cTELA
local cMENU
priv cRUN
cTELA := savescreen( 6, 10, 17, 70 )
CLSBOX( 6, 10, 17, 70 )
HB_dispbox( 6, 10, 17, 70, B_DOUBLE+" " )
while .T.
   for X := 1 to 20
      cMENU  := PROFILESTRING( "PRINTER.INI", "PRGEXT", "DES" + strzero( X, 2 ), "Nao Disponivel" )
      nTECLA := PROFILENUM( "PRINTER.INI", "PRGEXT", "TEC" + strzero( X, 2 ), 0 )
      oPCAO( if( X < 11, X + 6, X - 4 ), if( X < 11, 12, 32 ), cMENU, nTECLA )
   next x
   nRUN := menu(, 0 )
   if nRUN > 0
      exit
   endif
enddo
restscreen( 6, 10, 17, 70, cTELA )
cRUN := PROFILESTRING( "PRINTER.INI", "PRGEXT", "EXE" + strzero( nRUN, 2 ), "DIR" ) + " "
cRUN += PROFILESTRING( "PRINTER.INI", "PRGEXT", "PRE" + strzero( nRUN, 2 ), "" ) + " "
cRUN += cARQ + " "
cRUN += PROFILESTRING( "PRINTER.INI", "PRGEXT", "PAR" + strzero( nRUN, 2 ), "" ) + " "
cRUN := strtran( cRUN, "  ", " " )      //Tira duplos Espacos
bb_run(cRUN)
retu .t.
*/

FUNCTION FILETOEMAIL(cARQ,cASSUNTO,cCORPOMSG)
LOCAL cServerIP,nPort,cFrom,aTo,aArqEmail,cUser,cPass,cPop,cVAR
aUSO:=SALVAA()
cTO:=SPACE(60)
IF VALTYPE(cASSUNTO)<>"C"
   cASSUNTO:=SPACE(60)
ENDiF
IF VALTYPE(cCORPOMSG)<>"C"
   cCORPOMSG:=SPACE(60)
ENDIF
@ 14,00 CLEAR TO 24,79
@ 15,00 SAY "Para"
@ 15,10 GET cTO       valid CheckEmail( cTO )
@ 16,00 SAY "Assunto"
@ 16,10 GET cASSUNTO
@ 17,00 SAY "Mensagem"
@ 17,10 GET cCORPOMSG
READCUR()

cSERVERIP := PROFILESTRING( "PRINTER.INI","EMAIL","SERVER")
nPORT:= VAL(PROFILESTRING( "PRINTER.INI","EMAIL","PORTA"))
cFROM := PROFILESTRING( "PRINTER.INI","EMAIL","FROM")
cUSER := PROFILESTRING( "PRINTER.INI","EMAIL","USUARIO")
cPASS := PROFILESTRING( "PRINTER.INI","EMAIL","SENHA")
cPOP  := PROFILESTRING( "PRINTER.INI","EMAIL","POP")

cTO:=ALLTRIM(cTO)
cTO:=lower(cTO)
cTO:=STRTRAN(cTO,";",",")
IF AT(",",cTO)>0
   aTO=HB_ATOKENS(cTO,",")
ELSE
   aTo      :={cTO}
ENDIF
cASSUNTO :=ALLTRIM(cASSUNTO)
cCORPOMSG:=ALLTRIM(cCORPOMSG)
IF VALTYPE(cARQ)="C"
   aARQEMAIL:={cARQ}
ENDIF
IF VALTYPE(aARQEMAIL)<>"A"
   aARQEMAIL:={}
ENDIF

/*
   cServer    -> Required. IP or Domain name of the mail server
   nPort      -> Optional. Port used my email server
   cFrom      -> Required. Email address of the sender
   aTo        -> Required. Character String or array of email addresses to send the email to
   aCC        -> Optional. Character String or array of email adresses for CC (Carbon Copy)
   aBCC       -> Optional. Character String or array of email adresses for BCC (BLind Carbon Copy)
   cBody      -> Optional. The body Message of the email as text, or the Filename of the HTML Message to send.
   cSubject   -> Optional. Subject of the sending email
   aFiles     -> Optional. Array of attachments to the email to send
   cUser      -> Required. User name for the POP3 server
   cPass      -> Required. Password for cUser
   cPopServer -> Required. Pop3 server name or address
   nPriority  -> Optional. Email priority: 1=High, 3=Normal (Standard), 5=Low
   lRead      -> Optional. If Set to .T., a Confirmation request is send. Standard Setting is .F.
   lTrace     -> Optional. If Set to .T., a log File is created (sendmail<nNr>.log). Standard Setting is .F.
   */
IF MDG("Enviar SIM(Sendmail) NAO(MAPI)")
   TRY 
     lVar:=HB_SendMail(cServerIP,nPort,cFrom,aTo,,,cCorpoMsg,cAssunto,aArqEmail,cUser,cPass,cPop,3,.F.,.T.)
   catch 
     lVAR:=.F.
   END  
ELSE
   lVAR:=.T.
   TRY
   win_MAPISendMail( ;
         cAssunto,                        ; // subject
         cCorpoMsg,                           ; // menssage
         NIL,                             ; // type of message
         DToS( Date() ) + " " + Time(),   ; // send date
         "",                              ; // conversation ID
         .F.,                       ; // acknowledgment
         .T.,                       ; // user intervention
         {cfrom},                         ; // sender
         aTO,                           ; // destinators
         aArqEmail                           ) // attach   
        
   catch 
     lVAR:=.F.
   END  

ENDIF   
If lVar
   cVar:="Envio Ok"
Else
   cVar:="Erro no Envio"
EndIf
ALERTX(cVar)

RESTAA(aUSO)
return .t.

*+≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
*+
*+    Function filetoprwin()
*+
*+≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
*+
FUNCTION filetoprwin(cARQ,nTIPO)
LOCAL cPRINTER
LOCAL aPRN,vaprinter
LOCAL nRESP
LOCAL i
LOCAL nSTATUS
cPRINTER  := WIN_PRINTERGETDEFAULT()
vaPrinter := WIN_PRINTERLIST(.T.)
If Empty(vaPrinter )
   ALERTX("Nenhuma impressora instalada")
   retu .f.
EndIf
aPrn := {}
// Laco para montar o array com
// todas as impressoras
For i:= 1 TO Len(vaPrinter)
    if cPrinter = vaPrinter[i,1]  // Se for a padrao
       // Coloca um (P) antes do nome
       AADD(aPrn,"(P) "+vaPrinter[i,1]+' em '+vaPrinter[i,2])
    else
       // Armazena as outras
       AADD(aPrn,"    "+vaPrinter[i,1]+' em '+vaPrinter[i,2])
   endif
Next
cTELA := savescreen( 5, 5, 17, 75 )
HB_DISPBOX(5,5,17,75,B_DOUBLE+" ")
nRESP := ACHOICE(6,6, 16,74,aPrn)
cPorta:=""
if lastkey()=13
   cPRINTER:= vaprinter[nRESP,1] //pega nome impressora a matriz original
   cPorta  := vaprinter[nRESP,2] //pega a porta
   //ALERTX(cPRINTER)
   nStatus := PrintStat(cPrinter)
   if nSTATUS>0
      if ! mdg("Continuar a impressora: " + IsImpressora(cPrinter))
         retu .f.
     endif
   endif
else
   ALERTX("Nao Selecionada")
   retu .F.
endif
RESTscreen( 5, 5, 17, 75,CTELA )


oPrinter:= Win_Prn():new(cPrinter)
oPrinter:create()
oPrinter:startDoc()
nLar:=oPrinter:pagewidth()   //Larqura
nAlt:=oPrinter:pageheight()  //Altura
nCor:=oPrinter:numcolors()   //ncores
oPrinter:enddoc()
oPrinter:destroy()
lMatrix:=.F.
IF SUBSTR(UPPER(cPorta),1,3)="LPT" .AND. nCor<3 .AND. nLar<1000 .AND. nAlt<2000
   lMatrix:=.T.
ENDIF
cPRINTER:=ALLTRIM(cPRINTER)
IF VALTYPE(NTIPO)<>"N"
   IF MDG("Use SIM=PrinterFileRaw NAO=W32PRN")
      nTIPO:=1
   ELSE
      nTIPO:=2
   ENDIF
ENDIF

IF nTIPO=1
   //
   //PrintFileRaw(cPRINTER,cFile,cTITULO)
   //
//   nPrn := PrintFileRaw(cPRINTER,cARQ,"Imprimindo:"+cARQ)
   nPrn := WIN_PrintFileRaw(cPRINTER,cARQ,"Imprimindo:"+cARQ)
   IF nPRN < 0
       DO CASE
          CASE nPrn = -1
               ALERTX("Parametros Invalido, Favor Tentar Novamente")
          CASE nPrn = -2
               ALERTX("Falha na chamada da Impressora, Favor Verificar a Impressora")
          CASE nPrn = -3
               ALERTX("Falha ao Iniciar Impressao, Favor Verificar a Impressora")
           CASE nPrn = -4
               ALERTX("Falha ao Iniciar a Primeira Pagina, Favor Verificar a Impressora")
           CASE nPrn = -5
               ALERTX("Falha de Memoria da Impressora, Favor Verificar a Impressora")
           CASE nPrn = -6
               ALERTX("Nao foi Possivel localizar o arquivo de Impressao, Favor Tentar Novamente")
          OTHERWISE
                //ALERTX(cFileName+" PRINTED OK!!!?")
      ENDCASE
   ENDIF
ELSE
   PrintUSB(cARQ,cPRINTER)
ENDIF
retu .t.



*+≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
*+
*+    Function PrintUSB(DocPrinter,xPRINTER) RETU .T. .F.
*+
*+≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
*+
Function PrintUSB(DocPrinter,xPRINTER)

       Local mDocPrint, vDocPrint, nA, nLand, nLin := 1, nTamPag, cMsg ,i
       Local aCAMPOS,cMACRO,bBLOCK,aACENTOS


       //oPrinter:Italic( .F. )
       //oPrinter:UnderLine( .F. )
       //oPrinter:bold(700)
       // Tabela para oPrinter:bold
       // DONTCARE     0    // THIN       100
       // EXTRALIGHT 200    // LIGHT      300
       // NORMAL     400    // MEDIUM     500
       // SEMIBOLD   600    // BOLD       700
       // EXTRABOLD  800    // HEAVY      900

       aACENTOS:={}
       AADD(aacentos,{cIMPNEG,"oPrinter:bold(700)"})                            //negrito
       AADD(aacentos,{cIMPNER,"oPrinter:bold(400)"})                           //negrito off
       AADD(aacentos,{CHR(27)+CHR(69),"oPrinter:bold(700)"})
       AADD(aacentos,{CHR(27)+CHR(70),"oPrinter:bold(700) "})
       AADD(aacentos,{CHR(12),"oPrinter:newPage(),nLin := 1"})                           //Salto folha
       AADD(aacentos,{CHR(27)+CHR(45)+CHR(00),"oPrinter:UnderLine( .T. )"})    //underline
       AADD(aacentos,{CHR(27)+CHR(45)+CHR(01),"oPrinter:UnderLine( .F. )"})
       AADD(aacentos,{CHR(27)+CHR(52),"oPrinter:Italic( .T. )"})               //italico
       AADD(aacentos,{CHR(27)+CHR(53),"oPrinter:Italic( .F. )"})

       
       //deixa regra com variavel e com chr
       AADD(aacentos,{cIMPCOM,"oPrinter:SetFont('Courier',8,{3,-50}),oPrinter:bold( 100 )"})       //
       AADD(aacentos,{cIMPEXP,"oPrinter:setFont('Courier',8),oPrinter:bold( 200 )"})       //
       AADD(aacentos,{CHR(15),"oPrinter:SetFont('Courier',8,{3,-50}),oPrinter:bold( 100 )"})       //
       AADD(aacentos,{CHR(18),"oPrinter:setFont('Courier',8),oPrinter:bold( 200 )"})      //
       AADD(aacentos,{chr(14)+chr(15),"oPrinter:setFont('Courier',12),oPrinter:bold( 400 )"})       //
       AADD(aacentos,{chr(20)+chr(15),"oPrinter:setFont('Courier',12),oPrinter:bold( 800 )"})      //




       oPrinter := Win32Prn():new( xPrinter )   // Crio a instancia da impressora


       // Leio o arquvo gerado do diretorio temp ou outro qualquer
       mDocPrint = hb_memoread(DocPrinter)

       // Verifica se vai imprimir em Retrato (nLand=.f.)
       // ou Paisagem (nLand=.t.)       
       nLand   := .f.
       nTamPag := 62  // 62 Linhas em modo Retrato ou 45 em modo Paisagem
       IF EMPTY(cIMPORI)
          // Faco um laco para pegar a maior linha
          for nA := 1 to MLCount(mDocPrint,229)
              vDocPrint := rTrim(MemoLine(mDocPrint,229,nA))
              if len(vDocPrint) > 116  // Se a linha for maior
                 nLand   := .t.        // Muda para Paisagem
                 nTamPag := 45         // (Re)Configura o numero de linhas
                 exit                  // Mudou, nao precisa continuar
              endif
          next
       ELSE
          IF cIMPORI="R"       
             nLand   := .f.
             nTamPag := 62  // 62 Linhas em modo Retrato ou 45 em modo Paisagem          
          ENDIF
          IF cIMPORI="P"       
             nLand   := .t.        // Muda para Paisagem
             nTamPag := 45         // (Re)Configura o numero de linhas          
          ENDIF

       ENDIF   

       // Mostra mensagem no rodape
       //cMsg := iif(nLand,"Imprimindo em modo Paisagem","Imprimindo em modo Retrato")
       //nA := len(cMsg)
       //nA := int((80-nA)/2)
       //@ maxrow(), nA say cMsg color "gr+/n"
       @ maxrow(),0 say iif(nLand,"Imprimindo em modo Paisagem","Imprimindo em modo Retrato") 

       oPrinter:landscape := nLand

       // LETTER 1 US  Letter format 8 1/2 x 11 inch
       // LEGAL  5 US  Legal  format 8 1/2 x 14 inch
       // A3     8 DIN A3     format 297 x 420 mm
       // A4     9 DIN A4     format 210 x 297 mm
       oPrinter:formType  := 9   // Papel A4

       oPrinter:copies    := 1   // Numero de copias

       // Cria dispositivo de impressao
       If .not. oPrinter:create()
          ALERTX( "Nao foi possivel criar o dispositivo de impressao" )
          return(.f.)
       EndIf

       // Criar trabalho de impressao
       If .not. oPrinter:startDoc( DocPrinter ) // Encarrega o spooler para comecar com um novo documento
          ALERTX( "Nao foi possivel criar o documento" )
          return(.f.)
       EndIf


       //oPrinter:SetFont(cFontName, nPointSize, nWidth, nBold, lUnderline, lItalic, nCharSet)
       //oPrinter:SetFont('Courier New',12,{1,12}, 0, .F., .F.)
       //1-Nome da fonte;
       //2-Altura da fonte, em pixels;
       //3-Multiplicador da fonte (horizontal e vertical);
       //4-Largura da fonte - CPI (12 character per inch);
       //5-Controla o Negrito-Bold (700) ou normal (.F.);
       //6-Controla o sublinhado (.T.) ou nao (.F.);
       //7-Controla o italico (.T.) ou nao (.F.).

       oPrinter:setFont("Courier",8) // Fonte Courier
       oPrinter:bold( 200 )

       vtTeste = "Entrada"
       // Laco para imprimir linha por linha
       for nA := 1 to MLCount(mDocPrint,229)
           vDocPrint := rTrim(MemoLine(mDocPrint,229,nA))
           IF at("\\PAGE\\",UPPER(vDocPrint))>0
              nLin := nTamPag -1
              vDocPrint:=strtran(vDocPrint,"\\page\\","")
           ELSE

                // Remove todo e qualquer caractere especial
                // menor que 32 ou maior que 125 (asc)
                //vDocPrint := RemoveMarcas(vDocPrint)
                // Imprime a linha


                for i=1 to len(aacentos)
                   vDocPrint:=strtran(vDocPrint,aacentos[i,1],"\\#"+aacentos[i,2]+"\\")
                next i


                aCAMPOS:=HB_ATokens(vDocPrint,"\\")

                IF LEN(aCAMPOS)>0
                     FOR i=1 TO LEN(aCAMPOS)
                         IF SUBSTR(aCAMPOS[i],1,1)="#"
                            cMACRO:=SUBSTR(aCAMPOS[i],2)
//                            @ 16,00 SAY cMACRO
                            bBlock := &( "{||" + cMacro + "}" )
                            EVAL(Bblock)
                         ELSE
                            oPrinter:textOut(rTrim(aCAMPOS[i]))
                         ENDIF
                     NEXT i
                 ELSE
                   oPrinter:textOut(rTrim(vDocPrint))
                 ENDIF


                // Insere uma nova linha
                oPrinter:newLine()

                oPrinter:setFont("Courier",8) // Fonte Courier 8
                oPrinter:bold( 200 )          // 200
                // Verifica se chegou no final da pagina
            endif
            nLin ++
            if nLin > nTamPag //if (oPrinter:MaxRow() - 2) <= oPrinter:Prow() 
               nLin := 1
               oPrinter:newPage()
            endif
       next

       // Envia saida para impressora
       oPrinter:endDoc()

       // Encerra a impressao e destroi o objeto
       oPrinter:destroy()
       Return(.t.)

function filezebrapdf(cARQSPO)
cFILE := substr( cARQSPO, 1, at( ".", cARQSPO ) - 1 )
cFILE += ".pdf"
oServerWS := Win_OleCreateObject("MSXML2.ServerXMLHTTP")
oXMLDoc   := Win_OleCreateObject("MSXML2.DOMDocument")
   
cUrlWS := 'http://api.labelary.com/v1/printers/8dpmm/labels/4x6/0/' 
//cData :=  '"^XA^MMT^PW400^LL0400^LS0^FT5,384^A0N,41,40^FH\^FDwww.pctoledo.com.br^FS^BY1,3,99^FT70,322^BCN,,Y,N^FD>:Forum do Programador^FS^FT10,46^A0N,38,60^FH\^FDLinguagem ZPL^FS^BY1,3,104^FT96,182^B3N,N,,Y,N^FD1135265909+^FS^PQ1,0,1,Y^XZ"'
cDATA:= '"'+strtran(STRTRAN(hb_memoread(CARQSPO),CHR(13),""),chr(10),"")+'"'

nResolve := 5 * 1000  
nConnect := 5 * 1000  
nSend    := 30 * 1000  
nReceive := 30 * 1000  
   
With Object oServerWS
   :SetTimeouts( nResolve, nConnect, nSend, nReceive )
   :Open( "POST", cUrlWS, .F. )
   :SetRequestHeader( "Content-Type", 'application/x-www-form-urlencoded; charset="utf-8"' )
   :SetRequestHeader( "Accept", "application/pdf")
   :SetRequestHeader( "Content-Length", hb_NtoS( 3000 ) ) //3000 Ç o m†ximo
   :Send( cData )
   Do While :readyState != 4
      :WaitForResponse( 1000 )
   Enddo
   cResp := :responseBody
   Hb_Memowrit(cFILE, cResp )
End
return cFILE

*+≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
*+
*+    Function IsImpressora( QuePrinter )
*+    Funcao para retornar a mesnagem de status da impressora
*+
*+≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
*+
function IsImpressora( QuePrinter )
LOCAL nStatus
nStatus := PrintStat( QuePrinter )
if     nStatus <        1 ; cERRO+="OK"
       elseif nStatus =        1 ; cERRO+="Impressora Pausada"
       elseif nStatus =        2 ; cERRO+="Impressora com Erro"
       elseif nStatus =        4 ; cERRO+="Impressora Deletando"
       elseif nStatus =        8 ; cERRO+="Impressora em Modo Bandeja"
       elseif nStatus =       16 ; cERRO+="Impressora Sem Papel"
       elseif nStatus =       32 ; cERRO+="Impressora em Modo Manual"
       elseif nStatus =       64 ; cERRO+="Impressora com Problema no Papel"
       elseif nStatus =      128 ; cERRO+="Impressora OffLine"
       elseif nStatus =      256 ; cERRO+="Impressora com IO Ativo"
       elseif nStatus =      512 ; cERRO+="Impressora Ocupada"
       elseif nStatus =     1024 ; cERRO+="Impressora Imprimindo"
       elseif nStatus =     2048 ; cERRO+="Impressora Memoria Lotada"
       elseif nStatus =     4096 ; cERRO+="Impressora Nao Instalada"
       elseif nStatus =     8192 ; cERRO+="Impressora Aguardando"
       elseif nStatus =    16384 ; cERRO+="Impressora Processando"
       elseif nStatus =    32768 ; cERRO+="Impressora Inicializando"
       elseif nStatus =    65536 ; cERRO+="Impressora em Atencao"
       elseif nStatus =   131072 ; cERRO+="Impressora Toner Baixo"
       elseif nStatus =   262144 ; cERRO+="Impressora Sem Toner"
       elseif nStatus =   524288 ; cERRO+="Impressora PAGE_PUNT"
       elseif nStatus =  1048576 ; cERRO+="Impressora Intervencao do Usuario"
       elseif nStatus =  2097152 ; cERRO+="Impressora Sem Memoria"
       elseif nStatus =  4194304 ; cERRO+="Impressora Tampa Aberta"
       elseif nStatus =  8388608 ; cERRO+="Impressora Servidor Desconhecido"
       elseif nStatus = 16777217 ; cERRO+="Impressora POWER_SAVE"
endif
return(nil)



//FUNCTION PRCOMMIT
//local cPrinter := set( _SET_PRINTFILE, "LPT3" )
//set( _SET_PRINTFILE, "LPT2" )
//set( _SET_PRINTFILE, "LPT1" )
//set( _SET_PRINTFILE, "" )
// restorNA the original printer-port!
//set(_SET_PRINTFILE, cPrinter, .t.)
 //return nil

*+≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
*+
*+    Function NETredir()
*+
*+≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
*+
///function netredir(cPORTA,cCAMINHO) //apenas refetencia funcao nativa da hbct(catools)
   //   RUN CMD.EXE /C NET USE LPT1 \\MAQ08\ROS /Y >NULL
   //   RUN net use LPT1 \\Dell\HP /Persistent:Yes
   ///cRUN:="CMD.EXE NET USE "+cPORTA+" "+cCAMINHO+" /Persistent:Yes "
   ///hb_run(cRUN)
   //desmapear
   //net use LPT1 /Delete
///RETURN .t.

//NetRedir( <cLocal>    , ;
//          <cServer>   , ;
//         [<cPassword>], ;
//         [<lShowError>] ) --> lSuccess

//Uso: F_NetRedir( <cLocal> ,;
//<cServer> ,;
//<cUserName> ,;
//<cPassword> ,;
//[<lShowError>] ) --> lSuccess
//
//VTERM:=UPPER(NETNAME()) // no WinXP pega o nome da estaá∆o
//IF !(VTERM="CREDI_BALCAO_6")
//   NETREDIR("LPT2","\\CREDI_BALCAO_6\EPSON") //  captura impressora
//ENDIF                              
//COPY FILE("CREDI_01.PRN") TO ("LPT2") // joga a impress∆o para o spooler na LPT2





*+ EOF: FLIB08.PRG
