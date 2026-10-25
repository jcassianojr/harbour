# Notepad++ Harbour Language Support

Este repositório fornece suporte aprimorado para a linguagem de programação **Harbour** (e Clipper) no editor de texto [Notepad++](https://notepad-plus-plus.org/).

Ele inclui ficheiros de configuração para **Realce de Sintaxe** (User Defined Language - UDL) e **Auto-Completar / Calltips** (Dicas de parâmetros).

## 📦 Ficheiros Incluídos

* `userDefineLang_harbour.xml`: Ficheiro UDL que adiciona realce de sintaxe (cores, formatação de palavras-chave, blocos de código) para a linguagem Harbour.
* `harbour.xml`: Ficheiro de auto-completar que fornece sugestões de funções e exibe dicas de parâmetros (Calltips) enquanto escreve.

## ✨ Funcionalidades

* **Realce de Sintaxe Completo:** Reconhecimento de palavras-chave do Harbour, funções padrão, variáveis, strings e comentários.
* **Auto-Completar Inteligente:** Sugestão de nomes de funções enquanto digita.
* **Calltips (Dicas de Tela):** Exibição da assinatura da função e dos seus parâmetros ao abrir os parênteses `(`, facilitando a escrita do código sem precisar de consultar a documentação constantemente.
* **Ignora Maiúsculas/Minúsculas (Case Insensitive):** Configurável para suportar o padrão do Harbour.

## 🚀 Como Instalar

### 1. Instalar o Realce de Sintaxe (UDL)
1. Abra o Notepad++.
2. No menu superior, vá a **Linguagem** > **Definida pelo Utilizador** > **Defina a sua linguagem...** (Language > User Defined Language > Define your language...).
3. Na janela que se abre, clique no botão **Importar...** (Import...).
4. Selecione o ficheiro `userDefineLang_harbour.xml` que descarregou deste repositório.
5. Reinicie o Notepad++.
6. Agora, ao abrir um ficheiro `.prg` ou `.ch`, a sintaxe será realçada automaticamente (pode também selecioná-la manualmente no menu "Linguagem").

### 2. Instalar o Auto-Completar e Calltips
1. Encontre a pasta de instalação do Notepad++. Normalmente está localizada em:
   * `C:\Program Files\Notepad++\` ou `C:\Program Files (x86)\Notepad++\`
2. Dentro da pasta do Notepad++, abra o diretório `autoCompletion`.
3. Copie o ficheiro `harbour.xml` para dentro desta pasta.
   * *Nota: Dependendo da configuração, pode ser necessário renomear este ficheiro para corresponder exatamente ao nome da linguagem definida no UDL (por exemplo, `Harbour.xml`).*
4. Abra o Notepad++ e vá a **Configurações** > **Preferências** > **Auto-Completar** (Settings > Preferences > Auto-Completion).
5. Certifique-se de que a opção **Ativar auto-completar em cada entrada** está marcada para "Funções e Palavras" (Function and word completion) e que a caixa **Dica de parâmetros da função** (Function parameters hint on input) está assinalada.
6. Reinicie o editor.

## 🛠️ Requisitos
* Notepad++ (versão recomendada: 7.6 ou superior).

## 📄 Licença
Este projeto é distribuído sob a licença MIT. Sinta-se à vontade para o usar, modificar e partilhar.