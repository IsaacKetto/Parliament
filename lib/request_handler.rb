class RequestHandler

  def parse_request(request)
    lines = request.split("\n")
    request_line = lines.first
    headers = lines
      .drop(1)
      .map {|header| header.split(": ")}
      .to_h
    verb, resource, version = request_line.split(" ")
    {"verb" => verb, "resource" => resource, "version" => version, "headers" => headers}
  end

end
