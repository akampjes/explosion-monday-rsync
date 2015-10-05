require 'digest'
require_relative 'constants'

def find_digest_request(block_start, block_length, digest)
  data = Marshal.dump([block_start, block_length, digest])
  generate_request(SendType::FINDDIGEST, data)
end

def generate_request(request_type, data)
  case request_type
  when SendType::FINDDIGEST
    [request_type, data.bytesize].pack('CC') + data
  end
end

def get_response
  msg_type = STDIN.readbyte

  case msg_type
  when ReceiveType::DIGESTFOUND
    read_length = STDIN.readbyte
    data_bytes = STDIN.read(read_length)
    data = Marshal.load(data_bytes)
    {type: msg_type, data: data}
  end
end


input_file_name = ARGV[0]
fin = File.open(input_file_name, 'rb');

seek_to = 0
fin.seek(seek_to)

while true
  block = fin.read(WINDOWSIZE)
  digest = Digest::MD5.digest(block)

  request = find_digest_request(seek_to, WINDOWSIZE, digest)
  STDERR.write("searching seek to:#{seek_to}\n")
  STDOUT.write(request)
  STDOUT.flush

  response = get_response
  STDERR.write("response: #{response.to_s}\n")

  break

  #someinput += "\0" * (WINDOWSIZE - someinput.length)
  #STDOUT.write(someinput)
  #STDERR.write(someinput)
  #STDOUT.flush
  #response = STDIN.read(WINDOWSIZE)
  #someinput = fin.read(WINDOWSIZE)
end

#fin.close

