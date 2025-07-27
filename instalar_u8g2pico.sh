#!/bin/bash

INSTALL_DIR=${1:-lib}

U8G2PICO_REPO_URL="https://github.com/georgines/u8g2pico.git"
U8G2LIB_REPO_URL="https://github.com/olikraus/u8g2.git"

U8G2PICO_NAME="u8g2pico"
U8G2LIB_NAME="u8g2"

detect_project_name() {
    local cmake_file="$1"
    if [ -f "$cmake_file" ]; then
        local project_line=$(grep -i "^[[:space:]]*project(" "$cmake_file" | head -1)
        if [ -n "$project_line" ]; then
            # Captura nomes de projeto que podem conter letras, números, underscores e hífens
            local project_name=$(echo "$project_line" | sed 's/.*project([[:space:]]*\([a-zA-Z0-9_-][a-zA-Z0-9_-]*\).*/\1/i')
            echo "$project_name"
        fi
    fi
}

update_cmake_file() {
    local cmake_file="CMakeLists.txt"
    local u8g2pico_path="$1"
    
    if [ ! -f "$cmake_file" ]; then
        echo "⚠️  Arquivo CMakeLists.txt não encontrado no diretório atual."
        echo "Você precisará adicionar manualmente:"
        echo "add_subdirectory($u8g2pico_path)"
        echo "target_link_libraries(seu_projeto u8g2pico)"
        return
    fi
    
    echo ""
    echo "=== Atualizando CMakeLists.txt ==="
    
    local project_name=$(detect_project_name "$cmake_file")
    if [ -z "$project_name" ]; then
        echo "⚠️  Não foi possível detectar o nome do projeto no CMakeLists.txt"
        project_name="main"
    else
        echo "📋 Projeto detectado: $project_name"
    fi
    
    cp "$cmake_file" "${cmake_file}.backup"
    echo "📂 Backup criado: ${cmake_file}.backup"
    
    local add_subdirectory_exists=$(grep -n "add_subdirectory.*u8g2pico" "$cmake_file")
    
    if [ -n "$add_subdirectory_exists" ]; then
        echo "🔄 Removendo add_subdirectory existente para u8g2pico..."
        sed -i '/add_subdirectory.*u8g2pico/d' "$cmake_file"
    fi
    
    echo "➕ Adicionando add_subdirectory($u8g2pico_path)..."
    sed -i "/^project(/a add_subdirectory($u8g2pico_path)" "$cmake_file"
    
    local existing_u8g2pico=$(grep -n "target_link_libraries.*u8g2pico" "$cmake_file")
    if [ -n "$existing_u8g2pico" ]; then
        echo "🔄 Removendo referências existentes de u8g2pico em target_link_libraries..."
        sed -i 's/[[:space:]]*u8g2pico[[:space:]]*//g' "$cmake_file"
    fi
    
    local empty_target_link_line=$(grep -n "target_link_libraries($project_name[[:space:]]*$" "$cmake_file" | tail -1 | cut -d: -f1)
    
    if [ -n "$empty_target_link_line" ]; then
        echo "🔄 Encontrada declaração target_link_libraries vazia na linha $empty_target_link_line"
        echo "➕ Substituindo por target_link_libraries com u8g2pico..."
        
        sed -i "${empty_target_link_line}s/target_link_libraries($project_name[[:space:]]*$/target_link_libraries($project_name u8g2pico/" "$cmake_file"
    else
        local last_target_link=$(grep -n "target_link_libraries($project_name" "$cmake_file" | tail -1 | cut -d: -f1)
        
        if [ -n "$last_target_link" ]; then
            echo "➕ Adicionando u8g2pico à última declaração target_link_libraries..."
            
            local line_content=$(sed -n "${last_target_link}p" "$cmake_file")
            if [[ "$line_content" =~ \)$ ]]; then
                sed -i "${last_target_link}s/)$/ u8g2pico)/" "$cmake_file"
            else
                local closing_line=$((last_target_link + 1))
                while [ $closing_line -le $(wc -l < "$cmake_file") ]; do
                    local next_line=$(sed -n "${closing_line}p" "$cmake_file")
                    if [[ "$next_line" =~ \) ]]; then
                        sed -i "${closing_line}i\\        u8g2pico" "$cmake_file"
                        break
                    fi
                    closing_line=$((closing_line + 1))
                done
            fi
        else
            local pico_extra_line=$(grep -n "pico_add_extra_outputs" "$cmake_file" | cut -d: -f1)
            if [ -n "$pico_extra_line" ]; then
                sed -i "${pico_extra_line}i\\target_link_libraries($project_name u8g2pico)\n" "$cmake_file"
            else
                echo "target_link_libraries($project_name u8g2pico)" >> "$cmake_file"
            fi
        fi
    fi
    
    echo "✅ CMakeLists.txt atualizado com sucesso!"
    echo "📝 Configurações do u8g2pico:"
    echo "   add_subdirectory($u8g2pico_path)"
    echo "   target_link_libraries($project_name u8g2pico)"
}

