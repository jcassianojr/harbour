*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ad.prg
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
// :   M_AD   .PRG : Cadastro de Tabelas e Indices de Corre‡„o
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMAD()
// :
// :    Chamado por:
// :
// :          Chama: fMAD  (fun‡„o em M_AD.PRG )
// :
// :  Arq. Dados   : MD01       - Cadastro de Tabelas e Indices de Corre‡„o
// :
// :  Indices      : MD01-1     - Por C¢digo de Cadastramento
// :                 CODIGO
// :
// :
// :  Documentado em: Mai 27, 1994 as 11:35:51                DISK!  vers„o 5.01
// :*****************************************************************************

//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_ad()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_ad

PARA eFILTRO

PADRAX(0,,0,{"MD01","MD02"},"C¢digo"+spac(7)+"Nome"+spac(34)+"Tipo",;
 "' '+mCODIGO+' '+mNOME+' '+mTIPO","MAD001",;
 "MAD001",,{|| PADDEL("MD02",xCHAVE,"CODIGO","xCHAVE")},{|| MADPOS()},,"MAD",;
 ,,,,,eFILTRO)



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MADPOS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MADPOS

IF MDG("Deseja Alterar Itens da Tabela")
   xCODIGO := mCODIGO
   xNOME   := mNOME
   xTIPO   := mTIPO
   DO CASE
      CASE xCODIGO = "IPI"
         PADRAO(0,1,0,"MD03","N. Classifica‡„o  Descri‡„o"+spac(42)+"%  %R",;
          "' '+mCODIGO+' '+mCLASSIFIC+' '+mDESCRICAO+' '+STR(mALIQUOTA,  2)+' '+STR(mALIQUOTAR,  2)","MAD3")
      CASE xCODIGO = "CFO"
         PADRAO(0,1,0,"MD04","CFO Descri‡„o do C¢digo Fiscal de Opera‡„o",;
          "' '+mCFO+' '+mCFONEW+' '+SUBSTR(mDESCRICAO,1,50)","MAD4")
      CASE xCODIGO = "ICMS" 
         M_AD5(0)
      CASE xCODIGO = "UFESP"
         PADRAO(0,1,0,"MD06","Coloque os Indices di rios","STR(mMES,2)+' '+STR(mANO,4)","MAD6")
      CASE xCODIGO = "UNIDADE"
         PADRAO(0,1,0,"MD07","Un Descri‡„o da Unidade de Medidas"+spac(29)+"DC",;
          "' '+mUNIDADE+' '+mUNIDDES+' '+mUNIDDEC","MAD7")
      CASE xCODIGO = "SEDEX"
         PADRAO(0,1,0,"MD08","T KILO","' '+mSEDEXT+' '+STR(mKILO,2)","MAD8")
      CASE xCODIGO = "FERIADOS"
         PADRAO(0,1,0,"MANFER","Dia/Mes Descri‡„o","' '+STR(mDIA)+' '+STR(mMES)+' '+mDESCRICAO","MADD")
      CASE xCODIGO = "RAMO"
         PADRAO(0,1,0,"MD09","C¢digo Descri‡„o","' '+mCODIGO+' '+mDESCRICAO","MAD9")
      CASE xCODIGO = "CIDADES" 
         M_AD5(0)
      CASE xCODIGO = "MD11" 
         PADRAO(0,1,0,"MD11","CEP","' '+CEP","MADC")
      CASE xCODIGO = "MDPRE" 
         PADRAO(0,1,0,"MDPRE","DDD  Pref Tipo"+spac(9)+"UF Cidade","' '+mDDD+' '+mPREFIXO+' '+mTIPOT+' '+mESTADO+' '+mCIDADE","MADE")
      CASE xTIPO = "R"
         ARQWORK := ALLTRIM(xCODIGO)
         PADRAO(0,1,0,ARQWORK,"Rua"+spac(47)+"Cep     P/I Numera‡„o",;
          "' '+LEFT(mRUA,50)+' '+mCEP+' '+mLADO+' '+STR(mNINI,5)+' '+STR(mNFIM,5)","MADB")
      OTHERWISE 
         nREG := 1
         M_AD2(1)
   ENDCASE
   mCODIGO := xCODIGO
   mNOME   := xNOME
   mTIPO   := xTIPO
ENDIF
RETU .T.
