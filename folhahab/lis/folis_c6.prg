*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_c6.prg
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
*+    Documentado em 27-Dez-2024 as  9:26 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function folis_c6()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function folis_c6

PARA cTIPO,nACU


CABE2('Imprimir Informe de Rendimentos')
IF cTIPO = "R"
   CHECKIMP(0)
ENDIF

IF nACU = 0
   nACU := IRRESC()
ENDIF

MDS('* CARREGANDO DADOS DA FIRMA *')
if !NETUSE("FIRMA")   //AREDE( "FIRMA", "FIRMA", 0 )
   retu
endif
dbgotop()
IF dbseek(NREMP)
   NRCGC  := CGC
   xrTEL  := TELEFONE
   xrRESN := RESPONSAV
endif
dbcloseall()

DXDIA2  := date()
CONTAR  := 1
ANOBASE := year(DXDIA2)
IF cTIPO = "R"
   @ 21,00 clea
   @ 21,00 say 'Nome do Respons vel'                           
   @ 22,00 say 'Qual a data para impressao'                    
   @ 23,00 say 'Qual o ano base'                               
   @ 24,00 say 'Quantas Copias Deseja'                         
   @ 21,40 get xrRESN                                          
   @ 22,40 get DXDIA2                                          
   @ 23,40 get ANOBASE                      pict '####'        
   @ 24,40 get CONTAR                       pict '##'          
   if !READCUR()
      retu .F.
   endif
   lGRAVA := MDG("Grava Resultado Avulso")
   UFIR   := MDG('Deseja em ufir')
   CONF   := MDG('Deseja Conferir um a um')
ELSE
   lGRAVA := .T.
   UFIR   := .F.
   CONF   := .F.
ENDIF


if !ARQIRR(nACU,1,3)  //Shared Arede PES
   retu .F.
endif
cSELE1 := ALIAS()
FILTRO := ''
FI     := trim(FILTRO)
FILTRO := FILTRO(FI)
set filter to &FILTRO

if !ARQIRR(nACU,1,,2)   //SHARED Arede AcuIrrf
   dbcloseall()
   retu .F.
endif
cSELE2 := ALIAS()
dbgotop()
if lGRAVA
   IF MDG("Apagar Resultados Gravados Anteriores")
      NETZAP("IRRF")
   ENDIF
   if !NETUSE("IRRF")   //AREDE( "IRRF", "IRRF", 0 )
      dbcloseall()
      retu .F.
   endif
endif

IF cTIPO = "R"
   set devi to print
ENDIF
DBSELECTAR(cSELE1)
dbgotop()
while !eof()
   CTR   := NUMERO
   mCPF  := CPF
   mNOME := NOME
   lIMP  := .F.
   V401  := V402 := V403 := V404 := V405 := V406 := V407 := 0.00
   V501  := V502 := V503 := V504 := V505 := V506 := V507 := 0.00
   V601  := V602 := V603 := V604 := V605 := V606 := V607 := 0.00
   V611  := V612 := V613 := V614 := V615 := V616 := V617 := 0.00
   OBS01 := OBS02 := OBS03 := OBS04 := OBS05 := space(60)
   DBSELECTAR(cSELE2)
   dbgotop()
   dbseek(mCPF)
   while mCPF = CPF .and. !eof()
      lIMP := .T.
      VAL  := if(UFIR,VALUFIR,VALOR)
      do case
      case CODREN = 401
         V401 += VAL
      case CODREN = 402
         V402 += VAL
      case CODREN = 403
         V403 += VAL
      case CODREN = 404
         V404 += VAL
      case CODREN = 405
         V405 += VAL
      case CODREN = 407
         V407 += VAL

      case CODREN = 501
         V501 += VAL
      case CODREN = 502
         V502 += VAL
      case CODREN = 503
         V503 += VAL
      case CODREN = 504
         V504 += VAL
      case CODREN = 505
         V505 += VAL
      case CODREN = 506
         V506 += VAL
      case CODREN = 507
         V507 += VAL

      case CODREN = 601
         V601 += VAL
      case CODREN = 602
         V602 += VAL
      case CODREN = 603
         V603 += VAL
      case CODREN = 604
         V604 += VAL
      case CODREN = 605
         V605 += VAL
      case CODREN = 607
         V607 += VAL

      case CODREN = 611
         V611 += VAL
      case CODREN = 612
         V612 += VAL
      case CODREN = 613
         V613 += VAL
      case CODREN = 614
         V614 += VAL
      case CODREN = 615
         V615 += VAL
      case CODREN = 617
         V617 += VAL


      endcase
      DBSELECTAR(cSELE2)
      dbskip()
   enddo
   DBSELECTAR(cSELE1)
   if lIMP
      if CONF
         VIDEO()
         IRRFTEL()
         NETRECLOCK()
         IRRFGET(.F.)
         DBUNLOCK()
         IMPRESSORA()
      endif
      IF cTIPO = "R"
         IMPINFO()
      ENDIF
      if lGRAVA
         DBSELECTAR("IRRF")
         dbgotop()
         if !dbseek(mCPF)
            NETRECapp()
            field->CPF := mCPF
            field->CGC := NRCGC
         ELSE
            NETRECLOCK()
         endif
         field->NOME := mNOME

         field->V401 := memvar->V401
         field->V402 := memvar->V402
         field->V403 := memvar->V403
         field->V404 := memvar->V404
         field->V405 := memvar->V405
         field->V407 := memvar->V407

         field->V501 := memvar->V501
         field->V502 := memvar->V502
         field->V503 := memvar->V503
         field->V504 := memvar->V504
         field->V505 := memvar->V505
         field->V506 := memvar->V506
         field->V507 := memvar->V507

         field->V601 := memvar->V601
         field->V602 := memvar->V602
         field->V603 := memvar->V603
         field->V604 := memvar->V604
         field->V605 := memvar->V605
         field->V607 := memvar->V607

         field->V611 := memvar->V611
         field->V612 := memvar->V612
         field->V613 := memvar->V613
         field->V614 := memvar->V614
         field->V615 := memvar->V615
         field->V617 := memvar->V617

         field->OBS01 := memvar->OBS01
         field->OBS02 := memvar->OBS02
         field->OBS03 := memvar->OBS03
         field->OBS04 := memvar->OBS04
         field->OBS05 := memvar->OBS05
         DBUNLOCK()
      endif
   endif
   DBSELECTAR(cSELE1)
   dbskip()
