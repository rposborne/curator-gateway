require 'sinatra'
require 'hutch'
require 'oj'

Hutch.connect

post '/gateway/v1/:origin/:hook' do

  #validate expected orgin and hook
  #This will be a pub sub from the curator.
  @registed_hooks = {"big_commerce" => ["new_product", "new_order"]}

  origin = params[:origin]
  hook   = params[:hook]

  if @registed_hooks[origin] and @registed_hooks[origin].include?(hook)
    if body_hash = validate_body(request)
      begin
        Hutch.publish("webhooks.#{origin}.#{hook}", webhook: body_hash , request: request)
        halt 200
      rescue Hutch::PublishError => e
        puts "**** RABBIT DOWN *****"
        halt 500
      end
    else
      halt 422
    end
  else
    halt 404
  end
end

# Protected: Ensure JSON body can be parsed
#
# request  - inbound request object
#
# Examples
#
#   validate_body(request)
#   # => {'hi' => "bye"}
#
# Returns the ruby Hash or false
def validate_body(request)
  request.body.rewind

  begin
    Oj.load request.body.read
  rescue Oj::ParseError => e
    false
  end
  
end
