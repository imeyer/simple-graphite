require 'spec_helper'
require 'socket'
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

  it "requires a hostname" do
    a = Graphite.new
    expect {a.push_to_graphite}.to raise_error(RuntimeError, "You need to provide a hostname")
  end

  it "returns time accurately" do
    a = Graphite.new
    a.time_now.should == Time.now.to_i
  end

  describe "over TCP" do
    before do
      @ftcp = FakeTCPSocket.new
    end

    after do
      @ftcp.close
    end

    it "sends individual metrics to graphite" do
      a = Graphite.new(:host => 'localhost', :type => :tcp, :port => 12003)
      a.push_to_graphite do |graphite|
        graphite.puts "hello world\n"
      end

      @ftcp.buffer.should == "hello world\n"
    end

    it "sends multiple metrics to graphite" do
      a = Graphite.new(:host => 'localhost', :type => :tcp, :port => 12003)
      a.push_to_graphite do |graphite|
        graphite.puts "hello\n"
        graphite.puts "world\n"
      end

      @ftcp.buffer.should == "hello\nworld\n"
    end

    it "sends a hash of metrics to graphite" do
      a = Graphite.new(:host => 'localhost', :type => :tcp, :port => 12003)

      time = a.send_metrics({
        'foo.bar' => 200,
        'foo.test' => 10.2
      })

      @ftcp.buffer.should == "foo.bar 200 #{time}\nfoo.test 10.2 #{time}\n"
    end
  end

  describe "over UDP" do
    before do
      @fudp = FakeUDPSocket.new
    end

    after do
      @fudp.close
    end

    it "sends individual metrics to graphite" do
      a = Graphite.new(:host => 'localhost', :type => :udp, :port => 18125)
      a.push_to_graphite do |graphite|
        graphite.puts "hello world\n"
      end

      @fudp.buffer.should == "hello world\n"
    end

    it "sends multiple metrics to graphite" do
      a = Graphite.new(:host => 'localhost', :type => :udp, :port => 18125)
      a.push_to_graphite do |graphite|
        graphite.puts "hello\n"
        graphite.puts "world\n"
      end

      @fudp.buffer.should == "hello\nworld\n"
    end

    it "sends a hash of metrics to graphite" do
      a = Graphite.new(:host => 'localhost', :type => :udp, :port => 18125)

      time = a.send_metrics({
        'foo.bar' => 200,
        'foo.test' => 10.2
      })

      @fudp.buffer.should == "foo.bar 200 #{time}\nfoo.test 10.2 #{time}\n"
    end
  end

end
