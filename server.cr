require "http/server"
require "uri"

config = {
  host: "0.0.0.0",
  port: 8080,
  url: "https://goodworldsolutions.atlassian.net/browse/",
  message: "Is this the link you're looking for?",
  plural_message: "Are these the links you're looking for?",
  keys: "MLL,LIQ,LP"
}

server = HTTP::Server.new(config[:host], config[:port]) do |context|
  output = ""
  message = config[:message]
  encoded_url = URI.escape config[:url]
  context.response.content_type = "text/plain"
  next if context.request.body.nil? && context.request.query_params.nil?
  body = context.request.body.to_s
  # body = context.request.query_params.to_s if !context.request.query_params.nil?
  text = body.split(/&/)[9]
  next if text.includes? encoded_url
  keys = get_keys config[:keys].split(','), text
  puts keys
  next if keys == "" || keys.nil?
  message = config[:plural_message] if keys.size > 1
  output = "{\"text\":\"#{message} \
    #{keys.map { |key| "<#{config[:url]}" + key + "|" + key + "> " }.join(' ')}\"}"
  #
  # output = "{\"text\":\"#{config[:message]}<#{config[:url]}" + key + "|" + key + ">\"}"
  context.response.print output
end

puts "Listening on #{config[:host]}:#{config[:port]}"
server.listen

def get_keys(keys, input)
  key_regex = /(#{keys.map { |key| "#{key}-\\d+" }.join '|'})/m
  matches = input.scan(key_regex)
  matches.map { |match| match[0] }
end
