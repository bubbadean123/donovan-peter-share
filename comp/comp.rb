class Tape
  #reading endc:class.endc
  #writing endc:class.endc=data

  attr_accessor :endc

  def initialize(end_char="~")
    @tape=""
    @endc=end_char
    @cont=[]
    @name=""
  end

  def read(char)
	@cont[char]
  end

  def write(char,data)
      cont = @cont
      cont.delete(@endc)
	  cont[char]=data
	  cont<<@endc
      @tape.rewind
      @tape.puts cont
  end

  def insert(name)
    if File.exists?(name+".tap")
      cont = File.read(name+".tap")
      @cont = cont.split("\n")
      @cont.delete(@endc)
      @tape = File.open("./tapes/"+name+".tap","w+")
      @tape.puts cont
      @tape.rewind
      @name=name
    else
    @tape = File.open(name+".tap","w+")
	@name=name
	end
  end

  def eject()
    @tape.rewind()
    @tape.close()
    @tape=nil
    @cont=[]
  end
end

tape=Tape.new
tape.insert("data")
tape.write(0,1)
tape.write(2,3)
puts tape.read(0)
puts tape.read(1)
puts tape.read(2)
tape.eject()