require 'httparty'
require 'dotenv/load'
require 'json'

#access key from .env
api_key = ENV['GEMINI_API_KEY']&.strip

# will print the first 4 letters of key to verify it's loading
puts "Debug: API Key starts with #{api_key[0..3]}" if api_key

url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=#{api_key}"

#scouting prompt to be used later
prompt_text = <<~PROMPT
You are an NBA Scout. 
Give me a 1 sentence scouting report for a basketball player who averages 
- 25 points
- 8 rebounds
- 40% from 3-point range
PROMPT
scouting_prompt = {
    contents:[{
        parts: [{
            text: prompt_text
        }]
    }]
}


#send the request
puts "Connecting to Gemini..."
response = HTTParty.post(
    url, 
    headers:{'Content-Type' => 'application/json'},
    body:scouting_prompt.to_json)


#handles the ai response
if response.success?
    data = JSON.parse(response.body)
    puts "\n--- AI SCOUTING REPORT---"
    puts data["candidates"][0]["content"]["parts"][0]["text"]
else
    puts "Error: #{response.code} - #{response.message}"
end