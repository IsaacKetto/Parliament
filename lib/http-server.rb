require 'socket'
require 'yard'
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }
class HTTPServer

    attr_reader :routes

    def initialize(port)
        @port = port
        @routes = Routes.new
    end

    # Create routes and starts a server session
    
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
            

            Response.new(@routes, session, data)
        end
    end
end

