// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_45.prg
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


CABE2( "FOPTO_45 - Contas/Transferia/Formulas" )
IF !netuse( "FOPTOCON" )
RETURN .F.
ENDIF
IF !dbSeek( nremp )
netrecapp()
field->empresa := nremp
ELSE
netreclock()
ENDIF
initvars()
equvars()

IF !netuse( "FOPTOBCO" )
dbCloseAll()
RETURN .F.
ENDIF
IF !dbSeek( nremp )
netrecapp()
field->empresa := nremp
ELSE
netreclock()
ENDIF
initvars()
equvars()

IF !netuse( "FOPTOVAL" )
dbCloseAll()
RETURN .F.
ENDIF
IF !dbSeek( nremp )
netrecapp()
field->empresa := nremp
ELSE
netreclock()
ENDIF
initvars()
equvars()


@  5, 0  SAY "Conta 01 Transfere:"
@  7, 0  SAY "BCO"
@ 08, 0  SAY "Conta 02 Transfere:"
@ 10, 0  SAY "BCO"
@ 11, 0  SAY "Conta 03 Transfere:"
@ 13, 0  SAY "BCO"
@ 14, 0  SAY "Conta 04 Transfere:"
@ 16, 0  SAY "BCO"
@ 17, 0  SAY "Conta 05 Transfere:"
@ 19, 0  SAY "BCO"
@ 20, 0  SAY "Conta 06 Transfere:"
@ 22, 0  SAY "BCO"
@ 05, 20 GET mTR01                 VALID mTR01 $ "SN "
@ 05, 25 GET mCX01                 PICT "@S50"
@ 06, 05 GET mOP01                 PICT "@S70"
@ 07, 05 GET mBCO01                PICT "@S70"
@ 08, 20 GET mTR02                 VALID mTR02 $ "SN "
@ 08, 25 GET mCX02                 PICT "@S50"
@ 09, 05 GET mOP02                 PICT "@S70"
@ 10, 05 GET mBCO02                PICT "@S70"
@ 11, 20 GET mTR03                 VALID mTR03 $ "SN "
@ 11, 25 GET mCX03                 PICT "@S50"
@ 12, 05 GET mOP03                 PICT "@S70"
@ 13, 05 GET mBCO03                PICT "@S70"
@ 14, 20 GET mTR04                 VALID mTR04 $ "SN "
@ 14, 25 GET mCX04                 PICT "@S50"
@ 15, 05 GET mOP04                 PICT "@S70"
@ 16, 05 GET mBCO04                PICT "@S70"
@ 17, 20 GET mTR05                 VALID mTR05 $ "SN "
@ 17, 25 GET mCX05                 PICT "@S50"
@ 18, 05 GET mOP05                 PICT "@S70"
@ 19, 05 GET mBCO05                PICT "@S70"
@ 20, 20 GET mTR06                 VALID mTR06 $ "SN "
@ 20, 25 GET mCX06                 PICT "@S50"
@ 21, 05 GET mOP06                 PICT "@S70"
@ 22, 05 GET mBCO06                PICT "@S70"
READCUR()

@  5, 00 CLEAR
@  5, 0  SAY "Conta 07 Transfere:"
@  7, 0  SAY "BCO"
@ 08, 0  SAY "Conta 08 Transfere:"
@ 10, 0  SAY "BCO"
@ 11, 0  SAY "Conta 09 Transfere:"
@ 13, 0  SAY "BCO"
@ 14, 0  SAY "Conta 10 Transfere:"
@ 16, 0  SAY "BCO"
@ 17, 0  SAY "Conta 11 Transfere:"
@ 19, 0  SAY "BCO"
@ 20, 0  SAY "Conta 12 Transfere:"
@ 22, 0  SAY "BCO"
@ 05, 20 GET mTR07                 VALID mTR07 $ "SN "
@ 05, 25 GET mCX07                 PICT "@S50"
@ 06, 05 GET mOP07                 PICT "@S70"
@ 07, 05 GET mBCO07                PICT "@S70"
@ 08, 20 GET mTR08                 VALID mTR08 $ "SN "
@ 08, 25 GET mCX08                 PICT "@S50"
@ 09, 05 GET mOP08                 PICT "@S70"
@ 10, 05 GET mBCO08                PICT "@S70"
@ 11, 20 GET mTR09                 VALID mTR09 $ "SN "
@ 11, 25 GET mCX09                 PICT "@S50"
@ 12, 05 GET mOP09                 PICT "@S70"
@ 13, 05 GET mBCO09                PICT "@S70"
@ 14, 20 GET mTR10                 VALID mTR10 $ "SN "
@ 14, 25 GET mCX10                 PICT "@S50"
@ 15, 05 GET mOP10                 PICT "@S70"
@ 16, 05 GET mBCO10                PICT "@S70"
@ 17, 20 GET mTR11                 VALID mTR11 $ "SN "
@ 17, 25 GET mCX11                 PICT "@S50"
@ 18, 05 GET mOP11                 PICT "@S70"
@ 19, 05 GET mBCO11                PICT "@S70"
@ 20, 20 GET mTR12                 VALID mTR12 $ "SN "
@ 20, 25 GET mCX12                 PICT "@S50"
@ 21, 05 GET mOP12                 PICT "@S70"
@ 22, 05 GET mBCO12                PICT "@S70"
READCUR()

