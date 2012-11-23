require 'dashing'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'
  set :github_username, ''
  set :github_password, ''
  set :jenkins_username, ''
  set :jenkins_password, ''
  
  set :github_repository_url, ''  #Just enter "user/repository" here, e.g. "martin-naumann/project-cockpit" 
  set :jenkins_job_name, ''

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application