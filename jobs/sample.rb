require 'rest_client'
require 'json'
require 'pp'

def getScorePercentForJob
  num_successes = 0
  job_details = JSON.parse(RestClient.get("http://" + settings.jenkins_username + ":" + settings.jenkins_password + "@code.cloudnode.ch:8080/job/" + settings.jenkins_job_name + "/api/json"))
  job_details["builds"].each do |build|
    build_details = JSON.parse(RestClient.get("http://" + settings.jenkins_username + ":" + settings.jenkins_password + "@code.cloudnode.ch:8080/job/" + settings.jenkins_job_name + "/" + build["number"].to_s + "/api/json"))
    if build_details["result"] != "FAILURE"
      num_successes = num_successes + 1
    end
  end
  score = 100.0 * (num_successes.to_f / job_details["builds"].count.to_f)
  return score.round(2)
end

def refresh_success_rate
  send_event('synergy',   { value: getScorePercentForJob })
end

def refresh_pullrequest
  resource = RestClient::Resource.new "https://api.github.com/repos/" + settings.github_repository_url + "/pulls", settings.github_username, settings.github_password
  pull_request = JSON.parse(resource.get)
  if !pull_request.nil? and !pull_request[0].nil?
  	send_event('pullrequest', { text: 
  		"<div style=\"float:left;\"><img width=\"160px\" src=\"" + pull_request[0]["user"]["avatar_url"] + "\"/>" + 
  		"<p>" + pull_request[0]["user"]["login"] + "</p></div><div style=\"text-align:justify\">" +pull_request[0]["title"] + "</div>"
  	})
  else
  send_event('pullrequest', { text: "<img height=\"160px\" src=\"http://onlyhdwallpapers.com/thumbnail/meme_awesome_face_awsome_desktop_1280x1280_wallpaper-365017.jpg\" /><br />No open pull requests" });
  end
end

def refresh_build_state
  job_details = JSON.parse(RestClient.get("http://" + settings.jenkins_username + ":" + settings.jenkins_password + "@code.cloudnode.ch:8080/job/" + settings.jenkins_job_name + "/api/json"))
  build_details = JSON.parse(RestClient.get("http://" + settings.jenkins_username + ":" + settings.jenkins_password + "@code.cloudnode.ch:8080/job/" + settings.jenkins_job_name + "/" + job_details["builds"][0]["number"].to_s + "/api/json"))
  
  if build_details["result"] != "FAILURE"
    send_event('build_state', {text: "healthy" })
0111  else
    send_event('build_state', {text: "broken" })
  end
end

SCHEDULER.every '3s' do
	refresh_success_rate
	refresh_pullrequest
	refresh_build_state
end