*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_4B.PRG
*+
*+    Functions: Function iFOPTO4B()
*+               Function tFOPTO4B()
*+               Function gFOPTO4B()
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　

//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

PEGPTOHOR( "XX", .T., .F. )   //Verifica indices

PADRAO( "FOPTOHOR", "FOPTOHOR", "' '+str(mNUMERO,8)+' '+mCODIGO+' '+STR(mENT,  6, 2)+' '+STR(mALMI,  6, 2)+' '+STR(mALMF,  6, 2)+' '+STR(mSAI,  6, 2)+' '+mVIRADA+' '+mFOLGASN", ;
         "mNUMERO", "FOPTO_4B - Horarios Basico", "Numero Cod Entrad Almoco       Saida V F", ;
        {|| iFOPTO4B()}, { || tFOPTO4B() }, { || gFOPTO4B() }, { || FO_RELL( "PONTOCAD04" ) },, 2,,,"X"  )
retu .T.


function iFOPTO4B
mNUMERO:=ULTIMOREG("FOPTOHOR","NUMERO",.T.)
mCODIGO:="  "
@ 24,00 GET mNUMERO
@ 24,20 GET mCODIGO VALID ! EMPTY(mCODIGO).and.! verseha("FOPTOHOR",2,mCODIGO,"'Codigo Ja Cadastrado:'+NOME",,.T.).AND. ! PEGFOLGA(mCODIGO) 
READCUR()
mCHAVE:=mNUMERO
return .t.

*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
*+    Function tFOPTO4B()
*+
*+    Called from ( fopto_4b.prg )   1 - function gfopto4a()
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
func tFOPTO4B
HB_dispbox( 4, 0, 23, 79, B_DOUBLE+" ")
@  6,  2 say "Numero    Cod Ent    Refeicao" + spac( 5 ) + "Saida  Noite Folga"
@  7, 35 say "S/N"
@  8,  2 SAY "Descricao"
@ 10,  2 say "Codigo de Apuracao "
@ 11,  5 say "-"
retu .T.

*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
*+    Function gFOPTO4B()
*+
*+    Called from ( fopto_4b.prg )   1 - function gfopto4a()
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
func gFOPTO4B
@  7,  2 SAY mNUMERO
@  7, 12 SAY mCODIGO  
@  7, 15 get mENT     pict '999.99'                          WHEN INCLUI
@  7, 22 get mALMI    pict '999.99'                          WHEN INCLUI
@  7, 29 get mALMF    pict '999.99'                          WHEN INCLUI
@  7, 36 get mSAI     pict '999.99'                          WHEN INCLUI
@  7, 43 get mVIRADA  pict "!"      valid mVIRADA  $ " SN"   WHEN INCLUI.OR.EMPTY(mVIRADA)
@  7, 50 get mFOLGASN pict "!"      valid mFOLGASN $ " SN"   WHEN INCLUI.OR.EMPTY(mFOLGASN)
@  8, 12 get mNOME    WHEN PTO4B01() .AND. INCLUI
READCUR()
retu .T.

FUNC PTO4B01
IF EMPTY(mNOME)
   mNOME:=Str(mENT,5,2)+" "
   IF ! Empty(mALMI)
      mNOME+=Str(mALMI,5,2)+" "
      mNOME+=Str(mALMF,5,2)+" "
   ENDIF
   mNOME+=Str(mSAI,5,2)
ENDIF
RETU .T.

*+ EOF: FOPTO_4B.PRG
