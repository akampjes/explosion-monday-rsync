WINDOWSIZE=8

module SendType
  FINDDIGEST = 0
  HELLO = 1
end

module ReceiveType
  DIGESTFOUND = 0
  DIGESTNOTFOUND = 1
  FILENOTFOUND = 2
end

class SendRequest
  def self.generate_request(request_type, data)
    case request_type
    when SendType::FINDDIGEST
      [request_type, data.bytesize].pack('CC') + data
    end
  end

  def self.find_digest_request(block_start, block_length, digest)
    data = Marshal.dump([block_start, block_length, digest])
    generate_request(SendType::FINDDIGEST, data)
  end
end

class ReceiveRequest
  def self.get_request
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
end

class SendResponse
  def self.generate_response(request_type, data)
    case request_type
    when ReceiveType::DIGESTFOUND
      [request_type, data.bytesize].pack('CC') + data
    when ReceiveType::DIGESTNOTFOUND
      [request_type].pack('C')
    when ReceiveType::FILENOTFOUND
      [request_type].pack('C')
    end
  end

  def self.found_block_response(seek_to)
    data = Marshal.dump(seek_to)
    generate_response(ReceiveType::DIGESTFOUND, data)
  end

  def self.not_found_block_response
    generate_response(ReceiveType::DIGESTNOTFOUND, nil)
  end

  def self.file_not_found
    generate_response(ReceiveType::FILENOTFOUND, nil)
  end
end

class ReceiveResponse
  def self.get_response
    msg_type = STDIN.readbyte

    case msg_type
    when ReceiveType::DIGESTFOUND
      read_length = STDIN.readbyte
      data_bytes = STDIN.read(read_length)
      data = Marshal.load(data_bytes)
      {type: msg_type, data: data}
    when ReceiveType::DIGESTNOTFOUND
      {type: msg_type, data: nil}
    when ReceiveType::FILENOTFOUND
      {type: msg_type, data: nil}
    end
  end
end
