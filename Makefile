# Arquivos e comandos
RELATORIO    = identificador_netlist.txt
TCL_SCRIPT   = identificador_netlist.tcl
ORGANIZAR_SH = projeto/organizar.sh
TCLSH        = tclsh
BASH         = bash

# Gerar Relatório final, caso não exista
relatorio_final: $(RELATORIO)

$(RELATORIO): $(TCL_SCRIPT)
	@$(TCLSH) $(TCL_SCRIPT) > $(RELATORIO)

# Organizar arquivos:
organizar_arquivos:
	@$(BASH) $(ORGANIZAR_SH)

# Remove o relatório final
clean:
	@rm -f $(RELATORIO)

all: relatorio_final organizar_arquivos

.PHONY: all clean relatorio_final organizar_arquivos
