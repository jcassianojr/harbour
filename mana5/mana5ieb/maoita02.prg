// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : maoita02.prg
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


#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function maoita02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION maoita02

   PARA nTIPO  // 1 Zerados //2-Grupo //3-Filtro //4-Automaticos //5 Cliente

// Modo de Trabalho no V¡deo
   IF nTIPO = 1
      MDI( " Ý Excluir Pedidos Zerados" )
   ENDIF
   IF nTIPO = 2
      mGRUPO := 0
      MDI( " Ý Excluir Grupo Pedidos" )
      @ 23, 00 SAY "Digite o Grupo Pedido"
      @ 24, 40 GET mGRUPO                  PICT "99999"
      READCUR()
      mGRPFIM := mGRUPO + .999
      IF !MDG( "Excluir Grupo:" + Str( mGRUPO ) + "/" + AllTrim( Str( mGRPFIM ) ) )
         RETU .F.
      ENDIF
   ENDIF

   IF nTIPO = 4
      dINI  := dFIM := ZDATA
      cTIPO := " "
      @ 21, 00 SAY "Periodo"
      @ 22, 00 SAY "Tipo (T)odas (A)Sem+Dia Prg(S)emanal Prg(D)iaria"
      @ 23, 00 SAY "     Electrolux->D(E)lfor (O)rders "
      @ 21, 15 GET dINI
      @ 21, 25 GET dFIM
      @ 23, 78 GET cTipo                                              PICT "!" VALID cTIPO $ "ASDEOT"
      IF !READCUR()
         RETU .F.
      ENDIF
   ENDIF

   IF nTIPO = 5
      nCLIINI := 0
      nCLIFIM := 0
      MDI( " Ý Digite o Grupo Cliente" )
      @ 24, 40 GET nCLIINI PICT "99999999"
      @ 24, 50 GET nCLIFIM PICT "99999999"
      READCUR()
      IF !MDG( "Excluir Grupo Cliente:" + Str( nCLIINI ) + " ao " + Str( nCLIFIM ) )
         RETU .F.
      ENDIF
   ENDIF


   IF nTIPO # 3
      IF !MDG( "Continuar Exclusao Pedidos" )
         RETU .F.
      ENDIF
   ENDIF




   MDS( " Aguarde. Abrindo os arquivos de dados ..." )

   IF !USEMULT( { { "MO01", 1, 99 }, { "MO02", 1, 99 }, { "MO01BX", 1, 99 }, { "MO02BX", 1, 99 } } )
      RETU .F.
   ENDIF

   dbSelectAr( "MO01" )
   dbSetOrder( 1 )
   INITVARS()
   CLRVARS()
   dbSelectAr( "MO02" )
   INITVARS()
   CLRVARS()

// Declarando vari veis
   REGISTRO := 0
   COLUNA   := 27

// Tela de Dados
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
   @ 08, 13 SAY "N£mero do Pedido   : "
   @ 10, 13 SAY "Registros Apagados : "
   @ 16, 11 SAY "+--------------------------+"
   @ 17, 11 SAY "Ý                          Ý"
   @ 18, 11 SAY "+--------------------------+"
   @ 17, 13 SAY "Processando : ÝÝÝÝÝÝÝÝÝÝ"
   MDS( " " )

   dbSelectAr( "MO02" )
   dbGoTop()
   WHILE !Eof()
      @ 17, COLUNA SAY "Ý"
      IF COLUNA = 36
         @ 17, 27 CLEAR TO 17, 36
         @ 17, 27 SAY "ÝÝÝÝÝÝÝÝÝ"
         COLUNA := 26
      ENDIF
      mPEDIDO  := PEDIDO
      mQTDESAL := QTDESAL
      mQTDEENT := QTDEENT
      mGERAOF  := GERAOF
      @ 08, 35 SAY mPEDIDO PICT '99999.99'
      lAPAGA  := .F.
      lBACKUP := .T.
      IF nTIPO = 1 .AND. mQTDESAL = 0.00
         lAPAGA := .T.
      ENDIF
      IF nTIPO = 2 .AND. PEDIDO >= mGRUPO .AND. PEDIDO <= mGRPFIM
         lAPAGA := .T.
      ENDIF
      IF nTIPO = 5 .AND. ( FORNECEDO >= nCLIINI .AND. FORNECEDO <= nCLIFIM )
         lAPAGA := .T.
      ENDIF
      IF nTIPO = 4
         mBAIXAM  := " "
         mTIPOPRG := " "
         dbSelectAr( "MO01" )
         dbGoTop()
         IF dbSeek( mPEDIDO )
            mBAIXAM  := BAIXAM
            mTIPOPRG := TIPOPRG
         ENDIF
         dbSelectAr( "MO02" )
         IF ENTREGA >= dINI .AND. ENTREGA <= dFIM .AND. mBAIXAM = "N"
            IF ( cTIPO = "A" .AND. ( mTIPOPRG = "D" .OR. mTIPOPRG = "S" ) ) ;
                  .OR. cTIPO = mTIPOPRG ;
                  .OR. cTIPO = "T"
               lAPAGA := .T.
               IF QTDEENT = 0
                  lBACKUP := .F.
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      IF lAPAGA
         mOS     := mPEDIDO
         mOF     := mPEDIDO
         mITEM   := ITEM
         mCODIGO := CODIGO
         xCHAVE  := Str( mOS, 8, 2 ) + Str( mITEM, 2 )
         EQUVARS()
         IF lBACKUP
            NOVOOPA( "MO02BX", .T., .T. )
         ENDIF
         dbSelectAr( "MO01" )
         dbGoTop()
         IF dbSeek( mPEDIDO )
            EQUVARS()
            DELEREG(,, .F., .F. )
            IF lBACKUP
               NOVOOPA( "MO01BX", .T., .T. )
            ENDIF
            REGISTRO++
            @ 10, 35 SAY REGISTRO PICT '99999'
         ENDIF
         IF mGERAOF = "S"
            APAGAREG( "OF01", xCHAVE, .F., .F.,, .F. )
            MAOFDEL()
         ENDIF
         dbSelectAr( "MO02" )
         DELEREG(,, .F., .F. )
      ENDIF
      dbSelectAr( "MO02" )
      dbSkip()
      COLUNA++
   ENDDO
   dbCloseAll()
   RELEASE ALL LIKE m *
   MAOFIXAR()



// + EOF: M_DR.PRG

// + EOF: maoita02.prg
// +