echo "=== Instalador da biblioteca u8g2pico ==="
echo "Pasta de destino: $INSTALL_DIR"

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Pasta '$INSTALL_DIR' não existe. Criando..."
    mkdir -p "$INSTALL_DIR"
    if [ $? -eq 0 ]; then
        echo "Pasta '$INSTALL_DIR' criada com sucesso."
    else
        echo "Erro ao criar a pasta '$INSTALL_DIR'."
        exit 1
    fi
else
    echo "Pasta '$INSTALL_DIR' já existe."
fi

U8G2PICO_PATH="$INSTALL_DIR/$U8G2PICO_NAME"

if [ -d "$U8G2PICO_PATH" ]; then
    echo "Biblioteca '$U8G2PICO_NAME' já existe em '$U8G2PICO_PATH'."
    echo "Removendo versão anterior..."
    rm -rf "$U8G2PICO_PATH"
    if [ $? -eq 0 ]; then
        echo "Versão anterior removida com sucesso."
    else
        echo "Erro ao remover a versão anterior."
        exit 1
    fi
fi

echo "Baixando a biblioteca u8g2pico..."
git clone "$U8G2PICO_REPO_URL" "$U8G2PICO_PATH"

if [ $? -ne 0 ]; then
    echo "❌ Erro ao baixar a biblioteca u8g2pico."
    exit 1
fi

echo "✅ u8g2pico baixado com sucesso."

U8G2LIB_INSTALL_DIR="$U8G2PICO_PATH/lib"
U8G2LIB_PATH="$U8G2LIB_INSTALL_DIR/$U8G2LIB_NAME"

echo ""
echo "=== Instalando dependência u8g2lib ==="

if [ ! -d "$U8G2LIB_INSTALL_DIR" ]; then
    echo "Pasta '$U8G2LIB_INSTALL_DIR' não existe. Criando..."
    mkdir -p "$U8G2LIB_INSTALL_DIR"
    if [ $? -eq 0 ]; then
        echo "Pasta '$U8G2LIB_INSTALL_DIR' criada com sucesso."
    else
        echo "Erro ao criar a pasta '$U8G2LIB_INSTALL_DIR'."
        exit 1
    fi
else
    echo "Pasta '$U8G2LIB_INSTALL_DIR' já existe."
fi

if [ -d "$U8G2LIB_PATH" ]; then
    echo "Biblioteca '$U8G2LIB_NAME' já existe em '$U8G2LIB_PATH'."
    echo "Removendo versão anterior..."
    rm -rf "$U8G2LIB_PATH"
    if [ $? -eq 0 ]; then
        echo "Versão anterior removida com sucesso."
    else
        echo "Erro ao remover a versão anterior."
        exit 1
    fi
fi

echo "Baixando a biblioteca u8g2lib..."
git clone "$U8G2LIB_REPO_URL" "$U8G2LIB_PATH"

if [ $? -ne 0 ]; then
    echo "❌ Erro ao baixar a biblioteca u8g2lib."
    exit 1
fi

echo "✅ u8g2lib baixado com sucesso."

update_cmake_file "$U8G2PICO_PATH"

echo ""
echo "=== Instalação concluída ==="
echo "✅ Biblioteca u8g2pico instalada com sucesso em: $U8G2PICO_PATH"
echo "✅ Dependência u8g2lib instalada em: $U8G2LIB_PATH"
echo "✅ CMakeLists.txt configurado automaticamente"