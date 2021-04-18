#include "dbinfo.ch"

**************************
function dBUsincdbf()

aAMBIENTE:=SALVAA()
nOLDTIPO=TIPODBF

alert("escolha origem")
tipodbfesc()
nORITIPO:=TIPODBF
cORIDRIVER:=RDDNOME(TIPODBF)
cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )

alert("escolha destino")
tipodbfesc()
nDESTIPO:=TIPODBF
cDESDRIVER:=RDDNOME(TIPODBF)
cARQDES:=win_GetOpenFileName(, "Arquivos de Destino",HB_CWD(), "Arquivos de Destino", "*.dbf", 1 )
lAPAGA:=MDG("Apagar Dados do Arquivo de Destino")
lREPL :=.F.
IF lAPAGA
   IF ! MDG("Deseja Realmente apagar dados da destino")
      lAPAGA:=.F.
   ENDIF
ENDIF
IF ! lAPAGA
    lREPL :=MDG("Complentar campos em Branco")
ENDIF 
 
MDT("Fazendo copia de reserva: "+"old_"+cARQDES)
filecopy(cARQDES ,trocaext(cARQDES,"_old.dbf"))

	 
MDT("abrindo arquivo de origen: "+cARQORI)
USE (cARQORI) ALIAS ORIGEM SHARED NEW VIA  (cORIDRIVER) 

MDT("abrindo arquivo de destino: "+cARQDES)
USE (cARQDES) ALIAS DESTINO EXCLUSIVE NEW VIA (cDESDRIVER) 


MDT("Importando registros para: "+cARQDES)
DBSELECTAR("ORIGEM")
INITVARS()
CLRVARS()

DBSELECTAR("DESTINO")
INITVARS()
CLRVARS()
IF lAPAGA
   ZAP
ENDIF
dbsetorder(1)
cCHAVE:=INDEXKEY()
//alert(ccHAVE)

DBSELECTAR("ORIGEM")
nLASTREC := lastrec()
zei_fort(nLASTREC,,,0)
DBGOTOP()
WHILE ! EOF()
   EQUVARS()
   xBUSCA:=&CCHAVE.
   DBSELECTAR("DESTINO")
   dbgotop()
   IF DBSEEK(xBUSCA)
      dbappend()
      REPLVARS( .T. , .T.)
   ELSE
      IF lREPL
         REPLVARS( .T. , .T.) 
      ENDIF   
   ENDIF
   DBSELECTAR("ORIGEM")
   DBSKIP()
   ZEI_FORT(nLASTREC,,,1)
ENDDO
FREEVARS()
DBCLOSEALL()
	
RDDNOME(nOLDTIPO) //retorna tipo anterior
RESTAA(aAMBIENTE)
alert("sincronizado")

*************************
function limparegdupdbf()

aAMBIENTE:=SALVAA()
nOLDTIPO=TIPODBF

alert("escolha origem")
tipodbfesc()
nORITIPO:=TIPODBF
cORIDRIVER:=RDDNOME(TIPODBF)
cARQORI:=win_GetOpenFileName(, "Arquivos de Origem",HB_CWD(), "Arquivos de Origem", "*.dbf", 1 )

lPACK:=MDG("Fazer pack(remove registros marcados para apagar) apos a checagem")
 
MDT("Fazendo copia de reserva: "+"old_"+cARQORI)
filecopy(cARQORI ,trocaext(cARQORI,"_old.dbf"))
	 
MDT("abrindo arquivo de origem: "+cARQORI)
USE (cARQORI) ALIAS ORIGEM EXCLUSIVE NEW VIA  (cORIDRIVER) 

MDT("Limpando Registro Duplicados: ")
DBSELECTAR("ORIGEM")
dbsetorder(1)
cCHAVE   :=INDEXKEY()
nLASTREC := lastrec()
zei_fort(nLASTREC,,,0)
DBGOTOP()
WHILE ! EOF()
   xCHAVEANTERIOR:=&CCHAVE.
   DBSKIP()
   ZEI_FORT(nLASTREC,,,1)
   IF ! EOF()
      xCHAVEATUAL:=&CCHAVE.
      IF xCHAVEANTERIOR==xCHAVEATUAL
         dbdelete()
      ENDIF
   ENDIF
ENDDO
MDT("Fazendo pack(removendo registros marcados para apagar)")
IF lPACK
   PACK
ENDIF
DBCLOSEALL()
	
RDDNOME(nOLDTIPO) //retorna tipo anterior
RESTAA(aAMBIENTE)
alert("chaves duplicadas removidas")