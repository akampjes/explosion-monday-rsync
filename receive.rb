require 'digest'
require_relative 'constants'

input_file_name = ARGV[0]
fin = File.open(input_file_name, 'rb')

while true
  request = ReceiveRequest.get_request

  case request[:type]
  when SendType::FINDDIGEST
    windowsize = request[:length]
    new_digest = request[:digest]

    # Search through ENTIRE file for block
    seek_to = 0
    fin.seek(seek_to)
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
      # write out the block
    else
      response = SendResponse.not_found_block_response
      # receive and write a single byte now
    end
  when SendType::WRITEDATA
  when SendType::FINISHED
    break
  end

  STDOUT.write(response)
  STDOUT.flush
end
