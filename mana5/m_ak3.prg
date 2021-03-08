*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ak3.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :   M_AK3  .PRG :
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMAK3()
// :
// :    Chamado por:
// :
// :          Chama: fMAK3  (fun‡„o em M_AK3.PRG )
// :
// :  Arq. Dados   : MK03       -
// :
// :  Indices      : MK03-1     - Mes e Ano
// :                 STR(NRNOTA,8)+STR(FORNECEDO,5)+DTOS(DATA)+CODIGO+STR(ANO)+STR(MES)
// :
// :
// :  Documentado em: Junh 9, 1995 as 16:47:08                DISK!  vers„o 5.01
// :*****************************************************************************


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

nGMAK3 := 0
PADRAO(1,1,0,"MK03","N§ Nota  Data     Forn. C¢digo"+spac(6)+"Mˆs/Ano Valor",;
 "' '+STR(mNRNOTA,  8)+' '+DTOC(mDATA)+' '+STR(mFORNECEDO,  5)+' '+mCODIGO+' '+STR(mMES,2)+' '+STR(mANO,4)+' '+STR(mVALORMES, 12, 2)+' '+mCONTA",;
 "MAK3",,,,{|| MAK3ARR()},,,,.F.)





*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAK3ARR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAK3ARR

//Carregando Matriz
IF cVIDE = "S"
   nIND := IF(lPIND,NUMIND("MK03"),nIEXI)
   IF !USEREDE("MK03",1,nIND)
      RETU
   ENDIF
   GRAF  := LASTREC()
   xGRAF := 0
   xPOS  := 1
   MARCAR()
   DBGOTOP()
   DBSEEK(STR(mNRNOTA,8)+STR(mFORNECEDO,5)+DTOS(mDATA)+mCODIGO)
   WHILE mNRNOTA = NRNOTA .AND. mFORNECEDO = FORNECEDO .AND. mDATA = DATA .AND. mCODIGO = CODIGO .AND. !EOF()
      AADD(aPAD1,&mCBAR.)
      AADD(aPAD2,&wCHA.)
      AADD(aPAD3,0)
      xPOS ++
      MARCAR1()
      DBSKIP()
   ENDDO
   DBCLOSEAREA()
   IF xPOS = 1
      nMESES := 1
      IF mTIPOENT # "D"
         mCONTA := mCTACONTB
      ELSE
         mCONTA := mCODIGO
      ENDIF
      IF !mdg('Nenhum Lan‡amento Neste Arquivo Deseja Incluir')
         RETU .F.
      ENDIF
      MDS('Quantos Meses  CONTA')
      @ 24,15 GET nMESES         
      IF ZLANC = 0
         @ 24,40 GET mCONTA PICT ZPICCC VALID CHECKCC("mCONTA")       
      ELSE
         @ 24,40 GET mCONTA VALID CHECKCC("mCONTA")        
      ENDIF
      IF !READCUR()
         RETU .F.
      ENDIF
      nMESREF := MONTH(mDATA)
      nANOREF := YEAR(mDATA)
      MDS("Aguarde Distruibuindo")
      FOR X := 1 TO nMESES
         mVALORMES := ROUND(mVALORTOT / nMESES,2)
         mANO      := nANOREF
         mMES      := nMESREF
         mCHAVE    := STR(mNRNOTA,8)+STR(mFORNECEDO,5)+DTOS(mDATA)+PADR(mCODIGO,11)+STR(nANOREF,4)+STR(nMESREF,2)
         NOVOREG("MK03",mCHAVE)
         AADD(aPAD1,&mCBARM.)
         AADD(aPAD2,mCHAVE)
         AADD(aPAD3,0)
         nMESREF ++
         IF nMESREF > 12
            nMESREF := 1
            nANOREF ++
         ENDIF
      NEXT X
      nSBAR := nMESES
   ENDIF
ENDIF
IF EMPTY(mCONTA) .AND. mTIPOENT = "D"
   mCONTA := mCODIGO
ENDIF
IF EMPTY(mCONTA) .AND. mTIPOENT # "D"
   mCONTA := mCTACONTB
ENDIF




