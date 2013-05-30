require 'socket'
require 'graphite/socket'

class Graphite

  attr_accessor :host, :type, :port, :time

  def initialize(options = {})
    @host = options[:host]
    @type = options[:type] ||= :tcp
    @port = options[:port] ||= @type.eql?(:tcp) ? 2003 : 8125
    @time = Time.now.to_i
  end

  def push_to_graphite
    raise "You need to provide a hostname" if @host.nil?
    begin
      socket = Graphite::Socket.new @host, @port, @type
      yield socket
    ensure
      socket.close
    end
  end

  def send_metrics(metrics_hash)
    current_time = time_now
    push_to_graphite do |graphite|
      graphite.puts((metrics_hash.map { |k,v| [k, v, current_time].join(' ') + "\n" }).join(''))
    end
    current_time
  end

  def hostname
    ::Socket.gethostname
  end

  def self.time_now
    @time = Time.now.to_i
  end

  def time_now
    self.class.time_now
  end
end
