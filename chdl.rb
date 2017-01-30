$truth_tables={
  "nand"=>{
    [0,0]=>1,
    [0,1]=>1,
    [1,0]=>1,
    [1,1]=>0,
  },
  "and"=>{
    [0,0]=>0,
    [0,1]=>0,
    [1,0]=>0,
    [1,1]=>1,
  },
  "or"=>{
    [0,0]=>0,
    [0,1]=>1,
    [1,0]=>1,
    [1,1]=>1,
  },
  "nor"=>{
    [0,0]=>1,
    [0,1]=>0,
    [1,0]=>0,
    [1,1]=>0,
  },
}
def run_logic(type,inputs)
  return $truth_tables[type][inputs]
end
def test2i(type)
  puts "#{type}:"
  puts "  0,0:"+run_logic(type,[0,0]).to_s
  puts "  0,1:"+run_logic(type,[0,1]).to_s
  puts "  1,0:"+run_logic(type,[1,0]).to_s
  puts "  1,1:"+run_logic(type,[1,1]).to_s
end
test2i("nand")
test2i("and")
test2i("or")
test2i("nor")