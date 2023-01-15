# define ADJVAL  30

*****************************************************************
* 
*  function encode
* 
*****************************************************************
FUNCTION ENCODE (in_string,lUPPER)
LOCAL counter := in_len := 0, next_char := out_string := '' ,nASC
IF VALTYPE(lUPPER)<>"L"
   lUPPER:=.T.
ENDIF

IF in_string != NIL

    * Ajusta a cadeia especificada e converte as letras em maiusculas.
    in_string := ALLTRIM(in_string)
    IF lUPPER
       in_string := UPPER(in_string)
    ENDIF
    
    in_len := LEN(in_string)

    * Inverte a cadeia, inclui 30 em cada caracter e o duplica.
    FOR counter = 1 TO in_len

         * Obtem os caracteres na ordem inversa.
         next_char = SUBSTR(in_string, counter * -1, 1)

         * Inclui o caracter na cadeia de retorno, se for numerico,alfabetico ou simbolo valido
         
         //  next_char == '.'.OR. next_char == '_'.OR.            ISDIGIT(next_char) .OR. ISALPHA(next_char)
         IF ISDIGIT(next_char) .OR. ISALPHA(next_char) .OR.  next_char $ '-+_!@#$%^&*., ?'
             nASC:= (ASC(next_char) + ADJVAL) * 2
             IF nASC>255
                 nASC:=nASC-220  //-255 gerava caracteres de controle minimo = 32 espaco 255-32=223 usando 220 z(122)=304 - 220 = 84
                                 // z ultimo valor aceitabel
             ENDIF
             out_string := out_string + CHR(nASC)  //CHR((ASC(next_char) + ADJVAL) * 2)
         ENDIF
    NEXT
ENDIF

RETURN out_string

*****************************************************************
* 
*  function decode
* 
*****************************************************************
FUNCTION DECODE (in_string)
//# define ADJVAL  30
LOCAL counter := in_len := 0, out_string := '' , nASC
IF in_string != NIL

    * Ajusta a cadeia especificada.
    in_string := ALLTRIM(in_string)
    in_len := LEN(in_string)

    * Obtem o valor ASCII de cada posicao e recupera o valor original.
    FOR counter = 1 TO in_len
        nASC  := ASC(SUBSTR(in_string, counter * -1, 1)) //CHR((ASC(SUBSTR(in_string, counter * -1, 1)) /2) - ADJVAL)
        IF nASC<85            //-255 gerava caracteres de controle minimo = 32 espaco 255-32=223 usando 220 z(122)=304 - 220 = 84
            nASC:= nASC +220  // z ultimo valor aceitaVel
        ENDIF    
        nASC := INT(nASC /2)
        nASC := nASC - ADJVAL
        out_string := out_string + CHR(nASC) // CHR((ASC(SUBSTR(in_string, counter * -1, 1)) /2) - ADJVAL)
    NEXT

ENDIF
RETURN out_string

*****************************************************************
* 
*  function encodeval
* 
*****************************************************************
FUNCTION ENCODEVAL (in_string)
LOCAL counter , next_char , aCHAVE
aCHAVE := array( 10 )
afill( aCHAVE, 0 )
in_string:=alltrim(in_string)
IF empty(in_string)
   return aCHAVE
endif
FOR counter = 1 TO LEN(in_string)  //out_string := out_string +  CHR((ASC(next_char) + ADJVAL) * 2)
    next_char = SUBSTR(in_string, counter * -1, 1)  //*-1 apra reversao das string
    nCHAR:= ASC(next_char) 
    nCHAR:= nCHAR + ADJVAL
    nCHAR:= nCHAR * 2
    aCHAVE[counter]:=nCHAR
NEXT
RETURN aCHAVE

*****************************************************************
* 
*  function decodeval
* 
*****************************************************************
FUNCTION DECODEVAL(aVALOR)
LOCAL in_string,nVALOR,counter,nLEN,nPOSREV
in_string:=""
nLEN :=len(aVALOR)
FOR counter = 1 to len(aVALOR)
    nPOSREV:=nLEN-counter+1
    IF aVALOR[nPOSREV]>0
       nVALOR := aVALOR[nPOSREV]  //CHR((ASC(SUBSTR(in_string, counter * -1, 1)) /2) - ADJVAL)
       nVALOR := INT(nVALOR /2)
       nVALOR := nVALOR - ADJVAL
       in_string = in_string  + CHR(nVALOR)
    ENDIF
NEXT
RETURN in_string


*+--------------------------------------------------------------------
*+
*+    Function XDECODE()
*+
*+--------------------------------------------------------------------
*+
function XDECODE(cVAR)
return if(empty(cVAR),cVAR,DECODE(cVAR))

*+--------------------------------------------------------------------
*+
*+    Function XENCODE()
*+
*+--------------------------------------------------------------------
*+
function XENCODE(cVAR,lUPPER)
return if(empty(cVAR),cVAR,ENCODE(cVAR,lUPPER))

*+--------------------------------------------------------------------
*+
*+    Function XDECDAT()
*+
*+--------------------------------------------------------------------
*+
function XDECDAT(cVAR)
cVAR := XDECODE(cVAR)
cVAR := ctod(left(cVAR,2)+'/'+substr(cVAR,3,2)+'/'+right(cVAR,2))
return cVAR
