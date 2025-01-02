// +--------------------------------------------------------------------
// +
// +    Programa  : folis_d7.prg Virado do Ano
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"
#include "BOX.CH"


function folis_d7()
INFOR( "FIRMA", "NRCLIEN", "FIRMA", .T. )
CABE2( 'INICIAR ANO' )

SetColor( "+GR/R" )
hb_DispBox( 8, 0, 20, 79, B_DOUBLE )
@ 11, 03 SAY "ATEN€AO !!!!!"
@ 13, 09 SAY "Antes de iniciar o ano fa‡a uma copia de reserva de todos os seus"
@ 14, 03 SAY "arquivos."
@ 15, 09 SAY "Tal resguardo se deve ao fato que  haver   manipula‡„o  de v rios"
@ 16, 03 SAY "arquivos durante o processo de inicializa‡„o."
@ 17, 09 SAY "S¢ continue ap¢s ter feito a copia de reserva."
@ 18, 03 SAY "Aconselhamos estar com apenas um usuario na rede"
SetColor( "W/N,N/W" )
IF !MDG( 'Deseja continuar' )
RETU .F.
ENDIF
CLSROW( 8 )
IF !NETUSE( "FIRMA" )
RETU .F.
ENDIF
FI     := 'INIANO#"N"'
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO

nANOANT := Year( ZDATA ) - 1
nANONOV := Year( ZDATA )
nANOREF := Year( ZDATA ) - 1
@ 22, 00 SAY 'DIGITE O ANO PARA ARQUIVAR'
@ 23, 00 SAY 'DIGITE O ANO PARA INICIAR'
@ 24, 00 SAY 'DIGITE O ANO REFERENCIA'
@ 22, 50 GET nANOANT                      PICT "9999"
@ 23, 50 GET nANONOV                      PICT "9999"
@ 24, 50 GET nANOREF                      PICT "9999"
IF !READCUR()
RETU .F.
ENDIF

ANOANT := SubStr( StrZero( nANOANT, 4 ), 3, 2 )
ANONOV := SubStr( StrZero( nANONOV, 4 ), 3, 2 )
ANOREF := SubStr( StrZero( nANOREF, 4 ), 3, 2 )




IF !MDG( "Fazer Virada do ano de " + ANOANT + " para " + ANONOV )
RETU .F.
ENDIF
IF !MDG( "Voce ja vez a copia de Reserva" )
RETU .F.
ENDIF
IF !MDG( "Voce tem Certeza" )
RETU .F.
ENDIF


INIPATH := hb_cwd()
CLSROW( 8 )
SetColor( "+GR/R" )
hb_DispBox( 8, 0, 14, 79, B_DOUBLE )
@ 10, 08 SAY "ATEN€AO !!!!!"
@ 12, 08 SAY "NŽO INTERROMPA ESTOU INICIANDO O ANO."
dbSelectAr( "FIRMA" )
dbGoTop()
WHILE !Eof()
NREMP := NRCLIEN
EMP   := StrZero( NREMP, 4 )
SetColor( "+GR/R" )
hb_DispBox( 15, 0, 19, 79, B_DOUBLE )
@ 17, 08 SAY "FIRMA  :  " + EMP + ' - ' + RAZAO
SetColor( "W/N,N/W" )
MDS( 'Preparando area de trabalho e arquivos' )
NEWPATH := INIPATH + '\EMP' + ANONOV + StrZero( NREMP, 3 )
OLDPATH := INIPATH + '\EMP' + ANOANT + StrZero( NREMP, 3 )
REFPATH := INIPATH + '\EMP' + ANOREF + StrZero( NREMP, 3 )
// Se n„o existir arquivos DBFs pula proxima empresa
MATDBF := FILENAMES( REFPATH + '\*.DBF' )
nARQ   := Len( MATDBF )
IF nARQ = 0
MDT( "Falta Arquivos desta empresa" )
dbSelectAr( "FIRMA" )
dbSkip()
LOOP
ENDIF
lTEM := File( NEWPATH + "\FO_PES.DBF" )
IF lTEM
ALERTX( "Vocˆ ja iniciou o ano para esta Empresa" )
IF !MDG( "Deseja Reescrever" )
dbSelectAr( "FIRMA" )
dbSkip()
LOOP
ENDIF
ENDIF
DIRMAKE( NEWPATH )
IF ANOREF # ANOANT
DIRMAKE( OLDPATH )
ENDIF
hb_cwd( REFPATH )
// DIRCHANGE(REFPATH)
FOR X := 1 TO nARQ
ARQO := MATDBF[ X ]
ARQD := NEWPATH + "\" + ARQO
MDS( 'Copiando ' + ARQO + ' para ' + ARQD )
FILEcopy( ARQO, ARQD )
IF ANOREF # ANOANT
ARQO := MATDBF[ X ]
ARQD := OLDPATH + "\" + ARQO
MDS( 'Copiando ' + ARQO + ' para ' + ARQD )
FILEcopy( ARQO, ARQD )
ENDIF
NEXT X
hb_cwd( NEWPATH )
// DIRCHANGE(NEWPATH)
// ******** COPIA O ARQUIVO DE DEZEMBRO PARA 00 PARA PODER INICIAR O MES
ARQFOL := 'FP' + EMP + '12.DBF'
FOA    := 'FP' + EMP + '00.DBF'
FILEcopy( ARQFOL, FOA )


