someinput = $stdin.read(8)

fout = File.open('output.bin', 'wb+');
while !someinput.nil?
  fout.write(someinput)

  someinput = $stdin.read(8)
end

fout.close
