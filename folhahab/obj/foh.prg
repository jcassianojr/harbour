*:*****************************************************************************
*:
*:        FOH.PRG: Menu De Impress„o de Guias
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:06
*:
*:
*****************************************************************************
#INCLUDE "BOX.CH"

IMPHP()


WHILE .T.
   CABEX("Menu De Impress„o de Guias")
   HB_DISPBOX(07,00,23,21,B_DOUBLE+" ")
   oPCAO(  8,01 , " &1 - Pagamento       ",49)
   oPCAO(  9,01 , " &2 - Ferias          ",50)
   oPCAO( 10,01 , " &3 - Rescis„o        ",51)
   oPCAO( 11,01 , " &4 - 13o.Salario     ",52)
   oPCAO( 12,01 , " &5 - Complemento     ",53)
   oPCAO( 13,01 , " &6 - Vale Transporte ",54)
   oPCAO( 14,01 , " &7 - Folha Semanal   ",55)
   oPCAO( 15,01 , " &8 - Folha RPA       ",56)
   oPCAO( 16,01 , " &A - Adiantamento    ",65)
   oPCAO( 17,01 , " &B - Premio          ",66)
   ARQ:=MENU(,0)
   TELA=SAVESCREEN(07,00,23,21)
   DO CASE
      CASE ARQ=6
           ALERTX("N„o Disponivel VT")
           LOOP
      CASE ARQ#0
           FOH1()
      OTHERWISE
           RETU
   ENDCASE
ENDDO

*!*****************************************************************************
*!
*!      Procedure: FOH1
*!
*!*****************************************************************************
PROC FOH1
WHILE .T.
   CABEX("Menu De Impress„o de Guias")
   RESTSCREEN(07,00,23,21,TELA)
   HB_DISPBOX(07,22,23,55,B_DOUBLE+" ")
   @ 08,23 PROM " A - Guia INSS RESUMO           "
   @ 09,23 PROM " B - Guia INSS Formulario       "
   @ 10,23 PROM " C - Guia INSS Setorial         "
   @ 11,23 PROM " D - Guia INSS Acumulada        "
   @ 12,23 PROM " E - Consulta Guia Emp. Acumul. "
   @ 13,23 PROM " F - Consulta Guia Set. Acumul. "
   @ 14,23 PROM " G -                            "
   @ 15,23 PROM " H - Resumo Deposito FGTS       "
   @ 16,23 PROM " O - Contribui‡„o Sindical      "
   @ 17,23 PROM " P - Contribui‡„o Assistencial  "
   @ 18,23 PROM " Q - Contribui‡„o Mensalidade   "
   @ 19,23 PROM " R - Contribui‡„o Confederativa "
   @ 20,23 PROM " S - Guia Contribui‡„o Sindical "
   @ 21,23 PROM " T - Guia de IRFF               "
   @ 22,23 PROM " U - SEFIP-CEF-FGTS-DISQUETE    "
   MENU TO TIP
   DO CASE
      CASE TIP=1  ; FOHA(0,ARQ,0)
      CASE TIP=2  ; FOHA(1,ARQ,0)
      CASE TIP=3  ; FOHC()
      CASE TIP=4  ; FOHA(2,ARQ,1)
      CASE TIP=5  ; FOHE()     //-
      CASE TIP=6  ; FOHF()     //-
      CASE TIP=7
      CASE TIP=8  ; FOHD()
      CASE TIP=9  ; FOHH('CONTRIBUICAO SINDICAL',630)
      CASE TIP=10 ; FOHH('CONTRIBUICAO ASSISTENCIAL',620)
      CASE TIP=11 ; FOHH('MENSALIDADE SINDICATO',610)
      CASE TIP=12 ; FOHH('CONTRIBUICAO CONFEDERATIVA',511)
      CASE TIP=13 ; FOHS()
      CASE TIP=14 ; FOHI(ARQ)
      CASE TIP=15 ; FOHG2()
      OTHERWISE  ; RETU
   ENDCASE
ENDDO
RETU
*: FIM: FOH.PRG

