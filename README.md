# AI Sports Scout & Engagement Engine 🏀

An automated scouting tool that leverages the **Gemini 2.5 Flash API** to analyze player statistics and generate professional scouting reports.

## 🚀 Current Features
- **API Handshake:** Successfully integrated Google Gemini API using Ruby and HTTParty.
- **Bulk Processing:** Logic to read player data from a `data/roster.csv` file.
- **Automated Scouting:** Generates pro-comparisons and draft outlooks for multiple players in one command.
- **Rate Limit Protection:** Implemented intentional delays to respect API quotas.

## 🛠️ Tech Stack
- **Language:** Ruby
- **API:** Google Gemini (Generative AI)
- **Data:** CSV (Spreadsheet-based roster management)
- **Security:** Dotenv for API key protection

## 🏃 How to Run
1. Ensure your API key is in the `.env` file.
2. Add players to `data/roster.csv`.
3. Run the engine:
   ```bash
   bundle exec ruby scout_roster.rb