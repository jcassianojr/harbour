*+
*+
*+    Source Module => J:\ITAESBRA\M_BO6.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+

MDI( "þ Aviso de Embarque" )
para nTIPO

nNUMERO  := 0
mFATURA  := 0
nCLIENTE := 0
nDEC     := 0
nSEQ     := 0
cPLANTA  := "C1 "
cDOCA    := "B1" + space( 12 )
cCAMINHO := "\CDA\TXT\" + space( 40 )
cTIME    := strtran( time(), ":", "" )
cENTREGA := substr( dtos( ZDATA + 1 ), 3 )

aRETU := PEGMES( { "M1", "M2" }, .T., { "MM01", "MM02" } )
xARQ  := aRETU[ 5, 1 ]
xAR2  := aRETU[ 5, 2 ]

cDATA := substr( dtos( ZDATA ), 3 )

if nTIPO = 1        //GM
   cASSUNTO := "GMB.AVISO.PROD" + space( 60 )
endif
if nTIPO = 2        //FORD
   cASSUNTO := "DUT.P5VFBR.RVS.ASN" + space( 59 )
endif

cTIPO := "P"

@ 10, 00 say "Digite o Numero da Nota Fiscal/ Fatura"
@ 11, 00 say "Digite o Numero Sequencial"
@ 12, 00 say "Digite o Codigo da Planta/Doca"
@ 13, 00 say "Caminho"
@ 14, 00 say "Assunto"
@ 15, 00 say "Tipo Fornecimento"
@ 16, 00 say "Data Hora:"
@ 17, 00 say "Entrega:"
@ 15, 22 say "(R)eposicao (P)roducao (E)xportacao (X)Outros (A)mostra"
@ 10, 40 get nNUMERO                                                   valid ALLTRUE( PEGACAMPO( xARQ, "nNUMERO", "FORNECEDO", "nCLIENTE" ) ) ;
        .and. ALLTRUE( PEGACAMPO( "MA01", "nCLIENTE", { "PLANTA", "DOCA" }, { "cPLANTA", "cDOCA" } ) )
@ 10, 50 get mFATURA
@ 11, 40 get nSEQ
@ 12, 40 get cPLANTA
@ 12, 50 get cDOCA
@ 13, 15 get cCAMINHO
@ 14, 20 get cASSUNTO
@ 15, 20 get cTIPO    pict "!" valid cTIPO $ "RPEXA"
@ 16, 20 get cTIME
@ 16, 30 get cDATA
@ 17, 20 get cENTREGA
if !READCUR()
   retu .F.
endif

lCONV := MDG( "Converter Unidade" )

cARQ  := alltrim( cCAMINHO ) + "AE" + strzero( nSEQ, 5 ) + ".TXT"
cARQ2 := alltrim( cCAMINHO ) + "MGR" + strzero( nSEQ, 5 ) + ".ENV"

if !USEREDE( xARQ, 1, 1 )
   retu .F.
endif

dbselectar( xARQ )
dbgotop()
if !dbseek( nNUMERO )
   dbcloseall()
   ALERTX( "Nao achei Nota Fiscal" )
   retu .F.
endif

if !USEREDE( xAR2, 1, 1 )
   dbcloseall()
   retu .F.
endif
if !lCONV           //Pegando casas
   dbgotop()
   dbseek( str( nNUMERO, 8 ) )
   while NUMERO = nNUMERO .and. !eof()
      do case
      case UNID = "CT"
         nDEC := 2
      case UNID = "ML"
         nDEC := 3
      endcase
      dbskip()
   enddo
endif
if !USEREDE( "MO01", 1, 1 )
   dbcloseall()
   retu .F.
endif

//Arquivo ENDV
nHANDLE := fcreate( alltrim( cARQ2 ) )
if ferror() # 0
   ALERTX( "Erro na Criacao do Arquivo" )
   retu
endif
fwrite( nHANDLE, "AE" + strzero( nSEQ, 5 ) + ".TXT" + chr( 13 ) + chr( 10 ) )
fwrite( nHANDLE, alltrim( cASSUNTO ) + chr( 13 ) + chr( 10 ) )
if nTIPO = 1        //GM
   fwrite( nHANDLE, "27459" + chr( 13 ) + chr( 10 ) )
endif
if nTIPO = 2        //FORD
   fwrite( nHANDLE, "41195" + chr( 13 ) + chr( 10 ) )
endif

fwrite( nHANDLE, chr( 26 ) )
fclose( nHANDLE )

nHANDLE := fcreate( alltrim( cARQ ) )
if ferror() # 0
   ALERTX( "Erro na Criacao do Arquivo" )
   retu
