require 'rubygems'
require 'eventmachine'
require 'em-http'
require 'pp'


EventMachine.run {
  page = EventMachine::HttpRequest.new('http://google.in/').get
  page.errback { p "Google is down! terminate?" }
  page.callback {
    about = EventMachine::HttpRequest.new('http://google.in/search?q=eventmachine').get
    about.callback { p about.response
    EventMachine.stop
    }
    about.errback  { # error-handling code
    }
  }
  puts "Inside Event machine"
}

puts "FInished"
