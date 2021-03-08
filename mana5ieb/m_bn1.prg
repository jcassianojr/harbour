*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\ITAESBRA\M_BN1.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI( " н Imprimir Duplicata a Receber Direto no Formul rio " )

//Checa a Impressora
if !CHECKIMP( 0 )
   return .F.
endif

//Filtro da Listagem
FILTRO := 'IMPDUP#"N".AND.IMPDUP#"I"'
FILTRO := RFILORD( "MN01", .F., FILTRO )
//lCFO:=MDG("Imprimir CFO Novo")

//Abertura do Arquivo
if !USEmult( {{"MA01", 1, 1 },{"MB01", 1, 1},{"MN01", 1, 1}})
   retu
endif
dbselectar("MN01")

if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
if eof()
   dbcloseall()
   retu .F.
endif

set print on
qqout( IMPCHR( 27 ) + 'C' + IMPCHR( 36 ) )
set print OFF

   CTLIN   := 80
   ZPAGINA := 0
   impressora()
   dbselectar( "MN01" )
   dbgotop()
   while !eof()
      @ 03, 49 say impchr(cIMPEXP) + substr( OPERACAO, 1, 4 ) //02,49
      if substr( OPERACAO, 1, 4 ) = "511" .or. substr( OPERACAO, 1, 4 ) = "611"
         @ 03, 54 say '- V E N D A S'
      else
         if substr( OPERACAO, 1, 4 ) = "513" .or. substr( OPERACAO, 1, 4 ) = "613"
            @ 03, 54 say 'MAO DE OBRA'
         endif
      endif
      if CODCOMP = "1"
         @ 04, 49 say 'COMPLEMENTAR'
      endif
      CTLIN := 5
      @ CTLIN, 49 say 'RODOVIARIA'
      CTLIN ++
      @ CTLIN, 49 say DATA
      CTLIN += 4
      @ CTLIN, 17      say NUMERO         pict '999999'
      @ CTLIN, 24      say TIPFAT
      @ prow(), pcol() say impchr(cIMPCOM)
      @ CTLIN, 29      say VALOR - ABATER pict '@E 9,999,999,999.99'
      @ prow(), pcol() say impchr(cIMPEXP)
      @ CTLIN, 51      say NUMERO         pict '999999'
      @ CTLIN, 60      say VENCIMENT
      CTLIN      += 3
      CTLIN      += 1
      mFORNECEDO := FORNECEDO
      mTIPOCLI   := TIPOCLI
      if TIPOCLI = "F"
         dbselectar( "MB01" )
      else
         dbselectar( "MA01" )
      endif
      dbgotop()
      if dbseek( mFORNECEDO )
         @ CTLIN, 23 say " ( " + strzero( mFORNECEDO, 5 ) + " )"
         CTLIN ++
         @ CTLIN, 23 say trim( NOME )
         CTLIN ++
         @ CTLIN, 23 say ENDERECO
         CTLIN ++
         @ CTLIN, 23 say CIDADE
         @ CTLIN, 58 say ESTADO
         CTLIN ++
         if mTIPOCLI = "F"
            @ CTLIN, 23 say trim( ENDERECO ) + ' ' + trim( CIDADE ) + ' ' + trim( ESTADO ) + ' ' + trim( CEP )
         else
            @ CTLIN, 23 say trim( ENDERECO2 ) + ' ' + trim( CIDADE2 ) + ' ' + trim( ESTADO2 ) + ' ' + trim( CEP2 )
         endif
         CTLIN += 2
         @ CTLIN, 23 say CGC
         if mTIPOCLI = "F"
            @ CTLIN, 47 say IESTADUAL
         else
            @ CTLIN, 47 say INSCR
         endif
         CTLIN += 2
      else
         CTLIN += 8
      endif
      dbselectar( "MN01" )
      @ CTLIN, 23 say impchr(cIMPCOM) + EXT( VALOR - ABATER, 1, 80, 80, 0 ) + impchr(cIMPEXP)
      CTLIN ++
      @ CTLIN, 23 say impchr(cIMPCOM) + EXT( VALOR - ABATER, 2, 80, 80, 0 ) + impchr(cIMPEXP)
      CTLIN ++
      @ CTLIN,  1 say IMPCHR( 13 )
      NETGRVCAM("IMPDUP","N")
      dbskip()
   enddo
dbcloseall()
IMPFOL()
video()
set print on
qqout( IMPCHR( 27 ) + 'C' + IMPCHR( 66 ) )
set print OFF
IMPEND()

*+ EOF: M_BN1.PRG
