*+--------------------------------------------------------------------
*+
*+    Programa  : m_dp.prg Gera documetacao estrutura arquivos
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+
*+    Copyright (c) 2023, JCassiano
*+
*+--------------------------------------------------------------------
*+


cARQ:=WIN_GETSAVEFILENAME(        , "Salvar Documentacao", HB_CWD(),"txt"   , "*.txt" , 1            ,               , "documentacao.txt")

lPULAFEC  := MDG("Pular Arquivos Fechados")
lPULACEP  := MDG("Pular Arquivos CEPS")
lPULACNPJ := MDG("Pular Arquivos CNPJ/IE")
lMESARQ   := MDG("Exibir Mensagem arquivo nao encontrado")


cTIPO := "D"
MDS("(D)ocumento (I)ni")
@ 24,40 get cTIPO valid cTIPO $ "DI"        
if !READCUR()
   retu .F.
endif


aARQ   := {}
aDES   := {}
aCAM   := {}
FILTRO := ""
FILTRO := RFILORD(zARQ,.F.)
if !USEREDE(zARQ,1,1)
   retu .T.
endif
set filter to &FILTRO
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
dbgotop()
while !eof()
   lINCLUI:=.T.
   iF ARQUIVO ="DICI"
      lINCLUI:=.F. 
   endif
  
   if (!empty(arqANO) .and. lPULAFEC) .or. ARQUIVO = "MANARQ" .or. ARQUIVO = "MANARQ1"
      //Nao Inclui Na Lista Fechados
      lINCLUI := .F.
   ENDIF
   if PADRAO = "A" .and. lPULACEP   //E cep e foi solicitado pular
      lINCLUI := .F.
   ENDIF
   IF lPULACNPJ .AND. (AT("CNPJIE",ARQUIVO) > 0 .OR. AT("BAIXA",ARQUIVO) > 0)
      lINCLUI := .F.
   ENDIF

   if lINCLUI
      aadd(aARQ,ARQUIVO)
      aadd(aDES,DESCRICAO)
      aadd(aCAM,LOCALARQ(PADRAO,CAMINHO))
   endif
   dbskip()
   zei_fort(nLASTREC,,,1)
enddo
dbcloseall()

if !USEREDE(HELPARQ,1,1)
   dbcloseall()
   retu .T.
endif

if !USEREDE("DICI",0,1)
   dbcloseall()
   retu .T.
endif
if lPULACEP
   delete all for UPPER(left(tabela,2))="C0"
   delete all for UPPER(left(tabela,2))="C1"
   delete all for UPPER(left(tabela,2))="C2"
   delete all for UPPER(left(tabela,2))="C3"
   delete all for UPPER(left(tabela,2))="C4"
   delete all for UPPER(left(tabela,2))="C5"
   delete all for UPPER(left(tabela,2))="G0"
   delete all for UPPER(left(tabela,2))="G1"
   delete all for UPPER(left(tabela,2))="G2"
   delete all for UPPER(left(tabela,2))="G3"
   delete all for UPPER(left(tabela,2))="G4"
   delete all for UPPER(left(tabela,2))="G5"   
endif
IF lPULACNPJ
   delete all for UPPER(left(tabela,4))="CNPJ"
ENDIF

nHANDLE := fcreate(alltrim(cARQ))
if ferror() # 0
   ALERTX("Erro na Criacao do Arquivo")
   retu
