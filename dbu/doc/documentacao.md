# 📘 Documentacao Tecnica do Projeto
> Gerado em: 06/29/26 16:18:22

## 🏗️ Estrutura de Modulos (PRGs)

### 📄 Arquivo: `adordd.prg`
- Static Function ADO_INIT()
- Static Function ADO_NEW()
- Static Function ADO_CREATE()
- Static Function ADO_CREATEFIELDS()
- Static Function ADO_OPEN()
- Static Function ADO_CLOSE()
- Static Function ADO_GETVALUE()
- Static Function ADO_GOTO()
- Static Function ADO_GOTOID()
- Static Function ADO_GOTOP()
- Static Function ADO_GOBOTTOM()
- Static Function ADO_SKIPRAW()
- Static Function ADO_BOF()
- Static Function ADO_EOF()
- Static Function ADO_DELETED()
- Static Function ADO_DELETE()
- Static Function ADO_RECNO()
- Static Function ADO_RECID()
- Static Function ADO_RECCOUNT()
- Static Function ADO_PUTVALUE()
- Static Function ADO_APPEND()
- Static Function ADO_FLUSH()
- Static Function ADO_ORDINFO()
- Static Function ADO_RECINFO()
- Static Function ADO_FIELDNAME()
- Static Function ADO_FIELDINFO()
- Static Function ADO_ORDLSTFOCUS()
- Static Function ADO_PACK()
- Static Function ADO_RAWLOCK()
- Static Function ADO_LOCK()
- Static Function ADO_UNLOCK()
- Static Function ADO_SETFILTER()
- Static Function ADO_CLEARFILTER()
- Static Function ADO_ZAP()
- Static Function ADO_SETLOCATE()
- Static Function ADO_LOCATE()
- Static Function ADO_CLEARREL()
- Static Function ADO_RELAREA()
- Static Function ADO_RELTEXT()
- Static Function ADO_SETREL()
- Static Function ADO_FORCEREL()
- Static Function ADO_RELEVAL()
- Static Function ADO_ORDLSTADD()
- Static Function ADO_ORDLSTCLEAR()
- Static Function ADO_ORDCREATE()
- Static Procedure ADO_REPORT_ERROR()
- Static Function ADO_ORDDESTROY()
- Static Function ADO_EVALBLOCK()
- Static Function ADO_EXISTS()
- Static Function ADO_DROP()
- Static Function ADO_SEEK()
- Static Function ADO_FOUND()
- Function ADORDD_GETFUNCTABLE()
- Init Procedure ADORDD_INIT()
- Static Function ADO_GETFIELDSIZE()
- Static Function ADO_GETFIELDTYPE()
- Procedure hb_adoSetTable()
- Procedure hb_adoSetEngine()
- Procedure hb_adoSetServer()
- Procedure hb_adoSetUser()
- Procedure hb_adoSetPassword()
- Procedure hb_adoSetQuery()
- Procedure hb_adoSetLocateFor()
- Static Function SQLTranslate()
- Function hb_adoRddGetConnection()
- Function hb_adoRddGetCatalog()
- Function hb_adoRddGetRecordSet()
- Static Function ADO_TRANSBEGIN()
- Static Function ADO_TRANSCOMMIT()
- Static Function ADO_TRANSROLLBACK()

### 📄 Arquivo: `adoxb.prg`
- Function ADOSetRDD()
- Function ADOConnect()
- Function ADODBCREATE()
- Function ADODBCREATESQL()
- Function ADOCREATE()
- Function ADOIndex()
- Function ADOUse()
- Function ADOConnectRemote()
- Function ADOConnected()
- Function ADOMsgAlert()
- Function ADOSetDriver()
- Function ADORDDDefault()
- Function ADOFile()
- Function ADOTABLES()
- Function ADOAlias()
- Function ADOFCount()
- Function ADOSTRU()
- Function ADOBEGINTRANSACTION()
- Function ADOCOMMITTRANSACTION()
- Function GetFieldType()
- Function ADOSetOrder()
- Function ADODISConnect()
- Function ADOAppend()
- Function ADOEdit()
- Function ADOCommit()
- Function ADORequery()
- Function ADOReSync()
- Function ADOUpdateBatch()
- Function ADOCommitAll()
- Function ADOSave()
- Function ADOReglock()
- Function ADOSkip()
- Function ADODelete()
- Function ADOGoTo()
- Function ADOGoTop()
- Function ADOGoBottom()
- Function ADOMoveNext()
- Function ADORecno()
- Function ADORecCount()
- Function ADOSetFilter()
- Function ADODeleted()
- Function ADOClose()
- Function ADOCloseAll()
- Function ADOExecute()
- Function ADOBOF()
- Function ADOEOF()
- Function ADOFOUND()
- Function ADOFind()
- Function ADOLocate()
- Function ADOSort()
- Function ADOFiles()
- Function ADOAREAS()
- Function ADOSelect()
- Function ADOLOG()
- Function ADOReplace()
- Function ADOField()
- Function ADOFieldBlank()
- Function TypeDat()
- Function isRSEmpty()
- Function ADOGetSQL()
- Function ADOUseRemote()
- Function ADORandom()

### 📄 Arquivo: `dbu.prg`
- Function MAIN()
- Function HELP()
- Function DBUDIR()
- Function DBUDELFOR()
- Function DBUREDE()
- Function READDBU()
- Function LNKFUN()
- Function errindex()
- Function errprinter()

### 📄 Arquivo: `dbu2md.prg`
- Function Dbf2md()
- Function Doc_DBF_md()

### 📄 Arquivo: `dbuadox.prg`
- Function adoxmenu()
- Function adoxExecArqSql()
- Function adoxcriadatabase()
- Function adoximpdbf()
- Function adoxexpdbf()
- Function adoxdeltable()
- Function adoxexecsql()

### 📄 Arquivo: `dbucnvmemo.prg`
- Function convertmemo()
- Function converttipo()

### 📄 Arquivo: `dbucopy.prg`
- Function capprep()
- Function copy_title()
- Function trg_getfil()
- Function do_copy()
- Function appe_title()
- Function src_getfil()
- Function do_append()
- Function repl_title()
- Function repl_field()
- Function with_exp()
- Function do_replace()
- Function for_exp()
- Function while_exp()
- Function scope_num()
- Function tog_sdf()
- Function tog_delim()
- Function copybkdbf()

### 📄 Arquivo: `dbudialeto.prg`
- Function ConverterEmptyParaSQL()
- Function DetectarNegacao()
- Function GerarFragmentoSQL()
- Function IsDriverInstalled()
- Function DriverFirebird()
- Function Dialeto_begin()
- Function Dialeto_commit()
- Function Dialeto_rollback()
- Function Dialeto_DataBanco()
- Function Dialeto_DataHoraBanco()
- Function Dialeto_DataVazia()
- Function Dialeto_GetIdentity()
- Function Dialeto_ShowDatabases()
- Function Dialeto_Version()
- Function Dialeto_GetRowCount()
- Function Dialeto_TopPrefix()
- Function Dialeto_TopSuffix()
- Function Dialeto_concat()
- Function Dialeto_condicionais()
- Function Dialeto_SQL()
- Function FormataBlocoSql()
- Function SqliteCreateTable()
- Function geracampodbf()
- Function GERACAMPOADT()
- Function GeraINDICES()

### 📄 Arquivo: `dbudoc.prg`
- Function PEGTIPO2VAL()
- Function GERADOC()
- Function PegcsUB()
- Function multidocs()
- Function multidocg()
- Function FAZERDBF()
- Function GRAVADOC()
- Function TIPOC()
- Function dbuzap()
- Function dbupack()
- Function DBETODBF()
- Function GERADBML()

### 📄 Arquivo: `dbuedi.prg`
- Function EDITXT()

### 📄 Arquivo: `dbuedit.prg`
- Function browse()
- Function xmemo()
- Static Function tog_insert()
- Static Function show_insert()
- Static Function statline()
- Static Function move_ptr()
- Function movp_title()
- Function movp_exp()
- Function do_seek()
- Function do_goto()
- Function do_locate()
- Function do_skip()
- Static Function EmptyFile()
- Static Function DoGet()
- Static Function ExitKey()
- Static Function FreshOrder()
- Static Function Skipped()

### 📄 Arquivo: `dbufire.prg`
- Function Firebirdmenu()
- Function firecreate()
- Static Function fireconnect()
- Function fireverinfo()
- Function fireTABELAS()
- Function fireimpdbf()
- Function fireexpdbf()
- Function firedeltable()
- Function fireExecArqSql()
- Function fireexecuteSQL()

### 📄 Arquivo: `dbuindx.prg`
- Function make_ntx()
- Function ntx_title()
- Function ntx_getfil()
- Function ntx_done()
- Function ntx_exp()
- Function ntx_tag()
- Function ntx_exist()
- Function do_index()

### 📄 Arquivo: `dbuleto.prg`
- Function letomenu()
- Function LETO_SRVTODBF()
- Function LETO_DELDBF()
- Function leto_errocon()
- Function leto_expformat()
- Function LETO_DBFTOSRV()
- Function LETO_INFO()
- Function leto_tables()

