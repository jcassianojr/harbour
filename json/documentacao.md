# 📘 Documentacao Tecnica do Projeto
> Gerado em: 05/12/26 19:14:57

## 🏗️ Estrutura de Modulos (PRGs)

### 📄 Arquivo: `jason.prg`
- Function main()
- Function JASONCSV()
- Function tirace2()
- Function GetJson()
- Function IsJsonValid()

## 📊 Dicionario de Dados e Acessos

**Fonte:** `jason.prg`
> Tables: dbusearea(.T.,"DBFCDX",cARQDBF,,.T.)

## 🕸️ Diagrama de Relacionamento (Mermaid)
```mermaid
graph TD
    jason_prg --> getjson()       in jason.prg
    jason_prg --> hb_atokens()    in harbour.lib
    jason_prg --> hb_idlestate()  in harbour.lib
    jason_prg --> hb_jsondecode() in harbour.lib
    jason_prg --> hb_memoread()   in harbour.lib
    jason_prg --> hb_utf8tostr()  in harbour.lib
    jason_prg --> hb_valtoexp()   in harbour.lib
    jason_prg --> jasoncsv()      in jason.prg
    jason_prg --> tirace2()       in jason.prg
    jason_prg --> __setcentury()  <unresolved function>
```