@  5, 00 CLEAR
@  5, 0  SAY "Conta 13 Transfere:"
@  7, 0  SAY "BCO"
@ 08, 0  SAY "Conta 14 Transfere:"
@ 10, 0  SAY "BCO"
@ 11, 0  SAY "Conta 15 Transfere:"
@ 13, 0  SAY "BCO"
@ 14, 0  SAY "Conta 16 Transfere:"
@ 16, 0  SAY "BCO"
@ 17, 0  SAY "Conta 17 Transfere:"
@ 19, 0  SAY "BCO"
@ 20, 0  SAY "Conta 18 Transfere:"
@ 22, 0  SAY "BCO"
@ 05, 20 GET mTR13                 VALID mTR13 $ "SN "
@ 05, 25 GET mCX13                 PICT "@S50"
@ 06, 05 GET mOP13                 PICT "@S70"
@ 07, 05 GET mBCO13                PICT "@S70"
@ 08, 20 GET mTR14                 VALID mTR14 $ "SN "
@ 08, 25 GET mCX14                 PICT "@S50"
@ 09, 05 GET mOP14                 PICT "@S70"
@ 10, 05 GET mBCO14                PICT "@S70"
@ 11, 20 GET mTR15                 VALID mTR15 $ "SN "
@ 11, 25 GET mCX15                 PICT "@S50"
@ 12, 05 GET mOP15                 PICT "@S70"
@ 13, 05 GET mBCO15                PICT "@S70"
@ 14, 20 GET mTR16                 VALID mTR16 $ "SN "
@ 14, 25 GET mCX16                 PICT "@S50"
@ 15, 05 GET mOP16                 PICT "@S70"
@ 16, 05 GET mBCO16                PICT "@S70"
@ 17, 20 GET mTR17                 VALID mTR17 $ "SN "
@ 17, 25 GET mCX17                 PICT "@S50"
@ 18, 05 GET mOP17                 PICT "@S70"
@ 19, 05 GET mBCO17                PICT "@S70"
@ 20, 20 GET mTR18                 VALID mTR18 $ "SN "
@ 20, 25 GET mCX18                 PICT "@S50"
@ 21, 05 GET mOP18                 PICT "@S70"
@ 22, 05 GET mBCO18                PICT "@S70"
READCUR()

