require 'helper'

require 'tempfile'
$host,$port = '127.0.0.1', 12345
class Object
  def with_em_client(port=$port,after_fork = Proc.new{})
    r,w = IO.pipe
    client_pid = fork {
      $stderr.puts "test client starting on #{port}"
      trap('SIGINT') { puts "shutting down test client"; Kernel.exit!(0) }
      EM::run {
        statsd = EM::Statsd.new($host, port)
        after_fork.call(statsd)
        r.close
        EM.next_tick{ w.write("done"); w.close}
      }
    }
    w.close
    r.read
    r.close
    yield if client_pid
    $stderr.puts "in client" unless client_pid
  ensure
    if client_pid
      Process.kill('INT', client_pid)
      Process.wait
      $stderr.puts ["client process",$?.to_i , "finished with ", $?.exitstatus.inspect].join(' ')
    end
  end
end
describe EM::Statsd do
  describe "with a real UDP socket" do
    before {
    }
    require 'stringio'
    before { EM::Statsd.logger = Logger.new(@log = Tempfile.new("statsd")); @log.sync=true; @log.unlink}
    after { @log.close; GC.start}
    it "should write to the log in debug" do
      EM::Statsd.logger.level = Logger::DEBUG
      socket = UDPSocket.new
      port = $port -1
      socket.bind($host, port)

      with_em_client(port,lambda{|statsd| statsd.increment('foobar')}) do   
        socket.recvfrom(16)
        @log.rewind
        @log.read.must_match "Statsd: foobar:1|c"
      end
      socket = nil
    end

    it "should not write to the log unless debug" do
      EM::Statsd.logger.level = Logger::INFO
      socket = UDPSocket.new
      port = $port
      socket.bind($host, port)

      with_em_client(port,lambda{|statsd| statsd.increment('foobar')}) do   
        socket.recvfrom(16)
        @log.rewind
        @log.read.must_be_empty
      end
      socket = nil
    end
    
    it "should actually send stuff over the socket" do     
      socket = UDPSocket.new
      port = $port + 1
      socket.bind($host, port)

      with_em_client(port,lambda{|statsd| statsd.increment('foobar')}) do   
        message = socket.recvfrom(16).first
        message.must_equal 'foobar:1|c'
      end
      socket =nil
    end
  end
end if ENV['LIVE']
