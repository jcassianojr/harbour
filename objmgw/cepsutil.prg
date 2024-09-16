function pegcidconv(cUF,cNOME)
LOCAL cDBF
cDBF:=ALIAS()
IF EMPTY(cUF).OR.EMPTY(cNOME)
   return cNOME
ENDIF
dbselectar("cidconv")
dbgotop()
if dbseek(cUF+cNOME)
   cNOME:=CIDDES
ENDIF
IF ! EMPTY(cDBF)
   DBSELECTAR(cDBF)
ENDIF   
RETUrn cNOME


FUNCTION BUSCAIBGE(cUF,cCIDADE)
LOCAL cIBGE
LOCAL cALIAS
LOCAL cBUSCA

cALIAS:=ALIAS()

cBUSCA:=cUF+cCIDADE
cIBGE:=""
cBUSCA := strtran( alltrim( cBUSCA ), "'", " " )    //tirar como d'agua d'olho

dbselectar("MD10")
dbsetorder(1)
dbgotop()
if dbseek(cbUSCA)
   cIBGE:=MD10->CODIBGE
ELSE
   cBUSCA:=cUF+PEGCIDCONV(cUF,cCIDADE)
   dbselectar("MD10")
   dbgotop()
   if dbseek(cBUSCA)
      cIBGE:=MD10->CODIBGE
   endif     
endif
if ! empty(cALIAS)
   dbselectar(cALIAS)
ENDIF   
return cIBGE

FUNCTION IRRFIBGE(cBUSCA)
LOCAL cIBGE
LOCAL cALIAS
cIBGE:=""
cALIAS:=ALIAS()
dbselectar("MD10")
dbsetorder(5)
dbgotop()
if dbseek(cbUSCA)
  cIBGE:=MD10->CODIBGE
endif
IF ! EMPTY(cALIAS)
   dbselectar(cALIAS)
ENDIF   
return cIBGE

function coduf(cBUSCA,cTIPO) //ibge
local nPos:=0
local cRETU:="??"
LOCAL aUF,aIBGE

aUF    := { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", ;
            "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", ;
            "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO" ,"EX","XX"}

aIBGE:= { "12", "27", "13", "16", "29", "23", "53", "32", "52", ;
          "21", "31", "50", "51", "15", "25", "26", "22", "41", ;
          "33", "24", "11", "14", "43", "42", "28", "35", "17" ,"54","54"}


IF VALTYPE(cTIPO)<>"C"
   cTIPO:="UF"
ENDIF
//@ 23,00 SAY cBUSCA
//inkey(0)
IF cTIPO="UF" // codigo->Sigla uf
   IF LEN(cBUSCA)>2 //codigo ibge 7 digitos 2 primeiros estados
      cBUSCA:=SUBSTR(cBUSCA,1,2)
   ENDIF
   nPos:=ascan( aIBGE, cBUSCA )
   if nPos>0
      cRETU:=aUF[nPos] // retorna o codigo do Estado
   endif
ELSE    //sigla uf->codigo
   nPos:=ascan( aUF, cBUSCA )
   if nPos>0
      cRETU:=aIBGE[nPos] // retorna o codigo numerico do estado
   endif
ENDIF
Return cRETU


function tratanome(mNOME,lANSI,lACEN,lRANG)
LOCAL nPOS
IF VALTYPE(lANSI)<>"L"
   lANSI:=.F.
ENDIF
IF VALTYPE(lACEN)<>"L"
   lACEN:=.T.
ENDIF
IF VALTYPE(lRANG)<>"L"
   lACEN:=.F.
ENDIF

mNOME     := strtran( alltrim( mNOME ), "'", " " )    //tirar como d'agua d'olho
mNOME     := strtran( mNOME, "  ", " " )              //tirar os duplos espacos
mNOME     := strtran( mNOME, "-", " " )               //tirar os tracos
mNOME     := strtran( mNOME, "  ", " " )              //tirar os duplos espacos
IF lACEN
   mNOME     := TIRACE(mNOME)
ENDIF
mNOME     := strtran( mNOME, ".", " " )               //tirar os .
mNOME     := strtran( mNOME, ",", " " )               //tirar os ,
mNOME      :=STRTRAN(mNOME ,"&39;"," ")               //algum encode nao tratado 
mNOME     := strtran( mNOME, "  ", " " )              //tirar os duplos espacos
IF lANSI
   mNOME     :=win_ANSIToOEM(mNOME) //HB_ansitooem(mNOME)
ENDIF
mNOME     := ALLTRIM(UPPER(mNOME))
nPOS:=AT("(",mNOME)
IF nPOS>0
   mNOME:=SUBSTR(mNOME,1,nPOS-1)
ENDIF
IF lRANG //remove nao carateres numero e simbolos 
   mNOME:=RANGEREPL(chr(0),chr(31),mNOME," ")
   mNOME:=RANGEREPL(chr(127),chr(255),mNOME," ")
ENDIF
RETUrn mNOME
