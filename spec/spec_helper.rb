if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

require 'socket'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.color_enabled = true
  config.tty = true
  config.formatter = :documentation # :progress, :html, :textmate
end

class FakeTCPSocket
  def initialize
    @sock = TCPServer.new(12003)
  end

  def buffer
    buf = @sock.accept
    buf.read_nonblock(65535)
  end

  def close
    @sock.close
  end
end

class FakeUDPSocket
  def initialize
    @sock = UDPSocket.new
    @sock.bind(nil, 18125)
  end

  def buffer
    buf = Array.new
    begin
      while pkt = @sock.recvfrom_nonblock(65535)
        buf << pkt
      end
    rescue IO::WaitReadable
    end
    buf.map{|p| p.first}.join()
  end

  def close
    @sock.close
  end
end
