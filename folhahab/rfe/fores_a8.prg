// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_a8.prg
// +
// +
// +
// +     Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


FUNCTION fores_a8()

   IF !MDG( "Deseja Excluir Lan‡amentos de Demitidos do Ano Anterior" )
      RETU .T.
   ENDIF
   FORESA8( "FO_PFE", "FO_PFE" )
   FORESA8( "FO_RSS", "FO_RSS" )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FORESA8()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FORESA8( cARQ, cIND )

   IF !NETUSE( PES )   // AREDE(PES,PES,0)
      RETU .T.
   ENDIF
   IF !NETUSE( cARQ )  // AREDE(cARQ,cIND,0)
      RETU .T.
   ENDIF ]
   cSELE2 := Alias()
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      dbSelectAr( pes )
      dbGoTop()
      dbSeek( mNUMERO )
      ACHADO := Found()  // usa found softseek para loop
      dbSelectAr( cSELE2 )
      WHILE mNUMERO = NUMERO
         IF !ACHADO
            netrecdel()
         ENDIF
         dbSkip()
      ENDDO
   ENDDO
   dbCloseAll()
   RETU .T.




// + EOF: fores_a8.prg
// +
