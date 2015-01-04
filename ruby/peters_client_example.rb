#!/usr/bin/env ruby

require 'socket'
require "shellwords"
dest_server_address = "10.0.0.2"
dest_server_port = 65534

begin

  loop do
    connection = TCPSocket.new(dest_server_address, dest_server_port)
    puts "Select data to send:"
    puts "1. Text"
    puts "2. File"
    puts "Q/q Quit"

    input = gets.chomp
    case input
    when /1/
      puts "Input data to send"
      data = "text\n"
      data << gets.chomp
      data << "\nEOF"
      connection.puts data
      connection.flush
      puts "Data sent"
    when /2/
      puts "Path:"
      path = gets.chomp
      path = File.expand_path(path)
     path = Shellwords.escape(path)
      file = File.open(path, "r")
      lines = file.read.lines
      file.close
      lines.unshift(File.basename(path))
      lines.unshift("file")
      lines.push("EOF")
      lines.each do |line|
      connection.puts line
      connection.flush
      end 
      when /q/i
      puts "Quitting"
      connection.close
      break
    else
      puts "Don't know how to handle input #{input}"
    end
  end
ensure
  connection.close rescue nil
end
