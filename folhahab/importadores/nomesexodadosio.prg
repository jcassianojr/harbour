REQUEST DBTCDX
//REQUEST FPTCDX
//REQUEST SMTCDX

PROCEDURE Main()

//

//importa tabela grupos no dados.io do governo abrir oppenoffice deixar somente name,classifica,names salvar como dbf
rddsetdefault( "DBTCDX" )
use grupos2 new
use nomesexo new
index on NAME tag NOME
SETMODE(25,80)


  // dbCreate( "table1", { { "F1", "M", 4, 0 } }, "DBTCDX" )
  // dbCreate( "table2", { { "F1", "M", 4, 0 } }, "FPTCDX" )
  // dbCreate( "table3", { { "F1", "M", 4, 0 } }, "SMTCDX" )
  
  dbselectar("grupos2")
   while ! eof()
       cLINHA:=grupos2->NAMES
	    cCLASSIFICA:=grupos2->CLASSIFICA
	   ALTD()
       aNAMES:=HB_ATokens(CLINHA,"|")
	   AADD(ANAMES,grupos2->NAME)
	   FOR X:=1 TO LEN(ANAMES)
	       ? ANAMES[X]
		   @ 24,00 SAY RECNO()
		   @ 24,20 SAY ANAMES[X]
	       DBSELECTAR("NOMESEXO") 
		   DBGOTOP()
		   IF ! EMPTY(ANAMES[X])
			   IF ! DBSEEK(ANAMES[X]) 
				  DBAPPEND()
				  NOMESEXO->NAME:=ANAMES[X]
				  NOMESEXO->CLASSIFICA:=cCLASSIFICA
			   ENDIF
		   ENDIF	   
	   NEXT X
       dbselectar("grupos2")
	   DBSKIP()
   enddo
   RETURN
