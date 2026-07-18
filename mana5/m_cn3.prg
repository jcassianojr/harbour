// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cn3.prg
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
// :   M_CN3  .PRG :
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :
// :  Procs & Fncts: fMCN3()
// :
// :    Chamado por:
// :
// :          Chama: fMCN3  (fun‡„o em M_CN3.PRG )
// :
// :  Arq. Dados   : ARQRE1     -
// :
// :  Indices      : ARQRE1-1   - Arquivo Sequencia Coluna
// :                 MENU+CODIGO+STR(ARQUIVO)+STR(SEQUENCIA)+STR(COLUNA)
// :
// :
// :  Documentado em:  16, 1994 as 14:58:11                DISK!  vers„o 5.01
// :*****************************************************************************

// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"


PADRAO( 1, 1, 0, ARQRE1, "T Seq Es Col Dizeres" + spac( 54 ) + "Arq", ;
      "' '+mTIPO+' '+STR(mSEQUENCIA,3)+' '+STR(mESPACEJAR,2)+' '+STR(mCOLUNA,3)+' '+LEFT(mCONTEUDO,60)+' '+STR(mARQUIVO,3)", ;
      "MCN3", "MCN301", {|| gMCN3() }, ;
      , {|| PADARR( ARQRE1, mMENU1 + mCODIGO1, "CODIGO", "mCODIGO1" ) },,,, .F. )





// Get Nas Mvars


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMCN3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gMCN3

   SetColor( CORPAD[ 2 ] )
   @ 20, 1  GET mTIPO      PICT "!"    VALID mTIPO $ "HDFORT"
   @ 20, 3  GET mSEQUENCIA PICT '999'
   @ 20, 7  GET mESPACEJAR PICT '99'   VALID ESP()
   @ 20, 10 GET mCOLUNA    PICT '999'
   @ 20, 14 GET mCONTEUDO  PICT "@S60"
   @ 20, 75 GET mARQUIVO   PICT '999'
   READCUR()
   mSEQU := mSEQUENCIA
   @ 24, 00
   @ 24, 02 SAY 'Mascara : ' GET mMASCARA
   READCUR()
   @ 24, 00
   @ 24, 02 SAY 'Mascara : ' + mMASCARA

   IF mTIPO $ 'DO'
      @ 13, 29 CLEAR TO 16, 53
      @ 13, 29 TO 16, 53 DOUBLE
      OPCAO4 := 2
      IF mTOTALIZA
         OPCAO4 := 1
      ENDIF
      OPCAO( 14, 31, '     &Com Total       ', 67 )
      OPCAO( 15, 31, '     &Sem Total       ', 83 )
      OPCAO4 := MENU( OPCAO4, 0 )
      TOT    := .F.
      IF OPCAO4 = 1
         TOT := .T.
         @ 10, 29 CLEAR TO 16, 53
         @ 10, 29 TO 16, 53 DOUBLE
         @ 10, 34 SAY 'Totaliza pela:'
         OPCAO4 := mQUEBRAR
         IF mQUEBRAR = 0
            OPCAO4 := 1
         ENDIF
         OPCAO( 11, 31, '     &1¦ Quebra       ', 49 )
         OPCAO( 12, 31, '     &2¦ Quebra       ', 50 )
         OPCAO( 13, 31, '     &3¦ Quebra       ', 51 )
         OPCAO( 14, 31, '     &4¦ Quebra       ', 52 )
         OPCAO( 15, 31, '     &5¦ Quebra       ', 53 )
         OPCAO4 := MENU( OPCAO4, 0 )
         IF OPCAO4 > 0
            mQUEBRAR := OPCAO4
         ELSE
            mQUEBRAR := 0
         ENDIF
      ELSE
         mQUEBRAR := 0
      ENDIF
      mTOTALIZA := TOT
   ELSEIF mTIPO = 'T'
      @ 10, 29 CLEAR TO 16, 53
      @ 10, 29 TO 16, 53 DOUBLE
      @ 10, 34 SAY 'Totaliza pela:'
      OPCAO4 := mQUEBRAR
      IF mQUEBRAR = 0
         OPCAO4 := 1
      ENDIF
      OPCAO( 11, 31, '     &1¦ Quebra       ', 49 )
      OPCAO( 12, 31, '     &2¦ Quebra       ', 50 )
      OPCAO( 13, 31, '     &3¦ Quebra       ', 51 )
      OPCAO( 14, 31, '     &4¦ Quebra       ', 52 )
      OPCAO( 15, 31, '     &5¦ Quebra       ', 53 )
      OPCAO4 := MENU( OPCAO4, 0 )
      IF OPCAO4 > 0
         mQUEBRAR := OPCAO4
      ENDIF
   ELSEIF mTIPO = 'F'
      @ 08, 29 CLEAR TO 11, 54
      @ 08, 29 TO 11, 54 DOUBLE
      OPCAO4 := mQUEBRAR
      IF mQUEBRAR = 0
         OPCAO4 := 1
      ENDIF
      OPCAO( 09, 31, ' &Em todo fim de Pag. ', 69 )
      OPCAO( 10, 31, ' &S¢ no fim da lista  ', 83 )
      OPCAO4 := MENU( OPCAO4, 0 )
      IF OPCAO4 > 0
         mQUEBRAR := OPCAO4
      ENDIF
   ENDIF

   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: ESP()
// !
// !    Chamado por: M_CN3()   (fun‡„o em M_CN3.PRG)
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ESP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION ESP

   IF mESPACEJAR = -1
      @ 24, 00
      @ 24, 00 SAY 'Formula:' GET mFORMULA
   ENDIF

   RETURN ( .T. )

// + EOF: m_cn3.prg
// +
