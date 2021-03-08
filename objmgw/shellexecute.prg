
#pragma begindump

#include "windows.h"
#include "hbapi.h"
#include "shellapi.h"

HB_FUNC( SHELLEXECUTE )
{
    hb_retnl( ( LONG ) ShellExecute( ( HWND ) hb_parnl( 1 ),
hb_parc( 2 ), hb_parc( 3 ), hb_parc( 4 ), hb_parc( 5 ), hb_parni(
6 ) ) );

}

#pragma enddump

// Usage: ShellExecute( 0, 0, <program_to_execute>,  <commandline_parameter>, 0, 1 )