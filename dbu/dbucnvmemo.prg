#include "ads.ch"
#include "dbinfo.ch"


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function convermemo
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function convertmemo()

aAMBIENTE:=SALVAA()
nOLDTIPO=TIPODBF

alertx("escolha origem")
nORITIPO:= tipodbfesc()
cORIDRIVER:=RDDNOME(nORITIPO)
cORIMEMO:=hb_rddInfo( RDDI_MEMOEXT)  //a extensao do origem memo do destino vem com ponto

alertx("escolha destino")
nDESTIPO:= tipodbfesc()
cDESDRIVER:=RDDNOME(nDESTIPO)
cDESMEMO:=hb_rddInfo( RDDI_MEMOEXT) //a extensao do rdiinfo memo do destino vem com ponto

cBUSCA:="*"+cORIMEMO
aARQMEMOS:=directory(cBUSCA) // ".FPT" a extensao do rdiinfo memo do destino vem com o ponto
IF LEN(aARQMEMOS)=0
   ALERTX("Sem arquivos: "+cORIMEMO)
   RESTAA(aAMBIENTE)
   TIPODBF:=nOLDTIPO
   RDDNOME(nOLDTIPO) //retorna tipo anterior
   RETURN .F.
ENDIF

FOR XY:=1 TO LEN(aARQMEMOS)

     cARQORIMEMO   := lower(aARQMEMOS[XY,1])
	 cARQORISEMEXT := tiraext(cARQORIMEMO)
	 
	 MDT("Fazendo copia de reserva: "+"old_"+cARQORISEMEXT)
	 filecopy(cARQORISEMEXT+".dbf"  ,"old_"+cARQORISEMEXT+".dbf")
	 filecopy(cARQORISEMEXT+cORIMEMO,"old_"+cARQORISEMEXT+cORIMEMO)
	 cOLDDBF :="old_"+cARQORISEMEXT
	 cNEWDBF :="new_"+cARQORISEMEXT
	 
     MDT("abrindo arquivo antigo: "+cOLDDBF)
      USE (cOLDDBF) ALIAS aliasantigo SHARED NEW VIA  (cORIDRIVER) //"DBFNTX" 	via driver antigo

    MDT("copiando estrutura")
    COPY STRUCTURE TO (cNEWDBF)              //criando a estrutura usa o rdddefauld destino ultimo atribuido
    IF file(cNEWDBF+".DBF") .AND. file(cNEWDBF+cDESMEMO) // ".FPT" a extensao do rdiinfo memo do destino
       MDT("copia efetuada:"+cNEWDBF+".DBF"+" "+cNEWDBF+cDESMEMO)
    ENDIF

    USE (cNEWDBF) ALIAS aliasnovo EXCLUSIVE NEW VIA (cDESDRIVER)  //abre a copia usa o rdddefauld destino ultimo atribuido

    MDT("Importando registros para: "+cNEWDBF)
    SELE ALIASNOVO
    
    nLASTREC:=NetRegCount(cOLDDBF)
    zei_fort( nLASTREC,,,0)
    
    APPEND FROM (cOLDDBF) VIA (cORIDRIVER)  while zei_fort(nLASTREC,,,1)  //"DBFNTX" 	via driver antigo

    DBCLOSEALL()
next xy	
RDDNOME(nOLDTIPO) //retorna tipo anterior
RESTAA(aAMBIENTE)

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function converttipo
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function converttipo()

aAMBIENTE:=SALVAA()
nOLDTIPO=TIPODBF

alertx("escolha origem")
nORITIPO:= tipodbfesc()
cORIDRIVER:=RDDNOME(nORITIPO)
cORIEXT := hb_rddInfo( RDDI_TABLEEXT)  //a extensao do rdiinfo memo do destino vem com ponto
cORIMEMO:= hb_rddInfo( RDDI_MEMOEXT)  //a extensao do origem memo do destino vem com ponto

alertx("escolha destino")
nDESTIPO:= tipodbfesc()
cDESDRIVER:=RDDNOME(nDESTIPO)
cDESEXT := hb_rddInfo( RDDI_TABLEEXT) //a extensao do rdiinfo memo do destino vem com ponto
cDESMEMO:= hb_rddInfo( RDDI_MEMOEXT) //a extensao do rdiinfo memo do destino vem com ponto


cBUSCA:="*"+cORIEXT //a extensao do rdiinfo memo do destino vem com ponto
aARQDBF:=directory(cBUSCA) 
IF LEN(aARQDBF)=0
   ALERTX("Sem arquivos para converter ")
   RESTAA(aAMBIENTE)
   TIPODBF:=nOLDTIPO
   RDDNOME(nOLDTIPO) //retorna tipo anterior
   RETURN .F.
ENDIF

FOR XY:=1 TO LEN(aARQDBF)

     cARQNOME    := lower(aARQDBF[XY,1])
	 cARQNOME   := tiraext(cARQNOME)
     cARQORI    := cARQNOME+cORIEXT
     cARQMEMO   := cARQNOME+cORIMEMO
     
	 
	 MDT("Fazendo copia de reserva: "+"old_"+cARQORI)
	 filecopy(cARQORI ,"old_"+cARQORI)
	 filecopy(cARQMEMO,"old_"+cARQMEMO)
     
	 cOLDDBF :="old_"+cARQNOME
	 cNEWDBF :="new_"+cARQNOME
	 
     MDT("abrindo arquivo antigo: "+cOLDDBF)
      USE (cOLDDBF) ALIAS aliasantigo SHARED NEW VIA  (cORIDRIVER) //	via driver antigo utiliza aliasantigo mas o driver defaiult e o destino

    MDT("copiando estrutura")
    COPY STRUCTURE TO (cNEWDBF)              //criando a estrutura usa o rdddefauld destino ultimo atribuido
    IF file(cNEWDBF+cDESEXT)                   
       MDT("copia efetuada:"+cNEWDBF+cDESEXT)

        USE (cNEWDBF) ALIAS aliasnovo EXCLUSIVE NEW VIA (cDESDRIVER)  //abre a copia usa o rdddefauld destino ultimo atribuido utiliza aliasnovo

        MDT("Importando registros para: "+cNEWDBF)
        SELE ALIASNOVO
        
        nLASTREC:=NetRegCount(cOLDDBF)
        zei_fort( nLASTREC,,,0)
        
        APPEND FROM (cOLDDBF) VIA (cORIDRIVER)  while zei_fort(nLASTREC,,,1)  //"	via driver antigo
    ENDIF

    DBCLOSEALL()
next xy	
TIPODBF:=nOLDTIPO
RDDNOME(nOLDTIPO) //retorna tipo anterior
RESTAA(aAMBIENTE)
