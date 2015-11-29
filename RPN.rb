$stack = []
def add()
a = $stack.pop().to_i
b = $stack.pop().to_i
$stack.push(a+b)
end
def subc()
a = $stack.pop().to_i
b = $stack.pop().to_i
$stack.push(a-b)
end
def mult()
a = $stack.pop().to_i
b = $stack.pop().to_i
$stack.push(a*b)
end
def div()
a = $stack.pop().to_i
b = $stack.pop().to_i
$stack.push(a/b)
end
def equ()
puts $stack[-1]
end
while true
puts "Num/Op:"
inp = gets.chomp
case inp
when /[1-9]/
inp = inp.to_i
$stack.push(inp)
puts "Stack:"
puts $stack
when "+"
add()
equ()
puts "Stack:"
puts $stack
when "-"
subc()
equ()
puts "Stack:"
puts $stack
when "*"
mult()
equ()
puts "Stack:"
puts $stack
when "/"
div()
equ()
puts "Stack:"
puts $stack[]
end
end