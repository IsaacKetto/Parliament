require 'socket'
require_relative 'lib/request_handler'

class HTTPServer

    def initialize(port)
        @port = port
        @request_handler = RequestHandler.new
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

            resource = @request_handler.parse_request(data)["resource"]

            #Er HTTP-PARSER tar emot "data"
            if File.exist?('html' + resource + ".html")
                status = 200
                html = File.read('html' + resource + ".html")
            else
                status = 404
                html = "ERROR 404 NOT FOUND"
            end

            #Sen kolla om resursen (filen finns)

            session.print "HTTP/1.1 #{status}\r\n"
            session.print "Content-Type: text/html\r\n"
            session.print "\r\n"
            session.print html
            session.close
        end
    end
end

server = HTTPServer.new(4567)
server.start