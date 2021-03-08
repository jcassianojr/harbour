*******************************************************************************
*:
*:  FOPTO_4A.PRG : Alterar Cadastro De Faltas
*:     Linguagem : Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/26/94      8:48
*:
*:  Procs & Fncts: FOPTO_4A()
*:
*:     Documentado 05/13/94 em 15:44                DISK!  vers„o 5.01
*:*****************************************************************************


//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

PADRAO("TABFALTA","TABFALTA","mCODIGO+' '+mNOME","mCODIGO","FOPTO_4A - Codigos Faltas e Atrasos","Codigo Descri‡„o",;
       {|| PEGCHAVE("mCODIGO",SPACE(2),"Codigo:")},{|| tFOPTO4A()},{||gFOPTO4A()},{|| FO_RELL("PONTOCAD03") },,2)
RETUrn .T.

FUNCtion tFOPTO4A()
HB_DISPBOX( 4, 0,23,79,B_DOUBLE+" ")
@  5,  2 SAY "Codigo  Descricao"
@  7,  2 SAY "Observa‡ao"
@ 11,  3 SAY "Apura  Formula de Apuracao"
@ 15,  2 SAY "Excluir da Apuracao Padrao"
@ 16,  2 SAY "Codigos de importacao     "
@ 17,  2 SAY "Codigos FGTS Entrada/Saida"
@ 18,  2 SAY "Absenteismo Codigo/Justifica(S/N)"
RETUrn

FUNCtion gFOPTO4A
@  6, 2 SAY mCODIGO
@  6,10 GET mNOME
@  8, 2 GET mOBS
@ 12, 5 GET mAPURA VALID mAPURA $ "SN " PICT "!"
@ 12,10 GET mFORMULA
@ 15,30 GET mMACPAD VALID mMACPAD $ "SN " PICT "!"
@ 16,30 GET mCODIMP01
@ 16,35 GET mCODIMP02
@ 17,30 GET mCODFGS VALID EMPTY(mCODFGS).OR.CHECKTAB("FDEM"+PADR(mCODFGS,5),24,0,"Motivo nao Cadastrado")
@ 17,35 GET mCODFGR VALID EMPTY(mCODFGR).OR.CHECKTAB("FDEM"+PADR(mCODFGR,5),24,0,"Motivo nao Cadastrado")
@ 18,37 GET mRHABCOD
@ 18,41 GET mRHABJUST  VALID mRHABJUST $ "SN " PICT "!"
READCUR()
RETUrn .T.

*: FIM: FOPTO_4A.PRG
