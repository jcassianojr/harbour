// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4x.prg
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

CABE3( 'FOPTO_4X - Preparacao Arquivo Portaria 1520', 23 )
nANOINI := anouso   // 2009
nANOFIM := anouso   // YEAR(DATE())
nMESINI := MESTRAB  // 8
nMESFIM := MESTRAB

cPRO  := "N"
cFIX  := "N"
cAVU  := "N"
cTUR  := "N"
cOCO  := "N"
cAFD  := "N"
cAFDT := "S"
cDESC := "N"
cAFDC := "N"

@ 05, 01 SAY "Provisorios"
@ 06, 01 SAY "Horario Fixo/Escala"
@ 07, 01 SAY "Horarios Avulsos"
@ 08, 01 SAY "Troca Turnos"
@ 09, 01 SAY "Ocorrencias"
@ 10, 01 SAY "Escalas do Mes"
@ 11, 01 SAY "Ponto Horario"
@ 12, 01 SAY "GERAR AFD"
@ 12, 32 SAY "PergComp"
@ 13, 01 SAY "GERAR AFDT"
@ 13, 32 SAY "Limpar D"
@ 14, 01 SAY "PERIODO"
@ 05, 30 GET cPRO                  PICT "!"    VALID cPRO $ "SN"
@ 06, 30 GET cFIX                  PICT "!"    VALID cFIX $ "SN"
@ 07, 30 GET cAVU                  PICT "!"    VALID cAVU $ "SN"
@ 08, 30 GET cTUR                  PICT "!"    VALID cTUR $ "SN"
@ 09, 30 GET cOCO                  PICT "!"    VALID cOCO $ "SN"
@ 12, 30 GET cAFD                  PICT "!"    VALID cAFD $ "SN"
@ 12, 40 GET cAFDC                 PICT "!"    VALID cAFDC $ "SN"
@ 13, 30 GET cAFDT                 PICT "!"    VALID cAFDT $ "SN"
@ 13, 40 GET cDESC                 PICT "!"    VALID cDESC $ "SN"
@ 14, 10 GET nMESINI               PICT "99"
@ 14, 15 GET nANOINI               PICT "9999"
@ 14, 30 GET nMESFIM               PICT "99"
@ 14, 35 GET nANOFIM               PICT "9999"
IF !READCUR()
RETU .F.
ENDIF

FOR X := nANOINI TO nANOFIM
@ 23, 00 SAY X
nMESINI := IF( X = nANOINI, nMESINI, 1 )
nMESFIM := IF( X = nANOFIM, nMESFIM, 12 )
FOR Y := nMESINI TO nMESFIM
@ 23, 10 SAY Y
ANOWORK  := SubStr( StrZero( X, 4 ), 3, 2 )
MESWORK  := StrZero( Y, 2 )
ANOUSO   := X
MESTRAB  := Y
ANOMESW  := ANOWORK + MESWORK
cMESANO  := SubStr( StrZero( X, 4 ), 3, 2 ) + StrZero( Y, 2 )
ZFECHADO := "N"
PEGFOLPAT()
IF NETUSE( "FOPTOCOM" )
dbGoTop()
IF dbSeek( Str( ANOUSO, 4 ) + Str( MESTRAB, 2 ) + Str( NREMP, 8 ) )
ZDATAINI := DATAINI
ZDATAFIM := DATAFIM
ELSE
ZDATAINI := CToD( "01/" + StrZero( MESTRAB, 2 ) + "/" + StrZero( ANOUSO, 4 ) )
ZDATAFIM := EOM( ZDATAINI )
ZDATAINI -= 10
ENDIF
ELSE
ZDATAINI := CToD( "01/" + StrZero( MESTRAB, 2 ) + "/" + StrZero( ANOUSO, 4 ) )
ZDATAFIM := EOM( ZDATAINI )
ZDATAINI -= 10
ENDIF
dbCloseArea()
FO21CRI( "PN", "FO_PON", "STR(NUMERO,8)+DTOS(DATA)" )
FO21CRI( "PE", "FOPTOREV", "GRUPO+DTOS(DATA)" )
FO21CRI( "PO", "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )
FO21CRI( "PM", "FO_PMAN", "STR(NUMERO,8)+DTOS(DATOCO)+TIPOCO" )
FO21CRI( "PH", "FO_PHOR", "STR(NUMERO,8)+DTOS(OCOINI)" )
IF cPRO = "S"
@ 22, 00 SAY "Acertando provisorios"
trocapro( "PD" + ANOMESW, ZDATAINI, ZDATAFIM )
ENDIF
IF cFIX = "S"
@ 22, 00 SAY "Horarios Fixos Escalas"
fopto_43()   // Ajustar horarios
ENDIF
IF cAVU = "S"
@ 22, 00 SAY "Horarios Avulsos"
FOPTO_2I( .F. )  // horarios avulsos     FOPTO_4M cPM FO_PMAN
ENDIF
IF cTUR = "S"
@ 22, 00 SAY "Troca de Turnos"
FOPTO_2J( .F. )  // correcao de horarios FOPTO_4L cPH FO_PHOR
ENDIF
IF cOCO = "S"
@ 22, 00 SAY "Ocorrencias"
FOPTO_2H( .F. )  // ocorrencia           FOPTO_4T cPM FO_POCO
ENDIF
IF cAFD = "S"
geraafd( if( Cafdc = "S", .T., .F. ) )
ENDIF
IF cAFDT = "S"
@ 22, 00 SAY "AFDT"
FOPTO_3L( .F., if( Cdesc = "S", .T., .F. ) )
ENDIF
@ 22, 00 SAY Space( 80 )

dbCloseAll()


NEXT Y
NEXT X
ALERTX( "E NECESSARIO ENCERRAR O PROGRAMA" )
QUIT



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GERAAFD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GERAAFD( lPER )

   aAFD := {}
   IF netuse( "FOPTOEQP" )
      WHILE !Eof()
         IF GERAAFD = "S"
            AAdd( aAFD, NUMERO )
         ENDIF
         dbSkip()
      ENDDO
      dbCloseAll()
   ELSE
      RETURN
   ENDIF
   FOR Z := 1 TO Len( aAFD )   // gerar afd  dos relogios geraafd ="S"
      @ 22, 00 SAY "AFD - Relogio " + StrZero( aAFD[ Z ] )
      FOPTO_19( lPER, "D", 1, aAFD[ Z ] )
   NEXT

   RETURN




// + EOF: fopto_4x.prg
// +