### 📄 Arquivo: `dbulib.prg`
- Function inputbox()
- Function LAYOUT()
- Function MD()
- Function MDT()
- Function XEXT()
- Function EINDEXCOMPOUND()
- Function MENUSQL()
- Function tipodbfesc()
- Function RDDNOME()
- Function pegtipodoc()
- Function pegparexp()
- Function checkanofor()
- Function checkextEXP()
- Function copiardbfpara()
- Function COPYTO()
- Function APPENDFROM()
- Function formatacpf()

### 📄 Arquivo: `dbumix.prg`
- Function mixmenu()
- Function mixexpdbf()
- Function mixExecArqSql()
- Function miximpdbf()
- Function mixcreatedatabase()
- Function mix_executesql()
- Function mix_Query()
- Function mix_open()
- Function mix_close()
- Function mix_AFFECTEDROWS()
- Function mix_Conn()
- Function mixexpformat()

### 📄 Arquivo: `dbumy.prg`
- Function mysqlmenu()
- Function MYDELTABLE()
- Function MYSELECTDB()
- Function MYSELECTTABLE()
- Function mysqlnewdatabase()
- Function mystrudbf()
- Function mystrutodbf()
- Function dbf2mysql()
- Function myExecArqSql()

### 📄 Arquivo: `dbumyexp.prg`
- Function myexpformat()

### 📄 Arquivo: `dbuodbc.prg`
- Function odbcmenu()
- Function odbccriadatabase()
- Function odbcExecArqSql()
- Function odbcimpdbf()
- Function odbcexpdbf()
- Function odbcdeltable()
- Function odbcexecsql()

### 📄 Arquivo: `dbuparadox.prg`
- Function ParadoxCreateTable()
- Function DBF2Paradox()
- Function DBF2Paradoxadordd()

### 📄 Arquivo: `dbupg.prg`
- Function pgsqlmenu()
- Function pgExecArqSql()
- Function PGDELTABLE()
- Function PGSELECTTABLE()
- Function pgsetdatabase()
- Function PGsqlnewdatabase()
- Function PGstrudbf()
- Function PGstrutodbf()
- Function dbf2pgsql()

### 📄 Arquivo: `dbupgexp.prg`
- Function PGexpformat()

### 📄 Arquivo: `dbusincdbf.prg`
- Function dBUsincdbf()
- Function sortdbf()
- Static Function ValidarCampos()
- Function limparegdupdbf()

### 📄 Arquivo: `dbustru.prg`
- Function modi_stru()
- Function stru_row()
- Function stru_item()
- Function no_append()
- Function stru_ck()
- Function field_check()
- Function stru_title()
- Function do_modstru()

### 📄 Arquivo: `dbutclass.prg`
- Function tclassmenu()
- Function tclass_open()
- Function tclass_exec_script()
- Function tclass_checkconn()
- Function tclass_close()
- Function tclass_TABELAS()
- Function tclass_deltable()
- Function tclass_createdatabase()
- Function tclass_impdbf()
- Function tclass_executesql()
- Function tclass_expdbf()

### 📄 Arquivo: `dbuutil.prg`
- Function setup()
- Function multibox()
- Function matrix()
- Function to_ok()
- Function to_can()
- Function ok_button()
- Function can_button()
- Function filelist()
- Function fieldlist()
- Function itemlist()
- Function i_func()
- Function getfile()
- Function g_getfile()
- Function genfield()
- Function get_exp()
- Function not_empty()
- Function filebox()
- Function box_title()
- Function get_k_trim()
- Function sysmenu()
- Function menu_key()
- Function mu_func()
- Function xkey_clear()
- Function xkey_norm()
- Function lite_fkey()
- Function dim_fkey()
- Function key_ready()
- Function read_key()
- Function raw_key()
- Function q_check()
- Function clear_gets()
- Function all_fields()
- Function not_target()
- Function dup_ntx()
- Function stat_msg()
- Function error_msg()
- Function error_off()
- Function rsvp()
- Function name()
- Function pad()
- Function aseek()
- Function array_ins()
- Function array_del()
- Function afull()
- Function array_sort()
- Function array_dir()
- Function ntx_key()
- Function isdata()
- Function lpad()
- Function hi_cur()
- Function dehi_cur()
- Function enter_rc()
- Function OBTER()

### 📄 Arquivo: `dbuver.prg`
- Function VERTXT()

### 📄 Arquivo: `dbuview.prg`
- Function SET_VIEW()
- Function channel()
- Function bar_menu()
- Function bar_func()
- Function list_array()
- Function set_deflt()
- Function bline()
- Function draw_view()
- Function d_copy()
- Function open_dbf()
- Function dopen_titl()
- Function do_opendbf()
- Function get_ntx()
- Function xopen_titl()
- Function do_openntx()
- Function get_field()
- Function getfield()
- Function fsel_title()
- Function do_fsel()
- Function set_relation()
- Function draw_relat()
- Function get_relation()
- Function disp_relation()
- Function c_search()
- Function ctrl_key()
- Function get_filter()
- Function fltr_title()
- Function getfilter()
- Function do_filter()
- Function clear_dbf()
- Function save_view()
- Function vcrea_titl()
- Function do_creavew()
- Function put_line()
- Function set_from()
- Function vopen_titl()
- Function do_openvew()
- Function get_line()

### 📄 Arquivo: `dbuxlsclass.prg`
- Procedure Fazerxlsclass()

### 📄 Arquivo: `dbuxlsxml.prg`
- Procedure Fazerxlsxlm()

### 📄 Arquivo: `dbuxml.prg`
- Function Dbf2Xml()
- Function GetXMLString()
- Function TIPOXML()

### 📄 Arquivo: `mdb2dbf.prg`
- Function mdbmenu()
- Function pegcfgbanco()
- Function ExecArqSql()
- Function mdbdatabases()
- Function mdbtabela()
- Function MDBEXP()
- Function sqltodbfstru()
- Function opencmdbarq()
- Function mdbcria()
- Function DBF2MDB()
- Function OPENTIPOARQ()
- Function buscachaves()
- Function MDBIMPDBF()
- Function MDBTABLES()
- Function TipoDado2()
- Function Adotipodbf()
- Function geraconn()
- Function executacmd()
- Function CreateAccessDatabase()
- Function mdltodos()
- Function sqltodos()

### 📄 Arquivo: `mysqlrdd.prg`
- Function DBMYSQLCONNECTION()
- Function DBMYSTRU()
- Function DBMYSQLCLEARCONNECTION()
- Static Function MYSQL_INIT()
- Static Function MYSQL_NEW()
- Static Function MYSQL_OPEN()
- Static Function MYSQL_CLOSE()
- Static Function MYSQL_GETVALUE()
- Static Function MYSQL_PUTVALUE()
- Static Function MYSQL_SKIP()
- Static Function MYSQL_GOTOP()
- Static Function MYSQL_GOBOTTOM()
- Static Function MYSQL_GOTOID()
- Static Function MYSQL_GOTO()
- Static Function MYSQL_RECCOUNT()
- Static Function MYSQL_BOF()
- Static Function MYSQL_EOF()
- Static Function MYSQL_RECID()
- Static Function MYSQL_DELETED()
- Static Function MYSQL_FLUSH()
- Static Function MYSQL_APPEND()
- Static Function MYSQL_DELETE()
- Function MYSQLRDD_GETFUNCTABLE()
- Init Procedure MYSQL_INIT()

### 📄 Arquivo: `pgrdd.prg`
- Function DBPGCONNECTION()
- Function DBPGCLEARCONNECTION()
- Static Function PG_INIT()
- Static Function PG_NEW()
- Static Function PG_OPEN()
- Static Function PG_CLOSE()
- Static Function PG_GETVALUE()
- Static Function PG_PUTVALUE()
- Static Function PG_SKIP()
- Static Function PG_GOTOP()
- Static Function PG_GOBOTTOM()
- Static Function PG_GOTOID()
- Static Function PG_GOTO()
- Static Function PG_RECCOUNT()
- Static Function PG_BOF()
- Static Function PG_EOF()
- Static Function PG_RECID()
- Static Function PG_DELETED()
- Static Function PG_FLUSH()
- Static Function PG_APPEND()
- Static Function PG_DELETE()
- Function PGRDD_GETFUNCTABLE()
- Init Procedure PG_INIT()

### 📄 Arquivo: `sql2dbf.prg`
- Function sqlitemenu()
- Function SqliteArqSql()
- Function sqllitedeltable()
- Function exportadbf()
- Function C2SQLTS()
- Function C2SQL()
- Function sqltablestru()
- Function sqlitepack()
- Function optimize_sqlite()
- Function check_sqlite()
- Function selectdb()
- Function SqliteTables()
- Function connect2db()
- Function createSqlitedb()
- Function export2dbf()
- Function miscsql()
- Function export2sql()
- Function MDPCHAVEI()
- Function DocMarkdow()
- Function Doc_SQLite()

### 📄 Arquivo: `Tdbclass.prg`
- Class TDatabase
- Class TDBFTable
- Class TSQLite
- Class TMySQL
- Class TMariaDB
- Class TPostgreSQL
- Class TFirebird
- Class TSQLServer
- Class TOracle
- Class TMongoDB

