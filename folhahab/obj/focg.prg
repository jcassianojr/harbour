// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : focg.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOCG.PRG: Resumo para Compra de Vale Transporte
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 28/06/98
// :
// :*****************************************************************************
// //#INCLUDE "COMANDO.CH"


IF !MDL( 'Resumo para Compra de Vale Transporte', 0 )
RETU
ENDIF
IF !netuse( "VTCONTA" )
RETU .F.
ENDIF
IF !netuse( "vtfolha" )
dbCloseArea()
RETU .F.
ENDIF

CTLIN := 1
IMPRESSORA()
@ PRow(), 0    SAY IMPSTR( cIMPEXP )
@ PRow(), 00    SAY IMPCHR( cIMPTIT ) + 'Resumo para Compra Vale Transporte'
@ PRow() + 2, 60 SAY Time()
@ PRow(), 70    SAY DXDIA
@ PRow() + 1, 0  SAY REPL( '-', 80 )
@ PRow() + 1, 0  SAY 'COD.'
@ PRow(), 5    SAY 'DESCR'
@ PRow(), 50    SAY 'VALOR'
@ PRow(), 60    SAY 'QUANTIDADE'
@ PRow() + 1, 0  SAY REPL( '-', 80 )

dbSelectAr( "VTCONTA" )
dbGoTop()
WHILE !Eof()
SOMA   := 0
CTX    := CODIGO
FILTRO := 'CONTA=CTX'
dbSelectAr( "VTFOLHA" )
SET FILTER TO &FILTRO
dbGoTop()
WHILE !Eof()
SOMA += HORAS
dbSkip()
ENDDO
SET FILTER TO
SOMA := IF( SOMA # 0, ( Int( ( SOMA + 20 ) / 20 ) * 20 ), 0 )
dbSelectAr( "VTCONTA" )
IF SOMA # 0
@ PRow() + 1, 0 SAY CODIGO
@ PRow(), 5   SAY DESCR
@ PRow(), 50   SAY VALOR  PICT "#,###,###.##"
@ PRow(), 60   SAY SOMA   PICT "########"
ENDIF
dbSkip()
ENDDO
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()
RETU .T.

// + EOF: focg.prg
// +
