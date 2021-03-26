*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_2G.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

CABE2( "FOPTO_2G - Importar Ocorrencias" )

cPO := "PO" + ANOMESW //ANOWORK + strzero( MES, 2 )
CHECKCRI( cPO, "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )

//cARQ := space( 40 )
//MDS( "Digite o Nome do Arquivo" )
//@ 24, 30 get cARQ
//if !READCUR()
//   retu .F.
//endif
//cARQ := alltrim( cARQ )
cARQ:=win_GetOpenFileName(, "Arquivos de Ocorrencias",HB_CWD(), "Arquivos de Ocorrencias", "*.*", 1 )

if ! HB_FILEEXISTS( cARQ )
   ALERTX( "Nao encontrei Arquivo: " + cARQ )
   retu .F.
endif
nHANDLE := fopen( cARQ )
if nHANDLE <= 0
   ALERTX( "Nao Consegui abrir o Arquivo: " + cARQ )
   retu .F.
endif
lCONF:=MDG("Conferir funcionario a funcionario")
lOCOR:=MDG("Gravar em SIM=ocorrencias NAO=Ponto")
aNUM   := {}
aINI   := {}
aFIM   := {}
aCOD   := {}
LINHA1 := FREADLINE( nHANDLE )
LINHA  := alltrim( LINHA1 )
while .T.
   if !empty( LINHA )
      dINI := substr( LINHA, 9, 6 )
      tDIA := substr( dINI, 1, 2 )
      tMES := substr( dINI, 3, 2 )
      tANO := substr( dINI, 5, 2 )
      dINI := ctod( tDIA + "/" + tMES + "/" + tANO )
      dFIM := substr( LINHA, 15, 6 )
      tDIA := substr( dFIM, 1, 2 )
      tMES := substr( dFIM, 3, 2 )
      tANO := substr( dFIM, 5, 2 )
      dFIM := ctod( tDIA + "/" + tMES + "/" + tANO )
      aadd( aNUM, val( left( LINHA, 8 ) ) )
      aadd( aINI, dINI )
      aadd( aFIM, dFIM )
      aadd( aCOD, if( len( LINHA ) = 22, right( LINHA, 2 ), "  " ) )
   endif
   LINHA := alltrim( FREADLINE( nHANDLE ) )
   if LINHA = LINHA1
      exit
   endif
enddo
fclose( nHANDLE )

cPN := "PN" + ANOMESW //ANOWORK + strzero( MES, 2 )
CRIARVARS( PES )

for W := 1 to len( aNUM )
   mNUMERO := aNUM[ W ]
   dINI    := aINI[ W ]
   dFIM    := aFIM[ W ]
   dOCO    := aCOD[ W ]
   if IGUALVARS( PES, PESIND, mNUMERO )
      IF lCONF
         @ 05, 00 say mNUMERO
         @ 05, 10 say mNOME
         @ 06, 00 say "Data inicial"
         @ 06, 20 say "Data Final"
         @ 06, 40 say "Codigo"
         @ 07, 00 get dINI
         @ 07, 20 get dFIM
         @ 07, 40 get dOCO           valid !empty( dOCO )
         READCUR()
      ENDIF
      if ! empty( dOCO )
         if ! lOCOR //se nao for ocorrencia gravar ponto
            if NETUSE(cPN) //AREDE( cPN, cPN, 1 )
               for J := dINI to dFIM
                  dbgotop()
                  if dbseek( str( mNUMERO, 8 ) + dtos( J ) )
                     netreclock()
                     field->COD := dOCO
                     dbunlock()
                  endif
               next
               dbclosearea()
            endif
         else
            if NETUSE(cPO) //AREDE( cPO, cPO, 1 )
               dbgotop()
               if !dbseek( str( mNUMERO, 8 ) + dtos( dINI ) )
                  netrecapp()
                  field->NUMERO := mNUMERO
                  field->OCOINI := dINI
               else
                  netreclock()
               endif
               field->OCOFIM := dFIM
               field->OCOCOD := dOCO
               dbunlock()
            endif
            dbclosearea()
         endif
      endif
   else
      IF lCONF
         ALERTX( "Funcion rio nao Cadastrado: " + str( mNUMERO ) )
      ENDIF
   endif
next W

IF lCONF
   if MDG( "Deseja imprimir arquivo Importado" )
      IMPARQ( cARQ )
   endif
   //FOPTO_2H(.T.)
else
   //FOPTO_2H(.F.)
endif

*+ EOF: FOPTO_2G.PRG
