*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_cd.prg
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


#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

//Help de Contexto
PRIV HELPDBF := "CONFIGU"


@ 01,00 say padr(" Ý Vocˆ est  editando a configura‡„o basica do sistema ",80)         

IF ZUSER = "/C" .OR. ZSUPER
ELSE
   ALERTX("Acesso Permitido Somente Para o Supervisor")
   RETU .F.
ENDIF


if !USECHK("CONFIGU",,.F.)
   quit
endif
HB_DISPBOX(2,0,23,79,B_DOUBLE)
@  3,3 SAY "Arquivo Ajuda :"+spac(11)+"Impressora:"+spac(14)+"Letra:"                
@  4,3 SAY "Arquivo de Configura‡„o Arquivos :"+spac(11)+"Arquivo do Manual"         
@  5,3 SAY "Arquivo de Configura‡„o Indexa‡„o:"+spac(11)+"Arquivo Historico"         
@  6,3 SAY "Diret¢rio dos Arquivos de Configura‡„o"                                  
@  8,3 SAY "Diret¢rio dos Arquivos Integrados"                                       
@ 10,3 SAY "Diret¢rio dos Arquivos Principal"                                        
@ 12,3 SAY "Diret¢rio dos Arquivos Empresa"                                          
@ 14,3 SAY "Diret¢rio dos Arquivos do Banco"                                         
@ 16,3 SAY "Diret¢rio dos Arquivos de Cep"                                           
@ 18,3 SAY "Configura‡„o da Moeda"                                                   
@ 19,3 SAY "Moeda"+spac(11)+"Singular"+spac(22)+"Plural"                             
@ 20,3 SAY "Centavos"+spac(8)+"Singular"+spac(22)+"Plural"                           
@ 21,3 SAY "Separador Moeda/Centavos"+spac(22)+"Simbolo"                             
@ 22,3 SAY "Sistema Multi-Empresa? (S/N)     CGCMA01    CGCMB01"                     
// Get nas Menvars
@  3,19 GET HELP                                  
@  3,41 GET IMPPAD                                
@  3,61 GET ARQFON                                
@  4,38 GET ARQ                                   
@  4,66 GET MANUAL                                
@  5,38 GET ARQ1                                  
@  5,66 GET ARQHIS                                
@  7,3  GET DIRC                                  
@  9,3  GET DIRI                                  
@ 11,3  GET DIRP                                  
@ 13,3  GET DIRE                                  
@ 15,3  GET DIRB                                  
@ 17,3  GET DIRA                                  
@ 19,28 GET MOEDA01                               
@ 19,57 GET MOEDA02                               
@ 20,28 GET MOEDA03                               
@ 20,57 GET MOEDA04                               
@ 21,28 GET MOEDA05                               
@ 21,57 GET MOEDA06                               
@ 22,32 GET MULTIEMP VALID MULTIEMP $ 'SN'        
@ 22,44 GET INXCGCMA PICTURE '9'                  
@ 22,55 GET INXCGCMB PICTURE '9'                  
READCUR()
dbclosearea()

//Pega a Configura‡ao
MCD01()


//Nao pode Ser chamado pois as vezes chama sem ter as telas
//aMCDGET:=EDITPEG("MCD001")
//aMCDTEL:=TELAPEG("MCD001")
//TELASAY(aMCDTEL)
//EDITSAY(aMCDGET)




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MCD01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MCD01()

//Pegando Configura‡”es do Sistema
while .T.
   if USECHK("CONFIGU",,.T.)
      exit
   else
      RETU .F.
   endif
enddo
ZARQHIS   := alltrim(ARQHIS)  // Nome do arquivo do Historico
HELPARQ   := alltrim(HELP)  // Nome do Arquivo do Help
ZARQMAN   := alltrim(MANUAL)  // Nome do Arquivo do Manual
ZARQ      := alltrim(ARQ)   // Nome do Arquivo de Configura‡„o Arquivos
ZARQ1     := alltrim(ARQ1)  // Nome do Arquivo de Configura‡„o Indexa‡„o
ZDIRC     := alltrim(DIRC)  // Nome do Diret¢rio de Configura‡„o
ZDIRI     := alltrim(DIRI)  // Nome do Diret¢rio de Arquivos Integrados
ZDIRP     := alltrim(DIRP)  // Nome do Diret¢rio Principal
ZDIRA     := alltrim(DIRA)  // Nome do Diret¢rio Ceps
ZDIRB     := alltrim(DIRB)  // Nome do Diret¢rio Banco
ZDIREx    := alltrim(DIRE)  // Nome do Diret¢rio da Empresa
ZMOEDA01  := alltrim(MOEDA01)   // Configura‡„o da Moeda Corrente Fun‡„o Extenso
ZMOEDA02  := alltrim(MOEDA02)
ZMOEDA03  := alltrim(MOEDA03)
ZMOEDA04  := alltrim(MOEDA04)
ZMOEDA05  := alltrim(MOEDA05)
ZMOEDA06  := alltrim(MOEDA06)
zMULTIEMP := MULTIEMP
zARQFON   := alltrim(ARQFON)
zIMPPAD   := alltrim(IMPPAD)
ZIMA      := INXCGCMA
ZIMB      := INXCGCMB
cRDDEXT   := ALLTRIM(DRIVER)
dbcloseall()
RETU .T.


// : FIM: M_CD.PRG
