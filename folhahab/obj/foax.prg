// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foax.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOAX.PRG: Excluindo Lancamentos da Folha
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:35
// :
// :*****************************************************************************
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foax()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foax

   PARA CC, CY
   LOCAL lPACK

   lPACK := .F.

   CABEX( 'Excluindo Lancamentos da Folha' )
   CTR := 0

   IF !ARQUSAR( CC )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE1 := Alias()


   IF CY = 1
      MDS( 'NUMERO DA CONTA .....->' )
      @ 24, 35 GET CTR PICT "###"
      IF !READCUR()
         RETU .F.
      ENDIF
      IF !ARQCTA( CC )
         dbCloseAll()
         RETU .F.
      ENDIF
      cSELE2 := Alias()
      dbGoTop()
      IF dbSeek( CTR )
         IF CC = 6 .OR. ACEITE # "S" .OR. ZUSER = "SUPERVISOR"
            hb_DispBox( 9, 16, 13, 62, B_DOUBLE + " " )
            @ 09, 24 SAY "-"
            @ 13, 24 SAY "-"
            @ 10, 18 SAY "Conta Ý Descrimina‡„o"
            @ 11, 16 SAY 'Ç' + REPL( '-', 7 ) + "+" + REPL( '-', 37 ) + '¶'
            @ 12, 24 SAY "Ý"
            @ 12, 19 SAY CTR                                  PICT '###'
            @ 12, 26 SAY DESCR
            SET COLOR TO + R / GR
            hb_DispBox( 15, 0, 21, 79, B_DOUBLE + " " )
            @ 17, 14 SAY "Aten‡„o !!!!"
            @ 18, 14 SAY "Vocˆ ira retirar todos os lan‡amentos da conta mencionada"
            @ 19, 14 SAY "que existirem no arquivo da folha deste mˆs OK !!!!"
            SET COLO TO
            IF MDG( 'Deseja Apagar (S/N)=>' )
               dbSelectAr( cSELE1 )
               nLASTREC := LastRec()
               zei_fort( nLASTREC,,, 0 )
               dbEval( {|| netrecDel() }, {|| CONTA = CTR }, {|| zei_fort( nLASTREC,,, 1 ) } )
               lPACK := .T.
            ENDIF
         ELSE
            ALERTX( "Exclus„o desta Conta Permitida Somente para o Supervisor" )
         ENDIF
      ENDIF
   ENDIF
   IF CY = 0
      MDS( 'NUMERO DO FUNCIONARIO->' )
      @ 24, 35 GET CTR PICT '#####'
      IF !READCUR()
         RETU .F.
      ENDIF
      IF !ARQPES( CC, 1, 1 )
         dbCloseAll()
         RETU .F.
      ENDIF
      cSELE3 := Alias()
      dbGoTop()
      IF dbSeek( CTR )
         PETELA( 10 )
         SET COLOR TO + R / GR
         hb_DispBox( 15, 0, 21, 79, B_DOUBLE + " " )
         @ 17, 14 SAY "Atencao !!!!"
         @ 18, 14 SAY "Vocˆ ira retirar todos os lan‡amentos deste funcion rio"
         @ 19, 14 SAY "que existirem no arquivo da folha deste mˆs OK !!!!"
         SET COLO TO
         IF MDG( 'Deseja apagar (S/N)=>' )
            dbSelectAr( cSELE1 )
            dbEval( {|| netrecdel() }, {|| NUMERO = CTR },,,, .F. )
            lPACK := .T.
         ENDIF
      ENDIF
   ENDIF
   IF CY = 2
      SET COLOR TO + R / GR
      hb_DispBox( 15, 0, 21, 79, B_DOUBLE + " " )
      @ 17, 11 SAY "Atencao !!!!"
      @ 18, 11 SAY "Vocˆ ira retirar todos os lan‡amentos - (Apagar todos os dados)"
      @ 19, 11 SAY "que existirem no arquivo da folha deste mˆs OK !!!!"
      SET COLO TO
      IF MDG( 'Vocˆ tem certeza' )
         IF MDG( 'Vocˆ realmente tem certeza' )
            dbSelectAr( cSELE1 )
            ZAP
         ENDIF
      ENDIF
   ENDIF
   IF lPACK
      PACK
   ENDIF
   dbCloseAll()
   RETU
// : FIM: FOAX.PRG

// + EOF: foax.prg
// +
