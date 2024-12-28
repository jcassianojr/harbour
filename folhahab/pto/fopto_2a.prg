// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_2a.prg
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO_2A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO_2A

   PARA cFILTRO

   cPN := "PN" + ANOMESW

   CABE2( 'FOPTO_2A - Zerando entradas/Saidas Grupo de Funcionarios' )
   IF ValType( cFILTRO ) # "C"
      IF !MDG( "Zerar Entradas/Saidas" )
         RETU .F.
      ENDIF
   ENDIF
   MDS( "Aguarde Zerando Dados" )
   IF !Netuse( cPN )
      RETU
   ENDIF
   IF ValType( cFILTRO ) # "C"
      FILTRO := ''
      FI     := Trim( FILTRO )
      FILTRO := FILTRO( FI )
   ELSE
      FILTRO := cFILTRO
   ENDIF
   SET FILTER TO &FILTRO
   dbGoTop()
   WHILE !Eof()
      netreclock()
      field->ENT := 0
      field->SAI := 0
      field->ALE := 0
      field->ALS := 0
      dbUnlock()
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU


// + EOF: fopto_2a.prg
// +
