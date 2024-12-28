*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_3j.prg
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

cPN := "PN"+ANOMESW
cPT := "PT"+ANOMESW

lMIN := MDG("Resumo Final em minutos sexadecimal")

if !netuse("FIRMA")
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
   retu
endif

if !NETUSE(pes)
   dbcloseall()
   retu
endif
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
INX    := ""
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
   dbcloseall()
   retu
endif


if !NETUSE(if(lSECBCO,"BCOBAK","BCOHRS"))
   dbcloseALL()
   retu
endif
cSELE6 := ALIAS()

if !MDL('FOPTO-3J - Listagem Apontamento e Totais Banco Horas')
   retu
endif
if MDG("Espacar Entrelinha")
   IMPRESSORA()
   qqout(chr(27)+"3"+"72")
   VIDEO()
endif

LISTARUE({| X | FOPTO3J(X)})

retu


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO3J()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func FOPTO3J


para COMPARE
dbselectar(PES)
dbgotop()
while !eof()
   if &COMPARE
      DBSELECTAR("CONTAS")
      @ prow()+ 1,0 say IMPSTR(cIMPEXP)+repl('=',80)                          
      @ prow()+ 1,0 say "FOLHA DE PONTO - "+mRAZ                              
      @ prow(),56   say "CGC:"+mCGC                                           
      @ prow()+ 1,0 say "End: "+mEND+" - "+mBAI+" - "+mCID+" - "+mEST         
      if !empty(NOMSETOR)
         @ prow()+ 1,0 say NOMSETOR         
      endif
      dbselectar(PES)
      TSA    := TIPO
      NUM    := NUMERO
      ANO    := str(year(DXDIA),4)
      DIAINI := ctod("  /  /  ")
      DIAFIM := ctod("  /  /  ")
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
      @ prow()+ 1,0 say "Funcionario:"+str(NUM,8)+"-"+NOME+" PERIODO:"+dtoc(DIAINI)+"-"+dtoc(DIAFIM)           
      @ prow()+ 1,0 say "Depto: "+STRVAL(DEPTO,4)+"/"+STRVAL(SETOR,3)+"/"+STRVAL(SECAO,3)+" Horario: "         
      cHT  := HT
      cHTT := HTT
      dADM := ADMITIDO
      dbselectar("TABTURNO")
      dbgotop()
      if dbseek(cHTT)
         @ prow(),30   say NOME                            
         @ prow()+ 1,0 say "Admitido: "+dtoc(dADM)         
         if !empty(NOM2)
            @ prow(),30 say NOM2         
         endif
      else
         @ prow(),30   say "Descritivo de Horario nao Cadastrado"         
         @ prow()+ 1,0 say "Admitido: "+dtoc(dADM)                        
      endif
      @ prow()+ 1,0 say repl('-',80)         
      @ prow()+ 1,0 say "DIA "               
      @ prow(),18   say "Reducao"            
      @ prow(),28   say "Banco"              
      @ prow(),38   say "Horas"              
      @ prow()+ 1,0 say repl('-',80)         

      //saldo anterior
      dbselectar(cSELE6)
      nSALDO := pegsaldobco(NUM,nANOANT,nMESANT)
      if nSALDO <> 0.00
         @ prow()+ 1,0 say "Saldo Banco Horas="+strzero(nMESANT,2)+"/"+strzero(nANOANT,4)                       
         @ prow(),38   say if(lMIN,BHOR(nSALDO),nSALDO)                                   pict "9999.99"        
      endif

      //Movimento do mes
      dbselectar(cPN)
      dbgotop()
      dbseek(str(NUM,8))
      while NUM = NUMERO .and. !eof()
         X := day(DATA)
         @ prow()+ 1,0 say strzero(X,2)         
         @ prow(), 3   say COD                  
         if !empty(ENT) .or. !empty(SAI)
            @ prow(),06 say ENT pict '##.##'        
            @ prow(),12 say SAI pict '##.##'        
         endif
         @ prow(),18 say REDSN          
         @ prow(),30 say BCOSN          
         @ prow(),38 say BCOHRS         
         dbskip()
      enddo
      @ prow()+ 2,0 say repl('=',80)         

      //Total
      nTOTBCOHRS := 0
      dbselectar(cPT)
      dbgotop()
      if dbseek(NUM)
         @ prow()+ 1,0 say "Atual"                                            
         @ prow(),38   say if(lMIN,BHOR(BCOHRS),BCOHRS) pict "9999.99"        
         nTOTBCOHRS := BCOHRS
      endif

      //saldo
      if nSALDO+nTOTBCOHRS <> 0.00
         @ prow()+ 1,0 say "Saldo"                                                                  
         @ prow(),38   say if(lMIN,BHOR(nSALDO+nTOTBCOHRS),nSALDO+nTOTBCOHRS) pict "9999.99"        
      endif

      @ prow()+ 1,0 say repl('=',80)         

      IMPFOL()
   endif
   dbselectar(PES)
   dbskip()
enddo


*+ EOF: fopto_3j.prg
*+
