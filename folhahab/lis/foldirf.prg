// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foldirf.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "INKEY.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DIRFPEGDAD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DIRFPEGDAD( nUSO )

   PRIVATE v_pic := "@S18"

   IF ValType( nUSO ) # "N"
      nUSO := 1
   ENDIF
   SET KEY K_F11 TO TECLAF11
   hb_DispBox( 4, 0, 23, 79, B_DOUBLE )
   @  5, 2  SAY "Dados do Reponsavel Pelo Arquivo"
   @  7, 2  SAY "CGC" + spac( 17 ) + "Nome"
   @  9, 02 SAY "E-Mail"
   @ 10, 2  SAY "DDD   Telefone  Telefax  Ramal"
   @ 12, 02 SAY "Ano Base/Ano Ref "
   @ 12, 40 SAY "Codigo de Reten‡ao"
   @ 14, 02 SAY "Operacao"
   @ 14, 15 SAY "O-riginal R-etifica"
   @ 14, 39 SAY "(1)Nor(2)Esp"
   @ 14, 50 SAY "Natureza"
   @ 14, 61 SAY "Identifi"
   @ 15, 02 SAY "Numero Entrega Dec.Anterior"
   @ 17, 02 SAY "Responsavel"
   @ 18, 02 SAY "CPF"
   @ 18, 42 SAY "CPF/CNPJ"
   @ 19, 02 SAY "Nome do Arquivo"
   @ 20, 02 SAY "Arquivo Detalhes"
   @ 21, 02 SAY "Grava Reg 1"
   @  8, 2  GET xrCGC
   @  8, 22 GET xrNOME                             PICT "@S40"
   @  9, 10 GET mEMAIL                             VALID checkemail( mEMAIL )
   @ 11, 02 GET mrXDDD
   @ 11, 08 GET mrXTEL
   @ 11, 18 GET mrXFAX
   @ 11, 28 GET xrRAMAL
   @ 12, 20 GET ANO
   @ 12, 25 GET ANOREF
   IF nUSO = 1
      @ 12, 60 GET CODRET VALID VERSEHA( "CODIRRF",, CODRET, "NOME", '"Codigo de Retencao n„o cadastrado"' )
   ELSE
      @ 12, 60 GET CODRET
   ENDIF
   @ 14, 11 GET OPER       PICT "!"                   VALID OPER $ "OR"
   @ 14, 48 GET SITU       VALID SITU $ "12"
   @ 14, 59 GET NATUR      VALID NATUR $ "0123456789"
   @ 14, 70 GET IDEN       VALID IDEN $ "01"
   @ 15, 35 GET xNUMEROANT
   @ 17, 15 GET xrRESN
   @ 18, 10 GET xrRESC     PICT "999.999.999-99"      VALID VALCPF( xrRESC )
   @ 18, 50 GET mPESSOA    PICTURE "!"                VALID mPESSOA $ 'FJOC '
   @ 18, 52 GET CPFCNPJ    PICT( v_pic )                WHEN {| oGet | CNPJCPFPICT( oGet, mPESSOA, 18, 52 ) } VALID CNPJCPFVAL( CPFCNPJ, mPESSOA )
   @ 19, 20 GET ARQ
   @ 20, 20 GET ARQDET
   @ 21, 14 GET GRAVA1
   IF !READCUR()
      SET KEY K_F11 TO
      RETU .F.
   ENDIF
   SET KEY K_F11 TO
   ARQ    := AllTrim( ARQ )
   ARQDET := AllTrim( ARQDET )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DIRFREG01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC DIRFREG01()

// GravanDo o Header Empresa Tipo 1
   FWrite( USO, StrZero( SEQ, 8 ) )
   FWrite( USO, "1" )
   FWrite( USO, mCGC + mEST )
   FWrite( USO, "DIRF" )
   FWrite( USO, ANO )
   FWrite( USO, OPER )  // (O)ori (R)eti
   FWrite( USO, SITU )  // 1-Nor (2)Esp
   IF XRPESSOA = "F"
      FWrite( USO, "1" )  // Pessoa fisica
   ELSE
      FWrite( USO, "2" )  // Pessoa Juridica
   ENDIF
   FWrite( USO, NATUR )   // 0-9 Conforme Tipo Pessoa
   FWrite( USO, IDEN )
   FWrite( USO, ANOREF )
   FWrite( USO, "0" )   // Sem Deposito Judiciario
   FWrite( USO, Space( 1 ) )
   FWrite( USO, xrNOME )
   FWrite( USO, mCPFCNPJ )
