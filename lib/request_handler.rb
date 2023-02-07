class Request

  attr_accessor :verb, :resource, :version, :headers

  def initialize(request)
    lines = request.split("\n")
    request_line = lines.first
    @headers = lines
      .drop(1)
      .map {|header| header.split(": ")}
      .to_h
    @verb, @resource, @version = request_line.split(" ")
  end

end
