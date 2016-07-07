class HTTPClient
  def initialize(host,port=80)
    @http = Net::HTTP.new(host, port)
    @res=nil
    @url=nil
  end
  def get(url)
    response = @http.request(Net::HTTP::Get.new(url))
    @res=response
    @url=url
    return response
  end
  def options(url)
    response = @http.request(Net::HTTP::Options.new(url))
    @res=response
    @url=url
    return response
  end
  def delete(url)
    response = @http.request(Net::HTTP::Delete.new(url))
    @res=response
    @url=url
    return response
  end
  def post(url,body)
    request = Net::HTTP::Post.new(url)
    request.body=body
    response = @http.request(request)
    @res=response
    @url=url
    return response
  end
  def put(url,body)
    request = Net::HTTP::Put.new(url)
    request.body=body
    response = @http.request(request)
    @res=response
    @url=url
    return response
  end
  def debug_response(body=true)
    puts @res.code+" "+@res.message+":"+@url
    if body
      puts @res.body
    end
  end
  def body()
    return @res.body
  end
end