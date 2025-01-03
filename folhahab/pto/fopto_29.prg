// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_29.prg Apagando Arquivos de Movimentacao
// +
// +
// +
// +     Sistema:FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

function fopto_29()
CABE2( 'FOPTO_29 - Apagando Arquivos de Movimenta‡„o' )
nMES := Month( Date() )
nANO := Year( Date() )
MDS( 'Confirme a Competˆncia' )
@ 24, 40 GET nMES
@ 24, 50 GET nANO
IF !READCUR()
RETU .F.
ENDIF
IF !MDG( "Vocˆ tem certeza" )
RETU .F.
ENDIF
IF !MDG( "Vocˆ realmente tem certeza" )
RETU .F.
ENDIF
cMESANO := SubStr( StrZero( nANO, 4 ), 3, 2 ) + StrZero( nMES, 2 )
FO29APG( "PN", "Movimento Mes" )
FO29APG( "PT", "Totais do Mes" )
FO29APG( "PD", "Arquivo de Migracao Importa‡ao Relogio" )
FO29APG( "PA", "Arquivo de Migracao Importa‡ao Refeitorio" )
FO29APG( "PP", "Arquivo de Migracao Importa‡ao Portaria" )
FO29APG( "PE", "Escala de Revezamento" )
FO29APG( "PO", "Ocorrencias Avulsas" )
FO29APG( "PM", "Horarios Avulsos" )
FO29APG( "PH", "Corre‡ao Horarios" )
FO29APG( "PX", "Creditos Avulsos" )
FO29APG( "BK", "Requisicao Bco Horas Principal" )
FO29APG( "BH", "Requisi‡ao Bco Horas Secundario" )
return


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO29APG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FO29APG( cARQ, cDIZ )

   cARQ := cARQ + cMESANO
   cDIZ := "Apagar " + Cdiz
   IF MDG( cDIZ )
      DELETEFILE( ZDIRE + cARQ + ".DBF" )
      DELETEFILE( ZDIRE + cARQ + "." + cRDDEXT )
   ENDIF

   RETURN .T.

// + EOF: fopto_29.prg
// +
