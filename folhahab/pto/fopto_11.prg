*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_11.prg
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


CABE2('FOPTO_11 - Transferindo e Atualizando dados do Relogio')
para nTIPO,lPER
IF VALTYPE(lPER) # "L"
   lPER := .T.
ENDIF
if nTIPO = 0
   nTIPO := PEGRELOGIO()
endif

if !NETUSE("foptorel")
   retu .F.
ENDIF
dbgotop()
if !dbseek(ntipo)
   dbcloseall()
   ALERTX("falta configuracao relogio "+str(ntipo))
   retu .f.
endif
cCAMINHO := ALLTRIM(caminho)
DADO     := alltrim(ARQUIVO)
cARQ     := alltrim(ARQDEST)
TIPC     := PROCESSO
lDIVIDE  := if(HORADEC = "S",.T.,.F.)
TIPD     := ANOREL
dbcloseall()


DCORTE := zdataini
DCORTF := zdatafim
MDS('Digite o periodo ')
@ 24,40 get DCORTE         
@ 24,60 get DCORTF         
if !READCUR()
   retu .F.
endif

MDS('Aguarde Carregando Dados do Rel¢gio')
cPD := PARQDIO(nTIPO)
//if ! lPER .OR. MDG( "Apagar Importa‡ao Anterior" )
//   DELETEFILE( ZDIRE + cPD + ".DBF" )
//   DELETEFILE( ZDIRE + cPD + "." + cRDDEXT )
//endif

CHECKCRI(cPD,"FO_DIO","STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)")

IF !file(cARQ+".DBF")
   ALERTX("Falta arquivo de migracao")
   return
ENDIF

if !NETUSE(cARQ,,,,,.F.,)
   dbcloseall()
   return
endif
zap
if !FOPTO1101(DADO)
   dbcloseall()
   return
endif

nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| EMPTY(DATA)},{|| zei_fort(nLASTREC,,,1)})
zei_fort(nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| EMPTY(NUMERO)},{|| zei_fort(nLASTREC,,,1)})
zei_fort(nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| EMPTY(HORA)},{|| zei_fort(nLASTREC,,,1)})
dbclosearea()
netpack(cARQ)




if !NETUSE(cARQ,,,,,.F.,)
   dbcloseall()
   retu .f.
ENDIF

if !netuse(cPD)
   dbcloseall()
   retu
endif


MDS('Aguarde Atualizando Dados do Relogio')
dbselectar(cARQ)
GRAPP := 1
GRAPT := lastrec()
GRAPT('AGUARDE ATUALIZANDO DADOS ')
dbgotop()
while !eof()
   NUM := NUMERO
   DAT := DATA
   HOR := HORA
   if valtype(DATA) = "N"
      if TIPD = "3" .OR. TIPD = "4"
         DIC := strzero(DAT,8)
      else
         DIC := str(DAT,6)
      endif
   endif
   do case
   case TIPD = "1"
      DIAX := substr(DIC,1,2)
      nMES := substr(DIC,3,2)
      ANO  := substr(DIC,5,2)
   case TIPD = "2"
      ANO  := substr(DIC,1,2)
      nMES := substr(DIC,3,2)
      DIAX := substr(DIC,5,2)
   case TIPD = "3"
      DIAX := substr(DIC,1,2)
      nMES := substr(DIC,3,2)
      ANO  := substr(DIC,5,4)
      DAT  := diax+nmes+substr(DIC,7,2)
      DAT  := val(DAT)
   case TIPD = "4"
      ANO  := substr(DIC,1,4)
      nMES := substr(DIC,5,2)
      DIAX := substr(DIC,7,2)
      DAT  := diax+nmes+substr(DIC,3,2)
      DAT  := val(DAT)
   endcase
   DIX := ctod(DIAX+"/"+nMES+"/"+ANO)
   if lDIVIDE
      HOR /= 100
   endif
   if HOR < 1
      HOR += 24
      DIX --
   endif
   BUSCA := str(NUM,8)+dtos(DIX)+str(HORA,5,2)
   if DIX >= DCORTE .and. DIX <= DCORTF
      if !empty(DIX) .and. !empty(NUM) .and. !empty(HOR)
         dbselectar(cPD)
         dbgotop()
         if !dbseek(BUSCA)
            netrecapp()
            field->NUMERO := NUM
            field->HORA   := HOR
            field->DATA   := DIX
            dbunlock()
         endif
      endif
   endif
   dbselectar(cARQ)
   GRAPS()
   dbskip()
enddo
dbcloseall()


if nTIPO = 1 .or. nTIPO = 4 .or. nTIPO = 5
   trocapro(cpd,dcorte,dcortf)
   IF lPER
      if MDG("Deseja Transferir Dados Ponto do Mes")
         FOPTO_12()
      endif
   ELSE
      FOPTO_12(DCORTE,DCORTF)
   ENDIF
endif
retu


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO1101()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function FOPTO1101(cORI)


if at(".",cORI) = 0
   cORI += ".TXT"
endif
if !HB_FILEEXISTS(cORI)
   ALERTX("Falta Arquivo: "+cORI)
   retu .F.
endif
nLASTREC := FLINECOUNT(cORI)
zei_fort(nLASTREC,,,0)
do case
case TIPC = "D"
   APPEnd from &cORI. DELIMITED while zei_fort(nLASTREC,,,1)
case TIPC = "S"
   APPEnd from &cORI. SDF while zei_fort(nLASTREC,,,1)
endcase
retuRN .T.




*+ EOF: fopto_11.prg
*+
