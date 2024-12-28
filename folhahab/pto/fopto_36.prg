*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_36.prg
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


////#INCLUDE "COMANDO.CH"

CABE3('FOPTO_3 - Relatórios - Pontos e Totais',23)

cMESANO := ANOMESW
cPN     := "PN"+ANOMESW
cPT     := "PT"+ANOMESW
cPD     := "PD"+ANOMESW
cPP     := "PP"+ANOMESW
cPA     := "PA"+ANOMESW
FO21CRI("PD","FO_DIO","STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)")
FO21CRI("PA","FO_DIO","STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)")
FO21CRI("PP","FO_DIO","STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)")
FO21CRI("PN","FO_PON","STR(NUMERO,8)+DTOS(DATA)")
FO21CRI("PT","FO_POT","NUMERO")




cIMPORI := "R"
cDEC    := "N"
cBCO    := "N"
cDEM    := "N"
cENT    := "N"
@ 15,01 SAY "Resumo Final em minutos sexadecimal"                                  
@ 16,01 SAY "Resumo Banco de Horas"                                                
@ 17,01 SAY "Listar Demitidos"                                                     
@ 18,01 SAY "Espacar Entrelinha"                                                   
@ 15,40 GET cDEC                                  PICT "!" VALID cDEC $ "SN"       
@ 16,40 GET cBCO                                  PICT "!" VALID cBCO $ "SN"       
@ 17,40 GET cDEM                                  PICT "!" VALID cDEM $ "SN"       
@ 18,40 GET cENT                                  PICT "!" VALID cENT $ "SN"       
IF !READCUR()
   RETU .F.
ENDIF

aEVED := {}
aEVEC := {}
aEVEB := {}
PegFeriados()



lMIN := cDEC = "S"
lBCO := cBCO = "S"
lDEM := cDEM = "S"
lENT := cENT = "S"

CODCTA := PEGCX()

DESCTA := array(24)

if !NETUSE("FIRMA")
   retu
endif
dbgotop()
dbseek(NREMP)
mRAZ := RAZAO
mCGC := CGC
mEND := ENDERECO
mBAI := BAIRRO
mCID := CIDADE
mEST := ESTADO
dbcloseall()

if !NETUSE("CONTAS")
   return
endif


if !NETUSE(pes)
   dbcloseall()
   return
endif
if lDEM
   FILTRO := ""
else
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
endif
INX := ""
FILORD(.T.)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
if valtype(INX) = "N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF
set filter to &FILTRO


if !NETUSE(cPN)
   dbcloseall()
   retu
endif

if !NETUSE(cPT)
   dbcloseall()
   retu
endif

if !NETUSE("TABTURNO")
   dbcloseALL()
   retu
endif

if !NETUSE(if(lSECBCO,"BCOBAK","BCOHRS"))
   dbcloseALL()
   retu
endif
cSELE6 := ALIAS()

IF !NETUSE("FO_PTT")
   dbcloseall()
   retu
endif




if !NETUSE(cPD)
   dbcloseall()
   retuRN 0
endif
if !NETUSE(cPP)
   dbcloseall()
   retuRN 0
endif
if !NETUSE(cPA)
   dbcloseall()
   retuRN 0
endif



if !MDL('FOPTO_36 - Listagem Apontamento e Totais')
   retu
endif
if lENT
   IMPRESSORA()
   qqout(chr(27)+"3"+"72")
   VIDEO()
endif

LISTARUE({| X | FOPTO36(X)})

retu


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO36()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function FOPTO36


