// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foptop.prg
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
// +    Documentado em 27-Dez-2024 as  9:34 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABE2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CABE2( TITULO )

   SetColor( "N/W" )
   @ 02, 25 CLEA TO 02, 80
   @ 02, 25 SAY " Ý " + TITULO
   SetColor( "W/N,N/W" )
   @ 03, 00 clea

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABEX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CABEX( cTITULO )

   CABE2( cTITULO )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABEC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABEC( TITULO, TITULO2, nCOL, TITULO3, cSETOR )

   IF ValType( nCOL ) # "N"
      nCOL := 50
   ENDIF
   IF ValType( TITULO2 ) # "C"
      TITULO2 := ""
   ENDIF
   IF ValType( TITULO3 ) # "C"
      TITULO3 := 'Funcionario'
   ENDIF
   @  0, 0    SAY repl( "=", 80 )
   @  1, 6    SAY AllTrim( ZEMPRESA ) + " " + ACENTO( TITULO )
   @  2, 0    SAY "Referencia: " + DToC( DIAX ) + " Impressao: " + DToC( Date() ) + " - " + Time() + "  Pag: " + Str( pag, 4 )
   @  3, 0    SAY repl( "=", 80 )
   @  4, 0    SAY ACENTO( TITULO3 )
   @  5, nCOL SAY ACENTO( TITULO2 )
   IF ValType( cSETOR ) = "C"
      @  6, 0 SAY cSETOR
      @  7, 0 SAY repl( "-", 80 )
   ELSE
      @  6, 0 SAY repl( "-", 80 )
   ENDIF
   PAG++

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RODAP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION RODAP

   @ PRow() + 1, 0  SAY repl( "-", 80 )
   @ PRow() + 2, 40 SAY repl( "-", 35 )
   @ PRow() + 1, 45 SAY 'Assinatura do RH'
   IMPFOL()

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABE3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CABE3( TITULO, QT )

   SetColor( "W/N,N/W" )
   @ 02, 00 CLEA TO 03, 79
   @ 04, 00 clea
   SetColor( "N/W" )
   @ 02, 00 CLEA TO 02, 79
   @ 02, 00 SAY "  " + TITULO
   SetColor( "+GR/BG" )
   hb_DispBox( 3, 0, QT, 79, B_DOUBLE + " " )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MDL( TITULO )

   CABE2( TITULO )
   @ 19, 00 TO 21, 79 DOUB
   @ 20, 03 SAY 'LIGUE A IMPRESSORA !! ,Ajuste o papel'

   RETURN CHECKIMP( 0 )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function INCIDE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION INCIDE

   XA := FATOR
   XB := TIPO
   XC := TRIBUTINPS
   XD := TRIBUTIRR
   XE := TRIB_FGTS
   XF := VALOR

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRAVA1

   netreclock()
   &FOL.->VALOR      := VALE
   &FOL.->FATOR      := XA
   &FOL.->TIPO       := XB
   &FOL.->TRIBUTINPS := XC
   &FOL.->TRIBUTIRR  := XD
   &FOL.->TRIB_FGTS  := XE
   &FOL.->VALORBASE  := XF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRAVA

   &FOL.->NUMERO   := CTR
   &FOL.->CONTA    := CTR1
   &FOL.->CONTROLE := CTA

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRAVA2

   PARA CTR1

   SELE 3
   dbGoTop()
   IF dbSeek( CTR1 )
      INCIDE()
   ENDIF
   CTA := ( CTR * 10000 ) + CTR1
   SELE 2
   dbGoTop()
   IF !dbSeek( CTA )
      netrecapp()
      GRAVA()
   ENDIF
   GRAVA1()

   RETURN .T.





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGCX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PEGCX( cTIPO )

   LOCAL aCODCTA := Array( 24 )

   IF ValType( cTIPO ) # "C"
      cTIPO := "C"
   ENDIF
   AFill( aCODCTA, 0 )
   IF !netuse( "FOPTOCON" )
      RETURN aCODCTA
   ENDIF
   IF !dbSeek( nremp )
      dbGoTop()
   ENDIF
   DO CASE
   CASE cTIPO = "T"
      aCODCTA := { TR01, TR02, TR03, TR04, TR05, TR06, TR07, TR08, ;
         TR09, TR10, TR11, TR12, TR13, TR14, TR15, TR16, ;
         TR17, TR18, TR19, TR20, TR21, TR22, TR23, TR24 }
   CASE cTIPO = "I"
      aCODCTA := { VI01, VI02, VI03, VI04, VI05, VI06, VI07, VI08, ;
         VI09, VI10, VI11, VI12, VI13, VI14, VI15, VI16, ;
         VI17, VI18, VI19, VI20, VI21, VI22, VI23, VI24 }
   CASE cTIPO = "F"
      aCODCTA := { FS01, FS02, FS03, FS04, FS05, FS06, FS07, FS08, ;
         FS09, FS10, FS11, FS12, FS13, FS14, FS15, FS16, ;
         FS17, FS18, FS19, FS20, FS21, FS22, FS23, FS24 }
   OTHERWISE
      aCODCTA := { CX01, CX02, CX03, CX04, CX05, CX06, CX07, CX08, ;
         CX09, CX10, CX11, CX12, CX13, CX14, CX15, CX16, ;
         CX17, CX18, CX19, CX20, CX21, CX22, CX23, CX24 }
   ENDCASE
   dbCloseAll()

   RETURN aCODCTA


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function AHOR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION AHOR

   PARA QTHOR

   QT1 := Int( QTHOR )
   QT2 := QTHOR - QT1
   DO CASE
   CASE QT2 < .25
      QT3 := 0
   CASE QT2 >= .25 .AND. QT2 < .75
      QT3 := .5
   CASE QT2 >= .75
      QT3 := 1
   ENDCASE

   RETURN QT1 + QT3






