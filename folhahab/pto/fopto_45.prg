*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_45.prg
*+
*+
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
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


CABE2("FOPTO_45 - Contas/Transferia/Formulas")
if !netuse("FOPTOCON")
   return .F.
endif
if !dbseek(nremp)
   netrecapp()
   field->empresa := nremp
else
   netreclock()
endif
initvars()
equvars()

if !netuse("FOPTOBCO")
   dbcloseall()
   return .F.
endif
if !dbseek(nremp)
   netrecapp()
   field->empresa := nremp
else
   netreclock()
endif
initvars()
equvars()

if !netuse("FOPTOVAL")
   dbcloseall()
   return .F.
endif
if !dbseek(nremp)
   netrecapp()
   field->empresa := nremp
else
   netreclock()
endif
initvars()
equvars()


@  5,0  say "Conta 01 Transfere:"                            
@  7,0  say "BCO"                                            
@ 08,0  say "Conta 02 Transfere:"                            
@ 10,0  say "BCO"                                            
@ 11,0  say "Conta 03 Transfere:"                            
@ 13,0  say "BCO"                                            
@ 14,0  say "Conta 04 Transfere:"                            
@ 16,0  say "BCO"                                            
@ 17,0  say "Conta 05 Transfere:"                            
@ 19,0  say "BCO"                                            
@ 20,0  say "Conta 06 Transfere:"                            
@ 22,0  say "BCO"                                            
@ 05,20 get mTR01                 valid mTR01 $ "SN "        
@ 05,25 get mCX01                 PICT "@S50"                
@ 06,05 get mOP01                 PICT "@S70"                
@ 07,05 GET mBCO01                PICT "@S70"                
@ 08,20 get mTR02                 valid mTR02 $ "SN "        
@ 08,25 get mCX02                 PICT "@S50"                
@ 09,05 GET mOP02                 PICT "@S70"                
@ 10,05 GET mBCO02                PICT "@S70"                
@ 11,20 get mTR03                 valid mTR03 $ "SN "        
@ 11,25 get mCX03                 PICT "@S50"                
@ 12,05 GET mOP03                 PICT "@S70"                
@ 13,05 GET mBCO03                PICT "@S70"                
@ 14,20 get mTR04                 valid mTR04 $ "SN "        
@ 14,25 get mCX04                 PICT "@S50"                
@ 15,05 GET mOP04                 PICT "@S70"                
@ 16,05 GET mBCO04                PICT "@S70"                
@ 17,20 get mTR05                 valid mTR05 $ "SN "        
@ 17,25 get mCX05                 PICT "@S50"                
@ 18,05 GET mOP05                 PICT "@S70"                
@ 19,05 GET mBCO05                PICT "@S70"                
@ 20,20 get mTR06                 valid mTR06 $ "SN "        
@ 20,25 get mCX06                 PICT "@S50"                
@ 21,05 GET mOP06                 PICT "@S70"                
@ 22,05 GET mBCO06                PICT "@S70"                
READCUR()

@  5,00 CLEAR
@  5,0  say "Conta 07 Transfere:"                            
@  7,0  say "BCO"                                            
@ 08,0  say "Conta 08 Transfere:"                            
@ 10,0  say "BCO"                                            
@ 11,0  say "Conta 09 Transfere:"                            
@ 13,0  say "BCO"                                            
@ 14,0  say "Conta 10 Transfere:"                            
@ 16,0  say "BCO"                                            
@ 17,0  say "Conta 11 Transfere:"                            
@ 19,0  say "BCO"                                            
@ 20,0  say "Conta 12 Transfere:"                            
@ 22,0  say "BCO"                                            
@ 05,20 get mTR07                 valid mTR07 $ "SN "        
@ 05,25 get mCX07                 PICT "@S50"                
@ 06,05 get mOP07                 PICT "@S70"                
@ 07,05 GET mBCO07                PICT "@S70"                
@ 08,20 get mTR08                 valid mTR08 $ "SN "        
@ 08,25 get mCX08                 PICT "@S50"                
@ 09,05 GET mOP08                 PICT "@S70"                
@ 10,05 GET mBCO08                PICT "@S70"                
@ 11,20 get mTR09                 valid mTR09 $ "SN "        
@ 11,25 get mCX09                 PICT "@S50"                
@ 12,05 GET mOP09                 PICT "@S70"                
@ 13,05 GET mBCO09                PICT "@S70"                
@ 14,20 get mTR10                 valid mTR10 $ "SN "        
@ 14,25 get mCX10                 PICT "@S50"                
@ 15,05 GET mOP10                 PICT "@S70"                
@ 16,05 GET mBCO10                PICT "@S70"                
@ 17,20 get mTR11                 valid mTR11 $ "SN "        
@ 17,25 get mCX11                 PICT "@S50"                
@ 18,05 GET mOP11                 PICT "@S70"                
@ 19,05 GET mBCO11                PICT "@S70"                
@ 20,20 get mTR12                 valid mTR12 $ "SN "        
@ 20,25 get mCX12                 PICT "@S50"                
@ 21,05 GET mOP12                 PICT "@S70"                
@ 22,05 GET mBCO12                PICT "@S70"                
READCUR()

