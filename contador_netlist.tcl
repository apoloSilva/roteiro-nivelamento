
puts "=== RELATÓRIO DE CÉLULAS ==="


## Leitura das linhas do arquivo
set fp [open "contador_netlist.v" r]
set file_data [read $fp]

#libera o buffer do arquivo contador_netlist.v
close $fp

# separar por linhas
set data [split $file_data "\n"]

## Iniciando variáveis contadoras e constantes

set ctrADN2 0
set ctrXOR2 0
set ctrFLIPFLOP_D 0
set palavraAND2 "AND2"

set palavraXOR2 "XOR2"
set palavraFFD "flipflop_D"

## Contando quantas vezes cada  palavra aparece no arquivo .v, uma linha por vez
# incompleto, pois string first retorna apenas a ocorrência da palavra na linha
foreach line $data {
<<<<<<< HEAD
    # Contar AND2 instanciado: padrão "AND2 U" seguido de dígitos (ou qualquer identificador)
    if {[regexp {AND2\s+U\d+} $line]} {
        incr ctrAND2
    }
    # Contar XOR2 instanciado
    if {[regexp {XOR2\s+U\d+} $line]} {
        incr ctrXOR2
    }
    # Contar flipflop_D instanciado: padrão "flipflop_D" seguido de espaço e identificador (ex: ff0)
    if {[regexp {flipflop_D\s+\w+} $line]} {
        incr ctrFLIPFLOP_D
    }
}


# Calcular total
set total [expr $ctrAND2 + $ctrXOR2 + $ctrFLIPFLOP_D]

puts "=== RELATÓRIO DE CÉLULAS ==="
puts "AND2: $ctrAND2"
puts "XOR2: $ctrXOR2"
puts "flipflop_D: $ctrFLIPFLOP_D"
puts "TOTAL DE INSTÂNCIAS: $total"
=======
	
	# contador de "AND2" 
	set pos 0
	while {1} { #loop com break para quando nenhuma palavra "AND2" é encontrada na linha
		set idx [string first $palavraAND2 $line $pos]
		if {$idx == -1} {
			break
		} else {
			set ctrADN2 [expr {$ctrADN2 + 1}]
			set pos [expr {$idx + 4}] ;# atualiza o valor de pos para a posição na linha após a palvra
		}
	}
	
	# contador de "XOR2"
	set pos 0
	while {1} { #loop com break para quando nenhuma palavra "XOR2" é encontrada na linha
		set idx [string first $palavraXOR2 $line $pos]
		if {$idx == -1} {
			break
		} else {
			set ctrXOR2 [expr {$ctrXOR2 +1}]
			set pos [expr {$idx + 4}] ;# atualiza o valor de pos para a posição após o idex da palavra encontrada
		}
	}
	
	# contador de "flipflop_D"
	set pos 0
	while {1} { #loop com até encontrar que nenhuma palavra "flipflop_D" seja encontrada na linha
		set idx [string first $palavraFFD $line $pos]
		if {$idx == -1} {
			break
		} else {
			set ctrFLIPFLOP_D [expr + {$ctrFLIPFLOP_D + 1}]
			set pos [expr {$idx + 10}] ;# atualiza o valor de pos para a posição após o idex da palavra encontrada
		}
	}
	
}

puts "$palavraAND2: $ctrADN2 instâncias"
puts "$palavraXOR2: $ctrXOR2 instâncias"
puts "$palavraFFD: $ctrFLIPFLOP_D instâncias"
set total [expr {$ctrADN2 + $ctrXOR2 + $ctrFLIPFLOP_D}]
puts "TOTAL: $total"
>>>>>>> origin/apolo
