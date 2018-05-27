require 'rubygems'
require 'eventmachine'
require 'em-http'
require 'pp'

$stdout.sync = true

class KeyboardHandler < EM::Connection
  include EM::Protocols::LineText2

  def post_init
    print "> "
  end

  def receive_line(line)
    line.chomp!
    line.gsub!(/^\s+/, '')

    case(line)
    when /^get (.*)$/ then
      site = $1.chomp
      sites = site.split(',')

      multi = EM::MultiRequest.new
      sites.each_with_index do |s, index|
        multi.add(:request.to_s + index.to_s, EM::HttpRequest.new(s).get)
      end
      multi.callback {
        puts ""
        multi.responses[:callback].each do |h|
          pp h.inspect
          pp h.inspect
        end
        multi.responses[:errback].each do |h|
          puts "#{h.inspect} failed"
        end
        print "> "
      }
      print "> "

    when /^exit$/ then
      EM.stop

    when /^help$/ then
      puts "get URL[,URL]*   - gets a URL"
      puts "exit      - exits the app"
      puts "help      - this help"
      print "> "
    end
  end
end

EM::run {
  EM.open_keyboard(KeyboardHandler)
}
puts "Finished"


