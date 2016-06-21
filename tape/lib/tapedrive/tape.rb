# Core for tapedrive gem\n
# Defines a tape object\n
# Used for low level storing and reading of data off of .tap files\n
class Tape
  attr_reader :name
  # @!attribute [r] name
  #   @return [String] The name of the tape
  # Initalizes a new tape object.
  #@!method initalize(name)
  # @param name [String] Name for the tape or .tap file
  def initialize(name)
    @cont=[]
    @name=name
    if File.exists?("./"+name+".tap")
      cont = File.read("./"+name+".tap")
      @cont = cont.split("\n")
	end
  end
  #Read a character from a specific location.
  # @!method read(char)
  #   @param char [Integer] Location of character to get
  #   @return [String]  The character read from tape
  def read(char)
	return @cont[char]
  end

  # Writes a character at a specific location
  # @!method quit(username, message = "Quit")
  #   @param char [Integer] Location of character to set
  #   @param data [String] Character to write
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
  # @!method write_to_file()
  #   @return [void]
  def write_to_file()
   f = File.open("./"+@name+".tap","w")
   @cont.each do |val|
      f.puts val
   end
   f.rewind
   f.close
  end
end
