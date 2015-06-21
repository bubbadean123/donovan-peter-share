require "open3"

puts "Started parent process"
current_directory = File.expand_path(File.dirname(__FILE__))

puts "Starting child process"
child_process_location = File.join(current_directory, "./child_process.rb")

# You can read more about Open3 here: http://ruby-doc.org/stdlib-2.2.2/libdoc/open3/rdoc/Open3.html#method-c-popen3
# It basically runs the command provided and opens up pipes to the child's
# standard input output and error as well as a thread that monitors the child process.
Open3.popen3("ruby",child_process_location) do |input, output, error, thread|
  pid = thread.pid
  puts "Started child process #{pid}"

  # This will read data off of the child process's standard output stream
  # continuously and will output it to stdout as soon as it's received
  # from the child
  output_reader = Thread.new do
    while data = output.gets
      puts "Output from child process: #{data}"
    end
  end

  # This will read data off of the child process's standard error stream
  # continuously and will output it to stderr as soon as it's received
  # from the child
  error_reader = Thread.new do
    while data = error.gets
      STDERR.puts "Error output from child process: #{data}"
    end
  end

  files_to_process = "filelist:foo.txt,bar.txt,baz.txt"
  # Here we tell the child to process some files
  input.puts(files_to_process)

  # We feed it something it doesn't understand here
  input.puts("something")

  # Then we tell it to quite
  input.puts("quit")

  puts "Exit status of child_process: #{thread.value}"
end

puts "Finished running parent process"
