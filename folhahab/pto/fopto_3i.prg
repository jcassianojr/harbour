*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_3i.prg
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

dINI := dFIM := ZDATA
MDS('Qual Periodo')
@ 24,20 get dINI         
@ 24,30 get dFIM         
if !READCUR()
   retu .F.
endif

if !CHECKIMP(0)
   retu .F.
endif

ARQ     := {}
nINIANO := year(dINI)
nFIMANO := year(dFIM)
for J := nINIANO to nFIMANO
   PATH1 := '\FOLHA\EMP'+ANOSTR(J)+strzero(NREMP,3)+'\'+spac(20)
   MDS('Confirme localiza‡„o Arquivos de:'+str(J,4))
   @ 24,45 get PATH1         
   if !READCUR()
      retu .F.
   endif
   PATH1 := alltrim(PATH1)
   do case
   case nINIANO = nFIMANO
      nMESINI := month(dINI)
      nMESFIM := month(dFIM)
   case nINIANO = J
      nMESINI := month(dINI)
      nMESFIM := 12
   case nFIMANO = J
      nMESINI := 1
      nMESFIM := month(dFIM)
   endcase
   for W := nMESINI to nMESFIM
      cARQ := PATH1+"PN"+ANOSTR(J)+strzero(W,2)
      if !INFOR(cARQ,"STR(NUMERO,8)+DTOS(DATA)",cARQ,.T.)
         retu .F.
      endif
      aadd(ARQ,{cARQ,J,W})
   next W
next J

if !netuse("tabfalta")
   dbcloseall()
   retu .F.
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

LISTARUE({| X | FOPTO3I(X)})

retu


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO3I()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func FOPTO3I

local cARQUSO
para COMPARE
dbselectar(PES)
dbgotop()
while !eof()
   if &COMPARE
      mNUMERO := NUMERO
      mNOME   := NOME
      CTLIN   := 80
      for W := 1 to len(ARQ)
         VIDEO()
         cARQUSO := ARQ[W,1]
         if !netuse(cARQUSO)
            VIDEO()
            dbcloseall()
            retu .F.
         endif
         IMPRESSORA()
         dbgotop()
         dbseek(str(mNUMERO,8))
         while mNUMERO = NUMERO .and. !eof()
            if !empty(COD)
               if CTLIN > 50
                  @  0,0  say "Ficha Frequencia"         
                  @  1,0  say mNUMERO                    
                  @  1,10 say mNOME                      
                  if !empty(NOMSETOR)
                     @  2,00 say NOMSETOR         
                     CTLIN := 3
                  else
                     CTLIN := 2
                  endif
               endif
               CTLIN ++
               @ CTLIN,0  say DATA         
               @ CTLIN,10 say COD          
               mCOD := COD
               if !empty(mCOD)
                  dbselectar("TABFALTA")
                  dbgotop()
                  IF dbseek(mCOD)
                     @ CTLIN,13 say NOME         
                  endif
                  dbselectar(Carquso)
               endif
            endif
            dbselectar(Carquso)
            dbskip()
         enddo
      next W
      dbselectar(Carquso)
      dbclosearea()
   endif
   dbselectar(PES)
   dbskip()
enddo


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ANOSTR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ANOSTR(XANO)


retu substr(strzero(XANO,4),3,2)


*+ EOF: fopto_3i.prg
*+
