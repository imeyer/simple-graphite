require 'socket'
require 'open-uri'

class Graphite
  attr_accessor :host, :port, :protocol, :render_port, :render_uri, :time
  def initialize(options = {})
    @host = options[:host]
    @port = options[:port]
    @protocol = options[:protocol] || 'http'
    @render_port = options[:render_port] || 80
    @render_uri = options[:render_uri] || '/render'
    @time = Time.now.to_i
  end

  def push_to_graphite
    socket = TCPSocket.new(@host, @port)
    yield socket
    socket.close
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

  def get(*vals)
    key = vals[0]
    start_time = vals[1]
    end_time = vals[2]

    if start_time == nil
      raise "Missing start time"
      return nil
    end

    url = "#{protocol}://#{@host}:#{@render_port}#{@render_uri}?"
    url << "target=#{key}"
    url << "&from=#{start_time}"
    if end_time != nil
      url << "&until=#{end_time}"
    end
    url << "&rawData=true"

    begin
      response = Kernel.open(url)
    rescue
      return nil
    end

    graphite_data = { }
    response.each_line do |line|
      line.chomp!
      data_info = line.split("|",2)[0].split(",")

      graphite_data['key'] = data_info[0]
      graphite_data['start'] = data_info[1]
      graphite_data['end'] = data_info[2]
      graphite_data['step'] = data_info[3];
      graphite_data['data'] = line.split("|",2)[1].split(",")
      puts graphite_data
    end

    return graphite_data
  end

end
