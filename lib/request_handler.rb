class Request

  attr_accessor :verb, :resource, :version, :headers
  # Splits the request data and turns all the data into local variables
  #
  # @param request [String] String with all request data
  # @return [Void]
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
