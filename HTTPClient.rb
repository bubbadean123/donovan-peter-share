class HTTPClient
  def initialize(host,port=80)
      @http = Net::HTTP.new(host, port)
      @res=nil
      @url=nil
      begin
        get("/")
     rescue
        puts "Connection issue"
     end
  end
  def get(url)
    begin
      response = @http.request(Net::HTTP::Get.new(url))
      @res=response
      @url=url
      return response
    rescue
      puts "Connection issue"
    end
  end
  def delete(url)
    begin
      response = @http.request(Net::HTTP::Delete.new(url))
      @res=response
      @url=url
      return response
    rescue
      @res=nil
      @url=nil
      puts "Connection issue"
    ensure
      return nil
   end
  end
  def post(url,body)
    begin
      response = @http.request(Net::HTTP::Delete.new(url))
      @res=response
      @url=url
      return response
    rescue
      @res=nil
      @url=nil
      puts "Connection issue"
    ensure
      return nil
    end
  end
  def put(url,body)
    begin
      request = Net::HTTP::Put.new(url)
      request.body=body
      response = @http.request(request)
      @res=response
      @url=url
    return response
    rescue
      @res=nil
      @url=nil
      puts "Connection issue"
    ensure
      return nil
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
end