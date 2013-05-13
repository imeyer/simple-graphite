if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

require 'socket'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end

TCP_NEW = TCPSocket.method(:new) unless defined? TCP_NEW

class FakeTCPSocket
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

def mock_tcp()
  ftcp = FakeTCPSocket.new
  TCPSocket.stub!(:new).and_return { ftcp }
  ftcp
end

def unmock_tcp
  TCKSocket.stub!(:new).and_return {TCP_NEW.call}
end
