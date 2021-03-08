*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_da.prg   Formatando Disquetes
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

function M_da
return nil

// Inicializando o Help
/*
PRIV HELPDBF:="MDA",drive:="A"

// Desenha a Tela
MDI(" Ý Formatando Disquetes")
MDS("Vocˆ est  selecionando a Forma‡„o de Disquetes")

TELASAY("MDA001")
EDITSAY("MDA001")

WHILE .T.
   @ 8,2 CLEAR TO 21,77
   @ 8,2  SAY "Insira o disquete no drive  " + drive
   @ 9,2  SAY "Ý Pressione uma tecla para continuar (ESC sair) ..."
   kb = HOTINKEY(0)
   IF kb = 27
      @ 23,0
      RETURN
   ENDIF

    ndrive = DRIVETYPE(DRIVE)
    IF nDRIVE < 1 .or. nDRIVE > 2
       ALERTX("Nao e Disquete")
        RETURN
    ENDIF

    nDRIVE=FLOPPYTYPE(DRIVE)
    //     0      No floppy drive
    IF nDRIVE=0
       ALERTX("Nao e Disquete")
       RETURN
    ENDIF
   aTIPOS :={"360Kb","1.2Mb","720Kb","1.44Mb"}
   @ 10,2 SAY "A capacidade do disquete ‚ " + aTIPOS[nDRIVE]
   IF MDG("Iniciar Formatacao")
       mds("")
       @ 24, 00 SAY "Track:"
       @ 24, 20 SAY "Head:"
       nErrCode := DISKFORMAT(DRIVE,, "SAYFORMA", , 0)
       IF nErrCode = 0
          ALERTX("Formatacao Concluida")
       ELSE
          DO  CASE
              CASE nErrCode = -1 ; ALERTX("Somente Drives A OU B sao Validos")
              CASE nErrCode = -2 ; ALERTX("Formato/Tamanho nao suportado")
              CASE nErrCode = -3 ; ALERTX("Solicitado Cancelamento Formatacao ")
              CASE nErrCode = -4 ; ALERTX("Erro ao Gravar")
          ENDCASE
       ENDIF
   ENDIF
ENDDO


FUNCTION sayforma(nTrack, nHead)
LOCAL nRetval
nRetval := 0  // Continue format
@ 24, 08 SAY STR(nTrack)
@ 24, 28 SAY STR(nHead)
IF INKEY() = 27
   IF MDG("Encerrar Formatacao")
      nRetval := 2  // Abort
   ENDIF
ENDIF
RETURN(nRetval)

*/

// : FIM: M_DA.PRG
