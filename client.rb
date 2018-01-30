require 'rubygems'
require 'websocket-client-simple'
require 'json'

#uri = 'ws:rayrays-action-cable-test.herokuapp.com/cable'
uri = 'ws://localhost:3000/cable'
ws = WebSocket::Client::Simple.connect uri

ws.on :message do |msg|
  data = JSON.parse msg.data
  unless data['type'].eql? 'ping'
    puts data
  end
end

ws.on :open do
  puts 'Connected to server, trying to subscribe'
  data = {
    command: 'subscribe',
    identifier: JSON.generate({ channel: 'ChatRoomChannel' })
  }
  ws.send(JSON.generate(data))
end

ws.on :close do |e|
  p e
  exit 1
end

ws.on :error do |e|
  p e
end

loop do
  data = {
    command: 'message',
    identifier: JSON.generate({ channel: 'ChatRoomChannel' }),
    data: JSON.generate({ action: 'speak', message: gets.chomp })
  }

  ws.send(JSON.generate(data))
end