endif
nARQ  := len(aARQ)
//xGRAF := 0
//xPOS  := 1
//GRAF  := nARQ
//MARCAR()
nLASTREC:= nARQ
zei_fort( nLASTREC,,,0)
for Y := 1 to nARQ
   mARQUIVO   := aARQ[Y]
   mDESCRICAO := aDES[Y]
   MDS(mARQUIVO)
   if cTIPO = "D"
      fwrite(nHANDLE,"|"+replicate('-',78)+"|"+HB_OSNEWLINE())
      fwrite(nHANDLE,'|'+padc(alltrim(mARQUIVO)+".DBF",78)+'|'+HB_OSNEWLINE())
      fwrite(nHANDLE,'|'+padc("Descricao: "+alltrim(mDESCRICAO),78)+'|'+HB_OSNEWLINE())
      fwrite(nHANDLE,"|"+replicate('-',78)+"|"+HB_OSNEWLINE())
      fwrite(nHANDLE,'Sumario dos Campos:'+HB_OSNEWLINE())
      fwrite(nHANDLE,replicate('=',78)+HB_OSNEWLINE())
      fwrite(nHANDLE,''+HB_OSNEWLINE())
   else
      fwrite(nHANDLE,"["+alltrim(mARQUIVO)+".DBF]"+HB_OSNEWLINE())
      fwrite(nHANDLE,"CAMINHO="+ALLTRIM(aCAM[Y])+HB_OSNEWLINE())
      fwrite(nHANDLE,"DRIVER=DBFCDX"+HB_OSNEWLINE())
   endif
   if mARQUIVO # HELPARQ
      IF USEREDE(alltrim(mARQUIVO),1,0,,lMESARQ)   
         if cTIPO = "D"
            fwrite(nHANDLE,str(fcount(),5)+' Campos Definidos'+HB_OSNEWLINE())
         endif
         aESTRU := dbstruct()
         dbclosearea()
      else
         aESTRU := {}
      endif
   else
      dbselectar(HELPARQ)
      if cTIPO = "D"
         fwrite(nHANDLE,str(fcount(),5)+' Campos Definidos'+HB_OSNEWLINE())
      endif
      aESTRU := dbstruct()
   endif
   if cTIPO = "D"
      fwrite(nHANDLE,''+HB_OSNEWLINE())
      fwrite(nHANDLE,"Campo Nome"+spac(7)+"Tipo     Tam Dec Descricao"+HB_OSNEWLINE())
      fwrite(nHANDLE,replicate('-',78)+HB_OSNEWLINE())
   endif
   FIM := len(aESTRU)
   for X := 1 to FIM
      if cTIPO = "D"
         fwrite(nHANDLE,str(X,5)+" ")
         fwrite(nHANDLE,padr(aESTRU[X,1],10)+" ")
         fwrite(nHANDLE,TIPOCAMPO(aESTRU[X,2])+" ")
         fwrite(nHANDLE,str(aESTRU[X,3],3)+" ")
         fwrite(nHANDLE,str(aESTRU[X,4],3)+" ")
      endif
      mCHAVE := padr(mARQUIVO,8)+"M"+padr(aESTRU[X,1],9)
      dbselectar(HELPARQ)
      dbgotop()
      if dbseek(mCHAVE)
         if cTIPO = "D"
            fwrite(nHANDLE,DADO)
         endif
      endif
      if cTIPO = "D"
         fwrite(nHANDLE,HB_OSNEWLINE())
      endif
      dbselectar("DICI")
      dbgotop()
      mCHAVE := padr(mARQUIVO,10)+padr(aESTRU[X,1],10)
      if !dbseek(mCHAVE)
         NETRECAPP()
         field->tabela := mARQUIVO
         field->campo  := aESTRU[X,1]
         field->tipo   := aESTRU[X,2]
         field->tam    := aESTRU[X,3]
         field->dec    := aESTRU[X,4]
      ENDIF
   next X
   aIND := {}
   aIN1 := {}
   aCHA := {}
   while !USEREDE(zARQ1,1,1)
   enddo
   dbseek(padr(mARQUIVO,8)+str(1,2))
   while ARQUIVO = padr(mARQUIVO,8) .and. !eof()
      aadd(aIND,INDICE)
      aadd(aIN1,DESC)
      aadd(aCHA,INDEXP)
      dbskip()
   enddo
   dbclosearea()
   FIM := len(aIND)
   if cTIPO = "D"
      fwrite(nHANDLE,+HB_OSNEWLINE())
      fwrite(nHANDLE,"Sumario dos Indices"+HB_OSNEWLINE())
      fwrite(nHANDLE,replicate('=',78)+HB_OSNEWLINE())
      fwrite(nHANDLE,HB_OSNEWLINE())
      fwrite(nHANDLE,str(FIM,4)+' Indices Definidos:'+HB_OSNEWLINE())
      fwrite(nHANDLE,HB_OSNEWLINE())
      fwrite(nHANDLE,'Nome       Descricao'+HB_OSNEWLINE())
      fwrite(nHANDLE,'           Expressao Chave'+HB_OSNEWLINE())
      fwrite(nHANDLE,replicate('=',78)+HB_OSNEWLINE())
   else
      fwrite(nHANDLE,"NUMMAINTAINED="+str(FIM,1)+HB_OSNEWLINE())
   endif
   if cTIPO = "I"
       fwrite(nHANDLE,"MAINTAIN0="+ALLTRIM(mARQUIVO)+".CDX"+HB_OSNEWLINE())
   endif
   for I := 1 to FIM
      if cTIPO = "D"
         fwrite(nHANDLE,padr(aIND[I],10)+" "+padr(aIN1[I],50)+HB_OSNEWLINE())
         fwrite(nHANDLE,"           "+aCHA[I]+HB_OSNEWLINE())
         fwrite(nHANDLE,"           "+MDPCHAVEI(aCHA[I])+HB_OSNEWLINE())
         fwrite(nHANDLE,"----------"+HB_OSNEWLINE())
      else
         fwrite(nHANDLE,"TAG"   + str(I - 1,1) + "=" + alltrim(aIND[I]) + HB_OSNEWLINE())
         fwrite(nHANDLE,"INDEX" + str(I - 1,1) + "=" + alltrim(aCHA[I]) + HB_OSNEWLINE())
         fwrite(nHANDLE,"INDEXFIELDS" + str(I - 1,1) + "=" + MDPCHAVEI(alltrim(aCHA[I])) + HB_OSNEWLINE())
      endif
   next
   if cTIPO = "I"
      fwrite(nHANDLE,HB_OSNEWLINE())
   endif
   zei_fort(nLASTREC,,,1)
   //xGRAF ++
