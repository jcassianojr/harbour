*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\ITAESBRA\M_BS7.PRG
*+
*+    Functions: Function MBS0701()
*+               Function MBS0702()
*+
*+       Tables: use &cARQ. NEW
*+               use &cARQ. NEW
*+
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

MDI( " н Resumos Anuais" )

if MDG( "Acumular Empresa Anual/G1" )
   SOMAANO( "APU5EMP", "A1", "PADRAO",,,,,,,{|cARQ| MBS0703(cARQ)})
endif

if MDG( "Acumular 2 Maiores Clientes" )
   if !USEREDE( "APU5EMP", 1, 2 )
      retu .F.
   endif
   ZAPARQ( { { "APU5EM2", .F., .T. } } )
   dbselectar( "APU5EMP" )
   dbgotop()
   while !eof()
      mMES     := MES
      mANO     := ANO
      mCLI1    := 0
      mCOGCLI1 := ""
      mPRECLI1 := 0
      mCLI2    := 0
      mCOGCLI2 := ""
      mPERCLI2 := 0
      while mMES = MES .and. mANO = ANO .and. !eof()
         if empty( mCLI1 ) .and. empty( TGRUPO )
            mCLI1    := CLIENTE
            mCOGCLI1 := COGCLI
            mPERCLI1 := PERCLI
         else
            if empty( mCLI2 ) .and. empty( TGRUPO )
               mCLI2    := CLIENTE
               mCOGCLI2 := COGCLI
               mPERCLI2 := PERCLI
            endif
         endif
         dbselectar( "APU5EMP" )
         dbskip()
      enddo
      mJUNTO := strzero( mMES, 2 ) + "/" + strzero( mANO, 4 ) + "  " + padr( mCOGCLI1, 7 ) + " " + padr( mCOGCLI2, 7 )
      NOVOOPA( "APU5EM2" )
      dbselectar( "APU5EMP" )
   enddo
   dbcloseall()
endif

if MDG( "Relatorio Receita" )
   IMPREL( "MA", "MA_00013", "MANREL", "MANRE1" )
endif

if MDG( "Relatorio Melhores Clientes" )
   IMPREL( "MA", "MA_00014", "MANREL", "MANRE1" )
endif

if MDG( "Acumular Produtos" )
   SOMAANO( "APU5G", "A", "PADRAO",,,,,,,{|cARQ| MBS0703(cARQ)} )
endif


if MDG( "Acumular Graficos G4" )
   SOMAANO( "APU5G4", "A4", "PADRAO",,,,,,,{|cARQ| MBS0703(cARQ)} )
endif


if MDG( "Apurar Produtos A4" )
   SOMAANO( "APU5CD2", "A4", "PADRAO", { | nMES, nANO, cARQ, cARQREF | MBS0702( nMES, nANO, cARQ, cARQREF ) },,,,,, )
ENDIF

if MDG( "Apurar Resumo Linha" )
//   IF USEREDE("APU5LIN",0,99)
//      ZAP
//      DBCLOSEALL()
//   ENDIF
   SOMAANO( "APU5LIN", "A1", "PADRAO", { | nMES, nANO, cARQ, cARQREF | MBS0704( nMES, nANO, cARQ, cARQREF ) },,,,,, )
   IF USEREDE("APU5LIN",0,99)
      DBGOTOP()
      WHILE ! EOF()
          mANO:=ANO
          mTOTAL:=0
          nREGINI:=RECNO()
          WHILE mANO=ANO.AND.! EOF()
             mTOTAL+=VALORTOT
             DBSKIP()
          ENDDO
          nREGDEP:=RECNO()
          DBGOTO(nREGINI)
          WHILE mANO=ANO.AND.! EOF()
             FIELD->PERFAT:=perc(VALORTOT,mTOTAL)
             DBSKIP()
          ENDDO
          DBGOTO(nREGDEP)
      ENDDO
      DBCLOSEAREA()
   ENDIF
ENDIF


if MDG( "Relatorio Melhores Itens" )
   IMPREL( "MA", "MA_00015", "MANREL", "MANRE1" )
endif


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MBS0702()
*+
*+    Called from ( m_bs7.prg    )   1 - function mbs601()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MBS0702( nMES, nANO, cARQ, cARQREF )
cARQA := cARQ
cARQ  := "GRAFICOS\" + cARQ
IF ! useCHK(cARQ,,.T.)
   retu .f.
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","100-PERLUC")
ordSetFocus("temp")
//index on PERLUC to GRAFICOS\TEMP DESCE  eval zei_fort(nLASTREC,,,1)

dbgotop()
mANO    := nANO
mMES    := nMES
mJUNTO  := strzero( mMES, 2 ) + "/" + right( strzero( mANO, 4 ), 2 ) + " " + left( JUNTO, 25 )
mJUNTOA := left( JUNTO, 25 )
mPERCOM := PERLUC
mINTCOM := PERLUC * 1000
dbskip()
mJUNTO   += left( JUNTO, 25 )
mJUNTOB  := left( JUNTO, 25 )
mPERCOM2 := PERLUC
mINTCOM2 := PERLUC * 1000
dbskip()
mJUNTO   += left( JUNTO, 25 )
mJUNTOC  := left( JUNTO, 25 )
mPERCOM3 := PERLUC
mINTCOM3 := PERLUC * 1000
dbclosearea()
NOVOOPA( cARQREF )
retu .T.

FUNC MBS0703(cARQ)
retu usechk("GRAFICOS\" + cARQ,,.t.)


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MBS0704()
*+
*+    Called from ( m_bs7.prg    )   1 - function mbs601()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MBS0704( nMES, nANO, cARQ, cARQREF )
cARQA := cARQ
cARQ  := "GRAFICOS\" + cARQ
mANO   :=nANO

IF nMES=1 //Janeiro Reacumula Apaga Anual
  dbselectar("APU5LIN")
  nLASTREC:=LASTREC()
  zei_fort( nLASTREC,,,0)
  DBEVAL({|| netrecdel()},{|| ANO = nANO}, {|| zei_fort(nLASTREC,,,1)})
ENDIF

if ! userede("MA01",1,1)
   retu .f.
endif
if ! usechk(cARQ,,.t.)
   retu .f.
endif
dbgotop()
WHILE ! EOF()
   mSUBGER:=SUBGER
   IF EMPTY(SUBGER)
      mCLIENTE:=CLIENTE
      DBSELECTAR("MA01")
      DBGOTOP()
      IF DBSEEK(mCLIENTE)
         mSUBGER:=SUBGER
         IF EMPTY(SUBGER)
            ALERTX("Cliente Sem Grupo"+str(mCLIENTE,8))
         ENDIF
      ELSE
         IF mCLIENTE<99990000
            ALERTX("Cliente NЦo Cadastrado"+str(mCLIENTE,8))
         ENDIF
      ENDIF
      DBSELECTAR(cARQA)
      IF ! EMPTY(mSUBGER)
         NETGRVCAM("SUBGER",mSUBGER)
      ENDIF
   ENDIF
   DBSELECTAR(cARQA)
   mVALORTOT:=VALORTOT
   IF CLIENTE<99990000
      IF ! NOVOOPE("APU5LIN",STR(mANO,4)+mSUBGER)
         FIELD->VALORTOT:=VALORTOT+mVALORTOT
      ENDIF
   ENDIF
   DBSELECTAR(cARQA)
   DBSKIP()
ENDDO
DBCLOSEAREA()
DBSELECTAR("MA01")
DBCLOSEAREA()
RETU .T.

*+ EOF: M_BS7.PRG
