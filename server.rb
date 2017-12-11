require 'sinatra/base'
require 'json'
require 'octokit'

TITLE_REGEX = Regexp.new('\A\[(bugfix|feature|critical|(new )?locale|misc|tests|pkg)\] ')
class CITutorial < Sinatra::Base

  # !!! DO NOT EVER USE HARD-CODED VALUES IN A REAL APP !!!
  # Instead, set and test environment variables, like below
  ACCESS_TOKEN = ENV['KUNAL_PERSONAL_GITHUB_TOKEN']
  before do
    @client ||= Octokit::Client.new(:access_token => ACCESS_TOKEN)
  end

  get '/' do
    "PR Title Check: source at https://github.com/marwahaha/pr-title-check"
  end

  post '/event_handler' do
    @payload = JSON.parse(params[:payload])

    case request.env['HTTP_X_GITHUB_EVENT']
    when "pull_request" # trying to capture all PR events
      process_pull_request(@payload["pull_request"])
    end
  end

  helpers do
    def process_pull_request(pull_request)
      puts "Processing pull request \##{pull_request['number']}: #{pull_request['title']}..."
      @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'pending', options={:context => "Title", :description => "Reading title..."})
      if TITLE_REGEX.match(pull_request['title'])
        puts "PR \##{pull_request['number']}'s title looks good: #{pull_request['title']}"
        @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'success', options={:context => "Title", :description => "Your title looks great!"})
      else
        puts "PR \##{pull_request['number']}'s title doesn't pass: #{pull_request['title']}"
        @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'error', options={:context => "Title", :description => "Start with [bugfix]/[feature]/[critical]/[(new )?locale]/[misc]/[tests]/[pkg]."})
      end
      puts "Pull request \##{pull_request['number']} processed!"
    end
  end
end
