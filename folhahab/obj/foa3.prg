// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foa3.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOA3.PRG: Entrada de Dados Pr‚ Selecionada
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     11:28
// :
// :  Procs & Fncts: FOA3()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : PETELA()           (fun‡„o    em FOLPROC.PRG)
// :               : VALCTA()           (fun‡„o    em FOLPROC.PRG)
// :               : GRAVA2()           (fun‡„o    em FOLPROC.PRG)
// :               : FODZER             (processo  em FOLPROC.PRG)
// :
// :    Arq. Dados : FO_PFE - Folha de F‚rias
// :                 FO_RSS - Folha de Rescis„o
// :                 FO_COMP - Folha Complementar
// :                 CONTAS - Cadastro de Vencimentos e Descontos
// :
// :       Indices : RSS        Codigo de Trabalho
// :                            CONTROLE
// :                 CONTA      Por ordem de c¢digo
// :                            CODIGO
// :
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

#include "BOX.CH"

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foa3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foa3

   PARA CC

   CABEX( 'Entrada de Dados Pre Selecionada' )

   XA := XB := XC := XD := XE := XF := CTR := SEL := 0

   IF !NETUSE( PES )   // AREDE(PES,PES,0)
      RETU
   ENDIF
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))'
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO

   MDS( 'Qual Sele‡„o (0-9)' )
   @ 24, 40 GET SEL PICT '#' RANGE 0, 9
   READCUR()
   FILTRA := "SELECAO=" + Str( SEL, 1 )

   IF !ARQUSAR( CC )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE2 := Alias()

   IF !netuse( "CONTAS" )  // AREDE("CONTAS","CONTAS",0)
      dbCloseAll()
      RETU .F.
   ENDIF
   SET FILTER TO &FILTRA

   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      PETELA( 7 )
      CTR := NUMERO
      dbSelectAr( "CONTAS" )
      dbGoTop()
      WHILE !Eof()
         XB      := TIPO
         CTCONTA := CODIGO
         hb_DispBox( 12, 8, 16, 71, B_DOUBLE + " " )
         @ 12, 16 SAY "-" + REPL( '-', 37 ) + "-"
         @ 16, 16 SAY "-" + REPL( '-', 37 ) + "-"
         @ 13, 10 SAY "Conta Ý Descrimina‡„o" + SPAC( 23 ) + "Ý Valor/Horas"
         @ 14, 08 SAY 'Ç' + REPL( '-', 7 ) + "+" + REPL( '-', 37 ) + "+" + REPL( '-', 16 ) + '¶'
         @ 15, 16 SAY "Ý" + SPAC( 37 ) + "Ý"
         @ 15, 11 SAY CODIGO                                                PICTURE "###"
         @ 15, 18 SAY DESCR
         IF ACEITE # "S" .OR. ZUSER = "SUPERVISOR"
            dbSelectAr( cSELE2 )
            VALE := VALCTA( CTR, CTCONTA )
            HORA := IF( Found(), HORAS, 0 )
            IF XB = 1 .OR. XB = 3 .OR. XB = 4
               @ 15, 56 GET HORA PICT '###.##'
            ELSE
               @ 15, 56 GET VALE PICT '###,###,###.##'
            ENDIF
            READCUR()
            GRAVA2( CTCONTA )
            IF XB = 1 .OR. XB = 3 .OR. XB = 4
               REPL HORAS WITH HORA
            ENDIF
         ELSE
            ALERTX( "Inclus„o desta Conta Permitida Somente para o Supervisor" )
         ENDIF
         dbSelectAr( "CONTAS" )
         dbSkip()
      ENDDO
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   dbSelectAr( cSELE2 )
   FODZER()
   dbCloseAll()
   RETU
// : FIM: FOA3.PRG

// + EOF: foa3.prg
// +
