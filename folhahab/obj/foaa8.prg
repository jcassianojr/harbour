#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

function foaa8
PARA NN
DO CASE
   CASE NN=1
       CC1A:=PES
       CC1B:=PES
       CC2A:="CONTAS"
       CC2B:="CONTAS"
       CC3 :=SEM
   CASE NN=2
       CC1A:="MG01"
       CC1B:="MG01"
       CC2A:="CTARPA"
       CC2B:="CTARPA"
       CC3 :=RPA
ENDCASE
CABEX('Entrada de dados folha Individualizado')
HB_DISPBOX( 6, 0,23,79,B_DOUBLE+" ")
@  8,  3 SAY "Funcion rio :"
@ 10,  3 SAY "Conta"+spac(7)+":"
@ 12,  3 SAY "Semana"+spac(6)+":"
@ 17,  3 SAY "<ESC>  Encerra"
mNUMERO:=0
mCONTA :=0
mSEMANA:=1
mTIPO  :=""
WHILE .T.
   mVALOR:=0
   mHORAS:=0
   set key K_F11 to TECLAF11
   @  8, 17 GET mNUMERO PICT "99999" VALID VERSEHA(CC1A,,mNUMERO,"NOME" ,'"Funcion rio N„o Cadastrado"')
   @ 10, 17 GET mCONTA  PICT "999"   VALID VERSEHA(CC2A,,mCONTA ,"DESCR",'"Conta n„o cadastrada"')
   @ 12, 17 GET mSEMANA PICT "9"
   IF ! READCUR().OR.EMPTY(mNUMERO).OR.EMPTY(mCONTA)
      set key K_F11 TO
      EXIT
   ENDIF
   set key K_F11 to
   mTIPO:=OBTER(CC2A,,mCONTA,"TIPO")
   IF netuse(cc3) 
      DBGOTOP()
      if ! DBSEEK(mNUMERO*10000+mSEMANA*1000+mCONTA)
         netrecapp()
         FIELD->NUMERO:=mNUMERO
         FIELD->CONTA :=mCONTA
         FIELD->SEMANA:=mSEMANA
      ELSE
         mVALOR:=VALOR
         mHORAS:=HORAS
      ENDIF
   ENDIF
   DBCLOSEAREA()
   @ 14,01 CLEA TO 14,78
   IF mTIPO = 1 .OR. mTIPO = 3 .OR. mTIPO = 4
      @ 14,03 SAY "Quantidade de Horas"
      @ 14,25 GET mHORAS PICT '###.##'
      READCUR()
   ELSE
      @ 14,03 SAY "Valor"
      @ 14,25 GET mVALOR PICT '###,###,###.##'
      READCUR()
   ENDIF
   IF netuse(cc3) //AREDE(CC3,CC3,0)
      DBGOTOP()
      if DBSEEK(mNUMERO*10000+mSEMANA*1000+mCONTA)
          netreclock()
          IF mTIPO = 1 .OR. mTIPO = 3 .OR. mTIPO = 4
             FIELD->HORAS:=mHORAS
          ELSE
             FIELD->VALOR:=mVALOR
          ENDIF
          dbunlock()
      ENDIF
   ENDIF
   DBCLOSEAREA()
ENDDO
IF netuse(cc3) //AREDE(CC3,CC3,0)
   FODZER()
   DBCLOSEAREA()
ENDIF
