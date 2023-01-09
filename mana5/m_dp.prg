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
FILTRO := ""
FILTRO := RFILORD(zARQ,.F.)
if !USEREDE(zARQ,1,1)
   retu .T.
endif
set filter to &FILTRO
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
   endif
   dbskip()
enddo
dbcloseall()

if !USEREDE(HELPARQ,1,1)
   dbcloseall()
   retu .T.
endif

if !USEREDE("DICI",1,1)
   dbcloseall()
   retu .T.
endif

nHANDLE := fcreate(alltrim(cARQ))
if ferror() # 0
   ALERTX("Erro na Criacao do Arquivo")
   retu
endif
nARQ  := len(aARQ)
xGRAF := 0
xPOS  := 1
GRAF  := nARQ
MARCAR()
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
   endif
   if mARQUIVO # HELPARQ
      IF USEREDE(alltrim(mARQUIVO),1,0,,lMESARQ)   //Function USEREDE(cARQ,nMOD,nIND,cARE,lMES,nTIME)
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
      fwrite(nHANDLE,"Sum rio dos Indices"+HB_OSNEWLINE())
      fwrite(nHANDLE,replicate('=',78)+HB_OSNEWLINE())
      fwrite(nHANDLE,HB_OSNEWLINE())
      fwrite(nHANDLE,str(FIM,4)+' Indices Definidos:'+HB_OSNEWLINE())
      fwrite(nHANDLE,HB_OSNEWLINE())
      fwrite(nHANDLE,'Nome       Descricao'+HB_OSNEWLINE())
      fwrite(nHANDLE,'           Express„o Chave'+HB_OSNEWLINE())
      fwrite(nHANDLE,replicate('=',78)+HB_OSNEWLINE())
   else
      fwrite(nHANDLE,"NUMMAINTAINED="+str(FIM,1)+HB_OSNEWLINE())
   endif
   for I := 1 to FIM
      if cTIPO = "D"
         fwrite(nHANDLE,padr(aIND[I],10)+" "+padr(aIN1[I],50)+HB_OSNEWLINE())
         fwrite(nHANDLE,"           "+aCHA[I]+HB_OSNEWLINE())
         fwrite(nHANDLE,"----------"+HB_OSNEWLINE())
      else
         fwrite(nHANDLE,"MAINTAIN"+str(I - 1,1)+"="+alltrim(aIND[I])+".NTX"+HB_OSNEWLINE())
         fwrite(nHANDLE,"INDEX"+str(I - 1,1)+"="+alltrim(aCHA[I])+HB_OSNEWLINE())
      endif
   next
   if cTIPO = "I"
      fwrite(nHANDLE,HB_OSNEWLINE())
   endif
   xGRAF ++
next Y
dbcloseall()
fclose(nHANDLE)


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function TIPOCAMPO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func TIPOCAMPO(cTIP)


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
retu cTIPO

