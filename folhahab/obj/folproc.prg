// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folproc.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :    FOLPROC.PRG: PROCS FOLHA
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 21/07/98
// :
// :*****************************************************************************

#include "INKEY.CH"
// #INCLUDE "TECLAS.CH"

// !*****************************************************************************
// !
// !         Funcao: CABEX()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABEX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CABEX( TITULO )

   @  2, 0 CLEAR
   @  2, 0 SAY " Ý " + TITULO

   RETURN .T.

// !*****************************************************************************
// !
// !       INCIDE
// !
// !    Chamado por: GRAVA2()           (funcao    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function INCIDE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION INCIDE

   XA := FATOR
   XB := TIPO
   XC := TRIBUTINPS
   XD := TRIBUTIRR
   XE := TRIB_FGTS
   XF := VALOR

   RETURN

// !*****************************************************************************
// !
// !       GRAVA1
// !
// !    Chamado por: GRAVA2()           (funcao    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRAVA1( nVALOR, nHORAS )

   IF ValType( nVALOR ) # "N"
      nVALOR := VALE   // Grava Indicado ou publica vale
   ENDIF
   FIELD->VALOR := nVALOR
   IF ValType( nHORAS ) = "N" .AND. nVALOR > 0   // nao referencia se valor for zero
      FIELD->HORAS := nHORAS
   ENDIF
   FIELD->VALOR      := VALE
   FIELD->FATOR      := XA
   FIELD->TIPO       := XB
   FIELD->TRIBUTINPS := XC
   FIELD->TRIBUTIRR  := XD
   FIELD->TRIB_FGTS  := XE
   FIELD->VALORBASE  := XF

   RETURN

// !*****************************************************************************
// !
// !      GRAVA
// !
// !    Chamado por: GRAVA2()           (funcao    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRAVA

   REPL NUMERO WITH CTR, CONTA WITH CTR1
   REPL CONTROLE WITH CTA

   RETURN

// !*****************************************************************************
// !
// !         Funcao: GRAVA2()
// !
// !  CRT    Numero Funcionario (!Publica)
// !  VALOR  Gravar em Valor(!Publica)
// !
// !          Chama: INCIDE             (  em FOLPROC.PRG)
// !               : GRAVA              (  em FOLPROC.PRG)
// !               : GRAVA1             (  em FOLPROC.PRG)
// !
// !*****************************************************************************

// !*****************************************************************************
// !
// !         Fun+"o: GRAVA2()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVA2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRAVA2   // USO GRAVACAO DADOS FOLHA

   PARA CTR1, nVALOR, nHORAS
   LOCAL cALIAS

   cALIAS := Alias()
   dbSelectAr( "CONTAS" )
   dbGoTop()
   IF dbSeek( CTR1 )
      XA := FATOR
      XB := TIPO
      XC := TRIBUTINPS
      XD := TRIBUTIRR
      XE := TRIB_FGTS
      XF := VALOR
   ENDIF
   CTA := ( CTR * 10000 ) + CTR1
   dbSelectAr( cALIAS )
   dbGoTop()
   IF !dbSeek( CTA )
      NETRECAPP()
      FIELD->NUMERO   := CTR
      FIELD->CONTA    := CTR1
      FIELD->CONTROLE := CTA
   ELSE
      NETRECLOCK()
   ENDIF
   IF ValType( nVALOR ) = "N"
      GRAVA1( nVALOR, nHORAS )
   ELSE
      GRAVA1(, nHORAS )
   ENDIF
   dbUnlock()

   RETURN .T.

// !*****************************************************************************
// !
// !         Funcao: SALMES()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SALMES()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SALMES( nMES )

   IF ValType( nMES ) # "N"
      nMES := MES
   ENDIF
   XSAL := "SAL" + SubStr( MMES( nMES ), 1, 3 )
   XSAL := &XSAL

   RETURN XSAL

// !*****************************************************************************
// !
// !       FODZER
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FODZER()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FODZER

   GRAPP := 1
   GRAPT := LastRec()
   GRAPT( 'Aguarde Zerando Contas sem Valor e Horas' )
   PCK := .F.
   dbGoTop()
   WHILE !Eof()
      IF AllTrim( Alias() ) = "FO_COMP"
         IF HORAS = 0.00 .AND. VALOR = 0.00 .AND. VALORMES1 = 0 .AND. VALORMES2 = 0
            netrecdel()
            PCK := .T.
         ENDIF
      ELSE
         IF HORAS = 0.00 .AND. VALOR = 0.00
            netrecdel()
            PCK := .T.
         ENDIF
      ENDIF
      GRAPS()
      dbSkip()
   ENDDO
   IF PCK
      PACK
   ENDIF

   RETURN

