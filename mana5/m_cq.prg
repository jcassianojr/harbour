// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cq.prg
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


MDI( "Ajusta Tela de Exibi‡„o" )
xCODIGO := Space( 6 )
MDS( "Digite o Codigo" )
@ 24, 40 GET xCODIGO
IF !READCUR()
RETU .F.
ENDIF

PADRAO( 0, 1, 0, "MANGET", "Codigo Seq T LI CI LF CF Dizer", ;
      "' '+mCODIGO+' '+STR(mSEQ,  3)+' '+mTIP+' '+STR(mLININI,  2)+' '+STR(mCOLINI,  2)+' '+STR(mLINFIM,  2)+' '+STR(mCOLFIM,  2)+' '+mCAMPO+' '+mMENSAGEM", ;
      "MCQ", "MCQ001", "MCQ001", ;
      {|| mCODIGO := xCODIGO }, {|| PADARR( "MANGET", xCODIGO, "CODIGO", "XCODIGO" ) } )



// + EOF: m_cq.prg
// +