enddo
dbcloseall()
IF cTIPO = "R"
   IMPEND()
ENDIF
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function IMPINFO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func IMPINFO


for X := 1 to CONTAR
   @ prow(), 0   say repl('-',80)                                                              
   @ prow()+ 1,0 say "| MINISTERIO FAZENDA "                                                   
   @ prow(),35   say ' COMPROVANTE DE RENDIMENTOS PAGOS E DE'                                  
   @ prow(),79   say '|'                                                                       
   @ prow()+ 1,0 say "| SECRETARIA DA FAZENDA NACIONAL"                                        
   @ prow(),35   say ' RETENCAO DE IMPOSTO DE RENDA NA FONTE'                                  
   @ prow(),79   say '|'                                                                       
   @ prow()+ 1,0 say repl('-',80)                                                              
   @ prow()+ 1,1 say '1. FONTE PAGADORA PESSOA JURIDICA OU PESSOA FISICA'                      
   @ prow(),50   say "| ANO CALENDARIO: "+str(ANOBASE)                                         
   @ prow()+ 1,0 say repl('-',80)                                                              
   @ prow()+ 1,0 say '| Nome '+MSG2                                                            
   @ prow(),50   say "| CGC/CPF: "+NRCGC                                                       
   @ prow(),79   say '|'                                                                       
   @ prow()+ 1,0 say repl('-',80)                                                              
   @ prow()+ 1,1 say '2. PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS'                           
   @ prow()+ 1,0 say repl('-',80)                                                              
   @ prow()+ 1,0 say '| CPF: '+CPF+'| Nome Completo: '+NOME                                    
   @ prow(),79   say '|'                                                                       
   @ prow()+ 1,0 say '| Natureza do rendimento : RENDIMENTO DO TRABALHO ASSALARIADO'           
   @ prow(),79   say '|'                                                                       
   @ prow()+ 1,0 say repl('-',80)                                                              
   @ prow()+ 1,1 say '3. RENDIMENTOS TRIBUTAVEIS, DEDUCOES E IMPOSTO RETIDO NA FONTE '         
   @ prow(),64   say "VALORES EM "+if(UFIR,'UFIR',"REAIS")                                     
   @ prow()+ 1,0 say repl('-',80)                                                              
   @ prow()+ 1,0 say '|'                                                                       
   @ prow(), 1   say '01 - Total dos Rendimentos (Inclusive Ferias)'                           
   if NRSEN = 'DiReT'
      @ prow(),45 say '(PRO LABORE)'         
   endif
   @ prow(),60   say '|'                                                                                    
   @ prow(),64   say V401                                                      pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say '|'                                                                                    
   @ prow(), 1   say '02 - Contribuicao Previdenciaria Oficial'                                             
   @ prow(),60   say '|'                                                                                    
   @ prow(),64   say V402                                                      pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say '|'                                                                                    
   @ prow(), 1   say '03 - Contribuicao Previdenciaria Privada e ao FAPI'                                   
   @ prow(),60   say '|'                                                                                    
   @ prow(),64   say V403                                                      pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say '|'                                                                                    
   @ prow(), 1   say '04 - Pensao Alimenticia (informar beneficiario campo 6)'                              
   @ prow(),60   say '|'                                                                                    
   @ prow(),64   say V404                                                      pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say '|'                                                                                    
   //    @ PROW(),1 SAY '05 - Dependentes             '
   //    @ PROW(),60 SAY '|'
   //    @ PROW(),64 SAY V407 PICT '###,###,###.##'
   //    @ PROW(),79 SAY '|'
   //   @ PROW()+1,0 SAY '|'
   @ prow(), 1   say '05 - Imposto Retido na Fonte '                                         
   @ prow(),60   say '|'                                                                     
   @ prow(),64   say V405                                       pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                     
   @ prow()+ 1,0 say repl('-',80)                                                            
   @ prow()+ 1,1 say '4 - RENDIMENTOS ISENTOS NAO TRIBUTAVEIS '                              
   @ prow(),64   say "VALORES EM "+if(UFIR,'UFIR',"REAIS")                                   
   @ prow()+ 1,0 say repl('-',80)                                                            
   @ prow()+ 1,0 say '|'                                                                     
   @ prow(), 1   say '01 - Salario Familia '                                                 
   @ prow(),60   say '|'                                                                     
   @ prow(),64   say V501                                       pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                     
   @ prow()+ 1,0 say '|'                                                                     
   @ prow(), 1   say '02 - Proventos Aposentados ou Reforma'                                 
   @ prow(),60   say '|'                                                                     
   @ prow(),64   say V502                                       pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                     
   @ prow()+ 1,0 say '|'                                                                     
   @ prow(), 1   say '03 - Diarias Ajuda de Custo'                                           
   @ prow(),60   say '|'                                                                     
   @ prow(),64   say V503                                       pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                     
   @ prow()+ 1,0 say '|'                                                                     
   @ prow(), 1   say '04 - Pensao Proventos      '                                           
   @ prow(),60   say '|'                                                                     
   @ prow(),64   say V504                                       pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                     
   @ prow()+ 1,0 say '|'                                                                     
   @ prow(), 1   say '05 - Lucro ou Dividendo Apurado'                                       
   @ prow(),60   say '|'                                                                     
   @ prow(),64   say V505                                       pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                     
   @ prow()+ 1,0 say '|'                                                                     
   @ prow(), 1   say '06 - Valores Pagos a titulares ou Socios'                              
   @ prow(),60   say '|'                                                                     
   @ prow(),64   say V506                                       pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                     
   @ prow()+ 1,0 say '|'                                                                     
   @ prow(), 1   say '07 - Outros/Especificar'                                               
   if V507 <> 0.00
      if !empty(OBS01)
         @ prow(),26 say OBS01         
      else
         @ prow(),26 say ':FGTS/INDENIZACOES/ABONO'         
      endif
   endif
   @ prow(),60   say '|'                                       
   @ prow(),64   say V507         pict '###,###,###.##'        
   @ prow(),79   say '|'                                       
   @ prow()+ 1,0 say repl('-',80)                              
   //  @ PROW()+1, 1 SAY '5 - RENDIMENTOS SUJEITOS A TRIBUTACAO EXCLUSIVA NA FONTE (RENDIMENTO LIQUIDO) '
   @ prow()+ 1,1 say '5 - RENDIMENTOS SUJEITOS A TRIBUTACAO EXCLUSIVA NA FONTE '                              
   @ prow(),64   say "VALORES EM "+if(UFIR,'UFIR',"REAIS")                                                    
   @ prow()+ 1,0 say repl('-',80)                                                                             
   @ prow()+ 1,0 say '|'                                                                                      
   @ prow(), 1   say '01 - Decimo Terceiro Salario'                                                           
   @ prow(),60   say '|'                                                                                      
   @ prow(),64   say if(V601 - (V602+V607+V604) > 0,V601 - (V602+V607+V604),0)   pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                                      
   @ prow()+ 1,0 say '|'                                                                                      
   @ prow(), 1   say '02 - Outros / Especificar'                                                              
   if !empty(OBS02)
      @ prow(),26 say OBS02         
   endif
   @ prow(),60   say '|'                                                                                    
   @ prow(),64   say if(V611 - (V612+V617+V614) > 0,V611 - (V612+V617+V614),0) pict '###,###,###.##'        
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say repl('-',80)                                                                           
   @ prow()+ 1,1 say '6 - INFORMACOES COMPLEMENTARES'                                                       
   @ prow()+ 1,0 say repl('-',80)                                                                           
   @ prow()+ 1,0 say '|'                                                                                    
   @ prow(), 1   say OBS01                                                                                  
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say '|'                                                                                    
   @ prow(), 1   say OBS02                                                                                  
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say '|'                                                                                    
   @ prow(), 1   say OBS03                                                                                  
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say repl('-',80)                                                                           
   @ prow()+ 1,1 say '7 - RESPONSAVEL PELAS INFORMACOES'                                                    
   @ prow()+ 1,0 say repl('-',80)                                                                           
   @ prow()+ 1,0 say '| Nome'                                                                               
   @ prow(),50   say '| DATA     | Assinatura'                                                              
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say '|'                                                                                    
   @ prow(),02   say xrRESN                                                                                 
   @ prow(),50   say '| '+dtoc(DXDIA2)+' |'                                                                 
   @ prow(),79   say '|'                                                                                    
   @ prow()+ 1,0 say repl('=',80)                                                                           
   //@ prow() + 1, 1 say 'Aprovado pela IN/SRF  No.120/2000'
   IMPFOL()
