*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_SINTG.PRG
*+
*+    Functions: Function SINTG01()
*+
*+    Reformatted by Click! 2.03 on Nov-27-2002 at  1:48 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
#INCLUDE "BOX.CH"

GRAVA50 := "S"
GRAVA51 := "S"
GRAVA54 := "S"
GRAVA53 := "N"
GRAVA70 := "S"
nREG50  := 0
nREG51  := 0
nREG54  := 0
nREG53  := 0
nREG70  := 0
nREG75  := 0
cANO:=STRZERO(YEAR(ZDATA),4)
cMES:=STRZERO(MONTH(ZDATA),2)
//cARQ:="C:\TEMP\S"+cANO+cMES+STRZERO(ZNUMERO,1)+".TXT"+SPACE(10)
cARQ:=WIN_GETSAVEFILENAME(, "Salvar Sintegra","C:\TEMP\","txt", "*.txt" , 1 , , "S"+cANO+cMES+STRZERO(ZNUMERO,1)+".TXT")


MDI( " Gera SINTEGRA " )
if !USEREDE( "MANEMP", 1, 1 )
   retu .F.
endif
dbgotop()
if !dbseek( ZNUMERO )
   dbcloseall()
   ALERTX( "Falta Cadastro Empresa" )
   retu
else
   cCGC      := CGC
   cIE       := INSCR
   cCIDADE   := CIDADE
   cESTADO   := ESTADO
   cNOME     := NOME
   cTELEFAX  := TELEFAX
   cDDDFAX   := DDDFAX
   cENDERE   := ENDERECO
   cBAIRRO   := BAIRRO
   cCEP      := CEP
   cCONTATO  := CONTATO
   cDDD      := DDD
   cTELEFONE := TELEFONE
endif
dbcloseall()

dINI := dFIM := ZDATA

cNUMERO   := "0"
cENDERECO := cENDERE
nPOS      := at( ",", cENDERE )
if nPOS > 0
   cENDERECO := substr( cENDERE, 1, nPOS - 1 )
   cNUMERO   := substr( cENDERE, nPOS + 1 )
endif

if empty( cCONTATO )
   cCONTATO := "Contato"
endif
cIE       := ACEPAD( TIRAOUT( cIE ), 14 )
cENDEREDO := ACEPAD( TIRAOUT( cENDERECO ), 34 )
cBAIRRO   := ACEPAD( TIRAOUT( cBAIRRO ), 15 )
cCONTATO  := ACEPAD( cCONTATO, 28 )
cNUMERO   := ACEPAD( cNUMERO, 5 )
cNOME     := ACEPAD( TIRAOUT( cNOME ), 35 )
cCIDADE   := ACEPAD( TIRAOUT( cCIDADE ), 30 )
cCON      := "3" //XX/02 4.1.0 //3 Versao 5.0.2
cOPE      := "3"
cFIN      := "1"

cDDD      := strzero( val( TIRAOUT( cDDD ) ), 2 )
cTELEFONE := strzero( val( TIRAOUT( cTELEFONE ) ), 8 )
cDDDFAX   := strzero( val( TIRAOUT( cDDDFAX ) ), 2 )
cTELEFAX  := strzero( val( TIRAOUT( cTELEFAX ) ), 8 )

HB_dispbox( 4, 0, 23, 79, B_DOUBLE)
@  5,  2 say "Dados do Reponsavel Pelo Arquivo"
@  6,  2 say "Endereco"
@  6, 23 say "Numero"
@  6, 29 say "Bairro"
@  6, 45 say "Cidade"
@  6, 77 say "UF"
@  8, 02 say "CGC"
@  8, 22 say "IE"
@  8, 42 say "Nome"
@ 10, 02 say "DDD Telefone DDDFAX FaxNo. CEP"
@ 10, 42 say "Contato"
@ 13, 02 say "Opera‡Жo"
@ 13, 22 say "(1)Inter-Subs (2)Inter (3)Todas"
@ 15, 02 say "Finaliade"
@ 15, 22 say "(1)Normal (2)Ret.Sub (3)Ret.Adc (4)Ret.Cor (5)Desfaz"
@ 19, 02 say "Nome do Arquivo"
@ 19, 50 say "Periodo"
@ 21, 02 say "Grava Reg 50"
@ 21, 22 say "Grava Reg 51"
@ 21, 42 say "Grava Reg 54"
@ 22, 02 SAY "Grava Reg 53"
@ 22, 22 SAY "Grava Reg 70"
@  7,  2 get cENDERECO
@  7, 23 get cNUMERO
@  7, 29 get cBAIRRO
@  7, 45 get cCIDADE
@  7, 77 get cESTADO
@  9,  2 get cCGC
@  9, 22 get cIE
@  9, 42 get cNOME
@ 11, 02 get cDDD
@ 11, 06 get cTELEFONE
@ 11, 16 get cDDDFAX
@ 11, 20 get cTELEFAX
@ 11, 30 get cCEP
@ 11, 42 get cCONTATO
@ 13, 18 get cOPE
@ 15, 18 get cFIN
@ 19, 20 get cARQ
@ 19, 60 get dINI
@ 19, 70 get dFIM
@ 21, 15 get GRAVA50
@ 21, 35 get GRAVA51
@ 21, 65 get GRAVA54
@ 22, 15 GET GRAVA53
@ 22, 35 GET GRAVA70
if !READCUR()
   retu .F.
endif

cARQ    := strtran( cARQ, " ", "" )

if !USEMULT( { { "SINT50", 0, 1 }, { "SINT51", 0, 1 }, { "SINT70", 0, 1 } ,;
               { "SINT54", 0, 1 }, { "SINT75", 0, 1 }, { "SINT53", 0, 1 } } )
   retu .F.
endif
USO := fcreate( cARQ )
if ferror() # 0
   ALERTX( "Erro na Cria‡„o do Arquivo" )
   retu
endif


fwrite( uso, "10" )
fwrite( uso, strzero( val( TIRAOUT( cCGC ) ), 14 ) )
fwrite( uso, ACEPAD( cIE, 14 ) )
fwrite( uso, ACEPAD( cNOME, 35 ) )
fwrite( uso, ACEPAD( cCIDADE, 30 ) )
fwrite( uso, cESTADO )
fwrite( uso, cDDDFAX + cTELEFAX )
fwrite( uso, dtos( dINI ) )
fwrite( uso, dtos( dFIM ) )
fwrite( uso, cCON )
fwrite( uso, cOPE )
fwrite( uso, cFIN )
fwrite( USO, HB_OSNEWLINE())

fwrite( uso, "11" )
fwrite( uso, ACEPAD( cENDERECO, 34 ) )
fwrite( uso, strzero( val( cNUMERO ), 5 ) )
fwrite( uso, space( 22 ) )
fwrite( uso, ACEPAD( cBAIRRO, 15 ) )
fwrite( uso, strzero( val( TIRAOUT( cCEP ) ), 8 ) )
fwrite( uso, ACEPAD( cCONTATO, 28 ) )
fwrite( uso, "00" + cDDD + cTELEFONE )
fwrite( USO, HB_OSNEWLINE())

if GRAVA50 = "S"
   SINTG01( "SINT50" )
endif
if GRAVA51 = "S"
   SINTG01( "SINT51" )
endif

if GRAVA53 = "S"
   SINTG01( "SINT53" )
ENDIF


if GRAVA54 = "S"
   dbselectar( "SINT75" )
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netgrvcam("gerado",.f.)},, {|| zei_fort(nLASTREC,,,1)})
   @ 24, 00 say "SINT54"
   dbselectar( "SINT54" )
   dbgotop()
   while !eof()
      @ 24, 10 say recno()
      if cOPE = "3" .or. UF # cESTADO //todas operacoes ou interestaduais
          fwrite( uso, "54" ) //1
         fwrite( uso, strzero( val( TIRAOUT( CGC ) ), 14 ) ) //2
         fwrite( uso, strzero( MODELO, 2 ) ) //3
         fwrite( uso, left( SERIE, 3 ) ) //4