### 📄 Arquivo: `xlsxclass.prg`
- Class WorkBook
- Class DrawingML
- Class WorkSheet
- Static Function ColumnIndexToColumnLetter()
- Static Procedure MyZip()
- Static Function ReplaceAmp()
- Static Function my_UnZipFile()
- Static Function FilePath()

## 📊 Dicionario de Dados e Acessos

**Fonte:** `Tdbclass.prg`
> Tables: dbUseArea(.T.,::cRDD,::cDatabase,::cAlias,.F.,::lReadOnly)
> dbUseArea(.T.,::cRDD,::cDatabase,::cAlias,.T.,::lReadOnly)
> dbUseArea(.T.,::cRDD,::cDatabase,::cAlias,!::lExclusive,::lReadOnly)

**Fonte:** `dbu.prg`
> Tables: dbUseArea(.T.,USOVIA,(cARQ),,.F.,.F.)
> dbUseArea(.T.,USOVIA,(cARQ),,.T.,.F.)

**Fonte:** `dbuadox.prg`
> Tables: dbUseArea(.T.,cORIDRIVER,cARQORI,cTABLE,.T.,.T.)
> dbUseArea(.T.,"DBFCDX",cDESTINO,"DESTINO",.T.,.F.)

**Fonte:** `dbucnvmemo.prg`
> Tables: dbUseArea(.T.,(cORIDRIVER),(cOLDDBF),"aliasantigo",.T.,.F.)
> dbUseArea(.T.,(cDESDRIVER),(cNEWDBF),"aliasnovo",.F.,.F.)
> dbUseArea(.T.,(cORIDRIVER),(cOLDDBF),"aliasantigo",.T.,.F.)
> dbUseArea(.T.,(cDESDRIVER),(cNEWDBF),"aliasnovo",.F.,.F.)
> Indexes: INDEX ON &cINDEXCHAVE TAG &cINDEXNAME //TO &cARQINDEX
> INDEX ON &cINDEXCHAVE TO &cARQINDEX

**Fonte:** `dbufire.prg`
> Tables: dbUseArea(.T.,cORIDRIVER,cARQORI,cTABLE,.T.,.T.)
> dbUseArea(.T.,"DBFCDX",cDESTINO,"DESTINO",.T.,.F.)

**Fonte:** `dbuleto.prg`
> Tables: dbUseArea(.T.,,cTABELAX,,.T.)

**Fonte:** `dbulib.prg`
> Tables: dbUseArea(.T.,(cORIDRIVER),(cARQORI),"ORIGEM",.F.,.F.)
> dbUseArea(.T.,(cORIDRIVER),(cDESTINO),"DESTINO",.F.,.F.)

**Fonte:** `dbumix.prg`
> Tables: dbUseArea(.T.,,"SELECT * FROM "+cTABELAX,"ORIGEM")
> dbUseArea(.T.,"DBFCDX",cDESTINO,"DESTINO",.T.,.F.)
> dbUseArea(.T.,cORIDRIVER,cARQORI,cTABLE,.T.,.T.)
> dbUseArea(.T.,,"SELECT * FROM "+cTABELAX,cTABELAX)

**Fonte:** `dbumy.prg`
> Tables: dbUseArea(.T.,"DBFCDX",ctabelaX+"_mysql",,.F.,.F.)
> dbUseArea(.T.,,cARQORI,"dbffile",,.T.)

**Fonte:** `dbumyexp.prg`
> Tables: dbUseArea(.T.,"MYSQLRDD","SELECT * FROM "+cTABELAX,cTABELAX)

**Fonte:** `dbuodbc.prg`
> Tables: dbUseArea(.T.,cORIDRIVER,cARQORI,cTABLE,.T.,.T.)
> dbUseArea(.T.,"DBFCDX",cDESTINO,"DESTINO",.T.,.F.)

**Fonte:** `dbuparadox.prg`
> Tables: USE (cDbfOrigem) ALIAS ORIGEM SHARED NEW
> dbUseArea(.F.,,cDbfOrigem,"ORIGEM",.T.,.F.)
> dbUseArea(.F.,"ADORDD",(cParadoxDestino),"DESTINO",.T.,.F.)

**Fonte:** `dbupg.prg`
> Tables: dbUseArea(.T.,"DBFCDX",ctabelaX+"_pgsql",,.F.,.F.)
> dbUseArea(.T.,,cARQORI,"dbffile",,.T.)

**Fonte:** `dbupgexp.prg`
> Tables: dbUseArea(.T.,"PGRDD","SELECT * FROM "+Chr(34)+cTABELAX+Chr(34),cTABELAX)

**Fonte:** `dbusincdbf.prg`
> Tables: dbUseArea(.T.,(cORIDRIVER),(cARQORI),"ORIGEM",.T.,.F.)
> dbUseArea(.T.,(cDESDRIVER),(cARQDES),"DESTINO",.F.,.F.)
> dbUseArea(.T.,(cORIDRIVER),(cARQORI),"ORIGEM",.F.,.F.)
> dbUseArea(.T.,(cORIDRIVER),(cARQORI),"ORIGEM",.F.,.F.)

**Fonte:** `dbutclass.prg`
> Tables: dbUseArea(.T.,RDDNOME(TIPODBF),cARQORI,cTABLE,.T.,.T.)
> dbUseArea(.T.,"DBFCDX",cDESTINO,"DESTINO",.T.,.F.)

**Fonte:** `dbuutil.prg`
> Tables: dbUseArea(.T.,,XARQ,,.T.,.F.)

**Fonte:** `mdb2dbf.prg`
> Tables: DBUseArea(.T.,,ctabela+"_"+Ctiposql,,.F.,.F.)
> dbUseArea(.F.,"ADORDD",(cMDBARQ),,.T.,.F.)
> dbUseArea(.F.,,cDBFARQ,,.T.,.F.)

**Fonte:** `sql2dbf.prg`
> Tables: dbUseArea(.T.,"DBFCDX",cNewTable,"DESTINO",.T.,.F.)
> dbUseArea(.T.,(cORIDRIVER),(cARQORI),,.T.,.F.) //dbUseArea( .T., ( cORIDRIVER ), ( cARQORI ), "ORIGEM", .T. , .F. )

