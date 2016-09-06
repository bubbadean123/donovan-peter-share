require "net/http"
class HTTPClient
  def initialize(server)
      host, port = server.split(":")
      @http = Net::HTTP.new(host, port)
      begin
        @http.request(Net::HTTP::Get.new("/"))
      rescue => e
        error=e.message.split(' -')[0]
        puts case error
          when "Connection refused for " + server
            puts "Cannot connect to " + server
          when "the scheme http does not accept registry part: " + server + " (or bad hostname?)"
            puts "Bad server"
          else
           puts error
        end
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
  def body()
    begin
      return @res.body
    rescue
      puts "No response"
    ensure
      return nil
    end
  end
  def res()
    return @res
  end
  def inspect()
    return @http.inspect();
  end
end
youtube=HTTPClient.new("www.youtube.com")
youtube.get("/")
youtube.debug_response()