@  5, 00 CLEAR
@  5, 0  SAY "Conta 19 Transfere:"
@  7, 0  SAY "BCO"
@ 08, 0  SAY "Conta 20 Transfere:"
@ 10, 0  SAY "BCO"
@ 11, 0  SAY "Conta 21 Transfere:"
@ 13, 0  SAY "BCO"
@ 14, 0  SAY "Conta 22 Transfere:"
@ 16, 0  SAY "BCO"
@ 17, 0  SAY "Conta 23 Transfere:"
@ 19, 0  SAY "BCO"
@ 20, 0  SAY "Conta 24 Transfere:"
@ 22, 0  SAY "BCO"
@ 23, 0  SAY "BOCHR"
@ 24, 0  SAY "BOCTT"
@ 05, 20 GET mTR19                 VALID mTR19 $ "SN "
@ 05, 25 GET mCX19                 PICT "@S50"
@ 06, 05 GET mOP19                 PICT "@S70"
@ 07, 05 GET mBCO19                PICT "@S70"
@ 08, 20 GET mTR20                 VALID mTR20 $ "SN "
@ 08, 25 GET mCX20                 PICT "@S50"
@ 09, 05 GET mOP20                 PICT "@S70"
@ 10, 05 GET mBCO20                PICT "@S70"
@ 11, 20 GET mTR21                 VALID mTR21 $ "SN "
@ 11, 25 GET mCX21                 PICT "@S50"
@ 12, 05 GET mOP21                 PICT "@S70"
@ 13, 05 GET mBCO21                PICT "@S70"
@ 14, 20 GET mTR22                 VALID mTR22 $ "SN "
@ 14, 25 GET mCX22                 PICT "@S50"
@ 15, 05 GET mOP22                 PICT "@S70"
@ 16, 05 GET mBCO22                PICT "@S70"
@ 17, 20 GET mTR23                 VALID mTR23 $ "SN "
@ 17, 25 GET mCX23                 PICT "@S50"
@ 18, 05 GET mOP23                 PICT "@S70"
@ 19, 05 GET mBCO23                PICT "@S70"
@ 20, 20 GET mTR24                 VALID mTR24 $ "SN "
@ 20, 25 GET mCX24                 PICT "@S50"
@ 21, 05 GET mOP24                 PICT "@S70"
@ 22, 05 GET mBCO24                PICT "@S70"
@ 23, 6  GET mBCOHR                PICT "@S70"
@ 24, 6  GET mBCOTT                PICT "@S70"
READCUR()


@  5, 00 CLEAR
@  5, 0  SAY "01 Inicial"
@  6, 0  SAY "   Soma   "
@  7, 0  SAY "   Valores"
@  8, 0  SAY "   Fechar "
@  9, 0  SAY "02 Inicial"
@ 10, 0  SAY "   Soma   "
@ 11, 0  SAY "   Valores"
@ 12, 0  SAY "   Fechar "
@ 13, 0  SAY "03 Inicial"
@ 14, 0  SAY "   Soma   "
@ 15, 0  SAY "   Valores"
@ 16, 0  SAY "   Fechar "
@ 17, 0  SAY "04 Inicial"
@ 18, 0  SAY "   Soma   "
@ 19, 0  SAY "   Valores"
@ 20, 0  SAY "   Fechar "
@ 21, 0  SAY "05 Inicial"
@ 22, 0  SAY "   Soma   "
@ 23, 0  SAY "   Valores"
@ 24, 0  SAY "   Fechar "
@  5, 12 GET mVI01        PICT "@S60"
@  6, 12 GET mFS01        PICT "@S60"
@  7, 12 GET mFVAL01      PICT "@S60"
@  8, 12 GET mFFIN01      PICT "@S60"
@  9, 12 GET mVI02        PICT "@S60"
@ 10, 12 GET mFS02        PICT "@S60"
@ 11, 12 GET mFVAL02      PICT "@S60"
@ 12, 12 GET mFFIN02      PICT "@S60"
@ 13, 12 GET mVI03        PICT "@S60"
@ 14, 12 GET mFS03        PICT "@S60"
@ 15, 12 GET mFVAL03      PICT "@S60"
@ 16, 12 GET mFFIN03      PICT "@S60"
@ 17, 12 GET mVI04        PICT "@S60"
@ 18, 12 GET mFS04        PICT "@S60"
@ 19, 12 GET mFVAL04      PICT "@S60"
@ 20, 12 GET mFFIN04      PICT "@S60"
@ 21, 12 GET mVI05        PICT "@S60"
@ 22, 12 GET mFS05        PICT "@S60"
@ 23, 12 GET mFVAL05      PICT "@S60"
@ 24, 12 GET mFFIN05      PICT "@S60"
READCUR()