## 🕸️ Diagrama de Relacionamento (Mermaid)
```mermaid
graph TD
    dbuedit_prg --> REF()             <unresolved function>
    tdbclass_prg --> __eof()         <unresolved function>
    tdbclass_prg --> __execute()     <unresolved function>
    tdbclass_prg --> __fireerror()   <unresolved function>
    tdbclass_prg --> __loadcursor()  <unresolved function>
    tdbclass_prg --> __query()       <unresolved function>
    tdbclass_prg --> __super_new()   <unresolved function>
    adoxb_prg --> __writecell()   <unresolved function>
    adoxb_prg --> _addnew()       <unresolved function>
    mysqlrdd_prg --> _append()       <unresolved function>
    adoxb_prg --> _bof()          <unresolved function>
    adordd_prg --> _cancel()       <unresolved function>
    adordd_prg --> _close()        <unresolved function>
    adordd_prg --> _columns()      <unresolved function>
    adoxb_prg --> _columns()      <unresolved function>
    adoxb_prg --> _delete()       <unresolved function>
    adoxb_prg --> _edit()         <unresolved function>
    adoxb_prg --> _end()          <unresolved function>
    adoxb_prg --> _eof()          <unresolved function>
    mysqlrdd_prg --> _errormsg()     <unresolved function>
    adordd_prg --> _execute()      <unresolved function>
    mysqlrdd_prg --> _fieldget()     <unresolved function>
    mysqlrdd_prg --> _fieldput()     <unresolved function>
    adoxb_prg --> _fields()       <unresolved function>
    adoxb_prg --> _fields_count() <unresolved function>
    adoxb_prg --> _find()         <unresolved function>
    mysqlrdd_prg --> _getblankrow()  <unresolved function>
    mysqlrdd_prg --> _getrow()       <unresolved function>
    mysqlrdd_prg --> _goto()         <unresolved function>
    adordd_prg --> _indexes()      <unresolved function>
    adordd_prg --> _indexes()      <unresolved function>
    adordd_prg --> _indexes()      <unresolved function>
    adordd_prg --> _keys()         <unresolved function>
    adordd_prg --> _keys_append()  <unresolved function>
    adordd_prg --> _keys_count()   <unresolved function>
    adordd_prg --> _keys_delete()  <unresolved function>
    mysqlrdd_prg --> _lastrec()      <unresolved function>
    adoxb_prg --> _move()         <unresolved function>
    adoxb_prg --> _movefirst()    <unresolved function>
    adoxb_prg --> _movelast()     <unresolved function>
    adoxb_prg --> _movenext()     <unresolved function>
    dbufire_prg --> _new()          <unresolved function>
    adordd_prg --> _open()         <unresolved function>
    adordd_prg --> _openschema()   <unresolved function>
    mysqlrdd_prg --> _recno()        <unresolved function>
    adoxb_prg --> _recordcount()  <unresolved function>
    mysqlrdd_prg --> _refresh()      <unresolved function>
    adoxb_prg --> _requery()      <unresolved function>
    adoxb_prg --> _resync()       <unresolved function>
    adoxb_prg --> _save()         <unresolved function>
    mysqlrdd_prg --> _skip()         <unresolved function>
    adoxb_prg --> _sql()          <unresolved function>
    adoxb_prg --> _table()        <unresolved function>
    adordd_prg --> _tables()       <unresolved function>
    adoxb_prg --> _update()       <unresolved function>
    adoxb_prg --> _updatebatch()  <unresolved function>
    dbu_prg --> ac_agudo()      <unresolved function>
    dbu_prg --> ac_circ()       <unresolved function>
    dbu_prg --> ac_crase()      <unresolved function>
    dbu_prg --> ac_til()        <unresolved function>
    dbuadox_prg --> adoappend()     in adoxb.prg
    adoxb_prg --> adobof()        in adoxb.prg
    dbuadox_prg --> adoclose()      in adoxb.prg
    dbuadox_prg --> adocommit()     in adoxb.prg
    dbuadox_prg --> adoconnect()    in adoxb.prg
    dbuadox_prg --> adodisconnect() in adoxb.prg
    adoxb_prg --> adoeof()        in adoxb.prg
    dbuadox_prg --> adoexecute()    in adoxb.prg
    dbuadox_prg --> adofield()      in adoxb.prg
    adoxb_prg --> adofile()       in adoxb.prg
    adoxb_prg --> adogotop()      in adoxb.prg
    adoxb_prg --> adolocate()     in adoxb.prg
    adoxb_prg --> adolog()        in adoxb.prg
    dbuadox_prg --> adomovenext()   in adoxb.prg
    adoxb_prg --> adorandom()     in adoxb.prg
    adoxb_prg --> adordddefault() in adoxb.prg
    adoxb_prg --> adoreccount()   in adoxb.prg
    dbuadox_prg --> adoreplace()    in adoxb.prg
    dbuadox_prg --> adoselect()     in adoxb.prg
    dbuadox_prg --> adosetrdd()     in adoxb.prg
    dbuadox_prg --> adostru()       in adoxb.prg
    dbuadox_prg --> adotables()     in adoxb.prg
    dbuadox_prg --> adouse()        in adoxb.prg
    dbuadox_prg --> adouse()        in adoxb.prg
    dbuadox_prg --> adoxdeltable()  in dbuadox.prg
    dbuadox_prg --> adoxexecarqsql( in dbuadox.prg
    dbuadox_prg --> adoxexecsql()   in dbuadox.prg
    dbuadox_prg --> adoxexpdbf()    in dbuadox.prg
    dbuadox_prg --> adoximpdbf()    in dbuadox.prg
    dbulib_prg --> adoxmenu()      in dbuadox.prg
    adordd_prg --> ado_append()    in adordd.prg
    adordd_prg --> ado_bof()       in adordd.prg
    adordd_prg --> ado_bof()       in adordd.prg
    adordd_prg --> ado_clearrel()  in adordd.prg
    adordd_prg --> ado_close()     in adordd.prg
    adordd_prg --> ado_create()    in adordd.prg
    adordd_prg --> ado_create()    in adordd.prg
    adordd_prg --> ado_delete()    in adordd.prg
    adordd_prg --> ado_deleted()   in adordd.prg
    adordd_prg --> ado_drop()      in adordd.prg
    adordd_prg --> ado_eof()       in adordd.prg
    adordd_prg --> ado_evalblock() in adordd.prg
    adordd_prg --> ado_exists()    in adordd.prg
    adordd_prg --> ado_fieldinfo() in adordd.prg
    adordd_prg --> ado_fieldname() in adordd.prg
    adordd_prg --> ado_flush()     in adordd.prg
    adordd_prg --> ado_forcerel()  in adordd.prg
    adordd_prg --> ado_found()     in adordd.prg
    adordd_prg --> ado_found()     in adordd.prg
    adordd_prg --> ado_found()     in adordd.prg
    adordd_prg --> ado_getvalue()  in adordd.prg
    adordd_prg --> ado_gobottom()  in adordd.prg
    adordd_prg --> ado_goto()      in adordd.prg
    adordd_prg --> ado_gotoid()    in adordd.prg
    adordd_prg --> ado_gotop()     in adordd.prg
    adordd_prg --> ado_init()      in adordd.prg
    adordd_prg --> ado_locate()    in adordd.prg
    adordd_prg --> ado_lock()      in adordd.prg
    adordd_prg --> ado_new()       in adordd.prg
    adordd_prg --> ado_open()      in adordd.prg
    adordd_prg --> ado_ordcreate() in adordd.prg
    adordd_prg --> ado_orddestroy( in adordd.prg
    adordd_prg --> ado_ordinfo()   in adordd.prg
    adordd_prg --> ado_ordlstadd() in adordd.prg
    adordd_prg --> ado_ordlstadd() in adordd.prg
    adordd_prg --> ado_ordlstadd() in adordd.prg
    adordd_prg --> ado_pack()      in adordd.prg
    adordd_prg --> ado_putvalue()  in adordd.prg
    adordd_prg --> ado_rawlock()   in adordd.prg
    adordd_prg --> ado_reccount()  in adordd.prg
    adordd_prg --> ado_recid()     in adordd.prg
    adordd_prg --> ado_recinfo()   in adordd.prg
    adordd_prg --> ado_recno()     in adordd.prg
    adordd_prg --> ado_relarea()   in adordd.prg
    adordd_prg --> ado_releval()   in adordd.prg
    adordd_prg --> ado_reltext()   in adordd.prg
    adordd_prg --> ado_seek()      in adordd.prg
    adordd_prg --> ado_setfilter() in adordd.prg
    adordd_prg --> ado_setlocate() in adordd.prg
    adordd_prg --> ado_setrel()    in adordd.prg
    adordd_prg --> ado_skipraw()   in adordd.prg
    adordd_prg --> ado_transbegin( in adordd.prg
    adordd_prg --> ado_transbegin( in adordd.prg
    adordd_prg --> ado_transbegin( in adordd.prg
    adordd_prg --> ado_unlock()    in adordd.prg
    adordd_prg --> ado_zap()       in adordd.prg
    dbulib_prg --> adssetfiletype( <unresolved function>
    dbulib_prg --> adssetfiletype( <unresolved function>
    dbucopy_prg --> afull()         in dbuutil.prg
    dbu_prg --> alertx()        <unresolved function>
    dbu_prg --> all_fields()    in dbuutil.prg
    tdbclass_prg --> append()        <unresolved function>
    dbulib_prg --> appendfrom()    in dbulib.prg
    dbuutil_prg --> array_del()     in dbuutil.prg
    dbu_prg --> array_dir()     in dbuutil.prg
    dbuview_prg --> array_ins()     in dbuutil.prg
    dbucopy_prg --> array_sort()    in dbuutil.prg
    dbucopy_prg --> aseek()         in dbuutil.prg
    dbuview_prg --> bar_menu()      in dbuview.prg
    tdbclass_prg --> bar_menu()      in dbuview.prg
    dbuview_prg --> bline()         in dbuview.prg
    dbucopy_prg --> box_title()     in dbuutil.prg
    mdb2dbf_prg --> buscachaves()   in mdb2dbf.prg
    sql2dbf_prg --> c2sqlts()       in sql2dbf.prg
    dbu_prg --> capprep()       in dbucopy.prg
    dbuview_prg --> channel()       in dbuview.prg
    dbulib_prg --> checkanofor()   in dbulib.prg
    dbulib_prg --> checkextexp()   in dbulib.prg
    sql2dbf_prg --> check_sqlite()  in sql2dbf.prg
    dbuview_prg --> clear_dbf()     in dbuview.prg
    tdbclass_prg --> close()         <unresolved function>
    dbudoc_prg --> clscor()        <unresolved function>
    tdbclass_prg --> commit()        <unresolved function>
    sql2dbf_prg --> connect2db()    in sql2dbf.prg
    dbu_prg --> convertmemo()   in dbucnvmemo.prg
    dbu_prg --> converttipo()   in dbucnvmemo.prg
    dbuedit_prg --> convmais()      <unresolved function>
    dbuedit_prg --> convmini()      <unresolved function>
    dbu_prg --> copiardbfpara() in dbulib.prg
    dbu_prg --> copybkdbf()     in dbucopy.prg
    dbulib_prg --> copyto()        in dbulib.prg
    adoxb_prg --> copyto()        in dbulib.prg
    tdbclass_prg --> createindex()   <unresolved function>
    sql2dbf_prg --> createsqlitedb( in sql2dbf.prg
    tdbclass_prg --> createtable()   <unresolved function>
    dbumix_prg --> cstr()          <unresolved function>
    dbuview_prg --> ctrl_key()      in dbuview.prg
    dbuview_prg --> c_search()      in dbuview.prg
    dbudoc_prg --> data2str()      <unresolved function>
    dbuadox_prg --> dbdrop()        <unresolved function>
    dbu_prg --> dbetodbf()      in dbudoc.prg
    dbudoc_prg --> dbf2md()        in dbu2md.prg
    mdb2dbf_prg --> dbf2mdb()       in mdb2dbf.prg
    dbumy_prg --> dbf2mysql()     in dbumy.prg
    dbuadox_prg --> dbf2paradox()   in dbuparadox.prg
    dbupg_prg --> dbf2pgsql()     in dbupg.prg
    dbudoc_prg --> dbf2xml()       in dbuxml.prg
    dbumyexp_prg --> dbf2xml()       in dbuxml.prg
    dbumyexp_prg --> dbf2xml()       in dbuxml.prg
    dbupgexp_prg --> dbf2xml()       in dbuxml.prg
    dbupgexp_prg --> dbpgconnection( in pgrdd.prg
    dbu_prg --> dbudelfor()     in dbu.prg
    dbu_prg --> dbudir()        in dbu.prg
    dbu_prg --> dbupack()       in dbudoc.prg
    dbu_prg --> dburede()       in dbu.prg
    dbu_prg --> dbusincdbf()    in dbusincdbf.prg
    dbu_prg --> dbuzap()        in dbudoc.prg
    dbu_prg --> decode()        <unresolved function>
    dbu_prg --> dehi_cur()      in dbuutil.prg
    dbucopy_prg --> deletefile()    <unresolved function>
    dbumix_prg --> dialeto_begin() in dbudialeto.prg
    dbumix_prg --> dialeto_commit( in dbudialeto.prg
    dbudoc_prg --> dialeto_commit( in dbudialeto.prg
    mdb2dbf_prg --> dialeto_commit( in dbudialeto.prg
    mdb2dbf_prg --> dialeto_commit( in dbudialeto.prg
    dbuutil_prg --> dim_fkey()      in dbuutil.prg
    dbuview_prg --> disp_relation() in dbuview.prg
    dbudoc_prg --> docmarkdow()    in sql2dbf.prg
    dbu2md_prg --> doc_dbf_md()    in dbu2md.prg
    sql2dbf_prg --> doc_sqlite()    in sql2dbf.prg
    dbuedit_prg --> doget()         in dbuedit.prg
    dbuview_prg --> do_fsel()       in dbuview.prg
    dbuview_prg --> do_opendbf()    in dbuview.prg
    dbuview_prg --> do_openntx()    in dbuview.prg
    dbuview_prg --> do_openvew()    in dbuview.prg
    dbuview_prg --> draw_relat()    in dbuview.prg
    dbuview_prg --> draw_view()     in dbuview.prg
    adordd_prg --> driverfirebird( in dbudialeto.prg
    dbuodbc_prg --> driverfirebird( in dbudialeto.prg
    dbuodbc_prg --> driverfirebird( in dbudialeto.prg
    dbuodbc_prg --> driverfirebird( in dbudialeto.prg
    dbuodbc_prg --> driverfirebird( in dbudialeto.prg
    dbuodbc_prg --> driverfirebird( in dbudialeto.prg
    dbuodbc_prg --> driverfirebird( in dbudialeto.prg
    dbuodbc_prg --> driverfirebird( in dbudialeto.prg
    dbuodbc_prg --> driverfirebird( in dbudialeto.prg
    dbuindx_prg --> dup_ntx()       in dbuutil.prg
    dbuview_prg --> d_copy()        in dbuview.prg
    dbuedi_prg --> editarq()       <unresolved function>
    dbuedit_prg --> emptyfile()     in dbuedit.prg
    dbu_prg --> encode()        <unresolved function>
    dbu_prg --> enter_rc()      in dbuutil.prg
    adordd_prg --> errornew()      <unresolved function>
    dbu_prg --> error_msg()     in dbuutil.prg
    dbuutil_prg --> error_off()     in dbuutil.prg
    mdb2dbf_prg --> execarqsql()    in mdb2dbf.prg
    mdb2dbf_prg --> executacmd()    in mdb2dbf.prg
    tdbclass_prg --> execute()       <unresolved function>
    dbuedit_prg --> exitkey()       in dbuedit.prg
    sql2dbf_prg --> export2dbf()    in sql2dbf.prg
    sql2dbf_prg --> export2sql()    in sql2dbf.prg
    sql2dbf_prg --> exportadbf()    in sql2dbf.prg
    dbu_prg --> fazerdbf()      in dbudoc.prg
    dbudoc_prg --> fazerxlsclass() in dbuxlsclass.prg
    dbudoc_prg --> fazerxlsxlm()   in dbuxlsxml.prg
    dbufire_prg --> fbcreatedb()    <unresolved function>
    tdbclass_prg --> fieldcount()    <unresolved function>
    dbu2md_prg --> fielddec()      <unresolved function>
    dbu2md_prg --> fieldlen()      <unresolved function>
    dbu2md_prg --> fieldtype()     <unresolved function>
    dbustru_prg --> field_check()   in dbustru.prg
    dbustru_prg --> filebox()       in dbuutil.prg
    dbucopy_prg --> filelist()      in dbuutil.prg
    dbudoc_prg --> filenames()     <unresolved function>
    dbulib_prg --> firebirdmenu()  in dbufire.prg
    dbufire_prg --> fireconnect()   in dbufire.prg
    dbufire_prg --> firecreate()    in dbufire.prg
    dbufire_prg --> firedeltable()  in dbufire.prg
    tdbclass_prg --> fireerror()     <unresolved function>
    dbufire_prg --> fireexecarqsql( in dbufire.prg
    dbufire_prg --> fireexecutesql( in dbufire.prg
    dbufire_prg --> fireexpdbf()    in dbufire.prg
    dbufire_prg --> fireimpdbf()    in dbufire.prg
    dbufire_prg --> firetabelas()   in dbufire.prg
    dbufire_prg --> fireverinfo()   in dbufire.prg
    mdb2dbf_prg --> fixint()        <unresolved function>
    dbupg_prg --> fixnum()        <unresolved function>
    dbuadox_prg --> fixnum()        <unresolved function>
    dbucopy_prg --> flinecount()    <unresolved function>
    dbudoc_prg --> flinecount()    <unresolved function>
    dbuedit_prg --> freshorder()    in dbuedit.prg
    dbucopy_prg --> genfield()      in dbuutil.prg
    dbufire_prg --> geracampodbf()  in dbudialeto.prg
    adoxb_prg --> geraconn()      in mdb2dbf.prg
    dbudoc_prg --> geradbml()      in dbudoc.prg
    dbu_prg --> geradoc()       in dbudoc.prg
    dbu2md_prg --> geraindices()   in dbudialeto.prg
    dbucopy_prg --> getfile()       in dbuutil.prg
    dbuxml_prg --> getxmlstring()  in dbuxml.prg
    dbucopy_prg --> get_exp()       in dbuutil.prg
    dbuview_prg --> get_field()     in dbuview.prg
    dbuview_prg --> get_filter()    in dbuview.prg
    dbuedit_prg --> get_k_trim()    in dbuutil.prg
    dbuview_prg --> get_line()      in dbuview.prg
    dbuview_prg --> get_ntx()       in dbuview.prg
    dbuview_prg --> get_relation()  in dbuview.prg
    tdbclass_prg --> gobottom()      <unresolved function>
    tdbclass_prg --> goto()          <unresolved function>
    tdbclass_prg --> gotop()         <unresolved function>
    dbudoc_prg --> gravadoc()      in dbudoc.prg
    tdbclass_prg --> hbmysql_close() <unresolved function>
    tdbclass_prg --> hbmysql_error() <unresolved function>
    tdbclass_prg --> hbmysql_exec()  <unresolved function>
    tdbclass_prg --> hbmysql_fields( <unresolved function>
    tdbclass_prg --> hbmysql_lastid( <unresolved function>
    tdbclass_prg --> hbmysql_open()  <unresolved function>
    tdbclass_prg --> hbmysql_query() <unresolved function>
    tdbclass_prg --> hbmysql_tables( <unresolved function>
    tdbclass_prg --> hbpgsql_close() <unresolved function>
    tdbclass_prg --> hbpgsql_error() <unresolved function>
    tdbclass_prg --> hbpgsql_exec()  <unresolved function>
    tdbclass_prg --> hbpgsql_fields( <unresolved function>
    tdbclass_prg --> hbpgsql_lastid( <unresolved function>
    tdbclass_prg --> hbpgsql_open()  <unresolved function>
    tdbclass_prg --> hbpgsql_query() <unresolved function>
    tdbclass_prg --> hbpgsql_tables( <unresolved function>
    adordd_prg --> hbpgsql_tables( <unresolved function>
    mdb2dbf_prg --> hbpgsql_tables( <unresolved function>
    mdb2dbf_prg --> hbpgsql_tables( <unresolved function>
    mdb2dbf_prg --> hb_adosetuser() in adordd.prg
    dbulib_prg --> hb_alert()      in harbour.lib
    dbu_prg --> hb_aparams()    in harbour.lib
    dbumy_prg --> hb_ascan()      in harbour.lib
    dbuutil_prg --> hb_bsubstr()    in harbour.lib
    dbu_prg --> hb_ctod()       in harbour.lib
    dbu_prg --> hb_ctot()       in harbour.lib
    dbu_prg --> hb_cwd()        in harbour.lib
    dbu_prg --> hb_datetime()   in harbour.lib
    mysqlrdd_prg --> hb_decode()     in xhb.lib
    adordd_prg --> hb_default()    in harbour.lib
    dbuadox_prg --> hb_dispbox()    in harbour.lib
    dbu_prg --> hb_dtoc()       in harbour.lib
    adordd_prg --> hb_eol()        in harbour.lib
    tdbclass_prg --> hb_fielddec()   in harbour.lib
    tdbclass_prg --> hb_fieldlen()   in harbour.lib
    tdbclass_prg --> hb_fieldtype()  in harbour.lib
    adordd_prg --> hb_fileexists() in harbour.lib
    adordd_prg --> hb_fnamedir()   in harbour.lib
    adordd_prg --> hb_fnamesplit() in harbour.lib
    dbuutil_prg --> hb_fopen()      <unresolved function>
    dbu_prg --> hb_gtinfo()     in harbour.lib
    dbuleto_prg --> hb_gzcompress() in harbour.lib
    dbu_prg --> hb_hour()       in harbour.lib
    dbudoc_prg --> hb_hset()       in harbour.lib
    dbu_prg --> hb_idlestate()  in harbour.lib
    dbumix_prg --> hb_isnil()      in harbour.lib
    adordd_prg --> hb_isnumeric()  in harbour.lib
    dbudoc_prg --> hb_jsonencode() in harbour.lib
    adordd_prg --> hb_langerrmsg() in harbour.lib
    dbu_prg --> hb_langselect() in harbour.lib
    dbu_prg --> hb_minute()     in harbour.lib
    adordd_prg --> hb_ntos()       in harbour.lib
    dbu_prg --> hb_ntot()       in harbour.lib
    dbu_prg --> hb_ps()         in harbour.lib
    dbu_prg --> hb_run()        in harbour.lib
    dbucopy_prg --> hb_scroll()     in harbour.lib
    dbu_prg --> hb_sec()        in harbour.lib
    adordd_prg --> hb_stod()       in harbour.lib
    dbu_prg --> hb_stot()       in harbour.lib
    dbu_prg --> hb_strtots()    in harbour.lib
    adordd_prg --> hb_strtots()    in harbour.lib
    adordd_prg --> hb_tokenget()   in harbour.lib
    dbu_prg --> hb_tstostr()    in harbour.lib
    dbu_prg --> hb_ttoc()       in harbour.lib
    dbu_prg --> hb_tton()       in harbour.lib
    dbu_prg --> hb_ttos()       in harbour.lib
    dbufire_prg --> hb_utf8len()    in harbour.lib
    dbufire_prg --> hb_utf8tostr()  in harbour.lib
    adordd_prg --> hb_valtostr()   in harbour.lib
    dbu_prg --> hb_version()    <unresolved function>
    dbuleto_prg --> hb_zuncompress( in harbour.lib
    dbuutil_prg --> help()          in dbu.prg
    dbu_prg --> hi_cur()        in dbuutil.prg
    dbuadox_prg --> inputbox()      in dbulib.prg
    tdbclass_prg --> isconnected()   <unresolved function>
    dbucopy_prg --> isdata()        in dbuutil.prg
    dbuutil_prg --> itemlist()      in dbuutil.prg
    dbustru_prg --> key_ready()     in dbuutil.prg
    tdbclass_prg --> lasterror()     <unresolved function>
    tdbclass_prg --> lastinsertid()  <unresolved function>
    dbu_prg --> layout()        in dbulib.prg
    mdb2dbf_prg --> lerdocofre()    <unresolved function>
    dbu_prg --> letomenu()      in dbuleto.prg
    dbuleto_prg --> leto_connect()  in letodb.lib
    dbuleto_prg --> leto_connect()  in letodb.lib
    dbuleto_prg --> leto_dbftosrv() in dbuleto.prg
    dbuleto_prg --> leto_deldbf()   in dbuleto.prg
    dbuleto_prg --> leto_directory( in letodb.lib
    dbuleto_prg --> leto_directory( in letodb.lib
    dbuleto_prg --> leto_errocon()  in dbuleto.prg
    dbuleto_prg --> leto_expformat( in dbuleto.prg
    dbuleto_prg --> leto_expformat( in dbuleto.prg
    dbuleto_prg --> leto_expformat( in dbuleto.prg
    dbuleto_prg --> leto_ferase()   in letodb.lib
    dbuleto_prg --> leto_info()     in dbuleto.prg
    dbuleto_prg --> leto_mgid()     in letodb.lib
    dbuleto_prg --> leto_mglog()    in letodb.lib
    dbuleto_prg --> leto_srvtodbf() in dbuleto.prg
    dbuleto_prg --> leto_tables()   in dbuleto.prg
    dbuleto_prg --> leto_udf()      in letodb.lib
    dbu_prg --> limparegdupdbf( in dbusincdbf.prg
    dbuview_prg --> list_array()    in dbuview.prg
    dbuutil_prg --> lite_fkey()     in dbuutil.prg
    tdbclass_prg --> loadcursor()    <unresolved function>
    dbudoc_prg --> logic2str()     <unresolved function>
    dbuedit_prg --> lpad()          in dbuutil.prg
    dbudoc_prg --> makedbf()       <unresolved function>
    dbuutil_prg --> make_empty()    <unresolved function>
    dbu_prg --> make_ntx()      in dbuindx.prg
    dbuutil_prg --> matrix()        in dbuutil.prg
    dbu_prg --> md()            in dbulib.prg
    dbuadox_prg --> mdbcria()       in mdb2dbf.prg
    dbuadox_prg --> mdbdatabases()  in mdb2dbf.prg
    mdb2dbf_prg --> mdbexp()        in mdb2dbf.prg
    mdb2dbf_prg --> mdbimpdbf()     in mdb2dbf.prg
    dbulib_prg --> mdbmenu()       in mdb2dbf.prg
    dbuadox_prg --> mdbtabela()     in mdb2dbf.prg
    dbuadox_prg --> mdbtables()     in mdb2dbf.prg
    dbu_prg --> mdg()           <unresolved function>
    dbu_prg --> mdltodos()      in mdb2dbf.prg
    dbu_prg --> mds()           <unresolved function>
    dbuadox_prg --> mdt()           in dbulib.prg
    dbu_prg --> memopack()      <unresolved function>
    dbu_prg --> menusql()       in dbulib.prg
    dbucopy_prg --> menu_key()      in dbuutil.prg
    sql2dbf_prg --> miscsql()       in sql2dbf.prg
    dbumix_prg --> miscsql()       in sql2dbf.prg
    dbumix_prg --> mixexecarqsql() in dbumix.prg
    dbumix_prg --> mixexpdbf()     in dbumix.prg
    dbumix_prg --> miximpdbf()     in dbumix.prg
    dbulib_prg --> mixmenu()       in dbumix.prg
    dbumix_prg --> mix_close()     in dbumix.prg
    dbumix_prg --> mix_executesql( in dbumix.prg
    dbumix_prg --> mix_open()      in dbumix.prg
    dbu_prg --> modi_stru()     in dbustru.prg
    dbuedit_prg --> move_ptr()      in dbuedit.prg
    sql2dbf_prg --> msgstop()       <unresolved function>
    dbuutil_prg --> msgyesno()      <unresolved function>
    dbucopy_prg --> multibox()      in dbuutil.prg
    dbuadox_prg --> multidocg()     in dbudoc.prg
    dbu_prg --> multidocs()     in dbudoc.prg
    dbu_prg --> mvinfoconftela( <unresolved function>
    dbumy_prg --> mydeltable()    in dbumy.prg
    dbumy_prg --> myexecarqsql()  in dbumy.prg
    dbumy_prg --> myexpformat()   in dbumyexp.prg
    dbumy_prg --> myselectdb()    in dbumy.prg
    dbumy_prg --> myselecttable() in dbumy.prg
    dbulib_prg --> mysqlmenu()     in dbumy.prg
    dbumy_prg --> mysqlmenu()     in dbumy.prg
    mysqlrdd_prg --> mysql_append()  in mysqlrdd.prg
    mysqlrdd_prg --> mysql_bof()     in mysqlrdd.prg
    mysqlrdd_prg --> mysql_close()   in mysqlrdd.prg
    mysqlrdd_prg --> mysql_delete()  in mysqlrdd.prg
    mysqlrdd_prg --> mysql_deleted() in mysqlrdd.prg
    mysqlrdd_prg --> mysql_eof()     in mysqlrdd.prg
    mysqlrdd_prg --> mysql_flush()   in mysqlrdd.prg
    mysqlrdd_prg --> mysql_getvalue( in mysqlrdd.prg
    mysqlrdd_prg --> mysql_gobottom( in mysqlrdd.prg
    mysqlrdd_prg --> mysql_goto()    in mysqlrdd.prg
    mysqlrdd_prg --> mysql_gotoid()  in mysqlrdd.prg
    mysqlrdd_prg --> mysql_gotop()   in mysqlrdd.prg
    mysqlrdd_prg --> mysql_init()    in mysqlrdd.prg
    mysqlrdd_prg --> mysql_new()     in mysqlrdd.prg
    mysqlrdd_prg --> mysql_open()    in mysqlrdd.prg
    mysqlrdd_prg --> mysql_putvalue( in mysqlrdd.prg
    mysqlrdd_prg --> mysql_reccount( in mysqlrdd.prg
    mysqlrdd_prg --> mysql_recid()   in mysqlrdd.prg
    mysqlrdd_prg --> mysql_skip()    in mysqlrdd.prg
    dbumy_prg --> mystrudbf()     in dbumy.prg
    dbumy_prg --> mystrutodbf()   in dbumy.prg
    dbucopy_prg --> name()          in dbuutil.prg
    dbucopy_prg --> netgrvcam()     <unresolved function>
    dbuadox_prg --> netrecapp()     <unresolved function>
    dbu_prg --> netrecdel()     <unresolved function>
    dbucopy_prg --> netreclock()    in xhb.lib
    dbu_prg --> netregosok()    <unresolved function>
    tdbclass_prg --> new()           <unresolved function>
    dbuindx_prg --> not_target()    in dbuutil.prg
    dbustru_prg --> no_append()     in dbustru.prg
    dbuindx_prg --> ntx_exp()       in dbuindx.prg
    dbuindx_prg --> ntx_getfil()    in dbuindx.prg
    dbuindx_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> ntx_key()       in dbuutil.prg
    adoxb_prg --> oadoindex_end() <unresolved function>
    adoxb_prg --> oadoindex_end() <unresolved function>
    adoxb_prg --> oadoindex_end() <unresolved function>
    adoxb_prg --> oadoindex_end() <unresolved function>
    adoxb_prg --> oadoindex_end() <unresolved function>
    adoxb_prg --> oadoindex_end() <unresolved function>
    adoxb_prg --> oadoindex_end() <unresolved function>
    adoxb_prg --> oadotable_end() <unresolved function>
    adoxb_prg --> oadotable_end() <unresolved function>
    dbuedit_prg --> ob_addcolumn()  <unresolved function>
    dbuedit_prg --> ob_colorrect()  <unresolved function>
    dbuedit_prg --> ob_down()       <unresolved function>
    dbuedit_prg --> ob_end()        <unresolved function>
    dbuedit_prg --> ob_getcolumn()  <unresolved function>
    dbuedit_prg --> ob_gobottom()   <unresolved function>
    dbuedit_prg --> ob_gotop()      <unresolved function>
    dbuedit_prg --> ob_home()       <unresolved function>
    dbuedit_prg --> ob_left()       <unresolved function>
    dbuedit_prg --> ob_pagedown()   <unresolved function>
    dbuedit_prg --> ob_pageup()     <unresolved function>
    dbuedit_prg --> ob_panend()     <unresolved function>
    dbuedit_prg --> ob_panhome()    <unresolved function>
    dbuedit_prg --> ob_panleft()    <unresolved function>
    dbuedit_prg --> ob_panright()   <unresolved function>
    dbuedit_prg --> ob_refreshall() <unresolved function>
    dbuedit_prg --> ob_refreshall() <unresolved function>
    dbuedit_prg --> ob_right()      <unresolved function>
    dbuedit_prg --> ob_stabilize()  <unresolved function>
    dbuedit_prg --> ob_up()         <unresolved function>
    adordd_prg --> ob_up()         <unresolved function>
    adordd_prg --> ob_up()         <unresolved function>
    adordd_prg --> oconn_close()   <unresolved function>
    adordd_prg --> oconn_open()    <unresolved function>
    adordd_prg --> oconn_open()    <unresolved function>
    adordd_prg --> oconn_open()    <unresolved function>
    adordd_prg --> oconn_open()    <unresolved function>
    adordd_prg --> oconn_open()    <unresolved function>
    dbuodbc_prg --> odb_skip()      <unresolved function>
    dbuodbc_prg --> odbcdeltable()  in dbuodbc.prg
    dbuodbc_prg --> odbcexecarqsql( in dbuodbc.prg
    dbuodbc_prg --> odbcexecsql()   in dbuodbc.prg
    dbuodbc_prg --> odbcexpdbf()    in dbuodbc.prg
    dbuodbc_prg --> odbcimpdbf()    in dbuodbc.prg
    dbulib_prg --> odbcmenu()      in dbuodbc.prg
    adordd_prg --> oexcel_save()   <unresolved function>
    dbuadox_prg --> opcao()         <unresolved function>
    mdb2dbf_prg --> opencmdbarq()   in mdb2dbf.prg
    dbuadox_prg --> opentipoarq()   in mdb2dbf.prg
    dbustru_prg --> open_dbf()      in dbuview.prg
    sql2dbf_prg --> open_dbf()      in dbuview.prg
    dbumy_prg --> open_dbf()      in dbuview.prg
    dbumy_prg --> oquery2_eof()   <unresolved function>
    dbumy_prg --> oquery2_fcount( <unresolved function>
    dbumy_prg --> oquery2_getrow( <unresolved function>
    dbumy_prg --> oquery2_getrow( <unresolved function>
    dbumy_prg --> oquery2_skip()  <unresolved function>
    dbufire_prg --> oquery_destroy( <unresolved function>
    dbufire_prg --> oquery_eof()    <unresolved function>
    mysqlrdd_prg --> oquery_eof()    <unresolved function>
    pgrdd_prg --> oquery_fcount() <unresolved function>
    mysqlrdd_prg --> oquery_fcount() <unresolved function>
    dbufire_prg --> oquery_fcount() <unresolved function>
    mysqlrdd_prg --> oquery_fcount() <unresolved function>
    mysqlrdd_prg --> oquery_fcount() <unresolved function>
    mysqlrdd_prg --> oquery_fcount() <unresolved function>
    dbumy_prg --> oquery_getrow() <unresolved function>
    dbufire_prg --> oquery_gotop()  <unresolved function>
    dbufire_prg --> oquery_lastrec( <unresolved function>
    mysqlrdd_prg --> oquery_neterr() <unresolved function>
    dbufire_prg --> oquery_skip()   <unresolved function>
    dbumy_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    adordd_prg --> ordcount()      in harbour.lib
    dbumy_prg --> orow_fieldget() <unresolved function>
    mdb2dbf_prg --> ors_movenext()  <unresolved function>
    pgrdd_prg --> oserver_close() <unresolved function>
    dbufire_prg --> oserver_commit( <unresolved function>
    dbumy_prg --> oserver_commit( <unresolved function>
    dbumy_prg --> oserver_commit( <unresolved function>
    dbumy_prg --> oserver_commit( <unresolved function>
    dbumy_prg --> oserver_commit( <unresolved function>
    dbufire_prg --> oserver_commit( <unresolved function>
    dbufire_prg --> oserver_error() <unresolved function>
    dbumy_prg --> oserver_error() <unresolved function>
    dbufire_prg --> oserver_error() <unresolved function>
    dbufire_prg --> oserver_error() <unresolved function>
    dbumy_prg --> oserver_error() <unresolved function>
    dbufire_prg --> oserver_error() <unresolved function>
    dbufire_prg --> oserver_neterr( <unresolved function>
    dbufire_prg --> oserver_query() <unresolved function>
    dbumy_prg --> oserver_query() <unresolved function>
    dbufire_prg --> oserver_query() <unresolved function>
    dbufire_prg --> oserver_query() <unresolved function>
    dbumy_prg --> otable_append() <unresolved function>
    dbumy_prg --> otable_destroy( <unresolved function>
    dbumy_prg --> otable_error()  <unresolved function>
    dbupg_prg --> otable_error()  <unresolved function>
    dbumy_prg --> otable_error()  <unresolved function>
    dbumy_prg --> otable_neterr() <unresolved function>
    mdb2dbf_prg --> oxcatalog_eof() <unresolved function>
    mdb2dbf_prg --> oxcatalog_eof() <unresolved function>
    mdb2dbf_prg --> oxcatalog_eof() <unresolved function>
    mdb2dbf_prg --> oxcatalog_eof() <unresolved function>
    mdb2dbf_prg --> oxcatalog_eof() <unresolved function>
    dbuadox_prg --> pegcfgbanco()   in mdb2dbf.prg
    dbuadox_prg --> pegcsub()       in dbudoc.prg
    dbu_prg --> pegparexp()     in dbulib.prg
    dbudoc_prg --> pegtipo2val()   in dbudoc.prg
    dbuadox_prg --> pegtipodoc()    in dbulib.prg
    dbupg_prg --> pgdeltable()    in dbupg.prg
    dbupg_prg --> pgexecarqsql()  in dbupg.prg
    dbupg_prg --> pgexpformat()   in dbupgexp.prg
    dbupg_prg --> pgselecttable() in dbupg.prg
    dbupg_prg --> pgsetdatabase() in dbupg.prg
    dbulib_prg --> pgsqlmenu()     in dbupg.prg
    dbupg_prg --> pgsqlmenu()     in dbupg.prg
    dbupg_prg --> pgstrudbf()     in dbupg.prg
    dbupg_prg --> pgstrutodbf()   in dbupg.prg
    pgrdd_prg --> pg_append()     in pgrdd.prg
    pgrdd_prg --> pg_bof()        in pgrdd.prg
    pgrdd_prg --> pg_close()      in pgrdd.prg
    pgrdd_prg --> pg_delete()     in pgrdd.prg
    pgrdd_prg --> pg_deleted()    in pgrdd.prg
    pgrdd_prg --> pg_eof()        in pgrdd.prg
    pgrdd_prg --> pg_flush()      in pgrdd.prg
    pgrdd_prg --> pg_getvalue()   in pgrdd.prg
    pgrdd_prg --> pg_gobottom()   in pgrdd.prg
    pgrdd_prg --> pg_goto()       in pgrdd.prg
    pgrdd_prg --> pg_gotoid()     in pgrdd.prg
    pgrdd_prg --> pg_gotop()      in pgrdd.prg
    pgrdd_prg --> pg_init()       in pgrdd.prg
    pgrdd_prg --> pg_new()        in pgrdd.prg
    pgrdd_prg --> pg_open()       in pgrdd.prg
    pgrdd_prg --> pg_putvalue()   in pgrdd.prg
    pgrdd_prg --> pg_reccount()   in pgrdd.prg
    pgrdd_prg --> pg_recid()      in pgrdd.prg
    pgrdd_prg --> pg_skip()       in pgrdd.prg
    dbuview_prg --> put_line()      in dbuview.prg
    tdbclass_prg --> query()         <unresolved function>
    dbu_prg --> q_check()       in dbuutil.prg
    dbuview_prg --> raw_key()       in dbuutil.prg
    dbumix_prg --> rddinfo()       in harbour.lib
    dbu_prg --> rddnome()       in dbulib.prg
    dbulib_prg --> readcur()       <unresolved function>
    dbu_prg --> readdbu()       in dbu.prg
    dbustru_prg --> read_key()      in dbuutil.prg
    tdbclass_prg --> recall()        <unresolved function>
    dbuleto_prg --> repl()          <unresolved function>
    dbuadox_prg --> restaa()        <unresolved function>
    tdbclass_prg --> rollback()      <unresolved function>
    adordd_prg --> rs_fields()     <unresolved function>
    adordd_prg --> rs_move()       <unresolved function>
    adordd_prg --> rs_movefirst()  <unresolved function>
    dbu_prg --> rsvp()          in dbuutil.prg
    dbuadox_prg --> salvaa()        <unresolved function>
    dbuview_prg --> save_view()     in dbuview.prg
    tdbclass_prg --> seek()          <unresolved function>
    sql2dbf_prg --> selectdb()      in sql2dbf.prg
    dbudoc_prg --> selectfolder()  <unresolved function>
    dbu_prg --> setup()         in dbuutil.prg
    dbuview_prg --> set_deflt()     in dbuview.prg
    dbu_prg --> set_from()      in dbuview.prg
    dbuview_prg --> set_relation()  in dbuview.prg
    dbu_prg --> set_view()      in dbuview.prg
    mdb2dbf_prg --> showadoerror()  <unresolved function>
    dbuedit_prg --> show_insert()   in dbuedit.prg
    tdbclass_prg --> skip()          <unresolved function>
    dbuedit_prg --> skipped()       in dbuedit.prg
    dbu_prg --> sortdbf()       in dbusincdbf.prg
    sql2dbf_prg --> sortdbf()       in dbusincdbf.prg
    sql2dbf_prg --> sortdbf()       in dbusincdbf.prg
    sql2dbf_prg --> sortdbf()       in dbusincdbf.prg
    tdbclass_prg --> sortdbf()       in dbusincdbf.prg
    sql2dbf_prg --> sortdbf()       in dbusincdbf.prg
    sql2dbf_prg --> sortdbf()       in dbusincdbf.prg
    sql2dbf_prg --> sqlite3_errmsg( in hbsqlit3.lib
    sql2dbf_prg --> sqlite3_exec()  in hbsqlit3.lib
    sql2dbf_prg --> sqlite3_exec()  in hbsqlit3.lib
    sql2dbf_prg --> sqlite3_exec()  in hbsqlit3.lib
    sql2dbf_prg --> sqlite3_exec()  in hbsqlit3.lib
    sql2dbf_prg --> sqlite3_exec()  in hbsqlit3.lib
    sql2dbf_prg --> sqlite3_open()  in hbsqlit3.lib
    sql2dbf_prg --> sqlite3_open()  in hbsqlit3.lib
    sql2dbf_prg --> sqlite3_reset() in hbsqlit3.lib
    sql2dbf_prg --> sqlite3_step()  in hbsqlit3.lib
    sql2dbf_prg --> sqlitearqsql()  in sql2dbf.prg
    adoxb_prg --> sqlitearqsql()  in sql2dbf.prg
    dbulib_prg --> sqlitemenu()    in sql2dbf.prg
    sql2dbf_prg --> sqlitepack()    in sql2dbf.prg
    sql2dbf_prg --> sqlitetables()  in sql2dbf.prg
    sql2dbf_prg --> sqlitetables()  in sql2dbf.prg
    sql2dbf_prg --> sqltablestru()  in sql2dbf.prg
    dbumix_prg --> sqltodbfstru()  in mdb2dbf.prg
    dbu_prg --> sqltodos()      in mdb2dbf.prg
    adordd_prg --> sqltranslate()  in adordd.prg
    dbuedit_prg --> statline()      in dbuedit.prg
    dbu_prg --> stat_msg()      in dbuutil.prg
    sql2dbf_prg --> stod()          in harbour.lib
    dbudoc_prg --> str2html()      <unresolved function>
    tdbclass_prg --> structure()     <unresolved function>
    dbustru_prg --> stru_ck()       in dbustru.prg
    dbustru_prg --> stru_item()     in dbustru.prg
    dbustru_prg --> stru_row()      in dbustru.prg
    dbudoc_prg --> strval()        <unresolved function>
    dbuedit_prg --> sysmenu()       in dbuutil.prg
    tdbclass_prg --> tableexists()   <unresolved function>
    tdbclass_prg --> tables()        <unresolved function>
    dbulib_prg --> tclassmenu()    in dbutclass.prg
    dbufire_prg --> tfbserver()     in hbfbird.lib
    dbudoc_prg --> tipoc()         in dbudoc.prg
    mdb2dbf_prg --> tipodado2()     in mdb2dbf.prg
    dbu_prg --> tipodbfesc()    in dbulib.prg
    dbudoc_prg --> tipoxml()       in dbuxml.prg
    dbuedit_prg --> tirace()        <unresolved function>
    dbuadox_prg --> tiraext()       <unresolved function>
    dbulib_prg --> tiraout()       <unresolved function>
    dbumy_prg --> tmysqlserver()  in hbmysql.lib
    dbuodbc_prg --> todbc()         in hbodbc.lib
    dbuedit_prg --> tog_insert()    in dbuedit.prg
    dbuutil_prg --> to_can()        in dbuutil.prg
    dbucopy_prg --> to_ok()         in dbuutil.prg
    dbupg_prg --> tpqserver()     in hbpgsql.lib
    dbulib_prg --> trocaext()      <unresolved function>
    sql2dbf_prg --> ttoc()          in xhb.lib
    sql2dbf_prg --> ttod()          in xhb.lib
    adoxb_prg --> typedat()       in adoxb.prg
    adordd_prg --> typedat()       in adoxb.prg
    adordd_prg --> ur_super_close( in hbusrrdd.lib
    adordd_prg --> ur_super_error( in hbusrrdd.lib
    adordd_prg --> ur_super_open() in hbusrrdd.lib
    adordd_prg --> ur_super_open() in hbusrrdd.lib
    adordd_prg --> ur_super_open() in hbusrrdd.lib
    adordd_prg --> ur_super_open() in hbusrrdd.lib
    adordd_prg --> usrrdd_rdddata( in hbusrrdd.lib
    dbuver_prg --> vertxt()        in dbuver.prg
    dbudoc_prg --> win_ansitooem() in hbwin.lib
    dbuadox_prg --> win_ansitooem() in hbwin.lib
    dbufire_prg --> win_ansitooem() in hbwin.lib
    dbudoc_prg --> win_oemtoansi() in hbwin.lib
    adordd_prg --> win_oleauto()   in hbwin.lib
    adordd_prg --> win_oleauto()   in hbwin.lib
    dbu_prg --> xaltins()       <unresolved function>
    dbu_prg --> xcapfirs()      <unresolved function>
    dbu_prg --> xcaptxt()       <unresolved function>
    dbu_prg --> xcenter()       <unresolved function>
    dbu_prg --> xconvmai()      <unresolved function>
    dbu_prg --> xconvmin()      <unresolved function>
    dbu_prg --> xctrldel()      <unresolved function>
    dbu_prg --> xctrlins()      <unresolved function>
    dbu_prg --> xediwor()       <unresolved function>
    dbu_prg --> xexpand()       <unresolved function>
    dbu_prg --> xext()          in dbulib.prg
    dbu_prg --> xgratxt()       <unresolved function>
    dbucopy_prg --> xkey_clear()    in dbuutil.prg
    dbucopy_prg --> xkey_norm()     in dbuutil.prg
    dbu_prg --> xposdir()       <unresolved function>
    dbu_prg --> xposesq()       <unresolved function>
    dbu_prg --> xtirace()       <unresolved function>
    dbu_prg --> zei_fort()      <unresolved function>
    dbustru_prg --> __copyfile()    <unresolved function>
    dbu_prg --> __setcentury()  <unresolved function>
    dbu_prg --> __xrestscreen() <unresolved function>
```
