require "open3"
current_directory = File.expand_path(File.dirname(__FILE__))
child_process_location = File.join(current_directory, "./kernel.rb")
arrayofvars = Open3.popen3("ruby",child_process_location)
  $pid = arrayofvars[3].pid
$input = arrayofvars[0]
$output = arrayofvars[1]
$error = arrayofvars[2]
$thread = arrayofvars[3]
  output_reader = Thread.new do
     while data = $output.gets
      puts "Output from child process: #{data}"
    end
  end
  error_reader = Thread.new do
    while data = $error.gets
      STDERR.puts "Error output from child process: #{data}"
    end
  end
puts $input.inspect
def send_input(data)
$input.puts(data)
end
run = true
while run == true
input = gets.chomp
input.prepend('cli:')
send_input(input)
end
$input.close
$output.close
$error.close
$thread.join
arrayofvars = nil
puts $thread.value