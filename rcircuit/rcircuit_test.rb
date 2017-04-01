# Ruby Circuit Simulator
# Test Script

require_relative "rcircuit_lib"

#default 1-bit
def and_test()
  puts "AND Test:"
  in_a = Port.new()
  in_b = Port.new()
  and_gate = AndGate.new(in_a, in_b)
  dbg = Dbg.new( {"a"=>in_a, "b"=>in_b, "and"=>and_gate.output})
  dbg.out
  in_a.value = 0
  in_b.value = 1
  dbg.out
  in_a.value = 1
  dbg.out
end

def reg_test()
  puts "Reg Test:"
  din = Port.new(8)
  c = Port.new
  e = Port.new
  r = Port.new
  reg = Reg.new(8,{"data_in"=>din,"clk"=>c,"en"=>e,"rst"=>r})
  dbg = Dbg.new({"in"=>din, "clk"=>c, "en"=>e, "rst"=>r, "out"=>reg.data_out})
  r.value = 1
  c.value = 0
  e.value = 0
  din.value = 23
  dbg.out
  r.value = 1
  dbg.out 
  r.value = 0
  dbg.out
  c.value = 1
  dbg.out
  e.value = 1
  dbg.out
  c.value = 0
  dbg.out
  c.value = 1
  dbg.out
  din.value = 37
  dbg.out
end

def decoder_test()
  puts "Decoder Test:"
  select=Port.new(2)
  decoder=Decoder.new(2,"sel"=>select)
  dbg = Dbg.new({"sel"=>select, "0"=>decoder.o0, "1"=>decoder.o1, "2"=>decoder.o2, "3"=>decoder.o3})
  dbg.out
  select.value=0
  dbg.out
  select.value=1
  dbg.out
  select.value=2
  dbg.out
  select.value=3
  dbg.out
end

def mux_test()
  puts "Mux test:"
  select = Port.new(1)
  a = Port.new(4)
  b = Port.new(4)
  mux = Mux.new(4, 1).sel(select).in0(a).in1(b)
  dbg = Dbg.new({"sel"=>select, "0"=>a, "1"=>b, "out"=>mux.out})
  a.value = 3
  b.value = 14
  dbg.out
  select.value = 0
  dbg.out
  select.value = 1
  dbg.out
end

def addc_test()
puts "Add constant test:"
a = Port.new(8)
sum = a + 2
dbg = Dbg.new({"a"=>a, "a+2"=>sum})
dbg.out
a.value = 7
dbg.out
end

def ram_test()
  puts "RAM test:"
  din=Port.new(8)
  addr=Port.new(8)
  wr=Port.new
  clk=Port.new
  ram=Ram.new(8,8,{"data_in"=>din,"addr"=>addr,"wr"=>wr,"clk"=>clk})
  dbg=Dbg.new({"din"=>din,"dout"=>ram.data_out,"addr"=>addr,"wr"=>wr,"clk"=>clk})
  clk.value=0
  din.value=11
  addr.value=0
  wr.value=1
  clk.value=1
  dbg.out
  clk.value=0
end
def test()
  methods=Object.private_instance_methods
  methods.each do |m|
    if m.to_s.include? "_test"
      puts "Found test method:#{m}"
      method(m).call()
    end
  end
  classes=Object.constants
  classes.each do |c|
    puts "Before, c=#{c.inspect}"
    c=Object.const_get(c)
    puts "After, c=#{c.inspect}"
    if c.class == Class && !c==Object
      if c.instance_methods.include? :test
        puts "Found test method on class:#{c}"
        c.method(:test).call
      end
    end
  end
end

test()