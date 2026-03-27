#!/bin/bash

DRY_RUN=0
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=1
fi

echo "hello, world"
ls

echo "indo para diretorio projeto"
cd projeto || exit

CAMINHO_PROJETO=$(pwd)

echo "Diretorio projeto:"
ls

# Função auxiliar para mover ou apenas mostrar
move_file() {
    local file="$1"
    local dest_dir="$2"
    local dest_path="$dest_dir/$(basename "$file")"
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "[DRY RUN] moveria '$file' para '$dest_path'"
    else
        mkdir -p "$dest_dir"
        mv "$file" "$dest_path"
        echo "movido: $file -> $dest_path"
    fi
}

# Percorre todos os arquivos no diretório (não subdiretórios)
for file in "$CAMINHO_PROJETO"/*; do
    # Ignora diretórios existentes (para não tentar mover as pastas de destino)
    if [[ -d "$file" ]]; then
        continue
    fi

    filename=$(basename "$file")
    extension="${filename##*.}"
    lower_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    case "$extension" in
        v)
            # Verifica se é testbench
            if [[ "$lower_filename" == *_tb.v || "$lower_filename" == *test*.v ]]; then
                move_file "$file" "tb"
            else
                move_file "$file" "src"
            fi
            ;;
        vh)
            move_file "$file" "include"
            ;;
        tcl|do|sh)
            move_file "$file" "scripts"
            ;;
        *)
            # Para outros tipos, coloca em docs (ou pode ignorar)
            move_file "$file" "docs"
            ;;
    esac
done

echo
echo "Classificação concluída."

# Função para exibir a árvore de diretórios
print_tree() {
    local dir="$1"
    if command -v tree &> /dev/null; then
        tree "$dir"
    else
        echo "Comando 'tree' não encontrado. Exibindo estrutura com find:"
        find "$dir" -type d -print0 | while IFS= read -r -d '' d; do
            depth=$(echo "$d" | tr -cd '/' | wc -c)
            indent=$(printf '%*s' $((depth*2)) '')
            echo "${indent}$(basename "$d")/"
        done
        find "$dir" -type f -print0 | while IFS= read -r -d '' f; do
            depth=$(echo "$f" | tr -cd '/' | wc -c)
            indent=$(printf '%*s' $((depth*2)) '')
            echo "${indent}$(basename "$f")"
        done | sort
    fi
}

echo
echo "Estrutura final do diretório projeto:"
if [[ $DRY_RUN -eq 1 ]]; then
    echo "(Modo DRY RUN – nenhuma alteração foi feita. A estrutura abaixo é a atual.)"
fi
print_tree "$CAMINHO_PROJETO"
