require 'digest'
require_relative 'constants'

def get_request
  msg_type = STDIN.readbyte

  case msg_type
  when SendType::FINDDIGEST
    read_length = STDIN.readbyte
    data_bytes = STDIN.read(read_length)
    data = Marshal.load(data_bytes)
    #STDERR.write("received request:#{data.to_s}\n")
    {type: msg_type, data: data}
  end
end

def generate_response(request_type, data)
  case request_type
  when ReceiveType::DIGESTFOUND
    [request_type, data.bytesize].pack('CC') + data
  when ReceiveType::DIGESTNOTFOUND
    [request_type].pack('C')
  when ReceiveType::FILENOTFOUND
    [request_type].pack('C')
  end
end

def found_block_response(seek_to)
  data = Marshal.dump(seek_to)
  generate_response(ReceiveType::DIGESTFOUND, data)
end

def not_found_block_response
  generate_response(ReceiveType::DIGESTNOTFOUND, nil)
end

def file_not_found
  generate_response(ReceiveType::FILENOTFOUND, nil)
end

input_file_name = ARGV[0]
fin = File.open(input_file_name, 'rb')

while true
  request = get_request
  seek_to, windowsize, new_digest = request[:data]
  
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
    response = found_block_response(seek_to)
  else
    response = not_found_block_response
  end

  STDOUT.write(response)
  STDOUT.flush

  #fout.write(someinput)
  #numbytes = STDOUT.write('readeded')
  #STDOUT.flush
  #someinput = STDIN.read(WINDOWSIZE)
end
