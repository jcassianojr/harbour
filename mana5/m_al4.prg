// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_al4.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :   M_AL4.PRG   : FLUXO FINANCEIRO VIA VIDEO
//
// :   Linguagem   : harbour
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :*****************************************************************************

MDI( " þ Fluxo Financeiro " )
mQUEBRA := mdg( "Deseja quebra por dia?" )
FATOR   := ZTOTCRE := ZTOTDEB := 0.00
TELA    := SaveScreen( 8, 0, 24, 79 )
FLUXO()
zSALDO := FATOR
dbSelectAr( 'MZ01' )
PRIV ZDATA := CToD( Space( 8 ) )
ZNRCONTA := 0
dbGoTop()
CTLIN := 4
SetColor( 'N/W' )
@  2, 0 CLEAR
@  2, 1  SAY 'Dup/NF   Venc Cli/For       Historico               Valor    Tipo     Saldo   '
@  3, 01 SAY REPL( 'Ä', 78 )
@  3, 00 SAY 'Ú'
@  3, 07 SAY 'Â' // 209
@  3, 16 SAY 'Â'
@  3, 20 SAY 'Â'
@  3, 48 SAY 'Â'
@  3, 62 SAY 'Â'
@  3, 64 SAY 'Â'
@  3, 79 SAY '¿'
mDIA   := VENCIMENT
mTOTDP := mTOTDR := 0.00
LIN22  := .F.
WHILE !Eof() .AND. LastKey() # 27
SetColor( 'N/W' )
IF CTLIN >= 22
IF CTLIN = 22 .AND. LIN22
SetColor( 'N/W' )
@ CTLIN, 01 SAY REPL( 'Ä', 78 )
@ CTLIN, 00 SAY 'À'
@ CTLIN, 07 SAY 'Á'
@ CTLIN, 16 SAY 'Á'
@ CTLIN, 20 SAY 'Á'
@ CTLIN, 48 SAY 'Á'
@ CTLIN, 62 SAY 'Á'
@ CTLIN, 64 SAY 'Á'
@ CTLIN, 79 SAY 'Ù'
ENDIF
@ 24, 0
@ 24, 1 SAY 'Pressione qualquer tecla... '
Inkey( 0 )
IF LastKey() = 27
dbCloseAll()
RETU
ENDIF
CTLIN := 4
@  3, 0 CLEAR
@  3, 1  SAY REPL( 'Ä', 78 )
@  3, 00 SAY 'Ú'
@  3, 07 SAY 'Â'
@  3, 16 SAY 'Â'
@  3, 20 SAY 'Â'
@  3, 48 SAY 'Â'
@  3, 62 SAY 'Â'
@  3, 64 SAY 'Â'
@  3, 79 SAY '¿'
ENDIF
@ CTLIN, 00 SAY '³' // 179
@ CTLIN, 07 SAY '³' // 179
@ CTLIN, 16 SAY '³'
@ CTLIN, 20 SAY '³'
@ CTLIN, 48 SAY '³'
@ CTLIN, 62 SAY '³'
@ CTLIN, 64 SAY '³'
@ CTLIN, 79 SAY '³'
LIN22 := .F.
IF CTLIN = 21
LIN22 := .T.
ENDIF
IF DEBCRE = 'C'
ZTOTCRE += VALORS
mTOTDR  += VALORS
ELSEIF DEBCRE = 'D'
SetColor( 'R/W' )
ZTOTDEB += VALORS
mTOTDP  += VALORS
ENDIF
zSALDO += VALORS
@ CTLIN, 01 SAY NRNOTA                                               PICT '999999'
@ CTLIN, 08 SAY VENCIMENT
@ CTLIN, 17 SAY CLIENTE                                              PICT '999'
@ CTLIN, 21 SAY Left( Trim( COGNOME ) + ' ' + Trim( OBS1 ) + ' ' + Trim( OBS2 ), 27 )
@ CTLIN, 49 SAY VALORS                                               PICT '@E 9999999999.99'
@ CTLIN, 63 SAY IF( DEBCRE = 'D', 'D', IF( DEBCRE = 'C', 'C', 'E' ) )
IF zSALDO < 0
SetColor( 'R/W' )
ELSE
SetColor( 'B/W' )
ENDIF
@ CTLIN, 65 SAY zSALDO PICT '@E 99999999999.99'
SetColor( 'R/W' )
@ 23, 01 SAY 'D‚bitos: ' + TRAN( zTOTDEB, '@E 999,999,999.99' )
SetColor( 'B/W' )
@ 23, 31 SAY 'Cr‚ditos: ' + TRAN( zTOTCRE, '@E 999,999,999.99' )
IF zSALDO < 0
SetColor( 'R/W' )
ENDIF
@ 23, 58 SAY 'Saldo: ' + TRAN( zSALDO, '@E 999,999,999.99' )
CTLIN++
dbSkip()
SetColor( 'N/W' )
IF mQUEBRA
IF mDIA # VENCIMENT
@ CTLIN, 01 SAY REPL( 'Ä', 78 )
@ CTLIN, 00 SAY 'À'
@ CTLIN, 07 SAY 'Á'
@ CTLIN, 16 SAY 'Á'
@ CTLIN, 20 SAY 'Á'
@ CTLIN, 48 SAY 'Á'
@ CTLIN, 62 SAY 'Á'
@ CTLIN, 64 SAY 'Á'
@ CTLIN, 79 SAY 'Ù'
CTLIN++
IF CTLIN > 21
@ 24, 0
@ 24, 1 SAY 'Pressione qualquer tecla... '
Inkey( 0 )
IF LastKey() = 27
dbCloseAll()
RETU
ENDIF
IF !Eof()
CTLIN := 3
@  3, 0 CLEAR
ENDIF
ENDIF
@ CTLIN, 0
@ CTLIN - 1, 0 SAY IF( CTLIN # 3, 'Ã', '' )
@ CTLIN, 0     SAY 'ÀÄ' + Chr( 16 ) + ' Dia: ' + Left( DToC( mDIA ), 5 )
SetColor( 'R/W' )
IF mTOTDP # 0.00
@ CTLIN, Col() + 1 SAY 'D‚b ' + LTrim( TRAN( mTOTDP, '@E 999,999,999.99' ) )
ENDIF
SetColor( 'B/W' )
IF mTOTDR # 0.00
@ CTLIN, Col() + 1 SAY 'Cr‚ ' + LTrim( TRAN( mTOTDR, '@E 999,999,999.99' ) )
ENDIF
mSAL := IF( mTOTDR # 0.00 .AND. mTOTDP # 0.00, .T., .F. )
IF M->mSAL
IF mTOTDR + mTOTDP < 0
SetColor( 'R/W' )
ENDIF
@ CTLIN, Col() + 1 SAY 'Sdo ' + LTrim( TRAN( mTOTDR + mTOTDP, '@E 999,999,999.99' ) )
ENDIF
SetColor( 'N/W' )
IF !Eof()
CTLIN++
IF CTLIN < 21
@ CTLIN, 01 SAY REPL( 'Ä', 78 )
@ CTLIN, 00 SAY 'Ú'
@ CTLIN, 07 SAY 'Â'
@ CTLIN, 16 SAY 'Â'
@ CTLIN, 20 SAY 'Â'
@ CTLIN, 48 SAY 'Â'
@ CTLIN, 62 SAY 'Â'
@ CTLIN, 64 SAY 'Â'
@ CTLIN, 79 SAY '¿'
ENDIF
ENDIF
CTLIN++
mTOTDP := mTOTDR := 0.00
mDIA   := VENCIMENT
ENDIF
ENDIF
ENDDO
dbCloseArea()
@ 24, 1 SAY 'Pressione qualquer tecla... '
Inkey( 0 )
RestScreen( TELA, 8, 0, 24, 79 )
RETU

// : FIM: M_AL4.PRG

// + EOF: m_al4.prg
// +
