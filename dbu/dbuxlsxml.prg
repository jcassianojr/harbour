#require "hbxlsxml"


PROCEDURE Fazerxlsxlm()
   LOCAL xml, sheet1
   LOCAL aSTRU
   LOCAL nFIELDS
   LOCAL nPOS
   LOCAL i
   
aSTRU:=DBStruct()
nFIELDS := Len( aSTRU )
nPOS    :=1

IF FILE( alias()+"_xls.xml")
  FERASE(alias()+"_xls.xml")
ENDIF

   xml := ExcelWriterXML():New( alias()+"_xls.xml" )

   sheet1 := xml:addSheet( alias() )

IF lDOCCAB
    for i:=1 to nfields
        cPOS:=CHR(64+I)+ALLTRIM(Str(nPOS, 8 , 0 ) )
        eval:=ALLTRIM(astru[I][1])+","+astru[I][2]
        IF astru[I][2]="C" .OR. astru[I][2]="N"
           eVAL+=","+ALLTRIM(STR(astru[I][3],8,0))
        ENDIF  
        IF astru[I][2]="N" 
           eVAL+=","+ALLTRIM(STR(astru[I][4],8,0))
        ENDIF   
        sheet1:writeString( nPOS, I, eval)
    next i
    nPOS++
ENDIF

IF lDOCDAD
    dbgotop()
    while .not. EOF()
       for i:=1 to nfields
           eVAL:=HB_FIELDGET(I)
           if .NOT. EMPTY(eVAL)
               /*
              METHOD writeFormula( dataType, row, column, xData, style )
              METHOD writeString( row, column, xData, style )
              METHOD writeNumber( row, column, xData, style )
              METHOD writeDateTime( row, column, xData, style )
               METHOD writeData( type, row, column, xData, style, formula )
            */
              do case
                 case valtype(eval)="C"
                      sheet1:writeString( nPOS, I, eval)
                 case valtype(eval)="D"
                      //sheet1:writeDateTime( nPOS, I, eval) gravava como data numerica
                      eVAL:=DTOC(eVAL)
                      sheet1:writeString( nPOS, I, eval)
                 case valtype(eval)="N"
                      sheet1:writeNumber( nPOS, I, eval)
                 case valtype(eval)="L"     
                      IF EVAL
                         sheet1:writeString( nPOS, I, "TRUE")
                      ELSE
                         sheet1:writeString( nPOS, I, "FALSE")
                      ENDIF
                      
              endcase
           endif
       next I
       nPOS++
       ZEI_FORT( nLASTREC,,, 1 )
       dbskip()
    ENDDO
ENDIF

   xml:writeData( alias()+"_xls.xml")

   RETURN
