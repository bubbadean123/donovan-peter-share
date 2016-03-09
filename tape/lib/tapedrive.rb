require "tapedrive/tape"
# Defines a tapedrive object
# Used for high level reading and writing of tapes
class TapeDrive
  # Initalizes a new tapedrive object.
  def initialize()
    @tape=nil
  end

  # Ejects the current tape
  # @return [void]
  def eject()
   unless @tape.nil?
     @tape.write_to_file()
     @tape = nil
    end
  end

  # Insert a new tape
  # @param [String] name Name of tape to insert
  # @return [void]
  def insert(name)
    if @tape == nil
      @tape = Tape.new(name)
    else
      puts "Tape #{@tape.name} already in,  eject first"
    end
  end

  # Write a string on to the tape.
  # @param [String] data String to write
  # @param [Integer] start Start location for writing.
  # @return [void]
  def write(data,start=0)
    start=start
    data.each_char do |val|
      @tape.write(start,val)
      start += 1
     end
  end

  # Read a string on the tape
  # @param [Integer] start Start positiion for reading.
  # @param [Integer] end_pos End position for reading.
  # @return [String] The data read from the tape
   def read(start=0,end_pos=nil)
     start=start
     end_pos = end_pos
     string = ""
     unless end_pos.nil?
       range = start..end_pos
       range.each do |val|
         string += @tape.read(val)
       end
     else
       while true
       char = @tape.read(start)
       if char == "~"
         break
       else
         string += char
      end
      start += 1
      end
    end
    return string
  end
end






