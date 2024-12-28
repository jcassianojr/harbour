*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4g.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+



//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

//Pegando Eventos
aEVED := {}
aEVEC := {}
aEVEB := {}
PegFeriados()


PEGPTOHOR("XX",.T.,.F.)   //Verifica indices

cPE := "PE"+ANOMESW
CHECKCRI(cPE,"FOPTOREV","GRUPO+DTOS(DATA)")

cANT := "PE"+right(STRZERO(nANOANT,4),2)+strzero(NMESANT,2)
CHECKCRI(cANT,"FOPTOREV","GRUPO+DTOS(DATA)")


PADRAO(cPE,cPE,"' '+mGRUPO+' '+STR(mHORARIO,8)+' '+DTOC(mDATA)+' '+PADR(CDIA(mDATA),8)+' '+mCODREV+' '+STR(mENTREV,  6, 2)+' '+STR(mALIREV,  6, 2)+' '+STR(mALSREV,  6, 2)+' '+STR(mSAIREV,  6, 2)","mGRUPO+DTOS(mDATA)",;
 "FOPTO_4G - Escala Revezamento",;
 "Gr Data     Horario",;
 {|| iFOPTO4G()},{|| tFOPTO4G()},{|| gFOPTO4G()},{|| ALLTRUE()},,2,,,zTIPVID)
retuRN .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function iFOPTO4G()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func iFOPTO4G

dINI   := zdataini
dFIM   := zdatafim
mGRUPO := "  "
//mCODREV:="  "
@ 23,00 clea
@ 24,00 clea
@ 23,00 say 'Digite o Codigo da Escala'         
@ 24,00 say 'Digite o Periodo '                 
@ 23,40 get mGRUPO                              
//@ 23, 60 get mCODREV WHEN EMPTY(mGRUPO)
@ 24,40 get dINI         
@ 24,50 get dFIM         
if !READCUR()
   retu .F.
endif

//if ! empty( mCODREV )
//   xFOPTO4G()
//endif

nSEQ := 1
mMAX := 0
if !NETUSE(cANT)
   retu aRETU
endif
dbgotop()
IF dbseek(mGRUPO+dtos(dINI - 1))
   nSEQ := SEQ
   nSEQ := nSEQ+1
ENDIF
dbclosearea()

mds("Confirme Sequencia Incial")
@ 24,40 get nSEQ         
READCUR()


if !netuse("escalpad")
   retu .f.
endif
dbgotop()
dbseek(mGRUPO)
WHILE mGRUPO = GRUPO .AND. !EOF()
   mMAX := mMAX+1
   DBSKIP()
ENDDO
dbclosearea()


//N„o Grava o ultimo por que a funcao padrao fara
for W := dINI to dFIM
   mDATA  := W
   mCHAVE := mGRUPO+dtos(mDATA)
   IF mMAX > 0
      IF nSEQ > mMAX
         nSEQ := 1
      ENDIF
      igualvars("ESCALPAD","ESCALPAD",mGRUPO+STR(nSEQ,2))
      xFOPTO4G()
      mSEQ := nSEQ  //gravo seq atual
      nSEQ := nSEQ+1  //pego mais 1 para a proxima
   ENDIF
   mDATA := W
   EscPadCor()
   IF W <> dfim   //dfim na funcao padrao
      if NOVOREG(cPE,cPE,mCHAVE)
         if VIDEO = 'S'
            aadd(aPAD1,NIL)
            aadd(aPAD2,NIL)
            POS  := len(aPAD1)
            POSW := 1
            if POS > 1
               for X := 1 to POS - 1
                  mDARE := aPAD2[X]
                  if mCHAVE <= mDARE  // IF mGRUPO+DTOS(DATA)<=mDARE
                     exit
                  endif
               next
               POSW := X
            endif
            ains(aPAD1,POSW)
            ains(aPAD2,POSW)
            aPAD1[POSW] = ' '+mGRUPO+' '+dtoc(mDATA)+' '+padr(CDIA(mDATA),8)+' '+mCODREV+' '+str(mENTREV,6,2)+' '+str(mALIREV,6,2)+' '+str(mALSREV,6,2)+' '+str(mSAIREV,6,2)
            aPAD2[POSW] = mGRUPO+dtos(mDATA)
            pPAD := POSW
         endif
      endif
   endif
