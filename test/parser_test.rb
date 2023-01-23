require_relative '../lib/request_handler.rb'
require 'socket'

describe RequestHandler do

  before do
    @handler = RequestHandler.new
   
    @request = <<~END
    GET /grill HTTP/1.1
    User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
    Host: www.tutorialspoint.com
    Accept-Language: en-us
    Accept-Encoding: gzip, deflate
    Connection: Keep-Alive
    END
  end

  describe "Parsing Simple HTTP GET Request" do
    
    it "extracts the HTTP verb" do
      result = @handler.parse_request(@request)
      _(result["verb"]).must_equal "GET"
    end

    it "extracts the HTTP resource" do
      result = @handler.parse_request(@request)
      _(result["resource"]).must_equal "/grill"
    end

    it "extracts the HTTP version" do
      result = @handler.parse_request(@request)
      _(result["version"]).must_equal "HTTP/1.1"
    end

    it "extracts the User-Agent" do
      result = @handler.parse_request(@request)
      _(result["headers"]["User-Agent"]).must_equal "Mozilla/4.0 (compatible; MSIE5.01; Windows NT)"
    end

    it "extracts the Host" do
      result = @handler.parse_request(@request)
      _(result["headers"]["Host"]).must_equal "www.tutorialspoint.com"
    end

    it "extracts the Accept-Language" do
      result = @handler.parse_request(@request)
      _(result["headers"]["Accept-Language"]).must_equal "en-us"
    end

    it "extracts the Accept-Encoding" do
      result = @handler.parse_request(@request)
      _(result["headers"]["Accept-Encoding"]).must_equal "gzip, deflate"
    end

    it "extracts the Connection" do
      result = @handler.parse_request(@request)
      _(result["headers"]["Connection"]).must_equal "Keep-Alive"
    end
  end

 
end