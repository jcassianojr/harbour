// +--------------------------------------------------------------------
// +
// +    Programa  : dbu2md.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as 10:07 am
// +
// +--------------------------------------------------------------------
// +

#include "DBINFO.CH"
#include "Dbstruct.ch"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Dbf2md()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION Dbf2md()  

   // Requer Area Aberta
   //Area ja Aberta nivel superior para tratar rdd em uso
   sAlias := Upper( Alias() )
   sXML   := sAlias + ".md"

   hXML := FCreate( sXML, 0 )
   IF hXML == -1
      ALERTX( "Erro Criando md'" )
      RETUrn .F.
   ENDIF

   fWrite( hXML, "# 🗄️ Dicionario de Estruturas de Dados " + sAlias +hb_eol() )
   fWrite( hXML, "> Varredura automatica realizada em: " + DToC(Date()) + hb_eol() + hb_eol() )

   Doc_DBF_md( cFile, hXML )

   FClose( hXML )

   RETURN .T.
   
 Function Doc_DBF_md( sAlias, nHandle )
   LOCAL nI, cTag, cExpr
     
   //Area ja Aberta nivel superior para tratar rdd em uso
   // Abre em modo compartilhado e leitura para evitar travas
   //dbUseArea( .T., "DBFCDX", cFile, "TEMP", .T., .T. )

   IF ! NetErr()
      fWrite( nHandle, "## 📋 Tabela DBF: `" + cFile + "`" + hb_eol() )
      fWrite( nHandle, "| Campo | Tipo | Tam | Dec |" + hb_eol() )
      fWrite( nHandle, "| :--- | :--- | :--- | :--- |" + hb_eol() )

      FOR nI := 1 TO FCount()
         fWrite( nHandle, "| " + FieldName(nI) + " | " + FieldType(nI) + " | " + ;
                 AllTrim(Str(FieldLen(nI))) + " | " + AllTrim(Str(FieldDec(nI))) + " |" + hb_eol() )
      NEXT

      // LISTAR ÍNDICES REAIS
      IF dbOrderInfo( DBOI_ORDERCOUNT ) > 0
         fWrite( nHandle, hb_eol() + "**Índices vinculados:**" + hb_eol() )
         FOR nI := 1 TO dbOrderInfo( DBOI_ORDERCOUNT )
            cTag  := dbOrderInfo( DBOI_NAME, , nI )
            cExpr := dbOrderInfo( DBOI_EXPRESSION, , nI )
            fWrite( nHandle, "- Tag: `" + cTag + "` Expressão: `" + cExpr + "`" + hb_eol() )
         NEXT
      ENDIF

      dbCloseArea()
      fWrite( nHandle, hb_eol() + "---" + hb_eol() )
   ENDIF
RETURN


  



