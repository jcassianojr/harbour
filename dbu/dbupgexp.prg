request PGRDD
function PGexpformat()

PGSELECTTABLE()
LCOPIANAT:=.f. //MDG("Copia Nativa(SIM) Interna(NAO)") //copy to nao implemntado PGsqlrddd
tDOC:=pegtipodoc() // .t. Inclui dbf se for nativa
pegparexp() 
lDOCCAB  :=.F.
lDOCDAD  :=.F.
lDOCRECNO:=.F.
cSUBTIPO :=" "

PegcsUB(tDOC)  //pegar o subtipo conforme tipo

cDESTINO:=cTABELAX+"_PGsql."+zEXPOREXT
MDT(cDESTINO)

MDT("abrindo arquivo de origem: "+cTABELAX)

nConn := dbPGconnection( cSERVERX+";"+CdatabaseX+";"+CuserX+";"+CpassX+";5432;public" )
dbUseArea( .T.,"PGRDD" , "SELECT * FROM "+CHR(34)+cTABELAX+CHR(34), cTABELAX )
nLASTREC:=   lastrec() 
zei_fort( nLASTREC,,,0)
aSTRU:=PGstrudbf()
multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO),aSTRU)
dbcloseall()
dbpgclearconnection( nConn )

return nil


