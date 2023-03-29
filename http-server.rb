require 'socket'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

class HTTPServer

    def initialize(port)
        @port = port
        @routes = Routes.new
    end

    def start

        @routes.add_get_route('/test') do
            html = <<-HTML
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta http-equiv="X-UA-Compatible" content="IE=edge">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <link rel="stylesheet" href="/css/style.css">
                    <title>Document</title>
                </head>
                <body>
                    <h1>Test!</h1>
                    <img src="/img/grill.jpg" alt="GRill bild">
                    <script src="/js/main.js"></script>
                </body>
                </html>
            HTML
        end

        # @routes.add_get_route('/boll')
        #add_get_route('/grill/:number/:name')
    

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

server = HTTPServer.new(4567)
server.start