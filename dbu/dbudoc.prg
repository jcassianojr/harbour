*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Source Module => DBUDOC.PRG
*+
*+    Functions: Function GERADOC()
*+               Function multidocs()
*+               Function multidocg()
*+               Function FAZERDBF()
*+               Function GRAVADOC()
*+               Function TIPOC()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

#INCLUDE "BOX.CH"
#include "dbinfo.ch"
#include "dbstruct.ch"

FUNCTION PEGTIPO2VAL()
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   DBGOTOP()
   WHILE ! EOF()
      FOR X=1 TO nFIELDS
          @ 3,40 SAY PADR(aESTRU[X][1])
          nVAL:=FIELDGET(X)
          IF aESTRU[X][2]="N"
             IF nVAL>aVAL[X]
                aVAL[X]:=nVAL
             ENDIF
          ENDIF
          IF aESTRU[X][2]="C"
             nVAL:=LEN(ALLTRIM(nVAL))
             IF nVAL>aVAL[X]
                aVAL[X]:=nVAL
             ENDIF
          ENDIF
      NEXT X
      ZEI_FORT(nLASTREC,,,1)
      DBSKIP()
   ENDDO
RETURN

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function GERADOC()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
funcTION GERADOC( tdoc )

local stru_name
local stru_base
//local aESTRU usada na pegval2 nao pode ser local
//local nFIELDS usada na pegval2 nao pode ser local
local stru_nome
local cTEXTO
lDOCCAB:=.F.
lDOCDAD:=.F.
lDOCRECNO:=.F.
cSUBTIPO:=" "
if empty( M->cur_dbf )
   retu .F.
endif

IF tDOC=0
  tdoc := pegtipodoc()
  if tdoc=0
     return .f.
  endif
  IF tDOC=5 //parametros da exportacao
      pegparexp()
  ENDIF
ENDIF


