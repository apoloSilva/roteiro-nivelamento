#Ler o arquivo verilog 

set fp [open "contador_netlist.v" r]
set file_data [read $fp]

#libera o buffer do arquivo contador_netlist.v
close $fp

#separar por linhas
set data [split $file_data "\n"]

#loop para separar
foreach line $data {
puts $line
puts "==========="
}


puts "=== RELATÓRIO DE CÉLULAS ==="

# Ler celulas 

# Salvar celulas

# Printar celulas 
