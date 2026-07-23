*+--------------------------------------------------------------------
*+
*+    Programa  : dbuleto.prg
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+
*+    Documentado em 6-Jan-2025 as  3:37 pm
*+
*+--------------------------------------------------------------------
*+

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function cryptomenu()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +


REQUEST DBFCDXEX



FUNCTION cryptomenu()


LOCAL aAMBIENTE

cTIPOSQL := "DBFCDXEX"  // Passa para privada usadas nas funcoes aBaixo

aAMBIENTE  := SALVAA()
cSERVERX   := Space(30)
cDATABASEX := Space(30)
cUSERX     := Space(30)
cPASSX     := Space(30)
cTABELAX   := Space(30)
cBANCOX   := Space(30)
cOWNERX   := Space(30)
cPORTAX    :=SPACE(30)

cPATH      :=""
loledb     := .T.
lMDB       := .F.
lACCDB     := .F.
lFDB       := .F.

zSENHACDX := INPUTBOX( PADR( zSENHACDX,30 ), "Novo database" )
zSENHACDX :=ALLTRIM(zSENHACDX)
USOVIA := "DBFCDXEX"
rddSetDefault("DBFCDXEX")   
DbfcdxexSetup( "aes256", zSENHACDX )



WHILE .T.
   hb_DispBox(3,18,18,55,B_DOUBLE+" ")
   @ 03,24 SAY "Crypto DBF DBFCDXEX"        
   OPCAO(4,24,"&Encryptar                 ",86)   // V
   OPCAO(5,24,"&Descrptar                 ",84)   // T
   OPCAO(6,24,"&Checar                    ",73)   // I
   //opcao backup zip
   KEY := menu(1,0)
   DO CASE
   CASE KEY = 1
      
   CASE KEY = 2
      
   CASE KEY = 3
      
   OTHERWISE
      EXIT
   ENDCASE
ENDDO

TIPODBF := nOLDTIPORDD
rddSetDefault(cOLDRDD)
RDDNOME(TIPODBF)

RESTAA(aAMBIENTE)
LAYOUT()

RETURN .T.



// cARQORI    := win_GetOpenFileName(, "Arquivos de Origem", hb_cwd(), "Arquivos de Origem", "*.dbf", 1 )
  