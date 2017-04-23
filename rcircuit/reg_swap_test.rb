#testing propagation of nets by using two registers wired to each other

require_relative "rcircuit_lib"


clk = Port.new
sel = Port.new
rst = Port.new
reg_en = Port.new
init_val = Port.new(8)

reg_a = Reg.new(8).clk(clk).rst(rst).en(reg_en)
reg_b = Reg.new(8).clk(clk).rst(rst).en(reg_en)
#for loading reg_a with an initial value
init_mux = Mux.new(8,1).in0(reg_b.out).in1(init_val).sel(sel)
reg_a.in(init_mux.out)
reg_b.in(reg_a.out)

dbg=Dbg.new("clk"=>clk,"init"=>init_val,"a.out"=>reg_a.out,"b.out"=>reg_b.out)

rst.value = 1
clk.value = 0
rst.value = 0
reg_en.value = 1
init_val.value = 1 
sel.value = 1
puts "Loading 1 into A"
clk.value = 1  #loads 1 into A
dbg.out
init_val.value = 2
clk.value = 0
puts "Loading 2 into A, 1 into B"
clk.value = 1  #loads 2 into A, 1 into B
dbg.out
puts "Swapping A<->B"
sel.value = 0  #set to swap A <-> B
clk.value = 0
clk.value = 1
dbg.out
clk.value = 0
clk.value = 1
dbg.out
clk.value = 0
clk.value = 1
dbg.out