@  5,00 CLEAR
@  5,0  say "Conta 13 Transfere:"                            
@  7,0  say "BCO"                                            
@ 08,0  say "Conta 14 Transfere:"                            
@ 10,0  say "BCO"                                            
@ 11,0  say "Conta 15 Transfere:"                            
@ 13,0  say "BCO"                                            
@ 14,0  say "Conta 16 Transfere:"                            
@ 16,0  say "BCO"                                            
@ 17,0  say "Conta 17 Transfere:"                            
@ 19,0  say "BCO"                                            
@ 20,0  say "Conta 18 Transfere:"                            
@ 22,0  say "BCO"                                            
@ 05,20 get mTR13                 valid mTR13 $ "SN "        
@ 05,25 get mCX13                 PICT "@S50"                
@ 06,05 get mOP13                 PICT "@S70"                
@ 07,05 GET mBCO13                PICT "@S70"                
@ 08,20 get mTR14                 valid mTR14 $ "SN "        
@ 08,25 get mCX14                 PICT "@S50"                
@ 09,05 GET mOP14                 PICT "@S70"                
@ 10,05 GET mBCO14                PICT "@S70"                
@ 11,20 get mTR15                 valid mTR15 $ "SN "        
@ 11,25 get mCX15                 PICT "@S50"                
@ 12,05 GET mOP15                 PICT "@S70"                
@ 13,05 GET mBCO15                PICT "@S70"                
@ 14,20 get mTR16                 valid mTR16 $ "SN "        
@ 14,25 get mCX16                 PICT "@S50"                
@ 15,05 GET mOP16                 PICT "@S70"                
@ 16,05 GET mBCO16                PICT "@S70"                
@ 17,20 get mTR17                 valid mTR17 $ "SN "        
@ 17,25 get mCX17                 PICT "@S50"                
@ 18,05 GET mOP17                 PICT "@S70"                
@ 19,05 GET mBCO17                PICT "@S70"                
@ 20,20 get mTR18                 valid mTR18 $ "SN "        
@ 20,25 get mCX18                 PICT "@S50"                
@ 21,05 GET mOP18                 PICT "@S70"                
@ 22,05 GET mBCO18                PICT "@S70"                
READCUR()

