// Requer pxlib https://pxlib.sourceforge.net/
// libpx.a -Ic:\mspxlib-0.6.10\include\
// https://github.com/steinm/pxlib 


#include "fileio.ch"

PROCEDURE paradox_to_csv(cDbFile)
  // Local cDbFile  := "siglas.db"
  // Local cCsvFile := "siglas_exportado.csv"
  Local cCsvFile
   Local nHandleCsv
   Local pPxDoc   := NIL
   Local nNumRecords := 0, nNumFields := 0
   Local i, j
   Local cFieldNames := "", cRowData := ""
   
   cCsvFile=HB_FNAMEEXTSET(cDbFile)

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
         total_len += (int) pxdoc->px_head->px_fields[k].px_flen;
      }
      
      int offset = 0;
      int rec_size = (int) pxdoc->px_head->px_recordsize;
      if (total_len < rec_size) {
          offset = rec_size - total_len; 
      }
      
      for( k = 0; k < fieldno; k++ ) {
         offset += (int) pxdoc->px_head->px_fields[k].px_flen;
      }
      
      char *field_ptr = data + offset;
      int ftype = field->px_ftype;
      
      
      
      // Identifica o campo de data (Tipo 2 = Date ou Tipo 21 = Timestamp)
      int is_date_field = (ftype == 2 || ftype == 21) ? 1 : 0;

      if (is_date_field) {
         long days_val = 0;

         //===================================================================
         // Leitura direta da memória para Timestamp (Tipo 21 - 8 bytes)
         //===================================================================
         if (ftype == 21 && field->px_flen == 8) {
            unsigned char *p = (unsigned char *) field_ptr;
            // O Paradox armazena o Timestamp como um Double Big-Endian com o MSB invertido
            unsigned char buf[8];
            buf[0] = p[0] ^ 0x80; // Inverte o bit de sinal
            buf[1] = p[1]; buf[2] = p[2]; buf[3] = p[3];
            buf[4] = p[4]; buf[5] = p[5]; buf[6] = p[6]; buf[7] = p[7];
            
            // Converte para Double de forma segura de Big Endian para Little Endian (padrão do PC)
            unsigned char little_endian[8];
            little_endian[0] = buf[7]; little_endian[1] = buf[6];
            little_endian[2] = buf[5]; little_endian[3] = buf[4];
            little_endian[4] = buf[3]; little_endian[5] = buf[2];
            little_endian[6] = buf[1]; little_endian[7] = buf[0];
            
            double ms_val = 0.0;
            memcpy(&ms_val, little_endian, 8);
            
            // Converte milissegundos transcorridos desde 0001-01-01 para dias
            if (ms_val != 0.0) {
               days_val = (long) (ms_val / 86400000.0);
            }
         } 
         //===================================================================
         // Leitura da memória para Date (Tipo 2 - 4 bytes)
         //===================================================================
         else if (ftype == 2 && field->px_flen == 4) {
            unsigned char *p = (unsigned char *) field_ptr;
            days_val = (((long)(p[0] ^ 0x80)) << 24) |
                       (((long)p[1]) << 16) |
                       (((long)p[2]) << 8) |
                       ((long)p[3]);
         }

         if (days_val != 0) {
            // Algoritmo nativo de conversão Rata Die (Época Paradox: 01/01/0001)
            long rd = days_val - 1; 
            
            // Ciclo de 400 anos
            long n400 = rd / 146097;
            rd %= 146097;
            
            // Ciclo de 100 anos
            long n100 = rd / 36524;
            if (n100 == 4) n100 = 3; // Exceção bissexta
            rd -= n100 * 36524;
            
            // Ciclo de 4 anos
            long n4 = rd / 1461;
            rd %= 1461;
            
            // Ciclo de 1 ano
            long n1 = rd / 365;
            if (n1 == 4) n1 = 3; // Exceção bissexta
            rd -= n1 * 365;
            
            long year = n400 * 400 + n100 * 100 + n4 * 4 + n1 + 1;
            
            // Determina se o ano atual é bissexto
            int is_leap = ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) ? 1 : 0;
            int days_in_month[] = {31, 28 + is_leap, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
            
            // Calcula o mês e o dia com base nos dias restantes
            long month = 1;
            int i_m = 0;
            for (i_m = 0; i_m < 12; i_m++) {
                if (rd < days_in_month[i_m]) break;
                rd -= days_in_month[i_m];
                month++;
            }
            long day = rd + 1;

            if (year >= 1000 && year <= 9999) {
               char dstr[32];
               // Formata exatamente como o Python: YYYY-MM-DD 00:00:00
               snprintf(dstr, sizeof(dstr), "%04ld-%02ld-%02ld 00:00:00", year, month, day);
               hb_retc(dstr);
            } else {
               char dstr[32];
               snprintf(dstr, sizeof(dstr), "%ld", days_val);
               hb_retc(dstr);
            }
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