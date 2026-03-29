## ------------------ CARREGAR E LER ARQUIVO VERILOG ------------------

set file_manager [open "contador_netlist.v"]
set file_data [read $file_manager]

close $file_manager; #libera o buffer do arquivo contador_netlist.v

## ------------------ CALCULOS ------------------

# separa os dados do arquivo por linha
set data [split $file_data "\n"]

# Definindo variáveis e constantes
set nets {}; # cada net será uma Key e o seu Value é o número de fanouts
             # são considerados nets tanto fios internos quanto externos
            
# Primeiramente, é feita o identicação de todas as nets (keys)
foreach line $data {
	
	set idx_input [string first "input" $line]
	set idx_output [string first "output" $line]
	set idx_wire [string first "wire" $line]
	set idx_reg [string first "reg" $line]

	if {($idx_input != -1 || $idx_output != -1 || $idx_wire != -1) && $idx_reg == -1} {
		#puts $line
		set idx_comma [string first "," $line [expr {[string length $line]-1}]]; # em verilog, quando define-se uma net, termina-se sempre com , ou ;
		set idx_semicolon [string first ";" $line [expr {[string length $line]-1}]]
		
		# para não ter que fazer um cojunto de blocos para cada tipo de net
		if {$idx_input != -1} {
			set pos $idx_input
			set offset 5
		}
		if {$idx_output != -1} {
			set pos $idx_output
			set offset 6
		}
		if {$idx_wire != -1} {
			set pos $idx_wire
			set offset 4
		}
		####
		
		# encontra o name do net na linha e guarda em uma variável
		if {$idx_comma != -1 && $idx_semicolon == -1} {
			set net_name [string trim [string range $line [expr {$pos + $offset}] [expr {$idx_comma -1}]]]
			set idx_brl [string first "]" $net_name]
			if {$idx_brl != -1} {
				set net_name [string trim [string range $net_name [expr {$idx_brl +1}] end]]
				#puts $net_name
			} else {
				#puts $net_name
			} 
		} elseif {$idx_comma == -1 && $idx_semicolon != -1} {
			set net_name [string trim [string range $line [expr {$pos + $offset}] [expr {$idx_semicolon -1}]]]
			set idx_brl [string first "]" $net_name]
			if {$idx_brl != -1} {
				set net_name [string trim [string range $net_name [expr {$idx_brl +1}] end]]
				#puts $net_name
			} else {
				#puts $net_name
			} 
		} else {
			set net_name [string trim [string range $line [expr {$pos + $offset}] end]]
			set idx_brl [string first "]" $net_name]
			if {$idx_brl != -1} {
				set net_name [string trim [string range $net_name [expr {$idx_brl + 1}] end]]
				#puts $net_name
			} else {
				#puts $net_name
			} 
		}
		dict set nets $net_name {}
	}
	
}

#Após a entrada de cada key, o código é percorrido de novo, dessa vezes apenas para contagem do fanout
set ctr 0
dict for {key value} $nets {
	#conta quantas vezes a chave aparece nos dados
	foreach line $data {
		set pos 0
		while {1} { #devemos percorrer toda a linha
			set idx [string first $key $line $pos]
			if {$idx == -1} {
					break
			} else {
					set ctr [expr {$ctr + 1}]
					set pos [expr {$idx + [string length $key]}]
			}
		}	
	}
	dict set nets $key [expr {$ctr - 1}]
	set ctr 0		
}


## ------------------ EXIBINDO OS RESULTADOS ------------------
puts "=== TOP 10 NETS POR FANOUT ==="

dict for {key value} $nets {
	
	if {$value > 0} {
		puts "${key}: fanout = ${value}"
	}
	
}

puts "=== NETS COM FANOUT ZERO (POSSÍVEIS ERROS) ==="

dict for {key value} $nets {
	
	if {$value == 0} {
		puts "${key}"
	}
	
}

