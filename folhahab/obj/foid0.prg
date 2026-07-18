// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foid0.prg
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
// :     FOID0.PRG : Acumular apura‡„o Folha
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 17/07/98
// :
// :*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foid0()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foid0

   PARA CC

   CABEX( 'Acumular apura‡„o Folha' )
   IF MDG( 'Deseja Apagar Acumulo Anterior' )
      netZAP( "FO_APU" )
   ENDIF

   IF !ARQUSAR( CC, 1, 0 )
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "conta" )
   ordSetFocus( "temp" )

   cSELE1 := Alias()

   IF !ARQCTA( CC, 1, 1 )
      RETU
   ENDIF
   cSELE2 := Alias()

   IF !NETUSE( "FO_APU" )  // AREDE("FO_APU","FO_APU",0)
      RETU
   ENDIF

   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      CTA := CONTA
      TOT := TOT1 := 0
      WHILE CTA = CONTA .AND. !Eof()
         TOT  += VALOR
         TOT1 += HORAS
         dbSkip()
      ENDDO
      IMP := .T.
      IF CC # 4 .AND. CC # 6
         IF CTA > 120 .AND. CTA < 150
            IMP := .F.
         ENDIF
         IF CTA = 910 .OR. CTA = 911 .OR. CTA = 505 .OR. CTA = 506
            IMP := .F.
         ENDIF
      ENDIF
      IF IMP
         dbSelectAr( cSELE2 )
         dbGoTop()
         NOM := IF( dbSeek( CTA ), DESCR, 'Conta nao Cadastrada' )
         POS := 64
         IF CC # 6
            DO CASE
            CASE CTA > 40 .AND. CTA < 50
               POS := 86
            CASE CTA > 501
               POS := 86
            CASE CTA > 399 .AND. CTA < 502
               POS := 108
            ENDCASE
         ENDIF
         dbSelectAr( "FO_APU" )
         dbGoTop()
         IF !dbSeek( CTA )
            netrecapp()
            FIELD->CONTA := CTA
         ELSE
            netreclock()
         ENDIF
         FIELD->HORAS := HORAS + TOT1
         FIELD->VALOR := VALOR + TOT
         FIELD->NOME  := NOM
         FIELD->COL   := POS
      ENDIF
      dbSelectAr( cSELE1 )
   ENDDO
   dbCloseAll()
   RETU
// : FIM: FOID0.PRG

// + EOF: foid0.prg
// +
