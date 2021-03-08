*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib18.prg
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


//#INCLUDE "COMANDO.CH"



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function REGBUS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func REGBUS(cARQ,nIND,cKEYINDEX,lABRE)


local nREGRET := 0
local cIND
local ACHADO  := .F.
local cCOND   := ""
local nREC    := 0
local cTXT    := ''
local aBUS    := {}
local aBUS1   := {}
if valtype(nREG) # "N"
   nREG := 1
endif
if valtype(cKEYINDEX) = "C"
   cKEYINDEX := trim(cKEYINDEX)
endif
if valtype(lABRE) # "L"
   lABRE := .T.
endif
if lABRE
   if !USEREDE(cARQ,1,nIND)
      ALERTX("N„o Consegui Abrir o Arquivo")
      retu nREG
   endif
endif
//   dbgoto( nREG ) //posicionava no atual so fazia pesquisa progressiva
dbgotop()
if dbseek(cKEYINDEX)
   EQUVARS()
   nREGRET  := recno()
   FORMULA  := aIND[1,4]
   VARIAVEL := aIND[1,1,3]
   mCHAVE   := if(empty(FORMULA),&VARIAVEL.,&FORMULA.)
   ACHADO   := .T.
endif
IF valtype(cKEYINDEX) = "N"   //Simula Soft Seek
   if !EOF()
      EQUVARS()
      nREGRET  := recno()
      FORMULA  := aIND[1,4]
      VARIAVEL := aIND[1,1,3]
      mCHAVE   := if(empty(FORMULA),&VARIAVEL.,&FORMULA.)
   ENDIF
ENDIF
IF lABRE
   dbclosearea()
ENDIF
if !ACHADO .and. valtype(cKEYINDEX) = "C"
   if mdg("Fazer Pesquisa Avan‡ada ? ",1)
      IF lABRE
         if !USEREDE(cARQ,1,nIND)
            ALERTX("N„o Consegui Abrir o Arquivo")
            retu nREG
         endif
      ENDIF
      cIND := trim(indexkey(0))
      if !empty(cIND)
         cCOND := '"'+upper(cKEYINDEX)+'"'+"$"+cIND
         locate for &cCOND.
         MDS(padc("Aguarde, localizando ...",80))
         nACHEI := 0
         nREC   := recno()
         while !eof()
            aadd(aBUS,&cIND.)
            aadd(aBUS1,recno())
            if nACHEI = 0
               cTXT := 'Achei: '+trim(padr(&cIND,50))+', continua?'
               if !MDG(cTXT,1)
                  exit
               endif
               nACHEI := 1
            endif
            continue
            MDS(padc("Aguarde, localizando ...",80))
         enddo
         CLSROW(24)
         if len(aBUS) = 1
            EQUVARS()
            nREGRET := recno()
            IF lABRE
               dbclosearea()
            ENDIF
            FORMULA  := aIND[1,4]
            VARIAVEL := aIND[1,1,3]
            mCHAVE   := if(empty(FORMULA),&VARIAVEL.,&FORMULA.)
            retu nREGRET
         endif
         IF lABRE
            dbclosearea()
         ENDIF
         if len(aBUS) = 0
            ALERTX("N„o Encontrado")
            retu nREG
         endif
         nFIL := ESCARR(aBUS,4,5,24 - 3,63,,"Escolha a Pesquisa Desejada")
         nFIL := if(nFIL > 0,nFIL,1)
         IF lABRE
            if !USEREDE(cARQ,1,nIND)
               ALERTX("N„o Consegui Abrir o Arquivo")
               retu nREG
            endif
         ENDIF
         dbgoto(aBUS1[nFIL])
         EQUVARS()
         nREGRET := recno()
         IF lABRE
            dbclosearea()
         ENDIF
         FORMULA  := aIND[1,4]
         VARIAVEL := aIND[1,1,3]
         mCHAVE   := if(empty(FORMULA),&VARIAVEL.,&FORMULA.)
      else
         IF lABRE
            dbclosearea()
         ENDIF
         retu nREG
      endif
      IF lABRE
         dbclosearea()
      ENDIF
   endif
endif
if !ACHADO
   ALERTX("N„o Encontrado")
   retu nREG
endif
retu nREGRET

