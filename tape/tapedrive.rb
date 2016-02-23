require "./tape"

class TapeDrive

  def initialize()
    @tape=nil
  end

  def eject()
   unless @tape.nil?
     @tape.write_to_file()
     @tape = nil
    end
  end

  def insert(name)
    @tape = Tape.new(name)
  end
  
  def write(data,start=0)
    start=start
    data.each_char do |val|
      @tape.write(start,val)
      start += 1
     end
  end

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



   
  
    
       