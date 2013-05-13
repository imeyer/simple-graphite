require 'socket'

class Graphite
  class Socket
    attr_accessor :host, :port, :type, :socket

    def initialize(host, port, socket_type)
      @host = host
      @port = port
      @type = socket_type
      @socket = nil
    end

    def puts(event)
      begin
        connect unless @socket
        @socket.write("#{event}")
      ensure
        close
      end
    end

    def close
      @socket && @socket.close
    rescue => e
      warn "#{self.class} - #{e.class} - #{e.message}"
    end

    def connect
      @socket = case @type
      when :udp then UDPSocket.new.tap {|s| s.connect(@host, @port)}
      when :tcp then TCPSocket.new(@host, @port)
      else
        raise NameError, "#{@type} is invalid; must be udp or tcp"
      end
    end
  end
end