endif
dbselectar( xARQ )
nREG := 0
//ITP
nREG ++
fwrite( nHANDLE, "ITP" )
fwrite( nHANDLE, "004" )
fwrite( nHANDLE, "04" )
fwrite( nHANDLE, strzero( nSEQ, 5 ) )
fwrite( nHANDLE, cDATA )
fwrite( nHANDLE, cTIME )
fwrite( nHANDLE, "61381323000167" )
if nTIPO = 1        //GM
   fwrite( nHANDLE, "59275792000150" )
endif
if nTIPO = 2        //FORD
   fwrite( nHANDLE, "57290355001313" )
endif
fwrite( nHANDLE, space( 8 ) )
fwrite( nHANDLE, space( 8 ) )
fwrite( nHANDLE, space( 25 ) )
fwrite( nHANDLE, space( 25 ) )
fwrite( nHANDLE, space( 9 ) )
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
//AE1
nREG ++
fwrite( nHANDLE, "AE1" )
if empty( mFATURA )
   fwrite( nHANDLE, strzero( nNUMERO, 6 ) )
else
   fwrite( nHANDLE, strzero( mFATURA, 6 ) )
endif
fwrite( nHANDLE, "    " )
fwrite( nHANDLE, substr( dtos( DATA ), 3 ) )                //MM01
fwrite( nHANDLE, "000" )
fwrite( nHANDLE, strtran( strzero( TOTNF, 18, 2 ), ".", "" ) )
if !lCONV           // Casas decimais
   fwrite( nHANDLE, str( nDEC, 1 ) )
else
   fwrite( nHANDLE, "0" )
endif
fwrite( nHANDLE, left( OPERACAO, 3 ) )
fwrite( nHANDLE, strtran( strzero( TOTICM, 18, 2 ), ".", "" ) )
fwrite( nHANDLE, substr( dtos( DAT01 ), 3 ) )
fwrite( nHANDLE, "00" )
fwrite( nHANDLE, strtran( strzero( TOTIPI, 18, 2 ), ".", "" ) )
fwrite( nHANDLE, cPLANTA )
if nTIPO = 1        //GM
   fwrite( nHANDLE, "000000" )
endif
if nTIPO = 2        //FORD
   fwrite( nHANDLE, cENTREGA )
