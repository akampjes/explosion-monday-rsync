require_relative 'constants'

input_file_name = ARGV[0]
fin = File.open(input_file_name, 'r');

someinput = fin.read(WINDOWSIZE)
while !someinput.nil?
  someinput += "\0" * (WINDOWSIZE - someinput.length)
  STDOUT.write(someinput)
  STDERR.write(someinput)
  STDOUT.flush

  response = STDIN.read(WINDOWSIZE)

  someinput = fin.read(WINDOWSIZE)
end

fin.close
