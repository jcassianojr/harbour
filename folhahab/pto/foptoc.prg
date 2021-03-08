*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTOC.PRG
*+
*+    Functions: Function CHECKCRI()
*+               Function pegrelogio()
*+               Function PARQDIO()
*+               Function TARQREL()
*+               Function pegarqcon()
*+               pegfolga()
*+               peghorfix()
*+               pegequip()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

////#INCLUDE "COMANDO.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CHECKCRI()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function CHECKCRI( cARQ, cORI, eCHA, eCH2 )
local cPAD,cCAM,aESTRU
if ! REDEfile(  cARQ , ".DBF",.F. ).OR.! REDEfile(  cARQ , ".CDX" ,.F.)
   cPAD=OBTER( "FOPTONTX",,cORI,"PAD",,,,,,"S")
   cCAM:=""
   DO case
          CASE cPAD="S"
               cCAM:=ZDIRE
          CASE cPAD="A"
               cCAM:=ZDIRN
          CASE cPAD="I"     
               cCAM:=PEGCAMINI(cORI)     
   ENDCASE
   if ! REDEfile(cARQ , ".DBF" ,.F.)
       if ! NETUSE(cORI,,,,,.F.,)
          return
       endif
       aESTRU := dbstruct()
       dbclosearea()
       dbcreate( cCAM+ cARQ, aESTRU )
   ENDIF
   if ! REDEfile( cARQ , ".CDX",.F. )
       if valtype( eCH2 ) = "C"
          INFOR( cARQ, eCHA, cCAM + cARQ + "1" ,,cARQ+"1")
          INFOR( cARQ, eCH2, cCAM + cARQ + "2" ,,cARQ+"2")
       else
          INFOR( cARQ, eCHA, cCAM + cARQ ,,cARQ)
       endif
  endif
endif

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function pegrelogio()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function pegrelogio
LOCAL nARQ:=0
WHILE nARQ=0
    nARQ=ESCOLHEXI( "FOPTOREL", 0, "' '+STR(NUMERO,8)+' '+NOME", "NUMERO")
ENDDO
return nARQ

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function pegequip()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function pegequip(cFILTRO)
LOCAL nARQ:=0
WHILE nARQ=0
    nARQ=ESCOLHEXI( "FOPTOEQP", 0, "' '+STR(NUMERO,8)+' '+NOME", "NUMERO",cFILTRO)
ENDDO
return nARQ


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function PARQDIO()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function PARQDIO( nARQ )

if valtype( nARQ ) # "N"
   nARQ := PEGRELOGIO()
endif
return TARQREL( nARQ, .F., "D" )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function TARQREL()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func TARQREL( nTIPO, lPER, cTIPO )

local cARQ := "ERRO"
if valtype( lPER ) # "L"
   lPER := .T.
endif
if valtype( cTIPO ) # "C"
   cTIPO := " "
endif
if ! netuse("foptorel")
   return cARQ
endif
IF ! dbseek(nTIPO)
   dbclosearea()
   retu cARQ
endif
do case
case cTIPO = "D"    //Dio
   do case
   case DESTINO="P" //folha ponto (D)
      cARQ := "PD"
   case DESTINO="R" //refeitorio (A)Lmoco
      cARQ := "PA"
   case DESTINO="A"
      cARQ := "PP" //aesso (P)ortaria
   endcase
    cARQ += ANOMESW
otherwise
   if if( lPER, MDG( "Arquivo de Backup" ), .T. )
      do case
      case DESTINO="P" //folha ponto (D)
         cARQ := "D"
      case DESTINO="R" //refeitorio (A)lmoco
         cARQ := "A"
      case DESTINO="A"
         cARQ := "P" //acesso (P)ortaria
      endcase
      cARQ += ANOMESW
   else
      dbclosearea()
      cARQ := pegarqcon( nTIPO, "DBFMIG" )
      retu carq
   endif
endcase
dbclosearea()
return cARQ

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function pegarqcon()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function pegarqcon( nTIPO, cTIPO )
local cARQ := "ERRO"
if ! netuse("FOPTOREL")
   retu cARQ
endif
IF ! dbseek(nTIPO)
   dbclosearea()
   return cARQ
endif
do case
    case cTIPO = "PRO"
         cARQ:=PROCESSO
    case cTIPO = "CAM"
         cARQ:=CAMINHO         
    case cTIPO = "DBFMIG"
         cARQ:= ARQDEST
    case cTIPO = "TXT"
         cARQ:= ARQUIVO
         if at( ".", cARQ ) = 0
            cARQ += ".TXT"
         endif
//    case cTIPO = "NEX"
//         cARQ:=CAMINEX
//    case cTIPO = "NER"
//         cARQ:=CAMINER
//    case cTIPO = "ANO"
//         cARQ:=ANOREL
//    case cTIPO = "DIV"
//         cARQ := if( HORADEC = "S", .T., .F. )
endcase
dbcloseall()
return cARQ

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function peghorfix()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

FUNCTION PEGHORFIX(mNUMERO)
aFOLGA   := { "N", "N", "N", "N", "N", "N", "N" }
aREF     := { { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, ;  //Horario Normal
              { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, ;
              { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, ;
              { 0, 0, 0, 0 }, { 0, 0, 0, 0 } }
aNHOR    :=   { 0, 0, 0, 0, 0, 0, 0, 0 }

dbselectar( "FO_RELHR" )
dbgotop()
IF dbseek( mNUMERO )
   lREVESAR := if( HFOL00 = "S", .T., .F. )
   mGRUPO := GRUPO        //Codigo da Escala
   mTURNO := HFOL00       //Escala S/N
   mHORREF:= HORREF       //Codigo do Horario Fixo
   dDATAREF1:=DATAREF1
   mALMOCO := ALMOCO
   mMARMES := MARMES
   mMARALM := MARALM
   IF mTURNO="N"          //nao tem escala pega fixo
      dbselectar("FOPTOHRE")
      dbgotop()
      if dbseek(mHORREF)
         aFOLGA   := { HFOL01, HFOL02, HFOL03, HFOL04, HFOL05, HFOL06, HFOL07 }
         aREF     := { { HENT01, HALS01, HALE01, HSAI01 }, { HENT02, HALS02, HALE02, HSAI02 }, ;
                       { HENT03, HALS03, HALE03, HSAI03 }, { HENT04, HALS04, HALE04, HSAI04 }, ;
                       { HENT05, HALS05, HALE05, HSAI05 }, { HENT06, HALS06, HALE06, HSAI06 }, ;
                       { HENT07, HALS07, HALE07, HSAI07 }, { HENT, HALS, HALE, HSAI } }
         aNHOR    :=   { HOR01, HOR02, HOR03, HOR04, HOR05, HOR06, HOR07,HOR }
      endif
   ENDIF
endif
return


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function pegfolga()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

FUNCtion PEGFOLGA(cCOD)
LOCAL lRETU
lRETU:=.F.
IF ccod="FE".or.cCod="FO".or.cCOD="SA".or.cCOD="DO".or.cCOD="BH"
   lRETU:=.T.
ENDIF
RETURN lRETU

*+ EOF: FOPTOC.PRG
