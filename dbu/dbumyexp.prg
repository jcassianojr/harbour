request MYSQLRDD

function myexpformat()

MYSELECTTABLE()
LCOPIANAT:=.f. //MDG("Copia Nativa(SIM) Interna(NAO)") //copy to nao implemntado mysqlrddd
tDOC:=pegtipodoc() // .t. Inclui dbf se for nativa
pegparexp() 
lDOCCAB  :=.F.
lDOCDAD  :=.F.
lDOCRECNO:=.F.
cSUBTIPO :=" "

PegcsUB(tDOC)  //pegar o subtipo conforme tipo

cDESTINO:=cTABELAX+"_mysql."+zEXPOREXT
MDT(cDESTINO)

MDT("abrindo arquivo de origem: "+cTABELAX)

nConn := dbmysqlconnection( cSERVERX+";"+CdatabaseX+";"+CuserX+";"+CpassX+";3306" )
dbUseArea( .T.,"MYSQLRDD" , "SELECT * FROM "+cTABELAX, cTABELAX )

nLASTREC:=   lastrec() 
zei_fort( nLASTREC,,,0)

aSTRU:=mystrudbf()

multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO),aSTRU)

dbcloseall()
dbmysqlclearconnection( nConn )

return nil


