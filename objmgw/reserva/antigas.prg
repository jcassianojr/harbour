
keyins->hb_keyput KEYBOARD -> hb_keyPut()
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+    Function HotInkey()   FT_SINKEY(waittime)
*+    hotinkey alternativa mantida a que esta em comp
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
//function HotInkey( nSecs )

//local nKey
//local bHotKey
//nKey := iif( pcount() == 0, inkey(), inkey( nSecs ) )
//do while ( bHotKey := setkey( nKey ) ) != NIL
//   eval( bHotKey, procname( 1 ), procline( 1 ), "" )
//   nKey := iif( pcount() == 0, inkey(), inkey( nSecs ) )
//enddo
//return nKey


/* utilizada checkemail em comp
Function IsMail(cMail)
   Local lResp := .f.
   Local cRegExp

   cRegExp := "^[_a-z0-9-]+(\.[_a-z0-9-]+)"
   cRegExp += "*@[a-z0-9-]+(\.[a-z0-9-]+)*"
   cRegExp += "(\.[a-z]{2,3})$"

   lResp := hb_RegExMatch( cRegExp, cMail )
return lResp

fUNCTION IsMail( cMail )
RETURN   LEN( hb_regex( '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$', ALLTRIM( cMail ), .F. ) ) == 1
*/


/* seria usada para testar a rmacro porem apresentou alguns erros deixada para teste posteriore
function CheckExpression( cExpression )

   local bCode, lResult := .F., oError

   TRY
      bCode := GENBLOCK( cExpression )
      Eval( bCode )
      lResult = .T.
   CATCH oError
      ALERTX( oError:Description + If( ! Empty( oError:Operation ),;
                CRLF + oError:Operation, "" ) + hb_osnewlone() + ArgsList( oError ),;
                "Expression error" )
   END

return lResult
*/

//somente usada no fopto_21 sincada sefazclass
FUNCTION DomingoDePascoa( nAno )

   LOCAL nA, nB, nC, nD, nE, nF, nG, nH, nI, nK, nL, nM, nMes, nDia

   nA   := nAno % 19
   nB   := Int( nAno / 100 )
   nC   := nAno % 100
   nD   := Int( nB / 4 )
   nE   := nB % 4
   nF   := Int( ( nB + 8 ) / 25 )
   nG   := Int( ( nB - nF + 1 ) / 3 )
   nH   := ( 19 * nA + nB - nD - nG + 15 ) % 30
   nI   := Int( nC / 4 )
   nK   := nC % 4
   nL   := ( 32 + 2 * nE + 2 * nI - nH - nK ) % 7
   nM   := Int( ( nA + 11 * nH + 22 * nL ) / 451 )
   nMes := Int( ( nH + nL - 7 * nM + 114 ) / 31 )
   nDia := ( ( nH + nL - 7 * nM + 114 ) % 31 ) + 1

   RETURN Stod( StrZero( nAno, 4 ) + StrZero( nMes, 2 ) + StrZero( nDia, 2 ) )


//somente usada no fopto_21 sincada sefazclass
*+­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
*+
*+    Function tercadecarnaval()
*+
*+­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
*+

FUNCTION TercaDeCarnaval( nAno )

   RETURN DomingoDePascoa( nAno ) - 47
