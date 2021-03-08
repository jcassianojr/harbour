*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => J:\ITAESBRA\M_BZ1.PRG
*+
*+    Functions: Function MBZ101()
*+               Function MBZ102()
*+               Function MBZCAB()
*+
*+    Reformatted by Click! 2.03 on Oct-4-2004 at  4:44 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI( " þ Imprimir Fluxo Financeiro Dia a Dia " )

DODIA  := ATEDIA := ZDATA
DODI2  := ATEDI2 := ZDATA
SALANT := 0.00
CTLIN  := NRCOPIA := 1
VEZES  := 0
TIPOPG := "V"
TIPORC := "V"
cANAL  := "N"

@ 20, 50 say "(V)encimento (D)Data Documento"
@ 21, 00 say 'Pagar do Dia   : '              get DODIA
@ 21, 32 say 'At‚ o Dia    : '                get ATEDIA
@ 21, 60 say 'Tipo     :'                     get TIPOPG  pict "!"               valid TIPOPG $ "VD"
@ 22, 00 say 'Receber do Dia : '              get DODI2
@ 22, 32 say 'At‚ o Dia    : '                get ATEDI2
@ 22, 60 say 'Tipo     :'                     get TIPORC  pict "!"               valid TIPORC $ "VD"
@ 23, 00 say 'Saldo Anterior : '              get SALANT  pict '@E 999999999.99'
@ 23, 32 say 'Numero Copias:'                 get NRCOPIA
@ 23, 60 say 'Analitico:'                     get cANAL   pict "!"               valid cANAL $ "SN"
if !READCUR()
   retu .F.
endif

aRETU  := PERFEC( { "ML01", "MN01" }, { "ML", "MN" }, { "ML99", "MN99" } )
cARQPG := aRETU[ 5, 1 ]
cARQRC := aRETU[ 5, 2 ]
cCAB   := aRETU[ 7 ]

lCOLTOT2 := .F.
lCOM     := MDG( "Comprimido" )
MDS( 'Zerando Arquivo Fluxo Financeiro' )
ZAPARQ( { { "MZ01", .F., .F. } } )
initvars()
clrvars()
if !USEREDE( "MF01", 1, 1 )
   dbcloseall()
   retu .F.
endif

if cARQPG = "ML01"
   if MDG( "Incluir Contas a Pagar" )
      MDS( 'Carregando o Contas a Pagar' )
      MBZ101( cARQPG, "ML01" )
   endif
   if MDG( "Incluir Contas a Receber" )
      MDS( 'Carregando o Contas a Receber' )
      MBZ101( cARQRC, "MN01" )
   endif
   if MDG( "Incluir Contas Pagas" )
      MDS( 'Carregando o Contas Pagas' )
      MBZ101( "ML01PG", "ATUMLPG" )
      lCOLTOT2 := .T.
   endif
   if MDG( "Incluir Contas Recebidas" )
      MDS( 'Carregando o Contas Recebidas' )
      MBZ101( "MN01PG", "ATUMNPG" )
      lCOLTOT2 := .T.
   endif
else
   if MDG( "Incluir Contas Pagas" )
      MDS( 'Carregando o Contas Pagas' )
      MBZ101( cARQPG, "MLPG" )
   endif
   if MDG( "Incluir Contas Recebidas" )
      MDS( 'Carregando o Contas Recebidas' )
      MBZ101( cARQRC, "MNPG" )
   endif
endif

dbselectar( "MZ01" )
dbgotop()
if eof()
   dbcloseall()
   ALERTX( "N„o h  Movimenta‡„o Para Imprimir !" )
   retu .T.
endif

if !CHECKIMP( 0 )
   retu .F.
endif
cEMP := IMP( "ZEMP" )

IMPRESSORA()
if Lcom
   @  0,  0 say IMPSTR( aCHR[ 1 ] )
endif