@  5,00 CLEAR
@  5,0  say "Conta 19 Transfere:"                            
@  7,0  say "BCO"                                            
@ 08,0  say "Conta 20 Transfere:"                            
@ 10,0  say "BCO"                                            
@ 11,0  say "Conta 21 Transfere:"                            
@ 13,0  say "BCO"                                            
@ 14,0  say "Conta 22 Transfere:"                            
@ 16,0  say "BCO"                                            
@ 17,0  say "Conta 23 Transfere:"                            
@ 19,0  say "BCO"                                            
@ 20,0  say "Conta 24 Transfere:"                            
@ 22,0  say "BCO"                                            
@ 23,0  SAY "BOCHR"                                          
@ 24,0  SAY "BOCTT"                                          
@ 05,20 get mTR19                 valid mTR19 $ "SN "        
@ 05,25 get mCX19                 PICT "@S50"                
@ 06,05 get mOP19                 PICT "@S70"                
@ 07,05 GET mBCO19                PICT "@S70"                
@ 08,20 get mTR20                 valid mTR20 $ "SN "        
@ 08,25 get mCX20                 PICT "@S50"                
@ 09,05 GET mOP20                 PICT "@S70"                
@ 10,05 GET mBCO20                PICT "@S70"                
@ 11,20 get mTR21                 valid mTR21 $ "SN "        
@ 11,25 get mCX21                 PICT "@S50"                
@ 12,05 GET mOP21                 PICT "@S70"                
@ 13,05 GET mBCO21                PICT "@S70"                
@ 14,20 get mTR22                 valid mTR22 $ "SN "        
@ 14,25 get mCX22                 PICT "@S50"                
@ 15,05 GET mOP22                 PICT "@S70"                
@ 16,05 GET mBCO22                PICT "@S70"                
@ 17,20 get mTR23                 valid mTR23 $ "SN "        
@ 17,25 get mCX23                 PICT "@S50"                
@ 18,05 GET mOP23                 PICT "@S70"                
@ 19,05 GET mBCO23                PICT "@S70"                
@ 20,20 get mTR24                 valid mTR24 $ "SN "        
@ 20,25 get mCX24                 PICT "@S50"                
@ 21,05 GET mOP24                 PICT "@S70"                
@ 22,05 GET mBCO24                PICT "@S70"                
@ 23,6  GET mBCOHR                PICT "@S70"                
@ 24,6  GET mBCOTT                PICT "@S70"                
READCUR()


@  5,00 CLEAR
@  5,0  say "01 Inicial"                    
@  6,0  say "   Soma   "                    
@  7,0  say "   Valores"                    
@  8,0  say "   Fechar "                    
@  9,0  say "02 Inicial"                    
@ 10,0  say "   Soma   "                    
@ 11,0  say "   Valores"                    
@ 12,0  say "   Fechar "                    
@ 13,0  say "03 Inicial"                    
@ 14,0  say "   Soma   "                    
@ 15,0  say "   Valores"                    
@ 16,0  say "   Fechar "                    
@ 17,0  say "04 Inicial"                    
@ 18,0  say "   Soma   "                    
@ 19,0  say "   Valores"                    
@ 20,0  say "   Fechar "                    
@ 21,0  say "05 Inicial"                    
@ 22,0  say "   Soma   "                    
@ 23,0  say "   Valores"                    
@ 24,0  say "   Fechar "                    
@  5,12 GET mVI01        PICT "@S60"        
@  6,12 GET mFS01        PICT "@S60"        
@  7,12 GET mFVAL01      PICT "@S60"        
@  8,12 GET mFFIN01      PICT "@S60"        
@  9,12 GET mVI02        PICT "@S60"        
@ 10,12 GET mFS02        PICT "@S60"        
@ 11,12 GET mFVAL02      PICT "@S60"        
@ 12,12 GET mFFIN02      PICT "@S60"        
@ 13,12 GET mVI03        PICT "@S60"        
@ 14,12 GET mFS03        PICT "@S60"        
@ 15,12 GET mFVAL03      PICT "@S60"        
@ 16,12 GET mFFIN03      PICT "@S60"        
@ 17,12 GET mVI04        PICT "@S60"        
@ 18,12 GET mFS04        PICT "@S60"        
@ 19,12 GET mFVAL04      PICT "@S60"        
@ 20,12 GET mFFIN04      PICT "@S60"        
@ 21,12 GET mVI05        PICT "@S60"        
@ 22,12 GET mFS05        PICT "@S60"        
@ 23,12 GET mFVAL05      PICT "@S60"        
@ 24,12 GET mFFIN05      PICT "@S60"        
READCUR()


