// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bo8.prg
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

// +膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
// +
// +    Source Module => J:\ITAESBRA\M_BO8.PRG
// +
// +    Functions: Function MBO802()
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
// +
// +膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊

// #INCLUDE "COMANDO.CH"
MDI( "Relatorio Resumo" )

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cAE := IMP( "AE" )

aCODC := {}
aCODD := {}
aQTDC := {}
aQTDD := {}

cTIPO := "S"
cDATA := "A"
nFIM  := ZDATA
@ 22, 00 SAY "(P)roduto (M)at.Prima (C)omponentes E-HE H-HH T-HT"
@ 23, 00 SAY "Data Tipos A-Compra B-Producao C-Pedido"
MDS( "Digite o tipo e data Perido" )
@ 24, 40 GET cTIPO VALID cTIPO $ "PMCEHT" PICT "!"
@ 24, 42 GET cDATA VALID cDATA $ "ABC"    PICT "!"
@ 24, 60 GET nFIM
IF !READCUR()
RETU .F.
ENDIF

mARQ1 := ESTQARQ( cTIPO, 1 )

CTLIN  := 80
FILTRO := ''
FILTRO := RFILORD( mARQ1, .F. )
mARQ2  := TIPORR( cTIPO, 1 )
mARQ3  := TIPORR( cTIPO, 2 )

IF !USEMULT( { { mARQ1, 1, 1 }, { mARQ2, 1, 1 }, { mARQ3, 1, 1 } } )
RETU .F.
ENDIF

dbSelectAr( mARQ1 )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF

IMPRESSORA()
dbSelectAr( mARQ1 )
dbGoTop()
WHILE !Eof()
xCODIGO := CODIGO
nSALDO  := ESTQSAL
nRES    := nNEC := 0
IF CTLIN > 50
@  0, 0  SAY cAE + "Resumo Estoque/Reserva/Necessidades"
@  1, 00 SAY "M_BO8 "
@  1, 10 SAY "Ate " + DToC( nFIM )
DO CASE
CASE cDATA = "A"
@  1, 30 SAY " data de Compra"
CASE cDATA = "B"
@  1, 30 SAY " data de Limite Producao "
CASE cDATA = "C"
@  1, 30 SAY " data do Pedido "
ENDCASE
@  1, 60  SAY Time()
@  1, 70  SAY ZDATA
@  2, 0   SAY "Codigo"
@  2, 26  SAY "Nome"
@  2, 66  SAY "     Estoque"
@  2, 90  SAY "     Reserva"
@  2, 102 SAY " Necessidade"
@  2, 114 SAY "       Saldo"
@  3, 00  SAY repl( "-", 132 )
CTLIN := 4
ENDIF
@ CTLIN, 0  SAY CODIGO
@ CTLIN, 26 SAY NOME
@ CTLIN, 66 SAY ESTQSAL PICT "@E 9999,999.999"
dbSelectAr( mARQ2 )
dbGoTop()
dbSeek( AllTrim( xCODIGO ) )
WHILE AllTrim( xCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
DO CASE
CASE cDATA = "A" .AND. DLIMITE <= nFIM
nRES += QTDDE
CASE cDATA = "B" .AND. DLIMP <= nFIM
nRES += QTDDE
CASE cDATA = "C" .AND. DPEDI <= nFIM
nRES += QTDDE
ENDCASE
dbSkip()
ENDDO
dbSelectAr( mARQ3 )
dbGoTop()
dbSeek( AllTrim( xCODIGO ) )
WHILE AllTrim( xCODIGO ) = AllTrim( CODIGO ) .AND. !Eof()
DO CASE
CASE cDATA = "A" .AND. DLIMITE <= nFIM
nNEC += QTDDE
CASE cDATA = "B" .AND. DLIMP <= nFIM
nNEC += QTDDE
CASE cDATA = "C" .AND. DPEDI <= nFIM
nNEC += QTDDE
ENDCASE
dbSkip()
ENDDO
@ CTLIN, 90  SAY nRES PICT "@E 9999,999.999"
@ CTLIN, 102 SAY nNEC PICT "@E 9999,999.999"
DO CASE
CASE nNEC = 0
@ CTLIN, 114 SAY nSALDO - nRES PICT "@E 9999,999.999"
AAdd( aCODC, XCODIGO )
AAdd( aQTDC, nSALDO - nRES )
OTHERWISE
@ CTLIN, 114 SAY nNEC * -1 PICT "@E 9999,999.999"
AAdd( aCODD, XCODIGO )
AAdd( aQTDD, nNEC )
ENDCASE
CTLIN++
dbSelectAr( mARQ1 )
dbSkip()
ENDDO
dbCloseAll()
IF CTLIN # 80
IMPFOL()
ENDIF
IF cTIPO $ "EHT"
@  0, 0  SAY cAE + "Resumo Estoque/Reserva/Necessidades - Remanejamento"
@  1, 00 SAY "M_BO8-B "
MBO802()
ENDIF
VIDEO()
IMPEND()

// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +
// +    Function MBO802()
// +
// +    Called from ( m_bo8.prg    )   1 - function truncar()
// +                ( m_bo9.prg    )   1 - function mbo802()
// +
// +北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBO802()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBO802

   @  1, 60 SAY Time()
   @  1, 70 SAY ZDATA
   IF Type( "nFIM" ) = "D"
      @  1, 10 SAY "Ate " + DToC( nFIM )
   ENDIF
   @  2, 0  SAY "Codigo"
   @  2, 20 SAY "Remanejando"
   @  2, 46 SAY "Quantidade"
   @  3, 00 SAY repl( "-", 132 )
   CTLIN := 4

   mARQ1 := ESTQARQ( cTIPO, 1 ) + "A"

   VIDEO()
   WHILE !USEREDE( mARQ1, 1, 1 )
   ENDDO
   IMPRESSORA()
   FOR W := 1 TO Len( aCODC )
      aOPCAO  := {}
      zCODIGO := aCODC[ W ]
      nSTART  := aQTDC[ W ]
      dbGoTop()
      dbSeek( zCODIGO )
      WHILE zCODIGO = CODIGO .AND. !Eof()
         AAdd( aOPCAO, CODMPSB )
         dbSkip()
      ENDDO
      FOR Z := 1 TO Len( aOPCAO )
         nPOS := AScan( aCODD, aOPCAO[ Z ] )
         IF nPOS > 0 .AND. nSTART > 0.0001
            nDEB := aQTDD[ nPOS ]
            IF nDEB > 0
               DO CASE
               CASE nDEB = nSTART
                  @ CTLIN, 00 SAY zCODIGO
                  @ CTLIN, 20 SAY aCODD[ nPOS ]
                  @ CTLIN, 40 SAY nDEB        PICT "@E 9999,999.999"
                  nSTART := 0
                  CTLIN++
               CASE nSTART > nDEB
                  @ CTLIN, 00 SAY zCODIGO
                  @ CTLIN, 20 SAY aCODD[ nPOS ]
                  @ CTLIN, 40 SAY nDEB        PICT "@E 9999,999.999"
                  nSTART -= nDEB
                  CTLIN++
               CASE nDEB > nSTART
                  @ CTLIN, 00 SAY zCODIGO
                  @ CTLIN, 20 SAY aCODD[ nPOS ]
                  @ CTLIN, 40 SAY nSTART      PICT "@E 9999,999.999"
                  aQTDD[ nPOS ] -= nSTART
                  nSTART := 0
                  CTLIN++
               ENDCASE
            ENDIF
         ENDIF
      NEXT Z
   NEXT W
   dbCloseArea()
   @ CTLIN, 0 SAY repl( "=", 132 )
   CTLIN++
   FOR W := 1 TO Len( aCODD )
      nDEB := aQTDD[ W ]
      IF nDEB > 0
         @ CTLIN, 20 SAY aCODD[ W ]
         @ CTLIN, 40 SAY nDEB     PICT "@E 9999,999.999"
         CTLIN++
      ENDIF
   NEXT W
   @ CTLIN, 0 SAY repl( "=", 132 )
   CTLIN++
   IMPFOL()
   RETU

// + EOF: M_BO8.PRG

// + EOF: m_bo8.prg
// +
