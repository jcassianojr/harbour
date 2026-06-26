// fbird_wrappers.prg - Compatibilidade SQLRDD
FUNCTION FBGETBLOB( hEnv, blob_id, hTrans )
   // O SQLRDD moderno trata blobs via FBLINEPROCESSED ou GETDATA.
   // Se o seu sistema chama FBGETBLOB diretamente, você deve implementar 
   // a leitura do blob usando isc_open_blob no C ou retornar um handle.
RETURN NIL

FUNCTION FBFREE( hEnv )
   // FBFREE no legado liberava handles. No FB5, usamos FBCLOSE.
RETURN FBCLOSE( hEnv )

FUNCTION FBQUERY( hEnv, cSql, nDialect, hTrans )
   // FBQUERY é frequentemente um alias para FBEXECUTE no SQLRDD
RETURN FBEXECUTE( hEnv, cSql, nDialect )

FUNCTION FBSTARTTRANSACTION( hEnv )
RETURN FBBEGINTRANSACTION( hEnv )

FUNCTION FBCOMMIT( hTrans )
RETURN FBCOMMITTRANSACTION( hTrans )

FUNCTION FBROLLBACK( hTrans )
RETURN FBROLLBACKTRANSACTION( hTrans )


function hb_timeEncStr()
return 0