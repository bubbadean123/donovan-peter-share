require "net/http"
require "./HTTPClient"
http = HTTPClient.new("localhost", 8080)
http.delete("/items")
http.debug_response(false)
http.post("/items","Hi")
i=http.body.to_i
http.debug_response()
http.get("/items")
http.debug_response()
http.get("/items/#{i}")
http.debug_response()