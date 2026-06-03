/*****************************************************************************
 * SISTEMA  : ROTINA EVENTUAL                                                *
 * PROGRAMA : DEMO.PRG   		                                     *
 * OBJETIVO : Gerar Xml de Nfe/Nfce                                          *
 * AUTOR    : Marcelo Antonio Lázzaro Carli                                  *
 * DATA     : 23.06.2025                                                     *
 * ULT. ALT.: 15.05.2026                                                     *
 *****************************************************************************/


Procedure Main()
   REQUEST HB_LANG_PT
   REQUEST HB_CODEPAGE_PTISO
   REQUEST HB_CODEPAGE_PT850  &&& PARA INDEXAR CAMPOS ACENTUADOS
   REQUEST DBFCDX, DBFFPT
   HB_LangSelect([PT])
   HB_SETCODEPAGE([PT850])    &&& PARA INDEXAR CAMPOS ACENTUADOS
   HB_SETCODEPAGE([PTISO])    &&& PARA INDEXAR CAMPOS ACENTUADOS
   RDDSETDEFAULT([DBFCDX])
   Set Date Briti             &&& data no formato dd/mm/aaaados
   Set Dele On                &&& ignora registros marcados por deleção
   Set Score Off
   Set Exact On
   Setcancel(.F.)             &&& evitar cancelar sistema c/ ALT + C
   Set Cent On                &&& ano com 4 dígitos
   Set Epoch to 2000          &&& ano a partir de 2000
      SetMode( 25, 80 )
   cls

    fGerarjson()
Return (Nil)



function fGerarjson()
   Local cJsonText:= [], oJson, aNomenclaturas, nItem, oAnexos, nI, nj, cCdx, cNomArq := {}

   /*
   If !Hb_FileExists("tabela_ncm.json")
      alert([Não Existe Arquivo: tabela_ncm.json, Baixe em:] + hb_OsNewLine() + [https://www.unimake.com.br/downloads/tabela_ncm.json], [Atenção])
      Return (Nil)
   Endif

   If !Hb_FileExists("tabela_cest.json")
      alert([Não Existe Arquivo: tabela_cest.json. Baixe em:] + hb_OsNewLine() + [https://www.unimake.com.br/downloads/tabela_cest.json], [Atenção])
      Return (Nil)
   Endif

   If !Hb_FileExists("tabela_nbs.json")
      alert([Não Existe Arquivo: tabela_nbs.json, Baixe em] + hb_OsNewLine() + [https://www.unimake.com.br/downloads/tabela_nbs.json], [Atenção])
      Return (Nil)
   Endif
   */

   If !Hb_FileExists("tabela_ncm.dbf")
      Dbcreate([tabela_ncm], {{[CODIGO]    , [C], 010, 0},;
                              {[DESCRICAO] , [C], 255, 0},;
                              {[DT_INICIO] , [D], 008, 0},;
                              {[DT_FIM]    , [D], 008, 0},;
                              {[TIPO_ATO]  , [C], 030, 0},;
                              {[NUM_ATO]   , [N], 004, 0},;
                              {[ANO_ATO]   , [N], 004, 0},;
                              {[REDUZIDA]  , [C], 050, 0},;  
                              {[CST]       , [C], 003, 0},;
                              {[CCLASSTRIB], [C], 006, 0},;
                              {[ANEXOS]    , [C], 255, 0}})
   Else      
      use tabela_ncm exclusive
      tabela_ncm->(__dbzap())
   Endif

   If !Hb_FileExists("tabela_cest.dbf")
      Dbcreate([tabela_cest], {{[CEST]     , [C], 009, 0},;
                               {[NCM_SH]   , [C], 010, 0},;
                               {[SEG_CEST] , [C], 255, 0},;
                               {[ITEM]     , [C], 010, 0},;
                               {[DESC_CEST], [C], 255, 0},;
                               {[ANEXO]    , [C], 100, 0}})
   Else      
      use tabela_cest exclusive
      tabela_cest->(__dbzap())
   Endif

   If !Hb_FileExists("tabela_nbs.dbf")
      Dbcreate([tabela_nbs], {{[ITEM]     , [C], 005, 0},;
                              {[DESC_ITEM], [C], 255, 0},;
                              {[NBS]      , [C], 012, 0},;
                              {[DESC_NBS] , [C], 255, 0},;
                              {[ONEROSA]  , [C], 001, 0},;
                              {[EXTERIOR] , [C], 001, 0},;
                              {[INDOP]    , [C], 006, 0},;
                              {[LOCAL_INC], [C], 255, 0},;
                              {[CLASSTRIB], [C], 006, 0},;
                              {[DESC_CLAS], [C], 255, 0}})
   Else      
      use tabela_nbs exclusive
      tabela_nbs->(__dbzap())
   Endif

   Dbcloseall()
   HB_SETCODEPAGE([PTISO])

   cFile:= "tabela_ncm.json"
   If Hb_FileExists(cFile)
      use tabela_ncm shared

      cJsonText:= StrTran(Hb_MemoRead(cFile), '"; ', '"=> ' )

      oJson := hb_jsonDecode( cJsonText )
      aNomenclaturas := oJson["Nomenclaturas"]
 
      For nI:= 1 To Len( aNomenclaturas )
          oItem := aNomenclaturas[ nI ]

          tabela_ncm->( DBAppend() )
          tabela_ncm->Codigo   := oItem["Codigo"]
          tabela_ncm->Descricao:= hb_utf8ToStr( oItem["Descricao"], "PTISO" )
          tabela_ncm->Dt_inicio:= CToD( oItem["Data_Inicio"] )
          tabela_ncm->Dt_fim   := CToD( oItem["Data_Fim"] )
          tabela_ncm->tipo_ato := oItem["Tipo_Ato"]
          tabela_ncm->num_ato  := Val(oItem["Numero_Ato"])
          tabela_ncm->ano_ato  := Val(oItem["Ano_Ato"])
          tabela_ncm->Reduzida := SubStr( tabela_ncm->Codigo, 1, 50 )
      
          If HB_HHasKey( oItem, "Anexos" ) .And. HB_ISARRAY( oItem["Anexos"] )
             aAnexos := oItem["Anexos"]
             For nJ:= 1 To Len( aAnexos )
                 oAnexo := aAnexos[ nJ ]
                tabela_ncm->CST        := oAnexo["CST"]
