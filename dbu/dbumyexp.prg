request MYSQLRDD
function myexpformat()

MYSELECTTABLE()
LCOPIANAT:=.f. //MDG("Copia Nativa(SIM) Interna(NAO)") //copy to nao implemntado mysqlrddd
tDOC:=pegtipodoc(lCOPIANAT) // .t. Inclui dbf se for nativa
if tDOC<>14 //dbf nao precisa adcional 
   pegparexp() 
else
   mdt("Use Opcao exportar dbf")
   return .f.
endif   
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

//Fazer melhorais na tipagem
//atmp1:=dbstruct()
//Atmp2:=DBMYSTRU()
//altd()
aSTRU:=mystrudbf()


  IF lCOPIANAT
     COPYTO(cDESTINO)
  ELSE
     multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,TIRAEXT(cDESTINO),aSTRU)
  ENDIF   

dbcloseall()
dbmysqlclearconnection( nConn )

return nil