@  5, 00 CLEAR
@  5, 0  SAY "06 Inicial"
@  6, 0  SAY "   Soma   "
@  7, 0  SAY "   Valores"
@  8, 0  SAY "   Fechar "
@  9, 0  SAY "07 Inicial"
@ 10, 0  SAY "   Soma   "
@ 11, 0  SAY "   Valores"
@ 12, 0  SAY "   Fechar "
@ 13, 0  SAY "08 Inicial"
@ 14, 0  SAY "   Soma   "
@ 15, 0  SAY "   Valores"
@ 16, 0  SAY "   Fechar "
@ 17, 0  SAY "09 Inicial"
@ 18, 0  SAY "   Soma   "
@ 19, 0  SAY "   Valores"
@ 20, 0  SAY "   Fechar "
@ 21, 0  SAY "10 Inicial"
@ 22, 0  SAY "   Soma   "
@ 23, 0  SAY "   Valores"
@ 24, 0  SAY "   Fechar "
@  5, 12 GET mVI06        PICT "@S60"
@  6, 12 GET mFS06        PICT "@S60"
@  7, 12 GET mFVAL06      PICT "@S60"
@  8, 12 GET mFFIN06      PICT "@S60"
@  9, 12 GET mVI07        PICT "@S60"
@ 10, 12 GET mFS07        PICT "@S60"
@ 11, 12 GET mFVAL07      PICT "@S60"
@ 12, 12 GET mFFIN07      PICT "@S60"
@ 13, 12 GET mVI08        PICT "@S60"
@ 14, 12 GET mFS08        PICT "@S60"
@ 15, 12 GET mFVAL08      PICT "@S60"
@ 16, 12 GET mFFIN08      PICT "@S60"
@ 17, 12 GET mVI09        PICT "@S60"
@ 18, 12 GET mFS09        PICT "@S60"
@ 19, 12 GET mFVAL09      PICT "@S60"
@ 20, 12 GET mFFIN09      PICT "@S60"
@ 21, 12 GET mVI10        PICT "@S60"
@ 22, 12 GET mFS10        PICT "@S60"
@ 23, 12 GET mFVAL10      PICT "@S60"
@ 24, 12 GET mFFIN10      PICT "@S60"
READCUR()

@  5, 00 CLEAR
@  5, 0  SAY "11 Inicial"
@  6, 0  SAY "   Soma   "
@  7, 0  SAY "   Valores"
@  8, 0  SAY "   Fechar "
@  9, 0  SAY "12 Inicial"
@ 10, 0  SAY "   Soma   "
@ 11, 0  SAY "   Valores"
@ 12, 0  SAY "   Fechar "
@ 13, 0  SAY "13 Inicial"
@ 14, 0  SAY "   Soma   "
@ 15, 0  SAY "   Valores"
@ 16, 0  SAY "   Fechar "
@ 17, 0  SAY "14 Inicial"
@ 18, 0  SAY "   Soma   "
@ 19, 0  SAY "   Valores"
@ 20, 0  SAY "   Fechar "
@ 21, 0  SAY "15 Inicial"
@ 22, 0  SAY "   Soma   "
@ 23, 0  SAY "   Valores"
@ 24, 0  SAY "   Fechar "
@  5, 12 GET mVI11        PICT "@S60"
@  6, 12 GET mFS11        PICT "@S60"
@  7, 12 GET mFVAL11      PICT "@S60"
@  8, 12 GET mFFIN11      PICT "@S60"
@  9, 12 GET mVI12        PICT "@S60"
@ 10, 12 GET mFS12        PICT "@S60"
@ 11, 12 GET mFVAL12      PICT "@S60"
@ 12, 12 GET mFFIN12      PICT "@S60"
@ 13, 12 GET mVI13        PICT "@S60"
@ 14, 12 GET mFS13        PICT "@S60"
@ 15, 12 GET mFVAL13      PICT "@S60"
@ 16, 12 GET mFFIN13      PICT "@S60"
@ 17, 12 GET mVI14        PICT "@S60"
@ 18, 12 GET mFS14        PICT "@S60"
@ 19, 12 GET mFVAL14      PICT "@S60"
@ 20, 12 GET mFFIN14      PICT "@S60"
@ 21, 12 GET mVI15        PICT "@S60"
@ 22, 12 GET mFS15        PICT "@S60"
@ 23, 12 GET mFVAL15      PICT "@S60"
@ 24, 12 GET mFFIN15      PICT "@S60"
READCUR()

