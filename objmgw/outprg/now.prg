//#include "minigui.ch"

//function Main()
//  setmode(25,80)

//   alert( Now() )

//return nil

#pragma BEGINDUMP

// If the macro _CRT_SECURE_NO_WARNINGS is already defined, undefine it.
#ifdef _CRT_SECURE_NO_WARNINGS
#undef _CRT_SECURE_NO_WARNINGS
#endif

// Define the macro _CRT_SECURE_NO_WARNINGS to suppress security warnings about certain C runtime functions.
#define _CRT_SECURE_NO_WARNINGS 1

#include <hbapi.h> // Include Harbour API header file.

// If the compiler is not Borland, define _WIN32_WINNT for Windows API compatibility.
#ifndef __BORLANDC__
   #define _WIN32_WINNT 0x0502 // Windows Server 2003 or Windows XP SP2.
#endif

#include <stdio.h>  // Standard I/O functions.
#include <stdlib.h> // Standard library functions.
#include <time.h>   // Time-related functions.

// Include additional headers for network programming.
#ifdef __BORLANDC__
   #include <winsock2.h> // Winsock library for Borland compiler.
#endif

#include <ws2tcpip.h> // Additional TCP/IP functions for Winsock.

// Harbour function declaration.
HB_FUNC( NOW )
{
    struct addrinfo hints; // Hints structure for getaddrinfo configuration.
    struct addrinfo *result; // Pointer to the result of getaddrinfo.
    int sockfd; // Socket file descriptor.
    int rv; // Return value for error checking.
    char buf[64]; // Buffer for storing data.
    time_t now = time(NULL); // Get the current time.
    char str[26]; // Buffer for formatted time string.
    WSADATA wsaData;  // Data structure for initializing Winsock.

    // Initialize Winsock.
    WSAStartup(MAKEWORD(2,2), &wsaData);

    // Clear the hints structure and set configuration for getaddrinfo.
    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_INET; // Use IPv4.
    hints.ai_socktype = SOCK_STREAM; // Use stream sockets (TCP).
    hints.ai_flags = AI_CANONNAME; // Request canonical name resolution.

    // Get address information for the target host.
    rv = getaddrinfo("www.google.com", "http", &hints, &result);
    if (rv != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv)); // Print error message.
        exit(1); // Exit the program with an error.
    }

    // Create a socket using the obtained address information.
    sockfd = socket(result->ai_family, result->ai_socktype, result->ai_protocol);
    if (sockfd == -1) {
        perror("socket"); // Print socket error.
        exit(1); // Exit the program with an error.
    }

    // Connect to the remote host using the socket.
    if (connect(sockfd, result->ai_addr, result->ai_addrlen) == -1) {
        perror("connect"); // Print connection error.
        exit(1); // Exit the program with an error.
    }

    // Send an HTTP GET request to the server.
    snprintf(buf, sizeof(buf), "GET / HTTP/1.0\r\n\r\n"); // Format request string.
    send(sockfd, buf, strlen(buf), 0); // Send the request.

    // Receive response from the server.
    recv(sockfd, buf, sizeof(buf), 0); // Store response in buffer.

    // Format the current time as a human-readable string.
    ctime_s(str, 26, &now);
    snprintf(buf, sizeof(buf), "Current time: %s", str); // Format and store in buffer.

    // Close the socket connection.
    closesocket(sockfd);

    // Free the memory allocated by getaddrinfo.
    freeaddrinfo(result);

    // Return the formatted time string to the Harbour environment.
    hb_retc(buf);
}

#pragma ENDDUMP
