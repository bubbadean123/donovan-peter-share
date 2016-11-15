require "net/http"

class HTTPError < StandardError
  def initialize(msg)
    super
  end
end

class HTTPClient
  def initialize(server)
      host, port = server.split(":")
      @http = Net::HTTP.new(host, port)
      begin
        @http.request(Net::HTTP::Get.new("/"))
      rescue => e
        puts "Failed to connect to " + server
        @connected=false
      else
        puts "Successfully connected to " + server
        @connected=true
      end      
      @res=nil
      @url=nil
  end
  def get(url)
    if @connected
      response = @http.request(Net::HTTP::Get.new(url))
      @res=response
      @url=url
      return @res.body
    end
  end
  def delete(url)
    if @connected
      response = @http.request(Net::HTTP::Delete.new(url))
      @res=response
      @url=url
   end
  end
  def post(url,body)
    if @connected
      request = Net::HTTP::Post.new(url)
      request.body=body
      response = @http.request(request)
      @res=response
      @url=url
    end
  end
  def put(url,body)
    if @connected
      request = Net::HTTP::Put.new(url)
      request.body=body
      response = @http.request(request)
      @res=response
      @url=url
    end
  end
  def debug_response(body=true)
    begin
      puts @res.code+" "+@res.message+":"+@url
      if body
        puts @res.body
      end
    rescue
      puts "No response"
    end
  end
  def res()
    return @res
  end
  def inspect()
    return @http.inspect();
  end
end