//               tabela_ncm->CclassTrib := oAnexo["cClassTrib"]
             Next
          Endif
      Next

      tabela_ncm->(DbcloseArea())
   Endif

   nItem:= 1
   cFile:= "tabela_cest.json"
   If Hb_FileExists(cFile)
      use tabela_cest shared

      If At(["CEST"], hb_Memoread(cFile)) # 0
         For EACH nItem IN Hb_jsonDecode(hb_Memoread(cFile))
             tabela_cest->(DBAppend())
             tabela_cest->cest     := nItem["CEST"]
             tabela_cest->ncm_sh   := nItem["NCM_SH"]
             tabela_cest->seg_cest := hb_UTF8ToStr(nItem["Segmento_CEST"])
             tabela_cest->item     := nItem["Item"]
             tabela_cest->desc_cest:= hb_UTF8ToStr(nItem["Descricao_CEST"])
             tabela_cest->anexo    := nItem["Anexo_XXVII"]
         Next
      Endif

      tabela_cest->(DbcloseArea())
   Endif

   nItem:= 1
   cFile:= "tabela_nbs.json"
   If Hb_FileExists(cFile)
      use tabela_nbs shared

      If At(["Item_LC_116"], hb_Memoread(cFile)) # 0
         For EACH nItem IN Hb_jsonDecode(hb_Memoread(cFile))
             tabela_nbs->(DBAppend())
             tabela_nbs->item     := nItem["Item_LC_116"]
             tabela_nbs->desc_item:= hb_UTF8ToStr(nItem["Descricao_Item"])
             tabela_nbs->nbs      := nItem["NBS"]
             tabela_nbs->desc_nbs := hb_UTF8ToStr(nItem["Descricao_NBS"])
             tabela_nbs->onerosa  := hb_UTF8ToStr(nItem["PS_Onerosa"])
             tabela_nbs->exterior := nItem["ADQ_Exterior"]
             tabela_nbs->indop    := nItem["IndOP"]
             tabela_nbs->local_inc:= hb_UTF8ToStr(nItem["Local_Incidencia_IBS"])
             tabela_nbs->classtrib:= nItem["cClassTrib"]
             tabela_nbs->desc_clas:= hb_UTF8ToStr(nItem["Nome_cClassTrib"])
         Next
      Endif

      tabela_nbs->(DbcloseArea())
   Endif
   HB_SETCODEPAGE([PT850])
Return

