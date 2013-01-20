# University Events Web Application
#
# Ruby RESTful server
# Dissertation Project 2012-13
# Not full REST
# 
# Implementing a server in Ruby using the principles of REST
# The server allows applications to manage/book events
#
# author: Laura McCormack

require 'sinatra'
require 'haml'
#require 'pg'
require 'mysql2'
require 'json'
require './config/MyConfig.rb'
require 'bcrypt'

#allow sessions and set session secret
enable :sessions
set :session_secret, MyConfig::SessionKey || 'too secret'

#set the format for all haml docs used
set :haml, :format => :html5

#set up connection to mysql database
dbconn = Mysql2::Client.new(:host => MyConfig::Host, :username => MyConfig::Username, :password => MyConfig::Password, :database => MyConfig::Database)
##### set up so that errors are caught and connection closed 
#conn = PG.connect( dbhost: '127.0.0.1', dbname: "unievents" )

before do
	@user = session[:email]
end

get '/' do
	#:haml index
	redirect to('/events')
end


# handle http GET request on events (show all events)
get '/events' do
	# select all the events from the database in order of date
	@res = dbconn.query("SELECT id,name,details,DATE_FORMAT(date, '%d-%m-%y') AS date, time FROM events WHERE date >= CURDATE() ORDER BY date;")

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

# new staff member
get '/staff/new' do
	haml :newstaff
end

# handle http POST request on staff
post '/staff' do
	# get the information from the form
	firstname = dbconn.escape(params[:firstname])
	lastname = dbconn.escape(params[:lastname])
	email = dbconn.escape(params[:email])
	dob = dbconn.escape(params[:dob])
	password = BCrypt::Password.create(dbconn.escape(params[:password]))

	#run the query unless a member with the same email exists already
	test = dbconn.query("SELECT * FROM staff WHERE email = '#{email}';")
	if(test.count == 0) #add staff member to db
		dbconn.query("INSERT INTO staff(firstname, lastname, email, dob,password) VALUES ('#{firstname}', '#{lastname}',#{email}','#{dob}','#{password}');")
		
	else
		#error staff with email already exists
	end

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

get '/user/:id' do
	@res = dbconn.query("SELECT * FROM users WHERE id = '#{:id}';")

	haml :users
end

# handle http POST request on user
post '/user' do
	# get the information from the form
	firstname = dbconn.escape(params[:firstname])
	lastname = dbconn.escape(params[:lastname])
	email = dbconn.escape(params[:email])
	dob = dbconn.escape(params[:dob])
	password = BCrypt::Password.create(dbconn.escape(params[:password]))

	#run the query unless a member with the same email exists already
	test = dbconn.query("SELECT * FROM staff WHERE email = '#{email}';")
	if(test.count == 0) #add staff member to db
		dbconn.query("INSERT INTO users(firstname, lastname, email, dob, password) VALUES ('#{firstname}', '#{lastname}',#{email}','#{dob}', '#{password}');")
		
	else
		#error user with email already exists
	end

end

##### Login Endpoints
get '/login' do
	haml :login
end

post '/login' do
	email = dbconn.escape(params[:email])
	password = BCrypt::Password.create(dbconn.escape(params[:email]))
	#check if email exists in DB
	pword = dbconn.query("SELECT password FROM users WHERE email = '#{email}';")

	if pword.count == 1 && password == pword[0]["password"]
		# check password against password given
		
		session[:email] = params[:email]
	else
		#user does not exist redirect to '/user/new'
	end
end