// !*****************************************************************************
// !
// !         Funcao: MDL()
// !
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MDL( TITULO, nTIP )

   IF ValType( nTIP ) # "N"
      nTIP := 1
   ENDIF
   CABEX( TITULO )
   @ 18, 00 TO 21, 79 DOUB
   @ 19, 03 SAY 'LIGUE A IMPRESSORA !! ,Ajuste o papel'
   @ 20, 25 SAY 'IMPRESSORA DEFINIDA PARA FORMULARIO => '
   @ 20, 64 SAY IF( IM1 = 'A', '80', '132' ) + ' Colunas '

   RETURN CHECKIMP( nTIP )

// !*****************************************************************************
// !
// !         Funcao: VALCTA()
// !
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VALCTA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION VALCTA( NFUNC, NCONT )

   BUSCA := ( NFUNC * 10000 ) + NCONT
   dbGoTop()
   dbSeek( BUSCA )
   IF !Found()
      RETURN 0
   ENDIF

   RETURN VALOR


// !*****************************************************************************
// !
// !         Funcao: NSHOW1()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NSHOW1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION NSHOW1

   IF Eof()
      hb_keyClear()
      // CLEAR TYPEAHEAD
      NSHOW()
      IF LastKey() = 13
         netrecapp()
         KEYBOARD Chr( 13 )
      ELSE
         RETURN .F.
      ENDIF
   ENDIF

   RETURN .T.



// !*****************************************************************************
// !
// !       NSHOW
// !
// !    Chamado por: NSHOW1()           (funcao    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NSHOW()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION NSHOW

   SET COLOR TO
   @  8, 0 CLEAR
   SET COLOR TO + W / BR
   @  9, 0 TO 11, 79 DOUB
   SET COLOR TO N / W
   @ 10, 1 SAY SPAC( 33 ) + 'Arquivo vazio' + SPAC( 32 )
   SET COLOR TO + W / BR
   Inkey( 0 )
   SET COLO TO

   RETURN


// !*****************************************************************************
// !
// !         Funcao: ACHRET()
// !
// !    Chamado por: FO6.PRG
// !               : FO6E()             (funcao    em FO6.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ACHRET()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ACHRET( nStatus, nElement, nRelative )   // criado apenas para retornar o ponteiro do vetor

// *************************************
   LOCAL nKEY
   IF nStatus == 0
      SCROLLBARUPDATE( aSBAR, nElement, Graf )
   ENDIF
   nKEY := LastKey()
   DO CASE
   CASE nkey = K_ENTER
      RETU 1
   CASE nkey = K_ESC
      RETU 0
   CASE nkey = K_ALT_F10
      RETU 0
   CASE nkey = K_INS
      RETU 0
   CASE nkey = K_DEL
      RETU 1
   CASE nkey = K_CTRL_ENTER
      RETU 0
   CASE nkey = K_CTRL_F2
      RETU 0
   CASE nkey = K_CTRL_F3
      RETU 0
   CASE nkey = K_CTRL_F4
      RETU 0
   CASE nKEY = K_ALT_F1
      RETU 1
   CASE nKEY = K_ALT_F2
      RETU 1
   CASE nKEY = K_ALT_F3
      RETU 1
   CASE nKEY = K_ALT_F4
      RETU 1
   CASE nKEY = K_ALT_F5
      RETU 1
   CASE nKEY = K_ALT_F9
      RETU 1
   CASE nKEY = K_HOME    // HOME VIRA CTRL_PGUP
      KEYBOARD Chr( K_CTRL_PGUP )
   CASE nKEY = K_END   // END  VIRA CTRL_PGDN
      KEYBOARD Chr( K_CTRL_PGDN )
   OTHERWISE
      RETU 2
   ENDCASE
   RETU 2



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABE2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABE2( TITULO )

   SetColor( "N/W" )
   @ 02, 25 CLEAR TO 02, 80
   @ 02, 25 SAY " Ý " + TITULO
   SetColor( "W/N,N/W" )
   @ 03, 00 clear

   RETURN .T.

// : FIM: FOLPROC.PRG

// + EOF: folproc.prg
// +
