class Tape

  def initialize(name)
    @cont=[]
    @name=name
    if File.exists?(name+".tap")
      cont = File.read(name+".tap")
      @cont = cont.split("\n")
	end
  end

  def read(char)
	@cont[char]
  end

  def write(char,data)
      cont = @cont
      cont.delete("~")
	  cont[char]=data
	  cont<<"~"
	  @cont = cont
      write_to_file()
  end
  
  def write_to_file()
    if !Dir.exists?("tapes")
	  Dir.mkdir("tapes")
    end
   f = File.open(@name+".tap","w")
   @cont.each do |val|
      f.puts val
   end
   f.rewind
   f.close
  end
end