//         fwrite( uso, left( SUB, 2 ) )
         if numero>999999
            cNUMERO:=STRZERO(NUMERO,8)
            cNUMERO:=RIGHT(cNUMERO,6)
            fwrite( uso, cNUMERO) //5
         else
            fwrite( uso, strzero( NUMERO, 6 ) ) //5
         endif
         fwrite( uso, CFOP ) //6
         fwrite( uso, strzero( SITUACAO, 3 ) ) //7
         fwrite( uso, strzero( ITEM, 3 ) ) //8
         fwrite( uso, ACEPAD( CODIGORED, 14 ) ) //9
         fwrite( uso, GRVVAL( QTDE, 11, 3 ) ) //10
         fwrite( uso, GRVVAL( VALORMER, 12, 2 ) ) //11
         fwrite( uso, GRVVAL( DESCONTO, 12, 2 ) ) //12
         fwrite( uso, GRVVAL( BASEICM, 12, 2 ) ) //13
         fwrite( uso, GRVVAL( BASESUB, 12, 2 ) ) //13 Base de Calculo Sub Tributaria
         fwrite( uso, GRVVAL( VALORIPI, 12, 2 ) ) //15
         fwrite( uso, GRVVAL( ICM, 4, 2 ) ) //16
         fwrite( USO, HB_OSNEWLINE())
         nREG54 ++
         mCODIGORED:=CODIGORED
         IF ITEM<=990 //991 a 999 frete seguro outros
            dbselectar( "SINT75" )
            dbgotop()
            IF dbseek(mCODIGORED)
              netgrvcam("GERADO",.T.)
            ENDIF
         endif
         dbselectar( "SINT54" )
      endif
      dbskip()
   enddo
