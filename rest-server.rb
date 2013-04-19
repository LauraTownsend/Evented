# University Events Web Application
#
# Ruby RESTful server
# Dissertation Project 2012-13
# REST version
# 
# Implementing a server in Ruby using the principles of REST
# The server allows applications to manage/book events
#
# author: Laura McCormack

require 'sinatra'
require 'mysql2'
require 'json'
require './config/MyConfig.rb'
require 'bcrypt'
require './User.rb'
require 'sinatra/cross_origin'

	#fix for cross origin errors
	register Sinatra::CrossOrigin

	enable :cross_origin

	set :allow_headers, :any 

	#set up connection to mysql database
	dbconn = Mysql2::Client.new(:host => MyConfig::Host, :username => MyConfig::Username, :password => MyConfig::Password, :database => MyConfig::Database)


	# handle http GET request on events (show all events)
	get '/events' do
		# select all the events from the database in order of date and today or later
		res = dbconn.query("SELECT id,name,details,DATE_FORMAT(date, '%d-%m-%y') AS date, time FROM events WHERE date >= CURDATE() ORDER BY date;")
		res.to_a.to_json	
	end

	# handle http GET request for one event
	get '/events/:id' do
		# select the event with selected id
		res = dbconn.query("SELECT id,name,details,DATE_FORMAT(date, '%d-%m-%y') AS date, time FROM events WHERE id=#{params[:id]};")
		res.to_a.to_json
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
			dbconn.query("SELECT * FROM events WHERE name = '#{name}' AND details = '#{details}';").each do |row|
				redirect "/events/#{row["id"]}"
			end
		else
			redirect '/event/new'	
		end
	end

	# handle put request on event
	put '/event' do
		###### update the event with given id using form data
		test = dbconn.query("SELECT * FROM events WHERE id='#{id}';")
		if(test.count == 0)
			## event not found in db
		else
			name = dbconn.escape(params[:name])
			details = dbconn.escape(params[:details])
			date = dbconn.escape(params[:date])
			time = dbconn.escape(params[:time])
			##update event
			dbconn.query("UPDATE TABLE events SET name='#{name}'), details='#{details}', date='#{date}', time=#{time} WHERE id='#{:id}';")
		end
	end

	#handle delete request on event
	delete '/event' do
		query = dbconn.query("DELETE FROM events WHERE id ='#{id}';")
		#show page
	
	end

	# handle http GET request on staff
	get '/staff' do
		res = dbconn.query("SELECT * FROM staff;")
		res.to_a.to_json
	end

	# handle get reqest for one staff member
	get '/staff/:id' do
		res = dbconn.query("SELECT * FROM staff WHERE id = #{params[:id]};")
		res.to_a.to_json
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
			dbconn.query("INSERT INTO staff(firstname, lastname, email, dob,password) VALUES ('#{firstname}', '#{lastname}','#{email}','#{dob}','#{password}');")
		
		else
			#error staff with email already exists
		end

	end

	# handle put request on staff
	put '/staff' do
		# get the information from the form
		firstname = dbconn.escape(params[:firstname])
		lastname = dbconn.escape(params[:lastname])
		email = dbconn.escape(params[:email])
		dob = dbconn.escape(params[:dob])

		#run the query unless a member with the same email exists already
		test = dbconn.query("SELECT * FROM staff WHERE email = '#{email}';")
		if(test.count == 0) #staff does not exist already
			"error"
		else
			dbconn.query("UPDATE TABLE staff SET firstname = '#{firstname}', lastname='#{lastname}', email='#{email}', dob ='#{dob}' WHERE id='#{:id}';")
			#error staff with email already exists
		end
	end

	# handle delete request on staff 
	delete '/staff/:id' do
		query = dbconn.query("DELETE FROM staff WHERE id ='#{id}';")
	
	end

	##### USER requests

	# handle http GET request on user
	get '/user' do
		res = dbconn.query("SELECT * FROM users;");
		res.to_a.to_json
	end

	get '/user/:id' do
		res = dbconn.query("SELECT * FROM users WHERE id = '#{:id}';")
		res.to_a.to_json
	end

	# handle http POST request on user
	post '/user' do
		# get the information from the form
		firstname = dbconn.escape(params[:firstname])
		lastname = dbconn.escape(params[:lastname])
		email = dbconn.escape(params[:email])
		dob = dbconn.escape(params[:dob])

		#generate salt and hash for password
		salt = BCrypt::Engine.generate_salt
		password = BCrypt::Engine.hash_secret(dbconn.escape(params[:password]),salt)

		#run the query unless a member with the same email exists already
		test = dbconn.query("SELECT * FROM users WHERE email = '#{email}';")
		if(test.count == 0) #add staff member to db
			dbconn.query("INSERT INTO users(firstname, lastname, email, dob, password,salt) VALUES ('#{firstname}', '#{lastname}','#{email}','#{dob}', '#{password}','#{salt}');")
		else
			#error user with email already exists
			"error"
		end

	end

	#handle put request on user
	put '/user' do
	
		# get the information from the form
		firstname = dbconn.escape(params[:firstname])
		lastname = dbconn.escape(params[:lastname])
		email = dbconn.escape(params[:email])
		dob = dbconn.escape(params[:dob])
	
		#check password is correct
		##### make a seperate handler for password changes #####

		#update the database with the new values for the user
	end

	#handle delete request on user

	delete '/user/:id' do
		query = dbconn.query("DELETE FROM users WHERE id ='#{id}';")
	end

	##### Login Endpoints

	post '/login' do
		email = dbconn.escape(params[:email])
		password = dbconn.escape(params[:password])
		#check if email exists in DB
		query = dbconn.query("SELECT * FROM users WHERE email = '#{email}';")

		if query.count == 1
			# check password against password given
			query.each do |user|
				if user["password"] == BCrypt::Engine.hash_secret(password,user["salt"])
					user.to_a.to_json
				else
					##error
					"Incorrect email or password"	
				end
			end
		else
			#user does not exist redirect to '/user/new'
			"Incorrect email or password"
		end
	end
