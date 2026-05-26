CLASS sqlitetable INHERIT xSQLTable
METHOD init(cARQ,aCAMPOS) CLASS sqlitetable
LOCAL cARQCHAVE  AS STRING
LOCAL cARQSQLITE AS STRING
LOCAL oCONN AS SQLConnection
LOCAL cSQL AS STRING
LOCAL oSTATEMENT AS SQLStatement
cARQCHAVE:=cARQ+".DBF" //buscando com ponto .dbf para buscar na mesma chabe
cARQSQLITE:=PEGINIVAL(zCURINI,cARQCHAVE,"SQLITEARQ")
	oCONN := SQLConnection{"SQLite3", "", "" }
	oCONN:connect()
    IF oCONN:Connected
    	cSQL := "ATTACH DATABASE '"+ cARQSQLITE +"' AS "+cARQ
	    oSTATEMENT := SQLStatement{cSQL ,oCONN }
	    IF oSTATEMENT:Execute()
	      oSTATEMENT:FreeStmt( SQL_DROP  )
	      SUPER:INIT(cARQ,aCAMPOS,oCONN)
	    ENDIF
	ENDIF

RETURN SELF


METHOD INIT(cARQ) CLASS SqLiteSelect
LOCAL cARQCHAVE  AS STRING
LOCAL cARQSQLITE AS STRING
LOCAL oCONN AS SQLConnection
LOCAL cSQL AS STRING
LOCAL oSTATEMENT AS SQLStatement
cARQCHAVE:=cARQ+".DBF" //buscando com ponto .dbf para buscar na mesma chabe
cARQSQLITE:=PEGINIVAL(zCURINI,cARQCHAVE,"SQLITEARQ")
	oCONN := SQLConnection{"SQLite3", "", "" }
	oCONN:connect()
    IF oCONN:Connected
    	cSQL := "ATTACH DATABASE '"+ cARQSQLITE +"' AS "+cARQ
	    oSTATEMENT := SQLStatement{cSQL ,oCONN }
	    IF oSTATEMENT:Execute()
	      oSTATEMENT:FreeStmt( SQL_DROP  )
	      cSQL :=   "SELECT * FROM "+cARQ
	      SUPER:INIT(cSQL,oCONN)
	    ENDIF
	ENDIF

RETURN SELF
CLASS SqLiteSelect INHERIT xSQLSelect
TEXTBLOCK  exemplos

oSQLSELECT:= SQLITESELECT{"LCT"}
         oSQLSELECT:GOTOP()
	      WHILE ! oSQLSELECT:EoF
	     	   cVALOR:= oSQLSELECT:FIELDGET(1)
	      	   alert(cVALOR)
	      	   oSQLSELECT:Skip()
	      ENDDO


oSQLTABLE:= sqlitetable{"LCT",{"TIPO"}}
         oSQLTABLE:GOTOP()
	      WHILE ! oSQLTABLE:EoF
	     	   cVALOR:= oSQLTABLE:FIELDGET(1)
	      	   alert(cVALOR)
	      	   oSQLTABLE:Skip()
	      ENDDO

SqliteExec("LCT","DELETE FROM lct  WHERE tipo = 'XX';")
SqliteExec("LCT","INSERT INTO lct (tipo)  VALUES ( 'AX' );")

FUNCTION SqliteATTACH(cARQ)
LOCAL lRETU AS LOGIC
LOCAL oSTATEMENT AS SQLStatement
LOCAL cSQL AS STRING
LOCAL cARQCHAVE AS STRING
LOCAL cARQSQLITE AS STRING

cARQCHAVE:=cARQ+".DBF" //buscando com ponto .dbf para buscar na mesma chabe
cARQSQLITE:=PEGINIVAL(zCURINI,cARQCHAVE,"SQLITEARQ")
alert(cARQSQLITE)
lRETU:=.f.
    IF gLOoCONNECTION:Connected

    	cSQL := "ATTACH DATABASE '"+ cARQSQLITE +"' AS "+cARQ
	     oSTATEMENT := SQLStatement{cSQL ,GLOoCONNECTION }
	     IF oSTATEMENT:Execute()
	       oSTATEMENT:FreeStmt( SQL_DROP  )
	       lRETU:=.f.
         ENDIF


    ENDIF
RETURN lRETU


