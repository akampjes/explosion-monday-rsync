require 'digest'
require_relative 'constants'

input_file_name = ARGV[0]
fin = File.open(input_file_name, 'rb')

while true
  request = ReceiveRequest.get_request
  seek_to = request[:start]
  windowsize = request[:length]
  new_digest = request[:digest]

  # search through entire file for block
  block = fin.read(windowsize)
  while block
    old_digest = Digest::MD5.digest(block)

    break if new_digest == old_digest

    seek_to += 1
    fin.seek(seek_to)
    block = fin.read(windowsize)
  end

  if new_digest == old_digest
    STDERR.write("Found it! #{seek_to}\n")
    response = SendResponse.found_block_response(seek_to)
  else
    response = SendResponse.not_found_block_response
  end

  STDOUT.write(response)
  STDOUT.flush

  #fout.write(someinput)
  #numbytes = STDOUT.write('readeded')
  #STDOUT.flush
  #someinput = STDIN.read(WINDOWSIZE)
end
