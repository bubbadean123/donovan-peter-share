require "tapedrive/tape"
# Defines a TapeDrive object
# Used for high level reading and writing of tapes
class TapeDrive
  # Initalizes a new TapeDrive object.
  def initialize()
    @tape=nil
  end

  # Ejects the current tape
  # @return [void]
  def eject()
    unless @tape.nil? #If the tape variable is nil, there is no tape and so no need to eject it.
      @tape.write_to_file() #Write any unsaved changes to disk.
      @tape = nil #set the tape variable to nil, ejecting the tape.
    end
  end

  # Insert a new tape
  # @param name [String] Name of tape to insert
  # @return [void]
  def insert(name)
    if @tape == nil #make sure thre is no tape already in so we do not overwrite the tape.
      @tape = Tape.new(name) #set the tape variable to a new tape.
    else
      puts "Tape #{@tape.name} already in,  eject first"#if a tape is already in, give a message to the user.
    end
  end

  # Write a string on to the tape.
  # @param data [String] String to write
  # @param start [Integer] Start location for writing.
  #@return [void]
  def write(data,start=0)
    start=start
    data.each_char do |val| #start the each loop
      @tape.write(start,val) #write the next character of the string.
      start += 1
     end
  end

  # Read a string on the tape
  # @param start [Integer] Start positiion for reading.
  # @param end_pos [Integer] End position for reading.
  # @return [String] The data read from the tape
   def read(start=0,end_pos=nil)
     start=start
     end_pos = end_pos
     string = "" #we have not read any characters yet, so set this to a blank string.
     unless end_pos.nil? #if the end position does not equal nil, read a chunk, otherwise read the whole tape.
       range = start..end_pos #set the range to read.
       range.each do |val| #begin the each.
         string += @tape.read(val) #read in the next character.
       end
     else  #read the whole tape
       while true
         char = @tape.read(start) #read the next charhacter
         if char == "~" #if the character equals the end character, end the read.
         break
       else
           string += char #otherwise add it to the string
      end
         start += 1 #increment start so we can read in the next character
      end
    end
     return string #return the string
  end

end






