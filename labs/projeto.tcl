# projeto.tcl — Gowin EDA
# Chamado pelo Makefile via: echo "source projeto.tcl" | gw_sh
# A variável LAB é substituída pelo Makefile antes de executar

set_device GW2AR-LV18QN88C8/I7 -name GW2AR-18C

add_file $env(LAB)/top.v
add_file constraints.cst

set_option -output_base_name top
set_option -synthesis_tool gowinsynthesis
set_option -top_module top

run all
