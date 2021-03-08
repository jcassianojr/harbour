*******************************************************************************
*:
*:  FOPTO_4F.PRG : Alterar Cadastro De Turno
*:     Linguagem : Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
*:
*:*****************************************************************************


//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


PADRAO("TABTURNO","TABTURNO","mCODIGO+' '+mNOME","mCODIGO","FOPTO_4F - Cadastro de Turnos","Codigo Descri‡„o",;
       {|| PEGCHAVE("mCODIGO",SPACE(2),"Codigo:")},{|| tFOPTO4F() },{||gFOPTO4F()},{|| FO_RELL("PONTOCAD08")},,2,,,"X" )
RETU .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function gFOPTO4F() 
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
FUNC gFOPTO4F
@  6, 4 SAY mCODIGO
@  6,10 GET mNOME         WHEN INCLUI
@  7,10 GET mNOM2         WHEN INCLUI
@  9,10 GET mDESCRICAO    
@ 12, 5 GET mAPURA     
@ 12,10 GET mFORMULA   
READCUR()
RETU .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function tFOPTO4F()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
FUNC tFOPTO4F
HB_DISPBOX( 4, 0,23,79,B_DOUBLE+" ")
@  5,  2 SAY "Codigo  Descri‡„o para Etiqueta"
@  8, 10 SAY "Descri‡„o/Obs"
@ 11,  3 SAY "Apura  Formula de Apura‡„o"
RETU .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function trocahtt(nTIPO) 
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
Func trocahtt(nTIPO)
CABE2( 'FOPTO_4G - Trocar Turno Descritivo' )
mANT:="  "
mHTT:="  "
mHT:=""
mNUMERO:=0
mDATA:=date()
IF nTIPO=1
   @ 23,00 SAY "Funcionario:          Horario Antigo:          Novo:    Data:"
else
   @ 23,00 SAY "                      Horario Antigo:          Novo:    Data:"
ENDIF
set key K_F11 to TECLAF11   
@ 23,12 GET mNUMERO   WHEN nTIPO=1  PICT "99999999"
@ 23,38 GET mANT      WHEN nTIPO=2  VALID VERSEHA("TABTURNO",,mANT,"NOME","'Horario Nao Cadastrado'") 
@ 23,53 GET mHTT                    VALID VERSEHA("TABTURNO",,mHTT,"NOME","'Horario Nao Cadastrado'")                     
@ 23,63 GET mDATA
IF ! READCUR()
   RETU .F.
ENDIF
set key K_F11

if nTIPO=2
   IF ! MDG("Trocar "+mANT+"->"+mHTT)
      RETU .F.
   ENDIF
ENDIF

mHT := OBTER( "TABTURNO", , mHTT, "NOME" )

IF ! NETUSE("HTTTROCA")
   dbcloseall()
ENDIF

if ! NETUSE("FO_PES") 
   dbcloseall()
   retu .F.
endif
dbgotop()
IF nTIPO=1
   mANT:=HT
   if dbseek(mNUMERO)
      netreclock()
      mANT:=HTT               //pega o codigo Atual
      FIELD->HTT:=mHTT        //grava o novo
      field->HT :=mHT         //grava o descritivo
      DBUNLOCK()
   ENDIF  
   dbselectar("HTTTROCA")
   dbappend()
   replvars()
endif
IF nTIPO=2
  while ! eof()
     petela(9)
     mNUMERO:=NUMERO
     IF HTT=mANT.AND.EMPTY(DEMITIDO)
        netreclock()
        FIELD->HTT:=mHTT
        FIELD->HT :=mHT
        DBUNLOCK()
        dbselectar("HTTTROCA")
        dbappend()
        replvars()
        dbselectar("FO_PES")
    ENDIF
    DBSKIP()
  enddo
ENDIF
dbcloseall()
retu .t.

*: FIM: FOPTO_4F.PRG