FUNC FOHE
PADRAO("GINSSE","GINSSE","' '+STR(mNUMEMP,  5)+' '+STR(mMES,  2)+' '+STR(mANO,  4)+' '+STR(mVALREC, 12, 2)+' '+STR(mVALLIQ, 12, 2)+' '+mPAGA",;
        "STRZERO(mNUMEMP,5)+STRZERO(mANO,4)+STRZERO(mMES,2)","Guias Acumuladas INSS Empresa","Emp.  Mes/Ano Base"+spac(9)+"Liquido"+spac(6)+"Paga",;
       {||iFOHE()},"GINSSE","GINSSE",{|| FO_FOR("GRUPO='GINSSE'")})
RETU .T.


FUNC FOHF
PADRAO("GINSSD","GINSSD","' '+STR(mDEPTO,  4)+' '+STR(mSETOR,  3)+' '+STR(mSECAO,  3)+' '+STR(mMES,  2)+' '+STR(mANO,  4)+' '+STR(mVALLIQ, 12, 2)","STRZERO(mDEPTO,4)+STRZERO(mSETOR,3)+STRZERO(mSECAO,3)+STRZERO(mANO,4)+STRZERO(mMES,2)";
   ,"Guias Acumuladas Areas da Empresa","Dep  Set Sec Mes/Ano Valor Liquido",;
   {||iFOHF()},{|| tFOHF()},{||gFOHF()},{|| FO_FOR("GRUPO='GINSSD'")})
RETU .T.

FUNC tFOHE
HB_DISPBOX( 3, 0,23,79,B_DOUBLE+" ")
@  4,  1 SAY "Emp.  Mes/Ano Paga"
@  5, 17 SAY "(S/N)"
@  7,  4 SAY "Empresa"+spac(14)+"Segurados    Terceiros    Dedu‡”es     Liquido"
@  8,  2 SAY "Acidentes"
@  9,  6 SAY "Total"
RETU .T.

FUNC gFOHE
@  5, 1 SAY mNUMEMP     PICTURE '99999'
@  5, 7 SAY mMES        PICTURE '99'
@  5,10 SAY mANO        PICTURE '9999'
@  5,15 GET mPAGA       VALID mPAGA $ "SN" PICT "!"
@  7,12 GET mVALEMA     PICTURE '999999999.99'
@  8,12 GET mVALACI     PICTURE '999999999.99'
@  9,12 GET mVALEMP     PICTURE '999999999.99'
@  8,25 GET mVALREC     PICTURE '999999999.99'
@  8,38 GET mVALTER     PICTURE '999999999.99'
@  8,51 GET mVALDED     PICTURE '999999999.99'
@  8,64 GET mVALLIQ     PICTURE '999999999.99'
READCUR()
RETU .T.

FUNC iFOHE
MDS('Digite Empresa Mes e Ano: ')
@ 24,40 GET mNUMEMP
@ 24,50 GET mANO
@ 24,60 GET mMES
READCUR()
mCHAVE:=STRZERO(mNUMEMP,5)+STRZERO(mANO,4)+STRZERO(mMES,2)
RETU .T.

FUNC tFOHF
HB_DISPBOX( 3, 0,23,79,B_DOUBLE+" ")
@  4,  1 SAY "Dep  Set Sec Mes/Ano"
@  7,  1 SAY "Valores"
@  8,  1 SAY "Recolhimento Empresa"+spac(6)+"Terceiros    Deducoes     Valor Liquido"
RETU .T.

FUNC gFOHF
@  5, 1 SAY mDEPTO      PICTURE '9999'
@  5, 6 SAY mSETOR      PICTURE '999'
@  5,10 SAY mSECAO      PICTURE '999'
@  5,14 SAY mMES        PICTURE '99'
@  5,17 SAY mANO        PICTURE '9999'
@  9, 1 GET mVALREC     PICTURE '999999999.99'
@  9,14 GET mVALEMP     PICTURE '999999999.99'
@  9,27 GET mVALTER     PICTURE '999999999.99'
@  9,40 GET mVALDED     PICTURE '999999999.99'
@  9,53 GET mVALLIQ     PICTURE '999999999.99'
READCUR()
RETU .T.

FUNC iFOHF
mCHAVE:=STRZERO(mDEPTO,4)+STRZERO(mSETOR,3)+STRZERO(mSECAO,3)+STRZERO(mANO,4)+STRZERO(mMES,2)
RETU .T.
