*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_du.prg
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
// :   M_AS2  .PRG : Lista de Precos - Reajuste
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5/ITAESBRA
// :          Autor: Equipe Disk
// :      Copyright (c) 1994, Disk Soft S/C Ltda.
// :
// :*****************************************************************************


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


//Modo de Trabalho no Video
MDI(" Ý Reajuste de Pre‡os ")

//Prepara Variaveis
DATAREF  := DATADES := ZDATA
nFATOR   := 1.0000
QTDETAB  := 20
CLILISTA := 0


// Desenha a Tela
HB_DISPBOX(2,0,23,79,B_DOUBLE)
@  8,17 SAY "Data de Referencia"+spac(17)+":"              
@ 10,17 SAY "Data Destino"+spac(23)+":"                    
@ 12,17 SAY "Fator de  Reajuste"+spac(15)+":"              
@ 14,17 SAY "Quantidade de Pre‡os a armazenar   :"         
@ 15,17 SAY "Cliente Lista"                                
// Get nas Menvars
@  8,55 GET DATAREF          
@ 10,55 GET DATADES          
@ 12,55 GET nFATOR           
@ 14,55 GET QTDETAB          
@ 15,55 GET CliLista         
IF !READCUR()
   RETU .F.
ENDIF
IF nFATOR = 0
   ALERTX("Fator em Branco")
   RETU .F.
ENDIF
IF !MDG("Iniciar Calculo")
   RETU .F.
ENDIF

FILTRO := ""
FILTRO := RFILORD("MS01",.F.)

CRIARVARS("MS01")
CRIARVARS("MS02")


IF !USEMULT({{"MS01",1,2},{"MS02",0,99}})
   RETU .F.
ENDIF


MDS("Checando Pre‡os sem produtos")
DBSELECTAR("MS02")
DBGOTOP()
WHILE !EOF()
   mCHAVE := CODIGO
   DBSELECTAR("MS01")
   DBGOTOP()
   lEXISTE := DBSEEK(mCHAVE)
   DBSELECTAR("MS02")
   IF !lEXISTE
      @ 20,30 SAY mCHAVE         
      DELEREG(,,.F.,.F.)
   ENDIF
   DBSKIP()
ENDDO

DBSELECTAR("MS02")
DBSETORDER(5)   //Codigo Fornecedo Data

DBSELECTAR("MS01")
IF !EMPTY(FILTRO)
   SET FILTER TO &FILTRO
ENDIF
DBGOTOP()
WHILE !EOF()
   @ 24,00 SAY CODIGO         
   mCODIGO := CODIGO
   DBSELECTAR("MS02")
   DBSEEK(mCODIGO)
   WHILE mCODIGO = CODIGO .AND. !EOF()
      mFORNECEDO := FORNECEDO
      WHILE mCODIGO = CODIGO .AND. mFORNECEDO = FORNECEDO .AND. !EOF()
         IF DATAREF = DATA .AND. FORNECEDO = CLILISTA
            EQUVARS()
            NETGRVCAM("ATUAL","N")
            REG    := RECNO()
            mCHAVE := mCODIGO+STR(mFORNECEDO,5)+DTOS(DATADES)
            mDATA  := DATADES
            mVALOR := mVALOR * nFATOR
            NOVOOPE(,mCHAVE)
            DBGOTO(REG)
         ENDIF
         DBSELECTAR("MS02")
         DBSKIP()
      ENDDO
   ENDDO
   DBSELECTAR("MS01")
   DBSKIP()
ENDDO


DBSELECTAR("MS01")
DBGOTOP()
WHILE !EOF()
   @ 24,00 SAY CODIGO         
   mCODIGO := CODIGO
   DBSELECTAR("MS02")
   DBSEEK(mCODIGO)
   WHILE mCODIGO = CODIGO .AND. !EOF()
      mFORNECEDO := FORNECEDO
      nQTDDE     := 0
      nREGINI    := RECNO()
      WHILE mCODIGO = CODIGO .AND. mFORNECEDO = FORNECEDO .AND. !EOF()
         nQTDDE ++
         DBSELECTAR("MS02")
         DBSKIP()
      ENDDO
      IF nQTDDE > QTDETAB
         nDIF := nQTDDE - QTDETAB
         DBGOTO(nREGINI)
         WHILE mCODIGO = CODIGO .AND. mFORNECEDO = FORNECEDO .AND. !EOF()
            IF nDIF > 0
               DELEREG(,,.F.,.F.)
               nDIF --
            ENDIF
            DBSKIP()
         ENDDO
      ENDIF
   ENDDO
   DBSELECTAR("MS01")
   DBSKIP()
ENDDO



MDS("Aguarde Fixando o Arquivo")
DBSELECTAR("MS02")
PACK
DBCLOSEALL()

MAOITA01()
