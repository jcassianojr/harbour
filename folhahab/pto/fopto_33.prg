*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_33.prg
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



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO_33()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION FOPTO_33

para nTIP33
if !MDL('FOPTO_33 - Relacao Diaria de Entradas e Saidas')
   retu
endif
cPN := "PN"+ANOMESW

DIAX := date()
IF nTIP33 = 2 .OR. nTIP33 = 1
   MDS('De que dia Deseja o Relatorio')
   @ 24,40 get DIAX         
   READCUR()
ENDIF


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


if !netuse(cPN)
   dbcloseall()
   retu
endif

IF nTIP33 = 2 .OR. nTIP33 = 4
   cPD := PARQDIO()
   if !NETUSE(cPD)
      dbcloseall()
      retu
   endif
endif

PAG := 1
LISTARUE({| X | FOPTO33(X)},{|| RODAP()})
retu


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO33()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func FOPTO33



para COMPARE


dbselectar(pes)
dbgotop()
while !eof()
   if &COMPARE
      cTIT33 := ""
      cSUB33 := ""
      IF nTIP33 = 1
         cTIT33 := 'Relacao Diaria de Entradas e Saidas'
         cSUB33 := 'Entrada Almoco Saida'
      ENDIF
      IF nTIP33 = 2
         cTIT33 := 'Relacao Diaria Passagens Cartao'
         cSUB33 := 'Passagens'
      ENDIF
      IF nTIP33 = 3
         cTIT33 := 'Relacao Mensal de Frequencia'
         cSUB33 := 'Qtde Dias '
      ENDIF
      IF nTIP33 = 4
         cTIT33 := 'Relacao Mensal Passagem'
         cSUB33 := 'Qtde Dias '
      ENDIF
      if PAG = 1
         CABEC(cTIT33,cSUB33,,NOMSETOR)
      endif
      if prow() > 52
         RODAP()
         CABEC(cTIT33,cSUB33,,NOMSETOR)
      endif
      @ prow()+ 1,0 say str(NUMERO,8)+'-'+LEFT(NOME,30)         
      NUM   := NUMERO
      CONTA := 0
      BUSCA := str(NUMERO,8)+dtos(DIAX)
      IF nTIP33 = 3 .or. nTIP33 = 4
         BUSCA := str(NUMERO,8)
      ENDIF
      IF nTIP33 = 1
         dbselectar(cPN)
         dbgotop()
         IF dbseek(BUSCA)
            @ prow(),50     say ENT            
            @ prow(),pcol() say MUDENT         
            if empty(ALS) .and. empty(ALE)
               //   @ prow(), 58 say "AS"
            else
               @ prow(),56     say ALS            
               @ prow(),pcol() say MUDALS         
               @ prow(),62     say ALE            
               @ prow(),pcol() say MUDALE         
            endif
            @ prow(),68     say SAI            
            @ prow(),pcol() say MUDSAI         
         endif
      endif
      IF nTIP33 = 2
         COL := 40
         dbselectar(cPD)
         dbgotop()
         dbseek(BUSCA)
         while NUM = NUMERO .and. DATA = DIAX .and. !eof()
            @ prow(),COL say HORA         
            COL += 6
            dbskip()
         enddo
      ENDIF
      IF nTIP33 = 3
         dbselectar(cPN)
         dbgotop()
         dbseek(BUSCA)
         while NUM = NUMERO .and. !eof()
            if ENT # 0
               CONTA ++
            endif
            dbskip()
         enddo
         @ prow(),50 say CONTA pict '##'        
      ENDIF
      IF nTIP33 = 4
         dbselectar(cPd)
         dbgotop()
         dbseek(BUSCA)
         while NUM = NUMERO .and. !eof()
            CONTA ++
            DIAX := DATA
            while NUM = NUMERO .and. data = DIAX .and. !eof()
               dbskip()
            enddo
         enddo
         @ prow(),50 say CONTA pict '##'        
      ENDIF

   endif
   dbselectar(pes)
   dbskip()
enddo


*+ EOF: fopto_33.prg
*+
