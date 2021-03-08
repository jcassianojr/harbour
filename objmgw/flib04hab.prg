*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\OBJ\FLIB04.PRG
*+
*+               Function INFOR()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function INFOR()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function INFOR          //INDEXAR E EXIBIR INFORMACAO ARQUIVO
para mARQUIVO, aCHAVE, aINDICE, lCHECA, aTAG, lAPA
local nERRO,X
LOCAL cFileAttr  , nFileSize
LOCAL dCreateDate, nCreateTime
LOCAL dChangeDate, nChangeTime
if valtype( lCHECA ) # "L"
   lCHECA := .F.
endif
if valtype( aTAG ) = "U"                //Nao Passada tag
   aTAG := ""
endif
if valtype( lAPA ) # "L"
   lAPA := .T.
endif
if valtype( aCHAVE ) = "C"              //Caracter Vira Array
   aCHAVE  := { aCHAVE }
   aINDICE := { aINDICE }
   aTAG    := { aTAG }
endif
for X := 1 to len( aINDICE )
   mINDICE := aINDICE[ X ]
   if lCHECA        //Se Tiver o Indice nao Indexa
      if REDEFILE( mINDICE, ordbagext(), .F. ) 
         retu .T.
      endif
   endif
   if lAPA
      IF file( mINDICE + ordbagext() )
         ferase( mINDICE + ordbagext() )              //Apaga o Indice
      endif
      if file( ZDIRE + mINDICE+ ordbagext() )
         ferase( ZDIRE + mINDICE + ordbagext() )      //Apaga o Indice empresa
      endif
      if file( ZDIRN + mINDICE+ ordbagext() )
         ferase( ZDIRN + mINDICE + ordbagext() )      //Apaga o Indice ANUAL
      endif
   endif
next X

	
//FileStats( mARQUIVO,@cFileAttr  , @nFileSize  , ;
//                     @dCreateDate, @nCreateTime, ;
//                     @dChangeDate, @nChangeTime  )


if ! netuse(mARQUIVO,,.F.,.F.,.T.,.F.,30)
    //netuse(cARQ,cDRIVER,lSHA,lREAD,lNEW,lINDEX,nTIME )
   retu .F.
endif
HB_dispbox( 6, 0, 23, 78,B_DOUBLE+" ")
@  7,  3 say spac( 21 ) + "Quadro Informativo do Arquivo" + spac( 26 )
@ 08,  4 say "Nome" + spac( 12 ) + chr( 16 )
@ 09,  4 say "Chave" + spac( 11 ) + chr( 16 )
@ 10,  4 say "Indice" + spac( 10 ) + chr( 16 )
@ 11,  4 say "TAG   " + spac( 10 ) + chr( 16 )
@ 12,  4 say "Registros" + spac( 7 ) + chr( 16 )
@ 13,  4 say "Movimenta??o    " + chr( 16 )

//@ 09,40 SAY  "Attibuto  :"+ STRVAL(cFileAttr)
//@ 10,40 SAY  "Tamanho   :"+ STRVAL(nFileSize,8)
//@ 11,40 SAY  "Criado em :"+ STRVAL(dCreateDate)+" "+STRVAL( nCreateTime,5,2 )
//@ 12,40 SAY  "Modificao :"+ STRVAL(dChangeDate)+" "+STRVAL( nChangeTime,5,2 )

@ 24, 00 say chr( 16 ) + "  Aguarde Reorganizando  " + chr( 17 )
@ 08, 23 say alias()
@ 12, 23 say str( lastrec(), 7 )
@ 13, 23 say dtoc( lupdate() )
pack
for X := 1 to len( aINDICE )
   mCHAVE  := aCHAVE[ X ]
   mINDICE := aINDICE[ X ]
   mTAG    := aTAG[ X ]
   if empty( mTAG ) .and. upper( ordbagext() ) = ".CDX"
      mTAG := mINDICE
   endif
   @ 09, 23 say alltrim( mCHAVE )
   @ 10, 23 say alltrim( mINDICE )
   @ 11, 23 say alltrim( mTAG )

   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)

   if empty( mTAG )
      index on &mCHAVE to &mINDICE EVAL ZEI_FORT(nLASTREC,,,1)
   else
      index on &mCHAVE tag &mTAG. EVAL ZEI_FORT(nLASTREC,,,1)
   endif
next X
dbclosearea()
setcolor( "W/N,N/W" )
@ 06,00 CLEAR
retu .T.

*+ЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁ
*+
*+    Function REDEFILE()
*+
*+ЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁЁ
*+
func REDEFILE( cARQ, cEXT, lMES )
if valtype(Lmes)#"L"
   lMES:=.T.
ENDIF
if at( ".", cEXT ) = 0
   cEXT := "." + cEXT
endif
if ! HB_FILEEXISTS( cARQ + cEXT ) 
   if ! HB_FILEEXISTS( ZDIRE + cARQ + cEXT )
      if ! HB_FILEEXISTS( ZDIRN + cARQ + cEXT )
         if lMES
             ALERTX( 'REDEFILE Arquivo: ' + cARQ + cEXT + " N∆o Encontrado" )
         endif  
         retu .F.
      endif
  endif       
endif
retu .T.


*+ EOF: FLIB04.PRG

