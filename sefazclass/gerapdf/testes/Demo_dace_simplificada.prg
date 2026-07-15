/*****************************************************************************
 * SISTEMA  : ROTINA EVENTUAL                                                *
 * PROGRAMA : DEMO_DACE_SIMPLIFICADA.PRG                                     *
 * OBJETIVO : Demo para Gerar DACE Simplificada                              *
 * AUTOR    : Marcelo Antonio Lázzaro Carli                                  *
 * DATA     : 15.07.2026                                                     *
 * ULT. ALT.: 15.07.2026                                                     *
 *****************************************************************************/

Procedure Main()
   REQUEST HB_LANG_PT
   REQUEST HB_CODEPAGE_PTISO
   REQUEST HB_CODEPAGE_PT850  &&& PARA INDEXAR CAMPOS ACENTUADOS
   REQUEST DBFCDX, DBFFPT
   HB_LangSelect([PT])

   Set Wrap On
   Set Talk Off
   Set Date Briti             &&& data no formato dd/mm/aaaados
   Set Dele On                &&& ignora registros marcados por deleção
   Set Score Off
   Set Exact On
   Setcancel(.F.)             &&& evitar cancelar sistema c/ ALT + C
   Set Cent On                &&& ano com 4 dígitos
   Set Epoch to 2000          &&& ano a partir de 2000
   Set Excl Off               &&& abre arquivos em modo compartilhado
   Set(_SET_DEBUG, .F.)       &&& introduzida na build 24.05 (Standard)

   DCe_Simplificada("nfe_teste_danfe_simplificado.xml")
   
Return (Nil)