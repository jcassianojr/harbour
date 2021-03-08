#INCLUDE "INKEY.CH"
FUNC CTAFUN(cCODFUN,cCODEMP) //Conta do Funcionario,CGC sem os Sinais
IF LASTKEY()=K_UP.OR.LASTKEY()=K_DOWN
   RETU .T.
ENDIF
IF EMPTY(cCODFUN)
   ALERTX("Vocˆ n„o preencheu o codigo")
   RETU .T.
ENDIF
if (! EMPTY(cCODFUN)) .AND.( ! EMPTY(cCODEMP))
   xsa:= SubStr(cCODEMP,7,3)
   xfu:= SubStr(cCODFUN,1,4)
   if (Val(xsa) != 0)
      if (Val(xfu) != 0)
         wxdv:= 1
      else
         wxdv:= 2
      endif
   elseif (Val(xfu) != 0)
      wxdv:= 3
   else
      wxdv:= 4
   endif
   if ! dvfu(wxdv,cCODFUN,cCODEMP)
      ALERTX("C¢digo do empregado invalido")
      return .F.
   endif
endif
RETU .T.

********************************
function DVFU(wx,cCODFUN,cCODEMP)
fgtstemp:= Space(1)+ccodemp+Space(25)+ccodfun+Space(201)
wmodfu1:= wmodfu2:= 2
sdvfu1:= sdvfu2:= 0
if ! EMPTY(cCODFUN)
   wdvfu1:= SubStr(fgtstemp, 50, 1)
   wdvfu2:= SubStr(fgtstemp, 51, 1)
   do case
      case wx == 1
           j:= 23
           wfunc:= SubStr(fgtstemp, 2, 14) + SubStr(fgtstemp, 41, 11)
      case wx == 2
           j:= 19
           wfunc:= SubStr(fgtstemp, 2, 14) + SubStr(fgtstemp, 45, 7)
      case wx == 3
           j:= 20
           wfunc:= SubStr(fgtstemp, 2, 6) + SubStr(fgtstemp, 11, 5) + ;
           SubStr(fgtstemp, 41, 11)
      case wx == 4
           j:= 16
           wfunc:= SubStr(fgtstemp, 2, 6) + SubStr(fgtstemp, 11, 5) + ;
           SubStr(fgtstemp, 45, 7)
      otherwise
           return .F.
   endcase
   k:= j + 1
   l:= j + 2
   for i:= 1 to j
       sdvfu1:= sdvfu1 + wmodfu1 * Val(SubStr(wfunc, k - i, 1))
       wmodfu1:= iif(wmodfu1 < 7, wmodfu1 + 1, 2)
   next
   wrestfu1:= mod(sdvfu1, 11)
   wdigfu1:= iif(wrestfu1 == 0 .OR. wrestfu1 == 1, 0, 11 - ;
   wrestfu1)
   for i:= 1 to k
       sdvfu2:= sdvfu2 + wmodfu2 * Val(SubStr(wfunc, l - i, 1))
       wmodfu2:= iif(wmodfu2 < 7, wmodfu2 + 1, 2)
   next
   wrestfu2:= mod(sdvfu2, 11)
   wdigfu2:= iif(wrestfu2 == 0 .OR. wrestfu2 == 1, 0, 11 - ;
   wrestfu2)
   return iif(Str(wdigfu1, 1) == wdvfu1 .AND. Str(wdigfu2, 1) == ;
   wdvfu2, .T., .F.)
else
   return .T.
endif
return .F.
