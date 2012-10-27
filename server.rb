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
#require 'mysql'
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

# handle http GET request on customer
get '/cust' do
	@res = dbconn.query("SELECT * FROM Customers;");

	haml :customers
end

# handle http POST request on customer
post '/cust' do

end

# handle http PUT request on customer
put '/cust' do

end

# handle http DELETE request on customer
delete '/cust' do

end

# handle http GET request on event
get '/events' do
	#{}"Hello world"
	query = dbconn.query("SELECT id,name,details,DATE_FORMAT(date, '%d-%m-%y') AS date, time FROM Events;")
	query.each do |row|
		puts row["name"]
	end
	@res = query

	haml :index
end

# handle http GET request for one event
get '/events/:id' do
	@res = dbconn.query("SELECT id,name,details,DATE_FORMAT(date, '%d-%m-%y') AS date, time FROM Events WHERE id=#{params[:id]};")
	
	haml :eventview
end

# handle http POST request on event
post '/event' do
#get the name, details, date and time from body of request
	#request.body.rewind #incase the body has already been read
	#body = JSON.parse request.body.read
	#puts #{body["name"]}
end

get '/event/new' do
	haml :eventform
end

#handle http PUT request on event
put '/event' do

end

# handle http DELETE request on event
delete '/event' do

end

# handle http GET request on staff
get '/staff' do
	@res = dbconn.query("SELECT * FROM Staff;")

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
