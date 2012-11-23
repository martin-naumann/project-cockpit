# require 'rest_client'
# require 'json'
# require 'pp'
# 
# jobsToWatch = ["Project-M"];
# 
# def getScorePercentForJob(job)
#   num_successes = 0
#   job_details = JSON.parse(RestClient.get("http://martin.naumann:Eswar1malderMensch.@code.cloudnode.ch:8080/job/" + job + "/api/json"))
#   job_details["builds"].each do |build|
#     build_details = JSON.parse(RestClient.get("http://martin.naumann:Eswar1malderMensch.@code.cloudnode.ch:8080/job/" + job + "/" + build["number"].to_s + "/api/json"))
#     if build_details["result"] != "FAILURE"
#       num_successes = num_successes + 1
#     end
#   end
#   score = 100.0 * (num_successes.to_f / job_details["builds"].count.to_f)
#   return score.round(2)
# end
# 
# # Populate the graph with some random points
# points = []
# last_x = 0
# 
# SCHEDULER.every '2s' do
#   points.shift
#   last_x += 1
#   points << { x: last_x, y: getScorePercentForJob(jobsToWatch[0]) }
# 
#   send_event('convergence', points: points)
# end