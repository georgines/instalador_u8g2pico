# Instalador u8g2pico

Este script automatiza a instalação da biblioteca **u8g2pico** e sua dependência **u8g2lib** para projetos Raspberry Pi Pico com CMake.

## 📋 Requisitos

### Pré-requisitos obrigatórios:
- **Git** instalado e configurado no sistema
- **VS Code** com extensão C/C++ (recomendado)
- Projeto Raspberry Pi Pico com arquivo `CMakeLists.txt`

### Verificando se o Git está instalado:
```bash
git --version
```

Se o Git não estiver instalado, baixe em: https://git-scm.com/downloads

## 🚀 Como usar

### Acessando o terminal

#### 🪟 Windows (VS Code)

**Opção 1: Menu Terminal**
1. No VS Code, vá em **Terminal** → **New Terminal**
2. No canto inferior direito do terminal, clique na seta ao lado do nome do shell
3. Selecione **Git Bash** ou **bash.exe**

**Opção 2: Atalho de teclado**
1. Pressione `Ctrl + Shift + `` (crase)
2. Se não abrir o Bash por padrão, siga os passos da Opção 1

**Opção 3: Configurar Bash como padrão**
1. Pressione `Ctrl + Shift + P` para abrir a paleta de comandos
2. Digite: `Terminal: Select Default Profile`
3. Selecione **Git Bash** ou **bash.exe**

#### 🐧 Linux / 🍎 Mac
- Abra o **Terminal** nativo do sistema
- No VS Code: pressione `Ctrl + Shift + `` (Linux) ou `Cmd + Shift + `` (Mac)

### Baixando o script

**Navegue até a pasta raiz do seu projeto e baixe o instalador**:

#### 🪟 Windows
```bash
# Navegue até a pasta raiz do seu projeto Pico (onde está o CMakeLists.txt)
cd /c/caminho/para/seu/projeto_pico

# Baixe o script
curl -O https://raw.githubusercontent.com/georgines/instalador_u8g2pico/main/instalar_u8g2pico.sh
```

#### 🐧 Linux / 🍎 Mac
```bash
# Navegue até a pasta raiz do seu projeto Pico (onde está o CMakeLists.txt)
cd /home/usuario/caminho/para/seu/projeto_pico  # Linux
# ou
cd /Users/usuario/caminho/para/seu/projeto_pico  # Mac

# Baixe o script (curl está disponível por padrão)
curl -O https://raw.githubusercontent.com/georgines/instalador_u8g2pico/main/instalar_u8g2pico.sh
```

**💡 Alternativa usando wget** (disponível na maioria dos sistemas Linux):
```bash
wget https://raw.githubusercontent.com/georgines/instalador_u8g2pico/main/instalar_u8g2pico.sh
```

#### Verificando se o download foi bem-sucedido:
```bash
# Verifique se está na pasta certa (deve mostrar o CMakeLists.txt e o script)
ls -la CMakeLists.txt instalar_u8g2pico.sh
```

### Executando o script

#### Instalação na pasta padrão (lib/):
```bash
# Execute o script (criará a pasta lib/ automaticamente)
bash ./instalar_u8g2pico.sh
```

#### Instalação em pasta personalizada:
```bash
# Execute especificando uma pasta diferente (ex: libraries/)
bash ./instalar_u8g2pico.sh libraries
```


## ⚙️ Configurações automáticas no CMakeLists.txt

O script adiciona automaticamente ao seu `CMakeLists.txt`:

```cmake
# Adicionado após a linha project()
add_subdirectory(lib/u8g2pico)

# Adicionado/modificado na seção target_link_libraries
target_link_libraries(seu_projeto u8g2pico)
```

## 🔧 Exemplo de uso no código

Após a instalação, você pode usar a biblioteca em seu código:

```c
#include <stdio.h>
#include "pico/stdlib.h"
#include "u8g2pico.h"

#define I2C_PORT i2c1
#define SDA_PIN 14
#define SCL_PIN 15
#define I2C_ADDR 0x3C

static u8g2pico_t u8g2pico;

int main()
{
    stdio_init_all();

    //funções de u8g2pico
    u8g2_Setup_ssd1306_i2c_128x64_noname_f_pico(&u8g2pico, I2C_PORT, SDA_PIN, SCL_PIN, U8G2_R0, I2C_ADDR);
    
    //funções padrão de u8g2lib
    u8g2_InitDisplay(&u8g2pico);
    u8g2_SetPowerSave(&u8g2pico, 0);
    u8g2_ClearBuffer(&u8g2pico);
    u8g2_SendBuffer(&u8g2pico);

    u8g2_ClearBuffer(&u8g2pico);
    u8g2_SetFont(&u8g2pico, u8g2_font_8bitclassic_tf);
    u8g2_DrawStr(&u8g2pico, 0, 25, "U8g2 Pico!");
    u8g2_SendBuffer(&u8g2pico);
}

```

## 🛠️ Solução de problemas

### Git não encontrado
```
bash: git: command not found
```
**Soluções por sistema:**
- **🪟 Windows**: Instale o Git em https://git-scm.com/downloads
- **🐧 Linux**: `sudo apt install git` (Ubuntu/Debian) ou `sudo yum install git` (CentOS/RHEL)
- **🍎 Mac**: `brew install git` ou instale as Xcode Command Line Tools

### curl não encontrado
```
bash: curl: command not found
```
**Soluções:**
- **🪟 Windows**: curl vem com Git Bash, use `wget` como alternativa
- **🐧 Linux**: `sudo apt install curl` (Ubuntu/Debian)
- **🍎 Mac**: curl vem pré-instalado

### Permissão negada
```
Permission denied
```
**Solução**: 
- **🪟 Windows**: Execute o terminal como administrador
- **🐧🍎 Linux/Mac**: Use `sudo` se necessário ou verifique permissões da pasta

### CMakeLists.txt não encontrado
```
⚠️ Arquivo CMakeLists.txt não encontrado
```
**Solução**: Execute o script no diretório raiz do seu projeto Pico (onde está o CMakeLists.txt)

### Bash não disponível (Windows)
**Solução**: 
1. Instale o Git para Windows (inclui Git Bash)
2. Reinicie o VS Code
3. Siga as instruções da seção "Acessando o terminal"

## 📚 Recursos adicionais

- **Documentação u8g2**: https://github.com/olikraus/u8g2
- **u8g2pico GitHub**: https://github.com/georgines/u8g2pico
- **Raspberry Pi Pico SDK**: https://datasheets.raspberrypi.org/pico/raspberry-pi-pico-c-sdk.pdf

## 🔄 Reinstalação

Para reinstalar ou atualizar a biblioteca, simplesmente execute o script novamente. Ele automaticamente:
- Remove versões anteriores
- Baixa as versões mais recentes
- Reconfigura o CMakeLists.txt

---

**Nota**: Certifique-se de estar conectado à internet durante a instalação, pois o script precisa baixar as bibliotecas do GitHub.
