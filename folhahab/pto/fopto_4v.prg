*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_4V.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

CABE2( "FOPTO_4V - Importar Escala de Revezamento" )

cPE := "PE" + ANOMESW 
CHECKCRI( cPE, "FOPTOREV", "GRUPO+DTOS(DATA)" )

//cARQ := space( 40 )
//MDS( "Digite o Nome do Arquivo" )
//@ 24, 30 get cARQ
//if !READCUR()
//   retu .F.
//endif
//cARQ := alltrim( cARQ )
cARQ:=win_GetOpenFileName(, "Arquivos de Escala de Revezamento",HB_CWD(), "Arquivos de Escala de Revezamento", "*.*", 1 )


if ! HB_FILEEXISTS( cARQ )
   ALERTX( "Nao encontrei Arquivo: " + cARQ )
   retu .F.
endif


if ! NETUSE(cPE) 
   retu .f.
endif
nHANDLE := fopen( cARQ )
if nHANDLE <= 0
   ALERTX( "Nao Consegui abrir o Arquivo: " + cARQ )
   dbcloseall()
   retu .F.
endif


LINHA1 := FREADLINE( nHANDLE )
LINHA  := alltrim( LINHA1 )
while .T.
   if !empty( LINHA )
      mGRUPO:=substr( LINHA, 1, 2 )
      dINI := substr( LINHA, 3, 6 )
      tDIA := substr( dINI, 1, 2 )
      tMES := substr( dINI, 3, 2 )
      tANO := substr( dINI, 5, 2 )
      dINI := ctod( tDIA + "/" + tMES + "/" + tANO )
      mCHAVE := mGRUPO + dtos( dINI )
      DBGOTOP()
      IF ! DBSEEK(mCHAVE)
         netrecapp()
         FIELD->GRUPO:=mGRUPO
         field->DATA:=dINI
      ELSE
         netreclock()
      ENDIF
      field->cODREV:=substr( LINHA, 9, 2 )
      field->ENTREV:=VAL(substr( LINHA, 11, 4 ))/100
      field->ALIREV:=VAL(substr( LINHA, 15, 4 ))/100
      field->ALSREV:=VAL(substr( LINHA, 19, 4 ))/100
      field->SAIREV:=VAL(substr( LINHA, 23, 4 ))/100
      field->VIRADA:=substr( LINHA, 27, 2 )
      DBUNLOCK()
   endif
   LINHA := alltrim( FREADLINE( nHANDLE ) )
   if LINHA = LINHA1
      exit
   endif
   IF LINHA = "__FINAL__"
      exit
   endif
enddo
fclose( nHANDLE )
dbcloseall()

*+ EOF: FOPTO_4V.PRG
