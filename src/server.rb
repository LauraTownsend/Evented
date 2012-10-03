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

get '/' do
	:haml index
end

# handle http GET request on customer
get '/cust' do

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
get '/event' do

end

# handle http POST request on event
post '/event' do

end

#handle http PUT request on event
put '/event' do

end

# handle http DELETE request on event
delete '/event' do

end

# handle http GET request on staff
get '/staff' do
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
