puts "=== HIERARQUIA DO DESIGN ==="


## Leitura das linhas do arquivo
set fp [open "contador_netlist.v" r]
set file_data [read $fp]

#libera o buffer do arquivo contador_netlist.v
close $fp

# separar por linhas
set data [split $file_data "\n"]

## Inicializando dicionário para os módulo e submódulos e outras variáveis
set modules {}
set isubmodule 0
set modulo_atual ""

##Identificar modulos
foreach line $data {

	# procura pela instância do modulo
	set idx [string first "module" $line]
	if {$idx != -1 && $isubmodule == 0} {
		set isubmodule 1	
                set start [expr {$idx +6}];  #define o início logo após "module"
		set idx_paran [string first "(" $line]; #obtém o índice do primeiro parênteses 
		set module_name [string trim [string range $line $start [expr {$idx_paran -1}]]]; #corta o nome do módulo
		set modulo_atual $module_name
		#puts $module_name
		dict set modules $module_name {}; #inclui o modulo no dicionário
	} else { # caso já estejamos percorrendo um modulo

                set idxAND2 [string first "AND2" $line]
		set idxXOR2 [string first "XOR2" $line]
                set idxFFD [string first "flipflop_D" $line]

		if {$idxAND2 != -1} {
			set idx_space [string first " " $line $idxAND2]; #obtém o índice do primeiro espaço
			set inst_name [string trim [string range $line $idxAND2 [expr {$idx_space -1}]]]; #corta o nome do módulo
			set sinst_name "${inst_name} "
			dict append modules $modulo_atual $sinst_name 
			#puts $inst_name
		}

		if {$idxXOR2 != -1} {
			set idx_space [string first " " $line $idxXOR2]; #obtém o índice do primeiro espaço
			set inst_name [string trim [string range $line $idxXOR2 [expr {$idx_space -1}]]]; #corta o nome do módulo
			set sinst_name "${inst_name} "
			dict append modules $modulo_atual $sinst_name 
			#puts $inst_name
		}

		if {$idxFFD != -1} {
			set idx_space [string first " " $line $idxFFD]; #obtém o índice do primeiro espaço
			set inst_name [string trim [string range $line $idxFFD [expr {$idx_space -1}]]]; #corta o nome do módulo
			set sinst_name "${inst_name} "
			dict append modules $modulo_atual $sinst_name 
			#puts $inst_name
		}

	}

        set idx [string first "endmodule" $line]
	if {$idx != -1} {
		set isubmodule 0 
        }

} 

set ctrADN2 0
set ctrXOR2 0
set ctrFLIPFLOP_D 0

dict for {key value} $modules {
	puts "$key"
	
	# contador de "AND2" 
	set pos 0
	while {1} { #loop com break para quando nenhuma palavra "AND2" é encontrada na linha
		set idx [string first "AND2" $value $pos]
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
		set idx [string first "XOR2" $value $pos]
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
		set idx [string first "flipflop_D" $value $pos]
		if {$idx == -1} {
			break
		} else {
			set ctrFLIPFLOP_D [expr + {$ctrFLIPFLOP_D + 1}]
			set pos [expr {$idx + 10}] ;# atualiza o valor de pos para a posição após o idex da palavra encontrada
		}
	}

	#puts "	ctrADN2 = {$ctrADN2}"
	#puts "	ctrXOR2 = {$ctrXOR2}"
	#puts "	ctrFLIPFLOP_D = {$ctrFLIPFLOP_D}"
	
	if {$ctrADN2 == 0 && $ctrXOR2 == 0 && $ctrFLIPFLOP_D == 0} {
		puts "   |___ (módulo primitivo - sem submódulos) \n"
	} elseif {$ctrADN2 == 0 && $ctrXOR2 == 0} {
		puts "   |___ (apenas células primitivas) \n"
	} elseif {$ctrADN2 != 0 || $ctrXOR2 != 0} {
		puts "   |___ (células primitivas) \n"
	} 

	if {$ctrFLIPFLOP_D != 0} {
		puts "   |___ flipflop_D ($ctrFLIPFLOP_D instâncias) \n"
	}

	set ctrADN2 0
	set ctrXOR2 0
	set ctrFLIPFLOP_D 0

}
 






