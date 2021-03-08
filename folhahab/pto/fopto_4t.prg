*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Source Module => FOPTO_4t.PRG
*+
*+    Functions: Function iFOPTO4t()
*+               Function gFOPTO4t()
*+               Function tFOPTO4t()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡


//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

cPO := "PO" + ANOMESW

CHECKCRI( cPO, "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )

PADRAO( cPO, cPO, "' '+STR(mNUMERO,  8)+' '+DTOC(mOCOINI)+' '+DTOC(mOCOFIM)+' '+mOCOCOD+' '+mOCOSUB+' '+mOCOBCO+' '+mOCOFOL+' '+mOCOEXT+' '+mABONA+' '+mCESTA", ;
        "STR(mNUMERO,8)+DTOS(mOCOINI)", ;
        "FOPTO_4T - Cadastro de Ocorrencias", ;
        "Numero     Periodo          CodSubBHFOEXABCB", ;
        { || iFOPTO4t() }, { || tFOPTO4t() }, { || gFOPTO4t() }, { || ALLTRUE() },, 2,,,Ztipvid  )


return .T.

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function iFOPTO4t()
*+
*+    Called from ( fopto_4t.prg )   1 - function tfopto4j()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function iFOPTO4t

MDS( "Digite o Numero e a data Inicio" )
@ 24, 40 get mNUMERO
@ 24, 50 get mOCOINI
READCUR()
mCHAVE := str( mNUMERO, 8 ) + dtos( mOCOINI )
return .T.

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function gFOPTO4t()
*+
*+    Called from ( fopto_4t.prg )   1 - function tfopto4j()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
function gFOPTO4t
verpassagens(mNUMERO,mOCOINI,.T.,.T.)
@  6, 1 say mNUMERO
@  6,10 say mOCOINI
@  6,19 get mOCOFIM
@  6,28 get mOCOCOD
@  6,31 get mOCOSUB
@  7,25 get mOCORED pict "!" valid mOCORED $ "SN "
@  8,25 get mOCOBCO pict "!" valid mOCOBCO $ "SN "
@  9,25 get mOCOFOL pict "!" valid mOCOFOL $ "SNVM "
@ 10,25 get mOCOEXT pict "!" valid mOCOEXT $ "SNVTZA5 "         
@ 11,25 get mOCOALM pict "!" valid mOCOALM $ "ABCDESN "
@ 12,25 get mABONA  pict "!" valid mABONA  $ "PSNC "
@ 12,27 GET mHRABO  pict '999.99'
@ 13,25 get mCESTA  pict "!" valid mCESTA  $ "PAMFTVCJ "
@ 13,27 get mHRREL  pict '999.99'
@ 15,10 get mMOTIVO VALID ALLTRUE(IF(EMPTY(mOCOMOT),mOCOMOT:=OBTER( "FOPTOMOT",,mMOTIVO, "NOME"),""))
@ 16, 1 get mOCOMOT valid ! empty(mOCOMOT)
@ 17,5  get mCID   VALID ALLTRUE(VERSEHA("CID",,mCID,"NOME","'Codigo CID nao Cadastrado'"))   
@ 17,20 GET mESITU VALID ALLTRUE(CHECKTAB("SITU"+mESITU,24,0,"Situação não Cadastrado"))
READCUR()
retuRN .T.

*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Function tFOPTO4t()
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
funcTION tFOPTO4t
HB_SCROLL(2, 0, 23, 79)
HB_dispbox( 2, 0, 23, 79, B_DOUBLE+" ")
@  5,  1 say "Numero   Inicio   Fim     Cod Sub"
@  7,  1 say 'Reducao de Horario  SN'
@  8,  1 say 'Banco de Horas      SN'
@  9,  1 say 'Folga Indicada    SNVM'
@ 10,  1 say 'Hora Extra        SNVT'
@ 11,  1 SAY 'Almoco         ABCDESN'
@ 12,  1 say 'Abonada(C)omp(P)ularSN'
@ 13,  1 say 'Cesta Basica          '
@ 14,  1 say '(P)ular(A)traso(M)edico(F)alta Acid(T)rab Ad(V)ertencia(C)racha Falta(J)us'
@ 15,  1 say "Motivo:"
@ 17,  1 say "CID:"
@ 17, 10 SAY "esocial:"
retuRN .T.


*+ EOF: FOPTO_4t.PRG
