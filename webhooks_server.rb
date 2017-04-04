require 'sinatra'
require 'json'

#You may not need to bind the server to 0.0.0.0
#It automatically binds to 127.0.0.0 
# set :bind, '0.0.0.0'

global_payload = ""

# receives unsigned webhooks and populates the unsigned_payload_body global variable
post '/webhook' do
  push = JSON.parse(request.body.read)
  puts "Webhook JSON Data: #{push.inspect}"
  unsigned_payload_body = push.inspect
  global_payload = unsigned_payload_body
end

# simply prints out the global_payload
get '/show_webhook' do
	global_payload
end


# expects a signed webhook, returns 500 if the signatures don't match
post '/webhook_signed' do
	request.body.rewind
 	signed_payload_body = request.body.read
 	verify_signature(signed_payload_body)
 	push = JSON.parse(signed_payload_body)
 	puts "Webhook JSON Data: #{push.inspect}"
 	global_payload = signed_payload_body
end

# needs commenting =)
def verify_signature(payload_body)
  secret = "poo"
  expected = request.env['HTTP_X_HUB_SIGNATURE']
  if expected.nil? || expected.empty? then
    puts "Not signed. Not calculating"
  else
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload_body)
    puts "Expected  : #{expected}"
    puts "Calculated: #{signature}"
    if Rack::Utils.secure_compare(signature, expected) then
      puts "   Match"
    else
      puts "   MISMATCH!!!!!!!"
      return halt 500, "Signatures didn't match!"
    end
  end
end