// +--------------------------------------------------------------------
// +
// +
// +
// +    Function pegcompete()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION pegcompete( lFECHA )

   IF !NETUSE( "FOPTOCOM" )
      RETURN .F.
   ENDIF
   dbGoTop()
   IF !dbSeek( Str( ANOUSO, 4 ) + Str( MESTRAB, 2 ) + Str( NREMP, 8 ) )
      netrecapp()
      field->mes     := mestrab
      field->ano     := anouso
      field->empresa := Nremp
      field->dataini := Date()
      field->datafim := Date() + 30
   ELSE
      netreclock()
   ENDIF
   IF ValType( lFECHA ) = "L"
      IF lFECHA
         field->fechado := "S"
      ELSE
         field->fechado := "N"
      ENDIF
   ENDIF
   IF Empty( MESEXT )
      FIELD->MESEXT := Left( CMES( DATAINI ), 3 ) + "/" + StrZero( Year( DATAINI ), 4 )
   ENDIF
   MDS( "Periodo" )
   IF FIELD->FECHADO = "S"
      MDT( "COMPETENCIA JA FECHADA" )
      ZTIPVID := "V"
   ELSE
      @ MaxRow(), 20 GET DATAINI
      @ MaxRow(), 30 GET DATAFIM VALID DATAFIM >= DATAINI
      @ MaxRow(), 40 GET MESEXT
      READCUR()
      dbUnlock()
      ZTIPVID := "T"
   ENDIF
   ZDATAINI := DATAINI
   ZDATAFIM := DATAFIM
   ZFECHADO := FECHADO
   dbGoTop()
   WHILE !Eof()
      IF FIELD->FECHADO <> "S" .AND. ( FIELD->ANO < ANOUSO .OR. ( FIELD->ANO = ANOUSO .AND. FIELD->MES < ( MESTRAB - 2 ) ) )
         netreclock()
         netgrvcam( "FECHADO", "S" )
         dbUnlock()
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()

   cPD := "PD" + ANOMESW
   cPP := "PP" + ANOMESW
   cPA := "PA" + ANOMESW

// testa criacao relogio evitar erros
   CHECKCRI( cPD, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
// testa criacao portaria evitar erros
   CHECKCRI( cPP, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
// testa criacao refeitorio evitar erros
   CHECKCRI( cPA, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )

   RETURN

// + EOF: foptop.prg
// +