@  5,00 CLEAR
@  5,0  say "06 Inicial"                    
@  6,0  say "   Soma   "                    
@  7,0  say "   Valores"                    
@  8,0  say "   Fechar "                    
@  9,0  say "07 Inicial"                    
@ 10,0  say "   Soma   "                    
@ 11,0  say "   Valores"                    
@ 12,0  say "   Fechar "                    
@ 13,0  say "08 Inicial"                    
@ 14,0  say "   Soma   "                    
@ 15,0  say "   Valores"                    
@ 16,0  say "   Fechar "                    
@ 17,0  say "09 Inicial"                    
@ 18,0  say "   Soma   "                    
@ 19,0  say "   Valores"                    
@ 20,0  say "   Fechar "                    
@ 21,0  say "10 Inicial"                    
@ 22,0  say "   Soma   "                    
@ 23,0  say "   Valores"                    
@ 24,0  say "   Fechar "                    
@  5,12 GET mVI06        PICT "@S60"        
@  6,12 GET mFS06        PICT "@S60"        
@  7,12 GET mFVAL06      PICT "@S60"        
@  8,12 GET mFFIN06      PICT "@S60"        
@  9,12 GET mVI07        PICT "@S60"        
@ 10,12 GET mFS07        PICT "@S60"        
@ 11,12 GET mFVAL07      PICT "@S60"        
@ 12,12 GET mFFIN07      PICT "@S60"        
@ 13,12 GET mVI08        PICT "@S60"        
@ 14,12 GET mFS08        PICT "@S60"        
@ 15,12 GET mFVAL08      PICT "@S60"        
@ 16,12 GET mFFIN08      PICT "@S60"        
@ 17,12 GET mVI09        PICT "@S60"        
@ 18,12 GET mFS09        PICT "@S60"        
@ 19,12 GET mFVAL09      PICT "@S60"        
@ 20,12 GET mFFIN09      PICT "@S60"        
@ 21,12 GET mVI10        PICT "@S60"        
@ 22,12 GET mFS10        PICT "@S60"        
@ 23,12 GET mFVAL10      PICT "@S60"        
@ 24,12 GET mFFIN10      PICT "@S60"        
READCUR()

@  5,00 CLEAR
@  5,0  say "11 Inicial"                    
@  6,0  say "   Soma   "                    
@  7,0  say "   Valores"                    
@  8,0  say "   Fechar "                    
@  9,0  say "12 Inicial"                    
@ 10,0  say "   Soma   "                    
@ 11,0  say "   Valores"                    
@ 12,0  say "   Fechar "                    
@ 13,0  say "13 Inicial"                    
@ 14,0  say "   Soma   "                    
@ 15,0  say "   Valores"                    
@ 16,0  say "   Fechar "                    
@ 17,0  say "14 Inicial"                    
@ 18,0  say "   Soma   "                    
@ 19,0  say "   Valores"                    
@ 20,0  say "   Fechar "                    
@ 21,0  say "15 Inicial"                    
@ 22,0  say "   Soma   "                    
@ 23,0  say "   Valores"                    
@ 24,0  say "   Fechar "                    
@  5,12 GET mVI11        PICT "@S60"        
@  6,12 GET mFS11        PICT "@S60"        
@  7,12 GET mFVAL11      PICT "@S60"        
@  8,12 GET mFFIN11      PICT "@S60"        
@  9,12 GET mVI12        PICT "@S60"        
@ 10,12 GET mFS12        PICT "@S60"        
@ 11,12 GET mFVAL12      PICT "@S60"        
@ 12,12 GET mFFIN12      PICT "@S60"        
@ 13,12 GET mVI13        PICT "@S60"        
@ 14,12 GET mFS13        PICT "@S60"        
@ 15,12 GET mFVAL13      PICT "@S60"        
@ 16,12 GET mFFIN13      PICT "@S60"        
@ 17,12 GET mVI14        PICT "@S60"        
@ 18,12 GET mFS14        PICT "@S60"        
@ 19,12 GET mFVAL14      PICT "@S60"        
@ 20,12 GET mFFIN14      PICT "@S60"        
@ 21,12 GET mVI15        PICT "@S60"        
@ 22,12 GET mFS15        PICT "@S60"        
@ 23,12 GET mFVAL15      PICT "@S60"        
@ 24,12 GET mFFIN15      PICT "@S60"        
READCUR()

