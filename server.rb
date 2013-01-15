# University Events Web Application
#
# Ruby RESTful server
# Dissertation Project 2012-13
# 
# Implementing a server in Ruby using the principles of REST
# The server allows applications to manage/book university events
#
# author: Laura McCormack

require 'sinatra'
require 'haml'
#require 'pg'
require 'mysql2'
require 'json'
require './config/MyConfig.rb'

#set the format for all haml docs used
set :haml, :format => :html5

#set up connection to mysql database
dbconn = Mysql2::Client.new(:host => MyConfig::Host, :username => MyConfig::Username, :password => MyConfig::Password, :database => MyConfig::Database)
##### set up so that errors are caught and connection closed 
#conn = PG.connect( dbhost: '127.0.0.1', dbname: "unievents" )

get '/' do
	#:haml index
	redirect to('/events')
end


# handle http GET request on events (show all events)
get '/events' do
	# select all the events from the database in order of date
	@res = dbconn.query("SELECT id,name,details,DATE_FORMAT(date, '%d-%m-%y') AS date, time FROM events ORDER BY date;")

	haml :index
end

# handle http GET request for one event
get '/events/:id' do
	# select the event with selected id
	@res = dbconn.query("SELECT id,name,details,DATE_FORMAT(date, '%d-%m-%y') AS date, time FROM events WHERE id=#{params[:id]};")
	
	haml :eventview
end


##### HTTP requests for staff web app

# handle http POST request on event
post '/event' do
#get the name, details, date and time from body of request
	name = dbconn.escape(params[:name])
	details = dbconn.escape(params[:details])
	date = dbconn.escape(params[:date])
	time = dbconn.escape(params[:time])

	#if the event does not exist already, add it to the event table
	test = dbconn.query("SELECT * FROM events WHERE name = '#{name}' AND date = '#{date}';")
	if(test.count == 0)
		@res = dbconn.query("INSERT INTO events(name, details, date, time) VALUES ('#{name}','#{details}', '#{date}', #{time});")
		eid = 
		dbconn.query("SELECT * FROM events WHERE name = '#{name}' AND details = '#{details}';").each do |row|
			redirect "/events/#{row["id"]}"
		end
	else
		redirect '/event/new'	
	end
end

# get request for form to create new event (server side templates - not needed if client side templates)
get '/event/new' do
	haml :eventform
end

# handle http PUT request on event update event - input is form
put '/event/:id' do
	@res = dbconn.query()
end

# handle http DELETE request on event
delete '/event/:id' do
	query = dbconn.query("DELETE FROM events WHERE id ='#{id}';")
end

# handle http GET request on staff
get '/staff' do
	@res = dbconn.query("SELECT * FROM staff;")

	haml :staff
end

# handle get reqest for one staff member
get '/staff/:id' do
	@res = dbconn.query("SELECT * FROM staff WHERE id = #{params[:id]};")

	haml :staff
end

# handle http POST request on staff
post '/staff' do
end

# handle http PUT request on staff
put '/staff' do

end

# handle http DELETE request on staff
delete '/staff' do

end

##### USER requests

# handle http GET request on user
get '/user' do
	@res = dbconn.query("SELECT * FROM users;");

	haml :users
end

#### endpoints for creating a new user
get '/user/new' do
	haml :newuser
end

# handle http POST request on user
post '/user' do

end

# handle http PUT request on user
put '/user' do

end

# handle http DELETE request on user
delete '/user' do

end