para COMPARE
dbselectar(PES)
dbgotop()
while !eof()
   if &COMPARE
      dbselectar("CONTAS")
      @ prow()+ 1,0 say IMPSTR(cIMPEXP)+repl('=',80)                          
      @ prow()+ 1,0 say "FOLHA DE PONTO - "+ALLTRIM(mRAZ)                     
      @ prow(),56   say "CGC:"+mCGC                                           
      @ prow()+ 1,0 say "End: "+mEND+" - "+mBAI+" - "+mCID+" - "+mEST         
      if !empty(NOMSETOR)
         @ prow()+ 1,0 say NOMSETOR         
      endif

      dbselectar(PES)
      TSA        := TIPO
      NUM        := NUMERO
      ANO        := str(year(DXDIA),4)
      mDEMITIDO  := DEMITIDO
      DIAINI     := ctod("  /  /  ")
      DIAFIM     := ctod("  /  /  ")
      nTOTBCOHRS := 0
      cPIS       := PIS
      cEVINC     := FIELD->EVINC

      VIDEO()
      petela(8)
      IMPRESSORA()



      dbselectar(cPN)
      dbgotop()
      dbseek(str(NUM,8))
      while NUM = NUMERO .and. !eof()
         if empty(DIAINI)
            DIAINI := DATA
         endif
         DIAFIM := DATA
         dbskip()
      enddo

      dbselectar(PES)
      @ prow()+ 1,0 say "Funcionario:"+str(NUM,8)+"-"+NOME+" PIS: "+cPIS                                       
      @ prow()+ 1,0 say "Depto: "+STRVAL(DEPTO,4)+"/"+STRVAL(SETOR,3)+"/"+STRVAL(SECAO,3)+" Horario: "         
      cHT  := HT
      cHTT := HTT
      dADM := ADMITIDO
      dbselectar("TABTURNO")
      dbgotop()
      IF dbseek(cHTT)
         @ prow(),30   say NOME                            
         @ prow()+ 1,0 say "Admitido: "+dtoc(dADM)         
         if !empty(NOM2)
            @ prow(),30 say NOM2         
         endif
      else
         @ prow(),30   say "Descritivo de Horario nao Cadastrado"         
         @ prow()+ 1,0 say "Admitido: "+dtoc(dADM)                        
      endif
      @ prow()+ 1,0     say "Periodo:"+dtoc(DIAINI)+"-"+dtoc(DIAFIM)                                              
      @ prow(),pcol()+1 say IMPSTR(cIMPCOM)+" Legenda: #Alteracao de Horario Trabalho *Lancamento Manual"         
      @ prow()+ 1,0     say IMPSTR(cIMPCOM)+repl('-',132)                                                         
      @ prow()+ 1,0     say IMPSTR(cIMPCOM)+"DIA "                                                                
      for X := 1 to 16
         @ prow(),21+(X * 6) say strzero(X,2)+'/'+strzero(X+16,2)         
      next X
      @ prow()+ 1,0 say repl('-',132)         

      IF !VALPIS(cPIS,.F.,.F.,cEVINC)
         @ PROW()+ 1,0 SAY ZERRO         
         IMPFOL()
         dbselectar(PES)
         dbskip()
         loop
      ENDIF

      dbselectar(cPN)
      dbgotop()
      dbseek(str(NUM,8))
      while NUM = NUMERO .and. !eof()
         //X := day( DATA )
         @ prow()+ 1,0   say IMPSTR(cIMPCOM)+DTOC(data)         
         @ prow(),pcol() say MUDHOR                             
         @ prow(),09     say COD                                
         if !empty(ENT) .or. !empty(SAI)
            @ prow(),12     say ENT    pict '##.##'        
            @ prow(),pcol() say MUDENT                     
            @ prow(),18     say SAI    pict '##.##'        
            @ prow(),pcol() say MUDSAI                     
         endif
         aCTA := {CTA01,CTA02,CTA03,CTA04,CTA05,CTA06,CTA07,CTA08,;
          CTA09,CTA10,CTA11,CTA12,CTA13,CTA14,CTA15,CTA16,;
          CTA17,CTA18,CTA19,CTA20,CTA21,CTA22,CTA23,CTA24}
         for X := 1 to 16
            if !empty(aCTA[X])
               @ prow(),18+(X * 6) say aCTA[X] pict '###.##'        
            endif
         next X
         IF CTA17+CTA18+CTA19+CTA20+CTA21+CTA22+CTA23+CTA24 > 0
            @ prow()+ 1,0 SAY "cta 17 a 24"         
            for X := 1 to 8
               if !empty(aCTA[X+16])
                  @ prow(),18+(X * 6) say aCTA[X+16] pict '###.##'        
               endif
            next X
         ENDIF
         if (COD = "SA" .OR. SOD = "SA") .AND. DOW(DATA) <> 7
            @ prow()+ 1,0 SAY DTOC(data)+" Codigo SA sem ser sabado"         
         endif
         if (COD = "DO" .OR. SOD = "DO") .AND. DOW(DATA) <> 1
            @ prow()+ 1,0 SAY DTOC(data)+" Codigo DO sem ser domingo"         
         endif
         IF (COD = "FE" .OR. SOD = "FE") .AND. ASCAN(aEVED,str(DAY(DATA),2)+str(MONTH(DATA),2)) = 0
            @ prow()+ 1,0 SAY DTOC(data)+" Codigo FE sem feriado cadastrado "         
         ENDIF

         VIDEO()
         nPASSAGENS := VERPASSAGENS(NUM,DATA,.f.,.F.,cPIS)
         IMPRESSORA()
         IF nPASSAGENS > 1 .AND. INT(nPASSAGENS / 2) <> nPASSAGENS / 2
            @ PROW()+ 1,0 SAY "Passagens impares Favor descartar desnecessarias"         
         ENDIF

         dbselectar(cPN)
         dbskip()
      enddo
      //totais
      dbselectar(cPT)
      dbgotop()
      IF dbseek(NUM)
         nTOTBCOHRS := BCOHRS
         @ prow()+ 1,0 say IMPSTR(cIMPCOM)+repl('=',132)+IMPSTR(cIMPCOM)         
         aTOTAL := {CTA01,CTA02,CTA03,CTA04,CTA05,CTA06,CTA07,CTA08,;
          CTA09,CTA10,CTA11,CTA12,CTA13,CTA14,CTA15,CTA16,;
          CTA17,CTA18,CTA19,CTA20,CTA21,CTA22,CTA23,CTA24}
         @ prow()+ 1,0 say "Totais"         
         for X := 1 to 16
            if !empty(aTOTAL[X])
               @ prow(),18+(X * 6) say aTOTAL[X] pict '###.##'        
            endif
         next X
         @ prow()+ 1,0 say IMPSTR(cIMPCOM)+repl('=',132)         

         //Monta temporaria com os totais
         aTOTX := ARRAY(24)
         aDESX := ARRAY(24)
         aCTAX := ARRAY(24)
         nPOSX := 1
         for x := 1 TO 24
            if !empty(aTOTAL[X])
               BUSCA := CODCTA[X]   //Contas 1 A 24
               BUSCA := if(empty(BUSCA),0,&BUSCA)
               dbselectar("CONTAS")
               dbgotop()
               dbseek(BUSCA)
               aDESX[ nPOSX ] := if(found(),DESCR,"")
               aTOTX[ NPOSX ] := aTOTAL[X]
               aCTAX[ NPOSX ] := X
               nPOSX ++
            endif
         NEXT X

         //imprime a temporaria
         for X := 1 to 24 STEP 2
            if !empty(aTOTX[X])
               @ prow()+ 1,0 say strzero(aCTAX[X],3)+" - "+aDESX[X]                       
               @ prow(),50   say if(lMIN,BHOR(aTOTX[X]),aTOTX[X])   pict "9999.99"        
            endif
            if !empty(aTOTX[X+1])
               @ prow(),60  say strzero(aCTAX[X+1],3)+" - "+aDESX[X+1]                       
               @ prow(),110 say if(lMIN,BHOR(aTOTX[X+1]),aTOTX[X+1])   pict "9999.99"        
            endif
         NEXT X
      endif

      if !empty(mDEMITIDO) .or. lBCO
         dbselectar(cSELE6)
         nSALDO := pegsaldobco(NUM,nANOANT,nMESANT)
         if nSALDO <> 0.00 .OR. nTOTBCOHRS <> 0.00
            @ prow()+ 1,0     say "Saldo Banco Horas="+str(MES)+"/"+str(ANO)                               
            @ prow(),30       say if(lMIN,BHOR(nSALDO),nSALDO)                       pict "9999.99"        
            @ prow(),PCOL()+1 say "Atual="                                                                 
            @ prow(),PCOL()+1 say if(lMIN,BHOR(nTOTBCOHRS),nTOTBCOHRS)               pict "9999.99"        
            @ prow(),PCOL()+1 say "="                                                                      
            @ prow(),PCOL()+1 say if(lMIN,BHOR(nSALDO+nTOTBCOHRS),nSALDO+nTOTBCOHRS) pict "9999.99"        
            @ prow()+ 1,0     say IMPSTR(cIMPCOM)+repl('=',132)                                            
         endif
      endif
      @ prow()+ 1,0 say IMPSTR(cIMPCOM)+repl('=',132)         

      // Totais Anuais
      aTOTANO := PEGTOTANO(NUM,.F.)
      @ prow()+ 1,0 say "Totais Anual"         
      for X := 1 to 12
         if !empty(aTOTANO[X])
            @ prow(),17+(X * 8) say STRZERO(X,3)         
         endif
      next X
      @ prow()+ 1,0 say ""         
      for X := 1 to 12
         if !empty(aTOTANO[X])
            @ prow(),14+(X * 8) say aTOTANO[X] pict '####.##'        
         endif
      next X
      @ prow()+ 1,0 say ""         
      for X := 13 to 24
         if !empty(aTOTANO[X])
            @ prow(),17+((X - 12) * 8) say STRZERO(X,3)         
         endif
      next X
      @ prow()+ 1,0 say ""         
      for X := 13 to 24
         if !empty(aTOTANO[X])
            @ prow(),14+((X - 12) * 8) say aTOTANO[X] pict '####.##'        
         endif
      next X
      @ prow()+ 1,0 say IMPSTR(cIMPEXP)+repl('=',80)                                    
      @ prow()+ 3,0 say repl('-',35)+spac(10)+repl('-',35)                              
      @ prow()+ 1,6 say "Assinatura do RH"+spac(28)+"Assinatura do Funcionario"         
      @ prow()+ 1,0 say repl('=',80)                                                    
      IMPFOL()
   endif
   dbselectar(PES)
   dbskip()
enddo



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function PegSaldoBco()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function PegSaldoBco(nNUMBUS,nANOBUS,nMESBUS,lOPEN)   //dbselectar() antes de chamar

LOCAL nSALDO
IF VALTYPE(lOPEN) # "L"
   lOPEN := .F.
ENDIF
IF lOPEN
   if !NETUSE(if(lSECBCO,"BCOBAK","BCOHRS"))
      retu 0
   endif
ENDIF
nSALDO := 0
dbgotop()
IF DBSEEK(str(nNUMBUS,8)+str(nANOBUS,4)+str(nMESBUS,2))   //pega a competencia
   nSALDO := SALDO
endif
IF lOPEN
   DBCLOSEAREA()
ENDIF
RETU nSALDO


*+ EOF: fopto_36.prg
*+