@  5,00 CLEAR
@  5,0  say "16 Inicial"                    
@  6,0  say "   Soma   "                    
@  7,0  say "   Valores"                    
@  8,0  say "   Fechar "                    
@  9,0  say "17 Inicial"                    
@ 10,0  say "   Soma   "                    
@ 11,0  say "   Valores"                    
@ 12,0  say "   Fechar "                    
@ 13,0  say "18 Inicial"                    
@ 14,0  say "   Soma   "                    
@ 15,0  say "   Valores"                    
@ 16,0  say "   Fechar "                    
@ 17,0  say "19 Inicial"                    
@ 18,0  say "   Soma   "                    
@ 19,0  say "   Valores"                    
@ 20,0  say "   Fechar "                    
@ 21,0  say "20 Inicial"                    
@ 22,0  say "   Soma   "                    
@ 23,0  say "   Valores"                    
@ 24,0  say "   Fechar "                    
@  5,12 GET mVI16        PICT "@S60"        
@  6,12 GET mFS16        PICT "@S60"        
@  7,12 GET mFVAL16      PICT "@S60"        
@  8,12 GET mFFIN16      PICT "@S60"        
@  9,12 GET mVI17        PICT "@S60"        
@ 10,12 GET mFS17        PICT "@S60"        
@ 11,12 GET mFVAL17      PICT "@S60"        
@ 12,12 GET mFFIN17      PICT "@S60"        
@ 13,12 GET mVI18        PICT "@S60"        
@ 14,12 GET mFS18        PICT "@S60"        
@ 15,12 GET mFVAL18      PICT "@S60"        
@ 16,12 GET mFFIN18      PICT "@S60"        
@ 17,12 GET mVI19        PICT "@S60"        
@ 18,12 GET mFS19        PICT "@S60"        
@ 19,12 GET mFVAL19      PICT "@S60"        
@ 20,12 GET mFFIN19      PICT "@S60"        
@ 21,12 GET mVI20        PICT "@S60"        
@ 22,12 GET mFS20        PICT "@S60"        
@ 23,12 GET mFVAL20      PICT "@S60"        
@ 24,12 GET mFFIN20      PICT "@S60"        
READCUR()


@  5,00 CLEAR
@  5,0  say "21 Inicial"                    
@  6,0  say "   Soma   "                    
@  7,0  say "   Valores"                    
@  8,0  say "   Fechar "                    
@  9,0  say "22 Inicial"                    
@ 10,0  say "   Soma   "                    
@ 11,0  say "   Valores"                    
@ 12,0  say "   Fechar "                    
@ 13,0  say "23 Inicial"                    
@ 14,0  say "   Soma   "                    
@ 15,0  say "   Valores"                    
@ 16,0  say "   Fechar "                    
@ 17,0  say "24 Inicial"                    
@ 18,0  say "   Soma   "                    
@ 19,0  say "   Valores"                    
@ 20,0  say "   Fechar "                    
@ 22,0  say " FecharBco"                    
@  5,12 GET mVI21        PICT "@S60"        
@  6,12 GET mFS21        PICT "@S60"        
@  7,12 GET mFVAL21      PICT "@S60"        
@  8,12 GET mFFIN21      PICT "@S60"        
@  9,12 GET mVI22        PICT "@S60"        
@ 10,12 GET mFS22        PICT "@S60"        
@ 11,12 GET mFVAL22      PICT "@S60"        
@ 12,12 GET mFFIN22      PICT "@S60"        
@ 13,12 GET mVI23        PICT "@S60"        
@ 14,12 GET mFS23        PICT "@S60"        
@ 15,12 GET mFVAL23      PICT "@S60"        
@ 16,12 GET mFFIN23      PICT "@S60"        
@ 17,12 GET mVI24        PICT "@S60"        
@ 18,12 GET mFS24        PICT "@S60"        
@ 19,12 GET mFVAL24      PICT "@S60"        
@ 20,12 GET mFFIN24      PICT "@S60"        
@ 22,12 GET mBCOFT       PICT "@S60"        
READCUR()


dbselectar("FOPTOCON")
replvars()

dbselectar("FOPTOBCO")
replvars()

dbselectar("FOPTOVAL")
replvars()


dbcloseall()

return


*+ EOF: fopto_45.prg
*+
