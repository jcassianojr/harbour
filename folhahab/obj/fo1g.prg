// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo1g.prg
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
// :       FO1G.PRG: Aguarda Dados Cadastro Empresa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 05/03/94      9:58
// :
// :*****************************************************************************

#include "INKEY.CH"
v_pic := "@S18"

SET KEY K_F11 TO TECLAF11
@  4, 03 SAY mNRCLIEN
@  4, 11 GET mCOGNOME
@  4, 28 GET mRAZAO
@  4, 77 GET mPESSOA    PICTURE "!"                                                                          VALID mPESSOA $ 'FJOC '
@ 11, 13 GET mCGC       PICT( v_pic )                                                                          WHEN {| oGet | CNPJCPFPICT( oGet, mPESSOA, 11, 13 ) }                           VALID CNPJCPFVAL( mCGC, mPESSOA )
@  6, 12 GET mENDERECO
@  6, 53 GET mBAIRRO
@  7, 26 GET mESTADO    PICTURE "!!"                                                                         VALID CHECKTAB( PadR( "UF", 4 ) + PadR( mESTADO, 5 ), 24, 0, "Estado Nao Cadastrado" )
@  7, 29 GET mCIDADE    VALID CHECKCID( mESTADO, mCIDADE, .T. )
@  7, 49 GET mCEP       PICTURE "99999-999"                                                                  VALID CHKUFCEP( mCEP, mESTADO )
@  8, 7  GET mDDD
@  8, 19 GET mTELEFONE
@  8, 37 GET mRAMAL
@  8, 49 GET mFAX
@  8, 68 GET mSIMPLES   VALID CHECKTAB( PadR( "SIMP", 4 ) + PadR( mSIMPLES, 4 ), 24, 0, "Codigo Simples Nao Cadastrado" )
@  9, 15 GET mRESPONSAV
@  9, 61 GET mCPFRESP   PICT "999.999.999-99"                                                                VALID VALCPF( mCPFRESP )
@ 10, 68 GET mDNRESP
READCUR()
@ 12, 13 GET mINSC       VALID                                                                                    VALIE( mINSC, mESTADO, mPESSOA )
@ 13, 13 GET mCEI        VALID VALCEI( mCEI )
@ 14, 19 GET mCONCAGED   PICTURE '@R 999999-9'                                                                    VALID CRITCONV( mCONCAGED )
@ 15, 29 GET mNAT_ESTAB  VALID VERSEHA( "RAISNATJ",, mNAT_ESTAB, "NOME", "'Natureza Juridica Invalida'" )
@ 16, 24 GET mHORASMES   PICTURE "###.##"                                                                         VALID mHORASMES > 0
@ 17, 24 GET mARREDONDA  PICTURE "###,###,###.##"
@ 18, 18 GET mSALNOR     PICTURE '9999.999'
@ 19, 11 GET mNR_SOCIOS  PICTURE '99'
@ 19, 26 GET mNR_FAMILIA PICTURE '99'
@ 19, 35 GET mPRODU      PICTURE "!"                                                                              VALID mPRODU $ ' SN'
@ 20, 13 GET mATIVIDADE  VALID VERSEHA( "FO_CNAE2",, mATIVIDADE, "DESCRICAO", "'Codigo de Atividade inconsistente '" )
@ 20, 23 GET mATIDES
@ 21, 31 GET mINIANO     PICTURE "!"                                                                              VALID mINIANO $ ' SN'
@ 22, 19 GET mCODIBGE
READCUR()
@ 12, 47 GET mSALJAN PICTURE "#,###,###.##"
@ 13, 47 GET mSALFEV PICTURE "#,###,###.##"
@ 14, 47 GET mSALMAR PICTURE "#,###,###.##"
@ 15, 47 GET mSALABR PICTURE "#,###,###.##"
@ 16, 47 GET mSALMAI PICTURE "#,###,###.##"
@ 17, 47 GET mSALJUN PICTURE "#,###,###.##"
@ 12, 66 GET mSALJUL PICTURE "#,###,###.##"
@ 13, 66 GET mSALAGO PICTURE "#,###,###.##"
@ 14, 66 GET mSALSET PICTURE "#,###,###.##"
@ 15, 66 GET mSALOUT PICTURE "#,###,###.##"
@ 16, 66 GET mSALNOV PICTURE "#,###,###.##"
@ 17, 66 GET mSALDEZ PICTURE "#,###,###.##"
READCUR()
@ 19, 73 GET mPAGAR   PICTURE "!"                                                                 VALID mPAGAR $ 'SN'
@ 20, 71 GET mACID    VALID VERSEHA( "FO_CSAT",, mACID, "DESCRICAO", "'COdigo SAT inconsistente '" )
@ 21, 57 GET mCATFGTS VALID CHECKTAB( "CATG" + PadR( mCATFGTS, 5 ), 24, 0, "Categoria Inconsistente" )
@ 21, 71 GET mFPAS    VALID VERSEHA( "CONFINSS",, mFPAS, "DESCRICAO", "'COdigo FPAS inconsistente '" )
@ 22, 48 GET mEMAIL   PICT "@S30"                                                                 VALID CHECKEMAIL( mEMAIL )
READCUR()
SET KEY K_F11


