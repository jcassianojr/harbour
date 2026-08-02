#include "fileio.ch"

PROCEDURE Main()
   Local cDbFile  := "siglas.db"
   Local cCsvFile := "siglas_exportado.csv"
   Local nHandleCsv
   Local pPxDoc   := NIL
   Local nNumRecords := 0, nNumFields := 0
   Local i, j
   Local cFieldNames := "", cRowData := ""

   IF !File( cDbFile )
      ? "Arquivo Paradox nao encontrado: " + cDbFile
      RETURN
   ENDIF

   ? "Iniciando a leitura do Paradox via pxlib estatica..."

   pPxDoc := PX_New()
   
   IF pPxDoc == 0 .OR. pPxDoc == NIL
      ? "Erro ao instanciar PX_New()"
      RETURN
   ENDIF

   IF PX_Open_File( pPxDoc, cDbFile ) == 0
      
      nHandleCsv := FCreate( cCsvFile )
      IF nHandleCsv == -1
         ? "Erro ao criar o arquivo CSV de saida."
         PX_Close( pPxDoc )
         PX_Delete( pPxDoc )
         RETURN
      ENDIF

      nNumRecords := PX_Get_Num_Records( pPxDoc )
      nNumfields  := PX_Get_Num_Fields( pPxDoc )

      ? "Total de Registros: " + AllTrim( Str( nNumRecords ) )
      ? "Total de Campos: " + AllTrim( Str( nNumfields ) )

      // Escreve o nome dos campos no CSV
      FOR j := 0 TO nNumfields - 1
         cFieldNames += PX_Get_Field_Name( pPxDoc, j ) + If( j < nNumfields - 1, ";", "" )
      NEXT
      FWrite( nHandleCsv, cFieldNames + hb_eol() )

      // Varre todos os registros da tabela Paradox
      FOR i := 0 TO nNumRecords - 1
         cRowData := ""
         FOR j := 0 TO nNumfields - 1
            cRowData += hb_valtostr( PX_Get_Field_Val( pPxDoc, i, j ) ) + If( j < nNumfields - 1, ";", "" )
         NEXT
         
         FWrite( nHandleCsv, cRowData + hb_eol() )
      NEXT

      FClose( nHandleCsv )
      PX_Close( pPxDoc )
      ? "Arquivo CSV gerado com sucesso: " + cCsvFile
   ELSE
      ? "Erro ao abrir o arquivo Paradox via PX_Open_File."
   ENDIF

   PX_Delete( pPxDoc )

RETURN

#pragma BEGINDUMP

#include <hbapi.h>
#include <paradox.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

HB_FUNC( PX_NEW )
{
   hb_retnl( (HB_LONG) (HB_PTRDIFF) PX_new() );
}

HB_FUNC( PX_OPEN_FILE )
{
   pxdoc_t *pxdoc = (pxdoc_t *) (HB_PTRDIFF) hb_parnl( 1 );
   const char *filename = hb_parc( 2 );
   hb_retni( PX_open_file( pxdoc, (char * ) filename ) );
}

HB_FUNC( PX_CLOSE )
{
   pxdoc_t *pxdoc = (pxdoc_t *) (HB_PTRDIFF) hb_parnl( 1 );
   PX_close( pxdoc );
}

HB_FUNC( PX_DELETE )
{
   pxdoc_t *pxdoc = (pxdoc_t *) (HB_PTRDIFF) hb_parnl( 1 );
   PX_delete( pxdoc );
}

HB_FUNC( PX_GET_NUM_RECORDS )
{
   pxdoc_t *pxdoc = (pxdoc_t *) (HB_PTRDIFF) hb_parnl( 1 );
   hb_retnl( (HB_LONG) pxdoc->px_head->px_numrecords );
}

HB_FUNC( PX_GET_NUM_FIELDS )
{
   pxdoc_t *pxdoc = (pxdoc_t *) (HB_PTRDIFF) hb_parnl( 1 );
   hb_retni( pxdoc->px_head->px_numfields );
}

