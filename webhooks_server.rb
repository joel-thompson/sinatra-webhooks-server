require 'sinatra'
require 'json'

#You may not need to bind the server to 0.0.0.0
#It automatically binds to 127.0.0.0 
# set :bind, '0.0.0.0'

post '/webhook' do
  push = JSON.parse(request.body.read)
  puts "Webhook JSON Data: #{push.inspect}"
end