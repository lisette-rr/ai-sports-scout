require 'httparty' # External (In Gemfile)
require 'dotenv/load' # External (In Gemfile)
require 'json' # Standard (Built-in)
require 'csv' # Standard (Built-in)
require 'fileutils' # Standard (Built-in) gem (Ruby library), helps with folder creation

# setup the Connection
api_key = ENV['GEMINI_API_KEY']&.strip
url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=#{api_key}"

# creates the folder for scouting reports if it doesn't exist yet
FileUtils.mkdir_p("scouting_reports")
FileUtils.mkdir_p("social_media_reports")

# nice clean title output for terminal
puts "AI Sports Scout Engine: ONLINE"
puts "---------------------------------"

# creates a variable that keeps track of the start time of generation
start_time = Time.now

# creates a variable that keeps track of the number of players that we generated responses for
player_count = 0

# read the Roster one line at a time for memory efficiency when there is lots of data
# headers: true allows us to use row['name'] instead of row[0]
CSV.foreach("data/roster.csv", headers: true) do |row|
  
  # personalized prompt
  prompt_text = <<~PROMPT
    You are an expert NBA scout and a social media expert. 
    Analyze the following player: #{row['name']}
    Stats: #{row['points']} PPG, #{row['rebounds']} RPG, #{row['three_point_pct']} 3PT%

    Return ONLY a raw JSON object. No markdown, no <json> tags, no preamble.
    Format:
    {
      "scouting_report": "Pro Comp: [Name]. [1-sentence outlook].",
      "social_media_caption": "[High energy post with emojis]"
    }
  PROMPT

  # creates a payload that will send the prompt text to the connected model
  payload = {
    contents: [{ parts: [{ text: prompt_text }] }]
  }

  # prints Scouting ___ to show that the model is working
  puts "Scouting and creating Social Media caption for #{row['name']}... "
  
  #This gets the response from the model
  response = HTTParty.post(
    url,
    headers: { 'Content-Type' => 'application/json' },
    body: payload.to_json
  )

  # makes sure that the response was successful
  if response.success?

    # since the response generation was succesful, increment player count by one
    player_count += 1

    # parses through the response, this is STILL A STRING
    raw_ai_report_and_caption_string = JSON.parse(response.body)["candidates"][0]["content"]["parts"][0]["text"]

    # this will take care of any possible additional text that AI may have added
    # this includes chatty text, or unwanted JSON tags
    clean_json = raw_ai_report_and_caption_string.gsub(/<json>|<\/json>|```json|```/, "").strip

    # calls JSON.parse again to get a Ruby Hash
    generated_JSON = JSON.parse(clean_json)

    report_text = generated_JSON["scouting_report"]
    social_text = generated_JSON["social_media_caption"]

    # creates a file name for the player report that won't create errors by using underscores instead of spaces
    report_file_name = row["name"].downcase.gsub(" ", "_") + "_report.txt"
    report_file_path = "scouting_reports/#{report_file_name}"

    #opens the file to put things in it
    File.open(report_file_path, "w") do |file|
      #put the player name, date of report creation, and the report itself
      file.puts "PLAYER: #{row["name"]}"
      file.puts "DATE: #{Time.now.strftime("%Y-%m-%d")}"
      file.puts "-----------------------------------"
      file.puts report_text
    end

    #prints a success message in the terminal
    puts "Done. Saved to #{report_file_path}"

    # creates a file name for the player social media caption that won't create errors by using underscores instead of spaces
    social_file_name = row["name"].downcase.gsub(" ", "_") + "_social.txt"
    social_file_path = "social_media_reports/#{social_file_name}"

    #opens the file to put things in it
    File.open(social_file_path, "w") do |file|
      #put the player name, date of report creation, and the report itself
      file.puts "PLAYER: #{row["name"]}"
      file.puts "DATE: #{Time.now.strftime("%Y-%m-%d")}"
      file.puts "-----------------------------------"
      file.puts social_text
    end

    #prints a success message in the terminal
    puts "Done. Saved to #{social_file_path}"

  else
    #error is the response is unable to be scanned
    puts "ERROR scanning #{row['name']}: #{response.code}"
  end

  # Rate Limit Protection 
  # This waits 5 seconds between players for the limits given in the free tier of Gemini
  sleep 5 
end

puts "All players scouted successfully."
puts " "

# gets the end time after all generations finish
end_time = Time.now

# gets the total amount of time taken for the generation
generation_duration_time = (end_time-start_time).round(2)

# estimated amount of time saved
# 10 minutes was chosen just as an educated estimated guess
minutes_saved = player_count * 10

puts "\n" + "="*45
puts "BATCH COMPLETE: AI ENGAGEMENT ENGINE"
puts "="*45
puts "Players Processed:     #{player_count}"
puts "Total Assets Created:  #{player_count * 2} (.txt files)"
puts "Execution Time:        #{generation_duration_time} seconds"
puts "Manual Labor Saved:    ~#{minutes_saved} minutes"
puts "Status:                SYSTEM OPTIMIZED"
puts "="*45