next X
mDATA  := dFIM
mCHAVE := mGRUPO+dtos(dFIM)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFOPTO4G()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function gFOPTO4G

@  5,9  say mGRUPO         
@  5,19 say mDATA          
IF !EMPTY(mDATA)
   @  5,28 say CDIA(mDATA)         
ENDIF
@  6,9  get mSEQ                                                                        
@  8,12 get mCODREV  valid xFOPTO4G(.T.) .and. EscPadCor()                              
@  8,15 say mHORARIO                                                                    
@  8,25 say mENTREV  pict '999.99'                                                      
@  8,32 say mALIREV  pict '999.99'                                                      
@  8,39 say mALSREV  pict '999.99'                                                      
@  8,46 say mSAIREV  pict '999.99'                                                      
@  8,53 GET mVIRADA  pict "!"                              valid mVIRADA $ " SN"        
@  8,60 get mFOLGASN pict "!"                              valid mFOLGASN $ " SN"       
@  8,65 GET mCODADC                                                                     
@  8,72 get MBCOSN   pict "!"                              valid mBCOSN $ " SNF"        
READCUR()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFOPTO4G()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func tFOPTO4G

// Desenha a Tela
HB_dispbox(4,0,23,79,B_DOUBLE+" ")
@  5,2  say "Grupo:     Data:"                                                        
@  6,2  say "Seq"                                                                     
@  7,15 say "Horario   Entrada   Almo‡o     Saida Virada Folga CodAdc BcoHrs"         
@  8,2  say "Hor rio :"                                                               
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function xFOPTO4G()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
funcTION xFOPTO4G(lEXIBE)


local cDBFUSO := alias()
if valtype(lEXIBE) # "L"
   lEXIBE := .F.
endif
if empty(mCODREV)
   retu .T.
endif
aRETU := PEGPTOHOR(mCODREV)
IF aRETU[6]
   mENTREV  := aRETU[1]
   mALIREV  := aRETU[2]
   mALSREV  := aRETU[3]
   mSAIREV  := aRETU[4]
   mVIRADA  := aRETU[5]
   mFOLGASN := aRETU[7]
   mHORARIO := aRETU[8]
   if lEXIBE
      @  8,15 say mHORARIO                      
      @  8,25 say mENTREV  pict '999.99'        
      @  8,32 say mALIREV  pict '999.99'        
      @  8,39 say mALSREV  pict '999.99'        
      @  8,46 say mSAIREV  pict '999.99'        
      @  8,53 say mVIRADA                       
      @  8,60 say mFOLGASN                      
   endif
ENDIF
return .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function EscPadCor()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION EscPadCor()

DO CASE
CASE mCODREV = "SA" .AND. DOW(mDATA) <> 7
   ALERTX("Codigo SA sem ser sabado "+dtoc(mdata))
   mCODREV := ""
CASE mCODREV = "DO" .AND. DOW(mDATA) <> 1
   ALERTX(" Codigo DO sem ser domingo "+dtoc(mdata))
   mCODREV := ""
CASE mCODREV = "FE" .AND. ASCAN(aEVED,str(DAY(mDATA),2)+str(MONTH(mDATA),2)) = 0
   ALERTX(" Codigo FE sem feriado cadastrado "+dtoc(mdata))
   mCODREV := ""
ENDCASE
return .t.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PEGPTOHOR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func PEGPTOHOR(cCOD,lOPEN,lMES)


local aRETU := {0,0,0,0," ",.F.," ",0,""}
local cDBF  := alias()
//entrada almoco retorno saida virada
if empty(cCOD)
   retu aRETU
endif
if valtype(lOPEN) # "L"
   lOPEN := .T.
