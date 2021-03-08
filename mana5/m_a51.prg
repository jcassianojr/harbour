*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_a51.prg
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


PADRAO(0,1,0,ARQWORK,"Codigo - Descricao"+SPAC(47)+"Tipo",;
 "' '+mCODSER+' '+mDESSER+' '+mTIPSER",;
 "MA51","MA5101",{|| gMA51()})


//Get Nas Mvars

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMA51()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gMA51

SETCOLOR(PAD002)
@ 24,1  SAY "Tipo 1-Entrada 2-Sa¡da 3-Servi‡os A-Ent+Sai B+Ent+Ser C-Sai+Ser T(odos)"                                          
@  4,1  SAY mCODSER                                                                                                            
@  4,7  GET mDESSER                                                                                                            
@  4,68 GET mTIPSER                                                                   PICT "!" VALID mTIPSER $ "123ABCT"       
READCUR()
RETU .T.


