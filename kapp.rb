require 'sinatra'#dependencies
require "sinatra/reloader" if development?
require 'twilio-ruby'

# this allows us to use session variables
# see below
enable :sessions # configuration
  
error 403 do
  "Access Forbidden"
end

def check_command_is_in_string body, commands
  commands.each do |command|
    # this will loop over each instance
    if body.include? command
      return true
    end
  end
  return false 
end   

# $thesecretcode = "Kulja Sim Sim"

time = Time.new #component of time
#time_now = time.strftime("%Y-%m-%d %H:%M:%S")
time_today = time.strftime("%A %B %d, %Y %H:%M")

get "/" do
  # "Hello World" # a string variable
  #redirect to('/about'), 303 OR
  #redirect "/about"
  empty_array = []
 
  evening_greetings = ["Good Evening","Such a lovely evening isn't it?"]
  morning_greeting = ["Good morning", "Such a bright sunny day isn't it?"]
  
  if time.hour >= 12
    if session["first_name"] 
     evening_greetings.sample + " " + session["first_name"]
    else
      evening_greetings.sample 
    end
  
    elsif time.hour<12
    if session["first_name"]
      morning_greeting.sample + " " + session["first_name"] 
    else
      morning_greeting.sample
    end
  end
end
  
get "/about" do
  session["visits"] ||=0 #set the session to 0 if it hasn't been set before
  session["visits"] = session["visits"] + 1 #adds one to the current value
  
  
  visits_string = "I can retrieve useful information from your phone </br>
  Total visits: " + session["visits"].to_s + "</br>" +
  "You have visited #{session["visits"]} times as of #{time_today}"
  
  if session["first_name"] && session["number"]
    "#{visits_string}  </br>
    Welcome #{session["first_name"]}. Your number is #{session['number']}."
  else 
    "#{visits_string}  </br>
     Welcome to the world"
  end
  
end
  
# get "/signup" do
#   "lorem ipsum dolor"
# end

get '/signup/:firstname/:number' do
  session[:firstname] = params[:firstname]
  session[:number] = params[:number]
  'Thanks for signing up, ' + params[:firstname].capitalize + '! Your number is ' + params[:number] + '.'
end

get "/incoming/sms" do
  403
end

get "/test/conversation/?:body?/?:from?" do # /?:param?/?:param? for unnamed parameters
session['body'] = params['body']
session['from'] = params['from']

def determine_response (body)
    body = body.downcase.strip
    no = "i didnt quite understand what you mean"
    array_of_lines = IO.readlines("jokes.txt")
    array_of_lines_b = IO.readlines("facts.txt")
    
    empty_array = []
    where = ["Pittsburgh","The City of Bridge","City of the 3 Rivers"]
    greetings = ["hi","Wadap","What's up"]
    
    what_commands = ["what", "help", "features", "functions", "actions"]
    
    

    if greetings.include? body
      return "hello friend" 
    elsif body.include? "who" or body.include? "facts" or body.include? "name"
      return "Hi! I'm Friday, An advanced AI. Here are some fun facts about my creator Karan Naik </br>" + 
      array_of_lines_b.sample
      #elsif body.include? "what" or body.include? "help" or body.include? "features" or body.include? "functions" or
      # "help"
      # "help me"
    elsif check_command_is_in_string body, what_commands
      # body.include? "actions"
      return "I can aanswer basic info about Karan Naik" 
    elsif body == "where" 
      return where.sample 
    elsif body == "why" 
      return "i have been made for a class project" 
    elsif body == "joke"
      return array_of_lines.sample
    else 
      return no 
    end
  end
  
  if params[:body].nil? && params[:from].nil? #doubt
  # if !params[:first_name][:number].nil?
  # if !params[:first_name][:number].empty?
  #if params[:first_name][:number].nil? #this absolutely doesn't work
     return "please enter your first name and number" 
  else
     return " #{session['body']}. Your phone number is #{params['from']}.<br/>" + 
     determine_response(params['body'])
  end 
end   

  # 403

 

get "/signup/?:thesecretcode?" do
  # session['first_name'] = params['first_name']
  # session['number'] = params['number']
  
  # $thesecretcode = "Kuljasimsim" #Bollywood joke haha
  
  # "Thank you #{session['first_name']}. Your phone number is #{params['number']}"
  
  if params[:thesecretcode].nil?
    return 403
  elsif params[:thesecretcode] == "Kuljasimsim"
    # return
    # "You've got the code now"
    erb :signup
    # <p> <%= my-variable %> </p>
  else return 403
  end
end

post "/signup" do
       if params[:first_name] != "" && params[:number] != ""
        "You'll be hearing from soon, stay put!"
       else 
        "Please fill in the required fields"      
        end
end

 