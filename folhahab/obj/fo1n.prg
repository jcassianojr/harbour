*:*****************************************************************************
*:
*:       FO1N.PRG: Eliminar Folha de Ponto
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:09
*:
*:  Procs & Fncts: FO1N()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************


CABEX("Eliminar Folha de Ponto")
IF ! MDG('Vocˆ tem certeza')
   RETU
ENDIF
IF ! MDG('Vocˆ realmente tem certeza')
   RETU
ENDIF

DELDBFNTX("AFDTERR")
DELDBFNTX("BCOBAK")
DELDBFNTX("BCODEK")
DELDBFNTX("BCODEM")
DELDBFNTX("BCOHRS")
DELDBFNTX("BCOREQ")
DELDBFNTX("BCOREQ") //
DELDBFNTX("BCRBAK")
DELDBFNTX("CESTA")
DELDBFNTX("CTRHOR")
DELDBFNTX("FERIAS")                     
DELDBFNTX("FO_DIO")
DELDBFNTX("FO_PDES")  //
DELDBFNTX("FO_PHOR") //
DELDBFNTX("FO_PMAN")  //
DELDBFNTX("FO_POCO") //
DELDBFNTX("FO_PON")
DELDBFNTX("FO_PON") //
DELDBFNTX("FO_POS")
DELDBFNTX("FO_POS") //
DELDBFNTX("FO_POT")
DELDBFNTX("FO_POT") //
DELDBFNTX("FO_PTT")
DELDBFNTX("FO_RELHR")
DELDBFNTX("FOPTOALM")
DELDBFNTX("FOPTOATR")
DELDBFNTX("FOPTOBCO")
DELDBFNTX("FOPTOCOM")
DELDBFNTX("FOPTOCOM") //
DELDBFNTX("FOPTOCON")
DELDBFNTX("FOPTOCON") //Configuracao
DELDBFNTX("FOPTOEVE")
DELDBFNTX("FOPTOHOR")
DELDBFNTX("FOPTOHRE")
DELDBFNTX("FOPTOPRD")
DELDBFNTX("FOPTOPRO")
DELDBFNTX("FOPTOREL")
DELDBFNTX("FOPTOREV")
DELDBFNTX("FOPTOREV") //
DELDBFNTX("HTTTROCA")
DELDBFNTX("RBTEMP")
RETU

FUNC DELDBFNTX(cARQ)
 MDS('Deletando '+cARQ)
FERASE(ZDIRN+cARQ+".DBF")
FERASE(ZDIRN+cARQ+"."+cRDDEXT)
FERASE(ZDIRN+cARQ+".DBF")
FERASE(ZDIRN+cARQ+"."+cRDDEXT)
FERASE(cARQ+".DBF")
FERASE(cARQ+"."+cRDDEXT)
RETU

*: FIM: FO1N.PRG
