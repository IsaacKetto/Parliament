class Response
    def initialize(session, data)
        @session = session
        @data = data
        run
    end

    def run

        request = Request.new(@data)

        resource_type = MIME::Types.type_for('html' + request.resource).first
        resource_media_type = resource_type.media_type
        resource_sub_type = resource_type.sub_type

        if File.exist?('html' + request.resource)
            status = 200
            case resource_media_type
            when "text", "application"
                resource_file = File.read('html' + request.resource)
                file_size = resource_file.size
            when "image"
                resource_file = File.binread('html' + request.resource)
                file_size = resource_file.bytesize
            end
        else
            status = 404
            resource_file = "ERROR 404 NOT FOUND"
        end

        @session.print "HTTP/1.1 #{status}\r\n"
        @session.print "Content-Type: #{resource_media_type}/#{resource_sub_type}\r\n"
        @session.print "Content-length: #{file_size}\r\n"
        @session.print "\r\n"
        @session.print resource_file
        @session.close
    end
end
