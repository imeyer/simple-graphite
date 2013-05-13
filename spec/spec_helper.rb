require 'socket'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.color_enabled = true
  config.tty = true
  config.formatter = :documentation # :progress, :html, :textmate
end

TCP_NEW = TCPSocket.method(:new) unless defined? TCP_NEW
UDP_NEW = UDPSocket.method(:new) unless defined? UDP_NEW

class FakeSockets
  attr :buffer, true

  def initialize
    @buffer = ""
  end

  def readline
  end

  def flush
  end

  def write(some_text)
    @buffer += some_text
  end

  def readchar
  end

  def read(num)
  end

  def close
  end

  def puts(some_text)
    @buffer += some_text
  end

end

class FakeTCPSocket < FakeSockets
end

class FakeUDPSocket < FakeSockets
  def connect(host, port)
  end
end

def mock_tcp
  ftcp = FakeTCPSocket.new
  TCPSocket.stub!(:new).and_return { ftcp }
  ftcp
end

def unmock_tcp
  TCPSocket.stub!(:new).and_return {TCP_NEW.call}
end

def mock_udp
  fudp = FakeUDPSocket.new
  UDPSocket.stub!(:new).and_return { fudp }
  fudp
end

def unmock_udp
  UDPSocket.stub!(:new).and_return {UDP_NEW.call}
end