MDS( 'Apagando as Folhas de Pagamento' )
// ******** APAGA OS ARQUIVOS DA FOLHA E DIRETORIA
FOR X := 1 TO 12
ARQFOL := 'FP' + EMP + StrZero( X, 2 )
IF !netzap( arqfol )
RETU .F.
ENDIF
dbCloseArea()
ARQFOL := 'SO' + EMP + StrZero( X, 2 )
IF File( ARQFOL + ".DBF" )
IF !netzap( ARQFOL )
RETURN .F.
ENDIF
ENDIF
NEXT X


// nao e necessario pois fica agora na fo_sal
FOR X := 1 TO 2
IF X = 1
ARQPES := 'FO_PES.DBF'
MDS( 'Excluindo Funcionarios demitidos,Zerando Salarios' )
ELSE
ARQPES := 'FO_DIR.DBF'
MDS( 'Excluindo diretores demitidos,Zerando Salarios' )
ENDIF
IF File( ARQPES )
IF !netuse( "fo_sal" )
dbCloseAll()
RETU .F.
ENDIF
IF !netuse( ARQPES,, .F.,,, .F., )
dbCloseAll()
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
IF !Empty( DEMITIDO )
NETRECDEL()
ELSE
netreclock()
               /* nao e mais necessario pois fica na fol_sal
               REPL SALJAN WITH SALDEZ,SALFEV WITH 0.00,SALMAR WITH 0.00
               REPL SALABR WITH 0.00,SALMAI WITH 0.00,SALJUN WITH 0.00
               REPL SALJUL WITH 0.00,SALAGO WITH 0.00,SALSET WITH 0.00
               REPL SALOUT WITH 0.00,SALNOV WITH 0.00,SALDEZ WITH 0.00
               REPL MOT1 WITH " ",MOT2 WITH " ",MOT3 WITH " ",MOT4 WITH " "
               REPL MOT5 WITH " ",MOT6 WITH " ",MOT7 WITH " ",MOT8 WITH " "
               REPL MOT9 WITH " ",MOT10 WITH " ",MOT11 WITH " ",MOT12 WITH " "
               */
REPL DATCONTSIN WITH CToD( "00/00/00" )
dbUnlock()
ENDIF
xNUMERO := NUMERO
nSALANT := 0
dbSelectAr( "fo_sal" )
IF dbSeek( Str( xnumero, 8 ) + Str( nANOANT, 4 ) )
nSALANT := SALDEZ
ENDIF
IF dbSeek( Str( xnumero, 8 ) + Str( nANONOV, 4 ) )
netreclock()
ELSE
netrecapp()
field->numero := xNUMERO
field->ano    := nANONOV
ENDIF
FIELD->SALJAN := nSALANT
dbUnlock()
dbSelectAr( arqpes )
dbSkip()
ENDDO
PACK
dbSelectAr( arqpes )
dbCloseArea()
dbSelectAr( "fo_sal" )
dbCloseArea()
ENDIF
NEXT X


// Apagando Indices
MATNTX := FILENAMES( '*.' + cRDDEXT )
nARQ   := Len( MATNTX )
IF nARQ > 0
FOR X := 1 TO nARQ
FErase( MATNTX[ X ] )
NEXT X
ENDIF

dbSelectAr( "FIRMA" )
dbSkip()
ENDDO
hb_cwd( INIPATH )
// DIRCHANGE(INIPATH)
dbCloseAll()
NOBREAK()
@ 24, 00 SAY "  Ok.- O novo ano ja  esta  inicializado.  "
Inkey( 0 )
RETU .T.



// + EOF: folis_d7.prg
// +
