# Instalador u8g2pico

Script para instalar automaticamente a biblioteca **u8g2pico** e **u8g2lib** em projetos Raspberry Pi Pico.

## 📋 O que você precisa

- Git instalado (teste com `git --version`)
- Projeto Raspberry Pi Pico com arquivo `CMakeLists.txt`

## 🚀 Como instalar

### 1. Abra o terminal no VS Code
- Pressione `Ctrl + Shift + ` ` (crase)
- Se não for Bash, clique na seta ao lado do nome do terminal e escolha "Git Bash"

### 2. Vá para a pasta do seu projeto
```bash
cd /c/caminho/para/seu/projeto_pico
```

### 3. Baixe e execute o script
```bash
# Baixe o script
curl -O https://raw.githubusercontent.com/georgines/instalador_u8g2pico/main/instalar_u8g2pico.sh

# Execute o script
bash ./instalar_u8g2pico.sh
```

## � Exemplo de uso

Depois da instalação, use assim no seu código:

```c
#include "pico/stdlib.h"
#include "u8g2pico.h"

#define I2C_PORT i2c1
#define SDA_PIN 14
#define SCL_PIN 15
#define I2C_ADDR 0x3C

static u8g2pico_t u8g2pico;

int main() {
    stdio_init_all();

    // Configurar display
    u8g2_Setup_ssd1306_i2c_128x64_noname_f_pico(&u8g2pico, I2C_PORT, SDA_PIN, SCL_PIN, U8G2_R0, I2C_ADDR);
    
    // Inicializar
    u8g2_InitDisplay(&u8g2pico);
    u8g2_SetPowerSave(&u8g2pico, 0);
    
    // Escrever texto
    u8g2_ClearBuffer(&u8g2pico);
    u8g2_SetFont(&u8g2pico, u8g2_font_8bitclassic_tf);
    u8g2_DrawStr(&u8g2pico, 0, 25, "Hello World!");
    u8g2_SendBuffer(&u8g2pico);
}
```

## 🛠️ Problemas comuns

**Git não encontrado?**
- Instale o Git: https://git-scm.com/downloads

**Não tem o arquivo CMakeLists.txt?**
- Execute o script na pasta raiz do seu projeto Pico

**Para reinstalar:**
- Execute o script novamente

## 📚 Links úteis

- [Documentação u8g2](https://github.com/olikraus/u8g2)
- [u8g2pico no GitHub](https://github.com/georgines/u8g2pico)
