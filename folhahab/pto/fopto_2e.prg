*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_2e.prg
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
*+    Documentado em 27-Dez-2024 as  9:32 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


CABE2('FOPTO_2E - Transferir Totais Para a Folha')
CX := array(24)
LF := chr(13)+chr(10)

aCODCTA := PEGCX()
aTR     := PEGCX("T")

if !NETUSE("FOPTOCON")
   retu .F.
endif
if !dbseek(nremp)
   dbgotop()
endif
cARQUIVO := alltrim(CAMINEX)
eFORMULA := alltrim(EXPORTA)
dbcloseall()

cPT := "PT"+ANOMESW


if !NETUSE(PES)
   retu
endif
FILTRO := "EMPTY(DEMITIDO)"
FI     := trim(FILTRO)
FILTRO := FILTRO(FI)
set filter to &FILTRO
INITVARS()
CLRVARS()


if !NETUSE(cPT)
   retu
endif

nHANDLE := fcreate(cARQUIVO)
IF FERROR() # 0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF


dbselectar(PES)
dbgotop()
while !eof()
   PETELA(8)
   EQUVARS()
   //Anlise feita com arquivo pes pois checar tipo horista/mensalista entre outros na macro
   afill(CX,0)
   for X := 1 to 24
      cVAR := aCODCTA[X]
      if !empty(&cVAR.)
         CX[X] = &CVAR
      endif
   next X
   dbselectar(cPT)
   dbgotop()
   if dbseek(mNUMERO)
      HX := {CTA01,CTA02,CTA03,CTA04,CTA05,CTA06,CTA07,CTA08,;
       CTA09,CTA10,CTA11,CTA12,CTA13,CTA14,CTA15,CTA16,;
       CTA17,CTA18,CTA19,CTA20,CTA21,CTA22,CTA23,CTA24}
      VX := {VAL01,VAL02,VAL03,VAL04,VAL05,VAL06,VAL07,VAL08,;
       VAL09,VAL10,VAL11,VAL12,VAL13,VAL14,VAL15,VAL16,;
       VAL17,VAL18,VAL19,VAL20,VAL21,VAL22,VAL23,VAL24}
      for X := 1 to 24
         if HX[X] # 0 .and. aTR[X] # "N"
            fwrite(nHANDLE,&eFORMULA)
         endif
      next X
   endif
   dbselectar(PES)
   dbskip()
enddo
dbcloseall()
fwrite(nHANDLE,chr(26))
fclose(nHANDLE)
if MDG("Deseja Imprimir o arquivo Gerado")
   IMPARQ(cARQUIVO)
endif


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function STRHOR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func STRHOR(nVAL,nPOS,nDEC)


local cRETVAL := 0
cRETVAL := strtran(strzero(nVAL,nPOS,nDEC),".","")
retu cRETVAL


*+ EOF: fopto_2e.prg
*+
