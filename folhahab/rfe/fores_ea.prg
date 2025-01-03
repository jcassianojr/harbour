// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_ea.prg AVISO PREVIO DE FERIAS
// +
// +
// +
// +     Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


FUNCTION fores_ea()

   EMITIDO := GOZOU1DE - 32
   EMITIDO := EMITIDO - IF( DoW( EMITIDO ) = 7, 1, 0 )
   EMITIDO := EMITIDO + IF( DoW( EMITIDO ) = 1, 1, 0 )
   RETORNO := GOZOU1ATE + 1
   @ 22, 00
   @ 22, 00 SAY 'Confirme Data de Emiss„o'
   @ 23, 00 SAY 'Confirme Data de Retorno'
   @ 22, 40 GET EMITIDO
   @ 23, 40 GET RETORNO
   READCUR()



   IMPRESSORA()
   FOR X := 1 TO COP
      @ PRow() + 1, 0 SAY IMPCHR( cIMPTIT ) + 'AVISO PREVIO DE FERIAS'
      @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM ) + 'De acordo com o art. 135 da C.L.T., participando no minimo com 30 dias de antecedencia (nova redacao dada pela lei 7414/85)' + IMPSTR( cIMPEXP )
      @ PRow() + 1, 0 SAY REPL( '=', 80 )
      @ PRow() + 2, 0 SAY 'Local: ' + CID1 + ',' + EST1 + '-' + DToC( EMITIDO )
      @ PRow() + 2, 0 SAY 'Firma ' + MSG2
      @ PRow() + 1, 0 SAY 'Endereco ' + ENDER1 + '-' + BAI1 + '-' + CID1 + '-' + EST1
      @ PRow() + 1, 0 SAY REPL( '=', 80 )
      dbSelectAr( PES )
      @ PRow() + 2, 0 SAY 'Sr.(a)'
      @ PRow() + 1, 0 SAY 'Numero: ' + Str( NUMERO ) + ' Nome: ' + NOME
      @ PRow() + 1, 0 SAY 'CTPS: ' + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, CPF, PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
      @ PRow() + 2, 0 SAY IMPSTR( cIMPCOM ) + 'Nos termos das Disposicoes legais vigentes, suas ferias serao concedidas conforme demonstrativo abaixo:' + IMPSTR( cIMPEXP )
      dbSelectAr( "FO_FER" )
      @ PRow() + 1, 0  SAY REPL( '-', 80 )
      @ PRow() + 1, 0  SAY "Periodo Aquisitivo" + SPAC( 13 ) + "Periodo de Gozo" + SPAC( 15 ) + "Retorno ao trabalho"
      @ PRow() + 1, 9  SAY "a" + SPAC( 29 ) + "a"
      @ PRow(), 0    SAY DATFERIAS
      @ PRow(), 11    SAY DATFERIASF
      @ PRow(), 30    SAY GOZOU1DE
      @ PRow(), 41    SAY GOZOU1ATE
      @ PRow(), 67    SAY RETORNO
      @ PRow() + 1, 0  SAY REPL( '-', 80 )
      @ PRow() + 2, 0  SAY IMPSTR( cIMPCOM ) + 'Favor Apresentar a sua Carteira de Trabalho e Previdencia Social ao Departamento de Pessoal para as anotacoes necessarias.' + IMPSTR( cIMPEXP )
      @ PRow() + 1, 0  SAY REPL( '=', 80 )
      @ PRow() + 3, 0  SAY REPL( '-', 30 )
      @ PRow(), 39    SAY REPL( '-', 30 )
      @ PRow() + 1, 10 SAY 'Empregador'
      @ PRow(), 49    SAY 'Empregado'
      @ PRow() + 2, 0  SAY REPL( '=', 80 )
      IMPFOL()
   NEXT X
   VIDEO()
   IMPEND()
   RETU
// : FIM: FORES_EA.PRG

// + EOF: fores_ea.prg
// +