// FWRITE(USO,SPACE(37))
   FWrite( USO, Space( 8 ) )  // data evento
   FWrite( USO, Space( 1 ) )  // tipo evento //1 encerramento espolio 2-saida definitiva pais
// fwrite(USO,space(28))
// FWRITE(USO,mCGC+mEST) //28+14 MCGC+MEST mudado 2007 vai em branco
   FWrite( USO, Space( 42 ) )
   FWrite( USO, xNUMEROANT )
   FWrite( USO, Space( 229 ) )
   FWrite( USO, mrCPF )
   FWrite( USO, xrRESn )
   FWrite( USO, mrXDDD )
   FWrite( USO, mrXTEL )
   FWrite( USO, StrZero( Val( xrRAMAL ), 6 ) )
   FWrite( USO, mrXFAX )
   FWrite( USO, mEMAIL )
   FWrite( USO, Space( 165 ) )
   FWrite( USO, StrZero( mNRCLIEN, 12 ) )
   FWrite( USO, "9" )
   FWrite( USO, Chr( 13 ) + Chr( 10 ) )
   SEQ++
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DIRFREG02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC DIRFREG02( cTIPO )

// Registro tipo 2 Beneficiario
   FWrite( USO, StrZero( SEQ, 8 ) )
   IF cTIPO <> "3"
      FWrite( USO, "2" )
   ELSE
      FWrite( USO, "3" )
   ENDIF
   FWrite( USO, mCGC + mEST )
   FWrite( USO, CODRET )
   IF cTIPO <> "3"
      IF mPESSOA = "F"
         FWrite( USO, "1" )   // Beneficiario Pessoa fisica
      ELSE
         FWrite( USO, "2" )   // Beneficiario Pessoa Juridica
      ENDIF
      FWrite( USO, USOCGC )
      FWrite( USO, ACEPAD( mNOME, 60 ) )
   ELSE
      FWrite( USO, StrZero( nREG02, 8 ) )
      FWrite( USO, Space( 67 ) )
   ENDIF
   IF cTIPO <> "3"
      FOR X := 1 TO 13
         aTOTREN[ X ] += aREND[ X ]
         aTOTDED[ X ] += aDEDU[ X ]
         aTOTIRR[ X ] += aIRRF[ X ]
         IF cTIPO = "0"
            FWrite( USO, GRVVAL( aREND[ X ], 15, 2 ) )
            FWrite( USO, GRVVAL( aDEDU[ X ], 15, 2 ) )
            FWrite( USO, GRVVAL( aIRRF[ X ], 15, 2 ) )
         ENDIF
         IF cTIPO = "1"
            FWrite( USO, GRVVAL( aPREV[ X ], 15, 2 ) )
            FWrite( USO, GRVVAL( aDEPE[ X ], 15, 2 ) )
            FWrite( USO, GRVVAL( aPENS[ X ], 15, 2 ) )
         ENDIF
         IF cTIPO = "2"
            FWrite( USO, GRVVAL( aPRIV[ X ], 15, 2 ) )
            FWrite( USO, GRVVAL( 0, 15, 2 ) )
            FWrite( USO, GRVVAL( 0, 15, 2 ) )
         ENDIF
      NEXT X
   ELSE
      FOR X := 1 TO 13
         FWrite( USO, GRVVAL( aTOTREN[ X ], 15, 2 ) )
         FWrite( USO, GRVVAL( aTOTDED[ X ], 15, 2 ) )
         FWrite( USO, GRVVAL( aTOTIRR[ X ], 15, 2 ) )
      NEXT X
   ENDIF
   FWrite( USO, "0" )
   IF CTIPO = 3
      FWrite( USO, "0" )
   ELSE
      FWrite( USO, cTIPO )  // 0=BASE/DEDU/IRRF 1=PREV/DEP/PENSAO 2=PRIV
   ENDIF
   FWrite( USO, Space( 8 ) )
   FWrite( USO, Space( 20 ) )
   FWrite( USO, StrZero( mNUMERO, 12 ) )
   FWrite( USO, "9" )
   FWrite( USO, Chr( 13 ) + Chr( 10 ) )
   nREG02++
   SEQ++
   RETU .T.

// + EOF: foldirf.prg
// +
