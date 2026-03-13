# AI Sports Scout & Engagement Engine 

A high-performance Ruby pipeline designed to automate the generation of professional scouting reports and fan engagement content. By leveraging the **Gemini 2.5 Flash API**, the engine transforms raw CSV player data into structured, multi-persona analysis in seconds.

## Core Features
* **Multi-Persona Orchestration:** A single prompt architecture designed to return two distinct content streams: a technical scouting report and a high-energy social media post.
* **Defensive Data Parsing:** Implemented robust JSON scrubbing logic to handle non-standard model responses and ensure system stability.
* **Performance Metrics:** A built-in Return on Investment (ROI) dashboard that tracks execution time and calculates estimated manual labor savings.
* **Automated Archiving:** A file management system that organizes generated content into distinct directory structures for scalability.

## Technical Stack
- **Language:** Ruby 2.6+
- **External Libraries:** HTTParty (API Handshake), Dotenv (Security), Sinatra (Web Layer)
- **Standard Libraries:** JSON, CSV, FileUtils
- **AI Integration:** Google Gemini 2.5 Flash


## Installation and Usage
1. Clone the repository to your local machine.
2. Run `bundle install` to install all required gems.
3. Create a `.env` file based on the provided `.env.example` and insert your Gemini API key.
4. Execute the engine by running the following command:
bundle exec ruby `scout_roster.rb`

## System Performance and ROI

The engine was benchmarked against manual content creation workflows to measure efficiency gains.

* **Batch Size:** 3 Players

* **Total Assets Generated:** 6 (3 Scouting Reports, 3 Social Posts)

* **Processing Time:** ~15 seconds

* **Estimated Manual Effort:** ~30 minutes

* **Efficiency Increase:** Approximately 95%

## Future Roadmap

* **Web Interface:** Migration of the core logic to a Sinatra-based dashboard to improve user accessibility.
* **Automated Testing:** Implementation of an RSpec suite to ensure code reliability and prevent regressions.
* **Database Integration:** Transitioning from flat-file storage to a relational database like PostgreSQL for production-level scalability.