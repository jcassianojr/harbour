# 📘 Documentacao Tecnica do Projeto
> Gerado em: 25/10/2026 13:55:23

## 🏗️ Estrutura de Modulos (PRGs)

### 📄 Arquivo: `hbx`
- Function main()
- Function faz02()
- Function faz01()
- Function limpadup()
- Function faz04()
- Function TRATANOME()
- Function faz05()
- Function faz03()
- Function geraxmlnotepad()

## 📊 Dicionario de Dados e Acessos

## 🕸️ Diagrama de Relacionamento (Mermaid)
```mermaid
graph TD
    main --> faz01["faz01         in hbx.prg"]
    main --> faz02["faz02         in hbx.prg"]
    main --> faz03["faz03         in hbx.prg"]
    main --> faz04["faz04         in hbx.prg"]
    main --> faz05["faz05         in hbx.prg"]
    faz01 --> fdelim["fdelim        <externa>"]
    faz01 --> flinecount["flinecount    <externa>"]
    faz01 --> freadline["freadline     <externa>"]
    main --> geraxmlnotepad["geraxmlnotepad in hbx.prg"]
    faz02 --> hb_atokens["hb_atokens    in harbour.lib"]
    geraxmlnotepad --> hb_eol["hb_eol        in harbour.lib"]
    faz01 --> hb_fnamename["hb_fnamename  in harbour.lib"]
    main --> hb_idlestate["hb_idlestate  in harbour.lib"]
    main --> limpadup["limpadup      in hbx.prg"]
    tratanome --> rangerepl["rangerepl     in hbct.lib"]
    main --> tokenupper["tokenupper    in hbct.lib"]
    faz01 --> tratanome["tratanome     in hbx.prg"]
    main --> __setcentury["__setcentury  <externa>"]
```
