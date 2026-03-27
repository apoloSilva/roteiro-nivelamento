
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

	set idx [string first $palavraAND2 $line]

	if {$idx != -1} {
		puts "---TEST 1---"
		puts "$palavraAND2 Found"
		puts "-----------"

	}

}

puts "$palavraAND2: $ctrADN2 instâncias"
puts "$palavraXOR2: $ctrXOR2 instâncias"
puts "$palavraFFD: $ctrFLIPFLOP_D instâncias"
set total [expr {$ctrADN2 + $ctrXOR2 + $ctrFLIPFLOP_D}]
puts "TOTAL: $total"