next X
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function IRRFTEL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func IRRFTEL


HB_DISPbox(2,0,23,79,B_DOUBLE)
@  3,3 say "PF:"+spac(20)+"Nome:"                                                     
@  4,3 say "Rendimentos/Dedu‡oes/Reten‡”es   Isentos"                                 
@  5,3 say "Rendimentos"+spac(22)+"Sal.Familia"                                       
@  6,3 say "Prev.Oficial"+spac(21)+"Prov.Aposen."                                     
@  7,3 say "Prev.Privada"+spac(21)+"Diarias/Ajudas"                                   
@  8,3 say "Pens„o"+spac(27)+"Pensao/Aponsenta"                                       
@  9,3 say "Dependentes"+spac(22)+"Lucro"                                             
@ 10,3 say "IRRF Retido"+spac(22)+"Pago Soc./Tit"                                     
@ 11,3 say "C.G.C"+spac(28)+"Outros"                                                  
@ 12,3 say "Descri‡„o Outros Rendimentos Isentos"                                     
@ 14,3 say "Tributados Fonte  Rendimento   IRRF.Ret. INSS  Dependente Pensao"         
@ 15,3 say "13o.Sal"                                                                  
@ 16,3 say "Outros"                                                                   
@ 17,3 say "Descri‡„o Outros Rendimentos Exclusivo na Fonte"                          
@ 19,3 say "Informa‡”es Complementares"                                               
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function IRRFGET()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func IRRFGET(lPEG)


