
require_relative "rcircuit_lib"


class ALU < Device
  def initialize(init_args={},width)
    #feine inputs and outputs
    define_port('a', width)
    define_port('b', width)
    define_port('op', 4)
    define_port('out', width)
    #connect ports in init arguments
    init_assign(init_args)
    #create internal components
    mux = Mux.new(8, 4).sel(op)
                       .in0(a + b)
                       .in1(a - b)
                       .in2(a & b)
                       .in3(a | b)
                       .in4(a ^ b)
                       .in5(!a)
                       .in6(!b)
                       .in7(a)
                       .in8(b)
                       .in9(a << 1)
                       .in10(a >> 1)
                       .in11(a + 1)
                       .in12(a - 1)
                       .in13(0)
                       .in14(0)
                       .in15(0)
    mux.out.connect(out)
  end	
end

def ALU.test
  puts "ALU test"
  a=Port.new(8)
  b=Port.new(8)
  op=Port.new(4)
  alu=ALU.new({"a"=>a,"b"=>b,"op"=>op},8)
  dbg=Dbg.new({"a"=>a,"b"=>b,"op"=>op,"out"=>alu.out},true)
  a.value=3
  b.value=10
  dbg.add_trigger("op")
  for i in (0..15) do
    op.value=i
    #dbg.out
  end
end

test()

#start of KT8 parts

clk = Port.new(1)
rst = Port.new(1)

pc = Counter.new(8).clk(clk).rst(rst)
reg_a = Reg.new(8).clk(clk).rst(rst)
reg_b = Reg.new(8).clk(clk).rst(rst)
reg_r = Reg.new(8).clk(clk).rst(rst)
prog_mem = Ram.new(8, 8).clk(clk).addr(pc.out).wr(0)
data_mem = Ram.new(8, 6).clk(clk)
alu = ALU.new(8).a(reg_a.out).b(reg_b.out).op(prog_mem.out[0..3]).out(reg_r.in)

#reg A input is always from data memory
reg_a.in(data_mem.out)

#reg B can be from memory or current value combined with immediate bits
low_bit_combine = reg_b.out[4..7].join(prog_mem.out[0..3])
high_bit_combine = prog_mem.out[0..3].join(reg_b.out[0..3])
reg_b_source = Mux.new(8,2).in0(data_mem.out)
                           .in1(low_bit_combine)
                           .in2(high_bit_combine)
reg_b.in(reg_b_source.out)








