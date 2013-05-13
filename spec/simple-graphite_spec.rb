require 'spec_helper'
require 'simple-graphite'

describe Graphite do

  it "uses TCP by default" do
    a = Graphite.new
    a.port.should == 2003 && a.type.should == :tcp
  end

  it "has a default TCP port" do
    a = Graphite.new
    a.port.should == 2003
  end

  it "has a default UDP port" do
    a = Graphite.new :type => :udp
    a.port.should == 8125
  end

  it "only accepts UDP or TCP as protocols" do
    a = Graphite.new :host => 'localhost', :type => :fake
    expect {a.push_to_graphite{|g| g.puts "hello world"}}.to raise_error(NameError, "fake is invalid; must be udp or tcp")
  end

  it "sends individual metrics to graphite over TCP" do
    ftcp = mock_tcp
    a = Graphite.new(:host => 'localhost', :type => :tcp)
    a.push_to_graphite do |graphite|
      graphite.puts "hello world"
    end

    ftcp.buffer.should == "hello world"
  end

  it "sends a hash of metrics to graphite over TCP" do
    ftcp = mock_tcp
    a = Graphite.new(:host => 'localhost', :type => :tcp)

    time = a.send_metrics({
      'foo.bar' => 200,
      'foo.test' => 10.2
    })
    ftcp.buffer.should == "foo.bar 200 #{time}\nfoo.test 10.2 #{time}\n"
  end

  it "sends individual metrics to graphite over UDP" do
    fudp = mock_udp
    a = Graphite.new(:host => 'localhost', :type => :udp)
    a.push_to_graphite do |graphite|
      graphite.puts "hello world"
    end

    fudp.buffer.should == "hello world"
  end

  it "sends a hash of metrics to graphite over UDP" do
    fudp = mock_udp
    a = Graphite.new(:host => 'localhost', :type => :udp)

    time = a.send_metrics({
      'foo.bar' => 200,
      'foo.test' => 10.2
    })
    fudp.buffer.should == "foo.bar 200 #{time}\nfoo.test 10.2 #{time}\n"
  end

  it "requires a hostname" do
    a = Graphite.new
    expect {a.push_to_graphite}.to raise_error(RuntimeError, "You need to provide a hostname")
  end

  it "returns time accurately" do
    a = Graphite.new
    a.time_now.should == Time.now.to_i
  end

end