endif
if valtype(lMES) # "L"
   lMES := .T.
endif
if lOPEN
   if !netuse("foptohor")
      retu aRETU
   endif
else
   dbselectar("FOPTOHOR")
endif
if ordcount() < 2
   dbclosearea()
   FERASE("FOPTOHOR.CDX")   //Temporariarmente recriando
   INFOR("FOPTOHOR",{"NUMERO","CODIGO"},{"FOPTOHOR","FOPTOHOR"},.F.,{"FOPTOHOR","FOPTOHOR2"},.T.)
   if !netuse("foptohor")
      retu aRETU
   endif
endif
IF VALTYPE(cCOD) = "N"
   dbsetorder(1)  //Busca codigo numerico
ELSE
   dbsetorder(2)  //Busca codigo reduzido caracter
ENDIF
dbgotop()
if dbseek(cCOD)
   aRETU[ 1 ] := ENT
   aRETU[ 2 ] := ALMI
   aRETU[ 3 ] := ALMF
   aRETU[ 4 ] := SAI
   aRETU[ 5 ] := VIRADA
   aRETU[ 6 ] := .T.
   aRETU[ 7 ] := FOLGASN
   aRETU[ 8 ] := NUMERO
   aRETU[ 9 ] := CODIGO
endif
if lOPEN
   dbclosearea()
endif
if !aRETU[6] .and. lMES
   ALERTX("Ajuste de Horario: "+cCOD+" Nao Cadastrado")
endif
if !empty(cDBF)
   dbselectar(cDBF)
endif
retu aRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto4gpad()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func fopto4gpad

PADRAO("escalpad","escalpad","mGRUPO+' '+STR(mHORARIO,8)+' '+str(mSEQ,2)+' '+mCODREV+' '+STR(mENTREV,  6, 2)+' '+STR(mALIREV,  6, 2)+' '+STR(mALSREV,  6, 2)+' '+STR(mSAIREV,  6, 2)+' '+mFOLGASN","mGRUPO+STR(mSEQ,2)",;
 "FOPTO_4G - Cadastro de Escala Revezamento",;
 "Gr Seq Horario",;
 {|| iPTO4GPAD()},{|| tFOPTO4G()},{|| gFOPTO4G()},{|| ALLTRUE()},,2)



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto4gapa()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func fopto4gapa()

mESCALA := SPACE(2)
@ 24,00 SAY "Codigo da Escala"         
@ 24,40 get mESCALA                    
IF !READCUR()
   RETU
ENDIF
cPE := "PE"+ANOMESW
CHECKCRI(cPE,"FOPTOREV","GRUPO+DTOS(DATA)")
if !netuse(cPE)
   retu .f.
endif
dbgotop()
dbseek(mESCALA)
WHILE GRUPO = mESCALA .AND. !EOF()
   netrecdel()
   DBSKIP()
ENDDO
dbcloseall()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function iPTO4GPAD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
funcTION iPTO4GPAD

MDS('Digite o Codigo da Escala/Seq')
@ 24,40 get mGRUPO         
@ 24,44 get mSEQ           
READCUR()
mCHAVE := mGRUPO+STR(mSEQ,2)
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function horpadtoesc()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
funcTION horpadtoesc

CABE2('Horario Padrao Para Escala')
mHORPAD := "  "
mESCDES := "  "
mds("Horario Padrao:          Escala:")
@ 24,18 GET mHORPAD         
@ 24,34 GET mESCDES         
IF !READCUR()
   RETU .F.
ENDIF

if !NETUSE("FO_RELHR")
   dbcloseall()
   retu .F.
endif
dbgotop()
while !eof()
   IF HORREF = mHORPAD
      netreclock()
      FIELD->HORREF := ""
      FIELD->HFOL00 := "S"
      FIELD->GRUPO  := mESCDES
      DBUNLOCK()
   ENDIF
   DBSKIP()
enddo
dbcloseall()
return .t.







*+ EOF: fopto_4g.prg
*+
