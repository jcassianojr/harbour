
    /*
    cCONCREATE:=criaconcreate(cMDBARQ,cNOMETABELA)
    
    DO CASE
       CASE cTIPOSQL="SQLITE" .OR. cTIPOSQL="MYSQL" .OR. cTIPOSQL="MYSQL64" .OR. cTIPOSQL="MARIADB"  ;
            .OR. cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="ACCDB" .OR. cTIPOSQL="ACCDB64"  ;
            .OR. cTIPOSQL="PGSQL" .OR. cTIPOSQL="PGSQL64"
             //Abaixo com executacmd ja com estrutura ajustada pela funcao
       OTHERWISE
          dbCreate( cCONCREATE, aSTRU,"ADORDD" )
    ENDCASE
     */      


/*
   /*
   Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
   cCONCREATE:=criaconcreate(cARQORI,'table1')
   do case
      
      otherwise
         dbCreate( cCONCREATE, { ;
              { "FIRST",   "C", 10, 0 }, ;
              { "LAST",    "C", 10, 0 }, ;
              { "AGE",     "N",  8, 0 }, ;
              { "MYDATE",  "D",  8, 0 } }, "ADORDD" )
  endcase            
     Set( _SET_DATEFORMAT, "dd/mm/yyyy" )  
   */   

function criaconcreate(cMDBARQ,cNOMETABELA)
/* sequencia dos parametros adordd
 LOCAL cDataBase  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 1, ";" )
   LOCAL cTableName := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 2, ";" )
   LOCAL cDbEngine  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 3, ";" )
   LOCAL cServer    := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 4, ";" )
   LOCAL cUserName  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 5, ";" )
   LOCAL cPassword  := hb_tokenGet( aOpenInfo[ UR_OI_NAME ], 6, ";" )
*/
/*   
LOCAL cCONCREATE

   cCONCREATE:=cMDBARQ+";"+cNOMETABELA
    DO CASE
       CASE cTIPOSQL="MDB" .OR. cTIPOSQL="ACCESS" .OR. cTIPOSQL="MDB64" .OR. cTIPOSQL="ACCESS64"
            IF  loledb
                cCONCREATE:=cMDBARQ+";"+cNOMETABELA
            else
                cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";ACEOLEDB"
            endif
       CASE cTIPOSQL="ACCDB"  .OR. cTIPOSQL="ACCDB64" 
            cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";ACEOLEDB"
       CASE cTIPOSQL="SQLITE"  
            cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";SQLITE"
       CASE cTIPOSQL="MYSQL"  .OR. cTIPOSQL="MYSQL64"
           if loledb
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";MYSQL;"+cSERVERX+";"+CUSERX+";"+cPASSX
            else    
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";MYSQL64;"+cSERVERX+";"+CUSERX+";"+cPASSX
            endif   
       CASE cTIPOSQL="MARIADB"  
           cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";MARIADB;"+cSERVERX+";"+CUSERX+";"+cPASSX
       CASE cTIPOSQL="PGSQL"  .OR. cTIPOSQL="PGSQL64"
           if loledb
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";PGSQL;"+cSERVERX+";"+CUSERX+";"+cPASSX
            else    
               cCONCREATE:=cMDBARQ+";"+cNOMETABELA+";PGSQL64;"+cSERVERX+";"+CUSERX+";"+cPASSX
            endif            
    ENDCASE
RETURN cCONCREATE 
*/

