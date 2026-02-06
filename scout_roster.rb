require 'httparty'
require 'dotenv/load'
require 'json'
require 'csv'

# setup the Connection
api_key = ENV['GEMINI_API_KEY']&.strip
url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=#{api_key}"

puts "AI Sports Scout Engine: ONLINE"
puts "---------------------------------"

# read the Roster one line at a time for memory efficiency when there is lots of data
# headers: true allows us to use row['name'] instead of row[0]
CSV.foreach("data/roster.csv", headers: true) do |row|
  
  # personalized prompt
  prompt_text = <<~PROMPT
    You are an expert NBA scout. Analyze the following player stats and provide:
    1. A "Pro Comparison" (which current/former player they play like).
    2. A 1-sentence draft outlook based on their efficiency.

    Player: #{row['name']}
    Stats: #{row['points']} PPG, #{row['rebounds']} RPG, #{row['three_point_pct']} 3PT%
  PROMPT

  payload = {
    contents: [{ parts: [{ text: prompt_text }] }]
  }

  # Make the Request
  print "Scanning #{row['name']}... "
  
  response = HTTParty.post(
    url,
    headers: { 'Content-Type' => 'application/json' },
    body: payload.to_json
  )

  if response.success?
    ai_report = JSON.parse(response.body)["candidates"][0]["content"]["parts"][0]["text"]
    puts "Report Generated!"
    puts ai_report
    puts "---------------------------------"
  else
    puts "ERROR scanning #{row['name']}: #{response.code}"
  end

  # Rate Limit Protection 
  # This waits 2 seconds between players for the limits given in the free tier of Gemini
  sleep 2 
end

puts "All players scouted successfully."