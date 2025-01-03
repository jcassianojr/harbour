// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foresrs.prg Exibe Campos do Arquivo de Remanejamento de Ferias
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


FUNCTION foresrs()

   @ 09, 9  SAY DEPTO
   @ 09, 22 SAY SETOR
   @ 09, 34 SAY SECAO
   @ 09, 46 SAY CHAPA
   @ 09, 60 SAY NUMERO
   @ 10, 9  SAY NOME
   @ 11, 19 SAY DATFERIAS
   @ 11, 30 SAY DATFERIASF
   @ 11, 58 SAY BAIXADO
   @ 12, 19 SAY SALVAR     PICT "###,###,###.##"
   @ 12, 58 SAY PROGRAMA
   @ 12, 69 SAY PROGRAMA1
   MESR := Month( DATFERIAS )
   FOR W := 1 TO 6
      @ 14, ( W * 9 ) + 2 SAY SubStr( MMES( MESR ), 1, 3 )
      MESR := MESR + IF( MESR < 12, + 1, - 11 )
   NEXT
   FOR W := 1 TO 7
      @ 15, ( W * 9 ) - 7 SAY SubStr( MMES( MESR ), 1, 3 )
      MESR := MESR + IF( MESR < 12, + 1, - 11 )
   NEXT
   @ 14, 16 SAY FA01
   @ 14, 25 SAY FA02
   @ 14, 34 SAY FA03
   @ 14, 43 SAY FA04
   @ 14, 52 SAY FA05
   @ 14, 61 SAY FA06
   @ 15, 07 SAY FA07
   @ 15, 16 SAY FA08
   @ 15, 25 SAY FA09
   @ 15, 34 SAY FA10
   @ 15, 43 SAY FA11
   @ 15, 52 SAY FA12
   @ 15, 61 SAY FA13
   @ 14, 75 SAY FALTAS
   @ 15, 76 SAY DIASJUS
   @ 17, 23 SAY GOZOU1DE
   @ 17, 34 SAY GOZOU1ATE
   @ 17, 56 SAY DIASPAGO
   @ 17, 74 SAY DIASGOZA
   @ 18, 23 SAY COMPDATAI
   @ 18, 34 SAY COMPDATAF
   @ 19, 23 SAY ABONO1DE
   @ 19, 34 SAY ABONO1ATE
   @ 19, 56 SAY DIASPAGO2
   @ 19, 74 SAY DIASGOZA2
   @ 20, 23 SAY GOZOU2DE
   @ 20, 34 SAY GOZOU2ATE
   @ 20, 56 SAY DIASPAGO3
   @ 20, 74 SAY DIASGOZA3
   @ 18, 55 SAY COMPABOI
   @ 18, 66 SAY COMPABOF
   RETU

// + EOF: foresrs.prg
// +
