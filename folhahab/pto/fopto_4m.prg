*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4m.prg
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

cPM := "PM"+ANOMESW


CHECKCRI(cPM,"FO_PMAN","STR(NUMERO,8)+DTOS(DATOCO)+TIPOCO")


PADRAO(cPM,cPM,"' '+STR(mNUMERO,  8)+' '+DTOC(mDATOCO)+' '+STR(mHOROCO,5,2)+' '+STR(mHOROC2,5,2)+' '+STR(mHOROC3,5,2)+' '+STR(mHOROC4,5,2)+' '+mTIPOCO",;
 "STR(mNUMERO,8)+DTOS(mDATOCO)+mTIPOCO",;
 "FOPTO_4M - Correcoes de Marcacoes",;
 "Numero     Data    Cod ENT    ALM        SAI  T ",;
 {|| iFOPTO4m()},{|| tFOPTO4m()},{|| gFOPTO4m()},{|| ALLTRUE()},,2,,,zTIPVID)

retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function iFOPTO4m()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func iFOPTO4m


MDS("Digite o Numero e a data Tipo")
@ 24,40 get mNUMERO                                                       
@ 24,50 get mDATOCO                                                       
@ 24,60 get mTIPOCO valid !empty(mTIPOCO) .and. mTIPOCO $ "ES12TN"        
READCUR()
mCHAVE := str(mNUMERO,8)+dtos(mDATOCO)+mTIPOCO
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFOPTO4m()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func gFOPTO4m

verpassagens(mNUMERO,mDATOCO,.T.,.T.)
@  6,1  say mNUMERO picture '99999999'                                                                
@  6,10 say mDATOCO                                                                                   
@  6,28 say mTIPOCO                                                                                   
@  7,16 get mHOROCO picture '99.99'    when mTIPOCO = "T" .or. mTIPOCO = "E"                          
@  7,22 get mHOROC2 picture '99.99'    when mTIPOCO = "T" .or. mTIPOCO = "1"                          
@  7,30 get mHOROC3 picture '99.99'    when mTIPOCO = "T" .or. mTIPOCO = "2"                          
@  7,36 get mHOROC4 picture '99.99'    when mTIPOCO = "T" .or. mTIPOCO = "S" .or. mTIPOCO = "N"       
//@  7, 55 get mZERHOR when empty( mHOROCO ) valid mZERHOR $ "SN "
@ 12,10 get mMOTIVO VALID ALLTRUE(IF(EMPTY(mMOTOCO),mMOTOCO := OBTER("FOPTOMOT",,mMOTIVO,"NOME"),""))        
@ 13,6  get mMOTOCO valid !empty(mMOTOCO)                                                                    
READCUR()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFOPTO4m()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func tFOPTO4m


// Desenha a Tela
HB_SCROLL(2,0,23,79)
HB_dispbox(2,0,23,79,B_DOUBLE+" ")
@  5,1  say "Numero   Data    Cod Hora  T E-Entrada   1-Saida Refeicao    T-Todos"         
@  6,30 say "S-Saida     2-Retorno Refeicao    (S/N)"                                      
//@  7, 42 SAY "Zerar Horario  S/N"
@ 12,1 say "Motivo:"         
retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO_4M2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func FOPTO_4M2


CABE2("Lancamento Grupo Ajuste Horario")
cPM := "PM"+ANOWORK+strzero(mestrab,2)

CHECKCRI(cPM,"FO_PMAN","STR(NUMERO,8)+DTOS(DATOCO)+TIPOCO")
CRIARVARS(cPM)
MDS("Data")
@ 24,10 GET mDATOCO         
if !READCUR()
   retu .F.
endif
tFOPTO4m()
gFOPTO4m()

if !NETUSE(PES)
   retu
endif
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
FILTRO := FILTRO(FILTRO)
set filter to &FILTRO

if !NETUSE(cPM)
   dbcloseall()
   retu
endif
dbselectar(pes)
dbgotop()
while !eof()
   mNUMERO := NUMERO
   dbselectar(cPM)
   dbgotop()
   if !dbseek(str(mNUMERO,8)+dtos(mDATOCO)+mTIPOCO)
      netrecapp()
   endif
   REPLVARS()
   dbcommit()
   dbselectar(pes)
   dbskip()
enddo
dbcloseall()
//FOPTO_2I()

*+ EOF: fopto_4m.prg
*+
