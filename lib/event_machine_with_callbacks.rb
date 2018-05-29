require 'rubygems'
require 'eventmachine'
require 'em-http'
require 'pp'
require 'fiber'

def async_http_get url
  fiber = Fiber.current
  response = EventMachine::HttpRequest.new(url).get
  response.callback {fiber.resume(response)}
  response.errback{fiber.resume(response)}
  return Fiber.yield
end


EventMachine.run {
  Fiber.new do
      response = async_http_get('http://googles.com')
      puts "Response: #{response.inspect}"
      if response
        new_response = async_http_get('http://googles.com/search?q=eventmachine')
        puts "New Response: #{new_response.inspect}"
      else
        p "Error!"
      end
    end.resume
}

puts "FInished"
