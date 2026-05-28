# DCompare - Database Comparador & Corretor

O **DCompare** é uma ferramenta desenvolvida em Visual Basic 6 (VB6) projetada para analisar, comparar e sincronizar estruturas de bancos de dados Microsoft Access (formatos `.mdb` e `.accdb`). O objetivo principal é garantir que bases de dados de produção estejam alinhadas com as versões de desenvolvimento, corrigindo disparidades de tabelas e campos automaticamente.

## 🚀 Características Principais

- **Compatibilidade Dual:** Suporte total a arquivos legados (`Jet 4.0 / .mdb`) e arquivos modernos (`ACE Engine / .accdb`).
- **Arquitetura Híbrida Estabilizada:** Utiliza **ADOX** e **ADO** para manipulação de metadados, eliminando os travamentos (crashes) comuns causados pela biblioteca DAO em ambientes Windows modernos.
- **Análise Não Invasiva:** A comparação é realizada via inspeção de catálogos, sem a necessidade de abrir recordsets de dados, o que aumenta a performance e a segurança.
- **Sincronização Automática:** Capaz de criar tabelas ausentes e adicionar novos campos no banco de destino em tempo real.
- **Interface Intuitiva:** Log detalhado de diferenças em um campo de texto multi-line e barra de progresso para monitoramento de processos longos.

## 🛠️ Funções Técnicas

### 1. Comparação e Correção (`corrige`)
A função principal do sistema. Ela percorre a origem e o destino realizando:
- Verificação de existência de tabelas (ignora tabelas de sistema `MSys`).
- Comparação de nomes de campos, tipos de dados e tamanhos (`DefinedSize`).
- **Auto-Correção:** Inserção de colunas faltantes mantendo a integridade dos tipos.

### 2. Criação Dinâmica de Bases (`CriaMdbAccess`)
Módulo robusto para criação de novos arquivos de banco de dados:
- Seleção automática de Engine (Type 5 para MDB, Type 6 para ACCDB).
- Implementação via *Late Binding* para máxima compatibilidade com diferentes versões do Office instaladas.

### 3. Utilitários de Dados (`dcompare.bas`)
- Conversor de tipos ADO para strings legíveis.
- Funções de sanitização de strings e tratamento de valores nulos.

## 💻 Requisitos de Ambiente

- **Linguagem:** Visual Basic 6.0
- **Dependências de Runtime:**
  - Microsoft ActiveX Data Objects 6.1 (ou superior)
  - Microsoft ADO Ext. 2.8 for DDL and Security
  - Microsoft Office Access Database Engine (para suporte a .accdb)
- **Componentes:** `COMDLG32.OCX` (Common Dialogs)

## 📦 Como Utilizar

1. **Origem:** Selecione o banco de dados que contém a estrutura correta (modelo).
2. **Destino:** Selecione o banco de dados que deseja validar ou atualizar.
3. **Analisar:** Clique para listar as diferenças no log.
4. **Corrigir:** Ative a opção de gravação para aplicar as mudanças estruturais no destino.

## ⚠️ Notas de Versão

Recentemente o projeto foi migrado de **DAO 3.6** para **ADOX** para resolver problemas de encerramento inesperado do aplicativo ao ler metadados de arquivos `.accdb`. Esta mudança garante que o software funcione corretamente em Windows 10 e 11, mesmo sem o Access completo instalado.

---
*Projeto voltado para automação de manutenção de estruturas de dados e bancos de dados legados.*
