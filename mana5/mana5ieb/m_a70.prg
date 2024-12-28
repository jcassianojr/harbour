// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a70.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   M_A70.PRG   : Cancelamento de Notas Fiscais Faturadas
// :   Linguagem   : Clipper 5.x
// :        Sistema: ITAESBRA (Mana5)
// :      Copyright (c) 1994 by Disk Softwares S/C Ltda.
// :
// :*****************************************************************************

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_a70()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_a70

   PARA NFNumero, lRETORNO, aARQ

   IF ValType( aARQ ) # "A"
      aARQ := { MM01, MM02, MM06, MN01, MO02 }
   ENDIF


// Modo de Trabalho no Video
   MDI( " Ý Cancelamento de Notas Fiscal/Retorno Saldo OS " )
   IF ValType( NFNumero ) # "N"
      NFNumero := 0
      MDS( "Digite o Numero da Nota Fiscal" )
      @ 24, 40 GET NFNumero PICT "99999999"
      READCUR()
   ENDIF
   IF aARQ[ 1 ] <> "MM01"
      lRETORNO := .F.  // So Retorna Mes Corrente
   ENDIF
   IF ValType( lRETORNO ) # "L"
      lRETORNO := MDG( "Retornar Saldo de OS" )
   ENDIF
   IF lRETORNO
      IF !USEMULT( { { "MM02", 1, 4 }, { "MO02", 1, 4 } } )
         RETU .F.
      ENDIF
      dbSelectAr( "MM02" )
      dbGoTop()
      dbSeek( NFNumero )
      WHILE NFNumero = NUMERO .AND. !Eof()
         mOS   := OS
         mQTDE := QTDE
         mDEV  := DEV
         IF mOS > 0
            dbSelectAr( "MO02" )
            dbGoTop()
            IF dbSeek( mOS )
               netreclock()
               FIELD->QTDEENT  := QTDEENT - mQTDE
               FIELD->QTDESAL  := QTDEPED - QTDEENT
               FIELD->VALORMER := QTDESAL * VALOR
               IF TIPOSERV = '3' .OR. TIPOSERV = '4'
                  FIELD->TOTSDEV := TOTSDEV - mDEV
               ENDIF
               dbUnlock()
            ENDIF
         ENDIF
         dbSelectAr( "MM02" )
         dbSkip()
      ENDDO
      dbCloseAll()
   ENDIF
   PADDEL( aARQ[ 1 ], NFNUMERO, "NUMERO", "NFNUMERO" )  // Cab
   PADDEL( aARQ[ 2 ], Str( NFNUMERO, 8 ), "NUMERO", "NFNUMERO" )   // Itens
   PADDEL( aARQ[ 3 ], Str( NFNUMERO, 8 ), "ORDEM", "NFNUMERO" )  // Dipi
   PADDEL( aARQ[ 4 ], Str( NFNUMERO, 8 ), "NUMERO", "NFNUMERO", 4 )   // Contas
   RETU .T.

// + EOF: m_a70.prg
// +
