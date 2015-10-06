WINDOWSIZE=1024

module SendType
  FINDDIGEST = 0
  HELLO = 1
  FINISHED = 2
  WRITEBLOCK = 3
  WRITEDATA = 4
end

module ReceiveType
  DIGESTFOUND = 0
  DIGESTNOTFOUND = 1
  FILENOTFOUND = 2
end

class SendRequest
  def self.generate_request(data)
    #case request_type
    #when SendType::FINDDIGEST
    #  [request_type, data.bytesize].pack('CC') + data
    #when SendType::HELLO
    #  [request_type, data.bytesize].pack('CC') + data
    #end
    #
    data = Marshal.dump(data)
    [data.bytesize].pack('L') + data
  end

  def self.find_digest_request(block_start, block_length, digest)
    data = {type: SendType::FINDDIGEST,
            start: block_start,
            length: block_length,
            digest: digest}

    generate_request(data)
  end

  def self.hello(filename)
    data = {type: SendType::HELLO}

    generate_request(data)
  end

  def self.finished
    data = {type: SendType::FINISHED}

    generate_request(data)
  end
end

class ReceiveRequest
  def self.get_request
    #msg_type = STDIN.readbyte
    #case msg_type
    #when SendType::FINDDIGEST
    #  read_length = STDIN.readbyte
    #  data_bytes = STDIN.read(read_length)
    #  data = Marshal.load(data_bytes)
    #  #STDERR.write("received request:#{data.to_s}\n")
    #  {type: msg_type, data: data}
    #end
    #
    # Read a four byte length
    length = STDIN.read(4).unpack('L').first
    Marshal.load(STDIN.read(length))
  end
end

class SendResponse
  def self.generate_response(data)
    #case request_type
    #when ReceiveType::DIGESTFOUND
    #  [request_type, data.bytesize].pack('CC') + data
    #when ReceiveType::DIGESTNOTFOUND
    #  [request_type].pack('C')
    #when ReceiveType::FILENOTFOUND
    #  [request_type].pack('C')
    #end
    
    data = Marshal.dump(data)
    [data.bytesize].pack('L') + data
  end

  def self.found_block_response(seek_to)
    data = {type: ReceiveType::DIGESTFOUND, location: seek_to}

    generate_response(data)
  end

  def self.not_found_block_response
    data = {type: ReceiveType::DIGESTNOTFOUND}

    generate_response(data)
  end

  def self.file_not_found
    data = {type: ReceiveType::FILENOTFOUND}

    generate_response(data)
  end
end

class ReceiveResponse
  def self.get_response
    #msg_type = STDIN.readbyte
    #case msg_type
    #when ReceiveType::DIGESTFOUND
    #  read_length = STDIN.readbyte
    #  data_bytes = STDIN.read(read_length)
    #  data = Marshal.load(data_bytes)
    #  {type: msg_type, data: data}
    #when ReceiveType::DIGESTNOTFOUND
    #  {type: msg_type, data: nil}
    #when ReceiveType::FILENOTFOUND
    #  {type: msg_type, data: nil}
    #end

    length = STDIN.read(4).unpack('L').first
    Marshal.load(STDIN.read(length))
  end
end
