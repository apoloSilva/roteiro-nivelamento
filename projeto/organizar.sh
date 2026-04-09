#/bin/bash


# Pegar o nome do present script
script_name="$(basename "${BASH_SOURCE[0]}")"


# Mostre todos os arquivos na presente pasta e subpastas

find . -mindepth 1 ! -name "$script_name" | sort | while read -r path; do # encontre todos os arquivos no presente caminho e subpastas menos script_name
    # Remove ./
    clean="${path#./}"

    # Conta a profundidade
    depth=$(grep -o "/" <<< "$clean" | wc -l)

    # Define o prefixo
    prefix=""
    for ((i=0; i<depth; i++)); do
        prefix+="│   "
    done

    echo "${prefix}├── $(basename "$clean")"
done

## Função para mover e para renomear o arquivo caso ele já exista no diretório de destino

mv_auto() {
  f="$1"        # arquivo de origem
  d="$2"        # diretório de destino

  if [ -f "$d/$f" ]; then
	  n=0
	  b="${f%.*}"
	  e=".${f##*.}"
	  t="$d/$f"

	  while [ -e "$t" ]; do
		((n++))
		t="$d/${b}($n)$e"
	  done

	  mv "$f" "$t"
  else
	  mv "$f" "$d"
  fi
}

# Mova cada arquivo de acordo com as regras de classificação
for file in *; do
	if [ -f "$file" ]; then
		ext="${file##*.}"
		
		if [ "$file" = "$script_name" ]; then # Para não mover o script, pule caso o presente arquivo seja o script
			continue
		fi
		
		case "$ext" in
			v)
				if [[ "$file" == *"_tb"* ]]; then
					mkdir -p  tb
					echo "Movendo $file ⟶ tb/"
					mv_auto $file tb
				else
					mkdir -p  src
					echo "Movendo $file ⟶ src/"
					mv_auto $file src
				fi
			;;
			vh)
				mkdir -p  include
				echo "Movendo $file ⟶ include/"
				mv_auto $file include
			;;
			sh)
				mkdir -p  scripts
				echo "Movendo $file ⟶ scripts/"
				mv_auto $file scripts
			;;
			md)
				mkdir -p  docs
				echo "Movendo $file ⟶ docs/"
				mv_auto $file docs
			;;
			txt)
				mkdir -p docs
				echo "Movendo $file ⟶ docs/"
				mv_auto $file docs
			;;
			tcl)
				mkdir -p  scripts
				echo "Movendo $file ⟶ scripts/"
				mv_auto $file scripts
			;;
			do)
				mkdir -p  scripts
				echo "Movendo $file ⟶ scripts/"
				mv_auto $file scripts
			;;
			*)
				#faça nada
			;;
		esac
	fi
done


# Mostre todos os arquivos na presente pasta e subpastas

find . -mindepth 1 ! -name "$script_name" | sort | while read -r path; do # encontre todos os arquivos no presente caminho e subpastas menos script_name
    # Remove ./
    clean="${path#./}"

    # Conta a profundidade
    depth=$(grep -o "/" <<< "$clean" | wc -l)

    # Define o prefixo
    prefix=""
    for ((i=0; i<depth; i++)); do
        prefix+="│   "
    done

    echo "${prefix}├── $(basename "$clean")"
done

