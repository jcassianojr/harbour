// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo1k.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FO1K.PRG: Criar Folha de Diretores
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:08
// :
// :  Procs & Fncts: FO1K()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :
// : Outros Arquivos: DBF
// :               : &CRIAR
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************


CABEX( "Criar Folha de Diretores" )
IF !MDG( 'Vocˆ tem certeza' )
ENDIF
IF !MDG( 'Vocˆ realmente tem certeza' )
RETU
ENDIF
IF File( ZDIRE + "FO_DIR.DBF" )
MDT( 'Folha de Diretores j  criada' )
RETU
ENDIF
DES := { "FO_DIR", "FO_RDD", "SO" + EMP + "01", "SO" + EMP + "02", "SO" + EMP + "03", ;
      "SO" + EMP + "04", "SO" + EMP + "05", "SO" + EMP + "06", "SO" + EMP + "07", "SO" + EMP + "08", ;
      "SO" + EMP + "09", "SO" + EMP + "10", "SO" + EMP + "11", "SO" + EMP + "12", "SO" + EMP + "00", ;
      "FO_SO13A", "FO_SO13B", "FO_SO13C", "AJUDIRF", "FO_IRR" }
ORI := { "FO_PES", "FO_RES", "FP" + EMP + "01", "FP" + EMP + "02", "FP" + EMP + "03", ;
      "FP" + EMP + "04", "FP" + EMP + "05", "FP" + EMP + "06", "FP" + EMP + "07", "FP" + EMP + "08", ;
      "FP" + EMP + "09", "FP" + EMP + "10", "FP" + EMP + "11", "FP" + EMP + "12", "FP" + EMP + "00", ;
      "FO_FP13A", "FO_FP13B", "FO_FP13C", "AJUDIRD", "FO_IRD" }

FOR X := 1 TO Len( DES )
CRIAR := ZDIRE + DES[ X ] + ".DBF"
ORIGE := ZDIRE + ORI[ X ] + ".DBF"
IF File( ORIGE )
MDS( 'Copiando ' + Orige + ' Para ' + Criar )
FILECOPY( ORIGE, CRIAR )
netzap( criar )
ENDIF
NEXT X
RETU

// : FIM: FO1K.PRG

// + EOF: fo1k.prg
// +
