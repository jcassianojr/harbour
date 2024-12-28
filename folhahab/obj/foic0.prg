// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foic0.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :      FOIC0.PRG: Acumulado Dados para o Resumo Departamento II
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 15/07/98
// :
// :*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foic0()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foic0

   PARA CCARQ

   CABEX( 'Acumulado Dados para o Resumo Departamento II' )

   IF !NETUSE( "DEPTO" )   // /AREDE("DEPTO","DEPTO",1)
      RETU
   ENDIF

   IF MDG( 'Deseja apagar acumulo anterior' )
      netzap( "AJUGER" )
      IF !NETUSE( "AJUGER" )   // BREDE("AJUGER",0)
         RETU
      ENDIF
      MDS( 'Criando Arquivo de Trabalho' )
      dbSelectAr( "DEPTO" )
      dbGoTop()
      WHILE !Eof()
         DEP := DEPTO
         SET := SETOR
         SEC := SECAO
         NOM := NOMEC
         CON := CONTROLE
         dbSelectAr( "AJUGER" )
         netrecapp()
         FIELD->DEPTO    := DEP
         FIELD->SETOR    := SET
         FIELD->SECAO    := SEC
         FIELD->NOME     := NOM
         FIELD->CONTROLE := CON
         dbSelectAr( "DEPTO" )
         dbSkip()
      ENDDO
      dbCloseAll()
   ENDIF

   MDS( 'Aguarde Acumulando Dados' )
   IF !ARQPES( CCARQ, 1, 1 )
      RETU
   ENDIF
   cSELE1 := Alias()

   IF !ARQUSAR( CCARQ, 1 )
      RETU .F.
   ENDIF
   cSELE2 := Alias()

   IF !ARQCTA( CCARQ, 1, 1 )
      RETU
   ENDIF
   FILTRO := 'RESG>0.AND.RESG<6'
   SET FILTER TO &FILTRO
   cSELE3 := Alias()

   IF !NETUSE( "AJUGER" )  // BREDE("AJUGER",0)
      RETU
   ENDIF

   DECLARE BUS[ 3 ]
   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      PETELA( 7 )
      CTR  := NUMERO
      MADM := MDEM := MATI := SALH := SALM := 0
      SALHM()
      BUS[ 1 ] = DEPTO * 1000000
      BUS[ 2 ] = DEPTO * 1000000 + SETOR * 1000
      BUS[ 3 ] = DEPTO * 1000000 + SETOR * 1000 + SECAO
      IF Month( ADMITIDO ) = MES .AND. Year( ADMITIDO ) = ANO
         MADM := 1
      ENDIF
      IF Month( DEMITIDO ) = MES
         MDEM := 1
      ENDIF
      IF Empty( DEMITIDO ) .OR. Month( DEMITIDO ) >= MES
         MATI := 1
      ENDIF
      dbSelectAr( "AJUGER" )
      FOR X := 1 TO 3
         dbGoTop()
         IF dbSeek( BUS[ X ] )
            NETRECLOCK()
            FIELD->ADM     := ADM + MADM
            FIELD->DEM     := DEM + MDEM
            FIELD->ATI     := ATI + MATI
            FIELD->SALARIO := SALARIO + SALM
            dbUnlock()
         ENDIF
      NEXT
      IF MATI = 1
         dbSelectAr( cSELE3 )
         dbGoTop()
         WHILE !Eof()
            TIT := DESCR
            CTA := CODIGO
            CCC := RESG
            MDS( TIT )
            BUSCA := ( CTR * 10000 ) + CTA
            dbSelectAr( cSELE2 )
            dbGoTop()
            IF dbSeek( BUSCA )
               QTW := 'QT' + Str( CCC, 1 )
               VLW := 'VL' + Str( CCC, 1 )
               HOR := HORAS
               VAL := VALOR
               dbSelectAr( "AJUGER" )
               FOR X := 1 TO 3
                  dbGoTop()
                  IF dbSeek( BUS[ X ] )
                     NETRECLOCK()
                     FIELD->&QTW := &QTW + HOR
                     FIELD->&VLW := &VLW + VAL
                     dbUnlock()
                  ENDIF
               NEXT
            ENDIF
            dbSelectAr( cSELE3 )
            dbSkip()
         ENDDO
      ENDIF
      dbSelectAr( cSELE1 )
      dbSkip()
   ENDDO
   dbSelectAr( "AJUGER" )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netrecdel() }, {|| QT1 = 0 .AND. QT2 = 0 .AND. QT3 = 0 .AND. QT4 = 0 .AND. QT5 = 0 .AND. VL1 = 0 .AND. VL2 = 0 .AND. VL3 = 0 .AND. VL4 = 0 .AND. VL5 = 0 }, {|| zei_fort( nLASTREC,,, 1 ) } )
   dbCloseAll()
   netPACK( "AJUGER" )
   RETU
// : FIM: FOIC0.PRG

// + EOF: foic0.prg
// +
