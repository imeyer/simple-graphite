require 'spec_helper'
require 'simple-graphite'


describe Graphite do

  it "has a default port" do
    a = Graphite.new
    a.port.should == 2003
  end

  it "needs to have the hostname and the port" do
    a = Graphite.new
    lambda {a.push_to_graphite}.should raise_error(RuntimeError, "You need to provide both the hostname and the port")
  end

  it "returns time" do
    a = Graphite.new
    a.time_now.should == Time.now.to_i
  end

  it "has pushes row messages to graphite without restriction" do
    ftcp = mock_tcp()
    a = Graphite.new(:host => 'localhost')
    a.push_to_graphite do |graphite|
      graphite.puts "hello world"
    end

    ftcp.buffer.should == "hello world"
  end

  it "sends metrics from an hash" do
    ftcp = mock_tcp()
    a = Graphite.new(:host => 'localhost')

    time = a.send_metrics({
      'foo.bar' => 200,
      'foo.test' => 10.2
    })
    ftcp.buffer.should == "foo.bar 200 #{time}\nfoo.test 10.2 #{time}\n"
  end

end
