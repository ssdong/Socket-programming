require 'socket'

# A Client class
class Client
  # Attributes reader for instance variables
  attr_reader :tcp_client, :server_addr, :neg_port , :req_code, :message
  attr_accessor :udp_port, :udp_client

  # Called when an instance of Client is created
  def initialize(server_addr, negotiation_port, req_code, msg)
    # The TCP client we have
    @tcp_client = TCPSocket.new(server_addr, negotiation_port)
    # The UDP client we have
    @udp_client = 0
    # The server address
    @server_addr = server_addr
    # The negotiation port number
    @neg_port = negotiation_port
    # The request code
    @req_code = req_code
    # The message 
    @message = msg
    # The random port number. Default to be 0
    @udp_port = 0
  end

  # Method to connect through TCP to the server
  def tcp_connect
    # Send request_code to server
    # !important write here is not working
    tcp_client.puts(req_code)
    # Get the UDP random_port
    while response_port = tcp_client.gets
      self.udp_port = response_port.to_i
    end
    # Close our TCP connection
    tcp_client.close
    # Now do UDP
    udp_connect
  end

  # UDP connect
  def udp_connect
    # Create our new UDP socket
    self.udp_client = UDPSocket.new
    # Send our message to the random port server sent to us
    udp_client.send(message,0,server_addr,udp_port)
    # Receive the reversed message, 1024 represents the maximum bytes
    reversed_data, addr = udp_client.recvfrom(1024)
    # Print out reversed message
    puts "Client received reversed message: #{reversed_data}"
    # Close our UDP socket
    udp_client.close
  end
end

# Check if the inputs are missing or invalid
if ARGV.length < 4
   raise "Please enter enough inputs followed by the order '<server_address> <n_port> <request_code> <msg>'"
elsif ARGV[1].to_i.to_s != ARGV[1]
   raise "Negotiation port needs to be an integer"
end

# Read command line arguments (server_address, neg_port, req_code, message)
server_addr = ARGV[0]
neg_port = ARGV[1]
req_code = ARGV[2]
message = ARGV[3]


# We have a new client
client = Client.new(server_addr, neg_port, req_code, message)

# Connect to server
client.tcp_connect
