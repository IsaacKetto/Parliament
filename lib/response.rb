require 'mime/types'
require 'yard'

class Response
    # Constructs the Response object
    #
    # @param routes [Array] List with strings
    # @param session [TCPSocket] Server session
    # @param request [String] String with session data
    # @return [void]
    def initialize(routes, session, request)
        @routes = routes
        @session = session
        @request = Request.new(request)
        
        #static
        @file_route, @resource_type = resource()
        @content, @status, @file_size = file_check()
        
        #dynamic
        if @status == 404
            @request = Request.new(request)
            if @routes.check_route(@request.verb.downcase, @request.resource.downcase)
                @status = 200
                @content = @routes.block_value(@request.verb.downcase, @request.resource.downcase)
                
            end
        end
        
        session_print()
    end

    private
    #Checks if resource is html by checking for a "."
    #
    # @return [String, String] Returns 2 seperate strings that determines the path for static file and what resource type it is
    def resource
        if !@request.resource.include?(".")
            @request.resource += ".html"
        end
        file_route = 'public' + @request.resource
        
        resource_type = MIME::Types.type_for(file_route).first
        return file_route, resource_type
    end
    #Checks if there is a file for @file_route
    #
    # @return [String, Integer, Integer] Returns content - file data, status - Status code for server, file_size - A number that tells the size of the file
    def file_check
        if File.exist?(@file_route)
            status = 200
            case @resource_type.media_type
            when "text", "application"
                content = File.read(@file_route)
                file_size = content.size
            when "image"
                content = File.binread(@file_route)
                file_size = content.bytesize
            end
        else
            status = 404
            content = "NOT FOUND"
        end
        p status.class
        p file_size.class
        return content, status, file_size
    end
    # Prints data for the server session
    #
    # @return [void]
    def session_print
        @session.print "HTTP/1.1 #{@status}\r\n"
        @session.print "Content-Type: #{@resource_type.media_type}/#{@resource_type.sub_type}\r\n"
        @session.print "Content-length: #{@file_size}\r\n"
        @session.print "\r\n"
        @session.print @content
        @session.close
    end
end