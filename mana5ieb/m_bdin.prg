*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BDIN.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function m_bdin
para nTIPO, lPEGA,dDATA
if valtype( lPEGA ) = "L"
   if ! checkimp(0)
      RETU .F.
   ENDIF
   nANO := year( ZDATA )
   nMES := month( ZDATA )
   MDS( "Digite o M€s e o ano" )
   @ 24, 40 get nMES
   @ 24, 45 get nANO
   read
   cVAR := substr( strzero( nANO, 4 ), 3, 2 ) + strzero( nMES, 2 )
   ZFOL := ZLIM := ZLIV := 0
   ZULT := ZDATA
   do case
   case nTIPO = 1 .or. nTIPO = 2
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGS", "FILIMS", "FILIVS", "FILANS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   case nTIPO = 3 .or. nTIPO = 4
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGE", "FILIME", "FILIVE", "FILANE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   case nTIPO = 5 .or. nTIPO = 6
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGICM", "FILIMICM", "FILIVICM", "FILAICM" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   case nTIPO = 7 .or. nTIPO = 8
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGIPI", "FILIMIPI", "FILIVIPI", "FILAIPI" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   case nTIPO = 9 .or. nTIPO = 10
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISE", "FILIMISE", "FILIVISE", "FILANISE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   case nTIPO =11 .or. nTIPO = 12
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISS", "FILIMISS", "FILIVISS", "FILANISS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   endcase
   if nTIPO = 1 .or. nTIPO = 3
      ZFOL := 1
      ZLIV ++
   else
      ZFOL := ZLIM
   endif
   priv   wNOME,wINSCR,wCGC,wJUCESPC,wJUCESPD
   priv   wIMUNICI,wENDERECO,wCIDADE,wESTADO,wCEP,wBAIRRO
   pegempmbdi()

endif

VIDEO()
IF VALTYPE(dDATA)="D"
   ZULT:=dDATA
ENDIF
cLOCAL="Sao Paulo     "
dASSIN:=ZULT
MDS("Ordem/Limite/Ultima/Data/Local")
@ 24,30 GET ZLIV PICT "9999"
@ 24,35 GET ZLIM PICT "9999"
@ 24,40 GET ZULT
@ 24,50 GET dASSIN
@ 24,60 GET cLOCAL
READCUR()

IMPRESSORA()
// Desenha a Tela
setcolor( '+W/N' )
clear
do case
case nTIPO = 1 .or. nTIPO = 2
   @ 10, 30 say "REGISTRO DE SAIDAS"
   @ 10, 70 say "Folha: " + str( ZFOL, 3 )
   @ 11, 35 say "(Modelo 2)"
case nTIPO = 3 .or. nTIPO = 4
   @ 10, 30 say "REGISTRO DE ENTRADA"
   @ 10, 70 say "Folha: " + str( ZFOL, 3 )
   @ 11, 35 say "(Modelo 1)"
case nTIPO = 5 .or. nTIPO = 6
   @ 10, 30 say "REGISTRO DE ICMS"
   @ 10, 70 say "Folha: " + str( ZFOL, 3 )
case nTIPO = 7 .or. nTIPO = 8
   @ 10, 30 say "REGISTRO DE IPI"
   @ 10, 70 say "Folha: " + str( ZFOL, 3 )
case nTIPO = 9 .or. nTIPO = 10 .OR. nTIPO = 11 .or. nTIPO = 12
   @ 10, 20 say "REGISTRO DE SERVICOS TOMADOS"
   @ 10, 60 say "Folha: " + str( ZFOL, 3 )
   @ 11, 20 SAY "OU INTERMEDIADOS DE TERCEIROS"
endcase

@ 13, 29 say "Numero de ordem"
@ 13, 46 say ZLIV              pict "999"
if nTIPO = 2 .or. nTIPO = 4
   @ 14, 20 say "Ultimo Lancamento Efetuado em"
   @ 14, 50 say ZULT
endif
lABER:=nTIPO = 1 .or. nTIPO = 3 .or. nTIPO = 5 .or. nTIPO = 7.or. nTIPO = 9
if lABER
   @ 16, 31 say "TERMO DE ABERTURA"
else
   @ 16, 31 say "TERMO DE ENCERRAMENTO"
endif

@ 18,  0 say "Contem este livro     folhas numeradas de numero 001 ao numero     e " + if( lABER, "servira", "serviou" )
@ 18, 18 say ZLIM                                                                                                                           pict "999"
@ 18, 63 say ZLIM                                                                                                                           pict "999"
@ 19,  0 say "para o lancamento das operacoes proprias do estabelecimento"
@ 20,  0 say "do contribuinte abaixo identificado:"
@ 22,  9 say "Nome     :"
@ 22, 20 say wNOME
@ 23,  9 say "Endereco :"
@ 23, 20 say wENDERECO
@ 24,  9 say "Bairro   :"
@ 24, 20 say wBAIRRO
@ 25,  9 say "Cidade   :" + spac( 38 ) + "Estado :"
@ 25, 20 say wCIDADE
@ 25, 66 say wESTADO
@ 27,  9 say "Inscricao Estadual No."
@ 27, 32 say wINSCR
@ 28,  9 say "C.N.P.J. No."
@ 28, 24 say wCGC
@ 29,  9 say "Registrado na Junta Comercial sob No."
@ 29, 47 say wJUCESPC
@ 30,  9 SAY "CCM"
@ 30, 20 SAY wIMUNICI
if nTIPO = 3 .or. nTIPO = 4
   @ 31,  9 say "NIR 35.201.235.446"
endif
@ 35,  6 say cLOCAL+","+STR(DAY(dASSIN))+" de "+cMES(dASSIN)+" de "+strzero(year(Dassin),4)
@ 40,  6 say "__________________________________________________________________"
@ 41,  8 say "Representante legal - Diretor Industrial -  Giuseppe Luigi Quarta"
@ 42,  8 say "Diretor Industrial  - RG 8.498.999-SP - CPF 004.312.878-56"
@ 47,  6 say "__________________________________________________________________"
@ 48,  8 say "Contador            - Marcos Antonio Baptista - CRC 117.122-SP"
if valtype( lPEGA ) = "L"
   IMPFOL()
   VIDEO()
   IMPEND()
endif

*+ EOF: M_BDIN.PRG
