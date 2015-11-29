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
if @tape.closed?
insert(@name)
end
    content=@cont
    @tape.rewind
    #How do we fix this?
    if content.empty?
      current_content_array = @tape.read.split("\n")
    else
      current_content_array = content
    end
    @tape.rewind
    current_content_array[char] = data
	@cont=[]
    current_content_array.each do |character|
	  character=character.to_s
      if character == @endc
	  next
	  else
	  @tape.puts(character)
	  @cont.push(character)
 	  end
    end
@tape.puts(@endc)
@cont.push(@endc)
@tape.close
  end

  def insert(name)
    if File.exists?(name+".tap")
      @cont = File.read(name+".tap").split("\n")
    end
    @name=name
    @tape = File.open(name+".tap","w+")
    return
  end

  def eject()
    @tape.rewind()
    tapec=@tape.read.split("\n")
    @tape.close()
    if tapec.include?(@endc) and tapec.last!=@endc
      tapec.delete(@endc)
      tapec << @endc
      tape=File.open(@name,"w+")
      tapec.each do |character|
        tape.puts(character)
      end
      tape.rewind()
      tape.close()
    elsif tapec.last != @endc
      tapec << @endc
      tape=File.open(@name,"w+")
      tapec.each do |character|
        tape.puts(character)
      end
      tape.rewind()
	tape.rewind()
      tape.close()
    end
	puts File.read(@name)
    @tape=nil
    @cont=[]
  end
end

tape=Tape.new
tape.insert("data")
puts "----"
tape.write(0,"w")
puts "----"
tape.write(2,"test")
puts "----"
puts tape.read(0)
puts tape.read(1)
puts tape.read(2)
puts tape.read(3)