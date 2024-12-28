*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : flib17.prg
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
*+    Documentado em 27-Dez-2024 as  9:44 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// !*****************************************************************************
// !
// !         Fun‡„o: ULTIMOREG() ABRE ARQUIVO PEGA ULTIMO REGISTRO CAMPO
// !
// !   Parametros  : PARAMETRO ARQUIVO,CAMPO,lSOMA
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ULTIMOREG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCtion ULTIMOREG(ARQWORK,FIEWORK,lSOMA)

if valtype(lSOMA) # "L"
   lSOMA := .F.
endif
IF !NETUSE(ARQWORK)
   RETU
ENDIF
DBGOBOTTOM()
RETORNO := &FIEWORK.
DBCLOSEALL()
IF lSOMA .AND. VALTYPE(RETORNO) = "N"
   RETORNO ++
ENDIF
RETU RETORNO



//{|| PEGCHAVE("m",ULTIMOREG(cARQ,cCAMPO,.T.),":")}

*+ EOF: flib17.prg
*+