if lPEG
   @  3,7  get CPF                     pict "999.999.999-99" valid VALCPF(CPF) //num_cgc_cpf_benef       
   @  3,32 get NOME //nom_beneficiario                                                                   
else  //num_matricula
   @  3,7  say CPF                            
   @  3,32 say NOME //val_plano_saude         
endif
@  5,16 get V401                                    picture '999999999.99' //Total dos Rendimentos   val_renda_bruta                        
@  6,16 get V402                                    picture '999999999.99' //Prev Oficial            val_inss                               
@  7,16 get V403                                    picture '999999999.99' //Prev Privada            val_prev_privada                       
@  8,16 get V404                                    picture '999999999.99' //Pensao                  val_pensao                             
@  9,16 get V407                                    picture '999999999.99' //Dependentes             val_depend                             
@ 10,16 get V405                                    picture '999999999.99' //Imposto Retido na Fonte val_ir_retido                          
@  5,56 get V501                                    picture '999999999.99' //Salario Familia         val_sal_familia                        
@  6,56 get V502                                    picture '999999999.99' //Aposentadoria                                                  
@  7,56 get V503                                    picture '999999999.99' //Diarias                 val_diaria_ajuda                       
@  8,56 get V504                                    picture '999999999.99' //invalidez                                                      
@  9,56 get V505                                    picture '999999999.99' //lucro                   val_lucros                             
@ 10,56 get V506                                    picture '999999999.99' //titulares                                                      
@ 11,16 get CGC                                                                                                                             
@ 11,56 get V507                                    picture '999999999.99' //Indenizacoes outros //val_aviso_previo val_fgts_indeniz        
@ 13,3  get OBS01 // Val_indenizacao val_13_indeniz                                                                                         
//13o. salario
@ 15,21 get V601 picture '999999999.99' // val_renda_bruta_13        
@ 15,34 get V605 picture '9999999.99' // val_ir_retido_13            
@ 15,45 get V602 picture '9999999.99' // val_inss_13                 
@ 15,56 get V607 picture '9999999.99' // val_depend_13               
@ 15,67 get V604 picture '9999999.99' // val_pensao_13               
// Outras
@ 16,21 get V611 picture '999999999.99' // renda_bruta        
@ 16,34 get V615 picture '9999999.99' // ir_retido            
@ 16,45 get V612 picture '9999999.99' // inss                 
@ 16,56 get V617 picture '9999999.99' // depend               
@ 16,67 get V614 picture '9999999.99' // pensao               
//obs
@ 18,3 get OBS02         
@ 20,3 get OBS03         
@ 21,3 get OBS04         
@ 22,3 get OBS05         
READCUR()
retu .T.


*+ EOF: folis_c6.prg
*+
