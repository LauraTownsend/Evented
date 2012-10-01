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


