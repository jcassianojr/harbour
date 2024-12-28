// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlibarq.prg
// +
// +
// +
// +     Sistema:
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECKARQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CHECKARQ

   PARA cARQ1, cARQ2, cDES, lINDEX, cCAM, nANO, nMES   // recebe Variaveis como privadas sofrer  macro

   IF ValType( lINDEX ) # "L"
      lINDEX := .T.
   ENDIF
   IF ValType( cCAM ) # "C"
      cCAM := ZDIRE
   ENDIF
   IF !File( cCAM + cARQ2 + ".DBF" )   // Cria Arquivos
      MDS( "Aguarde Preparando" )
      CRIARVARS( zARQ )
      CRIARVARS( zARQ1 )
      IF USEREDE( cARQ1, 1, 0 )
         aESTRU := dbStruct()
         dbCloseArea()
         dbCreate( cCAM + cARQ2, aESTRU )
         IGUALVARS( zARQ, cARQ1 )   // Grava Configura‡„o de Arquivo
         mARQUIVO := cARQ2
         IF ValType( cDES ) = "C"
            mDESCRICAO := cDES
         ENDIF
         IF ValType( cCAM ) = "C"
            mCAMINHO := cCAM
            mPADRAO  := "X"
         ENDIF
         IF ValType( nMES ) = "N"
            mARQMES := nMES
         ENDIF
         IF ValType( nANO ) = "N"
            mARQANO := nANO
         ENDIF
         mDRIVER  := "DBFCDX"
         mPULAFIX := "S"
         NOVOREG( zARQ, cARQ2 )
         IF USEREDE( zARQ1, 1, 99 )  // Grava Configura‡„o de Indexa‡„o
            dbGoTop()
            dbSeek( PadR( cARQ1, 8 ) )
            WHILE ARQUIVO = PadR( cARQ1, 8 ) .AND. !Eof()
               REG := RecNo()
               EQUVARS()
               mARQUIVO := cARQ2
               IF Len( cARQ2 ) = 7
                  mINDICE := cARQ2 + StrZero( ITEM, 1 )
               ELSE
                  mINDICE := cARQ2 + StrZero( ITEM, 2 )
               ENDIF
               IF ValType( cDES ) = "C"
                  mDESC := cDES
               ENDIF
               NOVOOPA()
               dbGoto( REG )
               dbSkip()
            ENDDO
            dbCloseArea()
         ENDIF
      ENDIF
      RELEASE ALL LIKE M *
      IF lINDEX
         M_DB( "ARQUIVO=cARQ2" )   // Indexa
      ENDIF
   ENDIF
   RETU .T.


// + EOF: mlibarq.prg
// +
