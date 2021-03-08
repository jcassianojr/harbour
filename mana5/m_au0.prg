*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_au0.prg
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



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_au0()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_au0

para ARQWORK,ARQ2,ARQ3,ARQ3BX,STR3,ARQ4,STR4,ARQ9,ARQI,cSEN,cMENU

AUTOMENU(" Ý Cadastro de "+ARQWORK,cMENU,24)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function iMAU2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func iMAU2()


//Retorna de Referencias
mNOME    := xNOME
mUNIDADE := xUNIDADE
retu .F.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function iMAU3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func iMAU3()


mCODIGO := xCODIGO
MDS("Digite o Codigo do Produto")
@ 24,40 get mCODIGO         
if !READCUR()
   retu .F.
endif
PEGACAMPO(ARQWORK,"mCODIGO",{"NOME","UNIDADE"},{"mNOME","mUNIDADE"})
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAU301()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAU301(cARQUSO,cARQBAI)


if alltrim(wARQ) == alltrim(cARQUSO) .and. !empty(mDATASAI) .and. !empty(mNRNOTASAI) .and. ;
               ! empty(mTOTKGANT) .and. !empty(mTOTKGSAI)
   BAIXAREM(cARQUSO,cARQBAI,mCODIGO+str(mNRNOTAINI))
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function BAIXAREM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func BAIXAREM(cARQUSO,cARQBAI,eCHAVE)


mOLDDIG := mDIGCTR
I       := 0
mDIGCTR := "A"
while VERSEHA(cARQBAI,eCHAVE+mDIGCTR)
   I ++
   mDIGCTR := chr(65+I)
enddo
if NOVOREG(cARQBAI,eCHAVE+mDIGCTR)
   mDATASAI   := ctod(space(8))
   mNRNOTASAI := 0
   mTOTKGANT  := mTOTKGEST
   mTOTKGSAI  := 0
   mTOTKGEST  := 0
   mDIGCTR    := mOLDDIG  //Retorna o Digito Controle Inicial
   if mTOTKGANT > 0
      mTOTKGEST := mTOTKGANT
      REPORVARS(cARQUSO,eCHAVE+mDIGCTR)
   else
      APAGAREG(cARQUSO,eCHAVE+mDIGCTR,.F.,.F.)
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAUBX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAUBX


para ARQWORK,ARQ3,ARQ3BX
if valtype(ARQ3BX) = "C"
   PADRAO(0,1,0,ARQ3,"C¢digo   T Cliente"+spac(12)+"NF Ent.  Saldo   Rastro",;
    "' '+mCODIGO+' '+mTIPOCLI+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mNRNOTAINI,8)+' '+STR(mTOTKGEST,9,2)+' '+mRASTRO","MAU3",,,,;
    ,,,,,{|| MAU301(ARQ3,ARQ3BX)})
else
   PADRAO(0,1,0,ARQ3,"C¢digo   T Cliente"+spac(12)+"NF Sai.  Qtdde",;
    "' '+mCODIGO+' '+mTIPOCLI+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mNRNOTAINI,8)+' '+STR(mTOTKGEST,9,2)+' '+mRASTRO","MAU3")
endif