endif
fwrite( nHANDLE, space( 4 ) )
fwrite( nHANDLE, space( 30 ) )
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
//NF2 OPCIONAL
nREG ++
fwrite( nHANDLE, "NF2" )
fwrite( nHANDLE, repl( "0", 17 ) )      //Despesas Acessorias
fwrite( nHANDLE, repl( "0", 17 ) )      //Valor do Frete
fwrite( nHANDLE, repl( "0", 17 ) )      //Valor do Seguro
fwrite( nHANDLE, repl( "0", 17 ) )      //Valor do Desconto
fwrite( nHANDLE, space( 57 ) )
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
//NF3 OPCIONAL
nREG ++
fwrite( nHANDLE, "NF3" )
fwrite( nHANDLE, repl( "0", 6 ) )       //1a Data
fwrite( nHANDLE, repl( "0", 4 ) )       //Perc %
fwrite( nHANDLE, repl( "0", 6 ) )       //2a Data
fwrite( nHANDLE, repl( "0", 4 ) )       //Perc %
fwrite( nHANDLE, repl( "0", 6 ) )       //3a Data
fwrite( nHANDLE, repl( "0", 4 ) )       //Perc %
fwrite( nHANDLE, repl( "0", 6 ) )       //4a Data
fwrite( nHANDLE, repl( "0", 4 ) )       //Perc %
fwrite( nHANDLE, repl( "0", 6 ) )       //5a Data
fwrite( nHANDLE, repl( "0", 4 ) )       //Perc %
fwrite( nHANDLE, repl( "0", 6 ) )       //6a Data
fwrite( nHANDLE, repl( "0", 4 ) )       //Perc %
fwrite( nHANDLE, space( 65 ) )
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
dbselectar( xAR2 )
dbgotop()
dbseek( str( nNUMERO, 8 ) )
while NUMERO = nNUMERO .and. !eof()
   //AE2
   nREG ++
   fwrite( nHANDLE, "AE2" )
   fwrite( nHANDLE, strzero( SEQ, 3 ) )
   if empty( PEDIDOCLI )
      mOS := OS
      dbselectar( "MO01" )
      dbgotop()
      dbseek( mOS )
      if found() .and. !empty( PEDIDOCLI )
         fwrite( nHANDLE, padr( PEDIDOCLI, 12 ) )
      else
         dbselectar( xAR2 )
         fwrite( nHANDLE, padr( PEDIDOCLI, 12 ) )
      endif
      dbselectar( xAR2 )
   else
      fwrite( nHANDLE, padr( PEDIDOCLI, 12 ) )
   endif
   fwrite( nHANDLE, padr( strtran( CODIGO, ".", "" ), 30 ) )
   nQTDDE := QTDE
   if lCONV
      nQTDDE := CONVUN( nQTDDE, UNID )
      nQTDDE := int( nQTDDE )
      fwrite( nHANDLE, strzero( nQTDDE, 9 ) )
   else
      do case
      case UNID = "CT"
         cQTDE := strzero( nQTDDE, 10, 2 )
      case UNID = "ML"
         cQTDE := strzero( nQTDDE, 10, 3 )
      otherwise
         cQTDE := strzero( nQTDDE, 9 )
      endcase
      cQTDE := padr( strtran( cQTDE, ".", "" ), 9 )
      fwrite( nHANDLE, cQTDE )
   endif
   if lCONV
      fwrite( nHANDLE, "PC" )
   else
      fwrite( nHANDLE, padr( UNID, 2 ) )
   endif
   fwrite( nHANDLE, strzero( val( strtran( CLASSIPI, ".", "" ) ), 10 ) )
   fwrite( nHANDLE, strzero( IPI, 4 ) )
   if lCONV
      do case
      case UNID = "CT"
         fwrite( nHANDLE, strtran( strzero( PRECO / 100, 18, 2 ), ".", "" ) )
      case UNID = "ML"
         fwrite( nHANDLE, strtran( strzero( PRECO / 1000, 18, 2 ), ".", "" ) )
      otherwise
         fwrite( nHANDLE, strtran( strzero( PRECO, 18, 2 ), ".", "" ) )
      endcase
   else
      fwrite( nHANDLE, strtran( strzero( PRECO, 18, 2 ), ".", "" ) )
   endif
   fwrite( nHANDLE, strzero( 0, 9 ) )
   if nTIPO = 1     //GM
      fwrite( nHANDLE, "  " )
   endif
   if nTIPO = 2     //FORD
      if lCONV
         fwrite( nHANDLE, "PC" )
      else
         fwrite( nHANDLE, padr( UNID, 2 ) )
      endif
   endif
   fwrite( nHANDLE, strzero( 0, 9 ) )
   fwrite( nHANDLE, "  " )
   fwrite( nHANDLE, cTIPO )
   fwrite( nHANDLE, strzero( 0, 4 ) )
   fwrite( nHANDLE, strzero( 0, 11 ) )
   fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
   //AE4
   nREG ++
   fwrite( nHANDLE, "AE4" )
   fwrite( nHANDLE, strtran( strzero( ICM, 5, 2 ), ".", "" ) )
   fwrite( nHANDLE, strtran( strzero( BASEICM, 18, 2 ), ".", "" ) )
   fwrite( nHANDLE, strtran( strzero( VALORICM, 18, 2 ), ".", "" ) )
   fwrite( nHANDLE, strtran( strzero( VALORIPI, 18, 2 ), ".", "" ) )
   fwrite( nHANDLE, left( CODICM, 2 ) )                     //Mudou 2 para 3 digitos
   fwrite( nHANDLE, space( 30 ) )
   fwrite( nHANDLE, strzero( 0, 6 ) )
   fwrite( nHANDLE, space( 32 ) )
   fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
   dbskip()
enddo
//AE3
nREG ++
fwrite( nHANDLE, "AE3" )
if nTIPO = 1        //GM
   fwrite( nHANDLE, "59275792000150" )
   fwrite( nHANDLE, "59275792000150" )
endif
if nTIPO = 2        //FORD
   fwrite( nHANDLE, "57290355001313" )
   fwrite( nHANDLE, "57290355001313" )
endif

fwrite( nHANDLE, padr( cDOCA, 14 ) )
fwrite( nHANDLE, space( 83 ) )
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )

//FTP
nREG ++
fwrite( nHANDLE, "FTP" )
fwrite( nHANDLE, strzero( 0, 5 ) )
fwrite( nHANDLE, strzero( nREG, 9 ) )
fwrite( nHANDLE, strzero( 0, 17 ) )
fwrite( nHANDLE, " " )
fwrite( nHANDLE, space( 93 ) )
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
fwrite( nHANDLE, chr( 26 ) )
fclose( nHANDLE )
dbcloseall()

if MDG( "Deseja Ver o Arquivo" )
   VERTXT( cARQ )
endif
if MDG( "Deseja imprimir o Arquivo" )
   //   imparq(cARQ)
   imparq( cARQ,,,,,,, 128, )
endif

*+ EOF: M_BO6.PRG
