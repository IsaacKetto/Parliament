require 'mime/types'

class Response
    def initialize(session, request)
        @session = session
        @request = Request.new(request)
        @file_route, @resource_type = resource(@request)
        @resource_file, @status, @file_size = file_check(@request, @file_route, @resource_type)
        session_print(@session)
    end

    private
    def resource(request)
        file_type = (request.resource).split('.')[1]
        if file_type == nil
            file_type = '.html'
            file_route = 'public' + request.resource + file_type
            resource_type = MIME::Types.type_for(file_route).first
        else
            file_route = 'public' + request.resource
            resource_type = MIME::Types.type_for(file_route).first
        end
        p file_type
        p file_route
        p resource_type
        return file_route, resource_type
    end

    def file_check(request, file_route, resource_type)
        if File.exist?(file_route)
            status = 200
            case resource_type.media_type
            when "text", "application"
                resource_file = File.read(file_route)
                file_size = resource_file.size
            when "image"
                resource_file = File.binread(file_route)
                file_size = resource_file.bytesize
            end
        else
            status = 404
            resource_file = "ERROR 404 NOT FOUND"
        end
        return resource_file, status, file_size
    end

    def session_print(session)
        session.print "HTTP/1.1 #{@status}\r\n"
        session.print "Content-Type: #{@resource_type.media_type}/#{@resource_type.sub_type}\r\n"
        session.print "Content-length: #{@file_size}\r\n"
        session.print "\r\n"
        session.print @resource_file
        session.close
    end
end