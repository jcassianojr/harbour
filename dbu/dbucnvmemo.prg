#include "dbinfo.ch"
function convertmemo()
nOLDTIPO=TIPODBF
alert("escolha origem")
tipodbfesc()
nORITIPO:=TIPODEF
cORIMEMO:=hb_rddInfo( RDDI_MEMOEXT)  //a extensao do origem memo do destino vem com ponto
cORIDRIVER:=RDDNOME(TIPODBF)
alert("escolha destino")
tipodbfesc()
nDESTIPO:=TIPODEF
cDESMEMO:=hb_rddInfo( RDDI_MEMOEXT) //a extensao do rdiinfo memo do destino vem com ponto
cDESDRIVER:=RDDNOME(TIPODBF)

aARQMEMOS:=ADIR("*"+cORIMEMO) // ".FPT" a extensao do rdiinfo memo do destino vem com o ponto

FOR XY:=1 TO LEN(aARQMEMOS)

     cARQORIMEMO   := lower(aARQMEMOS[XY,1])
	 cARQORISEMEXT := tiraext(cARQORIMEMO)
	 
	 ?? "Fazendo copia de reserva"
	 filecopy(cARQORISEMEXT+".dbf"  ,"old_"+cARQORISEMEXT+".dbf")
	 filecopy(cARQORISEMEXT+cORIMEMO,"old_"+cARQORISEMEXT+cORIMEMO)
	 cOLDDBF :="old_"+cARQORISEMEXT
	 cNEWDBF :="new_"+cARQORISEMEXT
	 
     ?? "abrindo arquivo antigo"
      USE (cOLDDBF) ALIAS aliasantigo SHARED NEW VIA  (cORIDRIVER) //"DBFNTX" 	via driver antigo

    ?? "copiando estrutura "
    COPY STRUCTURE TO (cNEWDBF)              //criando a estrutura usa o rdddefauld destino ultimo atribuido
    IF file(cNEWDBF+".DBF") .AND. file(cNEWDBF+cDESMEMO) // ".FPT" a extensao do rdiinfo memo do destino
       ?? "copia efetuada"
    ENDIF

    USE (cNEWDBF) ALIAS aliasnovo EXCLUSIVE NEW VIA (cDESDRIVER)  //abre a copia usa o rdddefauld destino ultimo atribuido

    ??  "Importando registros para"
    SELE ALIASNOVO
    
    nLASTREC:=NetRegCount(cOLDDBF)
    zei_fort( nLASTREC,,,0)
    
    APPEND FROM (cOLDDBF) VIA (cORIDRIVER)  while zei_fort(nLASTREC,,,1)  //"DBFNTX" 	via driver antigo

    DBCLOSEALL()
next xy	


RDDNOME(nOLDTIPO) //retorna tipo anterior

