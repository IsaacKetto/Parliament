require 'socket'
require 'mime/types'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

class HTTPServer

    def initialize(port)
        @port = port
    end

    def start
        server = TCPServer.new(@port)
        puts "Listening on #{@port}"

        while session = server.accept
            data = ""
            while line = session.gets and line !~ /^\s*$/
                data += line
            end
            puts "RECEIVED REQUEST"
            puts "-" * 40
            puts data
            puts "-" * 40 
            
            Response.new(session, data)
        end
    end
end

server = HTTPServer.new(4567)
server.start