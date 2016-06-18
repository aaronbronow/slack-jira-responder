require "http/server"

server = HTTP::Server.new("0.0.0.0", 8080) do |context|
  context.response.content_type = "text/plain"
  #puts context.request.body.inspect
  body = context.request.body.nil? ? "" : context.request.body.to_s
  text = body.split(/&/)[9]
  next if text.includes? "https%3A%2F%2Fgoodworldsolutions.atlassian.net%2Fbrowse%2F"
  key = get_key text
  puts key
  next if key == ""
  context.response.print "{\"text\":\"Is this the link you're looking for? <https://goodworldsolutions.atlassian.net/browse/" + key + "|" + key + ">\"}"
  #puts "https://goodworldsolutions.atlassian.net/browse/" + context.request.query_params["term"]
end

puts "Listening on http://0.0.0.0:8080"
server.listen

def get_key(input)
  #output = {"id": 123, "hello": "world", "text": input, "key": ""}
  key_regex = /(MLL-)\d+|(LIQ-)\d+|(LP-)\d+/m
  # var matches = input.text.match(keyRegex);
  # if(matches != null && matches.length > 0)
  #   output[0]["key"] = matches[0];
  matches = key_regex.match(input)
  key = matches.nil? ? "" : matches[0]
end
