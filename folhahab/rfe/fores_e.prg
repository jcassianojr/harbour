// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_e.prg
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :    FORES_E.PRG: Imprimir Recibos
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/08/94     13:06
// :
// :*****************************************************************************

IMPHP()


WHILE .T.
CABE3( "  Imprimir Recibos  ", 23 )
@ 09, 01 PROM ' A - Aviso de Ferias     =>  Imprime Aviso de F‚rias                  '
@ 10, 01 PROM ' B - Solicitacao Abono   =>  Imprime Solicitacao de Abono F‚rias      '
@ 11, 01 PROM ' C - Recibo de Ferias    =>  Imprime Recibo de F‚rias                 '
@ 12, 01 PROM ' D - Recibo Abono        =>  Imprime Recibo de Abono F‚rias           '
@ 13, 01 PROM ' E - Complemento Ferias  =>  Imprime Recibo de Complemento F‚rias     '
@ 14, 01 PROM ' F - Complemento Abono   =>  Imprime Recibo de Complemento Abono      '
@ 15, 01 PROM ' G - Imprime Resumo do Recibo de Rescis„o                             '
@ 16, 01 PROM ' H - Imprime Recibo de Rescis„o em formul rio Continuo                '
@ 17, 01 PROM ' I - Imprime Resumo do Recibo de Rescis„o Complementar                '
@ 18, 01 PROM ' J - Imprime Recibo de Rescis„o Complementar em formul rio Cont¡nuo   '
@ 19, 01 PROM ' K - Guias IRRF (DARF)   =>  Imprime Guia Darf para recolhimento      '
@ 20, 01 PROM ' L - Imprime Resumo do Recibo de Rescis„o Simplificado                '
@ 21, 01 PROM ' M - Imprime Resumo do Recibo de Rescis„o Simplificado - Complementar '
@ 22, 01 PROM ' N - Resumo Guia Recolhimento Rescisorio do FGTS - GRFP               '
MENU TO OPC
DO CASE
CASE OPC = 1
FORES_EX( 1 )
CASE OPC = 2
FORES_EX( 2 )
CASE OPC = 3
FORES_EX( 3 )
CASE OPC = 4
FORES_EX( 4 )
CASE OPC = 5
FORES_EX( 5 )
CASE OPC = 6
FORES_EX( 6 )
CASE OPC = 7
FORES_E6( 1 )
CASE OPC = 8
FORES_E7( 1 )
CASE OPC = 9
FORES_E6( 2 )
CASE OPC = 10
FORES_E7( 2 )
CASE OPC = 11
FORES_E8()
CASE OPC = 12
FORES_E9( 1 )
CASE OPC = 13
FORES_E9( 2 )
CASE OPC = 14
FORES_EZ( 2 )
OTHERWISE
RETU
ENDCASE
ENDDO
// : FIM: FORES_E.PRG

// + EOF: fores_e.prg
// +
