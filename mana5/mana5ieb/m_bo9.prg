// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bo9.prg
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

// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
// +
// +    Source Module => J:\ITAESBRA\M_BO9.PRG
// +
// +    Functions: Function MBO901()
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

// #INCLUDE "COMANDO.CH"

MDI( " þ Saldo de Horas Pelos Processos" )
IF MDG( "Reprocessar Passos da Ordem de Fabrica‡?" )
M_AOY()
ENDIF

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cAE := IMP( "AE" )

aCODC := {}
aCODD := {}
aQTDC := {}
aQTDD := {}
CTLIN := 80
cTIPO := "M"
nFIM  := ZDATA
aMAO  := {}
aQTD  := {}
MDS( "Digite o tipo e data Perido" )
@ 23, 00 SAY "Horas->  E-Equipamantos H-omens T-Terceiros"
@ 23, 30 GET cTIPO                                         VALID cTIPO $ "EHT" PICT "!"
@ 24, 60 GET nFIM
IF !READCUR()
RETU .F.
ENDIF

mARQ1 := ESTQARQ( cTIPO, 1 )

IF !USEREDE( "OF03", 1, 3 )
dbCloseAll()
ENDIF
dbGoTop()
WHILE DLIMP <= nFIM .AND. !Eof()
nSTART := QTTIME * QTFAL
IF nSTART > 0.0001
DO CASE
CASE cTIPO = "E"
MBO901( CODMP01 )
CASE cTIPO = "H"
MBO901( CODMP02 )
MBO901( CODMP02B )
MBO901( CODMP02C )
MBO901( CODMP02D )
CASE cTIPO = "T"
MBO901( CODMP03 )
ENDCASE
ENDIF
dbSkip()
ENDDO
dbCloseArea()

IF !USEREDE( mARQ1, 1, 1 )
RETU .F.
ENDIF
IMPRESSORA()
dbGoTop()
WHILE !Eof()
IF CTLIN > 50
@  0, 0  SAY cAE + "Resumo Estoque/A Processar"
@  1, 00 SAY "M_BO9 "
@  1, 10 SAY "Ate " + DToC( nFIM )
@  1, 60 SAY Time()
@  1, 70 SAY ZDATA
@  2, 0  SAY "Codigo"
@  2, 26 SAY "Nome"
@  2, 66 SAY "     Estoque"
@  2, 78 SAY " A Processar"
@  2, 90 SAY "       Saldo"
@  3, 00 SAY repl( "-", 132 )
CTLIN := 4
ENDIF
@ CTLIN, 0  SAY CODIGO
@ CTLIN, 26 SAY NOME
@ CTLIN, 66 SAY ESTQSAL PICT "@E 9999,999.999"
nPOS := AScan( aMAO, CODIGO )
IF nPOS > 0
@ CTLIN, 78 SAY aQTD[ nPOS ] PICT "@E 9999,999.999"
IF ESTQSAL > 0
nSALDO := ESTQSAL - aQTD[ nPOS ]
@ CTLIN, 90 SAY nSALDO PICT "@E 9999,999.999"
IF nSALDO > 0
AAdd( aCODC, CODIGO )
AAdd( aQTDC, nSALDO )
ELSE
AAdd( aCODD, CODIGO )
AAdd( aQTDD, Abs( nSALDO ) )
ENDIF
ELSE
@ CTLIN, 90 SAY - aQTD[ nPOS ] PICT "@E 9999,999.999"
AAdd( aCODD, CODIGO )
AAdd( aQTDD, aQTD[ nPOS ] )
ENDIF
ELSE
@ CTLIN, 78 SAY 0       PICT "@E 9999,999.999"
@ CTLIN, 90 SAY ESTQSAL PICT "@E 9999,999.999"
AAdd( aCODC, CODIGO )
AAdd( aQTDC, ESTQSAL )
ENDIF
CTLIN++
dbSkip()
ENDDO
dbCloseArea()
IMPFOL()
IF cTIPO $ "EHT"
@  0, 0  SAY cAE + "Resumo Estoque/A Processar - Remanejamento"
@  1, 00 SAY "M_BO9-B "
@  1, 10 SAY "Ate " + DToC( nFIM )
MBO802()
ENDIF
VIDEO()
IMPEND()

// +±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// +
// +    Function MBO901()
// +
// +    Called from ( m_bo9.prg    )   6 - function mbo802()
// +
// +±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBO901()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBO901( cCOD )

   IF Empty( cCOD )
      RETU
   ENDIF
   nPOS := AScan( aMAO, cCOD )
   IF nPOS > 0
      aQTD[ nPOS ] += nSTART
   ELSE
      AAdd( aMAO, cCOD )
      AAdd( aQTD, nSTART )
   ENDIF
   RETU

// + EOF: M_BO9.PRG

// + EOF: m_bo9.prg
// +
