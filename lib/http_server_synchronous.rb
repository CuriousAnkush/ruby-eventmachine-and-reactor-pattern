require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'

class Handler  < EventMachine::Connection
  include EventMachine::HttpServer

  def process_http_request
    resp = EventMachine::DelegatedHttpResponse.new( self )

    sleep 2 # Simulate a long running request

    resp.status = 200
    resp.content = "Hello World!"
    resp.send_response
  end
end

EventMachine::run {
  EventMachine::start_server("0.0.0.0", 8081, Handler)
  puts "Listening..."
}

