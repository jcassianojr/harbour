*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_e7.prg
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
*+    Documentado em 27-Dez-2024 as  9:41 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


////#INCLUDE "COMANDO.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fores_e7()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fores_e7

para CC
if !MDL('Listar Rescisao contratual em formulario',0)
   retu
endif
if !NETUSE("REL2")  //AREDE( "REL2", "REL2", 1 )
   retu
endif
INITVARS()
dbgotop()
if !dbseek('RESCISA2')
   ALERTX("Configure o Formul rio")
   dbclosearea()
   retu .F.
endif
EQUVARS()
dbclosearea()

CABE2('Confirme os Dados')
CTR        := 0
HOMO       := date()
CODSAQ     := 0
nPENSAO    := 0000000.00
cTOMADOR   := space(20)
cMOTIVO    := space(2)
cCATEGORIA := space(20)
@ 18,00 say 'Digite o numero do Funcionario'         
@ 19,00 say 'Qual a Data da Homologa‡„o'             
@ 20,00 say 'Qual o C¢digo de Saque FGTS'            
@ 21,00 say 'CPF/CGC Tomador Servi‡o'                
@ 22,00 say '% Pensao'                               
@ 23,00 say 'Cod.Afastamento'                        
@ 24,00 say 'Categoria'                              
@ 18,40 get CTR                                      
@ 19,40 get HOMO                                     
@ 20,40 get CODSAQ                                   
@ 21,40 get cTOMADOR                                 
@ 22,40 get nPENSAO                                  
@ 23,40 get cMOTIVO                                  
@ 24,40 get cCATEGORIA                               
if !READCUR()
   retu .F.
endif

if !NETUSE(PES)   //AREDE( PES, PES, 1 )
   retu
endif
if !NETUSE("FO_RSS")  //AREDE( "FO_RSS", "FO_RSS", 1 )
   dbcloseall()
   retu
endif
if !NETUSE("CONTAS")  //AREDE( "CONTAS", "CONTAS", 1 )
   dbcloseall()
   retu
endif
if !NETUSE("FIRMA")   //AREDE( "FIRMA", "FIRMA", 1 )
   dbcloseall()
   retu
endif
//if ! NETUSE("BCOFGTS")
//   dbcloseall()
//   retu
//endif
if !NETUSE("RESFOR")  //AREDE( "RESFOR", "RESFOR", 1 )
   dbcloseall()
   retu
endif

DBSELECTAR(PES)
dbgotop()
if !dbseek(CTR)
   MDT('Funcion rio n„o Encontrado')
   dbcloseall()
   retu
endif
MEF := month(DEMITIDO)

DBSELECTAR("RESFOR")
dbgotop()
IF !dbseek(CTR)
   netrecapp()
   field->NUMERO := CTR
else
   netreclock()
   for X := 29 to 55
      cVAR          := "VAL"+strzero(X,2)
      field->&cVAR. := 0
      cVAR          := "HOR"+strzero(X,2)
      field->&cVAR. := 0
   next X
   //NÆo efetura unlock pois grava valores embaixo
endif

xCAUSA := OBTER("FO_RCAU","",MOTIVO,"NOME")
DBSELECTAR("FO_RSS")
xVAL1 := VALCTA(CTR,109)
xVAL1 += VALCTA(CTR,905)
if xVAL1 > 0 .and. MDG("Experiencia Termino Contrato a Termo")
   xCAUSA := 'Termino de Contrato a Termo '
endif
MDS("Confirme Motivo")
@ 24,20 get xCAUSA         
READCUR()

