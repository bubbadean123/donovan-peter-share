# Core for tapedrive gem
# Defines a tape object
# Used for low level storing and reading of data off of .tap files
class Tape

  # Initalizes a new tape object.
  # @param [String] name Name for the tape or .tap file
  def initialize(name)
    @cont=[]
    @name=name
    if File.exists?(name+".tap")
      cont = File.read(name+".tap")
      @cont = cont.split("\n")
	end
  end

  # Reads one character from the tape
  # @param [Integer] char Location of character to get
  # @return [String]  The character read from tape
  def read(char)
	return @cont[char]
  end

  # Writes a character at a specific location
  # @param [Integer] char Location of character to set
  # @param [String] data Character to write
  # @return [void]
  def write(char,data)
      cont = @cont
      cont.delete("~")
	  cont[char]=data
	  cont<<"~"
	  @cont = cont
      write_to_file()
  end

  #Method to update .tap file
  # @return [void]
  def write_to_file()
   f = File.open(@name+".tap","w")
   @cont.each do |val|
      f.puts val
   end
   f.rewind
   f.close
  end
end
