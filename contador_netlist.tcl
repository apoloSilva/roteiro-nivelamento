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