DBSELECTAR(PES)
SALH := SALM := VAR1 := 0
SALHM(if(MEF # 0,MEF,MES))
XTIPO := CHECKTAB("TSA2"+TIPO+"    ",,,"Tipo nao Cadastrado",2)

nVEN := nDES := 0

DBSELECTAR("CONTAS")
while !eof()
   if !empty(POSREC)
      if POSREC > 28 .and. POSREC < 56 .and. POSREC # 46 .and. POSREC # 54 .and. POSREC # 55  //Totais e Fora
         nCONTA := CODIGO
         nPOS   := POSREC
         cDESC  := DESCR
         DBSELECTAR("FO_RSS")
         dbgotop()
         if dbseek(CTR * 10000+nCONTA)
            nHORAS := HORAS
            nVALOR := VALOR
            if nVALOR > 0
               DBSELECTAR("RESFOR")
               netreclock()
               cVAR          := "VAL"+strzero(nPOS,2)
               field->&cVAR. := &cVAR.+nVALOR   //Soma ctas multiplas
               cVAR          := "HOR"+strzero(nPOS,2)
               field->&cVAR. := &CVAR.+nHORAS
               cVAR          := "DES"+strzero(nPOS,2)
               field->&cVAR. := cDESC
               if nPOS < 46
                  nVEN += nVALOR
               else
                  nDES += nVALOR
               endif
               dbunlock()
            endif
         endif
      endif
   endif
   DBSELECTAR("CONTAS")
   dbskip()
enddo
DBSELECTAR("RESFOR")
netreclock()
field->VAL46 := nVEN
field->VAL54 := nDES
field->VAL55 := nVEN - nDES
dbunlock()
TELASAY("RESFOR")
EDITSAY("RESFOR")

//SET PRINT ON
//QQOUT(IMPCHR(27)+'C'+IMPCHR(73))
//QQOUT(cIMPNEG)
//SET PRINT OFF
IMPRESSORA()

@  0,0 say IMPSTR(cIMPCOM)         

DBSELECTAR("FIRMA")
dbgotop()
dbseek(NREMP)
@ prow()+mA,mB say CGC               
@ prow(),mC    say RAZAO             
@ prow()+mD,mB say ENDERECO          
@ prow(),mE    say BAIRRO            
@ prow()+MD,mB say CIDADE            
@ prow(),mF    say ESTADO            
@ prow(),mG    say CEP               
@ prow(),mH    say ATIVIDADE         
@ prow(),mE    say cTOMADOR          
DBSELECTAR(PES)
@ prow()+mJ,mB    say PIS                                                                                                                                                                                            
@ prow(),mC       say NOME                                                                                                                                                                                           
@ prow()+mD,mB    say ENDER+","+alltrim(ENDNUM)+" "+alltrim(ENDCOMPL)                                                                                                                                                
@ prow(),mE       say BAIRRO                                                                                                                                                                                         
@ prow()+MD,mB    say CIDADE                                                                                                                                                                                         
@ prow(),mF       say ESTADO                                                                                                                                                                                         
@ prow(),mG       say CEP                                                                                                                                                                                            
@ prow(),mI       say IF(left(TIRAOUT(CPF),7) = PROFIS,CPF,PROFIS+"-"+SERIE+"/"+CTPSUF) //CTPS digital com os primeiros 7 digitos do CPF e o campo Serie, com os 4 digitos restantes                                 
@ prow()+MD,mB    say CPF                                                                                                                                                                                            
@ prow(),mK       say NASC                                                                                                                                                                                           
@ prow(),mL       say MAE                                                                                                                                                                                            
@ prow()+MJ,mB    say VAR1                                                                                                                                                           pict '@E ###,###,###.##'        
@ prow(),pcol()+1 say xTIPO                                                                                                                                                                                          
@ prow(),mM       say ADMITIDO                                                                                                                                                                                       
if !empty(AVISOPREV)
   @ prow(),mN say AVISOPREV         
endif
@ prow(),mE    say DEMITIDO           
@ prow()+MD,mB say xCAUSA             
@ prow(),mO    say cMOTIVO            
@ prow(),mP    say nPENSAO            
@ prow(),mQ    say cCATEGORIA         

DBSELECTAR("RESFOR")
for X := 1 to 9
   //1 COLUNA
   Z    := X+28
   cVAR := "HOR"+strzero(Z,2)
   if X = 1
      @ prow()+mJ,0 say ""         
   else
      if Z > 29 .and. Z < 35 .or. Z = 36 .and. &cVAR. > 0
         @ prow()+MD,MR say &cVAR.         
      else
         @ prow()+MD,0 say ""         
      endif
   endif
   cVAR := "VAL"+strzero(Z,2)
   if &cVAR. > 0
      @ prow(),MS say &cVAR.         
   endif

   //2 COLLUNA
   Z := X+37
   if Z = 40
      cVAR := "HOR"+strzero(Z,2)
      if &CVAR. > 0
         @ prow(),MT say &cVAR.         
      endif
   endif
   if Z > 41 .and. Z < 46
      cVAR := "DES"+strzero(Z,2)
      @ prow(),MU say padr(&cVAR.,20)         
   endif
   cVAR := "VAL"+strzero(Z,2)
   if &cVAR. > 0
      @ prow(),MV say &cVAR.         
   endif

   //3 COLUNA
   Z := X+46
   if Z = 51 .or. Z = 52 .or. Z = 53
      cVAR := "DES"+strzero(Z,2)
      @ prow(),MW say padr(&cVAR.,20)         
   endif
   cVAR := "VAL"+strzero(Z,2)
   if &CVAR. > 0
      @ prow(),MX say &cVAR.         
   endif

next X

DBSELECTAR("FIRMA")
@ prow()+mY,mB say alltrim(CIDADE)+", "+dtoc(HOMO)         

IMPFOL()
VIDEO()
//SET PRINT ON
//QQOUT(cIMPNER)
//QQOUT(IMPCHR(27)+'C'+IMPCHR(66))
//SET PRINT OFF
dbcloseall()
IMPEND()
retu


*+ EOF: fores_e7.prg
*+
