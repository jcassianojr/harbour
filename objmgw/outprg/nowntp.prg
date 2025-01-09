// #include "minigui.ch"
function Main()

   setmode(25,80)
   alert(  QualeDataOra()  )

return nil

*------------------------------------------------------------------------------*
Function QualeDataOra()
*------------------------------------------------------------------------------*
  // Local IpOra := hb_socketResolveInetAddr( "time.google.com", 123 )
  Local cDateTime , rtv, IpOra

  IpOra := hb_socketResolveInetAddr( "time.google.com", 123 )
  // Or via direct ip  
  // IpOra := hb_socketResolveInetAddr( "216.239.35.12"/* "time.google.com"*/, 123 )

  if valtype(ipora)=="A"
     cDateTime := cDate_Time:= Alltrim(GETNTPDATE(  IpOra[2] ))    
  Else
     cDateTime := "Invalid Date time"
  Endif

/*****************************************
* Outros NTP Server IP:
* 200.160.7.186
* 200.186.125.195
* 200.20.186.76
* 201.49.148.135
* 200.160.7.193
* 200.160.0.8
* 200.189.40.8
* 200.192.232.8
* 204.123.2.72
* 31.28.161.71
*****************************************/

Return cDateTime

#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"

#include <winsock.h>
#include <time.h>

#define MAXLEN 1024

HB_FUNC( GETNTPDATE )
{
   char * hostname = ( char * ) hb_parc( 1 );
   char msg[ 48 ] = { 010, 0, 0, 0, 0, 0, 0, 0, 0 };   // the packet we send
   long buf[ MAXLEN ]; // the buffer we get back
   struct sockaddr_in server_addr;
   uint32_t  s;  // socket
   WSADATA wsa;
   struct timeval timeout;
   fd_set fds;
   time_t tmit;

   WSAStartup( 0x101, &wsa );

   s = socket( PF_INET, SOCK_DGRAM, getprotobyname( "udp" )->p_proto );

   memset( &server_addr, 0, sizeof( server_addr ) );
   server_addr.sin_family = AF_INET;
   server_addr.sin_addr.s_addr = inet_addr( hostname );
   server_addr.sin_port = htons( 123 ); // ntp port

   sendto( s, msg, sizeof( msg ), 0, ( struct sockaddr * ) &server_addr, sizeof( server_addr ) );

   FD_ZERO( &fds );
   FD_SET( s, &fds );
   timeout.tv_sec = 10;
   timeout.tv_usec = 0;

   if( select( 0, &fds, NULL, NULL, &timeout ) )
   {
      recv( s, ( void * ) buf, sizeof( buf ), 0 );

      tmit = ntohl( buf[ 10 ] );
      tmit-= 2208988800U;
   }
   else
      MessageBox( 0, "Problems connecting to the internet.\n\nI can't read the date from the NTP server!","", 0 );

   WSACleanup();

   hb_retc( ctime( &tmit ) );
}

#pragma ENDDUMP