next Y
dbcloseall()
fclose(nHANDLE)
fixar("DICI")


*+--------------------------------------------------------------------
*+
*+    Function TIPOCAMPO()
*+
*+--------------------------------------------------------------------
*+
function TIPOCAMPO(cTIP)
local cTIPO
do case
   case cTIP = "C"
      cTIPO := "Caracter"
   case cTIP = "N"
      cTIPO := "Numerico"
   case cTIP = "D"
      cTIPO := "Data    "
   case cTIP = "L"
      cTIPO := "Logico  "
   case cTIP = "M"
      cTIPO := "Memo    "
   otherwise
      cTIPO := "????????"
endcase
return cTIPO


FUNCTION MDPCHAVEI(cICHAVE)  //Cria string campo1,campo2,... para create index em sql
LOCAL nPOS
LOCAL cCHAVE
LOCAL cTMPCHV
LOCAL aICampos
LOCAL I
cCHAVE:=""
aicampos:=hb_atokens(cICHAVE,"+")
FOR I=1 TO LEN(aICampos)
    cTMPCHV:=aICampos[I]
    nPOS:=AT("(",cTMPCHV)
    IF nPOS>=0
       cTMPCHV:=SUBSTR(cTMPCHV,nPOS+1)
    ENDIF
    nPOS:=AT("(",cTMPCHV)
    IF nPOS>0
       cTMPCHV:=SUBSTR(cTMPCHV,nPOS+1)
    ENDIF
    nPOS:=AT(")",cTMPCHV)
    IF nPOS>0
       cTMPCHV:=SUBSTR(cTMPCHV,1,nPOS-1)
    ENDIF
    nPOS:=AT(",",cTMPCHV)
    IF nPOS>0
       cTMPCHV:=SUBSTR(cTMPCHV,1,nPOS-1)
    ENDIF
    cCHAVE+=cTMPCHV
    IF I<>LEN(aICAMPOS)
       cCHAVE+=","
    ENDIF
NEXT I
return cCHAVE
