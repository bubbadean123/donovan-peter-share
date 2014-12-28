$stack = []
def add()
a = $stack.shift()
b = $stack.shift()
$stack.push(a+b)
end
def subc()
a = $stack.shift()
b = $stack.shift()
$stack.push(a-b)
end
def mult()
a = $stack.shift()
b = $stack.shift()
$stack.push(a*b)
end
def div()
a = $stack.shift()
b = $stack.shift()
$stack.push(a/b)
end
def equ()
puts $stack.shift()
end
while true
inp = gets.chomp
case inp
when /[1-9]/
inp = inp.to_i
$stack.<<(inp)
when "+"
add()
when "-"
subc()
when "*"
mult()
when "/"
div()
when "="
equ()
end
end