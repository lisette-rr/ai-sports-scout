require 'httparty'
require 'dotenv/load'
require 'json'
require 'csv'
require 'fileutils' # gem (Ruby library), helps with folder creation

# setup the Connection
api_key = ENV['GEMINI_API_KEY']&.strip
url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=#{api_key}"

# creates the folder for scouting reports if it doesn't exist yet
FileUtils.mkdir_p("scouting_reports")

# nice clean title output for terminal
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

  # creates a payload that will send the prompt text to the connected model
  payload = {
    contents: [{ parts: [{ text: prompt_text }] }]
  }

  # prints Scouting ___ to show that the model is working
  print "Scouting #{row['name']}... "
  
  #This gets the response from the model
  response = HTTParty.post(
    url,
    headers: { 'Content-Type' => 'application/json' },
    body: payload.to_json
  )

  # makes sure that the response was successful
  if response.success?

    # This part was changed to be from terminal to save in a file

    # parses through the response
    ai_report = JSON.parse(response.body)["candidates"][0]["content"]["parts"][0]["text"]

    # creates a file name for the player that won't create errors by using underscores instead of spaces
    file_name = row["name"].downcase.gsub(" ", "_") + "_report.txt"
    file_path = "scouting_reports/#{file_name}"

    #opens the file to put things in it
    File.open(file_path, "w") do |file|
      #put the player name, date of report creation, and the report itself
      file.puts "PLAYER: #{row["name"]}"
      file.puts "DATE: #{Time.now.strftime("%Y-%m-%d")}"
      file.puts "-----------------------------------"
      file.puts ai_report
    end

    #prints a success message in the terminal
    puts "Done. Saved to #{file_path}"

  else
    #error is the response is unable to be scanned
    puts "ERROR scanning #{row['name']}: #{response.code}"
  end

  # Rate Limit Protection 
  # This waits 5 seconds between players for the limits given in the free tier of Gemini
  sleep 5 
end

puts "All players scouted successfully."