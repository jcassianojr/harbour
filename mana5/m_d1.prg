*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_d1.prg
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


//Modo de Trabalho no Video
MDI("Checagem de CEP/DDD ")

priv HELPDBF := "MD1"


//md1FAZ("","","",{""})
md1FAZ("BD01","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX"})
md1FAZ("MA01","CIDADE","ESTADO",{"DDD","DDD1","DDD2","DDD3","DDDFAX","DDDFAX2","DDDFAX3"})
md1FAZ("CUREMP","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX"})
md1FAZ("MB01","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX","DDDPCP","DDDFAXPCP"})
md1FAZ("MC01","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX","DDDBIP"})
md1FAZ("MC02","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX","DDDBIP"})
md1FAZ("MC03","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX","DDDBIP"})
md1FAZ("MC04","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX","DDDBIP"})
md1FAZ("MC01","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX","DDDBIP"})
md1FAZ("MF02","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX"})
md1FAZ("MF03","CIDADE1","ESTADO1",{,"DDD1","DDF1"})
md1FAZ("MF03","CIDADE2","ESTADO2",{,"DDD2","DDF2"})
md1FAZ("MF05","CIDADE1","ESTADO1",{,"DDD1","DDF1"})
md1FAZ("MF05","CIDADE2","ESTADO2",{,"DDD2","DDF2"})
md1FAZ("MG01","CIDADE","ESTADO",{"DDD","DDD1","DDDFAX","DDDTLX"})


FUNCTION MD1FAZ(cARQ,cESTADO,cCIDADE,aDDD)

aLAT := {"","","","","",""}
cARQ := alltrim(cARQ)

if !USEREDE(cARQ,1,99)
   retu .F.
endif
if !USEREDE("MD10",1,1)
   dbcloseall()
   retu .F.
endif
dbselectar("MD10")
dbgotop()
IF dbseek(zESTADO+zCIDADE)
   aLAT[ 4 ] := LATITUDE
   aLAT[ 5 ] := LONGITUDE
   aLAT[ 6 ] := HEMISFERIO
endif

dbselectar(cARQ)
while !eof()
   mESTADO := &cESTADO.
   mCIDADE := &cCIDADE.
   if mESTADO <> "XX".AND. mESTADO <> "EX"
      dbselectar("MD10")
      dbgotop()
      if dbseek(mESTADO+upper(TIRACE(mCIDADE)))
         lRETU     := .T.
         ZDDD      := DDD
         ZCEP      := INICEP
         ZCEPFIM   := FIMCEP
         ZRUA      := "C"+STRZERO(CEPNUSEQ,6)   //alltrim( ARQUIVO )
         aLAT[ 1 ] := LATITUDE
         aLAT[ 2 ] := LONGITUDE
         aLAT[ 3 ] := HEMISFERIO
         zKM       := calcgeokm(geotodec(aLAT[1],aLAT[3]),geotodec(aLAT[2],aLAT[3]),geotodec(aLAT[4],aLAT[6]),geotodec(aLAT[5],aLAT[6]))
      else
         ZDDD    := ""
         ZCEP    := ""
         ZCEPFIM := ""
         ZKM     := 0
         ZRUA    := ""
      endif
      dbselectar(cARQ)
      for i=1 to len(addd)
          cVAR:=aDDD[I]
          cDDD:=&cVAR.
          if empty(cDDD) .and. ! empty(zddd)
             NETGRVCAM(cVAR,zDDD)
          endif          
      next i
   endif
   dbskip()
enddo
dbcloseall()


*+--------------------------------------------------------------------
*+
*+    Function MD1CHEK01()
*+
*+--------------------------------------------------------------------
function MD1CHEK01(eVAR)
cDDD := alltrim(&eVAR.)
if empty(cDDD) .and. ! empty(zddd)
   NETGRVCAM(eVAR,zDDD)
endif

//if LEN(cDDD) <> 2 .and. !empty(zddd)
//   NETGRVCAM(eVAR,zDDD)
//endif

