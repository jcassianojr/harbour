// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdin.prg
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

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_BDIN.PRG
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bdin()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bdin

   PARA nTIPO, lPEGA, dDATA

   IF ValType( lPEGA ) = "L"
      IF !checkimp( 0 )
         RETU .F.
      ENDIF
      nANO := Year( ZDATA )
      nMES := Month( ZDATA )
      MDS( "Digite o M€s e o ano" )
      @ 24, 40 GET nMES
      @ 24, 45 GET nANO
      READ
      cVAR := SubStr( StrZero( nANO, 4 ), 3, 2 ) + StrZero( nMES, 2 )
      ZFOL := ZLIM := ZLIV := 0
      ZULT := ZDATA
      DO CASE
      CASE nTIPO = 1 .OR. nTIPO = 2
         PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGS", "FILIMS", "FILIVS", "FILANS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
      CASE nTIPO = 3 .OR. nTIPO = 4
         PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGE", "FILIME", "FILIVE", "FILANE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
      CASE nTIPO = 5 .OR. nTIPO = 6
         PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGICM", "FILIMICM", "FILIVICM", "FILAICM" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
      CASE nTIPO = 7 .OR. nTIPO = 8
         PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGIPI", "FILIMIPI", "FILIVIPI", "FILAIPI" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
      CASE nTIPO = 9 .OR. nTIPO = 10
         PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISE", "FILIMISE", "FILIVISE", "FILANISE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
      CASE nTIPO = 11 .OR. nTIPO = 12
         PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISS", "FILIMISS", "FILIVISS", "FILANISS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
      ENDCASE
      IF nTIPO = 1 .OR. nTIPO = 3
         ZFOL := 1
         ZLIV++
      ELSE
         ZFOL := ZLIM
      ENDIF
      PRIV wNOME, wINSCR, wCGC, wJUCESPC, wJUCESPD
      PRIV wIMUNICI, wENDERECO, wCIDADE, wESTADO, wCEP, wBAIRRO
      pegempmbdi()

   ENDIF

   VIDEO()
   IF ValType( dDATA ) = "D"
      ZULT := dDATA
   ENDIF
   cLOCAL := "Sao Paulo     "
   dASSIN := ZULT
   MDS( "Ordem/Limite/Ultima/Data/Local" )
   @ 24, 30 GET ZLIV   PICT "9999"
   @ 24, 35 GET ZLIM   PICT "9999"
   @ 24, 40 GET ZULT
   @ 24, 50 GET dASSIN
   @ 24, 60 GET cLOCAL
   READCUR()

   IMPRESSORA()
// Desenha a Tela
   SetColor( '+W/N' )
   CLEAR
   DO CASE
   CASE nTIPO = 1 .OR. nTIPO = 2
      @ 10, 30 SAY "REGISTRO DE SAIDAS"
      @ 10, 70 SAY "Folha: " + Str( ZFOL, 3 )
      @ 11, 35 SAY "(Modelo 2)"
   CASE nTIPO = 3 .OR. nTIPO = 4
      @ 10, 30 SAY "REGISTRO DE ENTRADA"
      @ 10, 70 SAY "Folha: " + Str( ZFOL, 3 )
      @ 11, 35 SAY "(Modelo 1)"
   CASE nTIPO = 5 .OR. nTIPO = 6
      @ 10, 30 SAY "REGISTRO DE ICMS"
      @ 10, 70 SAY "Folha: " + Str( ZFOL, 3 )
   CASE nTIPO = 7 .OR. nTIPO = 8
      @ 10, 30 SAY "REGISTRO DE IPI"
      @ 10, 70 SAY "Folha: " + Str( ZFOL, 3 )
   CASE nTIPO = 9 .OR. nTIPO = 10 .OR. nTIPO = 11 .OR. nTIPO = 12
      @ 10, 20 SAY "REGISTRO DE SERVICOS TOMADOS"
      @ 10, 60 SAY "Folha: " + Str( ZFOL, 3 )
      @ 11, 20 SAY "OU INTERMEDIADOS DE TERCEIROS"
   ENDCASE

   @ 13, 29 SAY "Numero de ordem"
   @ 13, 46 SAY ZLIV              PICT "999"
   IF nTIPO = 2 .OR. nTIPO = 4
      @ 14, 20 SAY "Ultimo Lancamento Efetuado em"
      @ 14, 50 SAY ZULT
   ENDIF
   lABER := nTIPO = 1 .OR. nTIPO = 3 .OR. nTIPO = 5 .OR. nTIPO = 7 .OR. nTIPO = 9
   IF lABER
      @ 16, 31 SAY "TERMO DE ABERTURA"
   ELSE
      @ 16, 31 SAY "TERMO DE ENCERRAMENTO"
   ENDIF

   @ 18, 0  SAY "Contem este livro     folhas numeradas de numero 001 ao numero     e " + if( lABER, "servira", "serviou" )
   @ 18, 18 SAY ZLIM                                                                                                  PICT "999"
   @ 18, 63 SAY ZLIM                                                                                                  PICT "999"
   @ 19, 0  SAY "para o lancamento das operacoes proprias do estabelecimento"
   @ 20, 0  SAY "do contribuinte abaixo identificado:"
   @ 22, 9  SAY "Nome     :"
   @ 22, 20 SAY wNOME
   @ 23, 9  SAY "Endereco :"
   @ 23, 20 SAY wENDERECO
   @ 24, 9  SAY "Bairro   :"
   @ 24, 20 SAY wBAIRRO
   @ 25, 9  SAY "Cidade   :" + spac( 38 ) + "Estado :"
   @ 25, 20 SAY wCIDADE
   @ 25, 66 SAY wESTADO
   @ 27, 9  SAY "Inscricao Estadual No."
   @ 27, 32 SAY wINSCR
   @ 28, 9  SAY "C.N.P.J. No."
   @ 28, 24 SAY wCGC
   @ 29, 9  SAY "Registrado na Junta Comercial sob No."
   @ 29, 47 SAY wJUCESPC
   @ 30, 9  SAY "CCM"
   @ 30, 20 SAY wIMUNICI
   IF nTIPO = 3 .OR. nTIPO = 4
      @ 31, 9 SAY "NIR 35.201.235.446"
   ENDIF
   @ 35, 6 SAY cLOCAL + "," + Str( Day( dASSIN ) ) + " de " + cMES( dASSIN ) + " de " + StrZero( Year( Dassin ), 4 )
   @ 40, 6 SAY "__________________________________________________________________"
   @ 41, 8 SAY "Representante legal - Diretor Industrial -  Giuseppe Luigi Quarta"
   @ 42, 8 SAY "Diretor Industrial  - RG 8.498.999-SP - CPF 004.312.878-56"
   @ 47, 6 SAY "__________________________________________________________________"
   @ 48, 8 SAY "Contador            - Marcos Antonio Baptista - CRC 117.122-SP"
   IF ValType( lPEGA ) = "L"
      IMPFOL()
      VIDEO()
      IMPEND()
   ENDIF

// + EOF: M_BDIN.PRG

// + EOF: m_bdin.prg
// +
