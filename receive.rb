require_relative 'constants'

fout = File.open('output.bin', 'wb+');

someinput = STDIN.read(WINDOWSIZE)
while !someinput.nil?
  fout.write(someinput)

  numbytes = STDOUT.write('readeded')
  STDOUT.flush

  someinput = STDIN.read(WINDOWSIZE)

end

fout.close
