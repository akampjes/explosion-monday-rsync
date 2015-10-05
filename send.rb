require 'digest'
require_relative 'constants'
input_file_name = ARGV[0]
fin = File.open(input_file_name, 'rb');

seek_to = 0
fin.seek(seek_to)

while true
  block = fin.read(WINDOWSIZE)
  digest = Digest::MD5.digest(block)

  request = SendRequest.find_digest_request(seek_to, WINDOWSIZE, digest)
  STDERR.write("searching seek to:#{seek_to}\n")
  STDOUT.write(request)
  STDOUT.flush

  response = ReceiveResponse.get_response
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

