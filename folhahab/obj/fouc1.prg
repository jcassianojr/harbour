// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fouc1.prg
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
// :      FOUC1.PRG: TERMO DE RESPONSABILIDADE
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/08/94     11:20
// :
// :  Procs & Fncts: FOUC1()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************



CTR := 0
CABEX( 'IMPRIMIR TERMO DE RESPONSABILIDADE' )
MDS( 'Digite o numero do funcion rio' )
@ 24, 40 GET CTR PICT '#####'
READCUR()
IF MDG( 'Deseja detalhes em negrito' )
N := cIMPNEG
M := cIMPNER
ELSE
N := ""
m := ""
ENDIF
IF !netuse( pes )   // AREDE(PES,PES,0)
RETU
ENDIF
dbGoTop()
IF dbSeek( CTR )
SET DEVICE TO PRINT
@ PRow(), 1   SAY REPL( '-', 80 )
@ PRow() + 1, 1 SAY IMPCHR( cIMPTIT )
@ PRow(), 2   SAY 'TERMO DE RESPONSABILIDADE'
@ PRow() + 1, 2 SAY '(CONSESSAO DE SALARIO FAMILIA PORTARIA No. MPAS - 3.040/82)'
@ PRow() + 1, 1 SAY REPL( '-', 80 )
@ PRow() + 1, 1 SAY N + MSG2 + M
@ PRow(), 60   SAY N + CGC + M
@ PRow() + 1, 1 SAY 'NOME'
@ PRow(), 10   SAY N + NOME + M
@ PRow() + 1, 1 SAY 'CTPS:'
@ PRow(), 10   SAY N + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ), PROFIS ) + ' SERIE: ' + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, SubStr( TIRAOUT( CPF ), 8 ), SERIE ) + ' UF:' + CTPSUF + M
@ PRow() + 1, 1 SAY REPL( '-', 80 )
@ PRow() + 1, 1 SAY 'BENEFICIARIOS'
@ PRow() + 1, 1 SAY REPL( '-', 80 )
@ PRow() + 1, 1 SAY 'NOME'
@ PRow(), 50   SAY 'DATA DO NASCIMENTO'
FOR X := 1 TO 10
IF X > 9
Y := Str( X, 2 )
ELSE
Y := Str( X, 1 )
ENDIF
DEPDAT := "DEPDAT" + Y
DEPEND := "DEPEND" + Y
ANOX   := Year( &DEPDAT )
IF ANOX <> 0
MESX := Month( &DEPDAT )
ANOX := ANO - ANOX
MESX := MES - MESX
IF MESX < 0
ANOX := ANOX - 1
ENDIF
IF ANOX < 14
@ PRow() + 1, 1   SAY N + &DEPEND
@ PRow(), 50     SAY &DEPDAT
@ PRow(), PCol() SAY M
ENDIF
ENDIF
NEXT X
@ PRow() + 1, 1  SAY REPL( '-', 80 )
@ PRow() + 1, 1  SAY '      Pelo Presente TERMO DE RESPONSABILIDADE declaro estar ciente'
@ PRow() + 1, 1  SAY 'de que deverei comunicar de imediato a ocorrencia dos seguintes fatos'
@ PRow() + 1, 1  SAY 'ou ocorrencia que determinam a perda do direito ao salario-familia'
@ PRow() + 1, 10 SAY '-OBITO DE FILHO;'
@ PRow() + 1, 10 SAY '-CESSACAO DE INVALIDEZ DE FILHO INVALIDO;'
@ PRow() + 1, 10 SAY '-SENTENCA JUDICIAL QUE DETERMINE O PAGAMENTO A OUTREM (casos de'
@ PRow() + 1, 10 SAY ' desquite ou separacao, abandono de filho ou perda do patrio poder)'
@ PRow() + 1, 1  SAY '      Estou ciente, ainda, de que a falta de cumprimento do compromisso'
@ PRow() + 1, 1  SAY 'ora assumido, alem de obrigar a devolucao das importancia recebidas'
@ PRow() + 1, 1  SAY 'indevidamentes, sujeitar-me-a as penalidade prevista no art 171 do'
@ PRow() + 1, 1  SAY 'Codigo Penal e a rescisao do contrado de trabalho, por justa causa,'
@ PRow() + 1, 1  SAY 'nos termos do art.482 da Consolidacao das Leis do Trabalho'
@ PRow() + 1, 1  SAY REPL( '-', 80 )
@ PRow() + 1, 1  SAY CIDADE + ',' + N
@ PRow(), 20    SAY DToC( DXDIA ) + M
@ PRow() + 1, 1  SAY REPL( '-', 80 )
@ PRow() + 2, 1  SAY REPL( '_', 40 )
@ PRow() + 1, 10 SAY 'Assinatura'
@ PRow() + 2, 1  SAY REPL( '-', 80 )
IMPFOL()
SET DEVICE TO SCREEN
ELSE
MDT( 'Funcion rio n„o cadastrado' )
ENDIF
dbCloseAll()
RETU
// : FIM: FOUC1.PRG

// + EOF: fouc1.prg
// +
