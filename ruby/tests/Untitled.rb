require 'rspec'
class PetersClass
def say(text)
return text
end
def add(a,b)
return a + b
end
end
describe "Peter's tests" do

it "creates a new object" do
	@peters_instance = PetersClass.new
end

it "says hello to everyone" do
	@peters_instance = PetersClass.new
	expect{@peters_instance.say("Hello")}.to == "Hello"
end

it "adds a bunch of numbers together" do
	@peters_instance = PetersClass.new
	expect{@peters_instance.add(5,6)}.to == 11
	expect{@peters_instance.add(6,5)}.to == 11
end
end
