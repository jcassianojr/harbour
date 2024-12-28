// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib26.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +






// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CONFARQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CONFARQ( cARQ, eCAB, eEXI )

   WHILE .T.
      IF useCHK( ZDIRC + ZARQ, ZDIRC + ZARQ, .T. )
         EXIT
      ELSE
         RETU .F.
      ENDIF
   ENDDO
   dbGoTop()
   IF !dbSeek( cARQ )
      dbCloseArea()
      ALERTX( "Falta configura‡„o do Arquivo de Dados " + cARQ )
      lFIXA := .T.
      // nACHO := 999999 //4096 harbour sem limiete array
      cVIDE := 'N'
      lPBUS := .F.
      lPIND := .F.
      mCBAR := ""
      cTIPG := "1"
      cCBAS := ""
      nIBUS := 1
      nIEXI := 1
      RETU .F.
   ENDIF
   lFIXA := if( FIXAR = 'S', .T., .F. )
// nACHO := LACHI
// IF nACHO=0
// nACHO:=  999999 //4096 harbour sem limiete array
// ENDIF
   nACHO := 999999   // 4096 harbour sem limiete array
   cVIDE := VIDEO
   lPBUS := if( PBUS = 'S', .T., .F. )
   lPIND := if( PIND = 'S', .T., .F. )
   mCBAR := cBAR
   cTIPG := TIPG
   cCBAS := CBAS
   nIBUS := if( !lPBUS .AND. IBUS > 0, IBUS, 1 )
   nIEXI := if( !lPIND .AND. IEXI > 0, IEXI, 1 )
   dbCloseArea()
   IF Empty( cCBAS ) .AND. ValType( eCAB ) = "C"
      cCBAS := eCAB
   ENDIF
   IF Empty( mCBAR ) .AND. ValType( eEXI ) = "C"
      mCBAR := eEXI
   ENDIF
   mCBARM := mCBAR
   mCBAR  := StrTran( mCBAR, "m", "" )
   IF cTIPG = "3"
      PEGAGET( cARQ )
   ENDIF
   RETU .T.


// + EOF: mlib26.prg
// +
