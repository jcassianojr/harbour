#include "dbinfo.ch"
function convertmemo()

aAMBIENTE:=SALVAA()
nOLDTIPO=TIPODBF
alert("escolha origem")
tipodbfesc()
nORITIPO:=TIPODBF
cORIMEMO:=hb_rddInfo( RDDI_MEMOEXT)  //a extensao do origem memo do destino vem com ponto
cORIDRIVER:=RDDNOME(TIPODBF)
alert("escolha destino")
tipodbfesc()
nDESTIPO:=TIPODBF
cDESMEMO:=hb_rddInfo( RDDI_MEMOEXT) //a extensao do rdiinfo memo do destino vem com ponto
cDESDRIVER:=RDDNOME(TIPODBF)

cBUSCA:="*"+cORIMEMO
ALTD()
aARQMEMOS:=directory(cBUSCA) // ".FPT" a extensao do rdiinfo memo do destino vem com o ponto
IF LEN(aARQMEMOS)=0
   ALERTX("Sem arquivos: "+cORIMEMO)
   RESTAA(aAMBIENTE)
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
