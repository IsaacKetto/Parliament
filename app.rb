require_relative 'lib/http-server'

server = HTTPServer.new(4567)

server.routes.add_get_route('/test/:text/:text2/') do |text, text2|
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
            <h1>#{text}!</h1>
            <h1>#{text2}!</h1>
            <h2>#{1+2}</h2>
            <img src="/img/grill.jpg" alt="GRill bild">
            <script src="/js/main.js"></script>
        </body>
        </html>
    HTML
end

server.routes.add_get_route('/calculator/:term1/:term2') do |num1, num2|
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
            <h1> #{num1.to_i + num2.to_i} </h1>
            <img src="/img/grill.jpg" alt="GRill bild">
            <script src="/js/main.js"></script>
        </body>
        </html>
    HTML
end

server.routes.add_get_route('/test/:banan/') do |banan|
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
            <h1>#{banan}!</h1>
            <img src="/img/grill.jpg" alt="GRill bild">
            <script src="/js/main.js"></script>
        </body>
        </html>
    HTML
end

server.start