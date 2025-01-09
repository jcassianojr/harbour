#INCLUDE "TRY.CH"

// function main()
 //SetMode( 25, 80 )
//   CLS   // necessario as vezes trava apos a mudanca para 25,80
// altd()
// sha_getrealdate() 
 
 

 FUNCTION sha_getrealdate(cLOCALZONE,lSilencioso)                                                                                                        


   LOCAL cLink                                                                                                                        

   LOCAL oWeb,cRespuesta                                                                                                                    

   LOCAL cLineaTxt   := ''                                                                                                                   

   LOCAL hHash       := {=>}                                                                                                                

   LOCAL aTemp       := {}                                                                                                                   

   LOCAL aDatos      := {}                                                                                                                  

   LOCAL nBucle1:=0, aLlaves                                                                                                                

   LOCAL cKey,cValue                                                                                                                         

   IF VALTYPE(lSilencioso)<>"L"
     lSilencioso:= .F.   
   ENDIF  
   
   IF VALTYPE(cLOCALZONE)<>"C"
      cLOCALZONE:= "America/Sao_Paulo"  
   ENDIF   
   
   cLink :=  "http://worldtimeapi.org/api/timezone/"+  cLOCALZONE       
   
   
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
                                                                                   

 oPg  := CreateObject( "Msxml2.XMLHTTP.6.0" )  
   oPg:Open( "GET", "http://worldtimeapi.org/api/timezone/America/Sao_Paulo", .F. )
   Inkey( 2 ) //aguarda um pouco evitar erro de coneccao
   oPg:Send()
   //Inkey( 2 )
   cXMl := oPg:ResponseBody
   oPG := NIL  


HB_JSONDECODE(cXML,@hHash)                                                                                           

           aLlaves := HGETKEYS(hHash)         // OBTIENE LAS CLAVES                                                                         

           FOR nBucle1:=1 TO LEN(aLlaves)                                                                                                    

               cKey   := aLlaves[nBucle1]                                                                                                   

               cValue := HGETVALUEAT(hHash,nBucle1)                                                                                          

               //cValue := HGET(hHash,cKey])                                                                                                

               AADD(aTemp,{cKey,cValue})  
                                                                                                                 

           NEXT                                                                                                                             
                                                                                                            
ALTD()

RETURN(aTEMP)   // IP PUBLICA, FECHA LOCAL, HORA LOCAL, DIA DE LA SEMANA, DIA DEL A¥O, TIMEZONE, FECHA UTC, HORA UTC, DIF. UTC, NRO. SEMANA
                                                                                                                         

                


/*
      TRY                                                                                                                                    

        oWeb:= WIN_OLECREATEOBJECT("MSXML2.ServerXmlHttp")    //WIN_OLECREATEOBJECT("MSXML2.ServerXmlHttp")     CreateObject( "Msxml2.XMLHTTP.6.0" )                                                                               

        IF HB_ISOBJECT(oWeb)                                                                                                                 


           oWeb:OPEN("GET",cLink,.F.)                                                                                                        

           oWeb:SEND()                                                                                                                      

                                                                                                                                             

           HB_JSONDECODE(oWeb:responseText,@hHash)                                                                                           

           aLlaves := HGETKEYS(hHash)         // OBTIENE LAS CLAVES                                                                         

           FOR nBucle1:=1 TO LEN(aLlaves)                                                                                                    

               cKey   := aLlaves[nBucle1]                                                                                                   

               cValue := HGETVALUEAT(hHash,nBucle1)                                                                                          

               //cValue := HGET(hHash,cKey])                                                                                                

               AADD(aTemp,{cKey,cValue})                                                                                                    

           NEXT                                                                                                                             

           FOR nBucle1:=1 TO LEN(aTemp)                                                                                                     

               DO CASE                                                                                                                       

                  CASE nBucle1==3 .OR. nBucle1==13                                                                                          

                       cStringFecha := aTemp[nBucle1,2]                                                                                      

                       AADD(aDatos,SUBSTR(cStringFecha,9,2)+'/'+SUBSTR(cStringFecha,6,2)+'/'+SUBSTR(cStringFecha,1,4))                      

                       AADD(aDatos,SUBSTR(cStringFecha,12,5))                                                                               

                  CASE nBucle1==2 .OR. nBucle1==4 .OR. nBucle1==5 .OR. nBucle1==11 .OR. nBucle1==14 .OR. nBucle1==15                        

                       AADD(aDatos,aTemp[nBucle1,2])                                                                                        

               ENDCASE                                                                                                                      

           NEXT                                                                                                                             

           oWeb := NIL                                                                                                                       

        ENDIF         

        IF !lSilencioso

             ALERT('IP PUBLICA: '+aDatos[1]+HB_OSNEWLINE()+'FECHA LOCAL REAL: '+aDatos[2]+HB_OSNEWLINE()+'HORA LOCAL REAL: '+aDatos[3],'HORA REAL') 

        ENDIF       

     CATCH                                                                                                                                  

        ALERT('Error de conexi½n o sitio web no disponible...'+HB_OSNEWLINE()+cLink,'CONSULTA HORA REAL')                                    

        aDatos := {}                                                                                                                        

     END                                                                                                                                     

RETURN(aDatos)   // IP PUBLICA, FECHA LOCAL, HORA LOCAL, DIA DE LA SEMANA, DIA DEL A¥O, TIMEZONE, FECHA UTC, HORA UTC, DIF. UTC, NRO. SEMANA

 */
 
