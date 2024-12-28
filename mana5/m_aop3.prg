// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aop3.prg
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


MDI( "Importar Saldo de Pedidos" )
PARA cARQ, cARQ2, lCALC
IF ValType( cARQ ) # "C"
cARQ  := "OP01"
cARQ2 := "OP02"
ENDIF
IF ValType( lCALC ) # "L"
lCALC := .T.
ENDIF
d01    := d02 := d03 := ZDATA
dG01   := dG02 := dG03 := ZDATA
dMEN   := ZDATA
nMES   := 22
nSEM   := 4
cESTRA := "T"
cTIPO  := "P"
cZERA  := "N"

WHILE DoW( dg01 ) # 2
dg01--
ENDDO
dg02 := dg01 + 7
dg03 := dg01 + 14
d01  := dG01 + 6
d02  := dG02 + 6
d03  := dG03 + 6

@ 10, 00 SAY "Digite as Data Apura‡„o"
@ 10, 24 GET d01
@ 10, 34 GET d02
@ 10, 44 GET d03

@ 12, 00 SAY "Digite as Data Grava‡„o"
@ 12, 24 GET dG01
@ 12, 34 GET dG02
@ 12, 44 GET dG03

@ 14, 00 SAY "Mensal"
@ 14, 20 GET dMEN
@ 14, 30 GET nMES     PICT "9999"
@ 14, 40 GET nSEM     PICT "9999"

@ 16, 00 SAY "Gravar T-Tres Semanas 1-Primeira 2-Segunda 3-Terceira"
@ 16, 55 GET cESTRA                                                  PICT "!"

@ 18, 00 SAY "(P)edidos Prg(S)emanal Prg(D)iaria"
@ 19, 00 SAY "Electrolux->D(E)lfor (O)rders (I)ntegrada"
@ 18, 40 GET cTIPO                                       PICT "!"

@ 20, 00 SAY "Zerar Saldos (S/N)"
@ 20, 20 GET cZERA                PICT "!" VALID cZERA $ "SN"
IF !READCUR()
RETU .F.
ENDIF

IF cZERA = "S"
IF !MDG( "Importar Zerando Saldos" )
RETU
ENDIF
ENDIF


// Caqop  Codigo Produto
cARQOP  := "MO02"
eCODIGO := "CODIGO"
DO CASE
CASE cTIPO = "P"
IF !usemult( { { cARQOP, 1, 3 }, { cARQ, 1, 99 }, { cARQ2, 1, 99 } } )
RETU .F.
ENDIF
CASE cTIPO = "S"
eCODIGO := "PRODUTO"
cARQOP  := "OSPRG"
IF !usemult( { { cARQOP, 1, 2 }, { cARQ, 1, 99 }, { cARQ2, 1, 99 } } )
RETU .F.
ENDIF
CASE cTIPO = "D"
cARQOP  := "OSPR2"
eCODIGO := "PRODUTO"
IF !usemult( { { cARQOP, 1, 2 }, { cARQ, 1, 99 }, { cARQ2, 1, 99 } } )
RETU .F.
ENDIF
CASE cTIPO = "E"
cARQOP  := "OSPRE"
eCODIGO := "PRODUTO"
IF !usemult( { { cARQOP, 1, 2 }, { cARQ, 1, 99 }, { cARQ2, 1, 99 } } )
RETU .F.
ENDIF
CASE cTIPO = "O"
cARQOP  := "OSPR3"
eCODIGO := "PRODUTO"
IF !usemult( { { cARQOP, 1, 2 }, { cARQ, 1, 99 }, { cARQ2, 1, 99 } } )
RETU .F.
ENDIF
CASE cTIPO = "I"
cARQOP  := "OSPRS"
eCODIGO := "PRODUTO"
IF !usemult( { { cARQOP, 1, 2 }, { cARQ, 1, 99 }, { cARQ2, 1, 99 } } )
RETU .F.
ENDIF
ENDCASE

FILTRO := ''
FILTRO := RFILORD( cARQOP, .F. )


IF cZERA = "S"
dbSelectAr( cARQ )
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY RecNo()
GRAVACAMPO( { "QATR", "QSEM", "QSE2", "ATIVO" }, { "0", "0", "0", "'N'" } )
dbSelectAr( cARQ )
dbSkip()
ENDDO
dbSelectAr( cARQ2 )
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY RecNo()
GRAVACAMPO( { "QPSAI" }, { "0" } )
dbSelectAr( cARQ2 )
dbSkip()
ENDDO
ENDIF
dbSelectAr( cARQ )
INITVARS()
CLRVARS()
dbSelectAr( cARQOP )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
WHILE !Eof()
mCODIGO := &eCODIGO.
@ 24, 00 SAY mCODIGO
mQATR := 0
mQSEM := 0
mQSE2 := 0
mQMEN := 0
WHILE mCODIGO = &eCODIGO. .AND. !Eof()
cUNID := "PC"
IF cTIPO = "P"
cUNID := UNID
ENDIF
nQTDESAL := 0
dENTREGA := ZDATA
IF cTIPO = "P"
nQTDESAL := QTDESAL
dENTREGA := ENTREGA
ELSE
nQTDESAL := QTDE
dENTREGA := PROGRAMA
ENDIF
IF nQTDESAL > 0.001
IF cTIPO = "P" .AND. PEDMEN = "S"
IF dENTREGA <= dMEN
mQMEN += CONVUN( nQTDESAL, cUNID )
ENDIF
ELSE
IF dENTREGA <= d01
mQATR += CONVUN( nQTDESAL, cUNID )
ENDIF
IF dENTREGA > d01 .AND. dENTREGA <= d02
mQSEM += CONVUN( nQTDESAL, cUNID )
ENDIF
IF dENTREGA > d02 .AND. dENTREGA <= d03
mQSE2 += CONVUN( nQTDESAL, cUNID )
ENDIF
ENDIF
ENDIF
dbSelectAr( cARQOP )
dbSkip()
ENDDO
IF mQMEN > 0
mQMEN := Int( mQMEN / nMES * nSEM )
mQATR += mQMEN
mQSEM += mQMEN
mQSE2 += mQMEN
ENDIF
IF mQATR + mQSEM + mQSE2 > 0
dbSelectAr( cARQ )
dbSetOrder( 2 )
dbGoTop()
IF !dbSeek( AllTrim( mcodigo ) )
dbSetOrder( 1 )
dbGoBottom()
mOP := OP
mOP++
netrecapp()
FIELD->OP     := mOP
FIELD->CODIGO := mCODIGO
ELSE
netreclock()
ENDIF
FIELD->ATIVO := "S"
IF cESTRA = "1" .OR. cESTRA = "T"
FIELD->DATAA := dG01
FIELD->QATR  := mQATR
ENDIF
IF cESTRA = "2" .OR. cESTRA = "T"
FIELD->DATAS := dG02
FIELD->QSEM  := mQSEM
ENDIF
IF cESTRA = "3" .OR. cESTRA = "T"
FIELD->DATA2 := dG03
FIELD->QSE2  := mQSE2
ENDIF
dbUnlock()
ENDIF
dbSelectAr( cARQOP )
ENDDO
dbCloseAll()
MA2CHKPRG( .T. )
IF lCALC
// Consolida Resultado
MAOP03( .F., cARQ, cARQ2 )
ENDIF

// + EOF: m_aop3.prg
// +
