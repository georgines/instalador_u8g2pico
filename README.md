# Instalador u8g2pico

Script para instalar automaticamente a biblioteca **u8g2pico** e **u8g2lib** em projetos Raspberry Pi Pico.

## Sobre as bibliotecas

### u8g2lib
A **u8g2lib** é uma biblioteca monochrome graphics library desenvolvida por **Oliver Kraus (@olikraus)** para displays embarcados. É uma biblioteca amplamente utilizada e reconhecida na comunidade maker, suportando uma grande variedade de displays OLED e LCD.

### u8g2pico
A **u8g2pico** é um port/adaptação da u8g2lib especificamente desenvolvida para o **Raspberry Pi Pico**. Esta biblioteca facilita o uso de displays gráficos monocromáticos no Pico, aproveitando as funcionalidades específicas do RP2040 e do SDK do Pico. Ela ainda está em desenvolvimento.

## Requisitos

- Git instalado
- Projeto Raspberry Pi Pico com arquivo `CMakeLists.txt`

**Para verificar se o Git está instalado:**
```bash
git --version
```

## Instalação

### 1. Abrir o terminal no VS Code
Pressione a combinação de teclas para abrir o terminal integrado:
```
Ctrl + Shift + `
```

Se o terminal não estiver configurado para Bash, clique na seta ao lado do nome do terminal e selecione "Git Bash".

### 2. Navegar para a pasta do projeto
Substitua o caminho abaixo pelo caminho real do seu projeto:
```bash
cd /c/caminho/para/seu/projeto_pico
```

### 3. Baixar o script de instalação
```bash
curl -O https://raw.githubusercontent.com/georgines/instalador_u8g2pico/main/instalar_u8g2pico.sh
```

### 4. Executar o script
```bash
bash ./instalar_u8g2pico.sh
```

## Exemplo de uso

Após a instalação bem-sucedida das bibliotecas, você pode usar o código abaixo como exemplo em seu projeto:

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
    u8g2_DrawStr(&u8g2pico, 0, 25, "U8G2Pico");
    u8g2_SendBuffer(&u8g2pico);
    
    return 0;
}
```

## Solução de problemas

### Git não encontrado
Se você receber um erro de que o Git não foi encontrado, instale-o através do link oficial:
```
https://git-scm.com/downloads
```

### Arquivo CMakeLists.txt não encontrado
Certifique-se de que você está executando o script na pasta raiz do seu projeto Pico onde está localizado o arquivo `CMakeLists.txt`.

### Para reinstalar as bibliotecas
Se for necessário reinstalar, execute o script novamente:
```bash
bash ./instalar_u8g2pico.sh
```

## Links úteis

- [Documentação u8g2](https://github.com/olikraus/u8g2) - Biblioteca original por Oliver Kraus
- [u8g2pico no GitHub](https://github.com/georgines/u8g2pico) - Port para Raspberry Pi Pico

## Créditos

- **Oliver Kraus (@olikraus)** - Criador da biblioteca u8g2lib original
