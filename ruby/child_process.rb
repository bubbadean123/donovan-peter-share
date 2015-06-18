#!/usr/bin/env ruby

puts "Child is now running!"
running = true
while running do
  instruction = STDIN.gets.chomp
  case instruction
  when /filelist/
    comma_separated_list = instruction.split(":").last
    file_array = comma_separated_list.split(",")
    file_array.each do |file|
      puts "Processing file #{file}"
      # do something to process the file here
      puts "Done processing file #{file}"
    end
  when "quit"
    puts "Child process is exiting"
    running = false
  else
    STDERR.puts "Got unrecognized instruction: #{instruction}"
  end
end
