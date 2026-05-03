// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : comp1.prg
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


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Sonumero()
// +
// + usar diretamente sonumerox sonumero e usada na classe sefaz 
// +
// +--------------------------------------------------------------------
// +
// +
// +
//FUNCTION Sonumero( cInString, lPONTO, lVIRGULA )

//   RETURN SonumeroX( cInString, lPONTO, lVIRGULA )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TEMPOR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC TEMPOR   // Para colar a funcao na linkedicao

   TIMEVALID()
   ADDMONTH()
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function AGEN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION AGEN

   PRIV mCDDATA := CToD( "  /  /  " ), GETLLIST := {}
   PRIV mOBS1   := mOBS2 := mOBS3 := mOBS4 := mOBS5 := mOBS6 := mOBS7 := mOBS8 := Space( 60 )

   aAMBAGE := SALVAA()
   PADRAO( 0, 1, 0, "AGENDA", "Data     Compromisso", "' '+DTOC(mCDDATA)+' '+mOBS1", "MDF" )
   RESTAA( aAMBAGE )
/*PAD001  := COR("PAD001")
PAD002  := COR("PAD002")
PAD005  := COR("PAD005")
PAD006  := COR("PAD006")
PAD007  := COR("PAD007")
MDS('Digite Por Data da Agenda: ')
@ 24,40 GET mCDDATA
READCUR()
IF !IGUALVARS("AGENDA",mCDDATA)
   NOVOREG("AGENDA",mCDDATA)
ENDIF
TELASAY("MDF001")
EDITSAY("MDF001")
REPORVARS("AGENDA",mCDDATA)
*/

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TELE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TELE

   PRIV mNOME := Space( 15 ), mESPECIF := Space( 35 ), mTELEF := Space( 14 ), ;
      mFAX := Space( 14 ), GETLIST := {}

   aAMBTEL := SALVAA()
   PADRAO( 0, 1, 0, "TELEMEMO", 'Nome' + spac( 12 ) + 'Descri‡„o' + spac( 27 ) + 'Telefone', ;
      "' '+mNOME+' '+mESPECIF+' '+mTELEF", "MDE" )
   RESTAA( aAMBTEL )
/*
PAD001  := COR("PAD001")
PAD002  := COR("PAD002")
PAD005  := COR("PAD005")
PAD006  := COR("PAD006")
PAD007  := COR("PAD007")
MDS('Digite Nome: ')
@ 24,40 GET mNOME
READCUR()
IF !IGUALVARS("TELEMEMO",mNOME)
   NOVOREG("TELEMEMO",mNOME)
ENDIF
TELASAY("MDE001")
EDITSAY("MDE001")
REPORVARS("TELEMEMO",mNOME)
*/

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NOTEP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION NOTEP

   PRIV mNOME := Space( 10 ), GETLLIST := {}
   PRIV mOBS1 := mOBS2 := mOBS3 := mOBS4 := mOBS5 := mOBS6 := mOBS7 := mOBS8 := Space( 60 )

   aAMBNOT := SALVAA()
   PADRAO( 0, 1, 0, "NOTA", "Nome" + spac( 7 ) + "Descricao", "' '+mNOME+' '+mOBS1", "MDG" )
   RESTAA( aAMBNOT )

/*PAD001 := COR("PAD001")
PAD002 := COR("PAD002")
PAD005 := COR("PAD005")
PAD006 := COR("PAD006")
PAD007 := COR("PAD007")
MDS('Digite Nome da Anota‡„o ?')
@ 24,30 get mNOME
READCUR()
IF !IGUALVARS("NOTA",mNOME)
   NOVOREG("NOTA",mNOME)
ENDIF
TELASAY("MDG001")
EDITSAY("MDG001")
REPORVARS("NOTA",mNOME)
*/

   RETURN .T.

// + EOF: comp1.prg
// +
