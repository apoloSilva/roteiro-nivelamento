#Ler o arquivo verilog 

set fp [open "contador_netlist.v" r]
set file_data [read $fp]

# Iniciando variáveis contadoras

set ctrADN2 0
set ctrXOR2 0
set ctrFLIPFLOP_D 0

#libera o buffer do arquivo contador_netlist.v
close $fp

#separar por linhas
set data [split $file_data "\n"]

#loop para separar


foreach line $data {
set palavra "AND2"

if {[string first "*$palavra*" $line]} {
 
  set ctrAND2 $ctrAND2
  set ctrAND2 [expr 6 + 1]
}

}

puts $ctrAND2 

puts "=== RELATÓRIO DE CÉLULAS ==="

# Ler celulas 

# Salvar celulas

# Printar celulas 