// Ajusta Variaveis de Trabalho
MSG2      := Trim( mRAZAO )
MSG2A     := Trim( mCOGNOME )
ENDER1    := Trim( mENDERECO )
BAI1      := Trim( mBAIRRO )
CID1      := mCIDADE
EST1      := mESTADO
CEP1      := mCEP
MSG3      := mSENHA
MESHORA   := IF( mHORASMES > 0, mHORASMES, 220 )
FPAS1     := mFPAS
ACID1     := mACID
CGC       := mCGC
CGC1      := mCGC
ATIV1     := mATIVIDADE
RECOIRRF  := mPAGAR
zTELEFONE := mTELEFONE
zFAX      := mFAX
zPESSOA   := mPESSOA
zCEI      := mCEI



CABEX( 'CADASTRO BANCO PARA O FGTS/RAIS' )
mEMP := mNRCLIEN
NOVOREG( "BCOFGTS", "BCOFGTS", mEMP )
IGUALVARS( "BCOFGTS", "BCOFGTS", mEMP )
TELASAY( "BCOFGT" )
EDITSAY( "BCOFGT" )
REPORVARS( "BCOFGTS", "BCOFGTS", mEMP )
// Volta as Variaveis pois sao iguas BCOFGTS/Firma
// E gravava no firma os valores do bcofgts
mENDERECO := ENDER1
mCIDADE   := CID1


// *******************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DVSA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DVSA

   PARAMETERS wsa

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   sdvsa  := 0
   wdvsa  := Val( SubStr( wsa, 13, 1 ) )
   wmodsa := 2
   IF ( Val( wsa ) != 0 )
      IF ( SubStr( wsa, 6, 3 ) = "000" )
         wcodsa := SubStr( wsa, 1, 5 ) + SubStr( wsa, 9, 4 )
         FOR i := 1 TO 9
            sdvsa  := sdvsa + wmodsa * Val( SubStr( wcodsa, 10 - i, 1 ) )
            wmodsa := iif( wmodsa < 9, wmodsa + 1, 2 )
         NEXT
      ELSE
         wcodsa := SubStr( wsa, 1, 12 )
         FOR i := 1 TO 12
            sdvsa  := sdvsa + wmodsa * Val( SubStr( wcodsa, 13 - i, 1 ) )
            wmodsa := iif( wmodsa < 9, wmodsa + 1, 2 )
         NEXT
      ENDIF
      wrestsa := Mod( sdvsa, 11 )
      wdigsa  := iif( wrestsa = 0 .OR. wrestsa = 1, 0, 11 - wrestsa )
   ELSE
      wdigsa := wdvsa
   ENDIF
   lRETU := iif( wdigsa = wdvsa, .T., .F. )
   IF !lRETU
      ALERTX( "Indentifica‡„o da Empresa Errada" )
   ENDIF

   RETURN lRETU


// *******************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CRITCONV()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CRITCONV

   IF LastKey() = K_UP .OR. LastKey() = K_DOWN
      RETU .T.
   ENDIF
   PARAMETERS num
   PRIVATE tot, dv
   tot := Val( SubStr( num, 1, 1 ) ) * 7 + Val( SubStr( num, 2, 1 ) ) * 6 + ;
      Val( SubStr( num, 3, 1 ) ) * 5 + Val( SubStr( num, 4, 1 ) ) * 4 + ;
      Val( SubStr( num, 5, 1 ) ) * 3 + Val( SubStr( num, 6, 1 ) ) * 2
   dv := tot % 11
   IF ( dv != 0 .AND. dv != 1 )
      dv := 11 - dv
   ELSE
      dv := 0
   ENDIF
   IF ( dv = Val( SubStr( num, 7, 1 ) ) )
      RETURN .T.
   ELSE
      ALERTX( "Numero do DV errado !  " )
      RETURN .F.
   ENDIF

// + EOF: fo1g.prg
// +
