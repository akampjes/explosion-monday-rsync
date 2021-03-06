require 'digest'
require_relative 'constants'

input_file_name = ARGV[0]

diff = []
non_matching_block_start = nil


fin = File.open(input_file_name, 'rb');

seek_to = 0

while true
  fin.seek(seek_to)
  block = fin.read(WINDOWSIZE)

  break if block.nil?

  digest = Digest::MD5.digest(block)

  request = SendRequest.find_digest_request(seek_to, WINDOWSIZE, digest)
  STDERR.write("searching seek to:#{seek_to}\n")
  STDOUT.write(request)
  STDOUT.flush

  response = ReceiveResponse.get_response
  STDERR.write("response: #{response.to_s}\n")

  case response[:type]
  when ReceiveType::DIGESTFOUND
    # cool, the data should have been written out,
    seek_to += WINDOWSIZE
  when ReceiveType::DIGESTNOTFOUND
    # i could probably send one byte at a time if not found
    # it would be simple to expect to be sent a single byte
    # 
    # that wolud solve my problem of saving up bytes
    # and tracking them
    seek_to += 1
  when ReceiveType::FILENOTFOUND
    # send entire file
    break
  end
end

request = SendRequest.finished
STDOUT.write(request)
STDOUT.flush

fin.close
