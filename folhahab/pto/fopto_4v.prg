// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4v.prg Importar Escala de Revezamento
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

FUNCTION fopto_4v()

   CABE2( "FOPTO_4V - Importar Escala de Revezamento" )

   cPE := "PE" + ANOMESW
   CHECKCRI( cPE, "FOPTOREV", "GRUPO+DTOS(DATA)" )

// cARQ := space( 40 )
// MDS( "Digite o Nome do Arquivo" )
// @ 24, 30 get cARQ
// if !READCUR()
// retu .F.
// endif
// cARQ := alltrim( cARQ )
   cARQ := win_GetOpenFileName(, "Arquivos de Escala de Revezamento", hb_cwd(), "Arquivos de Escala de Revezamento", "*.*", 1 )


   IF !hb_FileExists( cARQ )
      ALERTX( "Nao encontrei Arquivo: " + cARQ )
      RETU .F.
   ENDIF


   IF !NETUSE( cPE )
      RETU .F.
   ENDIF
   nHANDLE := hb_fopen( cARQ )
   IF nHANDLE <= 0
      ALERTX( "Nao Consegui abrir o Arquivo: " + cARQ )
      dbCloseAll()
      RETU .F.
   ENDIF


   LINHA1 := FREADLINE( nHANDLE )
   LINHA  := AllTrim( LINHA1 )
   WHILE .T.
      IF !Empty( LINHA )
         mGRUPO := SubStr( LINHA, 1, 2 )
         dINI   := SubStr( LINHA, 3, 6 )
         tDIA   := SubStr( dINI, 1, 2 )
         tMES   := SubStr( dINI, 3, 2 )
         tANO   := SubStr( dINI, 5, 2 )
         dINI   := CToD( tDIA + "/" + tMES + "/" + tANO )
         mCHAVE := mGRUPO + DToS( dINI )
         dbGoTop()
         IF !dbSeek( mCHAVE )
            netrecapp()
            FIELD->GRUPO := mGRUPO
            field->DATA  := dINI
         ELSE
            netreclock()
         ENDIF
         field->cODREV := SubStr( LINHA, 9, 2 )
         field->ENTREV := Val( SubStr( LINHA, 11, 4 ) ) / 100
         field->ALIREV := Val( SubStr( LINHA, 15, 4 ) ) / 100
         field->ALSREV := Val( SubStr( LINHA, 19, 4 ) ) / 100
         field->SAIREV := Val( SubStr( LINHA, 23, 4 ) ) / 100
         field->VIRADA := SubStr( LINHA, 27, 2 )
         dbUnlock()
      ENDIF
      LINHA := AllTrim( FREADLINE( nHANDLE ) )
      IF LINHA = LINHA1
         EXIT
      ENDIF
      IF LINHA = "__FINAL__"
         EXIT
      ENDIF
   ENDDO
   FClose( nHANDLE )
   dbCloseAll()

   RETURN


// + EOF: fopto_4v.prg
// +