endif

if GRAVA70 = "S" //70 Conhecimento de Transporte
   SINTG01( "SINT70" )
ENDIF

if GRAVA54 = "S" //75 54 acima
   @ 24, 00 say "SINT75"
   dbselectar( "SINT75" )
   dbgotop()
   while !eof()
      @ 24, 10 say recno()
      if GERADO
         fwrite( uso, "75" )
         fwrite( uso, dtos( dINI ) )
         fwrite( uso, dtos( dFIM ) )
         fwrite( uso, ACEPAD( CODIGORED, 14 ) )
         fwrite( uso, ACEPAD( TIRAOUT( CLASSIPI ), 8 ) )
         fwrite( uso, ACEPAD( DESCRICAO, 53 ) )
         fwrite( uso, ACEPAD( UNID, 6 ) )
         //fwrite( uso, strzero( SITUACAO, 3 ) )
         fwrite( uso, grvval(IPI, 5,2) )
         fwrite( uso, grvval(ICM, 4,2) )
         IF REDICM>0
            nPERICM := 100 - REDICM
            fwrite( uso, GRVVAL( nPERICM, 5, 2 ) )
         ELSE
            fwrite( uso, GRVVAL( 0, 5, 2 ) )
         ENDIF
         fwrite( uso, GRVVAL( SUBICM, 13, 2 ) )
         fwrite( USO, HB_OSNEWLINE())
         nREG75 ++
      endif
      dbskip()
   enddo
endif

nSPACE := 85
nGER   := 3         //10 E 11 E 90

fwrite( USO, "90" )
fwrite( uso, strzero( val( TIRAOUT( cCGC ) ), 14 ) )
fwrite( uso, ACEPAD( cIE, 14 ) )
if GRAVA50 = "S"
   fwrite( uso, "50" )
   fwrite( uso, strzero( nREG50, 8 ) )
   nSPACE -= 10
   nGER   += nREG50
endif
if GRAVA51 = "S"
   fwrite( uso, "51" )
   fwrite( uso, strzero( nREG51, 8 ) )
   nSPACE -= 10
   nGER   += nREG51
endif
if GRAVA53 = "S"
   fwrite( uso, "53" )
   fwrite( uso, strzero( nREG53, 8 ) )
   nSPACE -= 10
   nGER   += nREG53
endif
if GRAVA54 = "S" //54 75 Abaixo
   fwrite( uso, "54" )
   fwrite( uso, strzero( nREG54, 8 ) )
   nSPACE -= 10
   nGER   += nREG54
endif
if GRAVA70 = "S"
   fwrite( uso, "70" )
   fwrite( uso, strzero( nREG70, 8 ) )
   nSPACE -= 10
   nGER   += nREG70
endif
if GRAVA54 = "S"  //75 Requerido quando 54
   fwrite( uso, "75" )
   fwrite( uso, strzero( nREG75, 8 ) )
   nSPACE -= 10
   nGER   += nREG75
endif

fwrite( uso, "99" )
fwrite( uso, strzero( nGER, 8 ) )
fwrite( uso, space( nSPACE ) )
fwrite( uso, "1" )
fwrite( USO, HB_OSNEWLINE())

fclose( USO )
dbcloseall()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function SINTG01()
*+
*+    Called from ( m_sintg.prg  )   2 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func SINTG01( cARQ )