stat_msg( "Lendo Estrutura do Arquivo" )
stru_name := M->cur_dbf
stru_base := substr( stru_name, 1, at( ".", stru_name ) - 1 )
if rat( "\", STRU_BASE ) > 0
   STRU_BASE := substr( STRU_BASE, rat( "\", STRU_BASE ) + 1 )
endif
select( M->cur_area )
aESTRU := dbstruct()
nFIELDS:=LEN(aESTRU)
AVAL:=ARRAY(nFIELDS)
AFILL(aVAL,0)
IF tDOC=2 //Verificando o tamanho utilizado por cada campo
   PEGTIPO2VAL()
ENDIF
PegcsUB(tDOC)
GRAVADOC( tdoc, stru_base, aESTRU,aVAL,lDOCCAB,lDOCDAD,cSUBTIPO,lDOCRECNO )
stat_msg( "Documentacao Gerada" )



*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function PegcsUB()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*
Function PegcsUB(tDOC)
if tDOC = 7
   lDOCDAD:=MDG("Gravar Dados")
   IF MDG("Tipo DATAPACKET(S) TIPO ISO-8859-1(N)")
      cSUBTIPO:="PCK"
   ELSE
      cSUBTIPO:="ISO"
   ENDIF
endif
IF  tDOC = 5 .OR.  tDOC = 6
   lDOCCAB:=MDG("Gravar Informacao Estrutura")
   lDOCDAD:=MDG("Gravar Dados")
   IF lDOCDAD      
      lDOCRECNO:=MDG("Incluir Recno()/ID")
   ENDIF   
   IF ZEXPOREXT="XLS" .AND. tDOC = 5
      nCHOICE:=ALERTX( "Tipo XML", {"TAB","TRH-HTML","TDB"})
      DO CASE
         CASE nCHOICE=1
              cSUBTIPO:="TAB"
         CASE nCHOICE=2
              cSUBTIPO:="TRH"
         CASE nCHOICE=3
              cSUBTIPO:="TDB"
      ENDCASE
   ENDIF
   IF ZEXPOREXT="SQL" .AND. tDOC = 5
      cSUBTIPO:="SQL"
   ENDIF
ELSE
   lDOCCAB:=.T.
ENDIF
IF  tDOC = 8
   lDOCDAD:= .T.
   lDOCRECNO:=.F. //A id do recno ja faz parte do json
ENDIF


*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function multidocs()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
funcTION multidocs
para tDOC,cMASK           //Passara outra funcao manter aqui para ficar como priv
IF valtype(cMASK)#"C"
   cMASK:="*.DBF"
endif

IF tDOC=0
  tdoc := pegtipodoc()
  if tdoc=0
     return .f.
  endif
ENDIF
IF tDOC=5 //parametros da exportacao
    pegparexp()
ENDIF
lDOCCAB  :=.F.
lDOCDAD  :=.F.
lDOCRECNO:=.F.
cSUBTIPO :=" "
PegcsUB(tDOC)  //pegar o subtipo conforme tipo
if tdoc=1
   FAZERDBF( {|| dbf2xml() }, .F. ,,,cMASK)
else
   FAZERDBF( {|| multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO) }, .F.,,,cMASK )
endif   
stat_msg( "Documentacao Gerada" )

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function multidocg()
*+
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
funcTION multidocg(lDOCCAB,lDOCDAD,lDOCRECNO,cSUBTIPO,cARQDIC)
aESTRU  := dbstruct()
IF VALTYPE(cARQDIC)<>"C" //memvar->ARQUIVO public do dbu melhorar posteriormente para sempre pegar paramentro cARQDIC
   cARQDIC:=TIRAEXT(memvar->ARQUIVO) 
ENDIF   
aVAL:=ARRAY(LEN(aESTRU))
AFILL(aVAL,0)
nFIELDS:=LEN(aESTRU)
IF tDOC=2 //Verificando o tamanho utilizado por cada campo
   PEGTIPO2VAL()
ENDIF
GRAVADOC( tdoc,cARQDIC, aESTRU ,aVAL,lDOCCAB,lDOCDAD,cSUBTIPO,lDOCRECNO )

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function FAZERDBF()
*+
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function FAZERDBF( bUSO, lSHARE ,bPRE,bPOS,cMASK)
LOCAL cCAMMASK  :=SPACE(100)

IF VALTYPE(cMASK)#"C"
    cMASK:="*.DBF"
ENDIF

IF AT("\",cMASK)>0  //o mascara tem caminho
   hb_FNameSplit(cMASK , @cCAMMASK, NIL, NIL )
ENDIF
cCAMMASK:=ALLTRIM(cCAMMASK)   

MATDBF := FILENAMES( cMASK )
nARQ   := len( MATDBF )
if nARQ > 0
   for w := 1 to nARQ
      ARQUIVO := alltrim( MATDBF[ w ] )
      IF Valtype(bPRE)="B"
           EVAL(bPRE)
      ENDIF
      IF Valtype(bUSO)="B"
          if file( cCAMMASK+ARQUIVO )
            MDS("Arquivo: "+cCAMMASK+ARQUIVO)
            DBUREDE( cCAMMASK+ARQUIVO,, lSHARE )
            nLASTREC:=LASTREC()
            zei_fort( nLASTREC,,,0)
            eval( bUSO,, {|| zei_fort(nLASTREC,,,1)} )
            dbclosearea()
         endif
      endif
      IF Valtype(bPOS)="B"
           EVAL(bPOS)
      ENDIF
   next w
endif
MDS("")

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function GRAVADOC()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
funcTION GRAVADOC( tdoc, cARQ, aESTRU ,aVAL,lDOCCAB,lDOCDAD,cSUBTIPO,lDOCRECNO )
LOCAL cARQGRV:=cARQ
local cLIN := hb_osnewline() //chr( 13 ) + chr( 10 )
LOCAL cVAL
LOCAL cCAMPO
LOCAL J,nIndexes
LOCAL cINDEXNAME

IF tDOC=0
  tdoc := pegtipodoc()
  if tdoc=0
     return .f.
  endif
  IF tDOC=5 //parametros da exportacao
      pegparexp()
  ENDIF
  PegcsUB(tDOC)  //pegar o subtipo conforme tipo
ENDIF

if tdoc=1
   Dbf2Xml()
   return .t.
endif

IF zEXPOREXT="XML" .AND. tDOC = 5
   tDOC := 7
ENDIF

IF zEXPOREXT="JSON" 
   tDOC := 8
ENDIF


do case
  //  case tDOC = 1 //acima dbf2xml
	case tDOC = 2
	   cARQGRV += ".TAM"
	case tDOC = 3
	   cARQGRV += ".TEC"
	case tDOC = 4
	   cARQGRV += ".DBE"
	case tDOC = 5  .OR. zEXPOREXT="SQL" .OR. zEXPOREXT="SSV" .OR. zEXPOREXT="CSV" ;
                   .OR. zEXPOREXT="UNL" .OR. zEXPOREXT="TSV" .OR. zEXPOREXT="PSV"
	   cARQGRV += "."+ZEXPOREXT
	case tDOC = 6
	   cARQGRV += ".SDF"
	case tDOC = 7
	   cARQGRV += ".XML"
	case tDOC = 8
	   cARQGRV += ".JSON"   
endcase
if file( cARQGRV )
   ferase( cARQGRV )
endif

nFIELDS := len( aESTRU )
cTEXTO  := ""
if nFIELDS = 0
   stat_msg( "Nao exitem campos na area selecionada" )
   return .f.
endif
if tDOC = 4
   cTEXTO += 'DBFDEF ' + cARQ + cLIN
endif
if tDOC = 3 .OR. tDOC=2
   cTEXTO += '+-----------------------------------------------------------------------------+' + cLIN
   cTEXTO += '| Arquivo          : ' + padr( cARQ, 57 ) + '|' + cLIN
   cTEXTO += '| Atualizado em    : ' + padr( lupdate(), 57 ) + '|' + cLIN
   cTEXTO += '| No.de Registros  : ' + padr( str( lastrec(), 8, 0 ), 57 ) + '|' + cLIN
   cTEXTO += '| No.de Campos     : ' + padr( str( fcount(), 8, 0 ), 57 ) + '|' + cLIN
   cTEXTO += '| Tamanho Registro : ' + padr( str( recsize(), 8, 0 ), 57 ) + '|' + cLIN
   cTEXTO += '|-----+------------+----------+-----+----+------------------------------------|' + cLIN
   cTEXTO += '| No. | Nome Campo | Tipo     | Com | De | Observacoes                        |' + cLIN
   cTEXTO += '|-----+------------+----------+-----+----+------------------------------------+' + cLIN
endif
IF tDOC= 7 .AND. cSUBTIPO="PCK"
  cTEXTO += "<?xml version="+chr(34)+"1.0"+chr(34)+" standalone="+chr(34)+"yes"+chr(34)+"?>" + cLIN
  cTEXTO += "<DATAPACKET Version="+chr(34)+"2.0"+chr(34)+">"+cLIN
  cTEXTO += "<METADATA>" + cLIN
  cTEXTO += "   <FIELDS>" + cLIN
ENDIF
IF tDOC= 7 .AND. cSUBTIPO="ISO"
   cTEXTO := '<?xml version="1.0" encoding="ISO-8859-1"?>' + cLIN
   cTEXTO += "<DataRoot>" + cLIN
   cTEXTO += "<Estrutura>" + cLIN
ENDIF
If tDOC= 5 .AND. cSUBTIPO="TRH"
   cTEXTO += "<html>" + cLIN
   cTEXTO += "<body>" + cLIN
   cTEXTO += "<table border="+chr(34)+"1"+chr(34)+">" + cLIN
   cTEXTO += "<!-- cabecalho com os nomes dos campos da tabela -->" + cLIN
   cTEXTO += "<tr>" + cLIN
ENDIF
If tDOC= 5 .AND. cSUBTIPO="TDB"
   nHANDLEDOC := xlsOpen(cARQGRV)
ENDIF


if lDOCCAB
   for MEMVAR->x := 1 to nFIELDS      //aqui menvar evitar confusao dbf que tem o campo X
      cCAMPO:=aESTRU[ X, 1 ]
      do case
          case tDOC = 3  .OR. tDOC=2
             cOBS:=SPACE(35)
             IF tDOC=2 .AND. aVAL[X]>0
                cOBS:=padr(STRZERO(aVAL[X]),35)
             ENDIF
             cTEXTO += '| ' + str( X, 3 ) + ' | ' + ;
                                   padr( cCAMPO, 10 ) + ' | ' + ;
                                   TIPOC( aESTRU[ X, 2 ] ) + ' | ' + ;
                                   str( aESTRU[ X, 3 ], 3 ) + ' | ' + ;
                                   str( aESTRU[ X, 4 ], 2 ) + ' | ' + ;
                                   cOBS+'|' + cLIN
          case tDOC = 4
             cTEXTO += '   ' + padr( cCAMPO, 10 ) + ' ' + ;
                                     aESTRU[ X, 2 ] + ' ' + ;
                                     str( aESTRU[ X, 3 ], 3 ) + ' ' + ;
                                     str( aESTRU[ X, 4 ], 2 ) + cLIN
          case tDOC = 5 .AND. cSUBTIPO<>"TRH" .AND. cSUBTIPO<>"TDB"  .AND. cSUBTIPO<>"SQL"
             IF lDOCDAD
                cTEXTO +=  alltrim(cCAMPO) + ZDELIMITE //clin no final
             ELSE
                cTEXTO += padr( cCAMPO, 10 ) + ZDELIMITE + ;
                             aESTRU[ X, 2 ] + ZDELIMITE + ;
                             str( aESTRU[ X, 3 ], 3 ) + ZDELIMITE + ;
                             str( aESTRU[ X, 4 ], 2 ) + cLIN
            ENDIF
          case tDOC = 5 .AND. cSUBTIPO="TRH"
               cTEXTO+="<th nowrap>"+alltrim(cCAMPO)+"</th>"+cLIN
          case tDOC = 5 .AND. cSUBTIPO="TDB"
               xlsWrite(nHANDLEDOC , 1, X,alltrim(cCAMPO) )
          case tDOC = 6 
             IF lDOCDAD
                cTEXTO +=  alltrim(cCAMPO) + " " //+ cLIN //So nome do campo
             else
                cTEXTO += padr( cCAMPO, 10 ) + ' ' + ;
                             aESTRU[ X, 2 ] + ' ' + ;
                             str( aESTRU[ X, 3 ], 3 ) + ' ' + ;
                             str( aESTRU[ X, 4 ], 2 ) + cLIN
             endif
          case tDOC = 7 .AND. cSUBTIPO="PCK"  //             <FIELD attrname="Descricao" fieldtype="string" WIDTH="10"/>
              cTEXTO += "   <FIELD attrname="+CHR(34)+ALLTRIM(cCAMPO)+CHR(34)
              cTEXTO +=" fieldtype="
              cTEXTO += CHR(34)+TIPOXML(aESTRU[X,2],aESTRU[X,3],aESTRU[X,4])+CHR(34)
              IF aESTRU[X,2]="C"
                 cTEXTO+=" WIDTH="+CHR(34)+ALLTRIM(str(aESTRU[X,3],3))+CHR(34)
              ENDIF
              IF aESTRU[X,2]="M"
                 cTEXTO+=" WIDTH="+CHR(34)+ALLTRIM(str(255))+CHR(34)
              ENDIF
              cTEXTO += "/>"+cLIN
          case tDOC = 7 .AND. cSUBTIPO="ISO"
             cTEXTO += "<Campo>" + CLIN
             cTEXTO += "<Nome>"    +ALLTRIM(cCAMPO)+          "</Nome>" + CLIN
             cTEXTO += "<Tipo>"    +aESTRU[X][2]+             "</Tipo>" + CLIN
             cTEXTO += "<Tamanho>" +LTrim(Str(aESTRU[X][3]))+ "</Tamanho>" + CLIN
             cTEXTO += "<Decimal>" +LTrim(Str(aESTRU[X][4]))+ "</Decimal>" + CLIN
             cTEXTO += "</Campo>" + CLIN

             cTEXTO += "<Indice>" + cLIN
             cTEXTO += "<Chave>" +StrTran((IndexKey()), "+", "</Chave>"+CLIN+"<Chave>")+ "</Chave>" + cLIN
             cTEXTO += "</Indice>" + cLIN
             
               aUSO:=DBSTRUCT()
              //select case ZANOFOR="SQLITE" criar conforme o tipo sql difere datatypes
              //
              DO CASE
                 CASE ZANOFOR="SQLITE"
                      cTEXTO:=SqliteCreateTable(cARQ,aUSO)
                 OTHERWISE
                        cTEXTO:="CREATE TABLE "+cARQ+HB_OSNEWLINE()
                        cTEXTO+=" ("
                        FOR K=1 TO LEN(aUSO)
                            cTEXTO+=alltrim(aUSO[K][DBS_NAME])+" " //1
                             DO CASE
                                 CASE aUSO[K][DBS_TYPE]="C"
                                      IF aUSO[K][DBS_LEN]=254
                                        cTEXTO+="VARCHAR (512)"
                                      ELSE
                                        cTEXTO+="VARCHAR ("+ALLTRIM(STR(aUSO[K][DBS_LEN]))+")"
                                      ENDIF  
                                 CASE aUSO[K][DBS_TYPE]="D"
                                      cTEXTO+="SMALLDATETIME"
                                 CASE aUSO[K][DBS_TYPE]="N"                           
                                       cTEXTO+="DECIMAL ("+ALLTRIM(STR(aUSO[K][DBS_LEN]))+","+ALLTRIM(STR(aUSO[K][DBS_DEC]))+")"                                
                             ENDCASE
                             IF K<>LEN(aUSO)
                                cTEXTO+=" ,"+HB_OSNEWLINE() 
                             ENDIF    
                       NEXT K
                      cTEXTO+=") ; "  + cLIN  
               ENDCASE               
                            
               nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
               FOR j = 1 TO  nIndexes
                  //CREATE INDEX idx_student_name ON Students (name); 
                  cINDEXNAME := dbORDERINFO( DBOI_NAME , ,  j )
                  cINDEXNAME := StrTran(cINDEXNAME, "-", "_"  )  //Tracos nao aceitos trocando por undescore
                   cSQLINDEX:="create index " + cINDEXNAME + " on " + cARQ + " ( "+MDPCHAVEI(dbORDERINFO( DBOI_EXPRESSION , ,  j )) + " ) ;"
                   //DbOrderInfo( <nDefine> , <cIndexFile> , <nOrder_or_cIndexName> , <xNewSetting> ) -> xCurrentSetting
                   //AAdd( aNtxNames ,  dbORDERINFO( DBOI_NAME , ,  j )+" - "+dbORDERINFO( DBOI_EXPRESSION , ,  j ) )
                   cTEXTO+=cSQLINDEX+HB_OSNEWLINE() 
               NEXT j
                          
                       
      endcase
   next x
ENDIF   
If tDOC= 5 .AND. cSUBTIPO="TRH"
   cTEXTO += "</tr>" + cLIN
ENDIF
if tDOC = 7 .AND. cSUBTIPO="PCK"
  cTEXTO +="  </FIELDS>" + cLIN
  cTEXTO +="</METADATA>" + cLIN
   cTEXTO+="<ROWDATA>" + cLIN
ENDIF
IF tDOC= 7 .AND. cSUBTIPO="ISO"
  cTEXTO += "</Estrutura>" + cLIN
  cTEXTO += "<Dados>" + cLIN
ENDIF

if tDOC = 5 .AND. lDOCCAB .AND. cSUBTIPO<>"TRH" .AND. cSUBTIPO<>"TDB"
  cTEXTO += cLIN
endif
if tDOC = 6
  cTEXTO += cLIN
ENDIF

If tDOC= 5 .AND. cSUBTIPO="TDB" //ja aberto em cima
ELSE
   nHANDLEDOC:=FCREATE( cARQGRV)
   IF LEN(cTEXTO)>0
      FWRITE(nHANDLEDOC, cTEXTO )
   ENDIF
ENDIF

IF tDOC=8
   hRecords := { => }
ENDIF

cTEXTO:=""

if tDOC = 3  .OR. tDOC=2
   cTEXTO += '+-----+------------+----------+-----+----+------------------------------------+' + cLIN
endif
if tDOC = 4
   cTEXTO += 'ENDDEF' + cLIN
   cTEXTO += 'ENDFILE' + cLIN
endif

IF lDOCDAD
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   nXLS:=0
   DBGOTOP()
   WHILE ! EOF()
       IF tDOC = 5 .AND. lDOCRECNO
          cTEXTO:=alltrim(STR(RECNO()))+ZDELIMITE
       ELSE
          cTEXTO:=""
       ENDIF   
       nXLS++
       DO CASE
          CASE tDOC = 7 .AND. cSUBTIPO="PCK"
               cTEXTO+="<ROW RowState="+CHR(34)+"12"+CHR(34)
          CASE tDOC= 5 .AND. cSUBTIPO="TRH"
               cTEXTO+="<tr>"         +cLIN
          CASE tDOC = 7 .AND. cSUBTIPO="ISO"
               cTEXTO += "<Registro>" + cLin
          CASE zEXPOREXT="SQL"
               cTEXTO += "insert into " + alias() + " values ("
       ENDCASE
       
	   IF tDOC=8
		  hRecord := { => }
          cTEXTO:=""    //zerando estava gerando acumlando os campos anteriores
	   endif	  
	   
       FOR X=1 TO nFIELDS
          cCAMPO:=aESTRU[ X, 1 ]
          IF tDOC = 7 .AND. cSUBTIPO="PCK"
             cTEXTO+=" "+ALLTRIM(cCAMPO)+"="+CHR(34)
          ENDIF
          If tDOC= 5 .AND. cSUBTIPO="TRH"
             cTEXTO+="<td align="+CHR(34)+"right"+CHR(34)+">"
          ENDIF
          IF tDOC = 7 .AND. cSUBTIPO="ISO"
             cTEXTO+="<"+cCAMPO+">"
          ENDIF

          @ 3,40 SAY alltrim(PADR(cCAMPO))
          nVAL:=FIELDGET(X)
          IF aESTRU[X][2]="M"
              nVAL:=STRTRAN(nVAL,CHR(13)+CHR(10)," ")
          ENDIF
          DO CASE
              //
              // String ou memo
              //
              CASE aESTRU[X][2]="C" .OR. aESTRU[X][2]="M" 
                   nVAL:=ALLTRIM(STRVAL(nVAL))
                   DO CASE
                      CASE zCNVCHAR="O"
                          nVAL:=win_ANSIToOEM(nVAL) //HB_ansitooem(nVAL)
                      CASE zCNVCHAR="A"
                          nVAL:=win_oemtoansi(nVAL) //hb_oemtoansi(nVAL)
                   ENDCASE
                      DO CASE
                         CASE tDOC = 7 //xml
                              cTEXTO+=str2html(nVAL)
                         CASE zEXPOREXT="SQL"
                             cTEXTO+="'"+nVAL+"'" //sql string recenbem aspas simples
                         CASE zEXPOREXT="DLM" .AND. (zREGSEP=chr(34) .OR. zREGSEP=chr(39))    //dlm que char recebem aspas ou dupla aspas
                              cTEXTO+=zREGSEP+nVAL+ZREGSEP
                         OTHERWISE
                             cTEXTO+=nVAL
                      ENDCASE
              //
              // Data
              //                 
              CASE aESTRU[X][2]="D"
                   IF EMPTY(nVAL)
                      cTEXTO+=""
                   ELSE                      
                      cTEXTO+=DATA2STR(nVAL,ZANOFOR,ZANOSEP,ZANOTAM)
                   ENDIF
              //
              // Data
              //                           
              CASE aESTRU[X][2]="L"
                   cTEXTO+=logic2str(nval,0,0,zSEPLOGIC)
              //
              // Numerico
              //     
              CASE aESTRU[X][2]="N"
                   cTEXTO+=ALLTRIM(STRVAL(nVAL,aESTRU[X][3],aESTRU[X][4],ZDECSIM))
          ENDCASE
          DO CASE
             CASE tDOC = 7 .AND. cSUBTIPO="PCK"
                  cTEXTO+=CHR(34)
             CASE tDOC= 5 .AND. cSUBTIPO="TRH"
                  cTEXTO+="</td>"+CHR(13)+CHR(10)
             CASE tDOC= 5 .AND. cSUBTIPO="TDB"
                  xlsWrite( nHANDLEDOC, nXLS, X, cTEXTO )
                  cTEXTO:=""
             CASE ((tDOC=5 .AND. cSUBTIPO="TAB").or.tDOC=6)
                  IF X<>nFIELDS
                     cTEXTO+=ZDELIMITE
                  ENDIF
             CASE tDOC = 7 .AND. cSUBTIPO="ISO"
                  cTEXTO+="</"+cCAMPO+">" + cLIN
			 case Tdoc= 8
                  hb_HSet(hRecord, FieldName(x), Ctexto )//FieldGet(nField)) // for each record, hrecord holds a hash of column name: column value		
                  cTEXTO:=""	 				  
            OTHERWISE
                  IF X<>nFIELDS  //O Ultimo campo nao recebe delimitador
                     Ctexto+=Zdelimite
                  endif
          ENDCASE
       NEXT X
       DO CASE
          CASE tDOC = 7 .AND. cSUBTIPO="PCK"
               cTEXTO+="/>"+cLIN
          CASE tDOC=6
               cTEXTO+=cLIN
          CASE tDOC= 5 .AND. cSUBTIPO="TRH"
              cTEXTO+="</tr>"+cLIN
          CASE tDOC = 7 .AND. cSUBTIPO="ISO"
               cTEXTO += "</Registro>" + cLIN
          CASE zEXPOREXT="SQL"
               cTEXTO += ") ; " + cLIN               
	      case Tdoc=8	
               //Abaixo	   
          OTHERWISE
               cTEXTO += cLIN
       ENDCASE
       do case 
	      case tDOC= 5 .AND. cSUBTIPO="TDB" //ja aberto em cima
		  case tdoc=8 
		       hb_HSet(hRecords, LTRIM(STR(nxls)), hRecord) // like so, a hash of recno: hash of columns/values of this record  RecNo() usa nxls para ficar sequencial
		  otherwise        
			FWRITE(nHANDLEDOC, cTEXTO )
       ENDcase
       cTEXTO:=""
       ZEI_FORT(nLASTREC,,,1)
       DBSKIP()
   ENDDO
ENDIF
if tDOC = 7 .AND. cSUBTIPO="PCK"
   cTEXTO+="</ROWDATA>" + cLIN
   cTEXTO +="</DATAPACKET>" + cLIN
ENDIF
if tDOC = 7 .AND. cSUBTIPO="ISO"
   cTEXTO += "</Dados>" + cLIN
   cTEXTO+= "</DataRoot>"+cLIN
endif
If tDOC= 5 .AND. cSUBTIPO="TRH"
  cTEXTO+="</table>"+cLIN
  cTEXTO+="</body>"+cLIN
  cTEXTO+="</html>"+cLIN
ENDIF
IF LEN(cTEXTO)>0
   If tDOC= 5 .AND. cSUBTIPO="TDB" //ja aberto em cima
   ELSE
      FWRITE(nHANDLEDOC, cTEXTO )
   ENDIF
ENDIF
if tDOC=8
   fSeek(nHandledoc, 0, 2)
   fWrite(nHandledoc, hb_jsonEncode( hRecords, .T. ))
endif
If tDOC= 5 .AND. cSUBTIPO="TDB" //ja aberto em cima
   xlsClose( nHANDLEDOC )
ELSE
   FCLOSE(nHANDLEDOC )
ENDIF
retu .T.

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function TIPOC()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
func TIPOC( cTIPO )

local cRETU := ""
do case
case cTIPO = 'C'
   cRETU := 'Caracter'
case cTIPO = 'N'
   cRETU := 'Numerico'
case cTIPO = 'L'
   cRETU := 'Logico  '
case cTIPO = 'D'
   cRETU := 'Data    '
case cTIPO = 'M'
   cRETU := 'Memo    '
endcase
retu cRETU

func TIPOXML( cTIPO,nTAM,nDEC )

local cRETU := ""
do case
case cTIPO = 'C'
   cRETU := 'string'
case cTIPO = 'N'
   IF nDEC=0
      cRETU := 'i4' //+alltrim(str(ntam))
   ELSE
      cRETU := 'r8' //'float'
   ENDIF
case cTIPO = 'L'
   cRETU := 'boolean'
case cTIPO = 'D'
   cRETU := 'date'  //datetime
case cTIPO = 'M'
   cRETU := 'string'
endcase
return cRETU


function dbuzap()
zap
return .t.

function dbupack()
pack
return .t.

FUNCTION DBETODBF(cMASK,lLAY,lCRIA)
IF VALTYPE(cMASK)#"C"
    cMASK:="*.DBF"
ENDIF
IF VALTYPE(lLAY)#"L"
   lLAY:=.T.
ENDIF
IF VALTYPE(lCRIA)#"L"
   lCRIA:=.F.
ENDIF
MATDBF=FILENAMES(cMASK)
nARQ=LEN(MATDBF)
IF nARQ>0
   FOR X=1 TO nARQ
      cARQDIC=TIRAEXT(MATDBF[X],'DBE')
      IF file(cARQDIC)
          @ 24,00 SAY "Atualizando arquivo "+MATDBF[X]
          CLSCOR()
          MAKEDBF(cARQDIC,,lCRIA,RDDNOME(TIPODBF))
      ENDIF
   NEXT X
ENDIF
IF lLAY
   LAYOUT()
ENDIF
RETU .T.


/*
XML Schema :
<DataRoot>
   <Estrutura>
      <Campo>
        <Nome></Nome>
        <Tipo></Tipo>
        <Tamanho></Tamanho>
        <Decimal></Decimal>
      </Campo>
   </Estrutura>
   <Indice>
      <Chave></Chave>
   </Indice>
   <Dados>
      <Registro>
        <#Nome do campo#></#Nome do campo#>
      </Registro>
   </Dados>
</DataRoot>
*/

*+ EOF: DBUDOC.PRG
