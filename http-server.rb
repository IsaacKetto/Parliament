require 'socket'
require_relative 'lib/request_handler'
require 'mime/types'

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

            @resource_handler = ResourceHandler.new(session, data) #fixa Klass för resources
            
            resource = @request_handler.parse_request(data)["resource"]
            
            resource_type = MIME::Types.type_for('html' + resource).first
            resource_media_type = resource_type.media_type
            resource_sub_type = resource_type.sub_type

            if File.exist?('html' + resource)
                status = 200
                case resource_media_type
                when "text"
                    resource_file = File.read('html' + resource)
                    file_size = resource_file.size
                when "image"
                    resource_file = File.binread('html' + resource)
                    file_size = resource_file.bytesize
                end
            else
                status = 404
                resource_file = "ERROR 404 NOT FOUND"
            end


            session.print "HTTP/1.1 #{status}\r\n"
            session.print "Content-Type: #{resource_media_type}/#{resource_sub_type}\r\n"
            session.print "Content-length: #{file_size}\r\n"
            session.print "\r\n"
            session.print resource_file
            session.close
        end
    end
end

server = HTTPServer.new(4567)
server.start