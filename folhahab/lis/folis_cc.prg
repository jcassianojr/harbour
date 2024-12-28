// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_cc.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FOLIS_CC.PRG: Listar Rais Checagem Funcionarios
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"
IF !MDL( 'Listar RAIS Checagem Empregados', 0 )
RETU .F.
ENDIF
CTLIN := 80


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

IF !NETUSE( "FORAIS" )
dbCloseAll()
RETU .F.
ENDIF

IMPRESSORA()
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
mNUMERO   := NUMERO
mNOME     := NOME
mDEMITIDO := DEMITIDO
FOLISCC01( PIS, "PIS" )
FOLISCC01( IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ), PROFIS ), "Numero Profissional" )   // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
FOLISCC01( IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, SubStr( TIRAOUT( CPF ), 8 ), SERIE ), "Serie Profissional" )
FOLISCC01( NASC, "Data Nascimento" )
FOLISCC01( ADMITIDO, "Data Admissao" )
// FOLISCC01(CBONEW,"Numero CBO Novo")
FOLISCC01( ESCRAIS, "Escolaridade" )
FOLISCC01( NASCPAIS, "Nacionalidade" )
IF NASCPAIS <> "1058"
FOLISCC01( ANONASCI, "Ano Chegada" )
ENDIF
FOLISCC01( RACS, "Codigo Etnia-Esocial" )
IF !Empty( mDEMITIDO )
cVAR := "RAIZ" + Left( CMES( mDEMITIDO ), 3 )
dbSelectAr( "FORAIS" )
dbGoTop()
IF dbSeek( Str( nanouso ) + Str( mNUMERO, 8 ) )
IF !foliscc01( &Cvar., "Saldo Salario Rescisao" )
@ CTLIN, 70 SAY mDEMITIDO
ENDIF
IF !foliscc01( RAIZFER, "Ferias Indenizadas" )
@ CTLIN, 70 SAY mDEMITIDO
ENDIF
IF !foliscc01( RAIZMUL, "Multa FGTS" )
@ CTLIN, 70 SAY mDEMITIDO
ENDIF
IF !foliscc01( RAIZAVI, "Aviso Previo" )
@ CTLIN, 70 SAY mDEMITIDO
ENDIF
ENDIF
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()
IMPFOL()
VIDEO()
IMPEND()
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOLISCC01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOLISCC01( cVAR, cMES )

   IF CTLIN > 55
      @  0, 1 SAY "RAIS - E M P R E G A D O S  - CHECAGEM" + Replicate( "-", 47 )
      CTLIN := 2
   ENDIF
   IF Empty( cVAR )
      CTLIN++
      @ CTLIN, 0  SAY mNUMERO
      @ CTLIN, 9  SAY mNOME
      @ CTLIN, 40 SAY cMES
      RETU .F.
   ENDIF
   RETU .T.


// + EOF: folis_cc.prg
// +
