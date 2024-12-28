// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_dw.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


MDI( " Recriar configuracao Tabelas CEPS" )
MDS( "Apagando configuracao Tabelas" )
IF !USEREDE( "MD01", 0, 99 )
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY RecNo()
IF Left( NOME, 4 ) = "CEP:"
netrecdel()
ENDIF
dbSkip()
ENDDO
PACK
dbCloseArea()
IF !USEREDE( "MD10", 1, 99 )
RETU .F.
ENDIF
IF !useCHK( ZDIRC + "MANARQ", ZDIRC + "MANARQ", .T. )
dbCloseAll()
RETU .F.
ENDIF
IF !useCHK( ZDIRC + "MANARQ1", ZDIRC + "MANARQ1", .T. )
dbCloseAll()
RETU .F.
ENDIF
MDS( "Apagando Configuracao Indexacao" )
dbSelectAr( "MANARQ" )
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY RecNo()
IF Left( DESCRICAO, 4 ) = "CEP:"
cARQUIVO := ARQUIVO
netrecdel()
dbSelectAr( "MANARQ1" )
dbGoTop()
dbSeek( cARQUIVO )
WHILE ARQUIVO = cARQUIVO .AND. !Eof()
netrecdel()
dbSkip()
ENDDO
ENDIF
dbSelectAr( "MANARQ" )
dbSkip()
ENDDO

mds( "recriando" )
dbSelectAr( "MD10" )
dbGoTop()
WHILE !Eof()
IF Val( cCODIBGE ) > 0   // CEP Localidade =ibge
mARQUIVO := "C" + cCODIBGE
mDESCR   := AllTrim( "CEP:" + UF + ":" + NOME )
dbSelectAr( "MANARQ" )
netrecapp()
FIELD->ARQUIVO   := mARQUIVO
FIELD->DESCRICAO := mDESCR
FIELD->FIXAR     := "S"
FIELD->LACHI     := 999999  // 4096 harbour sem limite array
FIELD->PADRAO    := "A"   // Ceps
FIELD->VIDEO     := "T"
FIELD->PBUS      := "S"
FIELD->PIND      := "N"
FIELD->TIPG      := "1"
FIELD->IBUS      := 1
FIELD->IEXI      := 1
FIELD->CAMINHO   := "CEPS\"
FIELD->DRIVER    := "DBFCDX"
dbSelectAr( "MANARQ1" )
netrecapp()
FIELD->ARQUIVO := mARQUIVO
FIELD->ITEM    := 1
FIELD->INDICE  := mARQUIVO + "1"
FIELD->INDEXP  := "RUA"
FIELD->DESC    := mDESCR + ":Rua"
FIELD->VAR1    := "mRUA"
FIELD->DES1    := "Digite o Nome da Rua"
netrecapp()
FIELD->ARQUIVO := mARQUIVO
FIELD->ITEM    := 2
FIELD->INDICE  := mARQUIVO + "2"
FIELD->INDEXP  := "CEP"
FIELD->DESC    := mDESCR + ":CEP"
FIELD->VAR1    := "mCEP"
FIELD->DES1    := "Digite o Numero do CEP"
ENDIF
dbSelectAr( "MD10" )
dbSkip()
ENDDO

dbCloseAll()








// + EOF: m_dw.prg
// +
