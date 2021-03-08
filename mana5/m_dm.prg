*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_dm.prg
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

PADRAX(0,,0,{"MEXPOR","MEXPOR1"},"C¢digo ArqOri   Arq.Des  Descri‡„o",;
 "' '+mCODIGO+' '+mARQORI+' '+mARQDES+' '+mDESCRICAO","MDK001","MDK001",;
 ,{|| PADDEL("MEXPOR1",xCHAVE,"CODIGO","xCHAVE")},{|| MDKREP()})


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDKREP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MDKREP


if mdg("Deseja rever Vari veis de Transferencia")
   xCODIGO := mCODIGO
   PADRAO(1,1,0,"MEXPOR1","C¢digo Destino    Origem",;
    "' '+mCODIGO+' '+mVARDES+' '+mVARDRI",;
    "MDK2",,,{|| mCODIGO := xCODIGO},{|| PADARR("MEXPOR1",xCODIGO,"CODIGO","XCODIGO")})
endif
retu .T.

