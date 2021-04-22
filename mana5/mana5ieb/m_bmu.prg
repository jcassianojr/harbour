*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_BMU.PRG
*+
*+    Reformatted by Click! 2.03 on Jul-30-2001 at 11:33 am
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

//#INCLUDE "COMANDO.CH"

MDI( " þ Resumo Duplicatas" )
if !CHECKIMP( 0 )
   retu .F.
endif

//Pegando o Filtro do Relatorio
FILTRO := ''
FILTRO := RFILORD( "MM01", .F. )
aGRU   := {}
aVAL   := {}

aRETU := PEGMES( { "M1" }, .T., { "MM01" } )
ARQNF := aRETU[ 5, 1 ]

if !USEMULT( { { ARQNF, 1, 1 }, { "MD04", 1, 1 }, { "MA01", 1, 1 } } )
   retu .F.
endif

CTLIN := 80
IMPRESSORA()
dbselectar( ARQNF )
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
nREFNUM := 0
while !eof()
   if APURA # "N" .or. CANCELADA = "S"
      mCLIENTE  := FORNECEDO
      mCGC      := ""
      mGRUPO    := ""
      mOPERACAO := left( OPERACAO, 3 )
      lREMESSA  := .F.
      dbselectar( "MD04" )
      dbgotop()
      if dbseek( mOPERACAO )
         if REMESSA = "S"
            lREMESSA := .T.
         endif
      endif
      dbselectar( "MA01" )
      dbgotop()
      if dbseek( mCLIENTE )
         mCGC   := CGC
         mGRUPO := if( empty( GRUPOEMP ), COGNOME, GRUPOEMP )
      endif
      if CTLIN > 50
         @  1, 07 say impchr(cIMPTIT) + "CONTROLE DE DUPLICATAS"
         @  2, 08 say "Data     Numero      Valor" + spac( 6 ) + "Cliente" + spac( 30 ) + "Vencto.|Banco"
         @  3, 07 say "|" + repl( "_", 98 ) + "|"
         CTLIN := 4
      endif
      dbselectar( ARQNF )
      DO CASE
         CASE CANCELADA="S"
              @ CTLIN, 16  say NUMERO      picture '999999'
              @ CTLIN, 27  say "CANCELADA"
              @ CTLIN, 100 say "|"
              CTLIN ++
              @ CTLIN, 07 say "|" + repl( "_", 98 ) + "|"
              CTLIN ++
      CASE lREMESSA
         @ CTLIN, 07  say "|" + dtoc( DATA ) + "|"
         @ CTLIN, 16  say NUMERO          picture '999999'
         @ CTLIN, 29  say "REMESSA"
         @ CTLIN, 36  say "|" + str( FORNECEDO, 5 )
         @ CTLIN, 43  say COGNOME + " " + mCGC + " |"
         @ CTLIN, 100 say "|"
         CTLIN ++
         @ CTLIN, 07 say "|" + repl( "_", 98 ) + "|"
         CTLIN ++
      otherwise
         aDATAS := { DAT01, DAT02, DAT03, DAT04, DAT05, ;
                     DAT06, DAT07, DAT08, DAT09, DAT10 }
         aVALOR := { VAL01, VAL02, VAL03, VAL04, VAL05, ;
                     VAL06, VAL07, VAL08, VAL09, VAL10 }
         for W := 1 to 10
            if !empty( aDATAS[ W ] )
               mTIPFAT := IMPCHR( 64 + W )                  //Tipo do Faturamento (A,B,C...)
               if W = 1 .and. empty( aDATAS[ 2 ] )          //Somente um vencimento
                  mTIPFAT := " "
               endif
               if CTLIN > 50
                  @  1, 07 say impchr(cIMPTIT) + "CONTROLE DE DUPLICATAS"
                  @  2, 08 say "Data     Numero      Valor" + spac( 6 ) + "Cliente" + spac( 30 ) + "Vencto.|Banco"
                  @  3, 07 say "|" + repl( "_", 98 ) + "|"
                  CTLIN := 4
               endif
               set century on
               @ CTLIN, 07 say "|" + dtoc( DATA ) + "|"
               set century OFF
               @ CTLIN, 19  say str( NUMERO, 6 )
               @ CTLIN, 26  say mTIPFAT
               @ CTLIN, 28  say aVALOR[ W ]                 picture '@E 999,999.99'
               @ CTLIN, 39  say "|" + str( FORNECEDO, 5 )
               @ CTLIN, 46  say COGNOME + " " + mCGC + " |"
               @ CTLIN, 79  say dtoc( aDATAS[ W ] ) + "|"
               @ CTLIN, 100 say "|"
               CTLIN ++
               @ CTLIN, 07 say "|" + repl( "_", 98 ) + "|"
               CTLIN ++
               nPOS := ascan( aGRU, mGRUPO )
               if nPOS > 0
                  aVAL[ nPOS, 1 ] += aVALOR[ W ]
                  aVAL[ nPOS, 2 ] ++
               else
                  aadd( aGRU, mGRUPO )
                  aadd( aVAL, { aVALOR[ W ], 1 } )
               endif
            endif
         next W
      endcase
   endif
   dbskip()
enddo
dbcloseall()
IMPFOL()
@  0,  0 say "Resumo"
@  1,  0 say "Grupo"
@  1, 12 say "Valor"
@  1, 27 say "No.Tit"
@  2,  0 say repl( "-", 80 )
CTLIN := 3
for W := 1 to len( aGRU )
   @ CTLIN,  0 say aGRU[ W ]
   @ CTLIN, 12 say aVAL[ W, 1 ] picture '@E 999,999,999.99'
   @ CTLIN, 30 say aVAL[ W, 2 ] pict "9999"
   CTLIN ++
   CTLIN ++
next W
IMPFOL()
VIDEO()
IMPEND()

*+ EOF: M_BMU.PRG
