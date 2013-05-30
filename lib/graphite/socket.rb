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
      socket.write("#{event}")
      close if @type == :udp
    end

    def close
      @socket.close if @socket and !@socket.closed?
    rescue => e
      warn "#{self.class} - #{e.class} - #{e.message}"
    end

    def socket
      return @socket if @socket && !@socket.closed?
      @socket = case @type
        when :udp then UDPSocket.new.tap {|s| s.connect(@host, @port)}
        when :tcp then TCPSocket.new(@host, @port)
        else
          raise NameError, "#{@type} is invalid; must be udp or tcp"
        end
    end

    # Retained for compatibility
    def connect
      socket
    end
  end
end
