require 'socket'

class Graphite
  attr_accessor :host, :port, :time
  def initialize(options = {})
    @host = options[:host]
    @port = options[:port]
    @time = Time.now.to_i
  end

  def push_to_graphite
    socket = TCPSocket.new(@host, @port)
    yield socket
    socket.close
  end

  def hostname
    Socket.gethostname
  end

  def self.time_now
    @time = Time.now.to_i
  end

  def time_now
    self.time_now
  end
end