HB_FUNC( PX_GET_FIELD_NAME )
{
   pxdoc_t *pxdoc = (pxdoc_t *) (HB_PTRDIFF) hb_parnl( 1 );
   int fieldno = hb_parni( 2 );
   if( pxdoc && pxdoc->px_head && fieldno >= 0 && fieldno < pxdoc->px_head->px_numfields ) {
      hb_retc( (char *) pxdoc->px_head->px_fields[fieldno].px_fname );
   } else {
      hb_retc( "" );
   }
}

HB_FUNC( PX_GET_FIELD_VAL )
{
   pxdoc_t *pxdoc = (pxdoc_t *) (HB_PTRDIFF) hb_parnl( 1 );
   int recno = hb_parni( 2 );
   int fieldno = hb_parni( 3 );
   
   char *data = (char *) malloc( pxdoc->px_head->px_recordsize );
   if( data ) {
      memset(data, 0, pxdoc->px_head->px_recordsize);
      PX_get_record(pxdoc, recno, data);
      
      pxfield_t *field = &pxdoc->px_head->px_fields[fieldno];
      
      int total_len = 0;
      int k;
      for( k = 0; k < pxdoc->px_head->px_numfields; k++ ) {
         total_len += pxdoc->px_head->px_fields[k].px_flen;
      }
      
      int offset = 0;
      if (total_len < pxdoc->px_head->px_recordsize) {
          offset = pxdoc->px_head->px_recordsize - total_len; 
      }
      
      for( k = 0; k < fieldno; k++ ) {
         offset += pxdoc->px_head->px_fields[k].px_flen;
      }
      
      char *field_ptr = data + offset;
      int ftype = field->px_ftype;
      char *fname = (char *) field->px_fname;
      
      // Se o nome do campo for HireDate (ou conter Date), força o tratamento de data independente do ftype
      int is_date_field = 0;
      if (fname && (strcasecmp(fname, "HireDate") == 0 || strcasecmp(fname, "Date") == 0 || ftype == 2)) {
         is_date_field = 1;
      }

      if (is_date_field) {
         long val = 0;
         PX_get_data_long(pxdoc, field_ptr, field->px_flen, &val);
         if (val != 0 && val > 0 && val < 3000000) { // Faixa segura de dias julianos
            long J = val + 1721425; 
            long l = J + 68569;
            long n = ( 4 * l ) / 146097;
            l = l - ( 146097 * n + 3 ) / 4;
            long i = ( 4000 * ( l + 1 ) ) / 1461001;
            l = l - ( 1461 * i ) / 4 + 31;
            long j = ( 80 * l ) / 2447;
            long d = l - ( 2447 * j ) / 80;
            l = j / 11;
            long m = j + 2 - ( 12 * l );
            long y = 100 * ( n - 49 ) + i + l;
            
            // Buffer seguro de 32 bytes elimina totalmente o warning do GCC
            char dstr[32];
            sprintf(dstr, "%04ld-%02ld-%02ld", y, m, d);
            hb_retc(dstr);
         } else {
            hb_retc(""); 
         }
      }
      else if (ftype == 3) { 
         short val = 0;
         PX_get_data_short(pxdoc, field_ptr, field->px_flen, &val);
         hb_retni( (int) val );
      }
      else if (ftype == 4 || ftype == 22) { 
         long val = 0;
         PX_get_data_long(pxdoc, field_ptr, field->px_flen, &val);
         hb_retnl( (HB_LONG) val );
      }
      else if (ftype == 5 || ftype == 6) { 
         double val = 0.0;
         PX_get_data_double(pxdoc, field_ptr, field->px_flen, &val);
         hb_retnd( val );
      }
      else {
         char *valstr = NULL;
         if( PX_get_data_alpha(pxdoc, field_ptr, field->px_flen, &valstr) == 0 && valstr ) {
            hb_retc( valstr );
            free( valstr );
         } else {
            char *buf = (char *) malloc( field->px_flen + 1 );
            memcpy( buf, field_ptr, field->px_flen );
            buf[field->px_flen] = '\0';
            for( int z = 0; z < field->px_flen; z++ ) {
                if( buf[z] < 32 || buf[z] > 126 ) buf[z] = ' ';
            }
            hb_retc( buf );
            free( buf );
         }
      }
      free( data );
   } else {
      hb_retc( "ERR_MEM" );
   }
}

#pragma ENDDUMP