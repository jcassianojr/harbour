// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fock.prg
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

// //#INCLUDE "COMANDO.CH"
IF !MDL( "Imprimir RPA", 0 )
RETU .F.
ENDIF


PARA CC
PRIV mSEMANA


IF !ARQUSAR( CC, 1 )
dbCloseAll()
RETU .F.
ENDIF
cSELE1 := Alias()

IF !ARQPES( CC, 1, 0 )
dbCloseAll()
RETU .F.
ENDIF
mTEMP  := tmpfile( cRDDEXT )
INX    := ""
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
FILORD()
SET FILTER TO &FILTRO
cSELE2 := Alias()



IMPRESSORA()
dbSelectAr( cSELE2 )
dbGoTop()
WHILE !Eof()
CTLIN    := 0
LIQUIDO  := PEGVSEM( 1, NUMERO, 440, 1 )
BASE     := PEGVSEM( 1, NUMERO, 401, 1 )
BRUTO    := PEGVSEM( 1, NUMERO, 399, 1 )
DESCONTO := PEGVSEM( 1, NUMERO, 999, 1 )
VALIRRF  := PEGVSEM( 1, NUMERO, 503, 1 )
DESPESAS := DESCONTO - VALIRRF
IF DESPESAS < 0
DESPESAS := 0
ENDIF
dbSelectAr( cSELE2 )
IF LIQUIDO > 0
FOR I := 1 TO 2
@ CTLIN, 0  SAY IMPSTR( cIMPCOM )
@ CTLIN, 1  SAY IMPCHR( cIMPTIT ) + 'RECIBO DE PAGAMENTO A AUTONOMO - RPA ' + IMPSTR( cIMPEXP )
@ CTLIN, 59 SAY '|'
@ CTLIN, 60 SAY 'Nro. Frota- '
@ CTLIN, 73 SAY NUMERO
@ CTLIN, 73 SAY NUMERO
@ CTLIN, 73 SAY NUMERO
@ CTLIN, 73 SAY NUMERO
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 01 SAY REPL( '=', 78 )
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY ACENTO( 'Nome ou Raz„o Social da Empresa' )
@ CTLIN, 59 SAY '|'
@ CTLIN, 60 SAY 'Matricula (CGCMF)'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 01 SAY REPL( '-', 78 )
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY MSG2
@ CTLIN, 02 SAY MSG2
@ CTLIN, 59 SAY '|'
@ CTLIN, 60 SAY CGC1
@ CTLIN, 60 SAY CGC1
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY AllTrim( ENDER1 ) + " " + AllTrim( CID1 )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 01 SAY REPL( '-', 78 )
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 12 SAY 'Recebi da Empresa acima identificada, pela prestacao dos servicos'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY 'de '
@ CTLIN, 05 SAY TIPSER
@ CTLIN, 05 SAY TIPSER
@ CTLIN, 05 SAY TIPSER
@ CTLIN, 30 SAY ', a importancia de R$ '
@ CTLIN, 53 SAY LIQUIDO                  PICT '@E 999,999,999,999.99'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY EXT( LIQUIDO, 1, 78, 78, 0 )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY EXT( LIQUIDO, 2, 78, 78, 0 )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY REPL( '-', 78 )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY 'Discriminativo Abaixo:'
IF VALIRRF <> 0.00
@ CTLIN, 40 SAY 'Base Irrf = ' + TRAN( BASE, '@E 999,999,999,999.99' )
ENDIF
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY REPL( '-', 78 )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY 'Carreteiro (Calculo do Valor do Reem'
@ CTLIN, 39 SAY '|'
@ CTLIN, 40 SAY 'Especificacao'
@ CTLIN, 40 SAY 'Especificacao'
@ CTLIN, 40 SAY 'Especificacao'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY 'bolso)'
@ CTLIN, 39 SAY '|'
@ CTLIN, 40 SAY '  Valor do Servico Prestado'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY 'Aplicar % sobre o valor da mao de '
@ CTLIN, 39 SAY '|'
@ CTLIN, 42 SAY 'Frete Bruto :'
@ CTLIN, 57 SAY 'R$ ' + TRAN( BRUTO, '@E 999,999,999,999.99' )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
// @ CTLIN,02 SAY 'obra (11,71 % do Frete)'
// @ CTLIN,39 SAY '|'
// @ CTLIN,50 SAY '40 % :'
// @ CTLIN,57 SAY 'R$ '+ TRAN(BRUTO*.4,'@E 999,999,999,999.99')
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 39 SAY '|'
@ CTLIN, 42 SAY 'IRRF :'
@ CTLIN, 57 SAY 'R$ ' + TRAN( VALIRRF, '@E 999,999,999,999.99' )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY REPL( '=', 37 )
@ CTLIN, 39 SAY '|'
@ CTLIN, 42 SAY 'DESPESAS  '
@ CTLIN, 57 SAY 'R$ ' + TRAN( DESPESAS, '@E 999,999,999,999.99' )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 06 SAY 'NUMERO  DE  INSCRICAO'
@ CTLIN, 39 SAY '|'
@ CTLIN, 61 SAY '------------------'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY 'IAPAS : ' // +mIAPAS
@ CTLIN, 39 SAY '| TOTAL DESCONTOS'
@ CTLIN, 57 SAY 'R$ ' + TRAN( DESCONTO, '@E 999,999,999,999.99' )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY 'NO CPF/CGC: ' + CGC
@ CTLIN, 39 SAY '|'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY REPL( '=', 37 )
@ CTLIN, 39 SAY '|'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 05 SAY 'INSC.ESTADUAL/RG'
@ CTLIN, 39 SAY '|'
@ CTLIN, 42 SAY 'Valor Liquido:'
@ CTLIN, 57 SAY 'R$ ' + TRAN( LIQUIDO, '@E 999,999,999,999.99' )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY REPL( '-', 37 )
@ CTLIN, 39 SAY '|'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY 'NUMERO'
@ CTLIN, 39 SAY '|'
@ CTLIN, 40 SAY '----------------ASSINATURA------------'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY INSCR
@ CTLIN, 39 SAY '|'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY REPL( '=', 37 )
@ CTLIN, 39 SAY '|'
@ CTLIN, 40 SAY REPL( '_', 38 )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 02 SAY 'LOCALIDADE'
@ CTLIN, 20 SAY 'DATA: ' + DToC( DXDIA )
@ CTLIN, 39 SAY '|'
@ CTLIN, 40 SAY '------------NOME    COMPLETO----------'
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 00 SAY '|'
@ CTLIN, 01 SAY REPL( '_', 20 )
// @ CTLIN,24 SAY '____/____/____'
@ CTLIN, 39 SAY '|'
@ CTLIN, 40 SAY SubStr( NOME, 1, 38 )
@ CTLIN, 40 SAY SubStr( NOME, 1, 38 )
@ CTLIN, 40 SAY SubStr( NOME, 1, 38 )
@ CTLIN, 79 SAY '|'
CTLIN++
@ CTLIN, 1 SAY REPL( '=', 78 )
CTLIN++
NEXT
ENDIF
dbSelectAr( cSELE2 )
dbSkip()
ENDDO
dbCloseAll()
VIDEO()
IMPEND()
FErase( mTEMP )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGVSEM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PEGVSEM( nAREA, nFROTA, nCONTA, nTIPO )

   LOCAL aRETU  := { .F., 0, 0 }
   LOCAL DBFUSO := Alias()

   SELE &nAREA
   dbGoTop()
   IF dbSeek( nFROTA * 10000 + mSEMANA * 1000 + nCONTA )
      aRETU[ 1 ] := .T.
      aRETU[ 2 ] := VALOR
      aRETU[ 3 ] := HORAS
   ENDIF
   IF !Empty( DBFUSO )
      dbSelectAr( DBFUSO )
   ENDIF
   DO CASE
   CASE nTIPO = 1
      RETU aRETU[ 2 ]
   CASE nTIPO = 2
      RETU aRETU[ 3 ]
   ENDCASE

   RETURN aRETU

// + EOF: fock.prg
// +
