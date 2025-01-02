// +--------------------------------------------------------------------
// +
// +    Programa  : folis_d1.prg Revisao e Alteracao de Dados da Rais
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function folis_d1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION folis_d1

   PARA nTIPO

   MESTADO  := ""
   MCIDADE  := ""
   MNESTADO := ""
   MNCIDADE := ""
   MPAIS    := ""


   IF nTIPO = 0
      IF mdg( "Checar Cadastro" )
         FO7W()
      ENDIF
      IF MDG( "Pre Checagem dos Codigos" )
         FOLIS_D9()
      ENDIF
   ENDIF

   CTR := 0
   CABE2( 'Revisando dados da RAIS' )
   SetColor( "W/N,N/W" )
   @ 05, 00 CLEA
   hb_DispBox( 5, 0, 23, 79, B_DOUBLE )
   IF nTIPO = 0
      @  9, 2 SAY "Numero Pis" + spac( 9 ) + "Nome" + spac( 27 ) + "Ultimo Salario    Tipo hrs"
      @ 11, 3 SAY "CTPS" + spac( 9 ) + "/" + spac( 8 ) + "Admiss„o:" + spac( 10 ) + "Tipo:    Op‡„o FGTS:"
      @ 12, 3 SAY "Nasto:" + spac( 9 ) + "CBO:" + spac( 6 ) + "Vinculo:   Instru‡„o:  Demissao:" + spac( 9 ) + "Motivo:"
      @ 14, 3 SAY "Nacionaidade:   Ano Chegada:" + spac( 5 ) + "CPF:" + spac( 15 ) + "Ra‡a:  Def:  Alvara:"
   ENDIF
   IF nTIPO = 1
      @  6, 2  SAY "ANO  Numero    Nome"
      @  6, 70 SAY "IBGE"
      @ 08, 02 SAY "Afastamento  CD DDMM DDMM CD DDMM DDMM CD DDMM DDMM DIAS"
      @ 10, 2  SAY "Associativa   CNPJ:" + Space( 16 ) + "Valor:"
      @ 11, 2  SAY "Confederativa CNPJ:" + Space( 16 ) + "Valor:"
      @ 12, 2  SAY "Assistencial  CNPJ:" + Space( 16 ) + "Valor:"
      @ 13, 2  SAY "Sindical      CNPJ:" + Space( 16 ) + "Valor:"
      @ 14, 7  SAY "Valores   Horas        Valores   Horas"
      @ 15, 3  SAY "Jan" + spac( 20 ) + "Jul" + Space( 20 ) + "13§1§Parc"
      @ 16, 3  SAY "Fev" + spac( 20 ) + "Ago" + Space( 20 ) + "13§2§Parc"
      @ 17, 3  SAY "Mar" + spac( 20 ) + "Set" + Space( 20 ) + "AvisoInd "
      @ 18, 3  SAY "Abr" + spac( 20 ) + "Out" + Space( 20 ) + "FeriasInd"
      @ 19, 3  SAY "Mai" + spac( 20 ) + "Nov" + Space( 20 ) + "Acrescim "
      @ 20, 3  SAY "Jun" + spac( 20 ) + "Dez" + Space( 20 ) + "Gratifi  "
      @ 21, 3  SAY "   " + spac( 20 ) + "   " + Space( 20 ) + "MultaFGTS"
      @ 22, 3  SAY "   " + spac( 20 ) + "   " + Space( 20 ) + "BcoHoras "
   ENDIF
   IF nTIPO = 0
      IF !netuse( pes )
         RETU
      ENDIF
   ELSE
      IF !netuse( "FORAIS" )
         RETU
      ENDIF
   ENDIF
   FILTRO := ''
   INX    := ""
   FILORD( .T. )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF ValType( INX ) = "N"
      dbSetOrder( INX )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", inx )
      ordSetFocus( "temp" )
   ENDIF
   SET FILTER TO &FILTRO


   dbGoTop()
   WHILE .T.
      // Get nas Menvars
      IF nTIPO = 0
         netreclock()
         CorrigeFo_pes()
         ALLTRUE( CHECKCID(,, .F., IBGE, { { "UF", "mESTADO" }, { "NOME", "mCIDADE" } } ) )
         ALLTRUE( CheckBacen( NASCPAIS, mPAIS, .F., { { "STRZERO(BACEN,4)", "NACPAIS" }, { "NOME", "mPAIS" } } ) )
         dbUnlock()

         IF Empty( DEMITIDO )
            tSAL := "SALDEZ"
         ELSE
            MESDEM := Month( DEMITIDO )
            XSAL   := MMES( Month( DEMITIDO ) )
            XSAL   := SubStr( XSAL, 1, 3 )
            tSAL   := 'SAL' + XSAL
         ENDIF
         @ 10, 2  SAY NUMERO
         @ 10, 9  SAY PIS
         @ 10, 21 SAY NOME
         @ 10, 52 SAY &tSAL.
         @ 10, 71 SAY TIPO
         @ 10, 74 SAY HRSEM
         @ 11, 8  SAY IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ) + "/" + SubStr( TIRAOUT( CPF ), 8 ), PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
         @ 11, 35 SAY ADMITIDO
         @ 11, 65 SAY FGTS
         @ 12, 9  SAY NASC
         @ 13, 22 SAY OBTER( "FUNCAO",, FUNCAO, "CBONEW" )
         @ 12, 49 SAY ESCRAIS
         @ 12, 60 SAY DEMITIDO
         @ 14, 17 SAY NASCPAIS
         @ 14, 22 SAY mPAIS
         @ 14, 32 SAY ANONASCI
         @ 14, 41 SAY CPF
         @ 14, 61 SAY RACS
         @ 14, 67 SAY DEFICI

      ELSE
         FOLISD1SAY()
      ENDIF
      @ 05, 02 PROM 'P>r¢ximo'
      @ 05, 11 PROM 'R>etorna'
      @ 05, 20 PROM 'A>ltera'
      @ 05, 28 PROM 'B>usca'
      @ 05, 36 PROM 'E>xcluir'
      @ 05, 71 PROM 'S>a¡da'
      MENU TO OPCAO
      DO CASE
      CASE OPCAO = 1
         NEXTREC()
      CASE OPCAO = 2
         PREVREC()
      CASE OPCAO = 3
         netreclock()
         // Get nas Menvars
         SET KEY K_F11 TO TECLAF11
         IF nTIPO = 0
            IF Empty( DEMITIDO )
               tSAL := "SALDEZ"
            ELSE
               MESDEM := Month( DEMITIDO )
               XSAL   := MMES( Month( DEMITIDO ) )
               XSAL   := SubStr( XSAL, 1, 3 )
               tSAL   := 'SAL' + XSAL
            ENDIF
            @ 10, 2  SAY NUMERO
            @ 10, 9  GET PIS      VALID VALPIS( PIS, .T., .T., EVINC )
            @ 10, 21 GET NOME
            @ 10, 52 GET &tSAL.
            @ 10, 71 GET TIPO     VALID CHECKTAB( "TSA2" + TIPO + "    ", 24, 0, "Tipo n„o Cadastrado" )
            @ 10, 74 GET HRSEM    VALID HRSEM > 0
            @ 11, 8  GET PROFIS   PICT '99999999999'                                                                      VALID CHECKCTPS() // 7 cpts 11 cpf
            @ 11, 17 GET SERIE    PICT '99999'                                                                            VALID CHECKSERIE()
            @ 11, 35 GET ADMITIDO VALID CHECKADM()
            @ 11, 65 GET FGTS     VALID CHECKFGTS( FGTS )
            @ 12, 9  GET NASC
            @ 12, 22 GET CBONEW   VALID VERSEHA( "FO_CBON",, CBONEW, "STRZERO(CAGEDESCO,2)+' '+NOME", '"CBO Nao Cadastrado"' )
            @ 12, 49 GET ESCRAIS  VALID CHECKTAB( "EESC" + ESCRAIS, 24, 0, "Escolaridade nao Cadastrada" )
            @ 12, 60 GET DEMITIDO
            @ 14, 17 GET NASCPAIS VALID CheckBacen( NASCPAIS, mPAIS, .T., { { "STRZERO(BACEN,4)", "NACPAIS" }, { "NOME", "mPAIS" } } )
            @ 14, 22 GET mPAIS    WHEN Val( NASCPASI ) = 0                                                                  VALID CheckBacen( 0, mPAIS, .T., { { "STRZERO(BACEN,4)", "NACPAIS" }, { "NOME", "mPAIS" } } )
            @ 14, 32 GET ANONASCI WHEN NASCPAIS <> "1058"                                                                 PICT "9999" // VALID FOLISD12()
            @ 14, 41 GET CPF      PICT "999.999.999-99"                                                                   VALID VALCPF( CPF )
            @ 14, 61 GET RACS     VALID CHECKTAB( "RACS" + RACS, 24, 0, "Etnia E-Social nao cadastrado" )
            @ 14, 67 GET DEFICI   VALID CHECKTAB( "DEFI" + PadR( DEFICI, 5 ), 24, 0, "Tipo Deficiencia invalido" )

         ELSE
            @ 07, 2  SAY NUMERO
            @ 07, 21 SAY NOME
            @ 07, 70 GET IBGECOD
            @ 09, 15 GET CODAFA01
            @ 09, 18 GET INIAFA01
            @ 09, 23 GET FIMAFA01
            @ 09, 28 GET CODAFA02
            @ 09, 31 GET INIAFA02
            @ 09, 36 GET FIMAFA02
            @ 09, 41 GET CODAFA03
            @ 09, 44 GET INIAFA03
            @ 09, 49 GET FIMAFA03
            @ 09, 54 GET DIASAFA
            @ 10, 21 GET CGCSOC1
            @ 10, 43 GET VALSOC1
            @ 10, 53 GET CGCSOC2
            @ 10, 69 GET VALSOC2
            @ 11, 21 GET CGCCON
            @ 11, 43 GET VALCON
            @ 12, 21 GET CGCASS
            @ 12, 43 GET VALASS
            @ 13, 21 GET CGCSIN
            @ 13, 43 GET VALSIN
            @ 15, 7  GET RAIZJAN
            @ 15, 19 GET HORJAN
            @ 16, 7  GET RAIZFEV
            @ 16, 19 GET HORFEV
            @ 17, 7  GET RAIZMAR
            @ 17, 19 GET HORMAR
            @ 18, 7  GET RAIZABR
            @ 18, 19 GET HORABR
            @ 19, 7  GET RAIZMAI
            @ 19, 19 GET HORMAI
            @ 20, 7  GET RAIZJUN
            @ 20, 19 GET HORJUN
            @ 15, 30 GET RAIZJUL
            @ 15, 42 GET HORJUL
            @ 16, 30 GET RAIZAGO
            @ 16, 42 GET HORAGO
            @ 17, 30 GET RAIZSET
            @ 17, 42 GET HORSET
            @ 18, 30 GET RAIZOUT
            @ 18, 42 GET HOROUT
            @ 19, 30 GET RAIZNOV
            @ 19, 42 GET HORNOV
            @ 20, 30 GET RAIZDEZ
            @ 20, 42 GET HORDEZ
            @ 15, 58 GET SAL13_1
            @ 15, 70 GET MES_1
            @ 16, 58 GET SAL13_2
            @ 16, 70 GET MES_2
            @ 17, 58 GET RAIZAVI
            @ 18, 59 GET RAIZFER
            @ 19, 59 GET RAIZACR
            @ 19, 70 GET MESACR
            @ 20, 59 GET RAIZGRA
            @ 20, 70 GET MESGRA
            @ 21, 59 GET RAIZMUL
            @ 22, 59 GET RAIZBCH
            @ 22, 70 GET MESBCH
            @ 11, 50 GET TIPOADM  VALID VERSEHA( "RAISTADM",, TIPOADM, "NOME", '"Tipo de admissao Nao Cadastrado"' )
            @ 12, 36 GET RAISVINC VALID VERSEHA( "VINCULO",, RAISVINC, "NOME", '"Vinculo nao Cadastrado"' ) // CHECKTAB("VINC"+RAISVINC,24,0,"Vinculo n„o Cadastrada")
            @ 12, 76 GET RAISDEM  WHEN CHECKMOTDEM() .AND. !Empty( DEMITIDO )                                                                                      VALID CHECKTAB( "RDEM" + RAISDEM + "   ", 24, 0, "Motivo n„o Cadastrado" )
            @ 14, 76 GET ALVARA   VALID ALVARA $ "SN"
         ENDIF
         READCUR()
         IF nTIPO = 0
            CorrigeFo_pes()
         ENDIF
         dbUnlock()
         SET KEY K_F11 TO
      CASE OPCAO = 4
         Mds( 'Digite o numero do funcionario' )
         @ 24, 40 GET CTR PICT '######'
         READCUR()
         dbGoTop()
         IF !dbSeek( CTR )
            MDT( 'Funcion rio nao encontrado' )
         ENDIF
      CASE OPCAO = 5
         IF nTIPO = 0
            ALERTX( "Exclusao Bloqueada" )
         ELSE
            IF MDG( "Deletar Rais Valores" )
               netreclock()
               dbskipex()
            ENDIF
         ENDIF

      OTHERWISE
         dbCloseAll()
         RETURN
      ENDCASE
   ENDDO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOLISD1SAY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOLISD1SAY()

   @ 07, 2  SAY ANO
   @ 07, 5  SAY NUMERO
   @ 07, 15 SAY NOME
   @ 07, 70 SAY IBGECOD
   @ 09, 15 SAY CODAFA01
   @ 09, 18 SAY INIAFA01
   @ 09, 23 SAY FIMAFA01
   @ 09, 28 SAY CODAFA02
   @ 09, 31 SAY INIAFA02
   @ 09, 36 SAY FIMAFA02
   @ 09, 41 SAY CODAFA03
   @ 09, 44 SAY INIAFA03
   @ 09, 49 SAY FIMAFA03
   @ 09, 54 SAY DIASAFA
   @ 10, 21 SAY CGCSOC1
   @ 10, 43 SAY VALSOC1
   @ 10, 53 SAY CGCSOC2
   @ 10, 69 SAY VALSOC2
   @ 11, 21 SAY CGCCON
   @ 11, 43 SAY VALCON
   @ 11, 50 SAY TIPOADM
   @ 12, 21 SAY CGCASS
   @ 12, 36 SAY RAISVINC
   @ 12, 43 SAY VALASS
   @ 13, 21 SAY CGCSIN
   @ 13, 43 SAY VALSIN
   @ 15, 7  SAY RAIZJAN
   @ 16, 7  SAY RAIZFEV
   @ 17, 7  SAY RAIZMAR
   @ 18, 7  SAY RAIZABR
   @ 19, 7  SAY RAIZMAI
   @ 20, 7  SAY RAIZJUN
   @ 15, 30 SAY RAIZJUL
   @ 16, 30 SAY RAIZAGO
   @ 17, 30 SAY RAIZSET
   @ 18, 30 SAY RAIZOUT
   @ 19, 30 SAY RAIZNOV
   @ 20, 30 SAY RAIZDEZ
   @ 15, 19 SAY HORJAN
   @ 16, 19 SAY HORFEV
   @ 17, 19 SAY HORMAR
   @ 18, 19 SAY HORABR
   @ 19, 19 SAY HORMAI
   @ 20, 19 SAY HORJUN
   @ 15, 42 SAY HORJUL
   @ 16, 42 SAY HORAGO
   @ 17, 42 SAY HORSET
   @ 18, 42 SAY HOROUT
   @ 19, 42 SAY HORNOV
   @ 20, 42 SAY HORDEZ
   @ 15, 58 SAY SAL13_1
   @ 15, 70 SAY MES_1
   @ 16, 58 SAY SAL13_2
   @ 16, 70 SAY MES_2
   @ 17, 58 SAY RAIZAVI
   @ 18, 59 SAY RAIZFER
   @ 19, 59 SAY RAIZACR
   @ 19, 70 SAY MESACR
   @ 20, 59 SAY RAIZGRA
   @ 20, 70 SAY MESGRA
   @ 21, 59 SAY RAIZMUL
   @ 22, 59 SAY RAIZBCH
   @ 22, 70 SAY MESBCH
   @ 12, 76 SAY RAISDEM
   @ 14, 76 SAY ALVARA

   RETURN


// : FIM: FOLIS_D1.PRG

// + EOF: folis_d1.prg
// +
