*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib44.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

//
//chamar aplicativos externos use #
//exemplo #edit
//

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function AUTOMENU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func AUTOMENU(cDESC,cITEM,nMES,cARQMENU)


priv aMENUPROMPTS := {}
priv aITEM        := {}
priv W
priv KEY
if valtype(nMES) # "N"
   nMES := 0
endif
if valtype(cARQMENU) # "C"
   cARQMENU := "MANOPT"
endif

if USEREDE(cARQMENU,1,1)
   dbgotop()
   dbseek(cITEM)
   while ITEMENU = cITEM .and. !eof()
      if POSICAO > 0 .and. POSICAO < 34
         aadd(aITEM,{LINHA,COLUNA,LEFT(DESCP,25),TECLA,DESCM,alltrim(EXECUTAR)})
      endif
      dbskip()
   enddo
   dbclosearea()
endif
if empty(aITEM)
   ALERTX("Menu de Acesso "+cITEM+" Vazio")
   retu
endif

while .T.
   MDI(cDESC)
   setcolor(ZCOR008)
   for W := 1 to len(aITEM)
      OPCAO(aITEM[W,1],aITEM[W,2],aITEM[W,3],aITEM[W,4],aITEM[W,5])
   next W
   KEY := menu(1,nMES)
   if KEY = 0
      retu
   endif
   if KEY > 0
      DO CASE
         CASE cARQMENU = "MANSUB"
            if !PEGACS("S",cITEM+strZERO(KEY,3)+ZUSER,.T.,cITEM+" "+STR(KEY)+" Voce n„o tem acesso, Verifique com o Supervisor")
               loop
            endif
         otherwise
            if !ENTMNU(cITEM,KEY)
               loop
            endif
      ENDCASE
      cVAR := ALLTRIM(aITEM[KEY,6])
      IF LEFT(cVAR,1) = "#"
         cVAR := SUBSTR(cVAR,2)
         swpruncmd(cVAR)
      ELSE
         IF EMPTY(cVAR)
            ALERTX("NÆo Disponivel/NÆo Configurada")
            loop
         ELSE
            cVAR := &("{||"+cVAR+"}")
            eval(cVAR)
         ENDIF
      ENDIF
   endif
enddo


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MENUFEC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MENUFEC


para cARQ
priv cSTR
priv aITEM := {"","","","","","",""}
PEGACAMPO("MANFEC","cARQ",{"STRDES","OPER01","OPER02","OPER03","OPER04","OPER05","OPER06","OPER07"},;
 {"cSTR","aITEM[1]","aITEM[2]","aITEM[3]","aITEM[4]","aITEM[5]","aITEM[6]","aITEM[7]"})
while .T.
   MDI(" Ý ",,,cARQ)
   setcolor(ZCOR008)
   OPCAO(03,04," &A - Atual        ",65)
   OPCAO(04,04," &B - Baixados     ",66)
   OPCAO(05,04," &C - Mˆs Fechado  ",67)
   OPCAO(06,04," &D - Fechar o Mˆs ",68)
   OPCAO(07,04," &E - Acumulado    ",69)
   OPCAO(08,04," &F - Acumular     ",70)
   OPCAO(09,04," &G - Volta Baixa  ",71)
   KEY := menu(1,0)
   if KEY = 0
      retu
   endif
   if KEY > 0
      if !PEGACS("F",str(KEY,1)+cARQ+ZUSER,.T.,cARQ+" Fechamento - Voce n„o tem acesso, Verifique com o Supervisor")
         loop
      endif
      gravalog(str(KEY),"MNF",cARQ)
      cVAR := ALLTRIM(aITEM[KEY])
      IF EMPTY(cVAR)
         ALERTX("NÆo Disponivel/NÆo Configurada")
         loop
      ELSE
         cVAR := &("{||"+cVAR+"}")
         eval(cVAR)
      ENDIF
   endif
enddo


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ENTMNU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ENTMNU(cKEY,nPOS)


if nPOS <= 0
   retu .F.
endif
if !ZSUPER
   if !VERSEHA("MUSERM",USERMCRI(ZUSER,cKEY,nPOS))
      ALERTX(cKEY+" "+STR(nPOS)+"Voce n„o tem acesso, Verifique com o Supervisor")
      retu .F.
   endif
endif
gravalog(cKEY,"MNU",str(nPOS))
retu .T.

