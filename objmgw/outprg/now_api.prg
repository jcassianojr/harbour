FUNCTION sha_getrealdate(cSERVICO)                                                                                                                                                                                                                                                                                                                              
   #DEFINE CRLF CHR(13)+CHR(10)                                                                                                                                                                                                                               
   LOCAL cLink := ''                                                                                                                                                                                                                                          
   LOCAL oWeb,oErr,cRespuesta                                                                                                                                                                                                                                 
   LOCAL cLineaTxt   := ''                                                                                                                                                                                                                                    
   LOCAL hHash       := {=>}                                                                                                                                                                                                                                  
   LOCAL aTemp       := {}                                                                                                                                                                                                                                    
   LOCAL aDatos      := {}                                                                                                                                                                                                                                    
   LOCAL nBucle1:=0, aLlaves                                                                                                                                                                                                                                  
   LOCAL cKey,cValue                                                                                                                                                                                                                                          
   ALTD()                                                                                                                                                                                                                                                     
   DEFAULT lSilencioso TO .F.                                                                                                                                                                                                                                 
      //TRY                                                                                                                                                                                                                                                   
        oWeb:=WIN_OLECREATEOBJECT("MSXML2.XmlHttp.6.0")                                                                                                                                                                                                       
        //oWeb:=WIN_OLECREATEOBJECT("MSXML2.XmlHttp")                                                                                                                                                                                                         
        //oWeb:=WIN_OLECREATEOBJECT("microsoft.XmlHttp")                                                                                                                                                                                                      
        IF HB_ISOBJECT(oWeb)     
           SELECT CASE
                  CASE cSERVICO="TIMEAPI.IO"                                                                                                                                                                                                                       
                        cLink := "https://timeapi.io/api/time/current/zone?timeZone=America/Sao_Paulo"
                  OTHERWISE
                        cLink := "http://worldtimeapi.org/api/timezone/America/Sao_Paulo"
           ENDCASE
 
  /*
   
   
   https://worldtimeapi.org/
   # curl "http://worldtimeapi.org/api/timezone/America/Sao_Paulo"
   https://worldtimeapi.org/api/timezone/america/argentina/buenos_aires"  

{
  "utc_offset": "-03:00",
  "timezone": "America/Sao_Paulo",
  "day_of_week": 2,
  "day_of_year": 7,
  "datetime": "2025-01-07T08:50:43.893702-03:00",
  "utc_datetime": "2025-01-07T11:50:43.893702+00:00",
  "unixtime": 1736250643,
  "raw_offset": -10800,
  "week_number": 2,
  "dst": false,
  "abbreviation": "-03",
  "dst_offset": 0,
  "dst_from": null,
  "dst_until": null,
  "client_ip": "2804:bdc:1f41:4780:1932:f6e9:b418:36a8"
}
   */
 
 /*
 
            cLink := "https://timeapi.io/api/time/current/zone?timeZone=America/Argentina/Buenos_Aires"  
           //https://timeapi.io/api/timezone/availabletimezones   
 {
  "year": 2025,
  "month": 1,
  "day": 9,
  "hour": 19,
  "minute": 58,
  "seconds": 31,
  "milliSeconds": 354,
  "dateTime": "2025-01-09T19:58:31.3545607",
  "date": "01/09/2025",
  "time": "19:58",
  "timeZone": "America/Sao_Paulo",
  "dayOfWeek": "Thursday",
  "dstActive": false
}
      */     
           
           //cLink := "http://worldtimeapi.org/api/timezone/America/Sao_Paulo"      
           
                                                                                                                                                       
           oWeb:OPEN("GET",cLink,.F.)                                                                                                                                                                                                                         
           oWeb:SEND()                                                                                                                                                                                                                                        
           DO WHILE oWeb:readyState<>4                                                                                                                                                                                                                        
              HB_IDLESLEEP(1)                                                                                                                                                                                                                                 
           ENDDO                                                                                                                                                                                                                                              
           IF !(oWeb:status>=200 .OR. oWeb:status<=299)                                                                                                                                                                                                       
              RETURN({"error"=>{"message"=>oWeb:responseText,"status"=>ALLTRIM(STR(oWeb:status))}})                                                                                                                                                           
           ENDIF                                                                                                                                                                                                                                              
           HB_JSONDECODE(oWeb:responseText,@hHash)                                                                                                                                                                                                            
           aLlaves := HGETKEYS(hHash)         // OBTIENE LAS CLAVES                                                                                                                                                                                           
           FOR nBucle1:=1 TO LEN(aLlaves)                                                                                                                                                                                                                     
               cKey   := aLlaves[nBucle1]                                                                                                                                                                                                                     
               cValue := HGETVALUEAT(hHash,nBucle1)                                                                                                                                                                                                           
               //cValue := HGET(hHash,cKey])                                                                                                                                                                                                                  
               AADD(aTemp,{cKey,cValue})                                                                                                                                                                                                                      
           NEXT         
           //retorna aTemp(chave,valor) pois dependendo da api as chaves sao diferentes                                                                                                                                                                                                                                      
           //FOR nBucle1:=1 TO LEN(aTemp)                                                                                                                                                                                                                       
           //    DO CASE                                                                                                                                                                                                                                        
           //       CASE nBucle1==8                                                                                                                                                                                                                             
           //            cStringFecha := aTemp[nBucle1,2]                                                                                                                                                                                                       
          //             AADD(aDatos,SUBSTR(cStringFecha,9,2)+'/'+SUBSTR(cStringFecha,6,2)+'/'+SUBSTR(cStringFecha,1,4))                                                                                                                                        
           //       CASE nBucle1==10 .OR. nBucle1==11 .OR. nBucle1==12                                                                                                                                                                                          
           //            AADD(aDatos,aTemp[nBucle1,2])                                                                                                                                                                                                          
            //   ENDCASE                                                                                                                                                                                                                                        
           //NEXT                                                                                                                                                                                                                                               
           oWeb := NIL                                                                                                                                                                                                                                        
        ENDIF
//        IF .not. lSilencioso                                                                                                                                                                                                                                       
//             MSGBOX('FECHA LOCAL REAL: '+aDatos[1]+CRLF+'HORA LOCAL REAL: '+aDatos[2],'HORA REAL')                                                                                                                                                            
//        ENDIF
     //CATCH oErr                                                                                                                                                                                                                                             
     //   MSGBOX(CSTR(oErr:gencode)+CRLF+CSTR(oErr:subcode)+CRLF+oErr:operation+CRLF+oErr:subsystem+CRLF+oErr:description)                                                                                                                                    
     //   //MSGEXCLAMATION('Error de conexi½n o sitio web no disponible...'+CRLF+cLink,'CONSULTA HORA REAL')                                                                                                                                                  
     //   aDatos := {}                                                                                                                                                                                                                                        
     //   RELEASE oWeb                                                                                                                                                                                                                                        
     //END                                                                                                                                                                                                                                                    
RETURN(atemo)   // PARA TIMEAPI.IO: FECHA LOCAL, HORA LOCAL, TIME ZONE, DIA DE LA SEMANA                                                                                                                                            