@ 24, 00 say cARQ
dbselectar( cARQ )
dbgotop()
while !eof()
   @ 24, 10 say recno()
   if cOPE = "3" .or. UF # cESTADO
      fwrite( uso, TIPO )
      if UF = "XX".OR.UF = "EX"
         fwrite( uso, REPL("0",14) )
      ELSE
         fwrite( uso, strzero( val( TIRAOUT( CGC ) ), 14 ) )
      ENDIF
      if UF = "XX".OR.UF = "EX"
         fwrite( uso, ACEPAD( "ISENTO", 14 ) )
      ELSE
         fwrite( uso, ACEPAD( TIRAOUT( IE ), 14 ) )
      ENDIF
      fwrite( uso, dtos( DATA ) )
      if UF = "XX".OR.UF = "EX"
         fwrite( uso, "EX" )
      else
         fwrite( uso, UF )
      endif
      if cARQ = "SINT50".OR.cARQ="SINT53"
         fwrite( uso, strzero( MODELO, 2 ) )
         fwrite( uso, left( SERIE, 3 ) )
//         fwrite( uso, left( SUB, 2 ) )
      endif
      if cARQ = "SINT51"
         fwrite( uso, left( SERIE, 3 ) )
//         fwrite( uso, left( SUB, 2 ) )
      endif
      if cARQ = "SINT70"
         fwrite( uso, strzero( MODELO, 2 ) )
         fwrite( uso, left( SERIE, 1 ) )
         fwrite( uso, left( SUB, 2 ) )
      endif
      if numero>999999
         cNUMERO:=STRZERO(NUMERO,8)
         cNUMERO:=RIGHT(cNUMERO,6)
         fwrite( uso, cNUMERO)
      else
         fwrite( uso, strzero( NUMERO, 6 ) )
      endif
      fwrite( uso, CFOP )
      if cARQ = "SINT50"
         fwrite(uso, "P")
      endif
      if cARQ = "SINT53"
         fwrite(uso, "T")
      endif
      nVALORTOT:=VALORTOT
      IF nVALORTOT=0
         nVALORTOT:=0.01
      ENDIF
      DO CASE
          CASE carq="SINT53"
              fwrite( uso, GRVVAL( BASE, 13, 2 ) )
              fwrite( uso, GRVVAL( VALOR, 13, 2 ) )
              fwrite( uso, GRVVAL( 0, 13, 2 ) ) //Despesas Acessorias
          CASE carq="SINT70"
              fwrite( uso, GRVVAL( nVALORTOT, 13, 2 ) )
              fwrite( uso, GRVVAL( BASE, 14, 2 ) )
              fwrite( uso, GRVVAL( VALOR, 14, 2 ) )
              fwrite( uso, GRVVAL( ISENTA, 14, 2 ) )
              fwrite( uso, GRVVAL( OUTRAS, 14, 2 ) )
          otherwise
             fwrite( uso, GRVVAL( nVALORTOT, 13, 2 ) )
             if cARQ = "SINT50"
                fwrite( uso, GRVVAL( BASE, 13, 2 ) )
             endif
             fwrite( uso, GRVVAL( VALOR, 13, 2 ) )
             fwrite( uso, GRVVAL( ISENTA, 13, 2 ) )
             fwrite( uso, GRVVAL( OUTRAS, 13, 2 ) )
      ENDCASE
      if cARQ = "SINT51"
         fwrite( uso, space( 20 ) )
      endif
      if cARQ = "SINT50"
         fwrite( uso, GRVVAL( ALIQUOTA, 4, 2 ) )
      endif
      if cARQ = "SINT70"
         fwrite( uso, FRETE )
      endif
      fwrite( uso, SITUACAO )
      IF cARQ="SINT53"
         fwrite( uso, space( 1 ) ) //Codigo Antecipacao tributaria
         fwrite( uso, space( 29 ) )
      ENDIF
      fwrite( USO, HB_OSNEWLINE())
      DO CASE
         CASE cARQ = "SINT50"
             nREG50 ++
         CASE cARQ = "SINT51"
             nREG51 ++
         CASE cARQ = "SINT53"
             nREG53 ++
         CASE cARQ = "SINT70"
             nREG70 ++
      endCASE
   endif
   dbskip()
enddo
retu

*+ EOF: M_SINTG.PRG
