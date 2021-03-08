#pragma BEGINDUMP

   #define _WIN32_WINNT   0x0400

   #include "windows.h"
   #include "shlobj.h"
   #include "math.h"
   #include "hbapi.h"
   #include "hbvm.h"
   #include "hbstack.h"
   #include "hbapiitm.h"
   #include "hbapigt.h"

   HB_FUNC ( PRINTERSETUP )
   {
      PRINTDLG   pd;
      LPDEVNAMES lpDevNames;

      pd.lStructSize    = sizeof( PRINTDLG );
      pd.hwndOwner   = GetActiveWindow();
      pd.Flags            = PD_PRINTSETUP | PD_USEDEVMODECOPIES | PD_RETURNDC;
      pd.hDevNames   = NULL;

      if ( PrintDlg( &pd ) )
      {
         lpDevNames = (LPDEVNAMES) GlobalLock( pd.hDevNames );
         if( lpDevNames )
         {
            hb_retc( ( LPSTR ) lpDevNames + lpDevNames->wDeviceOffset );

            GlobalUnlock( pd.hDevNames );
         }
         else
            hb_retc( "" );
      }
      else
         hb_retc( "" );
   } 
#pragma ENDDUMP 