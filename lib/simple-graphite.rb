require 'socket'


class Graphite

  attr_accessor :host, :port, :time

  def initialize(options = {})
    @host = options[:host]
    @port = options[:port] || 2003
    @time = Time.now.to_i
  end

  def push_to_graphite
    socket = TCPSocket.new(@host, @port)
    yield socket
    socket.close
  end

  def send_metrics(metrics_hash)
    current_time = time_now
    push_to_graphite {(metrics_hash.map { |k,v| [k, v, current_time, '\n'] }).join(' ')}
  end

  def hostname
    Socket.gethostname
  end

  def self.time_now
    @time = Time.now.to_i
  end

  def time_now
    self.class.time_now
  end
end
