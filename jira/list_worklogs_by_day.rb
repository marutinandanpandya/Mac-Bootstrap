require 'rubygems'
require 'jira-ruby'
require './issue'

options = {
  :username     => '',
  :password     => '',
  :site         => 'https://copperegg.atlassian.net:443',
  :context_path => '',
  :auth_type    => :basic
}

client = JIRA::Client.new(options)

tickets = '' #ticket list

tickets.split(',').each do |issue_key|
  issue = client.Issue.find(issue_key) ; nil
  puts issue.worklogs.count
  issue.worklogs['worklogs'].each do |worklog|
    puts "#{worklog['started'][0..9]},#{worklog['author']['name']},#{worklog['timeSpentSeconds']},#{issue_key}"
  end if issue.worklogs['worklogs']; nil
end ; nil

