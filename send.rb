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
    unless non_matching_block_start.nil?
      diff << {type: :data,
               start: non_matching_block_start,
               length: seek_to - 1 - non_matching_block_start}
    end
    diff << {type: :block, start: response[:location], length: WINDOWSIZE}
    seek_to += WINDOWSIZE
  when ReceiveType::DIGESTNOTFOUND
    non_matching_block_start = seek_to if non_matching_block_start.nil?
    seek_to += 1
  end

  #someinput += "\0" * (WINDOWSIZE - someinput.length)
  #STDOUT.write(someinput)
  #STDERR.write(someinput)
  #STDOUT.flush
  #response = STDIN.read(WINDOWSIZE)
  #someinput = fin.read(WINDOWSIZE)
end

#fin.close

