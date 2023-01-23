require 'pp'

request_string = <<~END
    GET /user/1 HTTP/1.1
    Host: www.tutorials.com
    Accept_language: en-us
    Accept-Encoding: gzip, deflate
    Connection: Keep-Alive
END

class RequestHandler

    def initialize(request)
        @request = request
    end

    def parse_request
        lines = @request.split("\n")
        request_line = lines.first
        headers = lines
            .drop(1)
            .map {|header| header.split(":")}
            .to_h
        verb, resource, version = request_line.split(" ")
        {"verb" => verb, "resource" => resource, "version" => version}
    end

end

request = RequestHandler.new(request_string)
pp request.parse_request