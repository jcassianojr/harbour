*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_dp.prg
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


// *******************
// * GERA DOCUMENTA€ŽO
// *******************
cARQ := space(50)
cCR  := chr(13)+chr(10)
MDS("Digite o Nome do Arquivo")
@ 24,40 get cARQ pict "@S30"        
if !READCUR()
   retu .F.
endif
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
   if empty(arqANO) .AND. ARQUIVO <> "DICI"
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
   ALERTX("Erro na Cria‡„o do Arquivo")
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
      fwrite(nHANDLE,'Ö'+replicate('-',78)+'·'+cCR)
      fwrite(nHANDLE,'Ý'+padc(alltrim(mARQUIVO)+".DBF",78)+'Ý'+cCR)
      fwrite(nHANDLE,'Ý'+padc("Descri‡„o: "+alltrim(mDESCRICAO),78)+'Ý'+cCR)
      fwrite(nHANDLE,'Ó'+replicate('-',78)+'½'+cCR)
      fwrite(nHANDLE,'Sum rio dos Campos:'+cCR)
      fwrite(nHANDLE,replicate('=',78)+cCR)
      fwrite(nHANDLE,''+cCR)
   else
      fwrite(nHANDLE,"["+alltrim(mARQUIVO)+".DBF]"+cCR)
   endif
   if mARQUIVO # HELPARQ
      IF USEREDE(alltrim(mARQUIVO),1,0)
         if cTIPO = "D"
            fwrite(nHANDLE,str(fcount(),5)+' Campos Definidos'+cCR)
         endif
         aESTRU := dbstruct()
         dbclosearea()
      else
         aESTRU := {}
      endif
   else
      dbselectar(HELPARQ)
      if cTIPO = "D"
         fwrite(nHANDLE,str(fcount(),5)+' Campos Definidos'+cCR)
      endif
      aESTRU := dbstruct()
   endif
   if cTIPO = "D"
      fwrite(nHANDLE,''+cCR)
      fwrite(nHANDLE,"Campo Nome"+spac(7)+"Tipo     Tam Dec Descri‡„o"+cCR)
      fwrite(nHANDLE,replicate('-',78)+cCR)
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
         fwrite(nHANDLE,cCR)
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
      fwrite(nHANDLE,+cCR)
      fwrite(nHANDLE,"Sum rio dos Indices"+cCR)
      fwrite(nHANDLE,replicate('=',78)+cCR)
      fwrite(nHANDLE,cCR)
      fwrite(nHANDLE,str(FIM,4)+' Indices Definidos:'+cCR)
      fwrite(nHANDLE,cCR)
      fwrite(nHANDLE,'Nome       Descri‡„o'+cCR)
      fwrite(nHANDLE,'           Express„o Chave'+cCR)
      fwrite(nHANDLE,replicate('=',78)+cCR)
   else
      fwrite(nHANDLE,"NUMMAINTAINED="+str(FIM,1)+cCR)
   endif
   for I := 1 to FIM
      if cTIPO = "D"
         fwrite(nHANDLE,padr(aIND[I],10)+" "+padr(aIN1[I],50)+cCR)
         fwrite(nHANDLE,"           "+aCHA[I]+cCR)
         fwrite(nHANDLE,"----------"+cCR)
      else
         fwrite(nHANDLE,"MAINTAIN"+str(I - 1,1)+"="+alltrim(aIND[I])+".NTX"+cCR)
         fwrite(nHANDLE,"INDEX"+str(I - 1,1)+"="+alltrim(aCHA[I])+cCR)
      endif
   next
   if cTIPO = "I"
      fwrite(nHANDLE,cCR)
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
      cTIPO := "N£merico"
   case cTIP = "D"
      cTIPO := "Data    "
   case cTIP = "L"
      cTIPO := "L¢gico  "
   case cTIP = "M"
      cTIPO := "Memo    "
   otherwise
      cTIPO := "????????"
endcase
retu cTIPO

