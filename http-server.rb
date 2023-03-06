require 'socket'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

class HTTPServer

    def initialize(port)
        @port = port
        @routes = []
    end

    def add_get_route(route)
        if block_given?
            
        @routes.append(route)
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