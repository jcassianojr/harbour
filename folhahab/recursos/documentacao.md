# 📘 Documentacao Tecnica do Projeto
> Gerado em: 05/12/26 19:13:37

## 🏗️ Estrutura de Modulos (PRGs)

### 📄 Arquivo: `recuapo.prg`
- Function RECUAPO()

### 📄 Arquivo: `recuapo2.prg`
- Function RECUAPO2()
- Function folutil3()
- Function folutil4()
- Function folutil5()

### 📄 Arquivo: `recueti1.prg`
- Function RECUETI1()
- Function EDITA2()
- Function CAD()

### 📄 Arquivo: `recueti2.prg`
- Function RECUETI2()
- Function EDITA()
- Function CA()
- Function LISTA()

### 📄 Arquivo: `recuger.prg`
- Function RECUGER()

### 📄 Arquivo: `recuger1.prg`
- Function RECUGER1()
- Function CAD1()
- Function TELATIP()

### 📄 Arquivo: `recuger2.prg`
- Function RECUGER2()
- Function tREDIT()
- Function gREDIT()
- Function lREDIT()

### 📄 Arquivo: `recumenu.prg`
- Function RECUMENU()

### 📄 Arquivo: `recuproc.prg`
- Function CABE2()
- Function CABE3()
- Function NSHOW()
- Function ARQ()
- Function NSHOW1()
- Function MDI()
- Function COR()
- Function CABEX()

### 📄 Arquivo: `recursos.prg`
- Function main()
- Function corrigeendereco()
- Function m_da()

### 📄 Arquivo: `recuser.prg`
- Function RECUSER()

## 📊 Dicionario de Dados e Acessos

## 🕸️ Diagrama de Relacionamento (Mermaid)
```mermaid
graph TD
    recueti1_prg --> acento()        <unresolved function>
    recursos_prg --> ac_agudo()      <unresolved function>
    recursos_prg --> ac_circ()       <unresolved function>
    recursos_prg --> ac_crase()      <unresolved function>
    recursos_prg --> ac_til()        <unresolved function>
    recursos_prg --> agen()          <unresolved function>
    recueti2_prg --> arq()           in recuproc.prg
    recuapo2_prg --> cabe2()         in recuproc.prg
    recuger_prg --> cabe3()         in recuproc.prg
    recueti2_prg --> checkimp()      <unresolved function>
    recueti1_prg --> delerec()       <unresolved function>
    recursos_prg --> deletaarq()     <unresolved function>
    recueti2_prg --> edita()         in recueti2.prg
    recueti1_prg --> edita2()        in recueti1.prg
    recueti2_prg --> filtro()        <unresolved function>
    recumenu_prg --> fim()           <unresolved function>
    recuapo2_prg --> folutil3()      in recuapo2.prg
    recuapo2_prg --> folutil4()      in recuapo2.prg
    recuapo2_prg --> folutil5()      in recuapo2.prg
    recumenu_prg --> foy2()          <unresolved function>
    recuger2_prg --> gredit()        in recuger2.prg
    recursos_prg --> hb_cwd()        in harbour.lib
    recumenu_prg --> hb_dispbox()    in harbour.lib
    recursos_prg --> hb_idlestate()  in harbour.lib
    recuproc_prg --> hb_keyclear()   in harbour.lib
    recursos_prg --> hb_langselect() in harbour.lib
    recursos_prg --> hb_run()        in harbour.lib
    recursos_prg --> help()          <unresolved function>
    recuger2_prg --> imparq()        <unresolved function>
    recueti2_prg --> impend()        <unresolved function>
    recueti2_prg --> impfol()        <unresolved function>
    recuger_prg --> imphp()         <unresolved function>
    recueti2_prg --> impressora()    <unresolved function>
    recursos_prg --> infor()         <unresolved function>
    recueti2_prg --> lista()         in recueti2.prg
    recuger2_prg --> lredit()        in recuger2.prg
    recuapo2_prg --> md()            <unresolved function>
    recueti1_prg --> mdg()           <unresolved function>
    recueti1_prg --> mds()           <unresolved function>
    recuapo2_prg --> mdt()           <unresolved function>
    recuger1_prg --> mmes()          <unresolved function>
    recursos_prg --> mudadata()      <unresolved function>
    recursos_prg --> mvinfoconftela( <unresolved function>
    recueti1_prg --> netrecapp()     <unresolved function>
    recueti1_prg --> netrecdel()     <unresolved function>
    recursos_prg --> netregosok()    <unresolved function>
    recueti1_prg --> netuse()        <unresolved function>
    recursos_prg --> nnetwhoami()    <unresolved function>
    recursos_prg --> notep()         <unresolved function>
    recuproc_prg --> nshow()         in recuproc.prg
    recueti1_prg --> nshow1()        in recuproc.prg
    recuapo2_prg --> opcao()         <unresolved function>
    recuger2_prg --> padrao()        <unresolved function>
    recuger2_prg --> pegchave()      <unresolved function>
    recuger2_prg --> profilestring() <unresolved function>
    recueti2_prg --> rcampo()        <unresolved function>
    recuapo2_prg --> readcur()       <unresolved function>
    recuapo_prg --> recuapo2()      in recuapo2.prg
    recuger1_prg --> recueti1()      in recueti1.prg
    recuger1_prg --> recueti2()      in recueti2.prg
    recuger_prg --> recuger1()      in recuger1.prg
    recuger_prg --> recuger2()      in recuger2.prg
    recursos_prg --> recumenu()      in recumenu.prg
    recuger1_prg --> repl()          <unresolved function>
    recursos_prg --> teclas()        <unresolved function>
    recueti1_prg --> telatip()       in recuger1.prg
    recursos_prg --> tele()          <unresolved function>
    recuger2_prg --> tredit()        in recuger2.prg
    recueti2_prg --> video()         in hbct.lib
    recueti2_prg --> zei_fort()      <unresolved function>
    recursos_prg --> __setcentury()  <unresolved function>
```
