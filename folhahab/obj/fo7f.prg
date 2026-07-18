// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo7f.prg
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
// :       FO7F.PRG: Exibir Via Video
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/07/94     15:21
// :
// :    Chamado por: FO77               (processo  em FO7.PRG)
// :
// :          Chama: SALHM()            (fun‡„o    em FOLPROC.PRG)
// :
// :
// :     Documentado 05/13/94 em 14:53                DISK!  vers„o 5.01
// :*****************************************************************************



QTFUN := SALTOT := 0
CTLIN := 9

IF !NETUSE( pes )
dbCloseAll()
RETU
ENDIF
FILTRO := ''
INX    := ""
FILORD( .T. )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF ValType( INX ) = "N"
dbSetOrder( INX )
ELSE
ordDestroy( "temp" )
ordCreate(, "temp", inx )
ordSetFocus( "temp" )
ENDIF
SET FILTER TO &FILTRO

dbGoTop()
@ 04, 00 SAY "+------------------------------------------------------------------------------+"
@ 05, 00 SAY "Ý Cadastro de Funcion rios." + SPAC( 52 ) + "Ý"
@ 06, 00 SAY "Ý------------------------------------------------------------------------------Ý"
@ 07, 00 SAY "Ý Reg.  Ý Nome." + SPAC( 26 ) + "Ý Admiss„o  Ý  Sal rio ao mˆs:        Ý"
@ 08, 00 SAY "Ý-------+--------------------------------+-----------+-------------------------Ý"
FOR X := 9 TO 21
@ X, 00 SAY "Ý       Ý" + SPAC( 32 ) + "Ý           Ý                         Ý"
NEXT X
@ 22, 00 SAY "Ý----------------------------------------+-------------------------------------Ý"
@ 23, 00 SAY "Ý        --" + Chr( 16 ) + " Cadastros Ý                 Ý Total --" + Chr( 16 ) + "" + SPAC( 27 ) + "Ý"
@ 24, 00 SAY "+------------------------------------------------------------------------------+"
WHILE !Eof()
IF CTLIN > 21
@ 23, 03 SAY QTFUN  PICT '####'
@ 23, 56 SAY SALTOT PICTURE '###,###,###.##'
Inkey( 0 )
IF LastKey() = 27
dbCloseAll()
RETU
ENDIF
@  9, 0 CLEAR TO 21, 79
CTLIN := 9
FOR X := 9 TO 21
@ X, 00 SAY "Ý       Ý" + SPAC( 32 ) + "Ý           Ý                         Ý"
NEXT
ENDIF
@ CTLIN, 2  SAY NUMERO
@ CTLIN, 10 SAY NOME
@ CTLIN, 43 SAY ADMITIDO
SALM := SALH := VAR1 := 0
SALHM()
@ CTLIN, 56 SAY SALM PICT '###,###,###,###.##'
SALTOT := SALTOT + SALM
QTFUN++
CTLIN++
dbSkip()
ENDDO
@ 23, 03 SAY QTFUN  PICT '####'
@ 23, 56 SAY SALTOT PICT '###,###,###,###.##'
Inkey( 0 )
dbCloseAll()
RETU
// : FIM: FO7F.PRG

// + EOF: fo7f.prg
// +
