*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4l.prg
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

PEGPTOHOR("XX",.T.,.F.)   //Verifica indices

cPH := "PH"+ANOMESW


CHECKCRI(cPH,"FO_PHOR","STR(NUMERO,8)+DTOS(OCOINI)")

PADRAO(cPH,cPH,"' '+STR(mNUMERO,  8)+' '+DTOC(mOCOINI)+' '+DTOC(mOCOFIM)+' '+mOCOCOD","STR(mNUMERO,8)+DTOS(mOCOINI)",;
 "FOPTO_4L - Correcao de Horarios",;
 "Numero Horario",;
 {|| iFOPTO4L()},{|| tFOPTO4L()},{|| gFOPTO4L()},{|| ALLTRUE()},,2,,,zTIPVID)


//FOPTO_2J()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function iFOPTO4L()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func iFOPTO4L


MDS("Digite o Numero e a data Inicio")
@ 24,40 get mNUMERO         
@ 24,50 get mOCOINI         
READCUR()
mCHAVE := str(mNUMERO,8)+dtos(mOCOINI)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFOPTO4L()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func gFOPTO4L

verpassagens(mNUMERO,mOCOINI,.T.,.T.)
@  6,1  say mNUMERO                                                                                                       
@  6,10 say mOCOINI                                                                                                       
@  6,19 get mOCOFIM                                                                                                       
@  6,28 get mOCOCOD valid !empty(mOCOCOD) .AND. verseha("FOPTOHOR",2,mOCOCOD,"NOME","'Codigo nao Cadastrado'",.T.)        
@  7,10 get mMOTIVO VALID ALLTRUE(IF(EMPTY(mOCOMOT),mOCOMOT := OBTER("FOPTOMOT",,mMOTIVO,"NOME"),""))                     
@  8,1  get mOCOMOT valid !empty(mOCOMOT)                                                                                 
READCUR()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFOPTO4L()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func tFOPTO4L


// Desenha a Tela
HB_dispbox(4,0,23,79,B_DOUBLE+" ")
@  5,1 say "Numero   Inicio   Fim     Codigo"         
@  7,1 say "Motivo:"                                  
retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO_4L2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func FOPTO_4L2


CABE2("FOPTO_4L2 - Lancamento Grupo Troca Horario")


cPH := "PH"+ANOMESW
CHECKCRI(cPH,"FO_PHOR","STR(NUMERO,8)+DTOS(OCOINI)")


CRIARVARS(cPH)
tFOPTO4l()
@  6,10 get mOCOINI                              
@  6,19 get mOCOFIM                              
@  6,28 get mOCOCOD valid !empty(mOCOCOD)        
@  8,1  get mOCOMOT                              
if !READCUR()
   RETU .F.
ENDIF
//sele 1
if !NETUSE(PES)
   retu
endif
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
FILTRO := FILTRO(FILTRO)
set filter to &FILTRO
//sele 2
if !NETUSE(cPH)
   dbcloseall()
   retu
endif
sele 1
dbgotop()
while !eof()
   mNUMERO := NUMERO
   dbselectar(cPH)
   dbgotop()
   if !dbseek(str(mNUMERO,8)+dtos(mOCOINI))
      netrecapp()
   endif
   REPLVARS()
   dbcommit()
   dbselectar(pes)
   dbskip()
enddo
dbcloseall()



*+ EOF: fopto_4l.prg
*+