while VEZES < NRCOPIA
   VEZES ++
   CTLIN   := 80
   ZPAGINA := 0
   TOTSAL  := SALANT
   TOTSA2  := SALANT
   TOT1    := TOT2 := TOT3 := 0.00
   TOB1    := TOB2 := TOB3 := 0.00
   dbgotop()
   while !eof()

      xVENC  := VENCIMENT               //Guarda data de Vencimento em Var Auxiliar
      TOTREC := TOTPAG := 0.00
      TOTRE2 := TOTPA2 := 0.00

      while VENCIMENT = xVENC .and. !eof()
         do case
         case DEBCRE = 'C'
            TOTREC += VALORS            // totaliza valor a receber por dia
            TOT1   += VALORS
            TOT3   += VALORS
         case DEBCRE = 'D'
            TOTPAG += VALORS            //totaliza valor a pagar por dia
            TOT2   += VALORS
            TOT3   -= VALORS
         case DEBCRE = 'N'
            TOTRE2 += VALORS            // totaliza valor a receber por dia
            TOB1   += VALORS
            TOB3   += VALORS
         case DEBCRE = 'L'
            TOTPA2 += VALORS            //totaliza valor a pagar por dia
            TOB2   += VALORS
            TOB3   -= VALORS
         endcase
         if cANAL = "S"
            MBZCAB()
            @ CTLIN,  0 say NRNOTA
            @ CTLIN,  9 say DATA
            @ CTLIN, 20 say CLIENTE
            @ CTLIN, 29 say COGNOME
            @ CTLIN, 45 say VENCIMENT
            @ CTLIN, 56 say VALORS
            CTLIN ++
         endif
         dbskip()
      enddo

      TOTSAL += TOTREC
      TOTSAL -= TOTPAG
      TOTSA2 += TOTRE2
      TOTSA2 -= TOTPA2

      MBZCAB()

      @ CTLIN, 000 say xVENC
      MBZ102( TOTREC, 10 )
      MBZ102( TOTPAG, 25 )
      MBZ102( TOTSAL, 40 )

      if lCOLTOT2
         MBZ102( TOTRE2, 55 )
         MBZ102( TOTPA2, 70 )
         MBZ102( TOTSA2, 85 )
         MBZ102( TOTSA2 - TOTSAL, 100 )
      endif

      CTLIN ++
      @ CTLIN, 000 say repl( '-', 132 )
      CTLIN ++
   enddo
   @ CTLIN,  0 say repl( '_', 132 )
   CTLIN ++
   @ CTLIN, 000 say "Totais"
   MBZ102( TOT1, 10 )
   MBZ102( TOT2, 25 )
   MBZ102( TOT3, 40 )

   if lCOLTOT2
      MBZ102( TOB1, 55 )
      MBZ102( TOB2, 70 )
      MBZ102( TOB3, 85 )
      MBZ102( TOB3 - TOT3, 100 )
   endif

   CTLIN ++
   @ CTLIN,  0 say repl( '_', 132 )
   CTLIN ++
enddo
VIDEO()
dbcloseall()
release all like M *
IMPEND()
retu

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MBZ101()
*+
*+    Called from ( m_bz1.prg    )   6 -
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
func MBZ101( cARQ, cTIPO )

local nDINI
local nDFIM
nDINI := DODIA
nDFIM := ATEDIA
cVAR  := "VENCIMENT"

if cTIPO = "MN01"
   nDINI := DODI2
   nDFIM := ATEDI2
   if TIPORC = "D"
      cVAR := "DATA"
   endif
else
   if TIPOPG = "D"
      cVAR := "DATA"
   endif
endif
if !USEREDE( cARQ, 1, 1 )               // Contas a Pagar
   dbcloseall()
   retu
