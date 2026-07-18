// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bz.prg
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


// :*****************************************************************************
// :
// :      M_BZB.PRG: Calcular e Imprimir Relat¢rio de Fluxo Financeiro
// :      Linguagem: harbour
// :        Sistema: Mana5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :      Atualizado:
// :
// :*****************************************************************************


// #INCLUDE "COMANDO.CH"

RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FLUXO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FLUXO( lENV )

   IF ValType( lENV ) # "L"
      lENV := .F.
   ENDIF
// Variaveis de Trabalho
   CRIARVARS( "ML01" )
   CRIARVARS( "MN01" )
   CRIARVARS( "MZ01" )
   aLAYG1   := PEGLAY( "MEXPOR1", "MBZ001" )
   aLAYG2   := PEGLAY( "MEXPOR1", "MBZ002" )
   DODIA    := bom( ZDATA )
   ATEDIA   := eom( ZDATA )
   SALDOANT := 0.00
   PREVER   := "S"
   mAL1     := mAL2 := mAL3 := mAL4 := mAL5 := mAL6 := mAL7 := 0
   mAN1     := mAN2 := mAN3 := mAN4 := mAN5 := mAN6 := mAN7 := 0
   mANI     := 1
   mALI     := 0

   mAL7 := 2   // Sabado  _>Segunda
   mAL1 := 1   // Domingo _>Segunda

   mAN7 := 2   // Sabado  _>Segunda
   mAN1 := 1   // Domingo _>Segunda


   TELASAY( "MBZ001" )
   EDITSAY( "MBZ001" )
   FATOR_AUX := SALDOANT


   ZAPARQ( { { "MZ01", .F., .T. } } )
   aMAL := { mAL1, mAL2, mAL3, mAL4, mAL5, mAL6, mAL7 }
   aMAN := { mAN1, mAN2, mAN3, mAN4, mAN5, mAN6, mAN7 }

   @ 24, 00
   @ 24, 00 SAY 'Carregando o Contas a Pagar'
   IF !USEREDE( "ML01", 1, 1 )   // Contas a Pagar
      dbCloseAll()
      RETU
   ENDIF
   WHILE !Eof()
      IF VENCIMENT >= DODIA .AND. VENCIMENT <= ATEDIA
         @ 24, 70 SAY NRNOTA
         mNRNOTA    := NRNOTA
         mTIPFAT    := TIPFAT
         mDATA      := DATA
         mFORNECEDO := CLIENTE
         mCOGNOME   := COGNOME
         mDDD       := DDD
         mTELEFONE  := TELEFONE
         mSITUACAO  := SITUACAO
         mBANCO     := BANCO
         mNOMEBCO   := NOMEBCO
         mDOCBOL    := DOCBOL
         mVENCIMENT := VENCIMENT
         mDOCBOL    := DOCBOL
         mVALOR     := VALOR
         mOBS       := OBS
         mOBS1      := OBS1
         mOBS2      := OBS2
         mOBS3      := OBS3
         mOBS4      := OBS4
         mVENCIMENT += mALI
         IF lENV
            mVALOR := mVALOR * -1
         ENDIF
         WHILE .T.
            IF DoW( mVENCIMENT ) > 0   // Evita Erro Data em Branco
               mVENCIMENT += aMAL[ DoW( mVENCIMENT ) ]
            ENDIF
            IF VERSEHA( "MANFER", Str( Day( mVENCIMENT ), 2 ) + Str( Month( mVENCIMENT ), 2 ) )
               mVENCIMENT++
            ELSE
               EXIT
            ENDIF
         ENDDO
         GRAVALAY( aLAYG1, "MZ01",, .F.,, .T. )
      ENDIF
      SELE ML01
      dbSkip()
   ENDDO
   dbSelectAr( "ML01" )
   dbCloseArea()
   @ 24, 00
   @ 24, 00 SAY 'Carregando o Contas a Receber'
   IF !USEREDE( "MN01", 1, 1 )
      dbCloseAll()
      RETU
   ENDIF
   WHILE !Eof()
      IF VENCIMENT >= DODIA .AND. VENCIMENT <= ATEDIA .AND. FLUXO <> "N"
         @ 24, 70 SAY NRNOTA
         mNUMERO    := NRNOTA
         mTIPFAT    := TIPFAT
         mDATA      := DATA
         mFORNECEDO := CLIENTE
         mCOGNOME   := COGNOME
         mDDD       := DDD
         mTELEFONE  := TELEFONE
         mSITUACAO  := SITUACAO
         mBANCO     := BANCO
         mNOMEBCO   := NOMEBCO
         mDOCBOL    := DOCBOL
         mVENCIMENT := VENCIMENT
         mVALOR     := VALOR
         mOBS       := OBS
         mOBS1      := OBS1
         mOBS2      := OBS2
         mOBS3      := OBS3
         mOBS4      := OBS4
         mVENCIMENT := IF( PREVATR > 0 .AND. PREVER = "S", mVENCIMENT + PREVATR, mVENCIMENT )
         mVENCIMENT += mANI
         WHILE .T.
            IF DoW( mVENCIMENT ) > 0   // Evita Erro Data em Branco
               mVENCIMENT += aMAN[ DoW( mVENCIMENT ) ]
            ENDIF
            IF VERSEHA( "MANFER", Str( Day( mVENCIMENT ), 2 ) + Str( Month( mVENCIMENT ), 2 ) )
               mVENCIMENT++
            ELSE
               EXIT
            ENDIF
         ENDDO
         GRAVALAY( aLAYG2, "MZ01",, .F.,, .T. )
      ENDIF
      dbSelectAr( "MN01" )
      dbSkip()
   ENDDO
   dbSelectAr( "MN01" )
   dbCloseArea()
   dbSelectAr( "MZ01" )
   dbGoTop()
   RETU .T.

// + EOF: m_bz.prg
// +
