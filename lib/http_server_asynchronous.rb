require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'

class Handler  < EventMachine::Connection
  include EventMachine::HttpServer

  def process_http_request
    resp = EventMachine::DelegatedHttpResponse.new( self )

    # Block which fulfills the request
    operation = proc do
    sleep 2 # simulate a long running request

        resp.status = 200
        resp.content = "Hello World!"
    end

    # Callback block to execute once the request is fulfilled
    callback = proc do |res|
        resp.send_response
    end

    # Let the thread pool (20 Ruby threads) handle request
    EM.defer(operation, callback)
  end
end

EventMachine::run {
  EventMachine::start_server("0.0.0.0", 8081, Handler)
  puts "Listening..."
}