endif
INITVARS()
CLRVARS()
dbgotop()
while !eof()
   if ( cTIPO = "MLPG" .or. cTIPO = "MNPG" ) .or. ( &cVAR. >= nDINI .and. ( &cVAR. ) <= nDFIM )
      EQUVARS()
      do case
      case cTIPO = "MLPG" .or. cTIPO = "ATUMLPG"
         @ 24, 70 say NRNOTA
         EQUVARS()
         mVALOR   := mVALOR
         mCLIENTE := mFORNECEDO
         mVALORS  := mVALORPG
         if cTIPO = "MLPG"
            mDEBCRE := 'D'
         else
            mDEBCRE := 'L'
         endif
         mVENCIMENT := mDATAPG
      case cTIPO = "MNPG" .or. cTIPO = "ATUMNPG"
         @ 24, 70 say NUMERO
         mVALOR   := VALOR
         mCLIENTE := mFORNECEDO
         mVALORS  := VALORPG
         mNRNOTA  := mNUMERO
         if cTIPO = "MNPG"
            mDEBCRE := 'C'
         else
            mDEBCRE := 'N'
         endif
         mVENCIMENT := mDATAPG
      case cTIPO = "ML01"
         @ 24, 70 say NRNOTA
         EQUVARS()
         mVALOR   := VALOR
         mCLIENTE := mFORNECEDO
         mVALORS  := VALATUAL
         mDEBCRE  := 'D'
         do case
         case dow( VENCIMENT ) = 1      //Se cai no Domingo
            mVENCIMENT := VENCIMENT + 1                     //2   vai para segunda
         case dow( VENCIMENT ) = 7      //Se cai no S bado
            mVENCIMENT := VENCIMENT + 2                     //3   vai para segunda
         otherwise
            mVENCIMENT := VENCIMENT
         endcase
      case cTIPO = "MN01"
         @ 24, 70 say NUMERO
         mVALOR   := VALOR
         mCLIENTE := mFORNECEDO
         mVALORS  := VALATUAL
         mNRNOTA  := mNUMERO
         mDEBCRE  := 'C'
         mBANCO   := STRZERO(BANCO,3)
         //Banco 99 carteira mesmo dia
         lDIA := .F.
         if BANCO = 99
            lDIA := .T.
         endif
         dbselectar( "MF01" )
         dbgotop()
         if dbseek( mBANCO )
            if FLUXODIA = "S"           //mesmo dia
               lDIA := .T.
            endif
         endif
         dbselectar( carq )
         do case
         case dow( VENCIMENT ) = 1 .and. !lDIA              //Se cai no Domingo
            mVENCIMENT := VENCIMENT + 2
         case dow( VENCIMENT ) = 7 .and. !lDIA              //Se cai no S bado
            mVENCIMENT := VENCIMENT + 3
         case dow( VENCIMENT ) = 6 .and. !lDIA              //Se cai na Sexta-Feira
            mVENCIMENT := VENCIMENT + 3
         case dow( VENCIMENT ) = 1 .and. lDIA               //Se cai no Domingo Segunda
            mVENCIMENT := VENCIMENT + 1
         case dow( VENCIMENT ) = 7 .and. lDIA               //Se cai no Sabado Segunda
            mVENCIMENT := VENCIMENT + 2
         otherwise  //Outros casos,  acrescenta
            if !lDIA
               mVENCIMENT := VENCIMENT + 1                  //mais um dia no vencimento
            endif
         endcase
      endcase
      NOVOOPA( "MZ01", .T., .T. )
   endif
   dbselectar( cARQ )
   dbskip()
enddo
dbselectar( cARQ )
dbclosearea()

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MBZ102()
*+
*+    Called from ( m_bz1.prg    )  14 -
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
func MBZ102( nVALOR, nROW )

if nVALOR > 0
   nROW ++
   @ CTLIN, nROW say trans( nVALOR, '@E 999999,999.99' )
endif
if nVALOR < 0
   @ CTLIN, nROW say "(" + trans( abs( nVALOR ), '@E 999999,999.99' ) + ")"
endif

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MBZCAB()
*+
*+    Called from ( m_bz1.prg    )   2 -
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
func MBZCAB()

if CTLIN > 55
   ZPAGINA ++
   @  0,  0 say cEMP
   @  1, 01 say 'M_BZ1'
   if cARQPG = "ML01"
      @  1, 20 say 'FLUXO FINANCEIRO (A Receber/ A Pagar)'
   else
      @  1, 20 say 'FLUXO FINANCEIRO (Recebidas/Pagas)'
   endif
   @  1, 80  say time()
   @  1, 90  say 'Emitida em: ' + dtoc( ZDATA )
   @  1, 110 say ACENTO( '    P gina: ' ) + str( ZPAGINA, 2 )
   @  2,  0  say repl( '-', 132 )
   @  3,  3  say 'Saldo Anterior : '
   @  3, 20  say SALANT                                       pict '@E 99999,999.99'
   @  4, 00  say 'DIA'
   if cARQPG = "ML01"
      @  4, 010 say 'A  Receber'
      @  4, 025 say 'A  Pagar'
      @  4, 040 say 'Saldo'
      if lCOLTOT2
         @  4, 055 say 'Recebidas'
         @  4, 070 say 'Pagas'
         @  4, 085 say 'Saldo'
         @  4, 100 say 'Dif Saldo'
      endif
   else
      @  4, 010 say 'Recebidas'
      @  4, 025 say 'Pagas'
      @  4, 040 say 'Saldo'
   endif
   @ 05,  0 say repl( '-', 132 )
   CTLIN := 6
endif

*+ EOF: M_BZ1.PRG
