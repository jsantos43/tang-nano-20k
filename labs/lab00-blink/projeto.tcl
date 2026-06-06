set_device GW2AR-LV18QN88C8/I7 -name GW2AR-18C

add_file src/top.v
add_file constraints.cst

set_option -output_base_name top
set_option -synthesis_tool gowinsynthesis
set_option -top_module top

run all
