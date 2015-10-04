input_file_name = ARGV[0]
fin = File.open(input_file_name, 'r');

someinput = fin.read(8)
while !someinput.nil?
  # print to stdout
  $stdout.write someinput;


  someinput = fin.read(8)
end

fin.close
