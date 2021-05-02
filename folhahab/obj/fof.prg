*:*****************************************************************************
*:
*:        FOF.PRG: MENU PRINCIPAL DE HOLLERITS
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 21/07/98
*:
*:*****************************************************************************

#INCLUDE "BOX.CH"

IF ! netuse("REL2") //AREDE("REL2","REL2",0)
   RETU
ENDIF
IF DBSEEK('HOLERITH')
   CC1=A
   CC2=B
   CC3=C
   CC4=D
   CC5=E
   CC6=F
   CC7=G
   CC8=H
   CC9=I
   CC10=J
   CC11=K
   CC12=L
   CC13=M
   CC14=N
   CC15=O
   CC16=P
   CC17=Q
   CC18=R
   CC19=S
   CC20=T
   CC21=U
   CC22=V
   CC23=W
   CC24=X
   CC25=Y
   CC26=Z
   CC27=AA
   CC28=AB
   CC29=AC
   CC30=AD
   CCXX=AE
   CC32=AF
ELSE
   DBCLOSEALL()
   ALERTX("N„o encontrei a configuracao do Hollerith")
   RETU
ENDIF
DBCLOSEALL()

WHILE .T.
   OPC:=1
   CABEX("Menu de Impress„o de Holleriths")
   HB_dispbox( 7, 0, 21, 21,B_DOUBLE+" ")
   @ 09,01 PROM "  1 - Hollerith     "
   @ 11,01 PROM "  2 - Mensagens     "
   @ 13,01 PROM "  3 - Configura‡„o  "
   @ 15,01 PROM "  4 - Por Planilha  "
   MENU TO OPC
   TELA=SAVESCREEN(07,00,21,21)
   DO CASE
       CASE OPC=1.OR.OPC=4 ; TIP=OPC ; FOFF()
       CASE OPC=2 ; FOFB()
       CASE OPC=3 
           PADRAO("REL2","REL2","mCODIGO","mCODIGO","Configura‡Æo Relatorios","Codigo",;
                 {|| PEGCHAVE("mCODIGO",SPACE(8),"Codigo:")},"REL201","REL201",{|| FO_FOR("GRUPO='CONFIG'")})
            RETU //for‡a retu para recarregar  conf.
       OTHERWISE  ; RETU
   ENDCASE
ENDDO


*!*****************************************************************************
*!
*!       FOFF
*!
*!*****************************************************************************
FUNCTION FOFF
WHILE .T.
   CABEX  ("Menu de Impress„o de Holleriths")
   RESTSCREEN(07,00,21,21,TELA)
   HB_dispbox( 7,22, 21, 42,B_DOUBLE+" ")   
   @ 09,23 PROM " A - Folha         "
   @ 11,23 PROM " B - Ferias        "
   @ 13,23 PROM " C - Rescisao      "
   @ 15,23 PROM " D - 13o. Salario  "
   @ 18,23 PROM " E - Complementar  "
   @ 17,23 PROM " F - Vale Transp.  "
   @ 19,23 PROM " G - Semanal       "
   @ 20,23 PROM " H - RPA           "
   MENU TO ARQ
   TELA1=SAVESCREEN(07,22,21,42)
   IF ARQ=0
      RETU
   ENDIF
   IF OPC=4 ; FOFHOL('HOLG1')
   ENDIF
   IF OPC#5
      DO CASE
      CASE ARQ=1 ; FOFF2()
      CASE ARQ=2 ; FOFHOL('HOLA1')
      CASE ARQ=3 ; FOFHOL('HOLA1')
      CASE ARQ=4 ; FOFHOL('HOLD1')
      CASE ARQ=5 ; FOFHOL('HOLA1')
      CASE ARQ=6 ; FOFHOL('HOLH1')
      CASE ARQ=7 ; FOFHOL('HOLA1')
      CASE ARQ=8 ; FOFHOL('HOLA1')
      ENDCASE
   ENDIF
ENDDO

*!*****************************************************************************
*!
*!       FOFF2
*!
*!    Chamado por: FOFF               (  em FOF.PRG)
*!
*!          Chama: FOFHOL()           (fun‡„o    em FOFHOL.PRG)
*!
*!*****************************************************************************
FUNCTION FOFF2
WHILE .T.
   CABEX ("Menu de Impress„o de Holleriths")
   RESTSCREEN(07,00,21,21,TELA)
   RESTSCREEN(07,22,21,42,TELA1)
   HB_dispbox( 7,58, 15, 79,B_DOUBLE+" ")   
   @ 09,59 PROM " L - Pagamento.     "
   @ 11,59 PROM " M - Adiantamento.  "
   @ 13,59 PROM " N - Premio.        "
   @ 14,59 PROM " O - Adiant.+Premio "
   MENU TO RES
   DO CASE
   CASE RES=1 ; FOFHOL('HOLA1')
   CASE RES=2 ; FOFHOL('HOLB1')
   CASE RES=3 ; FOFHOL('HOLI1')
   CASE RES=4 ; FOFHOL('HOLJ1')
   OTHERWISE  ; RETURN
   ENDCASE
ENDDO
RETU
*: FIM: FOF.PRG
