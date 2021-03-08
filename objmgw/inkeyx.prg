//InkeyGUI([<nMilliSec>])
#pragma BEGINDUMP

#include <windows.h>

#include "hbapi.h"

HB_FUNC( INKEYGUI ) 
{                                   
  MSG Msg; 
  BOOL lNoLoop=FALSE; 
  UINT dwTimer, nRet=0, uTimeout=10; 

  if( HB_ISNUM(1) ) uTimeout = hb_parni(1); 

  if( uTimeout==0 ) uTimeout = 0x0FFFFFFF; 

  dwTimer = SetTimer( NULL, 0, uTimeout, NULL); 

  while( GetMessage(&Msg, NULL, 0, 0) ) 
  { 

   switch( Msg.message ) 
   { 
     case WM_KEYDOWN  : 
     case WM_SYSKEYDOWN : { nRet  = Msg.wParam; lNoLoop = TRUE; break; } 
     case WM_TIMER   : { lNoLoop = Msg.wParam == dwTimer;   break; } 
   } 
 
   if( lNoLoop ) 
   { 
     KillTimer( NULL, dwTimer ); 
     hb_retni( nRet ); 
     return ; 
   } 
   else 
   { 
     TranslateMessage( &Msg ); // Translates virtual key codes 
     DispatchMessage( &Msg ); // Dispatches message to window 
   } 
  } 
} 

#pragma ENDDUMP
