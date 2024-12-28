// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_dc2.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :     M_DC2.PRG : Imprimir etiquetas para lote de pe‡as
// :     Linguagem : Clipper 5.x
// :        Sistema: Mana5 - ITAESBRA
// :      Copyright (c) 1996, Disk Soft S/C Ltda.
// :
// :*****************************************************************************

#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

MDI( " Ý Impress„o de Etiquetas para Lotes de Pe‡as " )

WHILE .T.
CODI  := Space( 30 )
QTDE  := 0
COPIA := 0
@ 11, 16 SAY 'C¢digo da Pe‡a : ' GET CODI
@ 13, 16 SAY 'Quantidade     : ' GET QTDE
@ 15, 16 SAY 'Quantas C¢pias : ' GET COPIA PICT '###'
@ 16, 16 SAY "<ESC> P/ Sair "
IF !READCUR()
EXIT
ENDIF
IF COPIA = 0
EXIT
ENDIF
WHILE !CHECKIMP()
ENDDO
MDS( "Imprimindo..." )
IMPRESSORA()
FOR X := 1 TO COPIA
IF !IsPrinter()
VIDEO()
ALERTX( "Erro Impressora" )
IMPEND()
RETU .F.
ENDIF
@ PRow() + 1, 00 SAY Trim( CODI )
@ PRow(), 33    SAY Trim( CODI )
@ PRow(), 66    SAY Trim( CODI )
@ PRow(), 99    SAY Trim( CODI )
@ PRow() + 2, 00 SAY 'Qtde : ' + Str( QTDE, 5 )
@ PRow(), 33    SAY 'Qtde : ' + Str( QTDE, 5 )
@ PRow(), 66    SAY 'Qtde : ' + Str( QTDE, 5 )
@ PRow(), 99    SAY 'Qtde : ' + Str( QTDE, 5 )
@ PRow() + 2, 00 SAY 'Itaesbra Ind.Mecanica Ltda'
@ PRow(), 33    SAY 'Itaesbra Ind.Mecanica Ltda'
@ PRow(), 66    SAY 'Itaesbra Ind.Mecanica Ltda'
@ PRow(), 99    SAY 'Itaesbra Ind.Mecanica Ltda'
@ PRow() + 4, 00 SAY ""
NEXT X
VIDEO()
ENDDO
IMPEND()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_DC4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_DC4

   mCODIGO   := Space( 24 )
   mQTDUNI   := mQTDEMB := 0
   mPESUNI   := mPESEMB := 0
   mTOTAL    := 0
   mCONTINUA := "S"
   TELASAY( "MDC401" )
   EDITSAY( "MDC401" )
   RETU .T.

// + EOF: m_dc2.prg
// +
