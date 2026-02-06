require 'httparty'
require 'dotenv/load'
require 'json'

api_key = ENV['GEMINI_API_KEY']&.strip
url = "https://generativelanguage.googleapis.com/v1beta/models?key=#{api_key}"

puts "Asking Google for a list of available models..."
response = HTTParty.get(url)

if response.success?
  data = JSON.parse(response.body)
  puts "\n--- AVAILABLE MODELS ---"
  data["models"].each do |model|
    puts model["name"] if model["name"].include?("gemini")
  end
else
  puts "Error: #{response.code} - #{response.message}"
  puts response.body
end