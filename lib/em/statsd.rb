#FROM: http://pastebin.com/pKZwrCCZ
#BY: A GUEST ON SEP 4TH, 2012 
require "eventmachine"
require "statsd" # statsd-ruby gem

module EM
  class Statsd < ::Statsd

    class ConnectionWrapper
      def initialize(em_connection)
        @em_connection = em_connection
      end

      def send(message, flags, host, port)
        @em_connection.send_datagram(message, host, port)
      end
    end

    attr_reader :socket
    private :socket

    def initialize(host, port=8125)
      super
            # eventmachine forces us to listen on a UDP socket even
      # though we only
      # want to send, so we'll just give it a junk address
      em_connection = EM.open_datagram_socket("0.0.0.0", 0, EM::Connection)
      @socket = ConnectionWrapper.new(em_connection)
    end

  end
end

require "em-statsd/version"