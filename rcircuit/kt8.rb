
require_relative "rcircuit_lib"


class ALU < Device
  def initialize(init_args={},width)
    #define inputs and outputs
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
  puts "ALU test:"
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
  end
end
class Decoder < Device
  def initialize(init_args={})
    define_input("ins",8)
    init_assign(init_args)
    define_port("aen")
    define_port("ben")
    define_port("ren")
    define_port("wr")
    define_port("rbsel",2)
    aen.value=0
    ben.value=0
    ren.value=0
    wr.value=0
    rbsel.value=0
  end
  def on_change(new_val)
    puts "ins:#{ins.value}"
    if ins[5..7]=="000"
      aen.value=1
      ben.value=0
      ren.value=0
      wr.value=0
      rbsel.value=0
    end
    if ins[5..7]=="001"
      aen.value=0
      ben.value=1
      ren.value=0
      wr.value=0
      rbsel.value=0
    end
    if ins[5..7]=="010"
      aen.value=0
      ben.value=0
      ren.value=0
      wr.value=1
      rbsel.value=0
    end
    if ins[4..7]=="0110"
      aen.value=0
      ben.value=0
      ren.value=0
      wr.value=0
      rbsel.value=1
    end
    if ins[4..7]=="0111"
      aen.value=0
      ben.value=0
      ren.value=0
      wr.value=0
      rbsel.value=2
    end
    if ins[4..7]=="1000"
      aen.value=0
      ben.value=0
      ren.value=1
      wr.value=0
      rbsel.value=0
    end
    puts "aen:#{aen.value}"
    puts "ben:#{ben.value}"
    puts "ren:#{ren.value}"
    puts "wr:#{wr.value}"
    puts "rbsel:#{rbsel.value}"
  end
end
#start of KT8 parts
class KT8 < Device
 def initialize(init_args={})
  define_port("clk")
  define_port("rst")
  define_port("dout",8)
  define_port("ins",8)
  init_assign(init_args)
  define_port("wr")
  define_port("paddr",8)
  define_port("daddr",5)
  define_port("din",8)
  dec = Decoder.new().ins(ins)
  wr.connect(dec.wr)
  pc = Counter.new(8).clk(clk).rst(rst).load(0)
  paddr.connect(pc.out)
  reg_a = Reg.new(8).clk(clk).rst(rst).en(dec.aen)
  reg_b = Reg.new(8).clk(clk).rst(rst).en(dec.ben)
  reg_r = Reg.new(8).clk(clk).rst(rst).en(dec.ren)
  alu = ALU.new(8).a(reg_a.out).b(reg_b.out).op(ins[0..3]).out(reg_r.in)
  daddr.connect(ins[0..4])
  din.connect(reg_r.out)
  #reg A input is always from data memory
  reg_a.in(dout)
  wr.connect(wr)
  #reg B can be from memory or current value combined with immediate bits
  low_bit_combine = reg_b.out[4..7].join(ins[0..3])
  high_bit_combine = ins.out[0..3].join(reg_b.out[0..3])
  reg_b_source = Mux.new(8,2).in0(dout).in1(low_bit_combine).in2(high_bit_combine).sel(dec.rbsel)
  reg_b.in(reg_b_source.out)
  end
end
clk=Port.new
rst=Port.new
prog_mem=Ram.new(8,8)
data_mem=Ram.new(8,5)
kt8=KT8.new("clk"=>clk,"rst"=>rst,"dout"=>data_mem.out,"ins"=>prog_mem.out)
prog_mem.addr(kt8.paddr).clk(clk).wr(0).in(0)
data_mem.addr(kt8.daddr).clk(clk).wr(kt8.wr).in(kt8.din)
dbg=Dbg.new("daddr"=>kt8.daddr,"in"=>kt8.din)
prog_mem[0]="00000000"
prog_mem[1]="10000111"
prog_mem[2]="01000001"
data_mem[0]="1011"
rst.value=1
rst.value=0
dbg.out
clk.value=1
dbg.out
clk.value=0
dbg.out
clk.value=1
dbg.out
clk.value=0
dbg.out
clk.value=1
dbg.out
clk.value=0
dbg.out
puts "Putting.."
puts data_mem[1].inspect