@  5, 00 CLEAR
@  5, 0  SAY "16 Inicial"
@  6, 0  SAY "   Soma   "
@  7, 0  SAY "   Valores"
@  8, 0  SAY "   Fechar "
@  9, 0  SAY "17 Inicial"
@ 10, 0  SAY "   Soma   "
@ 11, 0  SAY "   Valores"
@ 12, 0  SAY "   Fechar "
@ 13, 0  SAY "18 Inicial"
@ 14, 0  SAY "   Soma   "
@ 15, 0  SAY "   Valores"
@ 16, 0  SAY "   Fechar "
@ 17, 0  SAY "19 Inicial"
@ 18, 0  SAY "   Soma   "
@ 19, 0  SAY "   Valores"
@ 20, 0  SAY "   Fechar "
@ 21, 0  SAY "20 Inicial"
@ 22, 0  SAY "   Soma   "
@ 23, 0  SAY "   Valores"
@ 24, 0  SAY "   Fechar "
@  5, 12 GET mVI16        PICT "@S60"
@  6, 12 GET mFS16        PICT "@S60"
@  7, 12 GET mFVAL16      PICT "@S60"
@  8, 12 GET mFFIN16      PICT "@S60"
@  9, 12 GET mVI17        PICT "@S60"
@ 10, 12 GET mFS17        PICT "@S60"
@ 11, 12 GET mFVAL17      PICT "@S60"
@ 12, 12 GET mFFIN17      PICT "@S60"
@ 13, 12 GET mVI18        PICT "@S60"
@ 14, 12 GET mFS18        PICT "@S60"
@ 15, 12 GET mFVAL18      PICT "@S60"
@ 16, 12 GET mFFIN18      PICT "@S60"
@ 17, 12 GET mVI19        PICT "@S60"
@ 18, 12 GET mFS19        PICT "@S60"
@ 19, 12 GET mFVAL19      PICT "@S60"
@ 20, 12 GET mFFIN19      PICT "@S60"
@ 21, 12 GET mVI20        PICT "@S60"
@ 22, 12 GET mFS20        PICT "@S60"
@ 23, 12 GET mFVAL20      PICT "@S60"
@ 24, 12 GET mFFIN20      PICT "@S60"
READCUR()


@  5, 00 CLEAR
@  5, 0  SAY "21 Inicial"
@  6, 0  SAY "   Soma   "
@  7, 0  SAY "   Valores"
@  8, 0  SAY "   Fechar "
@  9, 0  SAY "22 Inicial"
@ 10, 0  SAY "   Soma   "
@ 11, 0  SAY "   Valores"
@ 12, 0  SAY "   Fechar "
@ 13, 0  SAY "23 Inicial"
@ 14, 0  SAY "   Soma   "
@ 15, 0  SAY "   Valores"
@ 16, 0  SAY "   Fechar "
@ 17, 0  SAY "24 Inicial"
@ 18, 0  SAY "   Soma   "
@ 19, 0  SAY "   Valores"
@ 20, 0  SAY "   Fechar "
@ 22, 0  SAY " FecharBco"
@  5, 12 GET mVI21        PICT "@S60"
@  6, 12 GET mFS21        PICT "@S60"
@  7, 12 GET mFVAL21      PICT "@S60"
@  8, 12 GET mFFIN21      PICT "@S60"
@  9, 12 GET mVI22        PICT "@S60"
@ 10, 12 GET mFS22        PICT "@S60"
@ 11, 12 GET mFVAL22      PICT "@S60"
@ 12, 12 GET mFFIN22      PICT "@S60"
@ 13, 12 GET mVI23        PICT "@S60"
@ 14, 12 GET mFS23        PICT "@S60"
@ 15, 12 GET mFVAL23      PICT "@S60"
@ 16, 12 GET mFFIN23      PICT "@S60"
@ 17, 12 GET mVI24        PICT "@S60"
@ 18, 12 GET mFS24        PICT "@S60"
@ 19, 12 GET mFVAL24      PICT "@S60"
@ 20, 12 GET mFFIN24      PICT "@S60"
@ 22, 12 GET mBCOFT       PICT "@S60"
READCUR()


dbSelectAr( "FOPTOCON" )
replvars()

dbSelectAr( "FOPTOBCO" )
replvars()

dbSelectAr( "FOPTOVAL" )
replvars()


dbCloseAll()

   RETURN


// + EOF: fopto_45.prg
// +
